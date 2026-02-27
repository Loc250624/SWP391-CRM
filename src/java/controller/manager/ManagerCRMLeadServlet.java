package controller.manager;

import dao.LeadDAO;
import dao.LeadSourceDAO;
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
import model.LeadSource;
import model.Users;
import model.Lead;

@WebServlet(name = "ManagerCRMLeadServlet", urlPatterns = {"/manager/crm/leads"})
public class ManagerCRMLeadServlet extends HttpServlet {

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

        // Filter parameters (task-based filter removed — list is always unassigned leads only)
        String keyword      = request.getParameter("keyword");
        String statusFilter = request.getParameter("status");
        String sourceFilter = request.getParameter("source");

        Integer sourceId = null;
        if (sourceFilter != null && !sourceFilter.trim().isEmpty()) {
            try { sourceId = Integer.parseInt(sourceFilter); } catch (NumberFormatException ignored) {}
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

        LeadDAO leadDAO = new LeadDAO();
        List<Lead> leads = leadDAO.getLeadsByManagerScope(
                departmentId, keyword, statusFilter, sourceId, offset, pageSize);
        int totalLeads = leadDAO.countLeadsByManagerScope(
                departmentId, keyword, statusFilter, sourceId);

        int totalPages = (int) Math.ceil((double) totalLeads / pageSize);
        if (totalPages < 1) totalPages = 1;

        // Team members for the assign-task modal
        List<Users> teamMembers = userDAO.getUsersByDepartment(departmentId);
        List<Users> salesForAssign = new ArrayList<>();
        for (Users u : teamMembers) {
            if (u.getUserId() != managerId) salesForAssign.add(u);
        }

        // Lead sources for filter dropdown
        List<LeadSource> leadSources = new LeadSourceDAO().getAllActiveSources();

        request.setAttribute("leads",          leads);
        request.setAttribute("totalLeads",     totalLeads);
        request.setAttribute("totalPages",     totalPages);
        request.setAttribute("currentPage",    page);
        request.setAttribute("teamMembers",    teamMembers);
        request.setAttribute("salesForAssign", salesForAssign);
        request.setAttribute("leadSources",    leadSources);
        request.setAttribute("keyword",        keyword != null ? keyword : "");
        request.setAttribute("statusFilter",   statusFilter != null ? statusFilter : "");
        request.setAttribute("sourceFilter",   sourceFilter != null ? sourceFilter : "");
        request.setAttribute("pageTitle",      "CRM - Lead chưa được giao");
        request.setAttribute("ACTIVE_MENU",    "CRM_LEADS");
        request.setAttribute("CONTENT_PAGE",   "/view/manager/crm/lead-list.jsp");

        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp").forward(request, response);
    }
}
