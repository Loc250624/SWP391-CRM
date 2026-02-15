package controller.manager;

import dao.TaskDAO;
import dao.UserDAO;
import dao.LeadDAO;
import dao.CustomerDAO;
import dao.OpportunityDAO;
import enums.Priority;
import enums.TaskStatus;
import enums.RelatedType;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Task;
import model.Users;
import model.Lead;
import model.Customer;
import model.Opportunity;

@WebServlet(name = "ManagerTaskFormServlet", urlPatterns = {"/manager/task/form"})
public class ManagerTaskFormServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");

        // Role checking
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

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
            if (taskIdStr != null && !taskIdStr.isEmpty()) {
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
            }
            request.setAttribute("pageTitle", "Chỉnh sửa Công việc");
            request.setAttribute("formAction", "edit");
        } else {
            task = new Task();
            request.setAttribute("pageTitle", "Tạo Công việc mới");
            request.setAttribute("formAction", "create");
        }

        // Get all users for assignment dropdown
        List<Users> allUsers = userDAO.getAllUsers();

        // Get leads, customers, opportunities for related objects
        LeadDAO leadDAO = new LeadDAO();
        CustomerDAO customerDAO = new CustomerDAO();
        OpportunityDAO opportunityDAO = new OpportunityDAO();

        List<Lead> leads = leadDAO.getAllLeads();
        List<Customer> customers = customerDAO.getAllCustomers();
        List<Opportunity> opportunities = opportunityDAO.getAllOpportunities();

        request.setAttribute("task", task);
        request.setAttribute("allUsers", allUsers);
        request.setAttribute("leads", leads);
        request.setAttribute("customers", customers);
        request.setAttribute("opportunities", opportunities);
        request.setAttribute("taskStatusValues", TaskStatus.values());
        request.setAttribute("priorityValues", Priority.values());

        request.setAttribute("ACTIVE_MENU", "TASK_LIST");
        request.setAttribute("CONTENT_PAGE", "/view/manager/task/task-create.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");

        // Role checking
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        UserDAO userDAO = new UserDAO();
        String roleCode = userDAO.getRoleCodeByUserId(currentUser.getUserId());

        if (!"MANAGER".equals(roleCode)) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        String formAction = request.getParameter("formAction");
        TaskDAO taskDAO = new TaskDAO();

        try {
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String assignedToStr = request.getParameter("assignedTo");
            String dueDateStr = request.getParameter("dueDate");
            String priority = request.getParameter("priority");
            String status = request.getParameter("status");
            String relatedType = request.getParameter("relatedType");
            String relatedIdStr = request.getParameter("relatedId");

            // Validation
            if (title == null || title.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Tiêu đề công việc không được để trống");
                response.sendRedirect(request.getContextPath() + "/manager/task/form?action=" + formAction);
                return;
            }

            if (assignedToStr == null || assignedToStr.isEmpty()) {
                session.setAttribute("errorMessage", "Vui lòng chọn người được giao việc");
                response.sendRedirect(request.getContextPath() + "/manager/task/form?action=" + formAction);
                return;
            }

            Integer assignedTo = Integer.parseInt(assignedToStr);

            // Validate assigned user exists
            Users assignedUser = userDAO.getUserById(assignedTo);
            if (assignedUser == null) {
                session.setAttribute("errorMessage", "Người được giao không tồn tại");
                response.sendRedirect(request.getContextPath() + "/manager/task/form?action=" + formAction);
                return;
            }

            // Parse due date
            LocalDateTime dueDate = null;
            if (dueDateStr != null && !dueDateStr.isEmpty()) {
                dueDate = LocalDateTime.parse(dueDateStr + "T23:59:59");

                // Validate due date not in the past (for create only)
                if ("create".equals(formAction) && dueDate.isBefore(LocalDateTime.now())) {
                    session.setAttribute("errorMessage", "Ngày hết hạn không được ở quá khứ");
                    response.sendRedirect(request.getContextPath() + "/manager/task/form?action=" + formAction);
                    return;
                }
            }

            // Validate enum values
            try {
                Priority.valueOf(priority);
            } catch (IllegalArgumentException e) {
                session.setAttribute("errorMessage", "Mức độ ưu tiên không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/manager/task/form?action=" + formAction);
                return;
            }

            try {
                TaskStatus.valueOf(status);
            } catch (IllegalArgumentException e) {
                session.setAttribute("errorMessage", "Trạng thái không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/manager/task/form?action=" + formAction);
                return;
            }

            // Parse related object
            Integer relatedId = null;
            if (relatedIdStr != null && !relatedIdStr.isEmpty()) {
                relatedId = Integer.parseInt(relatedIdStr);
            }

            if ("create".equals(formAction)) {
                // Create new task
                Task task = new Task();
                task.setTitle(title);
                task.setDescription(description);
                task.setAssignedTo(assignedTo);
                task.setDueDate(dueDate);
                task.setPriority(priority);
                task.setStatus(status);
                task.setRelatedType(relatedType);
                task.setRelatedId(relatedId);
                task.setCreatedBy(currentUser.getUserId());

                // Set reminder to 24 hours before due date
                if (dueDate != null) {
                    task.setReminderAt(dueDate.minusHours(24));
                }

                boolean success = taskDAO.insertTask(task);

                if (success) {
                    session.setAttribute("successMessage", "Tạo công việc thành công");
                    response.sendRedirect(request.getContextPath() + "/manager/task/list");
                } else {
                    session.setAttribute("errorMessage", "Tạo công việc thất bại");
                    response.sendRedirect(request.getContextPath() + "/manager/task/form?action=create");
                }

            } else if ("edit".equals(formAction)) {
                // Update existing task
                String taskIdStr = request.getParameter("taskId");
                if (taskIdStr == null || taskIdStr.isEmpty()) {
                    session.setAttribute("errorMessage", "ID công việc không hợp lệ");
                    response.sendRedirect(request.getContextPath() + "/manager/task/list");
                    return;
                }

                int taskId = Integer.parseInt(taskIdStr);
                Task task = taskDAO.getTaskById(taskId);

                if (task == null) {
                    session.setAttribute("errorMessage", "Không tìm thấy công việc");
                    response.sendRedirect(request.getContextPath() + "/manager/task/list");
                    return;
                }

                task.setTitle(title);
                task.setDescription(description);
                task.setAssignedTo(assignedTo);
                task.setDueDate(dueDate);
                task.setPriority(priority);
                task.setStatus(status);
                task.setRelatedType(relatedType);
                task.setRelatedId(relatedId);

                // Set reminder to 24 hours before due date
                if (dueDate != null) {
                    task.setReminderAt(dueDate.minusHours(24));
                }

                boolean success = taskDAO.updateTask(task);

                if (success) {
                    session.setAttribute("successMessage", "Cập nhật công việc thành công");
                    response.sendRedirect(request.getContextPath() + "/manager/task/detail?id=" + taskId);
                } else {
                    session.setAttribute("errorMessage", "Cập nhật công việc thất bại");
                    response.sendRedirect(request.getContextPath() + "/manager/task/form?action=edit&id=" + taskId);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/manager/task/list");
        }
    }
}
