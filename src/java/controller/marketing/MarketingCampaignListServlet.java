package controller.marketing;

import dao.CampaignDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Campaign;

@WebServlet(name = "MarketingCampaignListServlet", urlPatterns = {"/marketing/campaign/list"})
public class MarketingCampaignListServlet extends HttpServlet {

    private CampaignDAO campaignDAO = new CampaignDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String search = request.getParameter("search");
        String pageStr = request.getParameter("page");
        int page = 1;
        int pageSize = 10;
        
        try {
            if (pageStr != null) page = Integer.parseInt(pageStr);
        } catch (NumberFormatException ignored) {}

        List<Campaign> campaigns = campaignDAO.getCampaigns(page, pageSize, search);
        int total = campaignDAO.getTotalCampaigns(search);
        int totalPages = (int) Math.ceil((double) total / pageSize);

        request.setAttribute("campaigns", campaigns);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", search);
        request.setAttribute("ACTIVE_MENU", "CAMPAIGN_LIST");
        request.setAttribute("pageTitle", "Danh sách Chiến dịch");
        request.setAttribute("CONTENT_PAGE", "/view/marketing/campaign/list.jsp");
        request.getRequestDispatcher("/view/marketing/layout.jsp").forward(request, response);
    }
}
