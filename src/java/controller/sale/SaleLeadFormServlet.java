package controller.sale;

import dao.CampaignDAO;
import dao.LeadDAO;
import dao.LeadSourceDAO;
import enums.LeadRating;
import enums.LeadStatus;
import util.EnumHelper;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.SessionHelper;
import model.Campaign;
import model.Lead;
import model.LeadSource;

@WebServlet(name = "SaleLeadFormServlet", urlPatterns = {"/sale/lead/form"})
public class SaleLeadFormServlet extends HttpServlet {

    private LeadDAO leadDAO = new LeadDAO();
    private LeadSourceDAO leadSourceDAO = new LeadSourceDAO();
    private CampaignDAO campaignDAO = new CampaignDAO();

    private static final Set<String> ALLOWED_UPDATE_STATUSES = new HashSet<>(
            Arrays.asList(LeadStatus.Assigned.name(), LeadStatus.Unqualified.name(), LeadStatus.Nurturing.name(), LeadStatus.Inactive.name()));

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
                    request.setAttribute("error", "Lead not found!");
                    response.sendRedirect(request.getContextPath() + "/sale/lead/list");
                    return;
                }

                // Check permission: user can only edit leads they created or are assigned to
                boolean hasPermission = (lead.getCreatedBy() != null && lead.getCreatedBy().equals(currentUserId))
                        || (lead.getAssignedTo() != null && lead.getAssignedTo().equals(currentUserId));

                if (!hasPermission) {
                    response.sendRedirect(request.getContextPath() + "/sale/lead/list?error=no_permission");
                    return;
                }

                request.setAttribute("mode", "edit");
                request.setAttribute("lead", lead);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid lead ID!");
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

        // Get form parameters
        String leadIdParam = request.getParameter("leadId");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String companyName = request.getParameter("companyName");
        String jobTitle = request.getParameter("jobTitle");
        String interests = request.getParameter("interests");
        String status = request.getParameter("status");
        String rating = request.getParameter("rating");
        String notes = request.getParameter("notes");
        String sourceIdParam = request.getParameter("sourceId");
        String campaignIdParam = request.getParameter("campaignId");

        // Validation
        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("error", "Ho ten la bat buoc!");
            doGet(request, response);
            return;
        }
        if (fullName.trim().length() > 150) {
            request.setAttribute("error", "Ho ten khong duoc vuot qua 150 ky tu!");
            doGet(request, response);
            return;
        }
        if (email != null && !email.trim().isEmpty()) {
            if (!email.trim().matches("^[\\w.%+-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
                request.setAttribute("error", "Email khong hop le!");
                doGet(request, response);
                return;
            }
            if (email.trim().length() > 255) {
                request.setAttribute("error", "Email khong duoc vuot qua 255 ky tu!");
                doGet(request, response);
                return;
            }
        }
        if (phone != null && !phone.trim().isEmpty()) {
            if (!phone.trim().matches("^[0-9+\\-()\\s]{7,20}$")) {
                request.setAttribute("error", "So dien thoai khong hop le!");
                doGet(request, response);
                return;
            }
        }
        if (status != null && !status.isEmpty()) {
            if (!EnumHelper.isValidIgnoreCase(LeadStatus.class, status)) {
                request.setAttribute("error", "Trang thai khong hop le!");
                doGet(request, response);
                return;
            }
        }
        if (rating != null && !rating.isEmpty()) {
            try {
                LeadRating.valueOf(rating);
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", "Rating khong hop le!");
                doGet(request, response);
                return;
            }
        }

        // Create or update Lead object
        Lead lead = new Lead();
        boolean isEdit = false;

        if (leadIdParam != null && !leadIdParam.isEmpty()) {
            // Edit mode
            isEdit = true;
            try {
                lead.setLeadId(Integer.parseInt(leadIdParam));
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid lead ID!");
                doGet(request, response);
                return;
            }
        }

        Integer currentUserId = SessionHelper.getLoggedInUserId(request);
        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Set lead properties
        lead.setFullName(fullName != null ? fullName.trim() : null);
        lead.setEmail(email != null && !email.trim().isEmpty() ? email.trim() : null);
        lead.setPhone(phone != null && !phone.trim().isEmpty() ? phone.trim() : null);
        lead.setCompanyName(companyName != null && !companyName.trim().isEmpty() ? companyName.trim() : null);
        lead.setJobTitle(jobTitle != null && !jobTitle.trim().isEmpty() ? jobTitle.trim() : null);
        lead.setInterests(interests != null && !interests.trim().isEmpty() ? interests.trim() : null);
        lead.setRating(rating != null && !rating.isEmpty() ? rating : null);
        lead.setNotes(notes != null && !notes.trim().isEmpty() ? notes.trim() : null);
        lead.setLeadScore(0);
        lead.setIsConverted(false);

        if (isEdit) {
            // Validate status transition: only allow Assigned -> Unqualified, Recycled, Nurturing, Delete
            Lead existing = leadDAO.getLeadById(lead.getLeadId());
            if (existing == null) {
                request.setAttribute("error", "Lead khong ton tai!");
                doGet(request, response);
                return;
            }
            String newStatus = (status != null && !status.isEmpty()) ? status : existing.getStatus();
            if (!ALLOWED_UPDATE_STATUSES.contains(newStatus)) {
                request.setAttribute("error", "Chi co the chuyen trang thai sang: Assigned, Unqualified, Recycled, Nurturing hoac Delete!");
                request.setAttribute("lead", existing);
                doGet(request, response);
                return;
            }
            lead.setStatus(newStatus);

            // If status is Delete, soft delete and cancel related opps
            if (LeadStatus.Inactive.name().equals(newStatus)) {
                leadDAO.deleteLead(lead.getLeadId());
                response.sendRedirect(request.getContextPath() + "/sale/lead/list?success=deleted");
                return;
            }
        } else {
            // Create mode: default status = Assigned, assignedTo = current user
            lead.setStatus(LeadStatus.Assigned.name());
            lead.setAssignedTo(currentUserId);
            lead.setAssignedAt(LocalDateTime.now());
            lead.setCreatedBy(currentUserId);
        }

        // Set source and campaign
        if (sourceIdParam != null && !sourceIdParam.isEmpty()) {
            try {
                lead.setSourceId(Integer.parseInt(sourceIdParam));
            } catch (NumberFormatException e) {
                lead.setSourceId(null);
            }
        } else {
            lead.setSourceId(null);
        }
        if (campaignIdParam != null && !campaignIdParam.isEmpty()) {
            try {
                lead.setCampaignId(Integer.parseInt(campaignIdParam));
            } catch (NumberFormatException e) {
                lead.setCampaignId(null);
            }
        } else {
            lead.setCampaignId(null);
        }

        // Save to database
        boolean success;
        if (isEdit) {
            success = leadDAO.updateLead(lead);
        } else {
            success = leadDAO.insertLead(lead);
        }

        if (success) {
            // Success - redirect to list with success message
            response.sendRedirect(request.getContextPath() + "/sale/lead/list?success="
                    + (isEdit ? "updated" : "created"));
        } else {
            // Error - show form again with error message
            request.setAttribute("error", "Failed to save lead. Please try again.");
            request.setAttribute("lead", lead);
            doGet(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Lead Form Servlet - Handles create and edit lead operations";
    }
}
