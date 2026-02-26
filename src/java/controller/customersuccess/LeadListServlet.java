package controller.customersuccess;

import dao.LeadDAO;
import model.Lead;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "LeadListServlet", urlPatterns = {"/support/leads"})
public class LeadListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String phoneQuery = request.getParameter("search");
        LeadDAO dao = new LeadDAO();
        List<Lead> list;

        // Logic lọc theo số điện thoại
        if (phoneQuery != null && !phoneQuery.trim().isEmpty()) {
            list = dao.searchLeadsByPhone(phoneQuery.trim());
            request.setAttribute("searchValue", phoneQuery);
        } else {
            list = dao.getAllLeads();
        }
        
        request.setAttribute("leadList", list);
        request.setAttribute("pageTitle", "Quản lý Leads");
        request.setAttribute("contentPage", "/view/customersuccess/pages/leads_list.jsp");
        request.getRequestDispatcher("/view/customersuccess/pages/main_layout.jsp").forward(request, response);
    }
}