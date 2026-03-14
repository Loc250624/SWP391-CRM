package controller.sale;

import dao.OpportunityDAO;
import model.Opportunity;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
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

@WebServlet(name = "SaleReportRevenueServlet", urlPatterns = {"/sale/report/revenue"})
public class SaleReportRevenueServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer currentUserId = SessionHelper.getLoggedInUserId(request);
        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        OpportunityDAO oppDAO = new OpportunityDAO();
        List<Opportunity> allOpps = oppDAO.getOpportunitiesBySalesUser(currentUserId);
        if (allOpps == null) allOpps = new ArrayList<>();

        int currentYear = LocalDate.now().getYear();
        String yearParam = request.getParameter("year");
        if (yearParam != null) {
            try { currentYear = Integer.parseInt(yearParam); } catch (NumberFormatException e) {}
        }

        int currentMonth = LocalDate.now().getMonthValue();
        BigDecimal monthRevenue = BigDecimal.ZERO;
        BigDecimal prevMonthRevenue = BigDecimal.ZERO;
        BigDecimal yearRevenue = BigDecimal.ZERO;
        int wonCount = 0;
        long totalDaysToClose = 0;
        int closedCount = 0;

        BigDecimal[] monthlyRevenue = new BigDecimal[12];
        for (int i = 0; i < 12; i++) monthlyRevenue[i] = BigDecimal.ZERO;

        for (Opportunity opp : allOpps) {
            if (!"Won".equals(opp.getStatus())) continue;
            LocalDate closeDate = opp.getActualCloseDate() != null ? opp.getActualCloseDate()
                    : (opp.getCreatedAt() != null ? opp.getCreatedAt().toLocalDate() : null);
            if (closeDate == null || closeDate.getYear() != currentYear) continue;

            BigDecimal val = opp.getEstimatedValue() != null ? opp.getEstimatedValue() : BigDecimal.ZERO;
            wonCount++;
            yearRevenue = yearRevenue.add(val);
            monthlyRevenue[closeDate.getMonthValue() - 1] = monthlyRevenue[closeDate.getMonthValue() - 1].add(val);

            if (closeDate.getMonthValue() == currentMonth) monthRevenue = monthRevenue.add(val);
            int prevMonth = currentMonth == 1 ? 12 : currentMonth - 1;
            if (closeDate.getMonthValue() == prevMonth) prevMonthRevenue = prevMonthRevenue.add(val);

            if (opp.getCreatedAt() != null && opp.getActualCloseDate() != null) {
                totalDaysToClose += ChronoUnit.DAYS.between(opp.getCreatedAt().toLocalDate(), opp.getActualCloseDate());
                closedCount++;
            }
        }

        BigDecimal avgDealValue = wonCount > 0
                ? yearRevenue.divide(BigDecimal.valueOf(wonCount), 0, RoundingMode.HALF_UP)
                : BigDecimal.ZERO;
        int avgDaysToClose = closedCount > 0 ? (int)(totalDaysToClose / closedCount) : 0;
        double monthGrowth = prevMonthRevenue.compareTo(BigDecimal.ZERO) > 0
                ? monthRevenue.subtract(prevMonthRevenue).multiply(BigDecimal.valueOf(100))
                    .divide(prevMonthRevenue, 1, RoundingMode.HALF_UP).doubleValue()
                : 0;

        // Chart data
        StringBuilder monthLabels = new StringBuilder();
        StringBuilder monthData = new StringBuilder();
        for (int i = 0; i < 12; i++) {
            if (i > 0) { monthLabels.append(","); monthData.append(","); }
            monthLabels.append("'T").append(i + 1).append("'");
            monthData.append(monthlyRevenue[i]);
        }

        request.setAttribute("selectedYear", currentYear);
        request.setAttribute("monthRevenue", monthRevenue);
        request.setAttribute("yearRevenue", yearRevenue);
        request.setAttribute("avgDealValue", avgDealValue);
        request.setAttribute("avgDaysToClose", avgDaysToClose);
        request.setAttribute("monthGrowth", monthGrowth);
        request.setAttribute("wonCount", wonCount);
        request.setAttribute("monthLabels", monthLabels.toString());
        request.setAttribute("monthData", monthData.toString());

        request.setAttribute("ACTIVE_MENU", "RPT_REVENUE");
        request.setAttribute("pageTitle", "Bao cao Doanh thu");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/report/revenue.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }
}
