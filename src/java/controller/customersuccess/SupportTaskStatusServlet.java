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

        if (!"SUPPORT".equals(roleCode)) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        String taskIdStr = request.getParameter("id");
        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/support/task/list");
            return;
        }

        try {
            int taskId = Integer.parseInt(taskIdStr.trim());
            TaskDAO taskDAO = new TaskDAO();
            Task task = taskDAO.getTaskById(taskId);

            if (task == null || task.getAssignedTo() == null
                    || task.getAssignedTo() != currentUser.getUserId()) {
                session.setAttribute("errorMessage", "Không thể cập nhật công việc này");
                response.sendRedirect(request.getContextPath() + "/support/task/list");
                return;
            }

            // FIX: Cannot update terminal-state tasks
            if ("COMPLETED".equals(task.getStatus()) || "CANCELLED".equals(task.getStatus())) {
                session.setAttribute("errorMessage",
                        "Công việc đã hoàn thành hoặc đã hủy, không thể cập nhật trạng thái");
                response.sendRedirect(request.getContextPath() + "/support/task/detail?id=" + taskId);
                return;
            }

            request.setAttribute("task",             task);
            request.setAttribute("taskStatusValues", TaskStatus.values());
            request.setAttribute("pageTitle",    "Cập nhật Trạng thái");
            request.setAttribute("contentPage",  "/view/support/task/task-status.jsp");
            request.getRequestDispatcher("/view/customersuccess/main_layout.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/support/task/list");
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

        if (!"SUPPORT".equals(roleCode)) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        String taskIdStr = request.getParameter("taskId");
        String newStatus = request.getParameter("status");

        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/support/task/list");
            return;
        }

        String redirectBack = request.getContextPath() + "/support/task/status?id=" + taskIdStr.trim();

        // FIX: Validate enum first (separate from taskId parse to avoid wrong catch)
        try {
            TaskStatus.valueOf(newStatus);
        } catch (IllegalArgumentException | NullPointerException e) {
            session.setAttribute("errorMessage", "Trạng thái không hợp lệ");
            response.sendRedirect(redirectBack);
            return;
        }

        // FIX: SUPPORT cannot set CANCELLED status
        if ("CANCELLED".equals(newStatus)) {
            session.setAttribute("errorMessage", "Bạn không có quyền hủy công việc");
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
                response.sendRedirect(request.getContextPath() + "/support/task/list");
                return;
            }

            // FIX: Block updating terminal-state tasks
            if ("COMPLETED".equals(task.getStatus()) || "CANCELLED".equals(task.getStatus())) {
                session.setAttribute("errorMessage",
                        "Công việc đã hoàn thành hoặc đã hủy, không thể cập nhật");
                response.sendRedirect(request.getContextPath() + "/support/task/detail?id=" + taskId);
                return;
            }

            // FIX: Enforce valid status transitions for SUPPORT users (same rules as SALES)
            //   PENDING    → IN_PROGRESS  ✓
            //   PENDING    → COMPLETED    ✓  (shortcut)
            //   IN_PROGRESS → COMPLETED   ✓
            //   IN_PROGRESS → PENDING     ✗  (going backward is blocked)
            if (!isValidTransition(task.getStatus(), newStatus)) {
                session.setAttribute("errorMessage",
                        "Chuyển trạng thái không hợp lệ: "
                        + getVietnameseStatus(task.getStatus())
                        + " → " + getVietnameseStatus(newStatus));
                response.sendRedirect(redirectBack);
                return;
            }

            task.setStatus(newStatus);
            boolean success = taskDAO.updateTask(task);

            if (success) {
                session.setAttribute("successMessage", "Cập nhật trạng thái thành công");
                response.sendRedirect(request.getContextPath() + "/support/task/detail?id=" + taskId);
            } else {
                session.setAttribute("errorMessage", "Cập nhật trạng thái thất bại");
                response.sendRedirect(redirectBack);
            }

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID công việc không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/support/task/list");
        }
    }

    /**
     * Valid status transitions for SUPPORT users:
     *   PENDING    → IN_PROGRESS  ✓
     *   PENDING    → COMPLETED    ✓  (shortcut)
     *   IN_PROGRESS → COMPLETED   ✓
     *   IN_PROGRESS → PENDING     ✗  (going backward)
     */
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
