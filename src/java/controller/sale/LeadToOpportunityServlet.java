package controller.sale;

import dao.LeadDAO;
import model.Lead;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LeadToOpportunityServlet", urlPatterns = {"/sale/lead/convert"})
public class LeadToOpportunityServlet extends HttpServlet {

    private LeadDAO leadDAO = new LeadDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get lead ID parameter
        String leadIdParam = request.getParameter("id");

        if (leadIdParam == null || leadIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/sale/lead/list?error=no_lead");
            return;
        }

        try {
            int leadId = Integer.parseInt(leadIdParam);

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

            // Get lead to verify it exists and user has permission
            Lead lead = leadDAO.getLeadById(leadId);

            if (lead == null) {
                response.sendRedirect(request.getContextPath() + "/sale/lead/list?error=lead_not_found");
                return;
            }

            // Check permission
            boolean hasPermission = (lead.getCreatedBy() != null && lead.getCreatedBy().equals(currentUserId))
                    || (lead.getAssignedTo() != null && lead.getAssignedTo().equals(currentUserId));

            if (!hasPermission) {
                response.sendRedirect(request.getContextPath() + "/sale/lead/list?error=no_permission");
                return;
            }

            // Check if lead is already converted
            if (lead.isIsConverted()) {
                response.sendRedirect(request.getContextPath() + "/sale/lead/list?error=already_converted");
                return;
            }

            // Redirect to opportunity form with lead ID
            response.sendRedirect(request.getContextPath() + "/sale/opportunity/form?leadId=" + leadId);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/sale/lead/list?error=invalid_lead_id");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get lead ID parameter
        String leadIdParam = request.getParameter("leadId");

        if (leadIdParam == null || leadIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/sale/lead/list?error=no_lead");
            return;
        }

        try {
            int leadId = Integer.parseInt(leadIdParam);

            // Mark lead as converted
            Lead lead = leadDAO.getLeadById(leadId);
            if (lead != null) {
                lead.setIsConverted(true);
                lead.setStatus("Converted");
                leadDAO.updateLead(lead);
            }

            // Redirect back to opportunity form
            response.sendRedirect(request.getContextPath() + "/sale/opportunity/list?success=converted");

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/sale/lead/list?error=invalid_lead_id");
        }
    }

    @Override
    public String getServletInfo() {
        return "Lead To Opportunity Servlet - Converts leads to opportunities";
    }
}
