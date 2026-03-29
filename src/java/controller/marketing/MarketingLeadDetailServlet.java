package controller.marketing;

import dao.LeadDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Lead;

@WebServlet(name = "MarketingLeadDetailServlet", urlPatterns = {"/marketing/lead/detail"})
public class MarketingLeadDetailServlet extends HttpServlet {

    private LeadDAO leadDAO = new LeadDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                Lead lead = leadDAO.getLeadById(id);
                if (lead != null) {
                    request.setAttribute("lead", lead);
                    request.setAttribute("ACTIVE_MENU", "LEAD_LIST");
                    request.setAttribute("pageTitle", "Chi tiết Lead - " + lead.getFullName());
                    request.setAttribute("CONTENT_PAGE", "/view/marketing/lead/detail.jsp");
                    request.getRequestDispatcher("/view/marketing/layout.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Ignore
            }
        }

        response.sendRedirect(request.getContextPath() + "/marketing/lead/list");
    }
}
