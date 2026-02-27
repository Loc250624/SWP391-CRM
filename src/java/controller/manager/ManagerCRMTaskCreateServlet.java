package controller.manager;

import dao.CustomerDAO;
import dao.LeadDAO;
import dao.TaskDAO;
import dao.UserDAO;
import enums.Priority;
import enums.TaskStatus;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Customer;
import model.Lead;
import model.Task;
import model.Users;

@WebServlet(name = "ManagerCRMTaskCreateServlet", urlPatterns = {"/manager/crm/assign-task"})
public class ManagerCRMTaskCreateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Users currentUser = (Users) session.getAttribute("user");
        UserDAO userDAO = new UserDAO();

        if (!"MANAGER".equals(userDAO.getRoleCodeByUserId(currentUser.getUserId()))) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        // ── Read common form fields ────────────────────────────────────────
        String relatedType  = request.getParameter("relatedType");
        String relatedIdStr = request.getParameter("relatedId");
        String title        = request.getParameter("title");
        String description  = request.getParameter("description");
        String assignType   = request.getParameter("assignType");  // "INDIVIDUAL" or "GROUP"
        String priorityStr  = request.getParameter("priority");
        String dueDateStr   = request.getParameter("dueDate");
        String returnUrl    = request.getParameter("returnUrl");

        String defaultReturn = request.getContextPath() + "/manager/crm/pool";
        String redirectTo = (returnUrl != null && !returnUrl.trim().isEmpty())
                            ? returnUrl : defaultReturn;

        // ── Basic validation ───────────────────────────────────────────────
        if (!"LEAD".equals(relatedType) && !"CUSTOMER".equals(relatedType)) {
            session.setAttribute("errorMessage", "Loại đối tượng không hợp lệ");
            response.sendRedirect(redirectTo); return;
        }
        if (title == null || title.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Tiêu đề không được để trống");
            response.sendRedirect(redirectTo); return;
        }

        int relatedId;
        try {
            relatedId = Integer.parseInt(relatedIdStr);
        } catch (NumberFormatException | NullPointerException e) {
            session.setAttribute("errorMessage", "ID đối tượng không hợp lệ");
            response.sendRedirect(redirectTo); return;
        }

        int departmentId = currentUser.getDepartmentId();
        List<Users> teamMembers = userDAO.getUsersByDepartment(departmentId);

        // ── Validate Lead/Customer: exists, in scope, not already assigned ─
        LeadDAO     leadDAO     = new LeadDAO();
        CustomerDAO customerDAO = new CustomerDAO();

        if ("LEAD".equals(relatedType)) {
            Lead lead = leadDAO.getLeadById(relatedId);
            if (lead == null) {
                session.setAttribute("errorMessage", "Không tìm thấy Lead");
                response.sendRedirect(redirectTo); return;
            }
            if (lead.getAssignedTo() != null) {
                session.setAttribute("errorMessage", "Lead này đã được giao rồi, không thể giao lại");
                response.sendRedirect(redirectTo); return;
            }
            if (!isInDeptScope(lead.getCreatedBy(), currentUser.getUserId(), teamMembers)) {
                session.setAttribute("errorMessage", "Lead này không thuộc phạm vi quản lý của bạn");
                response.sendRedirect(redirectTo); return;
            }
        } else {
            Customer customer = customerDAO.getCustomerById(relatedId);
            if (customer == null) {
                session.setAttribute("errorMessage", "Không tìm thấy Khách hàng");
                response.sendRedirect(redirectTo); return;
            }
            if (customer.getOwnerId() != null) {
                session.setAttribute("errorMessage", "Khách hàng này đã được giao rồi, không thể giao lại");
                response.sendRedirect(redirectTo); return;
            }
            if (!isInDeptScope(customer.getCreatedBy(), currentUser.getUserId(), teamMembers)) {
                session.setAttribute("errorMessage", "Khách hàng này không thuộc phạm vi quản lý của bạn");
                response.sendRedirect(redirectTo); return;
            }
        }

        // ── Parse priority and due date ────────────────────────────────────
        String priority = Priority.MEDIUM.name();
        if (priorityStr != null && !priorityStr.trim().isEmpty()) {
            try { priority = Priority.valueOf(priorityStr.trim().toUpperCase()).name(); }
            catch (IllegalArgumentException ignored) {}
        }

        LocalDateTime dueDate = parseDueDate(dueDateStr);

        // ── Resolve assignee list ──────────────────────────────────────────
        List<Integer> assigneeIds = new ArrayList<>();

        if ("GROUP".equals(assignType)) {
            String[] groupArr = request.getParameterValues("assignedToGroup");
            if (groupArr == null || groupArr.length == 0) {
                session.setAttribute("errorMessage", "Vui lòng chọn ít nhất một nhân viên cho nhóm");
                response.sendRedirect(redirectTo); return;
            }
            for (String gIdStr : groupArr) {
                try {
                    int gId = Integer.parseInt(gIdStr.trim());
                    if (isValidAssignee(gId, currentUser.getUserId(), teamMembers)) {
                        assigneeIds.add(gId);
                    }
                } catch (NumberFormatException ignored) {}
            }
            if (assigneeIds.isEmpty()) {
                session.setAttribute("errorMessage", "Không có nhân viên hợp lệ trong danh sách nhóm");
                response.sendRedirect(redirectTo); return;
            }
            if (assigneeIds.size() < 2) {
                session.setAttribute("errorMessage", "Giao việc nhóm cần ít nhất 2 người");
                response.sendRedirect(redirectTo); return;
            }
        } else {
            // INDIVIDUAL (default)
            String assignedToStr = request.getParameter("assignedTo");
            if (assignedToStr == null || assignedToStr.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Vui lòng chọn nhân viên được giao việc");
                response.sendRedirect(redirectTo); return;
            }
            try {
                int aId = Integer.parseInt(assignedToStr.trim());
                if (!isValidAssignee(aId, currentUser.getUserId(), teamMembers)) {
                    session.setAttribute("errorMessage", "Nhân viên không thuộc phòng ban của bạn");
                    response.sendRedirect(redirectTo); return;
                }
                assigneeIds.add(aId);
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Người được giao không hợp lệ");
                response.sendRedirect(redirectTo); return;
            }
        }

        // ── Create one Task per assignee (cloning for group) ──────────────
        TaskDAO taskDAO = new TaskDAO();
        int successCount = 0;
        List<Integer> insertedTaskIds = new ArrayList<>();

        for (int assigneeId : assigneeIds) {
            Task task = new Task();
            task.setTitle(title.trim());
            task.setDescription(description != null ? description.trim() : null);
            task.setRelatedType(relatedType);
            task.setRelatedId(relatedId);
            task.setAssignedTo(assigneeId);
            task.setPriority(priority);
            task.setStatus(TaskStatus.IN_PROGRESS.name());  // always IN_PROGRESS
            task.setDueDate(dueDate);
            task.setCreatedBy(currentUser.getUserId());

            if (taskDAO.insertTask(task)) {
                successCount++;
                insertedTaskIds.add(task.getTaskId());
            }
        }

        // ── Link group task rows via group_task_id (first task is representative) ──
        if ("GROUP".equals(assignType) && insertedTaskIds.size() >= 2) {
            int groupTaskId = insertedTaskIds.get(0);
            for (int tId : insertedTaskIds) {
                taskDAO.updateGroupTaskId(tId, groupTaskId);
            }
        }

        if (successCount == 0) {
            session.setAttribute("errorMessage", "Giao việc thất bại, vui lòng thử lại");
            response.sendRedirect(redirectTo); return;
        }

        // ── Mark Lead/Customer as assigned (disappears from CRM Pool) ─────
        // Use the first assignee as the primary responsible person
        int primaryAssignee = assigneeIds.get(0);

        if ("LEAD".equals(relatedType)) {
            leadDAO.updateLeadAssignedTo(relatedId, primaryAssignee);
        } else {
            customerDAO.updateCustomerOwnerId(relatedId, primaryAssignee);
        }

        // Build success message
        String who = "GROUP".equals(assignType) && assigneeIds.size() > 1
                ? successCount + " nhân viên (nhóm)"
                : "1 nhân viên";
        session.setAttribute("successMessage",
                "Đã giao việc thành công cho " + who + ". Đối tượng đã chuyển sang quản lý task.");

        response.sendRedirect(redirectTo);
    }

    // ── Helpers ────────────────────────────────────────────────────────────

    /** True if the given userId is in the manager's team or is the manager themselves. */
    private boolean isValidAssignee(int userId, int managerId, List<Users> teamMembers) {
        if (userId == managerId) return true;
        for (Users u : teamMembers) {
            if (u.getUserId() == userId) return true;
        }
        return false;
    }

    /** True if createdBy belongs to the manager's department (scope check for unassigned items). */
    private boolean isInDeptScope(Integer createdBy, int managerId, List<Users> teamMembers) {
        if (createdBy == null) return false;
        if (createdBy == managerId) return true;
        for (Users u : teamMembers) {
            if (createdBy.equals(u.getUserId())) return true;
        }
        return false;
    }

    /** Parse a datetime-local string. Tries "HH:mm" format first, then "HH:mm:ss". */
    private LocalDateTime parseDueDate(String raw) {
        if (raw == null || raw.trim().isEmpty()) return null;
        try {
            return LocalDateTime.parse(raw.trim(),
                    DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
        } catch (DateTimeParseException e) {
            try {
                return LocalDateTime.parse(raw.trim(),
                        DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss"));
            } catch (DateTimeParseException e2) {
                return null;
            }
        }
    }
}
