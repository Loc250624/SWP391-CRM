package controller.marketing;

import dao.LeadDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "MarketingLeadDeleteServlet", urlPatterns = {"/marketing/lead/delete"})
public class MarketingLeadDeleteServlet extends HttpServlet {

    private LeadDAO leadDAO = new LeadDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                leadDAO.deleteLead(id);
            } catch (NumberFormatException e) {
                // Ignore
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/marketing/lead/list");
    }
}
