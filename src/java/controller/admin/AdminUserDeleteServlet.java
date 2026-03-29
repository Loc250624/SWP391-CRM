package controller.admin;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import util.AuthorizationUtils;

@WebServlet(name = "AdminUserDeleteServlet", urlPatterns = {"/admin/user/delete"})
public class AdminUserDeleteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = (String) request.getSession().getAttribute("role");
        if (!AuthorizationUtils.hasPermission(role, AuthorizationUtils.USER_EDIT)) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        String action = request.getParameter("action"); // "deactivate" or "delete"

        if (idStr != null && !idStr.isEmpty()) {
            int userId = Integer.parseInt(idStr);
            UserDAO userDAO = new UserDAO();

            switch (action != null ? action : "deactivate") {
                case "delete":
                    userDAO.deleteUser(userId);
                    break;
                case "reactivate":
                    userDAO.setUserStatus(userId, "Active");
                    break;
                default: // "deactivate"
                    userDAO.setUserStatus(userId, "Inactive");
                    break;
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/user/list");
    }
}
