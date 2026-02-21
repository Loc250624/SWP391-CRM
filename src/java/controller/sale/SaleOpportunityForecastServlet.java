package controller.sale;

import dao.OpportunityDAO;
import dao.PipelineDAO;
import dao.PipelineStageDAO;
import model.Opportunity;
import model.Pipeline;
import model.PipelineStage;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.SessionHelper;

@WebServlet(name = "SaleOpportunityForecastServlet", urlPatterns = {"/sale/opportunity/forecast"})
public class SaleOpportunityForecastServlet extends HttpServlet {

    private OpportunityDAO opportunityDAO = new OpportunityDAO();
    private PipelineStageDAO stageDAO = new PipelineStageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer currentUserId = SessionHelper.getLoggedInUserId(request);
        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Opportunity> allOpps = opportunityDAO.getOpportunitiesBySalesUser(currentUserId);
        if (allOpps == null) allOpps = new java.util.ArrayList<>();

        // Calculate forecast metrics
        BigDecimal totalPipeline = BigDecimal.ZERO;
        BigDecimal weightedForecast = BigDecimal.ZERO;
        BigDecimal wonValue = BigDecimal.ZERO;
        BigDecimal lostValue = BigDecimal.ZERO;
        int openCount = 0, wonCount = 0, lostCount = 0, totalCount = allOpps.size();

        // Value by stage
        Map<Integer, BigDecimal> valueByStage = new HashMap<>();
        Map<Integer, Integer> countByStage = new HashMap<>();

        for (Opportunity opp : allOpps) {
            BigDecimal val = opp.getEstimatedValue() != null ? opp.getEstimatedValue() : BigDecimal.ZERO;

            if ("Won".equals(opp.getStatus())) {
                wonValue = wonValue.add(val);
                wonCount++;
            } else if ("Lost".equals(opp.getStatus())) {
                lostValue = lostValue.add(val);
                lostCount++;
            } else if (!"Cancelled".equals(opp.getStatus())) {
                totalPipeline = totalPipeline.add(val);
                weightedForecast = weightedForecast.add(val.multiply(BigDecimal.valueOf(opp.getProbability())).divide(BigDecimal.valueOf(100), 0, BigDecimal.ROUND_HALF_UP));
                openCount++;
            }

            int stageId = opp.getStageId();
            valueByStage.merge(stageId, val, BigDecimal::add);
            countByStage.merge(stageId, 1, Integer::sum);
        }

        int winRate = (wonCount + lostCount) > 0 ? (wonCount * 100 / (wonCount + lostCount)) : 0;

        // Load stage names
        List<PipelineStage> stages = stageDAO.getAllStages();
        Map<Integer, String> stageNameMap = new HashMap<>();
        if (stages != null) {
            for (PipelineStage s : stages) {
                stageNameMap.put(s.getStageId(), s.getStageName());
            }
        }

        request.setAttribute("totalPipeline", totalPipeline);
        request.setAttribute("weightedForecast", weightedForecast);
        request.setAttribute("wonValue", wonValue);
        request.setAttribute("lostValue", lostValue);
        request.setAttribute("openCount", openCount);
        request.setAttribute("wonCount", wonCount);
        request.setAttribute("lostCount", lostCount);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("winRate", winRate);
        request.setAttribute("valueByStage", valueByStage);
        request.setAttribute("countByStage", countByStage);
        request.setAttribute("stageNameMap", stageNameMap);
        request.setAttribute("opportunities", allOpps);

        request.setAttribute("ACTIVE_MENU", "OPP_FORECAST");
        request.setAttribute("pageTitle", "Sales Forecast");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/opportunity/forecast.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }
}
