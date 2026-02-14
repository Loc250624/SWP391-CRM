package controller.sale;

import dao.OpportunityDAO;
import dao.PipelineDAO;
import dao.PipelineStageDAO;
import model.Opportunity;
import model.Pipeline;
import model.PipelineStage;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "SaleOpportunityHistoryServlet", urlPatterns = {"/sale/opportunity/history"})
public class SaleOpportunityHistoryServlet extends HttpServlet {

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

        // Load all user's opportunities sorted by updatedAt desc (as activity history)
        List<Opportunity> allOpps = opportunityDAO.getOpportunitiesBySalesUser(currentUserId);
        if (allOpps == null) allOpps = new java.util.ArrayList<>();

        // Filter by status if requested
        String statusFilter = request.getParameter("status");
        if (statusFilter != null && !statusFilter.isEmpty()) {
            allOpps = allOpps.stream()
                    .filter(o -> statusFilter.equals(o.getStatus()))
                    .collect(Collectors.toList());
        }

        // Build name maps
        List<Pipeline> pipelines = pipelineDAO.getAllActivePipelines();
        Map<Integer, String> pipelineNameMap = new HashMap<>();
        if (pipelines != null) {
            for (Pipeline p : pipelines) {
                pipelineNameMap.put(p.getPipelineId(), p.getPipelineName());
            }
        }

        List<PipelineStage> stages = stageDAO.getAllStages();
        Map<Integer, String> stageNameMap = new HashMap<>();
        if (stages != null) {
            for (PipelineStage s : stages) {
                stageNameMap.put(s.getStageId(), s.getStageName());
            }
        }

        request.setAttribute("opportunities", allOpps);
        request.setAttribute("pipelineNameMap", pipelineNameMap);
        request.setAttribute("stageNameMap", stageNameMap);
        request.setAttribute("filterStatus", statusFilter);

        request.setAttribute("ACTIVE_MENU", "OPP_HISTORY");
        request.setAttribute("pageTitle", "Opportunity History");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/opportunity/history.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }
}
