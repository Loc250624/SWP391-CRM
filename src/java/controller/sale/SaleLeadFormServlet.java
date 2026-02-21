package controller.sale;

import dao.CampaignDAO;
import dao.LeadDAO;
import dao.LeadSourceDAO;
import dao.OpportunityDAO;
import enums.LeadRating;
import enums.LeadStatus;
import util.EnumHelper;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.SessionHelper;
import model.Campaign;
import model.Lead;
import model.LeadSource;
import model.Opportunity;

@WebServlet(name = "SaleLeadFormServlet", urlPatterns = {"/sale/lead/form"})
public class SaleLeadFormServlet extends HttpServlet {

    private LeadDAO leadDAO = new LeadDAO();
    private LeadSourceDAO leadSourceDAO = new LeadSourceDAO();
    private CampaignDAO campaignDAO = new CampaignDAO();
    private OpportunityDAO opportunityDAO = new OpportunityDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer currentUserId = SessionHelper.getLoggedInUserId(request);
        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get lead ID if editing
        String leadIdParam = request.getParameter("id");
        Lead lead = null;

        if (leadIdParam != null && !leadIdParam.isEmpty()) {
            // Edit mode
            try {
                int leadId = Integer.parseInt(leadIdParam);
                lead = leadDAO.getLeadById(leadId);

                if (lead == null) {
                    response.sendRedirect(request.getContextPath() + "/sale/lead/list");
                    return;
                }

                // Check permission
                boolean hasPermission = (lead.getCreatedBy() != null && lead.getCreatedBy().equals(currentUserId))
                        || (lead.getAssignedTo() != null && lead.getAssignedTo().equals(currentUserId));

                if (!hasPermission) {
                    response.sendRedirect(request.getContextPath() + "/sale/lead/list?error=no_permission");
                    return;
                }

                request.setAttribute("mode", "edit");
                // Only set lead if not already set (preserve form data on validation error)
                if (request.getAttribute("lead") == null) {
                    request.setAttribute("lead", lead);
                }

                // Load opportunities for this lead (for Inactive confirmation modal)
                List<Opportunity> leadOpps = opportunityDAO.getOpportunitiesByLeadId(leadId);
                request.setAttribute("leadOpportunities", leadOpps);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/sale/lead/list");
                return;
            }
        } else {
            // Create mode
            request.setAttribute("mode", "create");
        }

        // Pass enum values to JSP for dropdowns
        request.setAttribute("leadStatuses", LeadStatus.values());
        request.setAttribute("leadRatings", LeadRating.values());

        // Load sources and campaigns for dropdowns
        List<LeadSource> sources = leadSourceDAO.getAllActiveSources();
        List<Campaign> campaigns = campaignDAO.getAllActiveCampaigns();

        request.setAttribute("leadSources", sources);
        request.setAttribute("campaigns", campaigns);

        // Set page metadata
        request.setAttribute("ACTIVE_MENU", "LEAD_FORM");
        request.setAttribute("pageTitle", leadIdParam != null ? "Edit Lead" : "Create New Lead");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/lead/form.jsp");

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

        // Check if this is an Inactive action
        String action = request.getParameter("action");
        if ("inactive".equals(action)) {
            handleInactive(request, response, currentUserId);
            return;
        }

        // Get form parameters
        String leadIdParam = request.getParameter("leadId");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String companyName = request.getParameter("companyName");
        String jobTitle = request.getParameter("jobTitle");
        String interests = request.getParameter("interests");
        String rating = request.getParameter("rating");
        String notes = request.getParameter("notes");
        String sourceIdParam = request.getParameter("sourceId");
        String campaignIdParam = request.getParameter("campaignId");

        boolean isEdit = (leadIdParam != null && !leadIdParam.isEmpty());

        // Build a Lead object to preserve form data on validation error
        Lead formLead = new Lead();
        formLead.setFullName(fullName != null ? fullName.trim() : null);
        formLead.setEmail(email != null ? email.trim() : null);
        formLead.setPhone(phone != null ? phone.trim() : null);
        formLead.setCompanyName(companyName != null ? companyName.trim() : null);
        formLead.setJobTitle(jobTitle != null ? jobTitle.trim() : null);
        formLead.setInterests(interests != null ? interests.trim() : null);
        formLead.setRating(rating != null && !rating.isEmpty() ? rating : null);
        formLead.setNotes(notes != null ? notes.trim() : null);
        if (sourceIdParam != null && !sourceIdParam.isEmpty()) {
            try { formLead.setSourceId(Integer.parseInt(sourceIdParam)); } catch (NumberFormatException ignored) {}
        }
        if (campaignIdParam != null && !campaignIdParam.isEmpty()) {
            try { formLead.setCampaignId(Integer.parseInt(campaignIdParam)); } catch (NumberFormatException ignored) {}
        }
        if (isEdit) {
            try { formLead.setLeadId(Integer.parseInt(leadIdParam)); } catch (NumberFormatException ignored) {}
        }

        // Collect validation errors
        List<String> errors = new ArrayList<>();

        // --- Full Name: required, max 150 ---
        if (fullName == null || fullName.trim().isEmpty()) {
            errors.add("Ho ten la bat buoc!");
        } else if (fullName.trim().length() > 150) {
            errors.add("Ho ten khong duoc vuot qua 150 ky tu!");
        } else if (!fullName.trim().matches("^[\\p{L}\\s.'\\-]+$")) {
            errors.add("Ho ten chi duoc chua chu cai, khoang trang, dau cham, dau gach ngang!");
        }

        // --- Email: optional but must be valid format, max 255 ---
        if (email != null && !email.trim().isEmpty()) {
            if (!email.trim().matches("^[\\w.%+-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
                errors.add("Email khong hop le!");
            } else if (email.trim().length() > 255) {
                errors.add("Email khong duoc vuot qua 255 ky tu!");
            }
        }

        // --- Phone: optional but must be valid format, 7-20 chars ---
        if (phone != null && !phone.trim().isEmpty()) {
            if (!phone.trim().matches("^[0-9+\\-()\\s]{7,20}$")) {
                errors.add("So dien thoai khong hop le (7-20 ky tu, chi gom so va ky tu +, -, (, ), khoang trang)!");
            }
        }

        // --- Company Name: optional, max 255 ---
        if (companyName != null && !companyName.trim().isEmpty() && companyName.trim().length() > 255) {
            errors.add("Ten cong ty khong duoc vuot qua 255 ky tu!");
        }

        // --- Job Title: optional, max 150 ---
        if (jobTitle != null && !jobTitle.trim().isEmpty() && jobTitle.trim().length() > 150) {
            errors.add("Chuc danh khong duoc vuot qua 150 ky tu!");
        }

        // --- Interests: optional, max 500 ---
        if (interests != null && !interests.trim().isEmpty() && interests.trim().length() > 500) {
            errors.add("So thich / Quan tam khong duoc vuot qua 500 ky tu!");
        }

        // --- Notes: optional, max 2000 ---
        if (notes != null && !notes.trim().isEmpty() && notes.trim().length() > 2000) {
            errors.add("Ghi chu khong duoc vuot qua 2000 ky tu!");
        }

        // --- Rating: optional, must be valid enum ---
        if (rating != null && !rating.isEmpty()) {
            try {
                LeadRating.valueOf(rating);
            } catch (IllegalArgumentException e) {
                errors.add("Rating khong hop le!");
            }
        }

        // Return errors if any
        if (!errors.isEmpty()) {
            request.setAttribute("error", String.join("<br>", errors));
            request.setAttribute("lead", formLead);
            doGet(request, response);
            return;
        }

        // Build final Lead object
        Lead lead = new Lead();
        lead.setFullName(fullName.trim());
        lead.setEmail(email != null && !email.trim().isEmpty() ? email.trim() : null);
        lead.setPhone(phone != null && !phone.trim().isEmpty() ? phone.trim() : null);
        lead.setCompanyName(companyName != null && !companyName.trim().isEmpty() ? companyName.trim() : null);
        lead.setJobTitle(jobTitle != null && !jobTitle.trim().isEmpty() ? jobTitle.trim() : null);
        lead.setInterests(interests != null && !interests.trim().isEmpty() ? interests.trim() : null);
        lead.setRating(rating != null && !rating.isEmpty() ? rating : null);
        lead.setNotes(notes != null && !notes.trim().isEmpty() ? notes.trim() : null);
        lead.setLeadScore(0);
        lead.setIsConverted(false);
        lead.setSourceId(formLead.getSourceId());
        lead.setCampaignId(formLead.getCampaignId());

        if (isEdit) {
            lead.setLeadId(formLead.getLeadId());

            Lead existing = leadDAO.getLeadById(lead.getLeadId());
            if (existing == null) {
                request.setAttribute("error", "Lead khong ton tai!");
                request.setAttribute("lead", formLead);
                doGet(request, response);
                return;
            }

            // Edit mode: keep existing status (user cannot change status via edit form)
            lead.setStatus(existing.getStatus());

            // Preserve assignedTo from existing lead
            lead.setAssignedTo(existing.getAssignedTo());
            lead.setAssignedAt(existing.getAssignedAt());
        } else {
            // Create mode: default status = Assigned, NO assignedTo (self-created), createdBy = current user
            lead.setStatus(LeadStatus.Assigned.name());
            lead.setAssignedTo(null);
            lead.setAssignedAt(null);
            lead.setCreatedBy(currentUserId);
        }

        // Save to database
        boolean success;
        if (isEdit) {
            success = leadDAO.updateLead(lead);
        } else {
            success = leadDAO.insertLead(lead);
        }

        if (success) {
            response.sendRedirect(request.getContextPath() + "/sale/lead/list?success="
                    + (isEdit ? "updated" : "created"));
        } else {
            request.setAttribute("error", "Luu lead that bai. Vui long thu lai.");
            request.setAttribute("lead", formLead);
            doGet(request, response);
        }
    }

    /**
     * Handle setting a lead to Inactive status and cancelling all related opportunities.
     */
    private void handleInactive(HttpServletRequest request, HttpServletResponse response, int currentUserId)
            throws IOException, ServletException {
        String leadIdParam = request.getParameter("leadId");
        if (leadIdParam == null || leadIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/sale/lead/list?error=invalid_id");
            return;
        }

        try {
            int leadId = Integer.parseInt(leadIdParam);
            Lead lead = leadDAO.getLeadById(leadId);
            if (lead == null) {
                response.sendRedirect(request.getContextPath() + "/sale/lead/list?error=not_found");
                return;
            }

            // Check permission
            boolean hasPermission = (lead.getCreatedBy() != null && lead.getCreatedBy().equals(currentUserId))
                    || (lead.getAssignedTo() != null && lead.getAssignedTo().equals(currentUserId));
            if (!hasPermission) {
                response.sendRedirect(request.getContextPath() + "/sale/lead/list?error=no_permission");
                return;
            }

            // Set lead Inactive and cancel all related opportunities
            boolean success = leadDAO.deleteLead(leadId);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/sale/lead/list?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/sale/lead/list?error=delete_failed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/sale/lead/list?error=invalid_id");
        }
    }

    @Override
    public String getServletInfo() {
        return "Lead Form Servlet - Handles create and edit lead operations";
    }
}
