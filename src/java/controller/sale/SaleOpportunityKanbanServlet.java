package controller.sale;

import dao.OpportunityDAO;
import dao.PipelineDAO;
import dao.PipelineStageDAO;
import model.Opportunity;
import model.Pipeline;
import model.PipelineStage;
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

@WebServlet(name = "SaleOpportunityKanbanServlet", urlPatterns = {"/sale/opportunity/kanban"})
public class SaleOpportunityKanbanServlet extends HttpServlet {

    private final OpportunityDAO opportunityDAO = new OpportunityDAO();
    private final PipelineDAO pipelineDAO = new PipelineDAO();
    private final PipelineStageDAO stageDAO = new PipelineStageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer currentUserId = SessionHelper.getLoggedInUserId(request);
        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get pipeline selection
        String pipelineIdParam = request.getParameter("pipeline");
        Pipeline selectedPipeline = null;

        if (pipelineIdParam != null && !pipelineIdParam.isEmpty()) {
            try {
                int pipelineId = Integer.parseInt(pipelineIdParam);
                selectedPipeline = pipelineDAO.getPipelineById(pipelineId);
            } catch (NumberFormatException e) {
            }
        }

        if (selectedPipeline == null) {
            selectedPipeline = pipelineDAO.getDefaultPipeline();
        }

        if (selectedPipeline == null) {
            List<Pipeline> pipelines = pipelineDAO.getAllActivePipelines();
            if (pipelines != null && !pipelines.isEmpty()) {
                selectedPipeline = pipelines.get(0);
            }
        }

        List<Pipeline> allPipelines = pipelineDAO.getAllActivePipelines();
        if (allPipelines == null) allPipelines = new ArrayList<>();

        List<PipelineStage> stages = new ArrayList<>();
        Map<Integer, List<Opportunity>> opportunitiesByStage = new HashMap<>();
        Map<Integer, BigDecimal> valueByStage = new HashMap<>();
        BigDecimal totalPipelineValue = BigDecimal.ZERO;
        int totalOpportunities = 0;
        int wonCount = 0;
        int totalClosed = 0;

        if (selectedPipeline != null) {
            stages = stageDAO.getStagesByPipelineId(selectedPipeline.getPipelineId());
            if (stages == null) stages = new ArrayList<>();

            for (PipelineStage stage : stages) {
                List<Opportunity> stageOpps = opportunityDAO.getOpportunitiesByStageAndUser(
                        stage.getStageId(), currentUserId);
                if (stageOpps == null) stageOpps = new ArrayList<>();

                // Filter by pipeline type
                String pipelineCode = selectedPipeline.getPipelineCode();
                if ("LEAD_CONVERSION".equals(pipelineCode)) {
                    // Show opps from leads (including converted ones that now have customerId)
                    List<Opportunity> filtered = new ArrayList<>();
                    for (Opportunity o : stageOpps) {
                        if (o.getLeadId() != null) filtered.add(o);
                    }
                    stageOpps = filtered;
                } else if ("UPSELL".equals(pipelineCode)) {
                    // Show opps for existing customers (exclude lead-converted opps)
                    List<Opportunity> filtered = new ArrayList<>();
                    for (Opportunity o : stageOpps) {
                        if (o.getCustomerId() != null && o.getLeadId() == null) filtered.add(o);
                    }
                    stageOpps = filtered;
                }

                opportunitiesByStage.put(stage.getStageId(), stageOpps);

                BigDecimal stageValue = BigDecimal.ZERO;
                for (Opportunity opp : stageOpps) {
                    if (opp.getEstimatedValue() != null) {
                        stageValue = stageValue.add(opp.getEstimatedValue());
                    }
                    if ("Won".equals(opp.getStatus())) wonCount++;
                    if ("Won".equals(opp.getStatus()) || "Lost".equals(opp.getStatus())) totalClosed++;
                }
                valueByStage.put(stage.getStageId(), stageValue);
                totalPipelineValue = totalPipelineValue.add(stageValue);
                totalOpportunities += stageOpps.size();
            }
        }

        int winRate = totalClosed > 0 ? (wonCount * 100 / totalClosed) : 0;

        // Build stageCodeMap for JSP (stageId -> stageCode)
        Map<Integer, String> stageCodeMap = new HashMap<>();
        for (PipelineStage stage : stages) {
            stageCodeMap.put(stage.getStageId(), stage.getStageCode());
        }

        request.setAttribute("stageCodeMap", stageCodeMap);
        request.setAttribute("selectedPipeline", selectedPipeline);
        request.setAttribute("allPipelines", allPipelines);
        request.setAttribute("stages", stages);
        request.setAttribute("opportunitiesByStage", opportunitiesByStage);
        request.setAttribute("valueByStage", valueByStage);
        request.setAttribute("totalPipelineValue", totalPipelineValue);
        request.setAttribute("totalOpportunities", totalOpportunities);
        request.setAttribute("winRate", winRate);

        request.setAttribute("ACTIVE_MENU", "OPP_KANBAN");
        request.setAttribute("pageTitle", "Pipeline Kanban View");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/opportunity/kanban.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }
}
