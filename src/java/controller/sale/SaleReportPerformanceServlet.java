package controller.sale;

import dao.OpportunityDAO;
import dao.ActivityDAO;
import dao.QuotationDAO;
import model.Opportunity;
import java.io.IOException;
import java.math.BigDecimal;
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

@WebServlet(name = "SaleReportPerformanceServlet", urlPatterns = {"/sale/report/performance"})
public class SaleReportPerformanceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer currentUserId = SessionHelper.getLoggedInUserId(request);
        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        OpportunityDAO oppDAO = new OpportunityDAO();
        ActivityDAO actDAO = new ActivityDAO();
        QuotationDAO quotDAO = new QuotationDAO();

        List<Opportunity> allOpps = oppDAO.getOpportunitiesBySalesUser(currentUserId);
        if (allOpps == null) allOpps = new ArrayList<>();

        int wonCount = 0, lostCount = 0;
        BigDecimal wonRevenue = BigDecimal.ZERO;
        for (Opportunity opp : allOpps) {
            if ("Won".equals(opp.getStatus())) {
                wonCount++;
                wonRevenue = wonRevenue.add(opp.getEstimatedValue() != null ? opp.getEstimatedValue() : BigDecimal.ZERO);
            } else if ("Lost".equals(opp.getStatus())) {
                lostCount++;
            }
        }
        int winRate = (wonCount + lostCount) > 0 ? (wonCount * 100 / (wonCount + lostCount)) : 0;

        Map<String, Integer> actStats = actDAO.getActivityStats(currentUserId);
        Map<String, Integer> quotStats = quotDAO.countByStatus(currentUserId);
        int quotSent = quotStats.getOrDefault("Sent", 0) + quotStats.getOrDefault("Accepted", 0) + quotStats.getOrDefault("Rejected", 0);

        request.setAttribute("wonCount", wonCount);
        request.setAttribute("wonRevenue", wonRevenue);
        request.setAttribute("winRate", winRate);
        request.setAttribute("calls", actStats.getOrDefault("calls", 0));
        request.setAttribute("emails", actStats.getOrDefault("emails", 0));
        request.setAttribute("meetings", actStats.getOrDefault("meetings", 0));
        request.setAttribute("totalActivities", actStats.getOrDefault("total", 0));
        request.setAttribute("quotSent", quotSent);

        request.setAttribute("ACTIVE_MENU", "RPT_PERFORMANCE");
        request.setAttribute("pageTitle", "Bao cao Performance");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/report/performance.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }
}
