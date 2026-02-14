package controller.sale;

import dao.CustomerDAO;
import dao.LeadSourceDAO;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Customer;
import model.LeadSource;

@WebServlet(name = "SaleCustomerListServlet", urlPatterns = {"/sale/customer/list"})
public class SaleCustomerListServlet extends HttpServlet {

    private CustomerDAO customerDAO = new CustomerDAO();
    private LeadSourceDAO leadSourceDAO = new LeadSourceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer currentUserId = 1;
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            try {
                currentUserId = (Integer) session.getAttribute("userId");
            } catch (Exception e) {
            }
        }

        // Get filter parameters
        String statusFilter = request.getParameter("status");
        String segmentFilter = request.getParameter("segment");
        String searchQuery = request.getParameter("search");

        // Load customers
        List<Customer> customerList = customerDAO.getCustomersBySalesUser(currentUserId);
        if (customerList == null) {
            customerList = new java.util.ArrayList<>();
        }

        // Statistics BEFORE filtering
        int totalCustomers = customerList.size();
        long activeCustomers = customerList.stream().filter(c -> "Active".equals(c.getStatus())).count();
        long vipCustomers = customerList.stream().filter(c -> "VIP".equals(c.getCustomerSegment())).count();
        long newCustomers = customerList.stream().filter(c -> "New".equals(c.getCustomerSegment())).count();

        // Apply status filter
        if (statusFilter != null && !statusFilter.isEmpty()) {
            customerList = customerList.stream()
                    .filter(c -> statusFilter.equals(c.getStatus()))
                    .collect(Collectors.toList());
        }

        // Apply segment filter
        if (segmentFilter != null && !segmentFilter.isEmpty()) {
            customerList = customerList.stream()
                    .filter(c -> segmentFilter.equals(c.getCustomerSegment()))
                    .collect(Collectors.toList());
        }

        // Apply search filter
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            String query = searchQuery.trim().toLowerCase();
            customerList = customerList.stream()
                    .filter(c -> (c.getFullName() != null && c.getFullName().toLowerCase().contains(query))
                            || (c.getEmail() != null && c.getEmail().toLowerCase().contains(query))
                            || (c.getPhone() != null && c.getPhone().contains(query))
                            || (c.getCity() != null && c.getCity().toLowerCase().contains(query))
                            || (c.getCustomerCode() != null && c.getCustomerCode().toLowerCase().contains(query)))
                    .collect(Collectors.toList());
        }

        // Source name mapping
        List<LeadSource> sources = leadSourceDAO.getAllActiveSources();
        Map<Integer, String> sourceNameMap = new HashMap<>();
        if (sources != null) {
            for (LeadSource src : sources) {
                sourceNameMap.put(src.getSourceId(), src.getSourceName());
            }
        }

        // Pagination
        int pageSize = 10;
        int totalItems = customerList.size();
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try { currentPage = Math.max(1, Integer.parseInt(pageParam)); } catch (NumberFormatException e) { }
        }
        if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;
        int fromIndex = (currentPage - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalItems);
        List<Customer> pagedList = totalItems > 0 ? customerList.subList(fromIndex, toIndex) : customerList;

        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);

        // Pass data to JSP
        request.setAttribute("customerList", pagedList);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("activeCustomers", activeCustomers);
        request.setAttribute("vipCustomers", vipCustomers);
        request.setAttribute("newCustomers", newCustomers);
        request.setAttribute("sourceNameMap", sourceNameMap);

        // Keep filter state
        request.setAttribute("filterStatus", statusFilter);
        request.setAttribute("filterSegment", segmentFilter);
        request.setAttribute("searchQuery", searchQuery);

        // Success/error messages
        String success = request.getParameter("success");
        if ("created".equals(success)) {
            request.setAttribute("successMessage", "Tao customer thanh cong!");
        } else if ("updated".equals(success)) {
            request.setAttribute("successMessage", "Cap nhat customer thanh cong!");
        } else if ("deleted".equals(success)) {
            request.setAttribute("successMessage", "Xoa customer thanh cong!");
        }

        request.setAttribute("ACTIVE_MENU", "CUSTOMER_LIST");
        request.setAttribute("pageTitle", "Customer Management");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/customer/list.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer currentUserId = 1;
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            try {
                currentUserId = (Integer) session.getAttribute("userId");
            } catch (Exception e) {
            }
        }

        String action = request.getParameter("action");
        String customerIdParam = request.getParameter("customerId");

        if ("delete".equals(action) && customerIdParam != null) {
            try {
                int customerId = Integer.parseInt(customerIdParam);
                Customer customer = customerDAO.getCustomerById(customerId);

                if (customer == null) {
                    response.sendRedirect(request.getContextPath() + "/sale/customer/list?error=not_found");
                    return;
                }

                boolean hasPermission = (customer.getCreatedBy() != null && customer.getCreatedBy().equals(currentUserId))
                        || (customer.getOwnerId() != null && customer.getOwnerId().equals(currentUserId));

                if (!hasPermission) {
                    response.sendRedirect(request.getContextPath() + "/sale/customer/list?error=no_permission");
                    return;
                }

                boolean success = customerDAO.deleteCustomer(customerId);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/sale/customer/list?success=deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/sale/customer/list?error=delete_failed");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/sale/customer/list?error=invalid_id");
            }
        } else {
            doGet(request, response);
        }
    }
}
