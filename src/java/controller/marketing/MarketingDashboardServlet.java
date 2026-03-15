package controller.marketing;

import dao.CampaignDAO;
import dao.LeadDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "MarketingDashboardServlet", urlPatterns = {"/marketing/dashboard"})
public class MarketingDashboardServlet extends HttpServlet {

    private LeadDAO leadDAO = new LeadDAO();
    private CampaignDAO campaignDAO = new CampaignDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Basic stats for dashboard
        int totalLeads = leadDAO.getAllLeads().size();
        int totalActiveCampaigns = campaignDAO.getAllActiveCampaigns().size();
        
        request.setAttribute("totalLeads", totalLeads);
        request.setAttribute("totalActiveCampaigns", totalActiveCampaigns);
        request.setAttribute("ACTIVE_MENU", "DASHBOARD");
        request.setAttribute("pageTitle", "Marketing Dashboard");
        request.setAttribute("CONTENT_PAGE", "/view/marketing/dashboard.jsp");
        request.getRequestDispatcher("/view/marketing/layout.jsp").forward(request, response);
    }
}
