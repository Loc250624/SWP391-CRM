package controller.manager;

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

@WebServlet(name = "ManagerTaskStatusServlet", urlPatterns = {"/manager/task/status"})
public class ManagerTaskStatusServlet extends HttpServlet {

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

            // Terminal state — cannot update
            if ("COMPLETED".equals(task.getStatusName()) || "CANCELLED".equals(task.getStatusName())) {
                session.setAttribute("errorMessage",
                        "Công việc đã hoàn thành hoặc đã hủy, không thể cập nhật trạng thái");
                response.sendRedirect(request.getContextPath() + "/manager/task/detail?id=" + taskId);
                return;
            }

            request.setAttribute("task",             task);
            request.setAttribute("allUsers",         userDAO.getAllUsers());
            request.setAttribute("taskStatusValues", TaskStatus.values());
            request.setAttribute("pageTitle",        "Cập nhật Trạng thái");
            request.setAttribute("ACTIVE_MENU",      "TASK_MY_LIST");
            request.setAttribute("CONTENT_PAGE",     "/view/manager/task/task-status.jsp");
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

        String taskIdStr = request.getParameter("taskId");
        String newStatus = request.getParameter("status");

        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/manager/task/list");
            return;
        }

        String redirectBack = request.getContextPath() + "/manager/task/status?id=" + taskIdStr.trim();

        // Validate enum first (separate try-catch to avoid swallowing NumberFormatException)
        try {
            TaskStatus.valueOf(newStatus);
        } catch (IllegalArgumentException | NullPointerException e) {
            session.setAttribute("errorMessage", "Trạng thái không hợp lệ");
            response.sendRedirect(redirectBack);
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

            // Block updating terminal-state tasks
            if ("COMPLETED".equals(task.getStatusName()) || "CANCELLED".equals(task.getStatusName())) {
                session.setAttribute("errorMessage",
                        "Công việc đã hoàn thành hoặc đã hủy, không thể cập nhật");
                response.sendRedirect(request.getContextPath() + "/manager/task/detail?id=" + taskId);
                return;
            }

            // Dependency check: block IN_PROGRESS / COMPLETED if unmet dependencies exist
            if ("IN_PROGRESS".equals(newStatus) || "COMPLETED".equals(newStatus)) {
                List<Integer> depIds = TaskDAO.parseDependencyIds(task.getDescription());
                if (!depIds.isEmpty()) {
                    List<Task> deps = taskDAO.getTasksByIds(depIds);
                    boolean blocked = deps.stream().anyMatch(d -> !"COMPLETED".equals(d.getStatusName()));
                    if (blocked) {
                        session.setAttribute("errorMessage",
                                "Công việc này đang bị chặn bởi các công việc phụ thuộc chưa hoàn thành");
                        response.sendRedirect(redirectBack);
                        return;
                    }
                }
            }

            task.setStatus(TaskStatus.valueOf(newStatus).ordinal());
            boolean success = taskDAO.updateTask(task);

            if (success) {
                // If just completed and task is recurring, auto-spawn next instance
                if ("COMPLETED".equals(newStatus)) {
                    String title = task.getTitle() != null ? task.getTitle() : "";
                    if (title.startsWith("[R-DAILY]") || title.startsWith("[R-WEEKLY]")
                            || title.startsWith("[R-MONTHLY]")) {
                        taskDAO.insertNextRecurringInstance(task);
                    }
                }

                // Thong bao cho assignees + creator
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
                response.sendRedirect(request.getContextPath() + "/manager/task/detail?id=" + taskId);
            } else {
                session.setAttribute("errorMessage", "Cập nhật trạng thái thất bại");
                response.sendRedirect(redirectBack);
            }

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID công việc không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/manager/task/list");
        }
    }
}
