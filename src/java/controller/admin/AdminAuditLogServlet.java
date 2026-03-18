package controller.admin;

import dao.AuditLogDAO;
import model.AuditLog;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.AuthorizationUtils;

@WebServlet(name = "AdminAuditLogServlet", urlPatterns = {"/admin/audit/log"})
public class AdminAuditLogServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = (String) request.getSession().getAttribute("role");
        if (!AuthorizationUtils.hasPermission(role, "ADMIN_DASHBOARD")) { 
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        AuditLogDAO dao = new AuditLogDAO();
        
        int page = 1;
        int pageSize = 20;
        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }
        } catch (Exception e) {}

        String action = request.getParameter("action");
        String entityType = request.getParameter("entityType");
        String keyword = request.getParameter("q");

        List<AuditLog> logs = dao.getListPaged(action, entityType, keyword, (page - 1) * pageSize, pageSize);
        int totalItems = dao.countTotal(action, entityType, keyword);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);

        request.setAttribute("auditLogs", logs);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("q", keyword);
        
        request.setAttribute("CONTENT_PAGE", "/view/admin/audit_log_all.jsp");
        request.setAttribute("pageTitle", "Nhật ký hệ thống");
        request.setAttribute("ACTIVE_MENU", "AUDIT_LOG");
        request.getRequestDispatcher("/view/admin/layout.jsp").forward(request, response);
    }
}
