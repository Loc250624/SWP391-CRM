package controller.customersuccess;

import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;
import util.NotificationUtil;

@WebServlet(name = "SupportNotificationServlet", urlPatterns = {"/support/notifications"})
public class SupportNotificationServlet extends HttpServlet {

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

        String action = request.getParameter("action");

        // JSON API requests
        if (action != null) {
            response.setContentType("application/json;charset=UTF-8");
            int userId = currentUser.getUserId();
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
                int offset = 0, limit = 15;
                boolean unreadOnly = "1".equals(request.getParameter("unreadOnly"));
                try {
                    String o = request.getParameter("offset");
                    if (o != null) offset = Integer.parseInt(o);
                    String l = request.getParameter("limit");
                    if (l != null) limit = Integer.parseInt(l);
                } catch (NumberFormatException ignored) {}
                NotificationUtil.writePagedNotificationList(out, userId, offset, limit, unreadOnly);
            } else {
                out.write("{\"error\":\"invalid action\"}");
            }
            return;
        }

        // Page render
        request.setAttribute("pageTitle", "Thông báo");
        request.setAttribute("contentPage", "/view/customersuccess/pages/notification-list.jsp");
        request.getRequestDispatcher("/view/customersuccess/pages/main_layout.jsp").forward(request, response);
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
