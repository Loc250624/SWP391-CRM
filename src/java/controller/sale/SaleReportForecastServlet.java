package controller.sale;

import dao.OpportunityDAO;
import model.Opportunity;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
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

@WebServlet(name = "SaleReportForecastServlet", urlPatterns = {"/sale/report/forecast"})
public class SaleReportForecastServlet extends HttpServlet {

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

        int commitCount = 0, upsideCount = 0, pipeCount = 0, earlyCount = 0;
        BigDecimal commitVal = BigDecimal.ZERO, upsideVal = BigDecimal.ZERO;
        BigDecimal pipeVal = BigDecimal.ZERO, earlyVal = BigDecimal.ZERO;
        BigDecimal commitW = BigDecimal.ZERO, upsideW = BigDecimal.ZERO;
        BigDecimal pipeW = BigDecimal.ZERO, earlyW = BigDecimal.ZERO;
        BigDecimal wonTotal = BigDecimal.ZERO;

        for (Opportunity opp : allOpps) {
            BigDecimal val = opp.getEstimatedValue() != null ? opp.getEstimatedValue() : BigDecimal.ZERO;
            if ("Won".equals(opp.getStatus())) { wonTotal = wonTotal.add(val); continue; }
            if ("Lost".equals(opp.getStatus()) || "Cancelled".equals(opp.getStatus())) continue;

            int prob = opp.getProbability();
            BigDecimal w = val.multiply(BigDecimal.valueOf(prob)).divide(BigDecimal.valueOf(100), 0, RoundingMode.HALF_UP);

            if (prob > 80) { commitCount++; commitVal = commitVal.add(val); commitW = commitW.add(w); }
            else if (prob >= 50) { upsideCount++; upsideVal = upsideVal.add(val); upsideW = upsideW.add(w); }
            else if (prob >= 20) { pipeCount++; pipeVal = pipeVal.add(val); pipeW = pipeW.add(w); }
            else { earlyCount++; earlyVal = earlyVal.add(val); earlyW = earlyW.add(w); }
        }

        BigDecimal totalW = commitW.add(upsideW).add(pipeW).add(earlyW);
        BigDecimal divider = totalW.compareTo(BigDecimal.ZERO) > 0 ? totalW : BigDecimal.ONE;

        List<Map<String, Object>> tiers = new ArrayList<>();
        addTier(tiers, "Commit (>80%)", "bg-success", commitCount, commitVal, commitW, divider);
        addTier(tiers, "Upside (50-80%)", "bg-primary", upsideCount, upsideVal, upsideW, divider);
        addTier(tiers, "Pipeline (20-50%)", "bg-warning text-dark", pipeCount, pipeVal, pipeW, divider);
        addTier(tiers, "Early (<20%)", "bg-secondary", earlyCount, earlyVal, earlyW, divider);

        request.setAttribute("commitW", commitW);
        request.setAttribute("upsideW", upsideW);
        request.setAttribute("wonTotal", wonTotal);
        request.setAttribute("totalW", totalW);
        request.setAttribute("tiers", tiers);

        request.setAttribute("ACTIVE_MENU", "RPT_FORECAST");
        request.setAttribute("pageTitle", "Bao cao Forecast");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/report/forecast.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }

    private void addTier(List<Map<String, Object>> tiers, String label, String badge,
                         int count, BigDecimal pipeVal, BigDecimal weighted, BigDecimal total) {
        Map<String, Object> t = new HashMap<>();
        t.put("label", label);
        t.put("badgeClass", badge);
        t.put("count", count);
        t.put("pipelineValue", pipeVal);
        t.put("weightedValue", weighted);
        t.put("percent", weighted.multiply(BigDecimal.valueOf(100)).divide(total, 0, RoundingMode.HALF_UP).intValue());
        tiers.add(t);
    }
}
