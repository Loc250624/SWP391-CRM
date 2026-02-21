package controller.sale;

import dao.TaskDAO;
import dao.UserDAO;
import enums.TaskStatus;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDateTime;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Task;
import model.Users;

@WebServlet(name = "TaskLogServlet", urlPatterns = {"/sale/task/log"})
public class TaskLogServlet extends HttpServlet {

    private static final String DB_URL =
            "jdbc:sqlserver://localhost\\SQLEXPRESS:1433;"
            + "databaseName=CRM_System;encrypt=true;trustServerCertificate=true;";
    private static final String DB_USER = "sa";
    private static final String DB_PASS = "123";

    private Connection openConnection() throws Exception {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }

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

        String taskIdStr = request.getParameter("taskId");
        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "ID công việc không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/sale/task/list");
            return;
        }

        try {
            int taskId = Integer.parseInt(taskIdStr.trim());
            TaskDAO taskDAO = new TaskDAO();
            Task task = taskDAO.getTaskById(taskId);

            if (task == null) {
                session.setAttribute("errorMessage", "Không tìm thấy công việc");
                response.sendRedirect(request.getContextPath() + "/sale/task/list");
                return;
            }

            // Task must be assigned to the current user
            if (task.getAssignedTo() == null || task.getAssignedTo() != currentUser.getUserId()) {
                session.setAttribute("errorMessage", "Bạn không có quyền ghi nhật ký cho công việc này");
                response.sendRedirect(request.getContextPath() + "/sale/task/list");
                return;
            }

            // Cannot log a completed or cancelled task
            if ("COMPLETED".equals(task.getStatus()) || "CANCELLED".equals(task.getStatus())) {
                session.setAttribute("errorMessage", "Không thể ghi nhật ký cho công việc đã hoàn thành hoặc đã hủy");
                response.sendRedirect(request.getContextPath() + "/sale/task/detail?id=" + taskId);
                return;
            }

            request.setAttribute("task", task);
            request.setAttribute("taskStatusValues", TaskStatus.values());
            request.setAttribute("ACTIVE_MENU", "TASK_LIST");
            request.setAttribute("pageTitle", "Ghi nhật ký Công việc");
            request.setAttribute("CONTENT_PAGE", "/view/sale/pages/task/task-log.jsp");
            request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID công việc không hợp lệ");
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
        String logNote   = request.getParameter("logNote");
        String timeSpentStr = request.getParameter("timeSpent");
        String newStatus    = request.getParameter("status");

        // --- Basic presence validation ---
        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "ID công việc không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/sale/task/list");
            return;
        }

        String redirectLog = request.getContextPath() + "/sale/task/log?taskId=" + taskIdStr.trim();

        if (logNote == null || logNote.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Nội dung nhật ký không được để trống");
            response.sendRedirect(redirectLog);
            return;
        }

        // --- Validate timeSpent (null when not provided) ---
        Integer timeSpent = null;
        if (timeSpentStr != null && !timeSpentStr.trim().isEmpty()) {
            try {
                int parsed = Integer.parseInt(timeSpentStr.trim());
                if (parsed < 0) {
                    session.setAttribute("errorMessage", "Thời gian làm việc phải là số không âm");
                    response.sendRedirect(redirectLog);
                    return;
                }
                timeSpent = parsed;
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Thời gian làm việc phải là số hợp lệ");
                response.sendRedirect(redirectLog);
                return;
            }
        }

        // --- Validate status enum ---
        try {
            TaskStatus.valueOf(newStatus);
        } catch (IllegalArgumentException | NullPointerException e) {
            session.setAttribute("errorMessage", "Trạng thái không hợp lệ");
            response.sendRedirect(redirectLog);
            return;
        }

        try {
            int taskId = Integer.parseInt(taskIdStr.trim());
            TaskDAO taskDAO = new TaskDAO();
            Task task = taskDAO.getTaskById(taskId);

            if (task == null) {
                session.setAttribute("errorMessage", "Không tìm thấy công việc");
                response.sendRedirect(request.getContextPath() + "/sale/task/list");
                return;
            }

            // Task must be assigned to the current user
            if (task.getAssignedTo() == null || task.getAssignedTo() != currentUser.getUserId()) {
                session.setAttribute("errorMessage", "Bạn không có quyền ghi nhật ký cho công việc này");
                response.sendRedirect(request.getContextPath() + "/sale/task/list");
                return;
            }

            // Cannot log a completed or cancelled task
            if ("COMPLETED".equals(task.getStatus()) || "CANCELLED".equals(task.getStatus())) {
                session.setAttribute("errorMessage", "Không thể ghi nhật ký cho công việc đã hoàn thành hoặc đã hủy");
                response.sendRedirect(request.getContextPath() + "/sale/task/detail?id=" + taskId);
                return;
            }

            // --- Insert log record using prepared statement ---
            String insertSql =
                    "INSERT INTO task_logs (task_id, user_id, log_note, time_spent, status, created_at) "
                    + "VALUES (?, ?, ?, ?, ?, ?)";

            try (Connection conn = openConnection();
                 PreparedStatement ps = conn.prepareStatement(insertSql)) {

                ps.setInt(1, taskId);
                ps.setInt(2, currentUser.getUserId());
                ps.setString(3, logNote.trim());
                if (timeSpent != null) {
                    ps.setInt(4, timeSpent);
                } else {
                    ps.setNull(4, Types.INTEGER);
                }
                ps.setString(5, newStatus);
                ps.setTimestamp(6, Timestamp.valueOf(LocalDateTime.now()));
                ps.executeUpdate();
            }

            // --- Update task status if it changed ---
            if (!newStatus.equals(task.getStatus())) {
                task.setStatus(newStatus);
                if ("COMPLETED".equals(newStatus)) {
                    task.setCompletedAt(LocalDateTime.now());
                }
                taskDAO.updateTask(task);
            }

            session.setAttribute("successMessage", "Ghi nhật ký công việc thành công!");
            response.sendRedirect(request.getContextPath() + "/sale/task/detail?id=" + taskId);

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID công việc không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/sale/task/list");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect(redirectLog);
        }
    }
}
