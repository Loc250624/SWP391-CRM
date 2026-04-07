package controller.admin;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        dao.CustomerDAO customerDAO = new dao.CustomerDAO();
        dao.CourseDAO courseDAO = new dao.CourseDAO();
        dao.UserDAO userDAO = new dao.UserDAO();
        dao.ActivityDAO activityDAO = new dao.ActivityDAO();
        
        int totalCustomers = customerDAO.getTotalCustomersCount();
        int totalCourses = courseDAO.getTotalActiveCoursesCount();
        int totalStaff = userDAO.getTotalUsersCount();
        java.util.List<model.Activity> recentActivities = activityDAO.getGlobalRecentActivities(5);
        
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalCourses", totalCourses);
        request.setAttribute("totalStaff", totalStaff);
        request.setAttribute("recentActivities", recentActivities);
        
        request.setAttribute("CONTENT_PAGE", "/view/admin/dashboard.jsp");
        request.setAttribute("pageTitle", "Admin Dashboard");
        request.setAttribute("ACTIVE_MENU", "DASHBOARD");
        request.getRequestDispatcher("/view/admin/layout.jsp").forward(request, response);
    }
}
