package controller.manager;

import dao.CustomerDAO;
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
import model.LeadSource;
import model.Users;

@WebServlet(name = "ManagerCRMCustomerServlet", urlPatterns = {"/manager/crm/customers"})
public class ManagerCRMCustomerServlet extends HttpServlet {

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
        if (!"MANAGER".equals(userDAO.getRoleCodeByUserId(currentUser.getUserId()))) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        // Tab: "unassigned" (default) or "assigned"
        String tab = request.getParameter("tab");
        if (tab == null || tab.trim().isEmpty()) tab = "unassigned";

        // Filter parameters
        String keyword  = request.getParameter("keyword");
        String status   = request.getParameter("status");
        String segment  = request.getParameter("segment");
        String dateFrom = request.getParameter("dateFrom");
        String dateTo   = request.getParameter("dateTo");
        String course   = request.getParameter("course");

        // Pagination
        int page = 1, pageSize = 10;
        try {
            String p = request.getParameter("page");
            if (p != null && !p.trim().isEmpty()) {
                int parsed = Integer.parseInt(p);
                if (parsed > 0) page = parsed;
            }
        } catch (NumberFormatException ignored) {}

        int offset = (page - 1) * pageSize;
        CustomerDAO customerDAO = new CustomerDAO();

        List<Customer> customers;
        int totalCustomers;

        if ("assigned".equals(tab)) {
            customers = customerDAO.getAssignedCustomers(
                    keyword, status, segment, dateFrom, dateTo, course, offset, pageSize);
            totalCustomers = customerDAO.countAssignedCustomers(
                    keyword, status, segment, dateFrom, dateTo, course);
        } else {
            customers = customerDAO.getCustomersByManagerScope(
                    keyword, status, segment, dateFrom, dateTo, course, offset, pageSize);
            totalCustomers = customerDAO.countCustomersByManagerScope(
                    keyword, status, segment, dateFrom, dateTo, course);
        }

        int totalPages = (int) Math.ceil((double) totalCustomers / pageSize);
        if (totalPages < 1) totalPages = 1;

        // Sales + Support users for owner name display and assign
        List<Users> salesUsers = userDAO.getUsersByRoleCode("SALES");
        List<Users> supportUsers = userDAO.getUsersByRoleCode("SUPPORT");
        List<Users> allStaff = new ArrayList<>(salesUsers);
        for (Users su : supportUsers) {
            boolean exists = false;
            for (Users u : allStaff) {
                if (u.getUserId() == su.getUserId()) { exists = true; break; }
            }
            if (!exists) allStaff.add(su);
        }
        request.setAttribute("salesUsers", allStaff);

        // ── Pre-load detail data for popup modals ─────────────────────────
        LeadSourceDAO sourceDAO = new LeadSourceDAO();
        Map<Integer, String> sourceNameMap = new HashMap<>();
        Map<Integer, String> ownerNameMap = new HashMap<>();
        Map<Integer, List<Map<String, Object>>> enrolledCoursesMap = new HashMap<>();

        for (Customer c : customers) {
            // Source name
            if (c.getSourceId() != null && !sourceNameMap.containsKey(c.getSourceId())) {
                LeadSource src = sourceDAO.getSourceById(c.getSourceId());
                if (src != null) sourceNameMap.put(c.getSourceId(), src.getSourceName());
            }
            // Owner name
            if (c.getOwnerId() != null && !ownerNameMap.containsKey(c.getOwnerId())) {
                Users owner = userDAO.getUserById(c.getOwnerId());
                if (owner != null) {
                    String name = ((owner.getFirstName() != null ? owner.getFirstName() : "")
                            + " " + (owner.getLastName() != null ? owner.getLastName() : "")).trim();
                    ownerNameMap.put(c.getOwnerId(), name);
                }
            }
            // Enrolled courses
            enrolledCoursesMap.put(c.getCustomerId(), customerDAO.getEnrolledCourses(c.getCustomerId()));
        }

        request.setAttribute("sourceNameMap", sourceNameMap);
        request.setAttribute("ownerNameMap", ownerNameMap);
        request.setAttribute("enrolledCoursesMap", enrolledCoursesMap);

        request.setAttribute("customers",      customers);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalPages",     totalPages);
        request.setAttribute("currentPage",    page);
        request.setAttribute("activeTab",      tab);

        // Filter values for form persistence
        request.setAttribute("keyword",       keyword != null ? keyword : "");
        request.setAttribute("statusFilter",  status != null ? status : "");
        request.setAttribute("segmentFilter", segment != null ? segment : "");
        request.setAttribute("dateFrom",      dateFrom != null ? dateFrom : "");
        request.setAttribute("dateTo",        dateTo != null ? dateTo : "");
        request.setAttribute("courseFilter",  course != null ? course : "");

        // Dropdown options
        request.setAttribute("segmentOptions", customerDAO.getDistinctSegments());
        request.setAttribute("statusOptions",  customerDAO.getDistinctStatuses());
        request.setAttribute("courseOptions",   customerDAO.getDistinctCourseNames());

        // Counts for tab badges
        request.setAttribute("countUnassigned", customerDAO.countCustomersByManagerScope(
                null, null, null, null, null, null));
        request.setAttribute("countAssigned", customerDAO.countAssignedCustomers(
                null, null, null, null, null, null));

        request.setAttribute("currentUserId", currentUser.getUserId());
        request.setAttribute("pageTitle",    "CRM - Quản lý Khách hàng");
        request.setAttribute("ACTIVE_MENU",  "CRM_CUSTOMERS");
        request.setAttribute("CONTENT_PAGE", "/view/manager/crm/customer-list.jsp");

        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp").forward(request, response);
    }
}
