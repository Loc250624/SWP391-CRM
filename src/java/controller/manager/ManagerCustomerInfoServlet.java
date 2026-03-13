package controller.manager;

import dao.CustomerDAO;
import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Customer;
import model.Users;

/**
 * GET /manager/task/customer-info?id={customerId}
 *
 * Returns JSON with customer details for AJAX auto-fill of the customer
 * category field in the task form. Only accessible by MANAGER role.
 */
@WebServlet(name = "ManagerCustomerInfoServlet", urlPatterns = {"/manager/task/customer-info"})
public class ManagerCustomerInfoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        // ── Auth check ──────────────────────────────────────────────────────
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"error\":\"Unauthorized\"}");
            return;
        }

        Users currentUser = (Users) session.getAttribute("user");
        UserDAO userDAO = new UserDAO();
        String roleCode = userDAO.getRoleCodeByUserId(currentUser.getUserId());

        if (!"MANAGER".equals(roleCode)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            out.print("{\"error\":\"Forbidden\"}");
            return;
        }

        // ── Validate id param ────────────────────────────────────────────────
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Missing customer id\"}");
            return;
        }

        int customerId;
        try {
            customerId = Integer.parseInt(idParam.trim());
            if (customerId <= 0) throw new NumberFormatException("non-positive");
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Invalid customer id\"}");
            return;
        }

        // ── Fetch customer from DB ───────────────────────────────────────────
        CustomerDAO customerDAO = new CustomerDAO();
        Customer customer = customerDAO.getCustomerById(customerId);

        if (customer == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            out.print("{\"error\":\"Customer not found\"}");
            return;
        }

        // ── Build JSON response (manual building avoids extra dependencies) ──
        String name     = escapeJson(customer.getFullName());
        String category = escapeJson(customer.getCustomerSegment());
        String phone    = escapeJson(customer.getPhone());
        String email    = escapeJson(customer.getEmail());

        out.print("{");
        out.print("\"customerId\":"  + customer.getCustomerId()  + ",");
        out.print("\"customerName\":\"" + name     + "\",");
        out.print("\"category\":\""     + category + "\",");
        out.print("\"phone\":\""        + phone    + "\",");
        out.print("\"email\":\""        + email    + "\"");
        out.print("}");
    }

    /** Escapes characters that are unsafe inside a JSON string value. */
    private String escapeJson(String value) {
        if (value == null) return "";
        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n")
                .replace("\t", "\\t");
    }
}
