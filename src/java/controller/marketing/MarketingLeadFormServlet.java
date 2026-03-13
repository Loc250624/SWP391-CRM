package controller.marketing;

import dao.CampaignDAO;
import dao.LeadDAO;
import dao.LeadSourceDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Lead;
import dao.UserDAO;
import enums.LeadStatus;
import enums.LeadRating;
import java.time.LocalDateTime;

@WebServlet(name = "MarketingLeadFormServlet", urlPatterns = {"/marketing/lead/form"})
public class MarketingLeadFormServlet extends HttpServlet {

    private LeadDAO leadDAO = new LeadDAO();
    private LeadSourceDAO sourceDAO = new LeadSourceDAO();
    private CampaignDAO campaignDAO = new CampaignDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr != null) {
            int id = Integer.parseInt(idStr);
            Lead lead = leadDAO.getLeadById(id);
            request.setAttribute("lead", lead);
        }

        request.setAttribute("sources", sourceDAO.getAllActiveSources());
        request.setAttribute("campaigns", campaignDAO.getAllActiveCampaigns());
        request.setAttribute("users", userDAO.getAllUsers());
        request.setAttribute("leadStatuses", LeadStatus.values());
        request.setAttribute("leadRatings", LeadRating.values());
        request.setAttribute("ACTIVE_MENU", "LEAD_FORM");
        request.setAttribute("pageTitle", idStr == null ? "Tạo Lead mới" : "Chỉnh sửa Lead");
        request.setAttribute("CONTENT_PAGE", "/view/marketing/lead/form.jsp");
        request.getRequestDispatcher("/view/marketing/layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Handle lead submission
        Lead lead = new Lead();
        String idStr = request.getParameter("leadId");
        if (idStr != null && !idStr.isEmpty()) {
            lead.setLeadId(Integer.parseInt(idStr));
        }
        
        lead.setFullName(request.getParameter("fullName"));
        lead.setEmail(request.getParameter("email"));
        lead.setPhone(request.getParameter("phone"));
        lead.setCompanyName(request.getParameter("companyName"));
        lead.setJobTitle(request.getParameter("jobTitle"));
        lead.setStatus(request.getParameter("status"));
        
        String sourceId = request.getParameter("sourceId");
        if (sourceId != null && !sourceId.isEmpty()) lead.setSourceId(Integer.parseInt(sourceId));
        
        String campaignId = request.getParameter("campaignId");
        if (campaignId != null && !campaignId.isEmpty()) lead.setCampaignId(Integer.parseInt(campaignId));
        
        lead.setRating(request.getParameter("rating"));
        lead.setInterests(request.getParameter("interests"));
        lead.setNotes(request.getParameter("notes"));
        
        String leadScore = request.getParameter("leadScore");
        if (leadScore != null && !leadScore.isEmpty()) lead.setLeadScore(Integer.parseInt(leadScore));
        
        String assignedTo = request.getParameter("assignedTo");
        if (assignedTo != null && !assignedTo.isEmpty()) lead.setAssignedTo(Integer.parseInt(assignedTo));
        
        boolean success;
        if (lead.getLeadId() > 0) {
            Lead existing = leadDAO.getLeadById(lead.getLeadId());
            if (existing != null) {
                if (lead.getAssignedTo() != null && (existing.getAssignedTo() == null || !existing.getAssignedTo().equals(lead.getAssignedTo()))) {
                    lead.setAssignedAt(LocalDateTime.now());
                } else {
                    lead.setAssignedAt(existing.getAssignedAt());
                }
            }
            success = leadDAO.updateLead(lead);
        } else {
            if (lead.getAssignedTo() != null) {
                lead.setAssignedAt(LocalDateTime.now());
            }
            success = leadDAO.insertLead(lead);
        }
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/marketing/lead/list?msg=success");
        } else {
            request.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại.");
            doGet(request, response);
        }
    }
}
