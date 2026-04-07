package controller.admin;

import dao.ActivityDAO;
import dao.AuditLogDAO;
import dao.CustomerCoreDAO;
import dao.EnrollmentDAO;
import dao.CustomerTagDAO;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Activity;
import model.Customer;
import model.CustomerEnrollment;
import model.CustomerTag;
import util.AuthorizationUtils;

@WebServlet(name = "AdminCustomer360Servlet", urlPatterns = { "/admin/customer/360" })
public class AdminCustomer360Servlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = (String) request.getSession().getAttribute("role");
        if (!AuthorizationUtils.hasPermission(role, "CUSTOMER_VIEW_LIST")) { // Assuming generic perm
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

            CustomerCoreDAO customerDAO = new CustomerCoreDAO();
            ActivityDAO activityDAO = new ActivityDAO();
            EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
            CustomerTagDAO tagDAO = new CustomerTagDAO();
            AuditLogDAO auditLogDAO = new AuditLogDAO();

            Customer customer = customerDAO.getCustomerById(id);
            if (customer == null) {
                response.sendRedirect(request.getContextPath() + "/admin/customer/list");
                return;
            }

            List<Activity> activities = activityDAO.getActivitiesByCustomerId(id);
            List<CustomerEnrollment> enrollments = enrollmentDAO.getEnrollmentsByCustomerId(id);
            List<CustomerTag> tags = tagDAO.getTagsByCustomerId(id);
            List<Map<String, Object>> auditLogs = auditLogDAO.getLogsByEntity("Customer", id);

            request.setAttribute("customer", customer);
            request.setAttribute("activities", activities);
            request.setAttribute("enrollments", enrollments);
            request.setAttribute("tags", tags);
            request.setAttribute("auditLogs", auditLogs);

            request.setAttribute("CONTENT_PAGE", "/view/admin/customercore/detail360.jsp");
            request.setAttribute("pageTitle", "Customer 360 - " + customer.getFullName());
            request.setAttribute("ACTIVE_MENU", "CUSTOMER_LIST");
            request.getRequestDispatcher("/view/admin/layout.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/customer/list");
        }
    }
}
