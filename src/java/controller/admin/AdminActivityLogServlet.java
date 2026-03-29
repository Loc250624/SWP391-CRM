package controller.admin;

import dao.ActivityDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Activity;
import util.AuthorizationUtils;

@WebServlet(name = "AdminActivityLogServlet", urlPatterns = {"/admin/activity/log"})
public class AdminActivityLogServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = (String) request.getSession().getAttribute("role");
        if (!AuthorizationUtils.hasPermission(role, "ADMIN_DASHBOARD")) { 
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        ActivityDAO dao = new ActivityDAO();
        
        // Simple global activities list for now
        // We reuse the manager logic but for Admin view
        int page = 1;
        int pageSize = 20;
        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }
        } catch (Exception e) {}

        List<Activity> activities = dao.getManagerActivityLogPaged(null, null, null, null, null, (page - 1) * pageSize, pageSize);
        int totalItems = dao.countManagerActivityLog(null, null, null, null, null);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);

        request.setAttribute("activities", activities);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        
        request.setAttribute("CONTENT_PAGE", "/view/admin/activity_log_all.jsp");
        request.setAttribute("pageTitle", "Lịch sử chăm sóc (Tất cả)");
        request.setAttribute("ACTIVE_MENU", "ACTIVITY_LOG");
        request.getRequestDispatcher("/view/admin/layout.jsp").forward(request, response);
    }
}
