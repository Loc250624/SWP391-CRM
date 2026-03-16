package controller.sale;

import dao.CustomerDAO;
import dao.EnrollmentDAO;
import dao.LeadDAO;
import dao.OpportunityDAO;
import dao.OpportunityHistoryDAO;
import dao.PipelineDAO;
import dao.PipelineStageDAO;
import dao.QuotationDAO;
import dao.TaskDAO;
import enums.LeadStatus;
import enums.OpportunityStatus;
import enums.QuotationStatus;
import model.Customer;
import model.CustomerEnrollment;
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
            String targetStageCode = targetStage.getStageCode() != null
                    ? targetStage.getStageCode().toUpperCase() : "";

            // Load current stage info
            PipelineStage fromStage = stageDAO.getStageById(opp.getStageId());

            // Load lead if opp has leadId
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
                if (lead != null) {
                    updateLeadStatus(targetStageCode, targetStageType, lead);
                }

                // Auto-convert lead to customer when Won
                boolean leadConverted = false;
                String convertError = null;
                try {
                    if (OpportunityStatus.Won.name().equals(opp.getStatus()) && lead != null
                            && !lead.isIsConverted()) {
                        if (opp.getCustomerId() != null) {
                            leadDAO.markLeadConverted(lead.getLeadId(), opp.getCustomerId());
                            quotationDAO.updateQuotationsCustomerByOpportunity(opp.getOpportunityId(), opp.getCustomerId());
                            leadConverted = true;
                            new TaskDAO().completeTasksByRelatedLead(lead.getLeadId());
                        } else {
                            leadConverted = convertLeadToCustomer(lead, opp, currentUserId);
                            if (!leadConverted) {
                                convertError = "Khong the tao Customer tu Lead (co the Lead thieu email).";
                            }
                        }
                    }
                } catch (Exception ex) {
                    convertError = ex.getClass().getSimpleName() + ": " + ex.getMessage();
                }

                // ── Notifications ──
                try {
                    java.util.List<Integer> notifyIds = new java.util.ArrayList<>();
                    if (opp.getOwnerId() != null && !opp.getOwnerId().equals(currentUserId)) {
                        notifyIds.add(opp.getOwnerId());
                    }
                    if (opp.getCreatedBy() != null && !notifyIds.contains(opp.getCreatedBy())
                            && !opp.getCreatedBy().equals(currentUserId)) {
                        notifyIds.add(opp.getCreatedBy());
                    }
                    PipelineStage toStage = stageDAO.getStageById(newStageId);
                    String stageName = toStage != null ? toStage.getStageName() : "N/A";
                    util.NotificationUtil.notifyOpportunityStageChanged(
                            oppId, opp.getOpportunityCode(), opp.getOpportunityName(),
                            stageName, currentUserId, notifyIds);
                    if ("Won".equals(opp.getStatus()) && !"Won".equals(oldStatus)) {
                        util.NotificationUtil.notifyOpportunityWon(
                                oppId, opp.getOpportunityCode(), opp.getOpportunityName(),
                                currentUserId, notifyIds);
                    } else if ("Lost".equals(opp.getStatus()) && !"Lost".equals(oldStatus)) {
                        util.NotificationUtil.notifyOpportunityLost(
                                oppId, opp.getOpportunityCode(), opp.getOpportunityName(),
                                currentUserId, notifyIds);
                    }
                    if (leadConverted && lead != null) {
                        util.NotificationUtil.notifyLeadConverted(
                                lead.getLeadId(), lead.getLeadCode(), lead.getFullName(),
                                currentUserId, notifyIds);
                        util.NotificationUtil.notifyCustomerCreated(
                                opp.getCustomerId() != null ? opp.getCustomerId() : 0,
                                null, lead.getFullName(),
                                currentUserId, notifyIds);
                    }
                } catch (Exception ignored) {}

                String msg;
                if (leadConverted) {
                    msg = "Cập nhật thành công. Lead đã được chuyển đổi thành Customer!";
                } else if (convertError != null) {
                    msg = "Cập nhật stage thành công nhưng lỗi chuyển đổi Lead: " + convertError;
                } else {
                    msg = "Cập nhật stage thành công";
                }
                out.print("{\"success\":true,\"message\":\"" + escapeJson(msg) + "\",\"newStatus\":\"" + opp.getStatus()
                        + "\",\"leadConverted\":" + leadConverted + "}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"success\":false,\"message\":\"Update failed\"}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\":false,\"message\":\"Invalid parameters\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\":false,\"message\":\"" + escapeJson(e.getClass().getSimpleName() + ": " + e.getMessage()) + "\"}");
        }
    }

    /**
     * Convert lead to customer, create enrollments, complete tasks.
     * Returns true if successful.
     */
    private boolean convertLeadToCustomer(Lead lead, Opportunity opp, int currentUserId) {
        Customer newCustomer = new Customer();
        newCustomer.setFullName(lead.getFullName());
        // email NOT NULL in DB → fallback to placeholder if lead has no email
        newCustomer.setEmail(lead.getEmail() != null && !lead.getEmail().isEmpty()
                ? lead.getEmail() : lead.getFullName().replaceAll("\\s+", "").toLowerCase() + "@placeholder.local");
        newCustomer.setPhone(lead.getPhone());
        newCustomer.setSourceId(lead.getSourceId());
        newCustomer.setConvertedLeadId(lead.getLeadId());
        newCustomer.setCustomerSegment("New");
        newCustomer.setStatus("Active");
        newCustomer.setOwnerId(currentUserId);
        newCustomer.setCreatedBy(currentUserId);

        // Build notes from lead info
        StringBuilder notesBuilder = new StringBuilder();
        if (lead.getNotes() != null && !lead.getNotes().trim().isEmpty()) {
            notesBuilder.append(lead.getNotes().trim());
        }
        if (lead.getCompanyName() != null && !lead.getCompanyName().trim().isEmpty()) {
            if (notesBuilder.length() > 0) notesBuilder.append(" | ");
            notesBuilder.append("Công ty: ").append(lead.getCompanyName().trim());
        }
        if (lead.getJobTitle() != null && !lead.getJobTitle().trim().isEmpty()) {
            if (notesBuilder.length() > 0) notesBuilder.append(" | ");
            notesBuilder.append("Chức vụ: ").append(lead.getJobTitle().trim());
        }
        if (lead.getInterests() != null && !lead.getInterests().trim().isEmpty()) {
            if (notesBuilder.length() > 0) notesBuilder.append(" | ");
            notesBuilder.append("Quan tâm: ").append(lead.getInterests().trim());
        }

        // Enrich from best quotation
        Quotation bestQuotation = getBestQuotation(opp.getOpportunityId());
        List<Map<String, Object>> quotationItems = null;
        if (bestQuotation != null) {
            newCustomer.setTotalSpent(
                    bestQuotation.getTotalAmount() != null ? bestQuotation.getTotalAmount() : BigDecimal.ZERO);
            quotationItems = quotationDAO.getItemsByQuotationId(bestQuotation.getQuotationId());
            int totalCourses = 0;
            StringBuilder courseNames = new StringBuilder();
            if (quotationItems != null) {
                for (Map<String, Object> item : quotationItems) {
                    Integer courseId = (Integer) item.get("courseId");
                    if (courseId != null) {
                        Integer qty = (Integer) item.get("quantity");
                        totalCourses += (qty != null ? qty : 1);
                        String courseName = (String) item.get("courseName");
                        if (courseName != null && !courseName.isEmpty()) {
                            if (courseNames.length() > 0) courseNames.append(", ");
                            courseNames.append(courseName);
                        }
                    }
                }
            }
            newCustomer.setTotalCourses(totalCourses);
            newCustomer.setPurchasedCourses(courseNames.length() > 0 ? courseNames.toString() : null);
            newCustomer.setFirstPurchaseDate(LocalDate.now());
            newCustomer.setLastPurchaseDate(LocalDate.now());
            if (notesBuilder.length() > 0) notesBuilder.append(" | ");
            notesBuilder.append("Chuyển đổi từ Lead: ").append(lead.getLeadCode())
                    .append(" | Báo giá: ").append(bestQuotation.getQuotationCode());
        } else {
            newCustomer.setTotalCourses(0);
            newCustomer.setTotalSpent(BigDecimal.ZERO);
            if (notesBuilder.length() > 0) notesBuilder.append(" | ");
            notesBuilder.append("Tự động chuyển đổi từ Lead: ").append(lead.getLeadCode());
        }
        newCustomer.setNotes(notesBuilder.toString());

        boolean customerCreated = customerDAO.insertCustomer(newCustomer);
        if (customerCreated && newCustomer.getCustomerId() > 0) {
            // Mark lead as converted
            leadDAO.markLeadConverted(lead.getLeadId(), newCustomer.getCustomerId());

            // Update opp with new customer id
            opp.setCustomerId(newCustomer.getCustomerId());
            opportunityDAO.updateOpportunity(opp);

            // Associate all quotations of this opportunity with the new customer
            quotationDAO.updateQuotationsCustomerByOpportunity(opp.getOpportunityId(), newCustomer.getCustomerId());

            // Auto-create enrollments from quotation items
            if (quotationItems != null && !quotationItems.isEmpty()) {
                EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
                for (Map<String, Object> item : quotationItems) {
                    Integer courseId = (Integer) item.get("courseId");
                    if (courseId != null) {
                        CustomerEnrollment enrollment = new CustomerEnrollment();
                        enrollment.setCustomerId(newCustomer.getCustomerId());
                        enrollment.setCourseId(courseId);
                        enrollment.setEnrolledDate(LocalDate.now());
                        BigDecimal unitPrice = (BigDecimal) item.get("unitPrice");
                        BigDecimal discAmt = (BigDecimal) item.get("discountAmount");
                        BigDecimal lineTotal = (BigDecimal) item.get("lineTotal");
                        enrollment.setOriginalPrice(unitPrice != null ? unitPrice : BigDecimal.ZERO);
                        enrollment.setDiscountAmount(discAmt != null ? discAmt : BigDecimal.ZERO);
                        enrollment.setFinalAmount(lineTotal != null ? lineTotal : BigDecimal.ZERO);
                        enrollment.setPaymentStatus("Pending");
                        enrollment.setLearningStatus("Not Started");
                        enrollment.setProgressPercentage(0);
                        enrollment.setLessonsCompleted(0);
                        enrollment.setSourceId(lead.getSourceId());
                        enrollment.setCampaignId(lead.getCampaignId());
                        enrollment.setAssignedTo(currentUserId);
                        enrollment.setCreatedBy(currentUserId);
                        String courseName = (String) item.get("courseName");
                        enrollment.setNotes("Từ báo giá: "
                                + (bestQuotation != null ? bestQuotation.getQuotationCode() : "N/A")
                                + (courseName != null ? " - " + courseName : ""));
                        enrollmentDAO.insertEnrollment(enrollment);
                    }
                }
            }

            // Auto-complete tasks related to this lead
            new TaskDAO().completeTasksByRelatedLead(lead.getLeadId());
            return true;
        }
        return false;
    }

    private String validateStageTransition(String targetStageCode, String targetStageType, Opportunity opp, Lead lead,
            HttpServletRequest request) {
        switch (targetStageCode) {
            case "CONTACTED":
                if (lead == null)
                    return "Không tìm thấy Lead liên kết.";
                if ((lead.getPhone() == null || lead.getPhone().trim().isEmpty())
                        && (lead.getEmail() == null || lead.getEmail().trim().isEmpty())) {
                    return "Lead phải có số điện thoại hoặc email để chuyển sang Contacted.";
                }
                break;

            case "QUALIFIED":
                if (lead == null)
                    return "Không tìm thấy Lead liên kết.";
                if (lead.getCompanyName() == null || lead.getCompanyName().trim().isEmpty()) {
                    return "Lead phải có tên công ty để chuyển sang Qualified.";
                }
                if ((lead.getPhone() == null || lead.getPhone().trim().isEmpty())
                        && (lead.getEmail() == null || lead.getEmail().trim().isEmpty())) {
                    return "Lead phải có số điện thoại hoặc email để chuyển sang Qualified.";
                }
                break;

            case "DEMO":
                if (opp.getEstimatedValue() == null || opp.getEstimatedValue().compareTo(BigDecimal.ZERO) <= 0) {
                    return "Opportunity phải có giá trị ước tính > 0 để chuyển sang Demo.";
                }
                if (opp.getExpectedCloseDate() == null) {
                    return "Opportunity phải có ngày đóng dự kiến để chuyển sang Demo.";
                }
                break;

            case "NEGOTIATION":
                if (opp.getEstimatedValue() == null || opp.getEstimatedValue().compareTo(BigDecimal.ZERO) <= 0) {
                    return "Opportunity phải có giá trị ước tính > 0 để chuyển sang Negotiation.";
                }
                break;

            case "WON":
                if (!hasAnyQuotation(opp.getOpportunityId())) {
                    return "Phải có ít nhất một báo giá để chuyển sang Won.";
                }
                break;

            default:
                break;
        }

        if ("lost".equalsIgnoreCase(targetStageType)) {
            String lostReason = request.getParameter("wonLostReason");
            if (lostReason == null || lostReason.trim().isEmpty()) {
                return "Phải nhập lý do khi chuyển sang Lost.";
            }
        }

        return null;
    }

    private boolean hasAnyQuotation(int opportunityId) {
        List<Quotation> quotations = quotationDAO.getQuotationsByOpportunityId(opportunityId);
        return quotations != null && !quotations.isEmpty();
    }

    private void applyStatusSideEffects(String targetStageCode, String targetStageType, Opportunity opp, Lead lead,
            boolean isLeadConversion) {
        if ("won".equalsIgnoreCase(targetStageType)) {
            opp.setStatus(OpportunityStatus.Won.name());
            opp.setActualCloseDate(LocalDate.now());
        } else if ("lost".equalsIgnoreCase(targetStageType)) {
            opp.setStatus(OpportunityStatus.Lost.name());
            opp.setActualCloseDate(LocalDate.now());
        } else {
            if (OpportunityStatus.Open.name().equals(opp.getStatus())) {
                opp.setStatus(OpportunityStatus.InProgress.name());
            }
        }
    }

    private void updateLeadStatus(String targetStageCode, String targetStageType, Lead lead) {
        String newLeadStatus = null;

        if ("lost".equalsIgnoreCase(targetStageType)) {
            newLeadStatus = LeadStatus.Unqualified.name();
        } else {
            switch (targetStageCode) {
                case "CONTACTED":
                case "QUALIFIED":
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
                priority = 4;
            } else if (QuotationStatus.Approved.name().equals(status)) {
                priority = 3;
            } else if (QuotationStatus.Sent.name().equals(status)) {
                priority = 2;
            } else {
                priority = 1;
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
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < text.length(); i++) {
            char c = text.charAt(i);
            switch (c) {
                case '\\': sb.append("\\\\"); break;
                case '"':  sb.append("\\\""); break;
                case '\n': sb.append("\\n"); break;
                case '\r': sb.append("\\r"); break;
                case '\t': sb.append("\\t"); break;
                case '\b': sb.append("\\b"); break;
                case '\f': sb.append("\\f"); break;
                default:
                    if (c < 0x20) {
                        sb.append(String.format("\\u%04x", (int) c));
                    } else {
                        sb.append(c);
                    }
            }
        }
        return sb.toString();
    }
}
