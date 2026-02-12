package controller.sale;

import dao.CampaignDAO;
import dao.LeadDAO;
import dao.LeadSourceDAO;
import enums.LeadRating;
import enums.LeadStatus;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Campaign;
import model.Lead;
import model.LeadSource;

@WebServlet(name = "SaleLeadFormServlet", urlPatterns = {"/sale/lead/form"})
public class SaleLeadFormServlet extends HttpServlet {

    private LeadDAO leadDAO = new LeadDAO();
    private LeadSourceDAO leadSourceDAO = new LeadSourceDAO();
    private CampaignDAO campaignDAO = new CampaignDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get current user ID
        Integer currentUserId = 1;
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            try {
                currentUserId = (Integer) session.getAttribute("userId");
            } catch (Exception e) {
                // Use default
            }
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
        request.setAttribute("ACTIVE_MENU", "LEADS");
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
            request.setAttribute("error", "Full name is required!");
            doGet(request, response);
            return;
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

        // Set lead properties
        lead.setFullName(fullName != null ? fullName.trim() : null);
        lead.setEmail(email != null && !email.trim().isEmpty() ? email.trim() : null);
        lead.setPhone(phone != null && !phone.trim().isEmpty() ? phone.trim() : null);
        lead.setCompanyName(companyName != null && !companyName.trim().isEmpty() ? companyName.trim() : null);
        lead.setJobTitle(jobTitle != null && !jobTitle.trim().isEmpty() ? jobTitle.trim() : null);
        lead.setInterests(interests != null && !interests.trim().isEmpty() ? interests.trim() : null);
        lead.setStatus(status != null && !status.isEmpty() ? status : "New");
        lead.setRating(rating != null && !rating.isEmpty() ? rating : null);
        lead.setNotes(notes != null && !notes.trim().isEmpty() ? notes.trim() : null);
        lead.setLeadScore(0);
        lead.setIsConverted(false);

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

        // Get current user ID from session (or use default userId = 1 for now)
        Integer currentUserId = 1; // TODO: Get from session after implementing authentication

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            try {
                currentUserId = (Integer) session.getAttribute("userId");
            } catch (Exception e) {
                // Use default userId = 1
            }
        }

        if (!isEdit) {
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
            // Success - redirect to list with success message
            response.sendRedirect(request.getContextPath() + "/sale/lead/list?success=" +
                                (isEdit ? "updated" : "created"));
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
