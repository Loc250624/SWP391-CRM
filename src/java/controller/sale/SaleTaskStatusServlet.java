package controller.sale;

import dao.TaskAssigneeDAO;
import dao.TaskDAO;
import dao.UserDAO;
import enums.TaskStatus;
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
import model.Users;

@WebServlet(name = "SaleTaskStatusServlet", urlPatterns = {"/sale/task/status"})
public class SaleTaskStatusServlet extends HttpServlet {

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

        if (!"SALES".equals(roleCode)) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        String taskIdStr = request.getParameter("id");
        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/sale/task/list");
            return;
        }

        try {
            int taskId = Integer.parseInt(taskIdStr.trim());
            TaskDAO taskDAO = new TaskDAO();
            Task task = taskDAO.getTaskById(taskId);

            if (task == null || task.getAssignedTo() == null
                    || task.getAssignedTo() != currentUser.getUserId()) {
                session.setAttribute("errorMessage", "Không thể cập nhật công việc này");
                response.sendRedirect(request.getContextPath() + "/sale/task/list");
                return;
            }

            // Cannot update a terminal-state task
            if ("COMPLETED".equals(task.getStatusName()) || "CANCELLED".equals(task.getStatusName())) {
                session.setAttribute("errorMessage",
                        "Công việc đã hoàn thành hoặc đã hủy, không thể cập nhật trạng thái");
                response.sendRedirect(request.getContextPath() + "/sale/task/detail?id=" + taskId);
                return;
            }

            request.setAttribute("task",             task);
            request.setAttribute("taskStatusValues", TaskStatus.values());
            request.setAttribute("ACTIVE_MENU",  "TASK_LIST");
            request.setAttribute("pageTitle",    "Cập nhật Trạng thái");
            request.setAttribute("CONTENT_PAGE", "/view/sale/pages/task/status.jsp");
            request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/sale/task/list");
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

        if (!"SALES".equals(roleCode)) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        String taskIdStr = request.getParameter("taskId");
        String newStatus = request.getParameter("status");

        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/sale/task/list");
            return;
        }

        String redirectBack = request.getContextPath() + "/sale/task/status?id=" + taskIdStr.trim();

        // Validate enum value
        try {
            TaskStatus.valueOf(newStatus);
        } catch (IllegalArgumentException | NullPointerException e) {
            session.setAttribute("errorMessage", "Trạng thái không hợp lệ");
            response.sendRedirect(redirectBack);
            return;
        }

        // SALE users can only set COMPLETED
        if (!"COMPLETED".equals(newStatus)) {
            session.setAttribute("errorMessage", "Bạn chỉ có thể cập nhật trạng thái sang Hoàn thành");
            response.sendRedirect(redirectBack);
            return;
        }

        try {
            int taskId = Integer.parseInt(taskIdStr.trim());
            TaskDAO taskDAO = new TaskDAO();
            Task task = taskDAO.getTaskById(taskId);

            if (task == null || task.getAssignedTo() == null
                    || task.getAssignedTo() != currentUser.getUserId()) {
                session.setAttribute("errorMessage", "Không thể cập nhật công việc này");
                response.sendRedirect(request.getContextPath() + "/sale/task/list");
                return;
            }

            // Block updating terminal-state tasks
            if ("COMPLETED".equals(task.getStatusName()) || "CANCELLED".equals(task.getStatusName())) {
                session.setAttribute("errorMessage",
                        "Công việc đã hoàn thành hoặc đã hủy, không thể cập nhật");
                response.sendRedirect(request.getContextPath() + "/sale/task/detail?id=" + taskId);
                return;
            }

            // FIX: Enforce valid status transitions for SALE users:
            //   PENDING    → IN_PROGRESS ✓
            //   PENDING    → COMPLETED   ✓  (allowed shortcut)
            //   IN_PROGRESS → COMPLETED  ✓
            //   IN_PROGRESS → PENDING    ✗  (no going backward)
            String currentStatus = task.getStatusName();
            if (!isValidTransition(currentStatus, newStatus)) {
                session.setAttribute("errorMessage",
                        "Chuyển trạng thái không hợp lệ: "
                        + getVietnameseStatus(currentStatus)
                        + " → " + getVietnameseStatus(newStatus));
                response.sendRedirect(redirectBack);
                return;
            }

            task.setStatus(TaskStatus.valueOf(newStatus).ordinal());
            boolean success = taskDAO.updateTask(task);

            if (success) {
                // Thong bao cho assignees + creator (tru nguoi thay doi)
                List<Integer> notifyIds = new ArrayList<>();
                for (model.TaskAssignee ta : new TaskAssigneeDAO().getByTaskId(taskId)) {
                    if (!notifyIds.contains(ta.getUserId())) notifyIds.add(ta.getUserId());
                }
                if (task.getCreatedBy() != null && !notifyIds.contains(task.getCreatedBy())) {
                    notifyIds.add(task.getCreatedBy());
                }
                util.NotificationUtil.notifyTaskStatusChanged(
                        taskId, task.getTaskCode(), task.getTitle(),
                        newStatus, currentUser.getUserId(), notifyIds);

                session.setAttribute("successMessage", "Cập nhật trạng thái thành công");
                response.sendRedirect(request.getContextPath() + "/sale/task/detail?id=" + taskId);
            } else {
                session.setAttribute("errorMessage", "Cập nhật trạng thái thất bại");
                response.sendRedirect(redirectBack);
            }

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID công việc không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/sale/task/list");
        }
    }

    /**
     * Returns true if transitioning from {@code current} to {@code next} is allowed for SALE users.
     * Allowed transitions:
     *   PENDING    → IN_PROGRESS
     *   PENDING    → COMPLETED   (shortcut)
     *   IN_PROGRESS → COMPLETED
     */
    private boolean isValidTransition(String current, String next) {
        if ("PENDING".equals(current)) {
            return "IN_PROGRESS".equals(next) || "COMPLETED".equals(next);
        }
        if ("IN_PROGRESS".equals(current)) {
            return "COMPLETED".equals(next);
        }
        // COMPLETED and CANCELLED are terminal; transitions are blocked earlier
        return false;
    }

    private String getVietnameseStatus(String status) {
        if (status == null) return "";
        switch (status) {
            case "PENDING":     return "Chờ xử lý";
            case "IN_PROGRESS": return "Đang thực hiện";
            case "COMPLETED":   return "Hoàn thành";
            case "CANCELLED":   return "Đã hủy";
            default:            return status;
        }
    }
}
