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
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "CustomerListServlet", urlPatterns = {"/support/customers"})
public class CustomerListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
       
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        CustomerDAO dao = new CustomerDAO();
        List<Customer> list = dao.getAllCustomers();
        
        
        request.setAttribute("customerList", list);
        

        request.setAttribute("pageTitle", "Quản lý Customer");
        request.setAttribute("contentPage", "/view/customersuccess/customer_list.jsp");

      
        request.getRequestDispatcher("/view/customersuccess/main_layout.jsp").forward(request, response);
    }
}