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

    // ─────────────────────────────────────────────────────────────────── GET ──
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
        if (!"MANAGER".equals(userDAO.getRoleCodeByUserId(currentUser.getUserId()))) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        String action   = request.getParameter("action");
        TaskDAO taskDAO = new TaskDAO();
        Task task       = null;

        if ("edit".equals(action)) {
            String taskIdStr = request.getParameter("id");
            if (taskIdStr == null || taskIdStr.isEmpty()) {
                session.setAttribute("errorMessage", "ID công việc không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/manager/task/list");
                return;
            }
            try {
                task = taskDAO.getTaskById(Integer.parseInt(taskIdStr));
                if (task == null) throw new Exception();
            } catch (Exception e) {
                session.setAttribute("errorMessage", "Không tìm thấy công việc");
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

        int departmentId = currentUser.getDepartmentId();
        List<Users> teamMembers  = userDAO.getUsersByDepartment(departmentId);
        List<Users> salesForAssign = new ArrayList<>();
        for (Users u : teamMembers) {
            if (u.getUserId() != currentUser.getUserId()) salesForAssign.add(u);
        }

        List<Integer> existingDepIds = TaskDAO.parseDependencyIds(task.getDescription());

        request.setAttribute("task",             task);
        request.setAttribute("allUsers",         userDAO.getAllUsers());
        request.setAttribute("salesForAssign",   salesForAssign);
        request.setAttribute("leads",            new LeadDAO().getAllLeads());
        request.setAttribute("customers",        new CustomerDAO().getAllCustomers());
        request.setAttribute("opportunities",    new OpportunityDAO().getAllOpportunities());
        request.setAttribute("taskStatusValues", TaskStatus.values());
        request.setAttribute("priorityValues",   Priority.values());
        request.setAttribute("existingDepIds",   existingDepIds);
        request.setAttribute("existingDepTasks", existingDepIds.isEmpty()
                ? new ArrayList<>() : taskDAO.getTasksByIds(existingDepIds));
        request.setAttribute("cleanDescription", TaskDAO.getCleanDescription(task.getDescription()));

        request.setAttribute("ACTIVE_MENU",  "TASK_FORM");
        request.setAttribute("CONTENT_PAGE", "/view/manager/task/task-form.jsp");
        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp")
               .forward(request, response);
    }

    // ────────────────────────────────────────────────────────────────── POST ──
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
        UserDAO userDAO   = new UserDAO();
        if (!"MANAGER".equals(userDAO.getRoleCodeByUserId(currentUser.getUserId()))) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        String formAction = request.getParameter("formAction");
        String taskIdStr  = request.getParameter("taskId");

        String errorBase = "edit".equals(formAction) && taskIdStr != null && !taskIdStr.isEmpty()
                ? request.getContextPath() + "/manager/task/form?action=edit&id=" + taskIdStr.trim()
                : request.getContextPath() + "/manager/task/form?action=create";

        try {
            String title       = request.getParameter("title");
            String description = request.getParameter("description");
            String dueDateStr  = request.getParameter("dueDate");
            String priorityStr = request.getParameter("priority");

            // ── Validate title ──────────────────────────────────────────────
            if (title == null || title.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Tiêu đề không được để trống");
                response.sendRedirect(errorBase); return;
            }

            // ── Parse priority ──────────────────────────────────────────────
            int priority = Priority.MEDIUM.ordinal();
            if (priorityStr != null && !priorityStr.trim().isEmpty()) {
                try { priority = Priority.valueOf(priorityStr.trim().toUpperCase()).ordinal(); }
                catch (IllegalArgumentException ignored) {}
            }

            // ── Validate due date ───────────────────────────────────────────
            if (dueDateStr == null || dueDateStr.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Hạn chót không được để trống");
                response.sendRedirect(errorBase); return;
            }
            LocalDateTime dueDate;
            try { dueDate = LocalDateTime.parse(dueDateStr.trim() + "T23:59:59"); }
            catch (Exception e) {
                session.setAttribute("errorMessage", "Định dạng ngày không hợp lệ");
                response.sendRedirect(errorBase); return;
            }
            if ("create".equals(formAction) && dueDate.isBefore(LocalDateTime.now())) {
                session.setAttribute("errorMessage", "Hạn chót không được ở quá khứ");
                response.sendRedirect(errorBase); return;
            }

            // ── Parse related object ────────────────────────────────────────
            String  relatedType = null;
            Integer relatedId   = null;
            String  rawRelated  = request.getParameter("relatedId");
            if (rawRelated != null && !rawRelated.trim().isEmpty()) {
                String raw = rawRelated.trim();
                int us = raw.indexOf('_');
                if (us <= 0 || us >= raw.length() - 1) {
                    session.setAttribute("errorMessage", "Đối tượng liên kết không hợp lệ");
                    response.sendRedirect(errorBase); return;
                }
                String typeToken = raw.substring(0, us);
                switch (typeToken) {
                    case "LEAD":        relatedType = "LEAD";        break;
                    case "CUSTOMER":    relatedType = "CUSTOMER";    break;
                    case "OPPORTUNITY": relatedType = "OPPORTUNITY"; break;
                    default:
                        session.setAttribute("errorMessage", "Loại đối tượng không hợp lệ");
                        response.sendRedirect(errorBase); return;
                }
                try {
                    relatedId = Integer.parseInt(raw.substring(us + 1));
                    if (relatedId <= 0) throw new NumberFormatException();
                } catch (NumberFormatException e) {
                    session.setAttribute("errorMessage", "ID đối tượng không hợp lệ");
                    response.sendRedirect(errorBase); return;
                }
            }

            TaskDAO taskDAO = new TaskDAO();


            if ("create".equals(formAction)) {

                String assignType   = request.getParameter("assignType");
                List<Users> team    = userDAO.getUsersByDepartment(currentUser.getDepartmentId());
                List<Integer> mainIds    = new ArrayList<>();
                List<Integer> supportIds = new ArrayList<>();

                if ("GROUP".equals(assignType)) {
                    String[] groupArr = request.getParameterValues("assignedToGroup");
                    if (groupArr == null || groupArr.length == 0) {
                        session.setAttribute("errorMessage", "Chọn ít nhất một nhân viên cho nhóm");
                        response.sendRedirect(errorBase); return;
                    }
                    for (String s : groupArr) {
                        try {
                            int gId = Integer.parseInt(s.trim());
                            if (isInTeam(gId, team) && !mainIds.contains(gId)) mainIds.add(gId);
                        } catch (NumberFormatException ignored) {}
                    }
                    if (mainIds.size() < 2) {
                        session.setAttribute("errorMessage", "Nhóm cần ít nhất 2 người");
                        response.sendRedirect(errorBase); return;
                    }
                    String[] supportArr = request.getParameterValues("supportMembers");
                    if (supportArr != null) {
                        for (String s : supportArr) {
                            try {
                                int sId = Integer.parseInt(s.trim());
                                if (isInTeam(sId, team) && !mainIds.contains(sId)
                                        && !supportIds.contains(sId)) supportIds.add(sId);
                            } catch (NumberFormatException ignored) {}
                        }
                    }
                } else {
                    String aStr = request.getParameter("assignedTo");
                    if (aStr == null || aStr.trim().isEmpty()) {
                        session.setAttribute("errorMessage", "Chọn người được giao việc");
                        response.sendRedirect(errorBase); return;
                    }
                    try {
                        int aId = Integer.parseInt(aStr.trim());
                        if (userDAO.getUserById(aId) == null) throw new Exception();
                        mainIds.add(aId);
                    } catch (Exception e) {
                        session.setAttribute("errorMessage", "Người được giao không hợp lệ");
                        response.sendRedirect(errorBase); return;
                    }
                }

                // ── Insert task rows ─────────────────────────────────────
                int success = 0;
                String cleanDesc = description != null ? description.trim() : null;
                List<Integer> insertedIds = new ArrayList<>();

                for (int assigneeId : mainIds) {
                    Task t = new Task();
                    t.setTitle(title.trim());
                    t.setDescription(cleanDesc);
                    t.setAssignedTo(assigneeId);
                    t.setDueDate(dueDate);
                    t.setPriority(priority);
                    t.setStatus(TaskStatus.PENDING.ordinal());
                    t.setRelatedType(relatedType);
                    t.setRelatedId(relatedId);
                    t.setCreatedBy(currentUser.getUserId());
                    t.setReminderAt(dueDate.minusHours(24));
                    if (taskDAO.insertTask(t)) { success++; insertedIds.add(t.getTaskId()); }
                }

                if ("GROUP".equals(assignType) && insertedIds.size() >= 2) {
                    int groupId = insertedIds.get(0);
                    for (int tId : insertedIds) taskDAO.updateGroupTaskId(tId, groupId);
                }

                for (int sId : supportIds) {
                    Task t = new Task();
                    t.setTitle(title.trim());
                    t.setDescription("[Vai trò: Hỗ trợ]\n" + (cleanDesc != null ? cleanDesc : ""));
                    t.setAssignedTo(sId);
                    t.setDueDate(dueDate);
                    t.setPriority(priority);
                    t.setStatus(TaskStatus.PENDING.ordinal()); // ★ cũng là TODO
                    t.setRelatedType(relatedType);
                    t.setRelatedId(relatedId);
                    t.setCreatedBy(currentUser.getUserId());
                    t.setReminderAt(dueDate.minusHours(24));
                    taskDAO.insertTask(t);
                }

                if (success == 0) {
                    session.setAttribute("errorMessage", "Tạo công việc thất bại");
                    response.sendRedirect(errorBase); return;
                }

                // ── Auto-assign Lead/Customer nếu chưa có người phụ trách ──
                // FIX: gán assigned_to của Lead/Customer theo người nhận task đầu tiên
                if (relatedId != null && !mainIds.isEmpty()) {
                    int primary = mainIds.get(0);
                    if ("LEAD".equals(relatedType)) {
                        Lead lead = new LeadDAO().getLeadById(relatedId);
                        if (lead != null && lead.getAssignedTo() == null)
                            new LeadDAO().updateLeadAssignedTo(relatedId, primary);
                    } else if ("CUSTOMER".equals(relatedType)) {
                        Customer c = new CustomerDAO().getCustomerById(relatedId);
                        if (c != null && c.getOwnerId() == null)
                            new CustomerDAO().updateCustomerOwnerId(relatedId, primary);
                    }
                }

                String who = (mainIds.size() + supportIds.size()) > 1
                        ? (mainIds.size() + supportIds.size()) + " nhân viên" : "1 nhân viên";
                session.setAttribute("successMessage",
                    "Đã tạo công việc cho " + who + ". Trạng thái: Chờ xử lý — Sale xác nhận nhận việc sẽ chuyển sang Đang thực hiện.");
                response.sendRedirect(request.getContextPath() + "/manager/task/list?view=team");

            // ════════════════════════════════════════════════════════════════
            //  EDIT — status có thể chỉnh sửa thủ công bởi manager
            // ════════════════════════════════════════════════════════════════
            } else if ("edit".equals(formAction)) {

                if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
                    session.setAttribute("errorMessage", "ID không hợp lệ");
                    response.sendRedirect(request.getContextPath() + "/manager/task/list"); return;
                }
                int taskId;
                try { taskId = Integer.parseInt(taskIdStr.trim()); }
                catch (NumberFormatException e) {
                    session.setAttribute("errorMessage", "ID không hợp lệ");
                    response.sendRedirect(request.getContextPath() + "/manager/task/list"); return;
                }

                Task task = taskDAO.getTaskById(taskId);
                if (task == null) {
                    session.setAttribute("errorMessage", "Không tìm thấy công việc");
                    response.sendRedirect(request.getContextPath() + "/manager/task/list"); return;
                }

                // Assignee
                String aStr = request.getParameter("assignedTo");
                if (aStr == null || aStr.trim().isEmpty()) {
                    session.setAttribute("errorMessage", "Chọn người thực hiện");
                    response.sendRedirect(errorBase); return;
                }
                int assignedTo;
                try { assignedTo = Integer.parseInt(aStr.trim()); }
                catch (NumberFormatException e) {
                    session.setAttribute("errorMessage", "Người thực hiện không hợp lệ");
                    response.sendRedirect(errorBase); return;
                }
                if (userDAO.getUserById(assignedTo) == null) {
                    session.setAttribute("errorMessage", "Người thực hiện không tồn tại");
                    response.sendRedirect(errorBase); return;
                }

                // Status (edit mode: manager được phép thay đổi thủ công)
                String statusStr = request.getParameter("status");
                int status;
                try { status = TaskStatus.valueOf(statusStr).ordinal(); }
                catch (Exception e) {
                    session.setAttribute("errorMessage", "Trạng thái không hợp lệ");
                    response.sendRedirect(errorBase); return;
                }

                // Dependencies
                String depParam = request.getParameter("dependencyIds");
                List<Integer> depIds = new ArrayList<>();
                if (depParam != null && !depParam.trim().isEmpty()) {
                    for (String part : depParam.split(",")) {
                        try { depIds.add(Integer.parseInt(part.trim())); }
                        catch (NumberFormatException ignored) {}
                    }
                }
                String finalDesc = TaskDAO.setDependencyIds(
                        description != null ? description.trim() : "", depIds);

                task.setTitle(title.trim());
                task.setDescription(finalDesc);
                task.setAssignedTo(assignedTo);
                task.setDueDate(dueDate);
                task.setPriority(priority);
                task.setStatus(status);
                task.setRelatedType(relatedType);
                task.setRelatedId(relatedId);
                task.setReminderAt(dueDate.minusHours(24));

                if (taskDAO.updateTask(task)) {
                    session.setAttribute("successMessage", "Cập nhật công việc thành công");
                    response.sendRedirect(request.getContextPath() + "/manager/task/detail?id=" + taskId);
                } else {
                    session.setAttribute("errorMessage", "Cập nhật thất bại");
                    response.sendRedirect(errorBase);
                }

            } else {
                session.setAttribute("errorMessage", "Thao tác không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/manager/task/list");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            response.sendRedirect(errorBase);
        }
    }

    private boolean isInTeam(int userId, List<Users> team) {
        for (Users u : team) if (u.getUserId() == userId) return true;
        return false;
    }
}