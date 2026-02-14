package controller.sale;

import dao.CampaignDAO;
import dao.CustomerDAO;
import dao.LeadDAO;
import dao.LeadSourceDAO;
import dao.OpportunityDAO;
import dao.PipelineDAO;
import dao.PipelineStageDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Campaign;
import model.Customer;
import model.Lead;
import model.LeadSource;
import model.Opportunity;
import model.Pipeline;
import model.PipelineStage;
import java.util.List;

@WebServlet(name = "SaleOpportunityDetailServlet", urlPatterns = {"/sale/opportunity/detail"})
public class SaleOpportunityDetailServlet extends HttpServlet {

    private OpportunityDAO opportunityDAO = new OpportunityDAO();
    private PipelineDAO pipelineDAO = new PipelineDAO();
    private PipelineStageDAO stageDAO = new PipelineStageDAO();
    private CustomerDAO customerDAO = new CustomerDAO();
    private LeadDAO leadDAO = new LeadDAO();
    private LeadSourceDAO leadSourceDAO = new LeadSourceDAO();
    private CampaignDAO campaignDAO = new CampaignDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String oppIdParam = request.getParameter("id");

        if (oppIdParam == null || oppIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/sale/opportunity/list");
            return;
        }

        try {
            int oppId = Integer.parseInt(oppIdParam);

            Integer currentUserId = 1;
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("userId") != null) {
                try {
                    currentUserId = (Integer) session.getAttribute("userId");
                } catch (Exception e) {
                }
            }

            Opportunity opp = opportunityDAO.getOpportunityById(oppId);

            if (opp == null) {
                response.sendRedirect(request.getContextPath() + "/sale/opportunity/list");
                return;
            }

            boolean hasPermission = (opp.getCreatedBy() != null && opp.getCreatedBy().equals(currentUserId))
                    || (opp.getOwnerId() != null && opp.getOwnerId().equals(currentUserId));

            if (!hasPermission) {
                response.sendRedirect(request.getContextPath() + "/sale/opportunity/list?error=no_permission");
                return;
            }

            // Load related data
            Pipeline pipeline = pipelineDAO.getPipelineById(opp.getPipelineId());
            PipelineStage currentStage = stageDAO.getStageById(opp.getStageId());
            List<PipelineStage> allStages = stageDAO.getStagesByPipelineId(opp.getPipelineId());

            Customer customer = null;
            if (opp.getCustomerId() != null) {
                customer = customerDAO.getCustomerById(opp.getCustomerId());
            }

            Lead lead = null;
            if (opp.getLeadId() != null) {
                lead = leadDAO.getLeadById(opp.getLeadId());
            }

            String sourceName = null;
            if (opp.getSourceId() != null) {
                LeadSource source = leadSourceDAO.getSourceById(opp.getSourceId());
                if (source != null) sourceName = source.getSourceName();
            }

            String campaignName = null;
            if (opp.getCampaignId() != null) {
                Campaign campaign = campaignDAO.getCampaignById(opp.getCampaignId());
                if (campaign != null) campaignName = campaign.getCampaignName();
            }

            request.setAttribute("opportunity", opp);
            request.setAttribute("pipeline", pipeline);
            request.setAttribute("currentStage", currentStage);
            request.setAttribute("allStages", allStages);
            request.setAttribute("customer", customer);
            request.setAttribute("lead", lead);
            request.setAttribute("sourceName", sourceName);
            request.setAttribute("campaignName", campaignName);

            request.setAttribute("ACTIVE_MENU", "OPP_LIST");
            request.setAttribute("pageTitle", "Opportunity - " + opp.getOpportunityName());
            request.setAttribute("CONTENT_PAGE", "/view/sale/pages/opportunity/detail.jsp");
            request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/sale/opportunity/list");
        }
    }
}
