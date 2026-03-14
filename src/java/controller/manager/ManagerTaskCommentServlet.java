package controller.manager;

import dao.TaskCommentDAO;
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

/**
 * POST /manager/task/comment
 * Params: taskId (int), content (String)
 * Adds a comment/note to the task activity log.
 */
@WebServlet(name = "ManagerTaskCommentServlet", urlPatterns = {"/manager/task/comment"})
public class ManagerTaskCommentServlet extends HttpServlet {

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

        String taskIdStr = request.getParameter("taskId");
        String content   = request.getParameter("content");

        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "ID công việc không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/manager/task/list");
            return;
        }

        if (content == null || content.trim().isEmpty()) {
            int taskId;
            try { taskId = Integer.parseInt(taskIdStr.trim()); }
            catch (NumberFormatException e) { taskId = 0; }
            session.setAttribute("errorMessage", "Nội dung bình luận không được để trống");
            response.sendRedirect(request.getContextPath() + "/manager/task/detail?id=" + taskId);
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

        Task task = new TaskDAO().getTaskById(taskId);
        if (task == null) {
            session.setAttribute("errorMessage", "Không tìm thấy công việc");
            response.sendRedirect(request.getContextPath() + "/manager/task/list");
            return;
        }

        boolean ok = new TaskCommentDAO().insertComment(taskId, currentUser.getUserId(), content.trim());
        if (ok) {
            session.setAttribute("successMessage", "Đã thêm bình luận");
        } else {
            session.setAttribute("errorMessage", "Thêm bình luận thất bại");
        }

        response.sendRedirect(request.getContextPath() + "/manager/task/detail?id=" + taskId);
    }
}
