package controller.admin;

import dao.CustomerCoreDAO;
import dao.CustomerTagDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;
import model.CustomerTag;

@WebServlet(name = "AdminCustomerFormServlet", urlPatterns = {"/admin/customer/form"})
public class AdminCustomerFormServlet extends HttpServlet {

    private CustomerCoreDAO dao   = new CustomerCoreDAO();
    private CustomerTagDAO tagDAO = new CustomerTagDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        Customer customer = null;
        List<Integer> checkedTagIds = new ArrayList<>();

        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idStr.trim());
                customer = dao.getCustomerById(id);
                if (customer != null) {
                    checkedTagIds = tagDAO.getTagIdsByCustomerId(id);
                }
            } catch (NumberFormatException ignored) {}
        }

        List<CustomerTag> allTags = tagDAO.getAllActiveTags();

        request.setAttribute("customer",      customer);
        request.setAttribute("allTags",       allTags);
        request.setAttribute("checkedTagIds", checkedTagIds);
        request.setAttribute("CONTENT_PAGE", "/view/admin/customercore/form.jsp");
        request.setAttribute("pageTitle", (customer != null ? "Sửa Khách hàng" : "Thêm Khách hàng"));
        request.setAttribute("ACTIVE_MENU", "CUSTOMER_LIST");
        request.getRequestDispatcher("/view/admin/layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr       = request.getParameter("id");
        String fullName    = request.getParameter("fullName");
        String email       = request.getParameter("email");
        String phone       = request.getParameter("phone");
        String status      = request.getParameter("status");
        String segment     = request.getParameter("segment");
        String city        = request.getParameter("city");
        String[] tagIdStrs = request.getParameterValues("tagIds");

        List<String> errors = new ArrayList<>();
        if (fullName == null || fullName.trim().isEmpty()) errors.add("Full name is required.");
        if (email    == null || email.trim().isEmpty())    errors.add("Email is required.");
        if (phone    == null || phone.trim().isEmpty())    errors.add("Phone is required.");

        List<Integer> tagIds = new ArrayList<>();
        if (tagIdStrs != null) {
            for (String t : tagIdStrs) {
                try { tagIds.add(Integer.parseInt(t)); } catch (NumberFormatException ignored) {}
            }
        }

        if (!errors.isEmpty()) {
            Customer customer = new Customer();
            customer.setFullName(fullName);
            customer.setEmail(email);
            customer.setPhone(phone);
            customer.setStatus(status);
            customer.setCustomerSegment(segment);
            customer.setCity(city);
            if (idStr != null && !idStr.trim().isEmpty()) {
                try { customer.setCustomerId(Integer.parseInt(idStr)); } catch (NumberFormatException ignored) {}
            }
            request.setAttribute("customer",      customer);
            request.setAttribute("errors",        errors);
            request.setAttribute("allTags",       tagDAO.getAllActiveTags());
            request.setAttribute("checkedTagIds", tagIds);
            request.setAttribute("CONTENT_PAGE", "/view/admin/customercore/form.jsp");
            request.setAttribute("pageTitle", (idStr != null ? "Sửa Khách hàng" : "Thêm Khách hàng"));
            request.setAttribute("ACTIVE_MENU", "CUSTOMER_LIST");
            request.getRequestDispatcher("/view/admin/layout.jsp").forward(request, response);
            return;
        }

        if (idStr != null && !idStr.trim().isEmpty()) {
            // UPDATE
            try {
                int id = Integer.parseInt(idStr.trim());
                Customer c = dao.getCustomerById(id);
                if (c != null) {
                    c.setFullName(fullName.trim());
                    c.setEmail(email.trim());
                    c.setPhone(phone.trim());
                    c.setStatus(status);
                    c.setCustomerSegment(segment);
                    c.setCity(city != null ? city.trim() : null);
                    dao.updateCustomer(c);
                    tagDAO.assignTags(id, tagIds, null);
                }
            } catch (NumberFormatException ignored) {}
        } else {
            // CREATE
            Customer c = new Customer();
            c.setFullName(fullName.trim());
            c.setEmail(email.trim());
            c.setPhone(phone.trim());
            c.setStatus(status);
            c.setCustomerSegment(segment);
            c.setCity(city != null ? city.trim() : null);
            int newId = dao.createCustomer(c);
            if (newId > 0) {
                tagDAO.assignTags(newId, tagIds, null);
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/customer/list");
    }
}
