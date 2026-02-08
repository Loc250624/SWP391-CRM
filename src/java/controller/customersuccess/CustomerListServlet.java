package controller.customersuccess;

import dao.CustomerDAO;
import model.Customer;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "CustomerListServlet", urlPatterns = {"/support/customers"})
public class CustomerListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CustomerDAO dao = new CustomerDAO();
        List<Customer> list = dao.getAllCustomers();
        request.setAttribute("customerList", list);
        request.getRequestDispatcher("/view/customersuccess/customer_list.jsp").forward(request, response);
    }
}