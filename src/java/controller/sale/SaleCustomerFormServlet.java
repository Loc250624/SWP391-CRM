package controller.sale;

import dao.CustomerDAO;
import dao.LeadSourceDAO;
import enums.CustomerSegment;
import enums.CustomerStatus;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Customer;
import model.LeadSource;

@WebServlet(name = "SaleCustomerFormServlet", urlPatterns = {"/sale/customer/form"})
public class SaleCustomerFormServlet extends HttpServlet {

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

        String customerIdParam = request.getParameter("id");
        Customer customer = null;

        if (customerIdParam != null && !customerIdParam.isEmpty()) {
            try {
                int customerId = Integer.parseInt(customerIdParam);
                customer = customerDAO.getCustomerById(customerId);

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

                request.setAttribute("mode", "edit");
                request.setAttribute("customer", customer);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/sale/customer/list");
                return;
            }
        } else {
            request.setAttribute("mode", "create");
        }

        request.setAttribute("customerStatuses", CustomerStatus.values());
        request.setAttribute("customerSegments", CustomerSegment.values());

        List<LeadSource> sources = leadSourceDAO.getAllActiveSources();
        request.setAttribute("leadSources", sources);

        request.setAttribute("ACTIVE_MENU", "CUSTOMER_FORM");
        request.setAttribute("pageTitle", customerIdParam != null ? "Edit Customer" : "Create New Customer");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/customer/form.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String customerIdParam = request.getParameter("customerId");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String dobStr = request.getParameter("dateOfBirth");
        String gender = request.getParameter("gender");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String sourceIdParam = request.getParameter("sourceId");
        String customerSegment = request.getParameter("customerSegment");
        String status = request.getParameter("status");
        String notes = request.getParameter("notes");
        String emailOptOutStr = request.getParameter("emailOptOut");
        String smsOptOutStr = request.getParameter("smsOptOut");

        // Validation
        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("error", "Ho ten la bat buoc!");
            doGet(request, response);
            return;
        }

        Customer customer = new Customer();
        boolean isEdit = false;

        if (customerIdParam != null && !customerIdParam.isEmpty()) {
            isEdit = true;
            try {
                customer.setCustomerId(Integer.parseInt(customerIdParam));
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid customer ID!");
                doGet(request, response);
                return;
            }
        }

        customer.setFullName(fullName.trim());
        customer.setEmail(email != null && !email.trim().isEmpty() ? email.trim() : null);
        customer.setPhone(phone != null && !phone.trim().isEmpty() ? phone.trim() : null);

        if (dobStr != null && !dobStr.trim().isEmpty()) {
            try {
                customer.setDateOfBirth(LocalDate.parse(dobStr));
            } catch (Exception e) {
                customer.setDateOfBirth(null);
            }
        }

        customer.setGender(gender != null && !gender.trim().isEmpty() ? gender.trim() : null);
        customer.setAddress(address != null && !address.trim().isEmpty() ? address.trim() : null);
        customer.setCity(city != null && !city.trim().isEmpty() ? city.trim() : null);
        customer.setCustomerSegment(customerSegment != null && !customerSegment.isEmpty() ? customerSegment : "New");
        customer.setStatus(status != null && !status.isEmpty() ? status : "Active");
        customer.setNotes(notes != null && !notes.trim().isEmpty() ? notes.trim() : null);
        customer.setEmailOptOut("on".equals(emailOptOutStr));
        customer.setSmsOptOut("on".equals(smsOptOutStr));
        customer.setTotalCourses(0);
        customer.setTotalSpent(BigDecimal.ZERO);

        if (sourceIdParam != null && !sourceIdParam.isEmpty()) {
            try {
                customer.setSourceId(Integer.parseInt(sourceIdParam));
            } catch (NumberFormatException e) {
                customer.setSourceId(null);
            }
        }

        Integer currentUserId = 1;
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            try {
                currentUserId = (Integer) session.getAttribute("userId");
            } catch (Exception e) {
            }
        }

        if (!isEdit) {
            customer.setCreatedBy(currentUserId);
            customer.setOwnerId(currentUserId);
        }

        boolean success;
        if (isEdit) {
            success = customerDAO.updateCustomer(customer);
        } else {
            success = customerDAO.insertCustomer(customer);
        }

        if (success) {
            response.sendRedirect(request.getContextPath() + "/sale/customer/list?success=" +
                    (isEdit ? "updated" : "created"));
        } else {
            request.setAttribute("error", "Luu customer that bai. Vui long thu lai.");
            request.setAttribute("customer", customer);
            doGet(request, response);
        }
    }
}
