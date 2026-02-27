package controller.manager;

import dao.CRMPoolDAO;
import dao.LeadSourceDAO;
import dao.UserDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CRMPoolItem;
import model.LeadSource;
import model.Users;

@WebServlet(name = "ManagerCRMPoolServlet", urlPatterns = {"/manager/crm/pool"})
public class ManagerCRMPoolServlet extends HttpServlet {

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

        // Filter parameters
        String keyword    = request.getParameter("keyword");
        String typeFilter = request.getParameter("type");   // "LEAD" | "CUSTOMER" | null = all

        // Normalize typeFilter
        if (typeFilter != null && !typeFilter.equals("LEAD") && !typeFilter.equals("CUSTOMER")) {
            typeFilter = null;
        }

        // Pagination
        int page = 1, pageSize = 20;
        try {
            String p = request.getParameter("page");
            if (p != null && !p.trim().isEmpty()) {
                int parsed = Integer.parseInt(p);
                if (parsed > 0) page = parsed;
            }
        } catch (NumberFormatException ignored) {}

        int offset       = (page - 1) * pageSize;
        int departmentId = currentUser.getDepartmentId();
        int managerId    = currentUser.getUserId();

        // Fetch pool items (UNION of unassigned Leads + Customers with no tasks)
        CRMPoolDAO poolDAO = new CRMPoolDAO();
        List<CRMPoolItem> poolItems = poolDAO.getPoolItems(
                departmentId, keyword, typeFilter, offset, pageSize);
        int totalItems = poolDAO.countPoolItems(departmentId, keyword, typeFilter);

        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages < 1) totalPages = 1;

        // Source name map for display (shared by both leads and customers)
        List<LeadSource> sources = new LeadSourceDAO().getAllActiveSources();
        Map<Integer, String> sourceMap = new HashMap<>();
        for (LeadSource s : sources) sourceMap.put(s.getSourceId(), s.getSourceName());

        // Team members for the assign-task modal
        List<Users> teamMembers    = userDAO.getUsersByDepartment(departmentId);
        List<Users> salesForAssign = new ArrayList<>();
        for (Users u : teamMembers) {
            if (u.getUserId() != managerId) salesForAssign.add(u);
        }

        request.setAttribute("poolItems",     poolItems);
        request.setAttribute("totalItems",    totalItems);
        request.setAttribute("totalPages",    totalPages);
        request.setAttribute("currentPage",   page);
        request.setAttribute("sourceMap",     sourceMap);
        request.setAttribute("salesForAssign", salesForAssign);
        request.setAttribute("keyword",       keyword != null ? keyword : "");
        request.setAttribute("typeFilter",    typeFilter != null ? typeFilter : "");
        request.setAttribute("pageTitle",     "CRM Pool - Chưa được giao");
        request.setAttribute("ACTIVE_MENU",   "CRM_POOL");
        request.setAttribute("CONTENT_PAGE",  "/view/manager/crm/crm-pool.jsp");

        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp")
               .forward(request, response);
    }
}
