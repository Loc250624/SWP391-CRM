package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import util.AuthorizationUtils;

@WebServlet(name = "AdminRoleListServlet", urlPatterns = {"/admin/role/list"})
public class AdminRoleListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String role = (String) request.getSession().getAttribute("role");
        if (!AuthorizationUtils.hasPermission(role, AuthorizationUtils.ROLE_VIEW_LIST)) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        // Since we can't edit the database, we might just display the hardcoded rules
        // or fetch roles from database and show their "static" permissions.
        
        request.setAttribute("CONTENT_PAGE", "/view/admin/role/list.jsp");
        request.setAttribute("pageTitle", "Phân quyền hệ thống");
        request.setAttribute("ACTIVE_MENU", "ROLE_MANAGEMENT");
        request.getRequestDispatcher("/view/admin/layout.jsp").forward(request, response);
    }
}
