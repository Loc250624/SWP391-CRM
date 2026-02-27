package controller.manager;

import dao.CustomerDAO;
import dao.LeadDAO;
import dao.OpportunityDAO;
import dao.TaskDAO;
import dao.UserDAO;
import enums.Priority;
import enums.TaskStatus;
import java.io.IOException;
import java.time.LocalDateTime;
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
import model.Opportunity;
import model.Task;
import model.Users;

@WebServlet(name = "ManagerTaskFormServlet", urlPatterns = {"/manager/task/form"})
public class ManagerTaskFormServlet extends HttpServlet {

    // ------------------------------------------------------------------ GET --
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Users currentUser = (Users) session.getAttribute("user");
        UserDAO userDAO = new UserDAO();
        String roleCode = userDAO.getRoleCodeByUserId(currentUser.getUserId());

        if (!"MANAGER".equals(roleCode)) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        String action = request.getParameter("action");
        TaskDAO taskDAO = new TaskDAO();
        Task task = null;

        if ("edit".equals(action)) {
            String taskIdStr = request.getParameter("id");
            if (taskIdStr == null || taskIdStr.isEmpty()) {
                session.setAttribute("errorMessage", "ID công việc không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/manager/task/list");
                return;
            }
            try {
                int taskId = Integer.parseInt(taskIdStr);
                task = taskDAO.getTaskById(taskId);
                if (task == null) {
                    session.setAttribute("errorMessage", "Không tìm thấy công việc");
                    response.sendRedirect(request.getContextPath() + "/manager/task/list");
                    return;
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "ID công việc không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/manager/task/list");
                return;
            }
            request.setAttribute("pageTitle",  "Chỉnh sửa Công việc");
            request.setAttribute("formAction", "edit");
        } else {
            task = new Task();
            request.setAttribute("pageTitle",  "Tạo Công việc mới");
            request.setAttribute("formAction", "create");
        }

        // Team members for group assignment section (create mode)
        int departmentId = currentUser.getDepartmentId();
        List<Users> teamMembers = userDAO.getUsersByDepartment(departmentId);
        List<Users> salesForAssign = new ArrayList<>();
        for (Users u : teamMembers) {
            if (u.getUserId() != currentUser.getUserId()) salesForAssign.add(u);
        }

        List<Users> allUsers     = userDAO.getAllUsers();
        List<Lead> leads         = new LeadDAO().getAllLeads();
        List<Customer> customers = new CustomerDAO().getAllCustomers();
        List<Opportunity> opps   = new OpportunityDAO().getAllOpportunities();

        List<Integer> existingDepIds = TaskDAO.parseDependencyIds(task.getDescription());
        List<Task> existingDepTasks = existingDepIds.isEmpty()
                ? new ArrayList<>()
                : taskDAO.getTasksByIds(existingDepIds);

        request.setAttribute("task",             task);
        request.setAttribute("allUsers",         allUsers);
        request.setAttribute("salesForAssign",   salesForAssign);
        request.setAttribute("leads",            leads);
        request.setAttribute("customers",        customers);
        request.setAttribute("opportunities",    opps);
        request.setAttribute("taskStatusValues", TaskStatus.values());
        request.setAttribute("priorityValues",   Priority.values());
        request.setAttribute("existingDepIds",   existingDepIds);
        request.setAttribute("existingDepTasks", existingDepTasks);
        request.setAttribute("cleanDescription", TaskDAO.getCleanDescription(task.getDescription()));

        request.setAttribute("ACTIVE_MENU",  "TASK_FORM");
        request.setAttribute("CONTENT_PAGE", "/view/manager/task/task-form.jsp");
        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp").forward(request, response);
    }

    // ----------------------------------------------------------------- POST --
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
        String roleCode = userDAO.getRoleCodeByUserId(currentUser.getUserId());

        if (!"MANAGER".equals(roleCode)) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        String formAction = request.getParameter("formAction");
        String taskIdStr  = request.getParameter("taskId");

        String errorRedirectBase;
        if ("edit".equals(formAction) && taskIdStr != null && !taskIdStr.isEmpty()) {
            errorRedirectBase = request.getContextPath()
                    + "/manager/task/form?action=edit&id=" + taskIdStr.trim();
        } else {
            errorRedirectBase = request.getContextPath() + "/manager/task/form?action=create";
        }

        try {
            String title       = request.getParameter("title");
            String description = request.getParameter("description");
            String dueDateStr  = request.getParameter("dueDate");
            String priority    = request.getParameter("priority");
            String rawRelated  = request.getParameter("relatedId");  // e.g. "CUSTOMER_45"

            // ── Required field validation ────────────────────────────────────
            if (title == null || title.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Tiêu đề công việc không được để trống");
                response.sendRedirect(errorRedirectBase);
                return;
            }

            try { Priority.valueOf(priority); }
            catch (IllegalArgumentException | NullPointerException e) {
                session.setAttribute("errorMessage", "Mức độ ưu tiên không hợp lệ");
                response.sendRedirect(errorRedirectBase);
                return;
            }

            if (dueDateStr == null || dueDateStr.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Hạn chót không được để trống");
                response.sendRedirect(errorRedirectBase);
                return;
            }

            LocalDateTime dueDate;
            try {
                // HTML date input gives YYYY-MM-DD; append end-of-day time
                dueDate = LocalDateTime.parse(dueDateStr.trim() + "T23:59:59");
            } catch (Exception e) {
                session.setAttribute("errorMessage", "Định dạng ngày hết hạn không hợp lệ");
                response.sendRedirect(errorRedirectBase);
                return;
            }

            if ("create".equals(formAction) && dueDate.isBefore(LocalDateTime.now())) {
                session.setAttribute("errorMessage", "Ngày hết hạn không được ở quá khứ");
                response.sendRedirect(errorRedirectBase);
                return;
            }

            // ── Parse related object (composite: "LEAD_123", "CUSTOMER_45", etc.) ──
            // relatedType is stored in UPPERCASE for consistency with CRM Pool queries
            String  relatedType = null;
            Integer relatedId   = null;

            if (rawRelated != null && !rawRelated.trim().isEmpty()) {
                String raw = rawRelated.trim();
                int underscore = raw.indexOf('_');
                if (underscore <= 0 || underscore >= raw.length() - 1) {
                    session.setAttribute("errorMessage", "Đối tượng liên kết không hợp lệ");
                    response.sendRedirect(errorRedirectBase);
                    return;
                }
                String typeToken = raw.substring(0, underscore);
                String idPart    = raw.substring(underscore + 1);

                switch (typeToken) {
                    case "LEAD":        relatedType = "LEAD";        break;
                    case "CUSTOMER":    relatedType = "CUSTOMER";    break;
                    case "OPPORTUNITY": relatedType = "OPPORTUNITY"; break;
                    default:
                        session.setAttribute("errorMessage", "Loại đối tượng liên kết không hợp lệ");
                        response.sendRedirect(errorRedirectBase);
                        return;
                }

                try {
                    relatedId = Integer.parseInt(idPart);
                    if (relatedId <= 0) throw new NumberFormatException("non-positive");
                } catch (NumberFormatException e) {
                    session.setAttribute("errorMessage", "ID đối tượng liên kết không hợp lệ");
                    response.sendRedirect(errorRedirectBase);
                    return;
                }

                // Validate the referenced object exists
                switch (typeToken) {
                    case "LEAD":
                        if (new LeadDAO().getLeadById(relatedId) == null) {
                            session.setAttribute("errorMessage", "Lead được chọn không tồn tại");
                            response.sendRedirect(errorRedirectBase); return;
                        }
                        break;
                    case "CUSTOMER":
                        if (new CustomerDAO().getCustomerById(relatedId) == null) {
                            session.setAttribute("errorMessage", "Khách hàng được chọn không tồn tại");
                            response.sendRedirect(errorRedirectBase); return;
                        }
                        break;
                    case "OPPORTUNITY":
                        if (new OpportunityDAO().getOpportunityById(relatedId) == null) {
                            session.setAttribute("errorMessage", "Cơ hội được chọn không tồn tại");
                            response.sendRedirect(errorRedirectBase); return;
                        }
                        break;
                }
            }

            TaskDAO taskDAO = new TaskDAO();

            // ════════════════════════════════════════════════════════════════
            //  CREATE
            // ════════════════════════════════════════════════════════════════
            if ("create".equals(formAction)) {

                // ── Resolve assignees ──────────────────────────────────────
                String assignType = request.getParameter("assignType");
                int departmentId  = currentUser.getDepartmentId();
                List<Users> teamMembers = userDAO.getUsersByDepartment(departmentId);

                List<Integer> mainIds    = new ArrayList<>();
                List<Integer> supportIds = new ArrayList<>();

                if ("GROUP".equals(assignType)) {
                    // Main group members
                    String[] groupArr = request.getParameterValues("assignedToGroup");
                    if (groupArr == null || groupArr.length == 0) {
                        session.setAttribute("errorMessage", "Vui lòng chọn ít nhất một nhân viên cho nhóm");
                        response.sendRedirect(errorRedirectBase); return;
                    }
                    for (String gIdStr : groupArr) {
                        try {
                            int gId = Integer.parseInt(gIdStr.trim());
                            if (isTeamMember(gId, teamMembers) && !mainIds.contains(gId))
                                mainIds.add(gId);
                        } catch (NumberFormatException ignored) {}
                    }
                    if (mainIds.isEmpty()) {
                        session.setAttribute("errorMessage", "Không có nhân viên hợp lệ trong danh sách nhóm");
                        response.sendRedirect(errorRedirectBase); return;
                    }
                    if (mainIds.size() < 2) {
        session.setAttribute("errorMessage", "Giao việc nhóm cần ít nhất 2 người");
        response.sendRedirect(errorRedirectBase); return;
    }

                    // Optional support members (must be in team, not already in mainIds)
                    String[] supportArr = request.getParameterValues("supportMembers");
                    if (supportArr != null) {
                        for (String sIdStr : supportArr) {
                            try {
                                int sId = Integer.parseInt(sIdStr.trim());
                                if (isTeamMember(sId, teamMembers) && !mainIds.contains(sId) && !supportIds.contains(sId))
                                    supportIds.add(sId);
                            } catch (NumberFormatException ignored) {}
                        }
                    }

                } else {
                    // INDIVIDUAL (default)
                    String assignedToStr = request.getParameter("assignedTo");
                    if (assignedToStr == null || assignedToStr.trim().isEmpty()) {
                        session.setAttribute("errorMessage", "Vui lòng chọn người được giao việc");
                        response.sendRedirect(errorRedirectBase); return;
                    }
                    try {
                        int aId = Integer.parseInt(assignedToStr.trim());
                        if (userDAO.getUserById(aId) == null) {
                            session.setAttribute("errorMessage", "Người được giao không tồn tại");
                            response.sendRedirect(errorRedirectBase); return;
                        }
                        mainIds.add(aId);
                    } catch (NumberFormatException e) {
                        session.setAttribute("errorMessage", "Người được giao không hợp lệ");
                        response.sendRedirect(errorRedirectBase); return;
                    }
                }

                // ── Create one task per main assignee ─────────────────────
                int successCount = 0;
                String cleanDesc = description != null ? description.trim() : null;

                for (int assigneeId : mainIds) {
                    Task task = new Task();
                    task.setTitle(title.trim());
                    task.setDescription(cleanDesc);
                    task.setAssignedTo(assigneeId);
                    task.setDueDate(dueDate);
                    task.setPriority(priority);
                    task.setStatus(TaskStatus.IN_PROGRESS.name());  // always IN_PROGRESS
                    task.setRelatedType(relatedType);
                    task.setRelatedId(relatedId);
                    task.setCreatedBy(currentUser.getUserId());
                    task.setReminderAt(dueDate.minusHours(24));
                    if (taskDAO.insertTask(task)) successCount++;
                }

                // ── Create support-member tasks (cloned with note in desc) ─
                for (int sId : supportIds) {
                    String supportDesc = "[Vai trò: Hỗ trợ]\n" + (cleanDesc != null ? cleanDesc : "");
                    Task task = new Task();
                    task.setTitle(title.trim());
                    task.setDescription(supportDesc.trim());
                    task.setAssignedTo(sId);
                    task.setDueDate(dueDate);
                    task.setPriority(priority);
                    task.setStatus(TaskStatus.IN_PROGRESS.name());
                    task.setRelatedType(relatedType);
                    task.setRelatedId(relatedId);
                    task.setCreatedBy(currentUser.getUserId());
                    task.setReminderAt(dueDate.minusHours(24));
                    taskDAO.insertTask(task);  // best-effort; support tasks don't count toward successCount
                }

                if (successCount == 0) {
                    session.setAttribute("errorMessage", "Tạo công việc thất bại, vui lòng thử lại");
                    response.sendRedirect(errorRedirectBase); return;
                }

                // ── Update Lead/Customer assignment if currently unassigned ─
                if (relatedId != null && !mainIds.isEmpty()) {
                    int primaryAssignee = mainIds.get(0);
                    if ("LEAD".equals(relatedType)) {
                        Lead lead = new LeadDAO().getLeadById(relatedId);
                        if (lead != null && lead.getAssignedTo() == null) {
                            new LeadDAO().updateLeadAssignedTo(relatedId, primaryAssignee);
                        }
                    } else if ("CUSTOMER".equals(relatedType)) {
                        Customer cust = new CustomerDAO().getCustomerById(relatedId);
                        if (cust != null && cust.getOwnerId() == null) {
                            new CustomerDAO().updateCustomerOwnerId(relatedId, primaryAssignee);
                        }
                    }
                }

                int totalAssigned = mainIds.size() + supportIds.size();
                String who = totalAssigned > 1 ? totalAssigned + " nhân viên" : "1 nhân viên";
                session.setAttribute("successMessage", "Tạo công việc thành công cho " + who);
                response.sendRedirect(request.getContextPath() + "/manager/task/list");

            // ════════════════════════════════════════════════════════════════
            //  EDIT  (single assignee, status editable)
            // ════════════════════════════════════════════════════════════════
            } else if ("edit".equals(formAction)) {

                if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
                    session.setAttribute("errorMessage", "ID công việc không hợp lệ");
                    response.sendRedirect(request.getContextPath() + "/manager/task/list"); return;
                }

                int taskId;
                try { taskId = Integer.parseInt(taskIdStr.trim()); }
                catch (NumberFormatException e) {
                    session.setAttribute("errorMessage", "ID công việc không hợp lệ");
                    response.sendRedirect(request.getContextPath() + "/manager/task/list"); return;
                }

                Task task = taskDAO.getTaskById(taskId);
                if (task == null) {
                    session.setAttribute("errorMessage", "Không tìm thấy công việc");
                    response.sendRedirect(request.getContextPath() + "/manager/task/list"); return;
                }

                // Single assignee for edit
                String assignedToStr = request.getParameter("assignedTo");
                if (assignedToStr == null || assignedToStr.trim().isEmpty()) {
                    session.setAttribute("errorMessage", "Vui lòng chọn người được giao việc");
                    response.sendRedirect(errorRedirectBase); return;
                }
                int assignedTo;
                try { assignedTo = Integer.parseInt(assignedToStr.trim()); }
                catch (NumberFormatException e) {
                    session.setAttribute("errorMessage", "Người được giao không hợp lệ");
                    response.sendRedirect(errorRedirectBase); return;
                }
                if (userDAO.getUserById(assignedTo) == null) {
                    session.setAttribute("errorMessage", "Người được giao không tồn tại");
                    response.sendRedirect(errorRedirectBase); return;
                }

                // Status is editable for edit mode
                String status = request.getParameter("status");
                try { TaskStatus.valueOf(status); }
                catch (IllegalArgumentException | NullPointerException e) {
                    session.setAttribute("errorMessage", "Trạng thái không hợp lệ");
                    response.sendRedirect(errorRedirectBase); return;
                }

                // Preserve dependency metadata
                String depIdsParam = request.getParameter("dependencyIds");
                List<Integer> depIds = new ArrayList<>();
                if (depIdsParam != null && !depIdsParam.trim().isEmpty()) {
                    for (String part : depIdsParam.split(",")) {
                        try { depIds.add(Integer.parseInt(part.trim())); }
                        catch (NumberFormatException ignored) {}
                    }
                }
                String finalDescription = TaskDAO.setDependencyIds(
                        description != null ? description.trim() : "", depIds);

                task.setTitle(title.trim());
                task.setDescription(finalDescription);
                task.setAssignedTo(assignedTo);
                task.setDueDate(dueDate);
                task.setPriority(priority);
                task.setStatus(status);
                task.setRelatedType(relatedType);
                task.setRelatedId(relatedId);
                task.setReminderAt(dueDate.minusHours(24));

                boolean success = taskDAO.updateTask(task);
                if (success) {
                    session.setAttribute("successMessage", "Cập nhật công việc thành công");
                    response.sendRedirect(request.getContextPath() + "/manager/task/detail?id=" + taskId);
                } else {
                    session.setAttribute("errorMessage", "Cập nhật công việc thất bại");
                    response.sendRedirect(errorRedirectBase);
                }

            } else {
                session.setAttribute("errorMessage", "Thao tác không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/manager/task/list");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            response.sendRedirect(errorRedirectBase);
        }
    }

    /** Returns true if the given userId belongs to any user in the team list. */
    private boolean isTeamMember(int userId, List<Users> teamMembers) {
        for (Users u : teamMembers) {
            if (u.getUserId() == userId) return true;
        }
        return false;
    }
}
