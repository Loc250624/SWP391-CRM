package controller.customercore;

import dao.CustomerCoreDAO;
import dao.CustomerTagDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "CustomerDetailServlet", urlPatterns = {"/customercore/customer/detail"})
public class CustomerDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idRaw = req.getParameter("id");
        if (idRaw == null || idRaw.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/customercore/customer/list");
            return;
        }

        int id;
        try { id = Integer.parseInt(idRaw); }
        catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/customercore/customer/list");
            return;
        }

        CustomerCoreDAO customerDAO = new CustomerCoreDAO();
        CustomerTagDAO assignDAO = new CustomerTagDAO();

        var customer = customerDAO.getCustomerById(id);
        if (customer == null) {
            resp.sendRedirect(req.getContextPath() + "/customercore/customer/list");
            return;
        }

        req.setAttribute("customer", customer);
        req.setAttribute("tags", assignDAO.getTagsByCustomerId(id));

        req.setAttribute("CONTENT_PAGE", "/view/customercore/detail.jsp");
        req.setAttribute("pageTitle", "Customer Details");
        req.setAttribute("ACTIVE_MENU", "CUSTOMER_LIST");
        req.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(req, resp);
    }
}
