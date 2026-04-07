package controller.manager;

import dao.AuditLogDAO;
import dao.UserDAO;
import model.AuditLog;
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

@WebServlet(name = "ManagerAuditLogServlet", urlPatterns = {"/manager/audit-log"})
public class ManagerAuditLogServlet extends HttpServlet {

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

        request.setAttribute("ACTIVE_MENU", "AUDIT_LOG");
        request.setAttribute("pageTitle", "Audit Logs");
        request.setAttribute("CONTENT_PAGE", "/view/manager/audit/audit-log.jsp");
        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp").forward(request, response);
    }

    private void writeKpi(PrintWriter out) {
        AuditLogDAO dao = new AuditLogDAO();
        Map<String, Integer> kpi = dao.getKpi();

        out.write("{\"total\":" + kpi.getOrDefault("total", 0)
                + ",\"changes\":" + kpi.getOrDefault("changes", 0)
                + ",\"activeUsers\":" + kpi.getOrDefault("activeUsers", 0)
                + ",\"distinctIps\":" + kpi.getOrDefault("distinctIps", 0)
                + "}");
    }

    private void writeLogs(PrintWriter out, HttpServletRequest request) {
        AuditLogDAO dao = new AuditLogDAO();

        String actionFilter = request.getParameter("actionFilter");
        String entityType = request.getParameter("entityType");
        String keyword = request.getParameter("keyword");
        int offset = parseIntOr(request.getParameter("offset"), 0);
        int limit = parseIntOr(request.getParameter("limit"), 20);

        if (actionFilter != null && actionFilter.isEmpty()) actionFilter = null;
        if (entityType != null && entityType.isEmpty()) entityType = null;
        if (keyword != null && keyword.isEmpty()) keyword = null;

        List<AuditLog> logs = dao.getListPaged(actionFilter, entityType, keyword, offset, limit);
        int total = dao.countTotal(actionFilter, entityType, keyword);

        StringBuilder sb = new StringBuilder();
        sb.append("{\"total\":").append(total).append(",\"logs\":[");
        for (int i = 0; i < logs.size(); i++) {
            AuditLog l = logs.get(i);
            if (i > 0) sb.append(",");
            sb.append("{");
            sb.append("\"logId\":").append(l.getLogId());
            sb.append(",\"userId\":").append(l.getUserId() != null ? l.getUserId() : "null");
            sb.append(",\"action\":").append(jsonStr(l.getAction()));
            sb.append(",\"entityType\":").append(jsonStr(l.getEntityType()));
            sb.append(",\"entityId\":").append(l.getEntityId() != null ? l.getEntityId() : "null");
            sb.append(",\"oldValues\":").append(jsonStr(l.getOldValues()));
            sb.append(",\"newValues\":").append(jsonStr(l.getNewValues()));
            sb.append(",\"ipAddress\":").append(jsonStr(l.getIpAddress()));
            sb.append(",\"userAgent\":").append(jsonStr(l.getUserAgent()));
            sb.append(",\"userName\":").append(jsonStr(l.getUserName()));
            sb.append(",\"userEmail\":").append(jsonStr(l.getUserEmail()));
            sb.append(",\"createdAt\":").append(jsonStr(l.getCreatedAt() != null ? l.getCreatedAt().toString() : null));
            sb.append("}");
        }
        sb.append("]}");
        out.write(sb.toString());
    }

    private void writeDetail(PrintWriter out, HttpServletRequest request) {
        int logId = parseIntOr(request.getParameter("id"), 0);
        if (logId <= 0) {
            out.write("{\"error\":\"invalid id\"}");
            return;
        }

        AuditLogDAO dao = new AuditLogDAO();
        AuditLog l = dao.getById(logId);
        if (l == null) {
            out.write("{\"error\":\"not found\"}");
            return;
        }

        StringBuilder sb = new StringBuilder("{");
        sb.append("\"logId\":").append(l.getLogId());
        sb.append(",\"userId\":").append(l.getUserId() != null ? l.getUserId() : "null");
        sb.append(",\"action\":").append(jsonStr(l.getAction()));
        sb.append(",\"entityType\":").append(jsonStr(l.getEntityType()));
        sb.append(",\"entityId\":").append(l.getEntityId() != null ? l.getEntityId() : "null");
        sb.append(",\"oldValues\":").append(jsonStr(l.getOldValues()));
        sb.append(",\"newValues\":").append(jsonStr(l.getNewValues()));
        sb.append(",\"ipAddress\":").append(jsonStr(l.getIpAddress()));
        sb.append(",\"userAgent\":").append(jsonStr(l.getUserAgent()));
        sb.append(",\"userName\":").append(jsonStr(l.getUserName()));
        sb.append(",\"userEmail\":").append(jsonStr(l.getUserEmail()));
        sb.append(",\"createdAt\":").append(jsonStr(l.getCreatedAt() != null ? l.getCreatedAt().toString() : null));
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
