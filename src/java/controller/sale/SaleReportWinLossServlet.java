package controller.sale;

import dao.OpportunityDAO;
import dao.CustomerDAO;
import dao.LeadDAO;
import model.Opportunity;
import model.Customer;
import model.Lead;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.SessionHelper;

@WebServlet(name = "SaleReportWinLossServlet", urlPatterns = {"/sale/report/win-loss"})
public class SaleReportWinLossServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer currentUserId = SessionHelper.getLoggedInUserId(request);
        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        OpportunityDAO oppDAO = new OpportunityDAO();
        CustomerDAO custDAO = new CustomerDAO();
        LeadDAO leadDAO = new LeadDAO();
        List<Opportunity> allOpps = oppDAO.getOpportunitiesBySalesUser(currentUserId);
        if (allOpps == null) allOpps = new ArrayList<>();

        int wonCount = 0, lostCount = 0;
        long totalDays = 0;
        int closedCount = 0;
        Map<String, Integer> lossReasons = new HashMap<>();
        List<Map<String, Object>> recentDeals = new ArrayList<>();

        for (Opportunity opp : allOpps) {
            BigDecimal val = opp.getEstimatedValue() != null ? opp.getEstimatedValue() : BigDecimal.ZERO;
            if ("Won".equals(opp.getStatus())) {
                wonCount++;
            } else if ("Lost".equals(opp.getStatus())) {
                lostCount++;
                String reason = opp.getWonLostReason() != null && !opp.getWonLostReason().isEmpty()
                        ? opp.getWonLostReason() : "Khong ro";
                lossReasons.merge(reason, 1, Integer::sum);
            } else {
                continue;
            }

            if (opp.getCreatedAt() != null && opp.getActualCloseDate() != null) {
                totalDays += ChronoUnit.DAYS.between(opp.getCreatedAt().toLocalDate(), opp.getActualCloseDate());
                closedCount++;
            }

            if (recentDeals.size() < 20) {
                Map<String, Object> deal = new HashMap<>();
                deal.put("code", opp.getOpportunityCode());
                deal.put("value", val);
                deal.put("status", opp.getStatus());
                deal.put("reason", opp.getWonLostReason() != null ? opp.getWonLostReason() : "-");
                deal.put("closeDate", opp.getActualCloseDate());
                String contact = "-";
                if (opp.getCustomerId() != null) {
                    Customer c = custDAO.getCustomerById(opp.getCustomerId());
                    if (c != null) contact = c.getFullName();
                } else if (opp.getLeadId() != null) {
                    Lead l = leadDAO.getLeadById(opp.getLeadId());
                    if (l != null) contact = l.getFullName();
                }
                deal.put("contactName", contact);
                recentDeals.add(deal);
            }
        }

        int totalClosed = wonCount + lostCount;
        int winRate = totalClosed > 0 ? (wonCount * 100 / totalClosed) : 0;
        int avgDays = closedCount > 0 ? (int)(totalDays / closedCount) : 0;

        List<Map<String, Object>> lossReasonList = new ArrayList<>();
        for (Map.Entry<String, Integer> e : lossReasons.entrySet()) {
            Map<String, Object> lr = new HashMap<>();
            lr.put("reason", e.getKey());
            lr.put("count", e.getValue());
            lr.put("percent", lostCount > 0 ? (e.getValue() * 100 / lostCount) : 0);
            lossReasonList.add(lr);
        }
        lossReasonList.sort((a, b) -> (int)b.get("percent") - (int)a.get("percent"));

        request.setAttribute("wonCount", wonCount);
        request.setAttribute("lostCount", lostCount);
        request.setAttribute("winRate", winRate);
        request.setAttribute("avgDays", avgDays);
        request.setAttribute("lossReasonList", lossReasonList);
        request.setAttribute("recentDeals", recentDeals);

        request.setAttribute("ACTIVE_MENU", "RPT_WINLOSS");
        request.setAttribute("pageTitle", "Bao cao Win / Loss");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/report/win-loss.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }
}
