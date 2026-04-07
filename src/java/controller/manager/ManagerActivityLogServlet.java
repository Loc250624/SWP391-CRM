package controller.manager;

import dao.ActivityDAO;
import dao.UserDAO;
import model.Activity;
import model.Users;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ManagerActivityLogServlet", urlPatterns = {"/manager/activity-log"})
public class ManagerActivityLogServlet extends HttpServlet {

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

        String action = request.getParameter("action");

        if (action != null) {
            response.setContentType("application/json;charset=UTF-8");
            PrintWriter out = response.getWriter();

            switch (action) {
                case "kpi":
                    writeKpi(out);
                    break;
                case "logs":
                    writeLogs(out, request);
                    break;
                case "detail":
                    writeDetail(out, request);
                    break;
                default:
                    out.write("{\"error\":\"unknown action\"}");
            }
            return;
        }

        request.setAttribute("ACTIVE_MENU", "ACTIVITY_LOG");
        request.setAttribute("pageTitle", "Log Activities");
        request.setAttribute("CONTENT_PAGE", "/view/manager/audit/activity-log.jsp");
        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp").forward(request, response);
    }

    private void writeKpi(PrintWriter out) {
        ActivityDAO dao = new ActivityDAO();
        Map<String, Integer> kpi = dao.getManagerActivityKpi();

        out.write("{\"total\":" + kpi.getOrDefault("total", 0)
                + ",\"meetings\":" + kpi.getOrDefault("meetings", 0)
                + ",\"calls\":" + kpi.getOrDefault("calls", 0)
                + ",\"emails\":" + kpi.getOrDefault("emails", 0)
                + "}");
    }

    private void writeLogs(PrintWriter out, HttpServletRequest request) {
        ActivityDAO dao = new ActivityDAO();

        String activityType = request.getParameter("activityType");
        String relatedType = request.getParameter("relatedType");
        String roleFilter = request.getParameter("roleFilter");
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");
        int offset = parseIntOr(request.getParameter("offset"), 0);
        int limit = parseIntOr(request.getParameter("limit"), 20);

        if (activityType != null && activityType.isEmpty()) activityType = null;
        if (relatedType != null && relatedType.isEmpty()) relatedType = null;
        if (roleFilter != null && roleFilter.isEmpty()) roleFilter = null;
        if (keyword != null && keyword.isEmpty()) keyword = null;
        if (status != null && status.isEmpty()) status = null;

        List<Activity> logs = dao.getManagerActivityLogPaged(activityType, relatedType, roleFilter, keyword, status, offset, limit);
        int total = dao.countManagerActivityLog(activityType, relatedType, roleFilter, keyword, status);

        StringBuilder sb = new StringBuilder();
        sb.append("{\"total\":").append(total).append(",\"logs\":[");
        for (int i = 0; i < logs.size(); i++) {
            Activity a = logs.get(i);
            if (i > 0) sb.append(",");
            sb.append("{");
            sb.append("\"activityId\":").append(a.getActivityId());
            sb.append(",\"activityType\":").append(jsonStr(a.getActivityType()));
            sb.append(",\"relatedType\":").append(jsonStr(a.getRelatedType()));
            sb.append(",\"relatedId\":").append(a.getRelatedId());
            sb.append(",\"subject\":").append(jsonStr(a.getSubject()));
            sb.append(",\"description\":").append(jsonStr(a.getDescription()));
            sb.append(",\"activityDate\":").append(jsonStr(a.getActivityDate() != null ? a.getActivityDate().toString() : null));
            sb.append(",\"durationMinutes\":").append(a.getDurationMinutes() != null ? a.getDurationMinutes() : "null");
            sb.append(",\"callDirection\":").append(jsonStr(a.getCallDirection()));
            sb.append(",\"callResult\":").append(jsonStr(a.getCallResult()));
            sb.append(",\"status\":").append(jsonStr(a.getStatus()));
            sb.append(",\"performerName\":").append(jsonStr(a.getPerformerName()));
            sb.append(",\"contactName\":").append(jsonStr(a.getCustomerName()));
            sb.append(",\"createdAt\":").append(jsonStr(a.getCreatedAt() != null ? a.getCreatedAt().toString() : null));
            sb.append("}");
        }
        sb.append("]}");
        out.write(sb.toString());
    }

    private void writeDetail(PrintWriter out, HttpServletRequest request) {
        int activityId = parseIntOr(request.getParameter("id"), 0);
        if (activityId <= 0) {
            out.write("{\"error\":\"invalid id\"}");
            return;
        }

        ActivityDAO dao = new ActivityDAO();
        Activity a = dao.getActivityById(activityId);
        if (a == null) {
            out.write("{\"error\":\"not found\"}");
            return;
        }

        StringBuilder sb = new StringBuilder("{");
        sb.append("\"activityId\":").append(a.getActivityId());
        sb.append(",\"activityType\":").append(jsonStr(a.getActivityType()));
        sb.append(",\"relatedType\":").append(jsonStr(a.getRelatedType()));
        sb.append(",\"relatedId\":").append(a.getRelatedId());
        sb.append(",\"subject\":").append(jsonStr(a.getSubject()));
        sb.append(",\"description\":").append(jsonStr(a.getDescription()));
        sb.append(",\"activityDate\":").append(jsonStr(a.getActivityDate() != null ? a.getActivityDate().toString() : null));
        sb.append(",\"durationMinutes\":").append(a.getDurationMinutes() != null ? a.getDurationMinutes() : "null");
        sb.append(",\"callDirection\":").append(jsonStr(a.getCallDirection()));
        sb.append(",\"callResult\":").append(jsonStr(a.getCallResult()));
        sb.append(",\"status\":").append(jsonStr(a.getStatus()));
        sb.append(",\"performerName\":").append(jsonStr(a.getPerformerName()));
        sb.append(",\"contactName\":").append(jsonStr(a.getCustomerName()));
        sb.append(",\"createdAt\":").append(jsonStr(a.getCreatedAt() != null ? a.getCreatedAt().toString() : null));
        sb.append("}");
        out.write(sb.toString());
    }

    private int parseIntOr(String s, int def) {
        if (s == null) return def;
        try { return Integer.parseInt(s); } catch (NumberFormatException e) { return def; }
    }

    private String jsonStr(String val) {
        if (val == null) return "null";
        return "\"" + val.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t") + "\"";
    }
}
