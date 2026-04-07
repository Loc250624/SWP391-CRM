package controller.sale;

import dao.LeadDAO;
import dao.OpportunityDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Lead;
import model.Opportunity;
import util.SessionHelper;

@WebServlet(name = "SaleLeadOpportunitiesServlet", urlPatterns = {"/sale/lead/opportunities"})
public class SaleLeadOpportunitiesServlet extends HttpServlet {

    private LeadDAO leadDAO = new LeadDAO();
    private OpportunityDAO opportunityDAO = new OpportunityDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Integer currentUserId = SessionHelper.getLoggedInUserId(request);
        if (currentUserId == null) {
            response.setStatus(401);
            response.getWriter().write("[]");
            return;
        }

        String leadIdParam = request.getParameter("leadId");
        if (leadIdParam == null || leadIdParam.isEmpty()) {
            response.getWriter().write("[]");
            return;
        }

        try {
            int leadId = Integer.parseInt(leadIdParam);

            // Check permission
            Lead lead = leadDAO.getLeadById(leadId);
            if (lead == null) {
                response.getWriter().write("[]");
                return;
            }
            boolean hasPermission = (lead.getCreatedBy() != null && lead.getCreatedBy().equals(currentUserId))
                    || (lead.getAssignedTo() != null && lead.getAssignedTo().equals(currentUserId));
            if (!hasPermission) {
                response.setStatus(403);
                response.getWriter().write("[]");
                return;
            }

            List<Opportunity> opps = opportunityDAO.getOpportunitiesByLeadId(leadId);

            // Build JSON manually (no external library dependency)
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < opps.size(); i++) {
                Opportunity opp = opps.get(i);
                if (i > 0) json.append(",");
                json.append("{");
                json.append("\"opportunityId\":").append(opp.getOpportunityId()).append(",");
                json.append("\"opportunityCode\":\"").append(escapeJson(opp.getOpportunityCode())).append("\",");
                json.append("\"opportunityName\":\"").append(escapeJson(opp.getOpportunityName())).append("\",");
                json.append("\"status\":\"").append(escapeJson(opp.getStatus())).append("\",");
                json.append("\"estimatedValue\":").append(opp.getEstimatedValue() != null ? opp.getEstimatedValue().toPlainString() : "null");
                json.append("}");
            }
            json.append("]");

            response.getWriter().write(json.toString());
        } catch (NumberFormatException e) {
            response.getWriter().write("[]");
        }
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }
}
