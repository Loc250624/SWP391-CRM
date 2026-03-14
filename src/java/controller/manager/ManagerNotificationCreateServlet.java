package controller.manager;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
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

        request.setAttribute("ACTIVE_MENU", "NOTIFICATION_MANAGE");
        request.setAttribute("pageTitle", "Tạo thông báo");
        request.setAttribute("CONTENT_PAGE", "/view/manager/notification/notification-create.jsp");
        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp").forward(request, response);
    }
}
