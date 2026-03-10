package controller.manager;

import dao.CustomerDAO;
import dao.LeadDAO;
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
import model.Customer;
import model.Lead;
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

        String keyword = request.getParameter("keyword");

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

        // Fetch unassigned leads and customers separately
        LeadDAO leadDAO         = new LeadDAO();
        CustomerDAO customerDAO = new CustomerDAO();

        List<Lead> poolLeads         = leadDAO.getPoolLeads(departmentId, keyword, offset, pageSize);
        int totalLeads               = leadDAO.countPoolLeads(departmentId, keyword);

        List<Customer> poolCustomers = customerDAO.getPoolCustomers(departmentId, keyword, offset, pageSize);
        int totalCustomers           = customerDAO.countPoolCustomers(departmentId, keyword);

        int totalLeadPages    = Math.max(1, (int) Math.ceil((double) totalLeads / pageSize));
        int totalCustomerPages = Math.max(1, (int) Math.ceil((double) totalCustomers / pageSize));

        // Source name map for display
        List<LeadSource> sources = new LeadSourceDAO().getAllActiveSources();
        Map<Integer, String> sourceMap = new HashMap<>();
        for (LeadSource s : sources) sourceMap.put(s.getSourceId(), s.getSourceName());

        // Team members for assign-task modal
        List<Users> teamMembers    = userDAO.getUsersByDepartment(departmentId);
        List<Users> salesForAssign = new ArrayList<>();
        for (Users u : teamMembers) {
            if (u.getUserId() != managerId) salesForAssign.add(u);
        }

        request.setAttribute("poolLeads",          poolLeads);
        request.setAttribute("totalLeads",         totalLeads);
        request.setAttribute("totalLeadPages",     totalLeadPages);
        request.setAttribute("poolCustomers",      poolCustomers);
        request.setAttribute("totalCustomers",     totalCustomers);
        request.setAttribute("totalCustomerPages", totalCustomerPages);
        request.setAttribute("currentPage",        page);
        request.setAttribute("sourceMap",          sourceMap);
        request.setAttribute("salesForAssign",     salesForAssign);
        request.setAttribute("keyword",            keyword != null ? keyword : "");
        request.setAttribute("pageTitle",          "CRM Pool - Chưa được giao");
        request.setAttribute("ACTIVE_MENU",        "CRM_POOL");
        request.setAttribute("CONTENT_PAGE",       "/view/manager/crm/crm-pool.jsp");

        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp")
               .forward(request, response);
    }
}
