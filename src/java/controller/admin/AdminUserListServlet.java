package controller.admin;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import model.Users;
import util.AuthorizationUtils;

@WebServlet(name = "AdminUserListServlet", urlPatterns = { "/admin/user/list" })
public class AdminUserListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Final sanity check for permissions
        String role = (String) request.getSession().getAttribute("role");
        if (!AuthorizationUtils.hasPermission(role, AuthorizationUtils.USER_VIEW_LIST)) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        UserDAO userDAO = new UserDAO();
        dao.RoleDAO roleDAO = new dao.RoleDAO();

        List<Map<String, Object>> userList = userDAO.getAllUsersWithRoles();
        List<Map<String, Object>> allRoles = roleDAO.getAllRoles();

        request.setAttribute("userList", userList);
        request.setAttribute("allRoles", allRoles);
        request.setAttribute("CONTENT_PAGE", "/view/admin/user/list.jsp");
        request.setAttribute("pageTitle", "Quản lý Tài khoản");
        request.setAttribute("ACTIVE_MENU", "USER_MANAGEMENT");
        request.getRequestDispatcher("/view/admin/layout.jsp").forward(request, response);
    }
}
