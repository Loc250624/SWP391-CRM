package controller.manager;

import dao.NotificationDAO;
import dao.UserDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Notification;
import model.Users;

@WebServlet(name = "ManagerNotificationCreateServlet", urlPatterns = {"/manager/notifications/create"})
public class ManagerNotificationCreateServlet extends HttpServlet {

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

        request.setAttribute("allUsers", userDAO.getAllUsers());
        request.setAttribute("ACTIVE_MENU", "NOTIFICATION_MANAGE");
        request.setAttribute("pageTitle", "Tạo thông báo");
        request.setAttribute("CONTENT_PAGE", "/view/manager/notification/notification-create.jsp");
        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

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

        String title      = request.getParameter("title");
        String summary     = request.getParameter("summary");
        String message     = request.getParameter("message");
        String priority    = request.getParameter("priority");
        String actionUrl   = request.getParameter("actionUrl");
        String targetType  = request.getParameter("targetType");

        String redirectUrl = request.getContextPath() + "/manager/notifications/create";

        // Validate title
        if (title == null || title.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Tiêu đề không được để trống");
            response.sendRedirect(redirectUrl);
            return;
        }

        // Resolve recipient user IDs
        List<Integer> recipientIds = new ArrayList<>();

        if ("ALL".equals(targetType)) {
            List<Users> all = userDAO.getAllUsers();
            for (Users u : all) {
                if (u.getUserId() != currentUser.getUserId()) {
                    recipientIds.add(u.getUserId());
                }
            }
        } else if ("ROLE".equals(targetType)) {
            String[] roles = request.getParameterValues("targetRoles");
            if (roles == null || roles.length == 0) {
                session.setAttribute("errorMessage", "Vui lòng chọn ít nhất một vai trò");
                response.sendRedirect(redirectUrl);
                return;
            }
            for (String role : roles) {
                List<Users> usersInRole = userDAO.getUsersByRoleCode(role.trim());
                for (Users u : usersInRole) {
                    if (!recipientIds.contains(u.getUserId())) {
                        recipientIds.add(u.getUserId());
                    }
                }
            }
        } else if ("INDIVIDUAL".equals(targetType)) {
            String[] userIdStrs = request.getParameterValues("targetUserIds");
            if (userIdStrs == null || userIdStrs.length == 0) {
                session.setAttribute("errorMessage", "Vui lòng chọn ít nhất một nhân viên");
                response.sendRedirect(redirectUrl);
                return;
            }
            for (String idStr : userIdStrs) {
                try {
                    recipientIds.add(Integer.parseInt(idStr.trim()));
                } catch (NumberFormatException ignored) {}
            }
        } else {
            session.setAttribute("errorMessage", "Loại đối tượng không hợp lệ");
            response.sendRedirect(redirectUrl);
            return;
        }

        if (recipientIds.isEmpty()) {
            session.setAttribute("errorMessage", "Không tìm thấy người nhận nào");
            response.sendRedirect(redirectUrl);
            return;
        }

        // Build notification
        Notification n = new Notification();
        n.setTitle(title.trim());
        n.setSummary(summary != null && !summary.trim().isEmpty() ? summary.trim() : title.trim());
        n.setMessage(message != null && !message.trim().isEmpty() ? message.trim() : null);
        n.setType("MANAGER_BROADCAST");
        n.setCategory("SYSTEM");
        n.setPriority(priority != null ? priority.trim() : "NORMAL");
        n.setActionUrl(actionUrl != null && !actionUrl.trim().isEmpty() ? actionUrl.trim() : null);
        n.setSenderId(currentUser.getUserId());
        n.setIsSystem(false);
        n.setIsSent(true);
        n.setTargetType(targetType);
        n.setTargetValue(targetType);

        NotificationDAO dao = new NotificationDAO();
        int notifId = dao.insertNotification(n);

        if (notifId > 0) {
            int sent = dao.insertRecipients(notifId, recipientIds, "IN_APP");
            session.setAttribute("successMessage",
                    "Đã gửi thông báo thành công đến " + sent + " người nhận");
        } else {
            session.setAttribute("errorMessage", "Gửi thông báo thất bại, vui lòng thử lại");
        }

        response.sendRedirect(redirectUrl);
    }
}
