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
        
        // You can add stats logic here late (e.g., total customers, total courses)
        
        request.setAttribute("CONTENT_PAGE", "/view/admin/dashboard.jsp");
        request.setAttribute("pageTitle", "Admin Dashboard");
        request.setAttribute("ACTIVE_MENU", "DASHBOARD");
        request.getRequestDispatcher("/view/admin/layout.jsp").forward(request, response);
    }
}
