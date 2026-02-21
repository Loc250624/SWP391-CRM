package controller.customersuccess;

import dao.TaskDAO;
import dao.UserDAO;
import enums.TaskStatus;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Task;
import model.Users;

@WebServlet(name = "SupportTaskStatusServlet", urlPatterns = {"/support/task/status"})
public class SupportTaskStatusServlet extends HttpServlet {

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

        if (!"SUPPORT".equals(roleCode)) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        String taskIdStr = request.getParameter("id");
        if (taskIdStr == null || taskIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/support/task/list");
            return;
        }

        try {
            int taskId = Integer.parseInt(taskIdStr);
            TaskDAO taskDAO = new TaskDAO();
            Task task = taskDAO.getTaskById(taskId);

            if (task == null || task.getAssignedTo() == null
                    || task.getAssignedTo() != currentUser.getUserId()) {
                session.setAttribute("errorMessage", "Không thể cập nhật công việc này");
                response.sendRedirect(request.getContextPath() + "/support/task/list");
                return;
            }

            request.setAttribute("task", task);
            request.setAttribute("taskStatusValues", TaskStatus.values());
            request.setAttribute("pageTitle", "Cập nhật Trạng thái");
            request.setAttribute("contentPage", "/view/support/task/task-status.jsp");
            request.getRequestDispatcher("/view/customersuccess/main_layout.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/support/task/list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Users currentUser = (Users) session.getAttribute("user");
        UserDAO userDAO = new UserDAO();
        String roleCode = userDAO.getRoleCodeByUserId(currentUser.getUserId());

        if (!"SUPPORT".equals(roleCode)) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        String taskIdStr = request.getParameter("taskId");
        String newStatus = request.getParameter("status");

        if (taskIdStr == null || taskIdStr.isEmpty() || newStatus == null || newStatus.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/support/task/list");
            return;
        }

        try {
            // Validate enum value
            TaskStatus.valueOf(newStatus);

            int taskId = Integer.parseInt(taskIdStr);
            TaskDAO taskDAO = new TaskDAO();
            Task task = taskDAO.getTaskById(taskId);

            if (task == null || task.getAssignedTo() == null
                    || task.getAssignedTo() != currentUser.getUserId()) {
                session.setAttribute("errorMessage", "Không thể cập nhật công việc này");
                response.sendRedirect(request.getContextPath() + "/support/task/list");
                return;
            }

            // Only update status - preserve all other fields unchanged
            task.setStatus(newStatus);
            boolean success = taskDAO.updateTask(task);

            if (success) {
                session.setAttribute("successMessage", "Cập nhật trạng thái thành công");
                response.sendRedirect(request.getContextPath() + "/support/task/detail?id=" + taskId);
            } else {
                session.setAttribute("errorMessage", "Cập nhật trạng thái thất bại");
                response.sendRedirect(request.getContextPath() + "/support/task/status?id=" + taskId);
            }

        } catch (IllegalArgumentException e) {
            session.setAttribute("errorMessage", "Trạng thái không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/support/task/status?id=" + taskIdStr);
        }
    }
}
