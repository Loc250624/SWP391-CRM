package controller.manager;

import dao.CustomerDAO;
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
import model.Customer;
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
        String roleCode = userDAO.getRoleCodeByUserId(currentUser.getUserId());

        if (!"MANAGER".equals(roleCode)) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        // Filter parameters (list always shows unassigned customers only)
        String keyword      = request.getParameter("keyword");
        String statusFilter = request.getParameter("status");

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

        CustomerDAO customerDAO = new CustomerDAO();
        List<Customer> customers = customerDAO.getCustomersByManagerScope(
                departmentId, keyword, statusFilter, offset, pageSize);
        int totalCustomers = customerDAO.countCustomersByManagerScope(
                departmentId, keyword, statusFilter);

        int totalPages = (int) Math.ceil((double) totalCustomers / pageSize);
        if (totalPages < 1) totalPages = 1;

        // Team members for the assign-task modal
        List<Users> teamMembers = userDAO.getUsersByDepartment(departmentId);
        List<Users> salesForAssign = new ArrayList<>();
        for (Users u : teamMembers) {
            if (u.getUserId() != managerId) salesForAssign.add(u);
        }

        request.setAttribute("customers",      customers);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalPages",     totalPages);
        request.setAttribute("currentPage",    page);
        request.setAttribute("teamMembers",    teamMembers);
        request.setAttribute("salesForAssign", salesForAssign);
        request.setAttribute("keyword",        keyword != null ? keyword : "");
        request.setAttribute("statusFilter",   statusFilter != null ? statusFilter : "");
        request.setAttribute("pageTitle",      "CRM - Khách hàng chưa được giao");
        request.setAttribute("ACTIVE_MENU",    "CRM_CUSTOMERS");
        request.setAttribute("CONTENT_PAGE",   "/view/manager/crm/customer-list.jsp");

        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp").forward(request, response);
    }
}
