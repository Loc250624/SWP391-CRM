package controller.customersuccess;

import dao.TaskDAO;
import dao.UserDAO;
import enums.TaskStatus;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Task;
import model.Users;

@WebServlet(name = "SupportTaskStatusAjaxServlet", urlPatterns = {"/support/task/ajax/status"})
public class SupportTaskStatusAjaxServlet extends HttpServlet {

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

        if (!"SUPPORT".equals(roleCode)) {
            out.print("{\"success\":false,\"message\":\"Không có quyền thực hiện\"}");
            return;
        }

        String taskIdStr = request.getParameter("taskId");
        String newStatus = request.getParameter("newStatus");
        String normalizedStatus = newStatus == null ? "" : newStatus.trim().toUpperCase();
        if ("INPROGRESS".equals(normalizedStatus) || "IN-PROGRESS".equals(normalizedStatus)) {
            normalizedStatus = "IN_PROGRESS";
        }

        try {
            TaskStatus.valueOf(normalizedStatus);
        } catch (IllegalArgumentException | NullPointerException e) {
            out.print("{\"success\":false,\"message\":\"Trạng thái không hợp lệ: " + normalizedStatus + "\"}");
            return;
        }

        // SUPPORT can only set COMPLETED
        if (!"COMPLETED".equals(normalizedStatus)) {
            out.print("{\"success\":false,\"message\":\"Bạn chỉ có thể cập nhật trạng thái sang Hoàn thành\"}");
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

            // Permission: must be assigned to this user
            if (task.getAssignedTo() == null || task.getAssignedTo() != currentUser.getUserId()) {
                out.print("{\"success\":false,\"message\":\"Bạn không có quyền cập nhật công việc này\"}");
                return;
            }

            // Terminal state check
            if ("COMPLETED".equals(task.getStatusName()) || "CANCELLED".equals(task.getStatusName())) {
                out.print("{\"success\":false,\"message\":\"Công việc đã kết thúc, không thể cập nhật\"}");
                return;
            }

            // Validate transition
            if (!isValidTransition(task.getStatusName(), normalizedStatus)) {
                out.print("{\"success\":false,\"message\":\"Chuyển trạng thái không hợp lệ\"}");
                return;
            }

            task.setStatus(TaskStatus.valueOf(normalizedStatus).ordinal());
            boolean ok = taskDAO.updateTask(task);

            if (ok) {
                // Notify task status changed
                java.util.List<Integer> notifyIds = new java.util.ArrayList<>();
                dao.TaskAssigneeDAO taDao = new dao.TaskAssigneeDAO();
                for (model.TaskAssignee ta : taDao.getByTaskId(taskId)) {
                    if (!notifyIds.contains(ta.getUserId())) notifyIds.add(ta.getUserId());
                }
                if (task.getCreatedBy() != null && !notifyIds.contains(task.getCreatedBy())) {
                    notifyIds.add(task.getCreatedBy());
                }
                util.NotificationUtil.notifyTaskStatusChanged(
                        taskId, task.getTaskCode(), task.getTitle(),
                        normalizedStatus, currentUser.getUserId(), notifyIds);

                out.print("{\"success\":true,\"taskId\":" + taskId + ",\"newStatus\":\"" + normalizedStatus + "\"}");
            } else {
                out.print("{\"success\":false,\"message\":\"Cập nhật thất bại\"}");
            }

        } catch (NumberFormatException e) {
            out.print("{\"success\":false,\"message\":\"ID công việc không hợp lệ\"}");
        }
    }

    private boolean isValidTransition(String current, String next) {
        if (current == null || current.equals(next)) return true;
        if ("PENDING".equals(current)) {
            return "IN_PROGRESS".equals(next) || "COMPLETED".equals(next);
        }
        if ("IN_PROGRESS".equals(current)) {
            return "COMPLETED".equals(next);
        }
        return false;
    }
}
