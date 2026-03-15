package controller.sale;

import dao.CustomerDAO;
import dao.LeadDAO;
import dao.OpportunityDAO;
import dao.OpportunityHistoryDAO;
import dao.PipelineDAO;
import dao.PipelineStageDAO;
import dao.QuotationDAO;
import enums.LeadStatus;
import enums.OpportunityStatus;
import enums.QuotationStatus;
import model.Customer;
import model.Lead;
import model.Opportunity;
import model.Pipeline;
import model.PipelineStage;
import model.Quotation;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.SessionHelper;

@WebServlet(name = "SaleOpportunityStageUpdateServlet", urlPatterns = { "/sale/opportunity/stage" })
public class SaleOpportunityStageUpdateServlet extends HttpServlet {

    private OpportunityDAO opportunityDAO = new OpportunityDAO();
    private OpportunityHistoryDAO historyDAO = new OpportunityHistoryDAO();
    private PipelineStageDAO stageDAO = new PipelineStageDAO();
    private PipelineDAO pipelineDAO = new PipelineDAO();
    private LeadDAO leadDAO = new LeadDAO();
    private CustomerDAO customerDAO = new CustomerDAO();
    private QuotationDAO quotationDAO = new QuotationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        Integer currentUserId = SessionHelper.getLoggedInUserId(request);
        if (currentUserId == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"success\":false,\"message\":\"Not logged in\"}");
            return;
        }

        String oppIdParam = request.getParameter("opportunityId");
        String stageIdParam = request.getParameter("stageId");

        if (oppIdParam == null || stageIdParam == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\":false,\"message\":\"Missing parameters\"}");
            return;
        }

        try {
            int oppId = Integer.parseInt(oppIdParam);
            int newStageId = Integer.parseInt(stageIdParam);

            Opportunity opp = opportunityDAO.getOpportunityById(oppId);
            if (opp == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"success\":false,\"message\":\"Opportunity not found\"}");
                return;
            }

            boolean hasPermission = (opp.getCreatedBy() != null && opp.getCreatedBy().equals(currentUserId))
                    || (opp.getOwnerId() != null && opp.getOwnerId().equals(currentUserId));

            if (!hasPermission) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                out.print("{\"success\":false,\"message\":\"No permission\"}");
                return;
            }

            // Block if opportunity is already Won or Lost
            if (OpportunityStatus.Won.name().equals(opp.getStatus())
                    || OpportunityStatus.Lost.name().equals(opp.getStatus())) {
                out.print("{\"success\":false,\"message\":\"Opportunity da dong (Won/Lost), khong the thay doi.\"}");
                return;
            }

            // Load target stage info
            PipelineStage targetStage = stageDAO.getStageById(newStageId);
            if (targetStage == null) {
                out.print("{\"success\":false,\"message\":\"Stage khong ton tai.\"}");
                return;
            }
            String targetStageType = targetStage.getStageType();
            String targetStageCode = targetStage.getStageCode();

            // Load current stage info
            PipelineStage fromStage = stageDAO.getStageById(opp.getStageId());

            // Load lead if opp has leadId (for LEAD_CONVERSION pipeline)
            Lead lead = null;
            if (opp.getLeadId() != null) {
                lead = leadDAO.getLeadById(opp.getLeadId());
            }

            // Determine pipeline
            Pipeline pipeline = pipelineDAO.getPipelineById(opp.getPipelineId());
            boolean isLeadConversion = pipeline != null && "LEAD_CONVERSION".equals(pipeline.getPipelineCode());

            // ===== VALIDATE CONDITIONS based on target stage code =====
            String validationError = validateStageTransition(targetStageCode, targetStageType, opp, lead, request);
            if (validationError != null) {
                out.print("{\"success\":false,\"message\":\"" + escapeJson(validationError) + "\"}");
                return;
            }

            // ===== APPLY CHANGES =====
            int oldStageId = opp.getStageId();
            String oldStatus = opp.getStatus();
            opp.setStageId(newStageId);

            // Accept won/lost reason from request
            String reason = request.getParameter("wonLostReason");
            if (reason != null && !reason.trim().isEmpty()) {
                opp.setWonLostReason(reason.trim());
            }

            // Apply status side effects based on target stage
            applyStatusSideEffects(targetStageCode, targetStageType, opp, lead, isLeadConversion);

            boolean success = opportunityDAO.updateOpportunity(opp);

            if (success) {
                // Log history
                historyDAO.logChange(oppId, "stage_id", String.valueOf(oldStageId), String.valueOf(newStageId),
                        currentUserId);
                if (!oldStatus.equals(opp.getStatus())) {
                    historyDAO.logChange(oppId, "status", oldStatus, opp.getStatus(), currentUserId);
                }

                // Update lead status if applicable
                if (lead != null && isLeadConversion) {
                    updateLeadStatus(targetStageCode, targetStageType, lead);
                }

                // Auto-convert lead to customer when Won if not already converted
                boolean leadConverted = false;
                if (OpportunityStatus.Won.name().equals(opp.getStatus()) && lead != null
                        && opp.getCustomerId() == null) {
                    if (!lead.isIsConverted()) {
                        Customer newCustomer = new Customer();
                        newCustomer.setFullName(lead.getFullName());
                        newCustomer.setEmail(lead.getEmail());
                        newCustomer.setPhone(lead.getPhone());
                        newCustomer.setSourceId(lead.getSourceId());
                        newCustomer.setConvertedLeadId(lead.getLeadId());
                        newCustomer.setCustomerSegment("New");
                        newCustomer.setStatus("Active");
                        newCustomer.setOwnerId(currentUserId);
                        newCustomer.setCreatedBy(currentUserId);

                        // Enrich customer from best quotation
                        Quotation bestQuotation = getBestQuotation(opp.getOpportunityId());
                        if (bestQuotation != null) {
                            newCustomer.setTotalSpent(
                                    bestQuotation.getTotalAmount() != null ? bestQuotation.getTotalAmount()
                                            : BigDecimal.ZERO);

                            // Get quotation items to extract course info
                            List<Map<String, Object>> items = quotationDAO
                                    .getItemsByQuotationId(bestQuotation.getQuotationId());
                            int totalCourses = 0;
                            StringBuilder courseNames = new StringBuilder();
                            for (Map<String, Object> item : items) {
                                Integer courseId = (Integer) item.get("courseId");
                                if (courseId != null) {
                                    Integer qty = (Integer) item.get("quantity");
                                    totalCourses += (qty != null ? qty : 1);
                                    String courseName = (String) item.get("courseName");
                                    if (courseName != null && !courseName.isEmpty()) {
                                        if (courseNames.length() > 0)
                                            courseNames.append(", ");
                                        courseNames.append(courseName);
                                    }
                                }
                            }
                            newCustomer.setTotalCourses(totalCourses);
                            newCustomer.setPurchasedCourses(courseNames.length() > 0 ? courseNames.toString() : null);
                            newCustomer.setFirstPurchaseDate(LocalDate.now());
                            newCustomer.setLastPurchaseDate(LocalDate.now());
                            newCustomer.setNotes("Chuyen doi tu Lead: " + lead.getLeadCode() + " | Bao gia: "
                                    + bestQuotation.getQuotationCode());
                        } else {
                            newCustomer.setTotalCourses(0);
                            newCustomer.setTotalSpent(BigDecimal.ZERO);
                            newCustomer.setNotes("Tu dong chuyen doi tu Lead: " + lead.getLeadCode());
                        }

                        boolean customerCreated = customerDAO.insertCustomer(newCustomer);
                        if (customerCreated && newCustomer.getCustomerId() > 0) {
                            leadDAO.markLeadConverted(lead.getLeadId(), newCustomer.getCustomerId());
                            opp.setCustomerId(newCustomer.getCustomerId());
                            opportunityDAO.updateOpportunity(opp);
                            leadConverted = true;
                        }
                    }
                }

                // ── Notifications ──
                // Build notify list: owner + managers
                java.util.List<Integer> notifyIds = new java.util.ArrayList<>();
                if (opp.getOwnerId() != null && opp.getOwnerId() != currentUserId) {
                    notifyIds.add(opp.getOwnerId());
                }
                if (opp.getCreatedBy() != null && !notifyIds.contains(opp.getCreatedBy())
                        && opp.getCreatedBy() != currentUserId) {
                    notifyIds.add(opp.getCreatedBy());
                }

                // Stage changed
                PipelineStage toStage = stageDAO.getStageById(newStageId);
                String stageName = toStage != null ? toStage.getStageName() : "N/A";
                util.NotificationUtil.notifyOpportunityStageChanged(
                        oppId, opp.getOpportunityCode(), opp.getOpportunityName(),
                        stageName, currentUserId, notifyIds);

                // Won / Lost
                if ("Won".equals(opp.getStatus()) && !"Won".equals(oldStatus)) {
                    util.NotificationUtil.notifyOpportunityWon(
                            oppId, opp.getOpportunityCode(), opp.getOpportunityName(),
                            currentUserId, notifyIds);
                } else if ("Lost".equals(opp.getStatus()) && !"Lost".equals(oldStatus)) {
                    util.NotificationUtil.notifyOpportunityLost(
                            oppId, opp.getOpportunityCode(), opp.getOpportunityName(),
                            currentUserId, notifyIds);
                }

                // Lead converted + Customer created
                if (leadConverted && lead != null) {
                    util.NotificationUtil.notifyLeadConverted(
                            lead.getLeadId(), lead.getLeadCode(), lead.getFullName(),
                            currentUserId, notifyIds);
                    util.NotificationUtil.notifyCustomerCreated(
                            opp.getCustomerId() != null ? opp.getCustomerId() : 0,
                            null, lead.getFullName(),
                            currentUserId, notifyIds);
                }

                String msg = leadConverted
                        ? "Stage updated. Lead da duoc chuyen doi thanh Customer!"
                        : "Stage updated";
                out.print("{\"success\":true,\"message\":\"" + escapeJson(msg) + "\",\"newStatus\":\"" + opp.getStatus()
                        + "\",\"leadConverted\":" + leadConverted + "}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"success\":false,\"message\":\"Update failed\"}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\":false,\"message\":\"Invalid parameters\"}");
        }
    }

    /**
     * Validate stage transition conditions.
     * Returns error message if invalid, null if OK.
     */
    private String validateStageTransition(String targetStageCode, String targetStageType, Opportunity opp, Lead lead,
            HttpServletRequest request) {
        switch (targetStageCode) {
            case "CONTACTED":
                // Lead must have phone OR email
                if (lead == null)
                    return "Khong tim thay Lead lien ket.";
                if ((lead.getPhone() == null || lead.getPhone().trim().isEmpty())
                        && (lead.getEmail() == null || lead.getEmail().trim().isEmpty())) {
                    return "Lead phai co so dien thoai hoac email de chuyen sang Contacted.";
                }
                break;

            case "QUALIFIED":
                // Lead must have companyName AND (email OR phone)
                if (lead == null)
                    return "Khong tim thay Lead lien ket.";
                if (lead.getCompanyName() == null || lead.getCompanyName().trim().isEmpty()) {
                    return "Lead phai co ten cong ty de chuyen sang Qualified.";
                }
                if ((lead.getPhone() == null || lead.getPhone().trim().isEmpty())
                        && (lead.getEmail() == null || lead.getEmail().trim().isEmpty())) {
                    return "Lead phai co so dien thoai hoac email de chuyen sang Qualified.";
                }
                break;

            case "DEMO":
                // Opp must have estimatedValue > 0 AND expectedCloseDate
                if (opp.getEstimatedValue() == null || opp.getEstimatedValue().compareTo(BigDecimal.ZERO) <= 0) {
                    return "Opportunity phai co gia tri uoc tinh > 0 de chuyen sang Demo.";
                }
                if (opp.getExpectedCloseDate() == null) {
                    return "Opportunity phai co ngay dong du kien de chuyen sang Demo.";
                }
                break;

            case "NEGOTIATION":
                // Opp must have estimatedValue > 0
                if (opp.getEstimatedValue() == null || opp.getEstimatedValue().compareTo(BigDecimal.ZERO) <= 0) {
                    return "Opportunity phai co gia tri uoc tinh > 0 de chuyen sang Negotiation.";
                }
                break;

            case "WON":
                // Must have at least one Approved or Sent quotation
                if (!hasApprovedOrSentQuotation(opp.getOpportunityId())) {
                    return "Phai co it nhat mot bao gia da duoc Approved hoac Sent de chuyen sang Won.";
                }
                break;

            default:
                break;
        }

        // LOST: must provide wonLostReason
        if ("lost".equals(targetStageType)) {
            String reason = request.getParameter("wonLostReason");
            if (reason == null || reason.trim().isEmpty()) {
                return "Phai nhap ly do khi chuyen sang Lost.";
            }
        }

        return null;
    }

    /**
     * Check if opportunity has at least one quotation with Approved or Sent status.
     */
    private boolean hasApprovedOrSentQuotation(int opportunityId) {
        List<Quotation> quotations = quotationDAO.getQuotationsByOpportunityId(opportunityId);
        if (quotations == null || quotations.isEmpty())
            return false;
        for (Quotation q : quotations) {
            String status = q.getStatus();
            if (QuotationStatus.Approved.name().equals(status) || QuotationStatus.Sent.name().equals(status)) {
                return true;
            }
        }
        return false;
    }

    private void applyStatusSideEffects(String targetStageCode, String targetStageType, Opportunity opp, Lead lead,
            boolean isLeadConversion) {
        if ("won".equals(targetStageType)) {
            opp.setStatus(OpportunityStatus.Won.name());
            opp.setActualCloseDate(LocalDate.now());
        } else if ("lost".equals(targetStageType)) {
            opp.setStatus(OpportunityStatus.Lost.name());
            opp.setActualCloseDate(LocalDate.now());
        } else {
            // For open stages, set InProgress if currently Open
            if (OpportunityStatus.Open.name().equals(opp.getStatus())) {
                opp.setStatus(OpportunityStatus.InProgress.name());
            }
        }
    }

    private void updateLeadStatus(String targetStageCode, String targetStageType, Lead lead) {
        String newLeadStatus = null;

        if ("lost".equals(targetStageType)) {
            newLeadStatus = LeadStatus.Unqualified.name();
        } else {
            switch (targetStageCode) {
                case "CONTACTED":
                    newLeadStatus = LeadStatus.Working.name();
                    break;
                case "QUALIFIED":
                    newLeadStatus = LeadStatus.Working.name();
                    break;
                case "DEMO":
                case "NEGOTIATION":
                    newLeadStatus = LeadStatus.Working.name();
                    break;
                case "WON":
                    newLeadStatus = LeadStatus.Converted.name();
                    break;
                default:
                    break;
            }
        }

        if (newLeadStatus != null && !newLeadStatus.equals(lead.getStatus())) {
            lead.setStatus(newLeadStatus);
            leadDAO.updateLead(lead);
        }
    }

    /**
     * Get the best quotation for an opportunity.
     * Priority: Accepted > Approved > Sent, then newest first.
     */
    private Quotation getBestQuotation(int opportunityId) {
        List<Quotation> quotations = quotationDAO.getQuotationsByOpportunityId(opportunityId);
        if (quotations == null || quotations.isEmpty())
            return null;

        Quotation best = null;
        int bestPriority = -1;

        for (Quotation q : quotations) {
            String status = q.getStatus();
            int priority;
            if ("Accepted".equals(status)) {
                priority = 3;
            } else if (QuotationStatus.Approved.name().equals(status)) {
                priority = 2;
            } else if (QuotationStatus.Sent.name().equals(status)) {
                priority = 1;
            } else {
                continue;
            }

            if (priority > bestPriority) {
                bestPriority = priority;
                best = q;
            } else if (priority == bestPriority && best != null
                    && q.getCreatedAt() != null && best.getCreatedAt() != null
                    && q.getCreatedAt().isAfter(best.getCreatedAt())) {
                best = q;
            }
        }
        return best;
    }

    private String escapeJson(String text) {
        if (text == null)
            return "";
        return text.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }
}
