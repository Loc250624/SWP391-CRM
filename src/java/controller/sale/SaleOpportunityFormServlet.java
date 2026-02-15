package controller.sale;

import dao.CampaignDAO;
import dao.CustomerDAO;
import dao.LeadDAO;
import dao.LeadSourceDAO;
import dao.OpportunityDAO;
import dao.PipelineDAO;
import dao.PipelineStageDAO;
import model.Campaign;
import model.Customer;
import model.Lead;
import model.LeadSource;
import model.Opportunity;
import model.Pipeline;
import model.PipelineStage;
import dao.OpportunityHistoryDAO;
import enums.OpportunityStatus;
import util.EnumHelper;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.SessionHelper;

@WebServlet(name = "SaleOpportunityFormServlet", urlPatterns = {"/sale/opportunity/form"})
public class SaleOpportunityFormServlet extends HttpServlet {

    private OpportunityDAO opportunityDAO = new OpportunityDAO();
    private PipelineDAO pipelineDAO = new PipelineDAO();
    private PipelineStageDAO stageDAO = new PipelineStageDAO();
    private LeadDAO leadDAO = new LeadDAO();
    private LeadSourceDAO leadSourceDAO = new LeadSourceDAO();
    private CampaignDAO campaignDAO = new CampaignDAO();
    private CustomerDAO customerDAO = new CustomerDAO();
    private OpportunityHistoryDAO historyDAO = new OpportunityHistoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer currentUserId = SessionHelper.getLoggedInUserId(request);
        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get opportunity ID if editing
        String oppIdParam = request.getParameter("id");
        Opportunity opportunity = null;

        if (oppIdParam != null && !oppIdParam.isEmpty()) {
            // Edit mode
            try {
                int opportunityId = Integer.parseInt(oppIdParam);
                opportunity = opportunityDAO.getOpportunityById(opportunityId);

                if (opportunity == null) {
                    request.setAttribute("error", "Opportunity not found!");
                    response.sendRedirect(request.getContextPath() + "/sale/opportunity/list");
                    return;
                }

                // Check permission: user can only edit opportunities they own or created
                boolean hasPermission = (opportunity.getOwnerId() != null && opportunity.getOwnerId().equals(currentUserId))
                        || (opportunity.getCreatedBy() != null && opportunity.getCreatedBy().equals(currentUserId));

                if (!hasPermission) {
                    response.sendRedirect(request.getContextPath() + "/sale/opportunity/list?error=no_permission");
                    return;
                }

                // Block editing Cancelled/Won/Lost opportunities (redirect to detail view)
                String oppStatus = opportunity.getStatus();
                if (OpportunityStatus.Cancelled.name().equals(oppStatus)
                        || OpportunityStatus.Won.name().equals(oppStatus)
                        || OpportunityStatus.Lost.name().equals(oppStatus)) {
                    response.sendRedirect(request.getContextPath() + "/sale/opportunity/detail?id=" + opportunity.getOpportunityId() + "&error=closed");
                    return;
                }

                request.setAttribute("mode", "edit");
                request.setAttribute("opportunity", opportunity);

                // Load associated lead/customer name for display
                if (opportunity.getLeadId() != null) {
                    Lead linkedLead = leadDAO.getLeadById(opportunity.getLeadId());
                    if (linkedLead != null) {
                        request.setAttribute("linkedLead", linkedLead);
                    }
                }
                if (opportunity.getCustomerId() != null) {
                    Customer linkedCustomer = customerDAO.getCustomerById(opportunity.getCustomerId());
                    if (linkedCustomer != null) {
                        request.setAttribute("linkedCustomer", linkedCustomer);
                    }
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid opportunity ID!");
                response.sendRedirect(request.getContextPath() + "/sale/opportunity/list");
                return;
            }
        } else {
            // Create mode
            request.setAttribute("mode", "create");

            // Pre-select pipeline/stage from kanban
            String preSelPipeline = request.getParameter("pipeline");
            String preSelStage = request.getParameter("stage");
            if (preSelPipeline != null && !preSelPipeline.isEmpty()) {
                try {
                    int pId = Integer.parseInt(preSelPipeline);
                    request.setAttribute("preSelectedPipelineId", pId);
                    List<PipelineStage> preStages = stageDAO.getStagesByPipelineId(pId);
                    request.setAttribute("stages", preStages);
                    if (preSelStage != null && !preSelStage.isEmpty()) {
                        request.setAttribute("preSelectedStageId", Integer.parseInt(preSelStage));
                    }
                } catch (NumberFormatException e) {
                }
            }

            // Check if converting from lead
            String leadIdParam = request.getParameter("leadId");
            if (leadIdParam != null && !leadIdParam.isEmpty()) {
                try {
                    int leadId = Integer.parseInt(leadIdParam);
                    Lead lead = leadDAO.getLeadById(leadId);
                    if (lead != null) {
                        // Pre-fill opportunity from lead
                        opportunity = new Opportunity();
                        opportunity.setLeadId(leadId);
                        opportunity.setOpportunityName(lead.getFullName() + " - " + lead.getCompanyName());
                        opportunity.setSourceId(lead.getSourceId());
                        opportunity.setCampaignId(lead.getCampaignId());
                        opportunity.setNotes("Converted from Lead: " + lead.getLeadCode());

                        request.setAttribute("opportunity", opportunity);
                        request.setAttribute("convertFromLead", true);
                        request.setAttribute("lead", lead);
                    }
                } catch (NumberFormatException e) {
                    // Ignore invalid lead ID
                }
            }
        }

        // Load dropdown data
        List<Pipeline> pipelines = pipelineDAO.getAllActivePipelines();
        List<LeadSource> sources = leadSourceDAO.getAllActiveSources();
        List<Campaign> campaigns = campaignDAO.getAllActiveCampaigns();

        // Load leads and customers for selection (create mode only)
        List<Lead> leads = leadDAO.getLeadsBySalesUser(currentUserId);
        List<Customer> customers = customerDAO.getCustomersBySalesUser(currentUserId);

        request.setAttribute("pipelines", pipelines);
        request.setAttribute("sources", sources);
        request.setAttribute("campaigns", campaigns);
        request.setAttribute("leads", leads);
        request.setAttribute("customers", customers);

        // If editing, load stages for the selected pipeline
        if (opportunity != null && opportunity.getPipelineId() != 0) {
            List<PipelineStage> stages = stageDAO.getStagesByPipelineId(opportunity.getPipelineId());
            request.setAttribute("stages", stages);
        }

        // Set page metadata
        request.setAttribute("ACTIVE_MENU", "OPP_FORM");
        request.setAttribute("pageTitle", oppIdParam != null ? "Edit Opportunity" : "Create New Opportunity");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/opportunity/form.jsp");

        // Forward to layout
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        Integer currentUserId = SessionHelper.getLoggedInUserId(request);
        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get form parameters
        String oppIdParam = request.getParameter("opportunityId");
        String opportunityName = request.getParameter("opportunityName");
        String leadIdParam = request.getParameter("leadId");
        String customerIdParam = request.getParameter("customerId");
        String pipelineIdParam = request.getParameter("pipelineId");
        String stageIdParam = request.getParameter("stageId");
        String estimatedValueParam = request.getParameter("estimatedValue");
        String probabilityParam = request.getParameter("probability");
        String expectedCloseDateParam = request.getParameter("expectedCloseDate");
        String status = request.getParameter("status");
        String sourceIdParam = request.getParameter("sourceId");
        String campaignIdParam = request.getParameter("campaignId");
        String notes = request.getParameter("notes");

        // Validation
        if (opportunityName == null || opportunityName.trim().isEmpty()) {
            request.setAttribute("error", "Ten opportunity la bat buoc!");
            doGet(request, response);
            return;
        }
        if (opportunityName.trim().length() > 255) {
            request.setAttribute("error", "Ten opportunity khong duoc vuot qua 255 ky tu!");
            doGet(request, response);
            return;
        }

        if (pipelineIdParam == null || pipelineIdParam.isEmpty()) {
            request.setAttribute("error", "Pipeline la bat buoc!");
            doGet(request, response);
            return;
        }

        if (estimatedValueParam != null && !estimatedValueParam.trim().isEmpty()) {
            try {
                BigDecimal val = new BigDecimal(estimatedValueParam.trim());
                if (val.compareTo(BigDecimal.ZERO) < 0) {
                    request.setAttribute("error", "Gia tri uoc tinh khong duoc am!");
                    doGet(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Gia tri uoc tinh khong hop le!");
                doGet(request, response);
                return;
            }
        }

        if (expectedCloseDateParam != null && !expectedCloseDateParam.trim().isEmpty()) {
            try {
                LocalDate closeDate = LocalDate.parse(expectedCloseDateParam.trim());
                if (closeDate.isBefore(LocalDate.now())) {
                    request.setAttribute("error", "Ngay dong du kien khong duoc o qua khu!");
                    doGet(request, response);
                    return;
                }
            } catch (Exception e) {
                request.setAttribute("error", "Ngay dong du kien khong hop le!");
                doGet(request, response);
                return;
            }
        }

        if (status != null && !status.isEmpty()) {
            if (!EnumHelper.isValidIgnoreCase(OpportunityStatus.class, status)) {
                request.setAttribute("error", "Trang thai khong hop le!");
                doGet(request, response);
                return;
            }
        }

        // Create or update Opportunity object
        Opportunity opportunity = new Opportunity();
        Opportunity oldOpp = null;
        boolean isEdit = false;

        if (oppIdParam != null && !oppIdParam.isEmpty()) {
            // Edit mode
            isEdit = true;
            try {
                int oppId = Integer.parseInt(oppIdParam);
                opportunity.setOpportunityId(oppId);
                oldOpp = opportunityDAO.getOpportunityById(oppId);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid opportunity ID!");
                doGet(request, response);
                return;
            }
        }

        // Block editing Won/Lost/Cancelled opportunities
        if (isEdit && oldOpp != null && (OpportunityStatus.Won.name().equals(oldOpp.getStatus())
                || OpportunityStatus.Lost.name().equals(oldOpp.getStatus())
                || OpportunityStatus.Cancelled.name().equals(oldOpp.getStatus()))) {
            request.setAttribute("error", "Opportunity da dong (" + oldOpp.getStatus() + "), khong the chinh sua!");
            doGet(request, response);
            return;
        }

        // Set opportunity properties
        opportunity.setOpportunityName(opportunityName.trim());

        // Lead ID & Customer ID
        if (isEdit && oldOpp != null) {
            // Edit mode: keep original lead_id and customer_id (cannot change)
            opportunity.setLeadId(oldOpp.getLeadId());
            opportunity.setCustomerId(oldOpp.getCustomerId());
        } else {
            // Create mode: must have either leadId or customerId
            Integer parsedLeadId = null;
            Integer parsedCustomerId = null;
            if (leadIdParam != null && !leadIdParam.isEmpty()) {
                try {
                    parsedLeadId = Integer.parseInt(leadIdParam);
                } catch (NumberFormatException e) {
                }
            }
            if (customerIdParam != null && !customerIdParam.isEmpty()) {
                try {
                    parsedCustomerId = Integer.parseInt(customerIdParam);
                } catch (NumberFormatException e) {
                }
            }
            if (parsedLeadId == null && parsedCustomerId == null) {
                request.setAttribute("error", "Phai chon Lead hoac Customer cho opportunity!");
                doGet(request, response);
                return;
            }
            opportunity.setLeadId(parsedLeadId);
            opportunity.setCustomerId(parsedCustomerId);
        }

        // Pipeline ID (required)
        try {
            int pipelineId = Integer.parseInt(pipelineIdParam);
            opportunity.setPipelineId(pipelineId);

            // Stage ID - if not provided, use first stage of pipeline
            if (stageIdParam != null && !stageIdParam.isEmpty()) {
                opportunity.setStageId(Integer.parseInt(stageIdParam));
            } else {
                // Get first stage of pipeline
                PipelineStage firstStage = stageDAO.getFirstStageByPipelineId(pipelineId);
                if (firstStage != null) {
                    opportunity.setStageId(firstStage.getStageId());
                } else {
                    request.setAttribute("error", "No stages found for selected pipeline!");
                    doGet(request, response);
                    return;
                }
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid pipeline or stage!");
            doGet(request, response);
            return;
        }

        // Estimated value
        if (estimatedValueParam != null && !estimatedValueParam.trim().isEmpty()) {
            try {
                opportunity.setEstimatedValue(new BigDecimal(estimatedValueParam));
            } catch (NumberFormatException e) {
                opportunity.setEstimatedValue(BigDecimal.ZERO);
            }
        } else {
            opportunity.setEstimatedValue(BigDecimal.ZERO);
        }

        // Probability (0-100)
        if (probabilityParam != null && !probabilityParam.trim().isEmpty()) {
            try {
                int prob = Integer.parseInt(probabilityParam);
                opportunity.setProbability(Math.max(0, Math.min(100, prob))); // Clamp to 0-100
            } catch (NumberFormatException e) {
                opportunity.setProbability(0);
            }
        } else {
            opportunity.setProbability(0);
        }

        // Expected close date
        if (expectedCloseDateParam != null && !expectedCloseDateParam.trim().isEmpty()) {
            try {
                opportunity.setExpectedCloseDate(LocalDate.parse(expectedCloseDateParam));
            } catch (Exception e) {
                opportunity.setExpectedCloseDate(null);
            }
        } else {
            opportunity.setExpectedCloseDate(null);
        }

        // Status
        opportunity.setStatus(status != null && !status.isEmpty() ? status : OpportunityStatus.Open.name());

        // Source and Campaign
        if (sourceIdParam != null && !sourceIdParam.isEmpty()) {
            try {
                opportunity.setSourceId(Integer.parseInt(sourceIdParam));
            } catch (NumberFormatException e) {
                opportunity.setSourceId(null);
            }
        } else {
            opportunity.setSourceId(null);
        }

        if (campaignIdParam != null && !campaignIdParam.isEmpty()) {
            try {
                opportunity.setCampaignId(Integer.parseInt(campaignIdParam));
            } catch (NumberFormatException e) {
                opportunity.setCampaignId(null);
            }
        } else {
            opportunity.setCampaignId(null);
        }

        // Notes
        opportunity.setNotes(notes != null && !notes.trim().isEmpty() ? notes.trim() : null);

        // Owner and creator
        opportunity.setOwnerId(currentUserId);
        if (!isEdit) {
            opportunity.setCreatedBy(currentUserId);
        }

        // Save to database
        boolean success;
        if (isEdit) {
            success = opportunityDAO.updateOpportunity(opportunity);
        } else {
            success = opportunityDAO.insertOpportunity(opportunity);
        }

        if (success) {
            // Log history for edit
            if (isEdit && oldOpp != null) {
                int oppId = opportunity.getOpportunityId();
                String oldName = oldOpp.getOpportunityName() != null ? oldOpp.getOpportunityName() : "";
                String newName = opportunity.getOpportunityName() != null ? opportunity.getOpportunityName() : "";
                historyDAO.logChange(oppId, "opportunity_name", oldName, newName, currentUserId);

                historyDAO.logChange(oppId, "pipeline_id", String.valueOf(oldOpp.getPipelineId()), String.valueOf(opportunity.getPipelineId()), currentUserId);
                historyDAO.logChange(oppId, "stage_id", String.valueOf(oldOpp.getStageId()), String.valueOf(opportunity.getStageId()), currentUserId);

                String oldVal = oldOpp.getEstimatedValue() != null ? oldOpp.getEstimatedValue().toPlainString() : "0";
                String newVal = opportunity.getEstimatedValue() != null ? opportunity.getEstimatedValue().toPlainString() : "0";
                historyDAO.logChange(oppId, "estimated_value", oldVal, newVal, currentUserId);

                historyDAO.logChange(oppId, "probability", String.valueOf(oldOpp.getProbability()), String.valueOf(opportunity.getProbability()), currentUserId);

                String oldStatus = oldOpp.getStatus() != null ? oldOpp.getStatus() : "";
                String newStatus = opportunity.getStatus() != null ? opportunity.getStatus() : "";
                historyDAO.logChange(oppId, "status", oldStatus, newStatus, currentUserId);

                String oldClose = oldOpp.getExpectedCloseDate() != null ? oldOpp.getExpectedCloseDate().toString() : "";
                String newClose = opportunity.getExpectedCloseDate() != null ? opportunity.getExpectedCloseDate().toString() : "";
                historyDAO.logChange(oppId, "expected_close_date", oldClose, newClose, currentUserId);

                String oldNotes = oldOpp.getNotes() != null ? oldOpp.getNotes() : "";
                String newNotes = opportunity.getNotes() != null ? opportunity.getNotes() : "";
                historyDAO.logChange(oppId, "notes", oldNotes, newNotes, currentUserId);

                String oldSource = oldOpp.getSourceId() != null ? String.valueOf(oldOpp.getSourceId()) : "";
                String newSource = opportunity.getSourceId() != null ? String.valueOf(opportunity.getSourceId()) : "";
                historyDAO.logChange(oppId, "source_id", oldSource, newSource, currentUserId);

                String oldCampaign = oldOpp.getCampaignId() != null ? String.valueOf(oldOpp.getCampaignId()) : "";
                String newCampaign = opportunity.getCampaignId() != null ? String.valueOf(opportunity.getCampaignId()) : "";
                historyDAO.logChange(oppId, "campaign_id", oldCampaign, newCampaign, currentUserId);
            } else if (!isEdit) {
                // Log creation
                historyDAO.logChange(opportunity.getOpportunityId(), "status", null, "Created", currentUserId);
            }

            // Success - redirect to list with success message
            response.sendRedirect(request.getContextPath() + "/sale/opportunity/list?success="
                    + (isEdit ? "updated" : "created"));
        } else {
            // Error - show form again with error message
            request.setAttribute("error", "Failed to save opportunity. Please try again.");
            request.setAttribute("opportunity", opportunity);
            doGet(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Opportunity Form Servlet - Handles create and edit opportunity operations";
    }
}
