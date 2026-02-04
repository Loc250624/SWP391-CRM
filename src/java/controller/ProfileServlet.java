package controller;

import dao.CustomerDAO;
import model.Customer;
import model.Course;
import java.util.List;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer customerId = (Integer) session.getAttribute("customerId");

        // --- TEST MODE: Nếu chưa login thì giả bộ là ID = 1 ---
        if (customerId == null) {
            customerId = 1;
            session.setAttribute("customerId", 1);
            session.setAttribute("customerName", "Alex Test");
        }
        // -----------------------------------------------------

        CustomerDAO dao = new CustomerDAO();
        
        // 1. Lấy Profile
        Customer customer = dao.getCustomerById(customerId);
        request.setAttribute("profile", customer);

        // 2. Lấy danh sách khóa học
        List<Course> myCourses = dao.getCoursesByCustomerId(customerId);
        request.setAttribute("myCourses", myCourses);

        request.getRequestDispatcher("/view/customersuccess/profile.jsp").forward(request, response);
    }
}