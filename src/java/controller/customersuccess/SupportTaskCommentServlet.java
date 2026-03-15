package controller.customersuccess;

import dao.TaskAssigneeDAO;
import dao.TaskCommentDAO;
import dao.TaskDAO;
import dao.UserDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Task;
import model.TaskAssignee;
import model.Users;

@WebServlet(name = "SupportTaskCommentServlet", urlPatterns = {"/support/task/comment"})
public class SupportTaskCommentServlet extends HttpServlet {

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

        if (!"SUPPORT".equals(roleCode)) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        String taskIdStr = request.getParameter("taskId");
        String content = request.getParameter("content");

        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "ID công việc không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/support/task/list");
            return;
        }

        int taskId;
        try {
            taskId = Integer.parseInt(taskIdStr.trim());
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID công việc không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/support/task/list");
            return;
        }

        if (content == null || content.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Nội dung bình luận không được để trống");
            response.sendRedirect(request.getContextPath() + "/support/task/detail?id=" + taskId);
            return;
        }

        Task task = new TaskDAO().getTaskById(taskId);
        if (task == null) {
            session.setAttribute("errorMessage", "Không tìm thấy công việc");
            response.sendRedirect(request.getContextPath() + "/support/task/list");
            return;
        }

        // Verify user is assignee
        if (task.getAssignedTo() == null || task.getAssignedTo() != currentUser.getUserId()) {
            session.setAttribute("errorMessage", "Bạn không có quyền bình luận công việc này");
            response.sendRedirect(request.getContextPath() + "/support/task/list");
            return;
        }

        boolean ok = new TaskCommentDAO().insertComment(taskId, currentUser.getUserId(), content.trim());
        if (ok) {
            // Notify assignees + creator (exclude commenter)
            List<Integer> notifyIds = new ArrayList<>();
            TaskAssigneeDAO taDao = new TaskAssigneeDAO();
            for (TaskAssignee ta : taDao.getByTaskId(taskId)) {
                if (!notifyIds.contains(ta.getUserId())) notifyIds.add(ta.getUserId());
            }
            if (task.getCreatedBy() != null && !notifyIds.contains(task.getCreatedBy())) {
                notifyIds.add(task.getCreatedBy());
            }
            util.NotificationUtil.notifyTaskComment(
                    taskId, task.getTaskCode(), task.getTitle(),
                    currentUser.getUserId(), notifyIds);

            session.setAttribute("successMessage", "Đã thêm bình luận");
        } else {
            session.setAttribute("errorMessage", "Thêm bình luận thất bại");
        }

        response.sendRedirect(request.getContextPath() + "/support/task/detail?id=" + taskId);
    }
}
