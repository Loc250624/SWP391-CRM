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

        // FIX: Use getSession(false) — do not create a new session
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
            request.setAttribute("pageTitle",   "Chỉnh sửa Công việc");
            request.setAttribute("formAction",  "edit");
        } else {
            task = new Task();
            request.setAttribute("pageTitle",  "Tạo Công việc mới");
            request.setAttribute("formAction", "create");
        }

        List<Users> allUsers       = userDAO.getAllUsers();
        List<Lead> leads           = new LeadDAO().getAllLeads();
        List<Customer> customers   = new CustomerDAO().getAllCustomers();
        List<Opportunity> opps     = new OpportunityDAO().getAllOpportunities();

        // Pass current dependency IDs and tasks for edit form
        List<Integer> existingDepIds = TaskDAO.parseDependencyIds(task != null ? task.getDescription() : null);
        List<Task> existingDepTasks = existingDepIds.isEmpty()
                ? new ArrayList<>()
                : taskDAO.getTasksByIds(existingDepIds);

        request.setAttribute("task",             task);
        request.setAttribute("allUsers",         allUsers);
        request.setAttribute("leads",            leads);
        request.setAttribute("customers",        customers);
        request.setAttribute("opportunities",    opps);
        request.setAttribute("taskStatusValues", TaskStatus.values());
        request.setAttribute("priorityValues",   Priority.values());
        request.setAttribute("existingDepIds",   existingDepIds);
        request.setAttribute("existingDepTasks", existingDepTasks);
        request.setAttribute("cleanDescription", TaskDAO.getCleanDescription(task != null ? task.getDescription() : null));

        request.setAttribute("ACTIVE_MENU",  "TASK_FORM");
        request.setAttribute("CONTENT_PAGE", "/view/manager/task/task-form.jsp");
        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp").forward(request, response);
    }

    // ----------------------------------------------------------------- POST --
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // FIX: Use getSession(false)
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
        // FIX: Extract taskId early so validation redirects can include it for the edit form
        String taskIdStr  = request.getParameter("taskId");

        // Build the redirect URL that preserves form context on validation errors
        String errorRedirectBase;
        if ("edit".equals(formAction) && taskIdStr != null && !taskIdStr.isEmpty()) {
            errorRedirectBase = request.getContextPath()
                    + "/manager/task/form?action=edit&id=" + taskIdStr.trim();
        } else {
            errorRedirectBase = request.getContextPath() + "/manager/task/form?action=create";
        }

        try {
            String title        = request.getParameter("title");
            String description  = request.getParameter("description");
            String assignedToStr = request.getParameter("assignedTo");
            String dueDateStr   = request.getParameter("dueDate");
            String priority     = request.getParameter("priority");
            String status       = request.getParameter("status");
            String relatedType  = request.getParameter("relatedType");
            String relatedIdStr = request.getParameter("relatedId");

            // --- Required field validation ---
            if (title == null || title.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Tiêu đề công việc không được để trống");
                response.sendRedirect(errorRedirectBase);
                return;
            }

            if (assignedToStr == null || assignedToStr.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Vui lòng chọn người được giao việc");
                response.sendRedirect(errorRedirectBase);
                return;
            }

            int assignedTo;
            try {
                assignedTo = Integer.parseInt(assignedToStr.trim());
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Người được giao không hợp lệ");
                response.sendRedirect(errorRedirectBase);
                return;
            }

            // Validate assigned user exists
            Users assignedUser = userDAO.getUserById(assignedTo);
            if (assignedUser == null) {
                session.setAttribute("errorMessage", "Người được giao không tồn tại");
                response.sendRedirect(errorRedirectBase);
                return;
            }

            // Validate priority
            try {
                Priority.valueOf(priority);
            } catch (IllegalArgumentException | NullPointerException e) {
                session.setAttribute("errorMessage", "Mức độ ưu tiên không hợp lệ");
                response.sendRedirect(errorRedirectBase);
                return;
            }

            // Validate status
            try {
                TaskStatus.valueOf(status);
            } catch (IllegalArgumentException | NullPointerException e) {
                session.setAttribute("errorMessage", "Trạng thái không hợp lệ");
                response.sendRedirect(errorRedirectBase);
                return;
            }

            // Parse due date (required)
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

            // For create: due date must not be in the past
            if ("create".equals(formAction) && dueDate.isBefore(LocalDateTime.now())) {
                session.setAttribute("errorMessage", "Ngày hết hạn không được ở quá khứ");
                response.sendRedirect(errorRedirectBase);
                return;
            }

            // Parse optional related object
            Integer relatedId = null;
            if (relatedIdStr != null && !relatedIdStr.trim().isEmpty()) {
                try {
                    relatedId = Integer.parseInt(relatedIdStr.trim());
                } catch (NumberFormatException e) {
                    relatedId = null;
                }
            }
            // Normalize empty relatedType to null
            if (relatedType != null && relatedType.trim().isEmpty()) {
                relatedType = null;
            }

            TaskDAO taskDAO = new TaskDAO();

            if ("create".equals(formAction)) {
                Task task = new Task();
                task.setTitle(title.trim());
                task.setDescription(description != null ? description.trim() : null);
                task.setAssignedTo(assignedTo);
                task.setDueDate(dueDate);
                task.setPriority(priority);
                task.setStatus(status);
                task.setRelatedType(relatedType);
                task.setRelatedId(relatedId);
                task.setCreatedBy(currentUser.getUserId());
                task.setReminderAt(dueDate.minusHours(24));

                boolean success = taskDAO.insertTask(task);
                if (success) {
                    session.setAttribute("successMessage", "Tạo công việc thành công");
                    response.sendRedirect(request.getContextPath() + "/manager/task/list");
                } else {
                    session.setAttribute("errorMessage", "Tạo công việc thất bại");
                    response.sendRedirect(errorRedirectBase);
                }

            } else if ("edit".equals(formAction)) {
                if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
                    session.setAttribute("errorMessage", "ID công việc không hợp lệ");
                    response.sendRedirect(request.getContextPath() + "/manager/task/list");
                    return;
                }

                int taskId;
                try {
                    taskId = Integer.parseInt(taskIdStr.trim());
                } catch (NumberFormatException e) {
                    session.setAttribute("errorMessage", "ID công việc không hợp lệ");
                    response.sendRedirect(request.getContextPath() + "/manager/task/list");
                    return;
                }

                Task task = taskDAO.getTaskById(taskId);
                if (task == null) {
                    session.setAttribute("errorMessage", "Không tìm thấy công việc");
                    response.sendRedirect(request.getContextPath() + "/manager/task/list");
                    return;
                }

                // Build description with dependency prefix
                String depIdsParam = request.getParameter("dependencyIds");
                List<Integer> depIds = new ArrayList<>();
                if (depIdsParam != null && !depIdsParam.trim().isEmpty()) {
                    for (String part : depIdsParam.split(",")) {
                        try { depIds.add(Integer.parseInt(part.trim())); }
                        catch (NumberFormatException ignored) { }
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
}
