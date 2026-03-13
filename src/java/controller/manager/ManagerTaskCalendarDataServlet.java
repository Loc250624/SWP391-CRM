package controller.manager;

import dao.TaskDAO;
import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Task;
import model.Users;

/**
 * AJAX endpoint that returns task events in FullCalendar JSON format.
 * GET /manager/task/calendar/data
 * Params: view (personal|team|all), employee, status, priority, start (ISO), end (ISO)
 */
@WebServlet(name = "ManagerTaskCalendarDataServlet", urlPatterns = {"/manager/task/calendar/data"})
public class ManagerTaskCalendarDataServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // Session + role guard
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"error\":\"Unauthorized\"}");
            return;
        }

        Users currentUser = (Users) session.getAttribute("user");
        UserDAO userDAO = new UserDAO();
        String roleCode = userDAO.getRoleCodeByUserId(currentUser.getUserId());

        if (!"MANAGER".equals(roleCode)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            out.print("{\"error\":\"Forbidden\"}");
            return;
        }

        // Parse date range params (FullCalendar sends ISO 8601)
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime startDate = parseIso(request.getParameter("start"),
                now.withDayOfMonth(1).withHour(0).withMinute(0).withSecond(0));
        LocalDateTime endDate = parseIso(request.getParameter("end"),
                startDate.plusMonths(2));

        // View and filter params
        String viewParam     = request.getParameter("view");
        String empParam      = request.getParameter("employee");
        String statusParam   = request.getParameter("status");
        String priorityParam = request.getParameter("priority");

        if (!"personal".equals(viewParam) && !"team".equals(viewParam) && !"all".equals(viewParam)) {
            viewParam = "personal";
        }

        // Build dept/team ID lists and user name map
        List<Users> allUsers = userDAO.getAllUsers();
        Map<Integer, String> userNames = new HashMap<>();
        List<Integer> allDeptIds = new ArrayList<>();
        List<Integer> teamIds    = new ArrayList<>();

        for (Users u : allUsers) {
            userNames.put(u.getUserId(), u.getFirstName() + " " + u.getLastName());
            if (u.getDepartmentId() == currentUser.getDepartmentId()) {
                allDeptIds.add(u.getUserId());
                if (u.getUserId() != currentUser.getUserId()) {
                    teamIds.add(u.getUserId());
                }
            }
        }

        // Resolve scope based on view
        List<Integer> scopeIds;
        if ("personal".equals(viewParam)) {
            scopeIds = new ArrayList<>();
            scopeIds.add(currentUser.getUserId());
        } else if ("team".equals(viewParam)) {
            scopeIds = teamIds;
        } else {
            scopeIds = allDeptIds;
        }

        // Optional employee override (must be within dept scope)
        if (empParam != null && !empParam.trim().isEmpty()) {
            try {
                int empId = Integer.parseInt(empParam.trim());
                if (allDeptIds.contains(empId)) {
                    scopeIds = new ArrayList<>();
                    scopeIds.add(empId);
                }
            } catch (NumberFormatException ignored) {}
        }

        // Fetch tasks
        List<Task> tasks = new ArrayList<>();
        if (!scopeIds.isEmpty()) {
            TaskDAO taskDAO = new TaskDAO();
            tasks = taskDAO.getTasksByDateRange(scopeIds, startDate, endDate,
                    (statusParam   != null && !statusParam.trim().isEmpty())   ? statusParam.trim()   : null,
                    (priorityParam != null && !priorityParam.trim().isEmpty()) ? priorityParam.trim() : null);
        }

        // Build JSON array
        StringBuilder json = new StringBuilder("[");
        boolean first = true;

        for (Task task : tasks) {
            if (task.getDueDate() == null) continue;

            if (!first) json.append(",");
            first = false;

            String slaState    = computeSlaState(task);
            boolean isOverdue  = task.getDueDate().isBefore(now)
                               && !"COMPLETED".equals(task.getStatusName())
                               && !"CANCELLED".equals(task.getStatusName());

            // SLA icon suffix appended to title
            String slaIcon = "BREACHED".equals(slaState) ? " \uD83D\uDD34"
                           : "WARNING".equals(slaState)  ? " \u26A0\uFE0F"
                           : "";

            // Color rules
            String bgColor;
            if ("COMPLETED".equals(task.getStatusName())) {
                bgColor = "#198754";
            } else {
                switch (task.getPriorityName() != null ? task.getPriorityName() : "LOW") {
                    case "HIGH":   bgColor = "#dc3545"; break;
                    case "MEDIUM": bgColor = "#fd7e14"; break;
                    default:       bgColor = "#0d6efd"; break;
                }
            }
            String borderColor = isOverdue ? "#dc3545" : bgColor;

            String assigneeName = userNames.getOrDefault(task.getAssignedTo(), "");
            String dueStr       = task.getDueDate().toString(); // ISO "2026-02-24T14:30:00"

            String safeTitle    = jsonEscape(task.getTitle() != null ? task.getTitle() + slaIcon : slaIcon);
            String safeAssignee = jsonEscape(assigneeName);
            String safeCode     = jsonEscape(task.getTaskCode() != null ? task.getTaskCode() : "");
            String safePriority = jsonEscape(task.getPriorityName() != null ? task.getPriorityName() : "");
            String safeStatus   = jsonEscape(task.getStatusName()  != null ? task.getStatusName()   : "");
            String safeDue      = jsonEscape(dueStr);

            json.append("{")
                .append("\"id\":").append(task.getTaskId()).append(",")
                .append("\"title\":\"").append(safeTitle).append("\",")
                .append("\"start\":\"").append(safeDue).append("\",")
                .append("\"end\":\"").append(safeDue).append("\",")
                .append("\"backgroundColor\":\"").append(bgColor).append("\",")
                .append("\"borderColor\":\"").append(borderColor).append("\",")
                .append("\"textColor\":\"#ffffff\",")
                .append("\"extendedProps\":{")
                .append("\"taskId\":").append(task.getTaskId()).append(",")
                .append("\"taskCode\":\"").append(safeCode).append("\",")
                .append("\"assigneeName\":\"").append(safeAssignee).append("\",")
                .append("\"priority\":\"").append(safePriority).append("\",")
                .append("\"status\":\"").append(safeStatus).append("\",")
                .append("\"slaState\":\"").append(slaState).append("\",")
                .append("\"isOverdue\":").append(isOverdue).append(",")
                .append("\"dueDisplay\":\"").append(safeDue).append("\"")
                .append("}}");
        }

        json.append("]");
        out.print(json.toString());
    }

    /**
     * Computes SLA state for a task using the same thresholds as the SQL-side SLA logic.
     * HIGH = 24h, MEDIUM = 72h, LOW = 120h
     */
    private String computeSlaState(Task task) {
        if ("COMPLETED".equals(task.getStatusName()) || "CANCELLED".equals(task.getStatusName())) return "OK";
        if (task.getCreatedAt() == null) return "OK";

        int slaHours;
        switch (task.getPriorityName() != null ? task.getPriorityName() : "LOW") {
            case "HIGH":   slaHours = 24;  break;
            case "MEDIUM": slaHours = 72;  break;
            default:       slaHours = 120; break;
        }

        long elapsedHours = java.time.Duration.between(task.getCreatedAt(), LocalDateTime.now()).toHours();
        if (elapsedHours > slaHours) return "BREACHED";
        if (elapsedHours > slaHours * 0.8) return "WARNING";
        return "OK";
    }

    /**
     * Escapes a string for safe embedding in a JSON string literal.
     */
    private String jsonEscape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    /**
     * Parses an ISO 8601 date/datetime string to LocalDateTime.
     * Handles both "YYYY-MM-DD" and "YYYY-MM-DDTHH:mm:ss[Z][+offset]" formats.
     */
    private LocalDateTime parseIso(String iso, LocalDateTime fallback) {
        if (iso == null || iso.isEmpty()) return fallback;
        try {
            if (iso.length() == 10) iso = iso + "T00:00:00";
            if (iso.endsWith("Z")) iso = iso.substring(0, iso.length() - 1);
            int plusIdx = iso.indexOf('+', 10);
            if (plusIdx > 0) iso = iso.substring(0, plusIdx);
            return LocalDateTime.parse(iso);
        } catch (Exception e) {
            return fallback;
        }
    }
}
