package controller.sale;

import dao.OpportunityDAO;
import dao.PipelineDAO;
import model.Opportunity;
import model.Pipeline;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "SaleOpportunityListServlet", urlPatterns = {"/sale/opportunity/list"})
public class SaleOpportunityListServlet extends HttpServlet {

    private OpportunityDAO opportunityDAO = new OpportunityDAO();
    private PipelineDAO pipelineDAO = new PipelineDAO();

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

        // Get pipeline filter (optional)
        String pipelineIdParam = request.getParameter("pipeline");
        Integer selectedPipelineId = null;
        if (pipelineIdParam != null && !pipelineIdParam.isEmpty()) {
            try {
                selectedPipelineId = Integer.parseInt(pipelineIdParam);
            } catch (NumberFormatException e) {
                // Ignore invalid pipeline ID
            }
        }

        // Load opportunities (permission-aware: owner_id OR created_by)
        List<Opportunity> opportunityList;
        if (selectedPipelineId != null) {
            opportunityList = opportunityDAO.getOpportunitiesByPipelineAndUser(selectedPipelineId, currentUserId);
        } else {
            opportunityList = opportunityDAO.getOpportunitiesBySalesUser(currentUserId);
        }

        // Null check
        if (opportunityList == null) {
            opportunityList = new java.util.ArrayList<>();
        }

        // Load all active pipelines for filter dropdown
        List<Pipeline> pipelines = pipelineDAO.getAllActivePipelines();
        if (pipelines == null) {
            pipelines = new java.util.ArrayList<>();
        }

        // Calculate statistics
        int totalOpportunities = opportunityList.size();
        BigDecimal totalValue = BigDecimal.ZERO;
        int openCount = 0;
        int wonCount = 0;
        int lostCount = 0;

        for (Opportunity opp : opportunityList) {
            if (opp.getEstimatedValue() != null) {
                totalValue = totalValue.add(opp.getEstimatedValue());
            }

            String status = opp.getStatus();
            if (status != null) {
                switch (status) {
                    case "Open":
                        openCount++;
                        break;
                    case "Won":
                        wonCount++;
                        break;
                    case "Lost":
                        lostCount++;
                        break;
                }
            }
        }

        // Set attributes
        request.setAttribute("opportunities", opportunityList);
        request.setAttribute("pipelines", pipelines);
        request.setAttribute("selectedPipelineId", selectedPipelineId);

        // Statistics
        request.setAttribute("totalOpportunities", totalOpportunities);
        request.setAttribute("totalValue", totalValue);
        request.setAttribute("openCount", openCount);
        request.setAttribute("wonCount", wonCount);
        request.setAttribute("lostCount", lostCount);

        // Page metadata
        request.setAttribute("ACTIVE_MENU", "OPP_LIST");
        request.setAttribute("pageTitle", "Opportunity List");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/opportunity/list.jsp");

        // Forward to layout
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Opportunity List Servlet - Displays list of opportunities for sales user";
    }
}
