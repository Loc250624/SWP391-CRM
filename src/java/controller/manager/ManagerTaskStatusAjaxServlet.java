package controller.manager;

import dao.TaskDAO;
import dao.UserDAO;
import enums.TaskStatus;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Task;
import model.Users;

/**
 * AJAX endpoint for Kanban drag-and-drop status updates.
 * POST /manager/task/ajax/status
 * Params: taskId (int), newStatus (String)
 * Returns: JSON {"success":true/false, "message":"..."}
 */
@WebServlet(name = "ManagerTaskStatusAjaxServlet", urlPatterns = {"/manager/task/ajax/status"})
public class ManagerTaskStatusAjaxServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            out.print("{\"success\":false,\"message\":\"Phiên đăng nhập hết hạn\"}");
            return;
        }

        Users currentUser = (Users) session.getAttribute("user");
        UserDAO userDAO = new UserDAO();
        String roleCode = userDAO.getRoleCodeByUserId(currentUser.getUserId());

        if (!"MANAGER".equals(roleCode)) {
            out.print("{\"success\":false,\"message\":\"Không có quyền thực hiện\"}");
            return;
        }

        String taskIdStr = request.getParameter("taskId");
        String newStatus = request.getParameter("newStatus");

        // Validate enum
        try {
            TaskStatus.valueOf(newStatus);
        } catch (IllegalArgumentException | NullPointerException e) {
            out.print("{\"success\":false,\"message\":\"Trạng thái không hợp lệ\"}");
            return;
        }

        try {
            int taskId = Integer.parseInt(taskIdStr.trim());
            TaskDAO taskDAO = new TaskDAO();
            Task task = taskDAO.getTaskById(taskId);

            if (task == null) {
                out.print("{\"success\":false,\"message\":\"Không tìm thấy công việc\"}");
                return;
            }

            // Terminal state check
            if ("COMPLETED".equals(task.getStatusName()) || "CANCELLED".equals(task.getStatusName())) {
                out.print("{\"success\":false,\"message\":\"Công việc đã kết thúc, không thể cập nhật\"}");
                return;
            }

            // Manager can only set CANCELLED
            if (!"CANCELLED".equals(newStatus)) {
                out.print("{\"success\":false,\"message\":\"Quản lý chỉ có thể hủy công việc\"}");
                return;
            }

            task.setStatus(TaskStatus.valueOf(newStatus).ordinal());
            boolean ok = taskDAO.updateTask(task);

            if (ok) {
                out.print("{\"success\":true,\"taskId\":" + taskId + ",\"newStatus\":\"" + newStatus + "\"}");
            } else {
                out.print("{\"success\":false,\"message\":\"Cập nhật thất bại\"}");
            }

        } catch (NumberFormatException e) {
            out.print("{\"success\":false,\"message\":\"ID công việc không hợp lệ\"}");
        }
    }
}
