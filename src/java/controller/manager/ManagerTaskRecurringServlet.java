package controller.manager;

import dao.TaskDAO;
import dao.UserDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Task;
import model.Users;

@WebServlet(name = "ManagerTaskRecurringServlet", urlPatterns = {"/manager/task/recurring"})
public class ManagerTaskRecurringServlet extends HttpServlet {

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

        String taskIdStr = request.getParameter("id");
        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/manager/task/list");
            return;
        }

        try {
            int taskId = Integer.parseInt(taskIdStr.trim());
            TaskDAO taskDAO = new TaskDAO();
            Task task = taskDAO.getTaskById(taskId);

            if (task == null) {
                session.setAttribute("errorMessage", "Không tìm thấy công việc");
                response.sendRedirect(request.getContextPath() + "/manager/task/list");
                return;
            }

            List<Users> allUsers = userDAO.getAllUsers();

            request.setAttribute("task",        task);
            request.setAttribute("allUsers",    allUsers);
            request.setAttribute("pageTitle",   "Cài đặt Lặp lại");
            request.setAttribute("ACTIVE_MENU", "TASK_MY_LIST");
            request.setAttribute("CONTENT_PAGE", "/view/manager/task/task-recurring.jsp");
            request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manager/task/list");
        }
    }

    // ----------------------------------------------------------------- POST --
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

        if (!"MANAGER".equals(roleCode)) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        String taskIdStr       = request.getParameter("taskId");
        String enableRecurring = request.getParameter("enableRecurring");
        String pattern         = request.getParameter("recurrencePattern");

        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/manager/task/list");
            return;
        }

        try {
            int taskId = Integer.parseInt(taskIdStr.trim());
            TaskDAO taskDAO = new TaskDAO();
            Task task = taskDAO.getTaskById(taskId);

            if (task == null) {
                session.setAttribute("errorMessage", "Không tìm thấy công việc");
                response.sendRedirect(request.getContextPath() + "/manager/task/list");
                return;
            }

            String currentTitle = task.getTitle() != null ? task.getTitle() : "";

            // Strip any existing [R-*] prefix
            String cleanTitle = currentTitle
                    .replaceAll("^\\[R-DAILY\\]\\s*", "")
                    .replaceAll("^\\[R-WEEKLY\\]\\s*", "")
                    .replaceAll("^\\[R-MONTHLY\\]\\s*", "");

            if ("on".equals(enableRecurring) || "true".equals(enableRecurring)) {
                // Validate pattern
                if (pattern == null || (!pattern.equals("DAILY") && !pattern.equals("WEEKLY") && !pattern.equals("MONTHLY"))) {
                    session.setAttribute("errorMessage", "Chu kỳ lặp lại không hợp lệ");
                    response.sendRedirect(request.getContextPath() + "/manager/task/recurring?id=" + taskId);
                    return;
                }
                task.setTitle("[R-" + pattern + "] " + cleanTitle);
            } else {
                // Remove recurring prefix
                task.setTitle(cleanTitle);
            }

            boolean success = taskDAO.updateTask(task);
            if (success) {
                session.setAttribute("successMessage",
                        "on".equals(enableRecurring) || "true".equals(enableRecurring)
                                ? "Đã bật chế độ lặp lại"
                                : "Đã tắt chế độ lặp lại");
                response.sendRedirect(request.getContextPath() + "/manager/task/detail?id=" + taskId);
            } else {
                session.setAttribute("errorMessage", "Cập nhật cài đặt lặp lại thất bại");
                response.sendRedirect(request.getContextPath() + "/manager/task/recurring?id=" + taskId);
            }

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID công việc không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/manager/task/list");
        }
    }
}
