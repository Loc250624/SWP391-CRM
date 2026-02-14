package controller.sale;

import dao.OpportunityDAO;
import dao.PipelineDAO;
import dao.PipelineStageDAO;
import model.Opportunity;
import model.Pipeline;
import model.PipelineStage;
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
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "SaleReportPipelineServlet", urlPatterns = {"/sale/report/pipeline"})
public class SaleReportPipelineServlet extends HttpServlet {

    private OpportunityDAO opportunityDAO = new OpportunityDAO();
    private PipelineDAO pipelineDAO = new PipelineDAO();
    private PipelineStageDAO stageDAO = new PipelineStageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer currentUserId = 1;
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            try {
                currentUserId = (Integer) session.getAttribute("userId");
            } catch (Exception e) {
            }
        }

        // Pipeline selection
        List<Pipeline> allPipelines = pipelineDAO.getAllActivePipelines();
        if (allPipelines == null) allPipelines = new ArrayList<>();

        String pipelineParam = request.getParameter("pipeline");
        Pipeline selectedPipeline = null;

        if (pipelineParam != null && !pipelineParam.isEmpty()) {
            try {
                int pid = Integer.parseInt(pipelineParam);
                for (Pipeline p : allPipelines) {
                    if (p.getPipelineId() == pid) { selectedPipeline = p; break; }
                }
            } catch (NumberFormatException e) { }
        }

        if (selectedPipeline == null && !allPipelines.isEmpty()) {
            for (Pipeline p : allPipelines) {
                if (p.isIsDefault()) { selectedPipeline = p; break; }
            }
            if (selectedPipeline == null) selectedPipeline = allPipelines.get(0);
        }

        // Load stages for selected pipeline
        List<PipelineStage> stages = new ArrayList<>();
        if (selectedPipeline != null) {
            stages = stageDAO.getStagesByPipelineId(selectedPipeline.getPipelineId());
            if (stages == null) stages = new ArrayList<>();
        }

        // Load all user's opportunities
        List<Opportunity> allOpps = opportunityDAO.getOpportunitiesBySalesUser(currentUserId);
        if (allOpps == null) allOpps = new ArrayList<>();

        // Filter to selected pipeline
        List<Opportunity> pipelineOpps = new ArrayList<>();
        for (Opportunity opp : allOpps) {
            if (selectedPipeline != null && opp.getPipelineId() == selectedPipeline.getPipelineId()) {
                pipelineOpps.add(opp);
            }
        }

        // === Overall KPIs ===
        int totalInPipeline = 0;
        BigDecimal totalPipelineValue = BigDecimal.ZERO;
        BigDecimal wonValue = BigDecimal.ZERO;
        BigDecimal lostValue = BigDecimal.ZERO;
        int wonCount = 0, lostCount = 0;

        for (Opportunity opp : pipelineOpps) {
            BigDecimal val = opp.getEstimatedValue() != null ? opp.getEstimatedValue() : BigDecimal.ZERO;
            String st = opp.getStatus();
            if ("Won".equals(st)) {
                wonValue = wonValue.add(val);
                wonCount++;
            } else if ("Lost".equals(st)) {
                lostValue = lostValue.add(val);
                lostCount++;
            } else if (!"Cancelled".equals(st)) {
                totalInPipeline++;
                totalPipelineValue = totalPipelineValue.add(val);
            }
        }

        int winRate = (wonCount + lostCount) > 0 ? (wonCount * 100 / (wonCount + lostCount)) : 0;
        BigDecimal avgDealSize = totalInPipeline > 0
                ? totalPipelineValue.divide(BigDecimal.valueOf(totalInPipeline), 0, RoundingMode.HALF_UP)
                : BigDecimal.ZERO;

        // === Per-stage stats ===
        Map<Integer, Integer> countByStage = new HashMap<>();
        Map<Integer, BigDecimal> valueByStage = new HashMap<>();

        for (Opportunity opp : pipelineOpps) {
            if (!"Won".equals(opp.getStatus()) && !"Lost".equals(opp.getStatus()) && !"Cancelled".equals(opp.getStatus())) {
                int sid = opp.getStageId();
                countByStage.merge(sid, 1, Integer::sum);
                BigDecimal val = opp.getEstimatedValue() != null ? opp.getEstimatedValue() : BigDecimal.ZERO;
                valueByStage.merge(sid, val, BigDecimal::add);
            }
        }

        // Max value for funnel bar width scaling
        BigDecimal maxStageValue = BigDecimal.ZERO;
        int maxStageCount = 0;
        for (PipelineStage stage : stages) {
            BigDecimal sv = valueByStage.getOrDefault(stage.getStageId(), BigDecimal.ZERO);
            int sc = countByStage.getOrDefault(stage.getStageId(), 0);
            if (sv.compareTo(maxStageValue) > 0) maxStageValue = sv;
            if (sc > maxStageCount) maxStageCount = sc;
        }

        // Set attributes
        request.setAttribute("allPipelines", allPipelines);
        request.setAttribute("selectedPipeline", selectedPipeline);
        request.setAttribute("stages", stages);

        request.setAttribute("totalInPipeline", totalInPipeline);
        request.setAttribute("totalPipelineValue", totalPipelineValue);
        request.setAttribute("wonCount", wonCount);
        request.setAttribute("wonValue", wonValue);
        request.setAttribute("lostCount", lostCount);
        request.setAttribute("lostValue", lostValue);
        request.setAttribute("winRate", winRate);
        request.setAttribute("avgDealSize", avgDealSize);
        request.setAttribute("totalDeals", pipelineOpps.size());

        request.setAttribute("countByStage", countByStage);
        request.setAttribute("valueByStage", valueByStage);
        request.setAttribute("maxStageValue", maxStageValue.compareTo(BigDecimal.ZERO) > 0 ? maxStageValue : BigDecimal.ONE);

        request.setAttribute("ACTIVE_MENU", "RPT_PIPELINE");
        request.setAttribute("pageTitle", "Pipeline Statistics");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/report/pipeline.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }
}
