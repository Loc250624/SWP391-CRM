package controller.admin;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Users;
import util.AuthorizationUtils;

@WebServlet(name = "AdminUserFormServlet", urlPatterns = { "/admin/user/form" })
public class AdminUserFormServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = (String) request.getSession().getAttribute("role");
        if (!AuthorizationUtils.hasPermission(role, AuthorizationUtils.USER_CREATE)) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        dao.RoleDAO roleDAO = new dao.RoleDAO();
        dao.UserRoleDAO userRoleDAO = new dao.UserRoleDAO();
        request.setAttribute("allRoles", roleDAO.getAllRoles());

        String idStr = request.getParameter("id");
        if (idStr != null) {
            int userId = Integer.parseInt(idStr);
            UserDAO userDAO = new UserDAO();
            Users user = userDAO.getUserById(userId);
            request.setAttribute("user", user);
            request.setAttribute("currentRoleId", userRoleDAO.getRoleIdByUserId(userId));
            request.setAttribute("pageTitle", "Chỉnh sửa Tài khoản");
        } else {
            request.setAttribute("pageTitle", "Thêm Tài khoản mới");
        }

        request.setAttribute("CONTENT_PAGE", "/view/admin/user/form.jsp");
        request.setAttribute("ACTIVE_MENU", "USER_MANAGEMENT");
        request.getRequestDispatcher("/view/admin/layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String currentRole = (String) request.getSession().getAttribute("role");
        if (!AuthorizationUtils.hasPermission(currentRole, AuthorizationUtils.USER_EDIT) &&
                !AuthorizationUtils.hasPermission(currentRole, AuthorizationUtils.USER_CREATE)) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        UserDAO userDAO = new UserDAO();
        dao.UserRoleDAO userRoleDAO = new dao.UserRoleDAO();

        String idStr = request.getParameter("id");
        String roleIdStr = request.getParameter("roleId");

        Users u = new Users();
        u.setFirstName(request.getParameter("firstName"));
        u.setLastName(request.getParameter("lastName"));
        u.setEmail(request.getParameter("email"));
        u.setPhone(request.getParameter("phone"));
        u.setEmployeeCode(request.getParameter("employeeCode"));
        u.setStatus(request.getParameter("status"));

        if (idStr != null && !idStr.isEmpty()) {
            // Update existing user
            int userId = Integer.parseInt(idStr);
            u.setUserId(userId);
            userDAO.updateUser(u);

            if (roleIdStr != null && !roleIdStr.isEmpty()) {
                int newRoleId = Integer.parseInt(roleIdStr);
                userRoleDAO.updateUserRole(userId, newRoleId);
            }
        } else {
            // Create new user
            int newUserId = userDAO.insertUser(u);
            if (newUserId > 0 && roleIdStr != null && !roleIdStr.isEmpty()) {
                int roleId = Integer.parseInt(roleIdStr);
                userRoleDAO.updateUserRole(newUserId, roleId);
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/user/list");
    }
}
