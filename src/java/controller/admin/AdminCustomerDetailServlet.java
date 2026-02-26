package controller.admin;

import dao.CustomerCoreDAO;
import dao.CustomerTagDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;
import model.CustomerTag;

@WebServlet(name = "AdminCustomerDetailServlet", urlPatterns = {"/admin/customer/detail"})
public class AdminCustomerDetailServlet extends HttpServlet {

    private CustomerCoreDAO dao   = new CustomerCoreDAO();
    private CustomerTagDAO tagDAO = new CustomerTagDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/customer/list");
            return;
        }

        try {
            int id = Integer.parseInt(idStr.trim());
            Customer customer = dao.getCustomerById(id);
            if (customer == null) {
                response.sendRedirect(request.getContextPath() + "/admin/customer/list");
                return;
            }
            List<CustomerTag> tags = tagDAO.getTagsByCustomerId(id);
            request.setAttribute("customer", customer);
            request.setAttribute("tags", tags);
            request.setAttribute("CONTENT_PAGE", "/view/admin/customercore/detail.jsp");
            request.setAttribute("pageTitle", "Chi tiết Khách hàng");
            request.setAttribute("ACTIVE_MENU", "CUSTOMER_LIST");
            request.getRequestDispatcher("/view/admin/layout.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/customer/list");
        }
    }
}
