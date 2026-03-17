package controller.manager;

import dao.LeadDAO;
import dao.LeadSourceDAO;
import dao.TaskDAO;
import dao.UserDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Lead;
import model.LeadSource;
import model.Task;
import model.Users;

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

        // Tab parameter: "unassigned" (default) or "assigned"
        String tab = request.getParameter("tab");
        if (tab == null || tab.trim().isEmpty()) tab = "unassigned";

        // Filter parameters
        String keyword      = request.getParameter("keyword");
        String statusFilter = request.getParameter("status");
        String sourceFilter = request.getParameter("source");
        String dateFrom     = request.getParameter("dateFrom");
        String dateTo       = request.getParameter("dateTo");

        Integer sourceId = null;
        if (sourceFilter != null && !sourceFilter.trim().isEmpty()) {
            try { sourceId = Integer.parseInt(sourceFilter); } catch (NumberFormatException ignored) {}
        }

        // Validate date format (yyyy-MM-dd)
        if (dateFrom != null && dateFrom.trim().isEmpty()) dateFrom = null;
        if (dateTo != null && dateTo.trim().isEmpty()) dateTo = null;

        // Pagination
        int page = 1, pageSize = 10;
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
        TaskDAO taskDAO = new TaskDAO();

        List<Lead> leads;
        int totalLeads;

        if ("all".equals(tab)) {
            // Tab 3: All leads
            leads = leadDAO.getAllLeadsFiltered(
                    keyword, statusFilter, sourceId, dateFrom, dateTo, offset, pageSize);
            totalLeads = leadDAO.countAllLeadsFiltered(
                    keyword, statusFilter, sourceId, dateFrom, dateTo);
        } else if ("assigned".equals(tab)) {
            // Tab 2: Leads assigned by this manager (via task_relations)
            leads = leadDAO.getAssignedLeadsByManager(
                    managerId, keyword, statusFilter, sourceId, dateFrom, dateTo, offset, pageSize);
            totalLeads = leadDAO.countAssignedLeadsByManager(
                    managerId, keyword, statusFilter, sourceId, dateFrom, dateTo);
        } else {
            // Tab 1: Unassigned leads — same logic as CRM Pool
            leads = leadDAO.getUnassignedLeadsForManager(
                    keyword, sourceId, dateFrom, dateTo, offset, pageSize);
            totalLeads = leadDAO.countUnassignedLeadsForManager(
                    keyword, sourceId, dateFrom, dateTo);
        }

        int totalPages = (int) Math.ceil((double) totalLeads / pageSize);
        if (totalPages < 1) totalPages = 1;

        // Team members for the assign-task modal — lấy theo role SALES + SUPPORT
        List<Users> salesUsers = userDAO.getUsersByRoleCode("SALES");
        List<Users> supportUsers = userDAO.getUsersByRoleCode("SUPPORT");
        List<Users> salesForAssign = new ArrayList<>(salesUsers);
        for (Users su : supportUsers) {
            boolean exists = false;
            for (Users u : salesForAssign) {
                if (u.getUserId() == su.getUserId()) { exists = true; break; }
            }
            if (!exists) salesForAssign.add(su);
        }

        // Build set of sales user IDs for JSP logic
        Set<Integer> salesUserIds = new HashSet<>();
        for (Users su : salesUsers) {
            salesUserIds.add(su.getUserId());
        }

        // Lead sources for filter dropdown
        List<LeadSource> leadSources = new LeadSourceDAO().getAllActiveSources();

        // Preload tasks per lead for progress modal and cache user names
        Map<Integer, List<Task>> leadTasksMap = new HashMap<>();
        Map<Integer, String> userNameMap = new HashMap<>();
        if ("assigned".equals(tab) || "all".equals(tab)) {
            Set<Integer> userIds = new HashSet<>();
            for (Lead ld : leads) {
                List<Task> tasks = taskDAO.getTasksByRelatedLead(ld.getLeadId());
                leadTasksMap.put(ld.getLeadId(), tasks);
                if (ld.getAssignedTo() != null) userIds.add(ld.getAssignedTo());
                if (ld.getCreatedBy() != null) userIds.add(ld.getCreatedBy());
                for (Task t : tasks) {
                    if (t.getAssignedTo() != null) userIds.add(t.getAssignedTo());
                    if (t.getCreatedBy() != null) userIds.add(t.getCreatedBy());
                }
            }
            for (Integer uid : userIds) {
                Users u = userDAO.getUserById(uid);
                if (u != null) {
                    String name = (u.getFirstName() != null ? u.getFirstName() : "")
                                + " "
                                + (u.getLastName()  != null ? u.getLastName()  : "");
                    userNameMap.put(uid, name.trim());
                }
            }
        }

        request.setAttribute("leads",          leads);
        request.setAttribute("totalLeads",     totalLeads);
        request.setAttribute("totalPages",     totalPages);
        request.setAttribute("currentPage",    page);
        request.setAttribute("teamMembers",    salesUsers);
        request.setAttribute("salesForAssign", salesForAssign);
        request.setAttribute("leadSources",    leadSources);
        request.setAttribute("leadTasksMap",   leadTasksMap);
        request.setAttribute("userNameMap",    userNameMap);
        request.setAttribute("salesUserIds",   salesUserIds);
        request.setAttribute("keyword",        keyword != null ? keyword : "");
        request.setAttribute("statusFilter",   statusFilter != null ? statusFilter : "");
        request.setAttribute("sourceFilter",   sourceFilter != null ? sourceFilter : "");
        request.setAttribute("dateFrom",       dateFrom != null ? dateFrom : "");
        request.setAttribute("dateTo",         dateTo != null ? dateTo : "");
        request.setAttribute("currentTab",     tab);
        request.setAttribute("currentUserId",  currentUser.getUserId());
        request.setAttribute("pageTitle",      "CRM - Quản lý Lead");
        request.setAttribute("ACTIVE_MENU",    "CRM_LEADS");
        request.setAttribute("CONTENT_PAGE",   "/view/manager/crm/lead-list.jsp");

        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp").forward(request, response);
    }
}
