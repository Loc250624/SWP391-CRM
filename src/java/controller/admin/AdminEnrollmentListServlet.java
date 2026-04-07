package controller.admin;

import dao.EnrollmentDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.CustomerEnrollment;
import util.AuthorizationUtils;

@WebServlet(name = "AdminEnrollmentListServlet", urlPatterns = {"/admin/enrollment/list"})
public class AdminEnrollmentListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = (String) request.getSession().getAttribute("role");
        if (!AuthorizationUtils.hasPermission(role, "ADMIN_DASHBOARD")) { 
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        EnrollmentDAO dao = new EnrollmentDAO();
        List<CustomerEnrollment> enrollments = dao.getAllEnrollments();

        request.setAttribute("enrollments", enrollments);
        request.setAttribute("CONTENT_PAGE", "/view/admin/enrollment_list_all.jsp");
        request.setAttribute("pageTitle", "Khóa học đã mua (Tất cả)");
        request.setAttribute("ACTIVE_MENU", "ENROLLMENT_LIST");
        request.getRequestDispatcher("/view/admin/layout.jsp").forward(request, response);
    }
}
