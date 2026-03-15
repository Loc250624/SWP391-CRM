package controller.admin;

import dao.AuditLogDAO;
import dao.CustomerCoreDAO;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;
import util.AuthorizationUtils;

@WebServlet(name = "AdminCustomerActivityLogServlet", urlPatterns = { "/admin/customer/activity-log" })
public class AdminCustomerActivityLogServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = (String) request.getSession().getAttribute("role");
        if (!AuthorizationUtils.hasPermission(role, "ROLE_VIEW_LIST")) { // Assuming generic perm
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/customer/list");
            return;
        }

        try {
            int id = Integer.parseInt(idStr.trim());
            AuditLogDAO auditLogDAO = new AuditLogDAO();
            CustomerCoreDAO customerDAO = new CustomerCoreDAO();

            Customer customer = customerDAO.getCustomerById(id);
            if (customer == null) {
                response.sendRedirect(request.getContextPath() + "/admin/customer/list");
                return;
            }

            List<Map<String, Object>> auditLogs = auditLogDAO.getLogsByEntity("Customer", id);

            request.setAttribute("customer", customer);
            request.setAttribute("auditLogs", auditLogs);
            request.setAttribute("CONTENT_PAGE", "/view/admin/customercore/activity_log.jsp");
            request.setAttribute("pageTitle", "Nhật ký hoạt động: " + customer.getFullName());
            request.setAttribute("ACTIVE_MENU", "CUSTOMER_LIST");
            request.getRequestDispatcher("/view/admin/layout.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/customer/list");
        }
    }
}
