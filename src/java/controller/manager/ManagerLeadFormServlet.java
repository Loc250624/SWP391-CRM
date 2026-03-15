package controller.manager;

import dao.CampaignDAO;
import dao.LeadDAO;
import dao.LeadSourceDAO;
import dao.UserDAO;
import enums.LeadRating;
import enums.LeadStatus;
import java.io.IOException;
import java.util.ArrayList;
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
import model.Users;
import util.AuditUtil;

@WebServlet(name = "ManagerLeadFormServlet", urlPatterns = {"/manager/crm/lead-form"})
public class ManagerLeadFormServlet extends HttpServlet {

    private LeadDAO leadDAO = new LeadDAO();
    private LeadSourceDAO leadSourceDAO = new LeadSourceDAO();
    private CampaignDAO campaignDAO = new CampaignDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Users currentUser = (Users) session.getAttribute("user");
        UserDAO userDAO = new UserDAO();
        String roleCode = userDAO.getRoleCodeByUserId(currentUser.getUserId());

        if (!"MANAGER".equals(roleCode)) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        // Only create mode for manager
        request.setAttribute("mode", "create");

        // Pass enum values for dropdowns
        request.setAttribute("leadRatings", LeadRating.values());

        // Load sources and campaigns
        List<LeadSource> sources = leadSourceDAO.getAllActiveSources();
        List<Campaign> campaigns = campaignDAO.getAllActiveCampaigns();
        request.setAttribute("leadSources", sources);
        request.setAttribute("campaigns", campaigns);

        // Page metadata
        request.setAttribute("ACTIVE_MENU", "CRM_LEADS");
        request.setAttribute("pageTitle", "Tao Lead moi");
        request.setAttribute("CONTENT_PAGE", "/view/manager/crm/lead-form.jsp");

        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Users currentUser = (Users) session.getAttribute("user");
        UserDAO userDAO = new UserDAO();
        String roleCode = userDAO.getRoleCodeByUserId(currentUser.getUserId());

        if (!"MANAGER".equals(roleCode)) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        int currentUserId = currentUser.getUserId();

        // Get form parameters
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
        String leadScoreParam = request.getParameter("leadScore");

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
        int leadScore = 0;
        if (leadScoreParam != null && !leadScoreParam.trim().isEmpty()) {
            try { leadScore = Integer.parseInt(leadScoreParam.trim()); } catch (NumberFormatException ignored) {}
        }
        formLead.setLeadScore(leadScore);

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

        // --- Lead Score: 0-100 ---
        if (leadScore < 0 || leadScore > 100) {
            errors.add("Diem (Score) phai tu 0 den 100!");
        }

        // --- Rating: optional, must be valid enum ---
        if (rating != null && !rating.isEmpty()) {
            try {
                LeadRating.valueOf(rating);
            } catch (IllegalArgumentException e) {
                errors.add("Rating khong hop le!");
            }
        }

        // --- Duplicate check by phone ---
        if (phone != null && !phone.trim().isEmpty() && errors.isEmpty()) {
            List<Lead> phoneMatches = leadDAO.searchLeadsByPhone(phone.trim());
            if (!phoneMatches.isEmpty()) {
                StringBuilder dupMsg = new StringBuilder("So dien thoai da ton tai trong he thong: ");
                for (int i = 0; i < phoneMatches.size() && i < 3; i++) {
                    Lead dup = phoneMatches.get(i);
                    if (i > 0) dupMsg.append(", ");
                    dupMsg.append(dup.getFullName()).append(" (").append(dup.getLeadCode()).append(")");
                }
                errors.add(dupMsg.toString());
            }
        }

        // --- Duplicate check by email ---
        if (email != null && !email.trim().isEmpty() && errors.isEmpty()) {
            List<Lead> emailMatches = leadDAO.searchLeadsByEmail(email.trim());
            if (!emailMatches.isEmpty()) {
                StringBuilder dupMsg = new StringBuilder("Email da ton tai trong he thong: ");
                for (int i = 0; i < emailMatches.size() && i < 3; i++) {
                    Lead dup = emailMatches.get(i);
                    if (i > 0) dupMsg.append(", ");
                    dupMsg.append(dup.getFullName()).append(" (").append(dup.getLeadCode()).append(")");
                }
                errors.add(dupMsg.toString());
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
        lead.setLeadScore(leadScore);
        lead.setIsConverted(false);
        lead.setSourceId(formLead.getSourceId());
        lead.setCampaignId(formLead.getCampaignId());

        // Manager creates lead with status = New (not Assigned like sales)
        lead.setStatus(LeadStatus.New.name());
        lead.setAssignedTo(null);
        lead.setAssignedAt(null);
        lead.setCreatedBy(currentUserId);

        // Save to database
        boolean success = leadDAO.insertLead(lead);

        if (success) {
            AuditUtil.logCreate(request, currentUserId, "Lead", lead.getLeadId(),
                    "fullName=" + lead.getFullName() + ", email=" + lead.getEmail()
                    + ", phone=" + lead.getPhone() + ", company=" + lead.getCompanyName()
                    + ", rating=" + lead.getRating() + ", score=" + lead.getLeadScore());
            session.setAttribute("successMessage", "Tao lead thanh cong!");
            response.sendRedirect(request.getContextPath() + "/manager/crm/leads?tab=unassigned");
        } else {
            request.setAttribute("error", "Luu lead that bai. Vui long thu lai.");
            request.setAttribute("lead", formLead);
            doGet(request, response);
        }
    }
}
