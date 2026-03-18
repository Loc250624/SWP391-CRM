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
import util.AuthorizationUtils;

@WebServlet(name = "AdminUserListServlet", urlPatterns = { "/admin/user/list" })
public class AdminUserListServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = (String) request.getSession().getAttribute("role");
        if (!AuthorizationUtils.hasPermission(role, AuthorizationUtils.USER_VIEW_LIST)) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        // --- Filter params ---
        String search   = request.getParameter("search");
        String roleCode = request.getParameter("roleCode");
        String status   = request.getParameter("status");

        // --- Pagination ---
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try { page = Math.max(1, Integer.parseInt(pageParam)); } catch (NumberFormatException ignored) {}
        }

        UserDAO userDAO     = new UserDAO();
        dao.RoleDAO roleDAO = new dao.RoleDAO();

        int totalUsers = userDAO.countUsersFiltered(search, roleCode, status);
        int totalPages = (int) Math.ceil((double) totalUsers / PAGE_SIZE);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        List<Map<String, Object>> userList = userDAO.getUsersFiltered(search, roleCode, status, page, PAGE_SIZE);
        List<Map<String, Object>> allRoles = roleDAO.getAllRoles();

        request.setAttribute("userList",   userList);
        request.setAttribute("allRoles",   allRoles);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("search",    search   != null ? search   : "");
        request.setAttribute("filterRole", roleCode != null ? roleCode : "");
        request.setAttribute("filterStatus", status != null ? status   : "");

        request.setAttribute("CONTENT_PAGE", "/view/admin/user/list.jsp");
        request.setAttribute("pageTitle",    "Quản lý Tài khoản");
        request.setAttribute("ACTIVE_MENU", "USER_MANAGEMENT");
        request.getRequestDispatcher("/view/admin/layout.jsp").forward(request, response);
    }
}
