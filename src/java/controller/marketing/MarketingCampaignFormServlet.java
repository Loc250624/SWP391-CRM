package controller.marketing;

import dao.CampaignDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Campaign;

@WebServlet(name = "MarketingCampaignFormServlet", urlPatterns = { "/marketing/campaign/form" })
public class MarketingCampaignFormServlet extends HttpServlet {

    private CampaignDAO campaignDAO = new CampaignDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr != null) {
            int id = Integer.parseInt(idStr);
            Campaign campaign = campaignDAO.getCampaignById(id);
            request.setAttribute("campaign", campaign);
        }

        request.setAttribute("ACTIVE_MENU", "CAMPAIGN_FORM");
        request.setAttribute("pageTitle", idStr == null ? "Tạo Chiến dịch mới" : "Chỉnh sửa Chiến dịch");
        request.setAttribute("CONTENT_PAGE", "/view/marketing/campaign/form.jsp");
        request.getRequestDispatcher("/view/marketing/layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("campaignId");
        Campaign c;
        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            c = campaignDAO.getCampaignById(id);
        } else {
            c = new Campaign();
        }

        c.setCampaignCode(request.getParameter("campaignCode"));
        c.setCampaignName(request.getParameter("campaignName"));
        c.setCampaignType(request.getParameter("campaignType"));
        c.setStatus(request.getParameter("status"));
        c.setDescription(request.getParameter("description"));

        String start = request.getParameter("startDate");
        if (start != null && !start.isEmpty())
            c.setStartDate(LocalDate.parse(start));

        String end = request.getParameter("endDate");
        if (end != null && !end.isEmpty())
            c.setEndDate(LocalDate.parse(end));

        String budget = request.getParameter("budget");
        if (budget != null && !budget.isEmpty())
            c.setBudget(new BigDecimal(budget));

        String target = request.getParameter("targetLeads");
        if (target != null && !target.isEmpty())
            c.setTargetLeads(Integer.parseInt(target));

        boolean success;
        if (c.getCampaignId() > 0) {
            success = campaignDAO.updateCampaign(c);
        } else {
            success = campaignDAO.insertCampaign(c);
        }

        if (success) {
            response.sendRedirect(request.getContextPath() + "/marketing/campaign/list?msg=success");
        } else {
            request.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại.");
            doGet(request, response);
        }
    }
}
