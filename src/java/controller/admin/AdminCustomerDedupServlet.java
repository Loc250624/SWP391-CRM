package controller.admin;

import dao.CustomerCoreDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;

@WebServlet(name = "AdminCustomerDedupServlet", urlPatterns = {"/admin/customer/dedup"})
public class AdminCustomerDedupServlet extends HttpServlet {

    private CustomerCoreDAO dao = new CustomerCoreDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Customer> dupEmail = dao.findDuplicatesByEmail();
        List<Customer> dupPhone = dao.findDuplicatesByPhone();

        request.setAttribute("dupEmail", dupEmail);
        request.setAttribute("dupPhone", dupPhone);
        request.getRequestDispatcher("/view/admin/customercore/dedup.jsp").forward(request, response);
    }
}
