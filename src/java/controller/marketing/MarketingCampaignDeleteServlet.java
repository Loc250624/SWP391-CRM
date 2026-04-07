package controller.marketing;

import dao.CampaignDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "MarketingCampaignDeleteServlet", urlPatterns = { "/marketing/campaign/delete" })
public class MarketingCampaignDeleteServlet extends HttpServlet {

    private CampaignDAO campaignDAO = new CampaignDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                boolean success = campaignDAO.deleteCampaign(id);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/marketing/campaign/list?msg=deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/marketing/campaign/list?error=delete_failed");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/marketing/campaign/list?error=invalid_id");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/marketing/campaign/list");
        }
    }
}
