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
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "SaleOpportunityKanbanServlet", urlPatterns = {"/sale/opportunity/kanban"})
public class SaleOpportunityKanbanServlet extends HttpServlet {

    private OpportunityDAO opportunityDAO = new OpportunityDAO();
    private PipelineDAO pipelineDAO = new PipelineDAO();
    private PipelineStageDAO stageDAO = new PipelineStageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get current user ID from session (default = 1)
        Integer currentUserId = 1;
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            try {
                currentUserId = (Integer) session.getAttribute("userId");
            } catch (Exception e) {
                // Use default
            }
        }

        // Get pipeline selection (optional - default to first active pipeline)
        String pipelineIdParam = request.getParameter("pipeline");
        Pipeline selectedPipeline = null;

        if (pipelineIdParam != null && !pipelineIdParam.isEmpty()) {
            try {
                int pipelineId = Integer.parseInt(pipelineIdParam);
                selectedPipeline = pipelineDAO.getPipelineById(pipelineId);
            } catch (NumberFormatException e) {
                // Ignore invalid pipeline ID
            }
        }

        // If no pipeline selected, use default pipeline
        if (selectedPipeline == null) {
            selectedPipeline = pipelineDAO.getDefaultPipeline();
        }

        // If still no pipeline, get the first active one
        if (selectedPipeline == null) {
            List<Pipeline> pipelines = pipelineDAO.getAllActivePipelines();
            if (pipelines != null && !pipelines.isEmpty()) {
                selectedPipeline = pipelines.get(0);
            }
        }

        // Load all active pipelines for dropdown
        List<Pipeline> allPipelines = pipelineDAO.getAllActivePipelines();
        if (allPipelines == null) {
            allPipelines = new ArrayList<>();
        }

        // If we have a selected pipeline, load stages and opportunities
        List<PipelineStage> stages = new ArrayList<>();
        Map<Integer, List<Opportunity>> opportunitiesByStage = new HashMap<>();
        Map<Integer, BigDecimal> valueByStage = new HashMap<>();
        BigDecimal totalPipelineValue = BigDecimal.ZERO;
        int totalOpportunities = 0;

        if (selectedPipeline != null) {
            // Load stages for this pipeline
            stages = stageDAO.getStagesByPipelineId(selectedPipeline.getPipelineId());
            if (stages == null) {
                stages = new ArrayList<>();
            }

            // Load opportunities grouped by stage
            for (PipelineStage stage : stages) {
                List<Opportunity> stageOpportunities = opportunityDAO.getOpportunitiesByStageAndUser(
                        stage.getStageId(), currentUserId);

                if (stageOpportunities == null) {
                    stageOpportunities = new ArrayList<>();
                }

                opportunitiesByStage.put(stage.getStageId(), stageOpportunities);

                // Calculate value for this stage
                BigDecimal stageValue = BigDecimal.ZERO;
                for (Opportunity opp : stageOpportunities) {
                    if (opp.getEstimatedValue() != null) {
                        stageValue = stageValue.add(opp.getEstimatedValue());
                    }
                }
                valueByStage.put(stage.getStageId(), stageValue);
                totalPipelineValue = totalPipelineValue.add(stageValue);
                totalOpportunities += stageOpportunities.size();
            }
        }

        // Set attributes
        request.setAttribute("selectedPipeline", selectedPipeline);
        request.setAttribute("allPipelines", allPipelines);
        request.setAttribute("stages", stages);
        request.setAttribute("opportunitiesByStage", opportunitiesByStage);
        request.setAttribute("valueByStage", valueByStage);
        request.setAttribute("totalPipelineValue", totalPipelineValue);
        request.setAttribute("totalOpportunities", totalOpportunities);

        // Page metadata
        request.setAttribute("ACTIVE_MENU", "OPP_KANBAN");
        request.setAttribute("pageTitle", "Pipeline Kanban View");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/opportunity/kanban.jsp");

        // Forward to layout
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Opportunity Kanban Servlet - Displays Kanban board view of opportunities";
    }
}
