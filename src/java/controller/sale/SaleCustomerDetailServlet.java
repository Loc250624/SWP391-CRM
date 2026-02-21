package controller.sale;

import dao.CustomerDAO;
import dao.LeadSourceDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.SessionHelper;
import model.Customer;
import model.LeadSource;

@WebServlet(name = "SaleCustomerDetailServlet", urlPatterns = {"/sale/customer/detail"})
public class SaleCustomerDetailServlet extends HttpServlet {

    private CustomerDAO customerDAO = new CustomerDAO();
    private LeadSourceDAO leadSourceDAO = new LeadSourceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String customerIdParam = request.getParameter("id");

        if (customerIdParam == null || customerIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/sale/customer/list");
            return;
        }

        try {
            int customerId = Integer.parseInt(customerIdParam);

            Integer currentUserId = SessionHelper.getLoggedInUserId(request);
            if (currentUserId == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            Customer customer = customerDAO.getCustomerById(customerId);

            if (customer == null) {
                response.sendRedirect(request.getContextPath() + "/sale/customer/list");
                return;
            }

            boolean hasPermission = (customer.getCreatedBy() != null && customer.getCreatedBy().equals(currentUserId))
                    || (customer.getOwnerId() != null && customer.getOwnerId().equals(currentUserId));

            if (!hasPermission) {
                response.sendRedirect(request.getContextPath() + "/sale/customer/list?error=no_permission");
                return;
            }

            // Get source name
            String sourceName = null;
            if (customer.getSourceId() != null) {
                LeadSource source = leadSourceDAO.getSourceById(customer.getSourceId());
                if (source != null) {
                    sourceName = source.getSourceName();
                }
            }

            request.setAttribute("customer", customer);
            request.setAttribute("sourceName", sourceName);
            request.setAttribute("ACTIVE_MENU", "CUSTOMER_LIST");
            request.setAttribute("pageTitle", "Customer Detail - " + customer.getFullName());
            request.setAttribute("CONTENT_PAGE", "/view/sale/pages/customer/detail.jsp");
            request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/sale/customer/list");
        }
    }
}
