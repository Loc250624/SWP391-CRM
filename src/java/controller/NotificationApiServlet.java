package controller;

import dao.NotificationDAO;
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
import model.Notification;
import model.NotificationRecipient;
import model.Users;

@WebServlet(name = "NotificationApiServlet", urlPatterns = {"/api/notifications"})
public class NotificationApiServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(401);
            response.getWriter().write("{\"error\":\"unauthorized\"}");
            return;
        }

        Users currentUser = (Users) session.getAttribute("user");
        int userId = currentUser.getUserId();
        String action = request.getParameter("action");

        NotificationDAO dao = new NotificationDAO();
        PrintWriter out = response.getWriter();

        if ("count".equals(action)) {
            int count = dao.countUnread(userId);
            out.write("{\"unreadCount\":" + count + "}");

        } else if ("list".equals(action)) {
            int limit = 20;
            try {
                String limitStr = request.getParameter("limit");
                if (limitStr != null) limit = Integer.parseInt(limitStr);
            } catch (NumberFormatException ignored) {}

            List<Map<String, Object>> rows = dao.getByUserId(userId, 0, limit);
            StringBuilder sb = new StringBuilder();
            sb.append("{\"unreadCount\":").append(dao.countUnread(userId));
            sb.append(",\"notifications\":[");

            for (int i = 0; i < rows.size(); i++) {
                Map<String, Object> row = rows.get(i);
                Notification n = (Notification) row.get("notification");
                NotificationRecipient nr = (NotificationRecipient) row.get("recipient");
                String senderName = (String) row.get("senderName");

                if (i > 0) sb.append(",");
                sb.append("{");
                sb.append("\"id\":").append(n.getNotificationId());
                sb.append(",\"title\":").append(jsonStr(n.getTitle()));
                sb.append(",\"summary\":").append(jsonStr(n.getSummary()));
                sb.append(",\"type\":").append(jsonStr(n.getType()));
                sb.append(",\"priority\":").append(jsonStr(n.getPriority()));
                sb.append(",\"actionUrl\":").append(jsonStr(n.getActionUrl()));
                sb.append(",\"senderName\":").append(jsonStr(senderName));
                sb.append(",\"isRead\":").append(nr.getIsRead());
                sb.append(",\"createdAt\":").append(jsonStr(
                        n.getCreatedAt() != null ? n.getCreatedAt().toString() : null));
                sb.append("}");
            }

            sb.append("]}");
            out.write(sb.toString());

        } else {
            out.write("{\"error\":\"invalid action\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(401);
            response.getWriter().write("{\"error\":\"unauthorized\"}");
            return;
        }

        Users currentUser = (Users) session.getAttribute("user");
        int userId = currentUser.getUserId();
        String action = request.getParameter("action");

        NotificationDAO dao = new NotificationDAO();
        PrintWriter out = response.getWriter();

        if ("markRead".equals(action)) {
            String idStr = request.getParameter("notificationId");
            if (idStr != null) {
                try {
                    int notifId = Integer.parseInt(idStr);
                    dao.markAsRead(notifId, userId);
                    out.write("{\"success\":true}");
                } catch (NumberFormatException e) {
                    out.write("{\"error\":\"invalid id\"}");
                }
            } else {
                out.write("{\"error\":\"missing notificationId\"}");
            }

        } else if ("markAllRead".equals(action)) {
            int count = dao.markAllAsRead(userId);
            out.write("{\"success\":true,\"count\":" + count + "}");

        } else if ("dismiss".equals(action)) {
            String idStr = request.getParameter("notificationId");
            if (idStr != null) {
                try {
                    int notifId = Integer.parseInt(idStr);
                    dao.dismiss(notifId, userId);
                    out.write("{\"success\":true}");
                } catch (NumberFormatException e) {
                    out.write("{\"error\":\"invalid id\"}");
                }
            } else {
                out.write("{\"error\":\"missing notificationId\"}");
            }

        } else {
            out.write("{\"error\":\"invalid action\"}");
        }
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
