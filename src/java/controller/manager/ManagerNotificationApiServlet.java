package controller.manager;

import dao.NotificationDAO;
import dao.UserDAO;
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
import model.Users;
import util.NotificationUtil;

@WebServlet(name = "ManagerNotificationDataServlet", urlPatterns = {"/manager/notifications-data"})
public class ManagerNotificationApiServlet extends HttpServlet {

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
        PrintWriter out = response.getWriter();

        if ("count".equals(action)) {
            NotificationUtil.writeUnreadCount(out, userId);
        } else if ("list".equals(action)) {
            int limit = 20;
            try {
                String limitStr = request.getParameter("limit");
                if (limitStr != null) limit = Integer.parseInt(limitStr);
            } catch (NumberFormatException ignored) {}
            NotificationUtil.writeNotificationList(out, userId, limit);
        } else if ("listPage".equals(action)) {
            // Paged list for notification management page
            int offset = 0, limit = 15;
            boolean unreadOnly = "1".equals(request.getParameter("unreadOnly"));
            try {
                String o = request.getParameter("offset");
                if (o != null) offset = Integer.parseInt(o);
                String l = request.getParameter("limit");
                if (l != null) limit = Integer.parseInt(l);
            } catch (NumberFormatException ignored) {}
            NotificationUtil.writePagedNotificationList(out, userId, offset, limit, unreadOnly);
        } else if ("sentList".equals(action)) {
            // Sent notifications by this manager
            int limit = 30;
            String keyword = request.getParameter("keyword");
            try {
                String l = request.getParameter("limit");
                if (l != null) limit = Integer.parseInt(l);
            } catch (NumberFormatException ignored) {}
            NotificationUtil.writeSentNotificationList(out, userId, keyword, limit);
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
        PrintWriter out = response.getWriter();

        if ("markRead".equals(action)) {
            NotificationUtil.handleMarkRead(out, userId, request.getParameter("notificationId"));
        } else if ("markAllRead".equals(action)) {
            NotificationUtil.handleMarkAllRead(out, userId);
        } else if ("dismiss".equals(action)) {
            NotificationUtil.handleDismiss(out, userId, request.getParameter("notificationId"));
        } else {
            out.write("{\"error\":\"invalid action\"}");
        }
    }
}
