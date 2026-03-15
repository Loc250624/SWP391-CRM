package controller.manager;

import dao.TaskDAO;
import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Task;
import model.Users;
import util.AuditUtil;

/**
 * FIX: Delete must only be triggered via POST to prevent CSRF / accidental GET-based deletion.
 * The JSP delete buttons have been changed to POST forms (with JS confirmation).
 */
@WebServlet(name = "ManagerTaskDeleteServlet", urlPatterns = {"/manager/task/delete"})
public class ManagerTaskDeleteServlet extends HttpServlet {

    /**
     * GET requests are rejected — deletion must go through POST.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        // Refuse GET-based deletion — redirect back to list
        session.setAttribute("errorMessage", "Thao tác xóa không hợp lệ. Vui lòng sử dụng form xóa.");
        response.sendRedirect(request.getContextPath() + "/manager/task/list");
    }

    /**
     * POST: perform the actual task deletion after authentication and role check.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

        String taskIdStr = request.getParameter("id");
        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "ID công việc không hợp lệ");
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

            boolean success = taskDAO.deleteTask(taskId, currentUser.getUserId());
            if (success) {
                AuditUtil.logDelete(request, currentUser.getUserId(), "Task", taskId,
                        "title=" + task.getTitle() + ", taskCode=" + task.getTaskCode());
                session.setAttribute("successMessage", "Xóa công việc thành công");
            } else {
                session.setAttribute("errorMessage", "Xóa công việc thất bại");
            }

            response.sendRedirect(request.getContextPath() + "/manager/task/list");

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID công việc không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/manager/task/list");
        }
    }
}
