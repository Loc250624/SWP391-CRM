/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.sale;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import dao.CampaignDAO;
import dao.LeadDAO;
import dao.LeadSourceDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.SessionHelper;
import model.Campaign;
import model.Lead;
import model.LeadSource;

@WebServlet(name = "SaleLeadDetailServlet", urlPatterns = {"/sale/lead/detail"})
public class SaleLeadDetailServlet extends HttpServlet {

    private LeadDAO leadDAO = new LeadDAO();
    private LeadSourceDAO leadSourceDAO = new LeadSourceDAO();
    private CampaignDAO campaignDAO = new CampaignDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String leadIdParam = request.getParameter("id");
        String format = request.getParameter("format");

        if (leadIdParam == null || leadIdParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Lead ID is required");
            return;
        }

        try {
            int leadId = Integer.parseInt(leadIdParam);

            Integer currentUserId = SessionHelper.getLoggedInUserId(request);
            if (currentUserId == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Get lead
            Lead lead = leadDAO.getLeadById(leadId);

            if (lead == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Lead not found");
                return;
            }

            // Check permission
            boolean hasPermission = (lead.getCreatedBy() != null && lead.getCreatedBy().equals(currentUserId))
                    || (lead.getAssignedTo() != null && lead.getAssignedTo().equals(currentUserId));

            if (!hasPermission) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }

            // Return JSON format for AJAX
            if ("json".equals(format)) {
                response.setContentType("application/json;charset=UTF-8");

                // Get related data
                LeadSource source = null;
                Campaign campaign = null;

                if (lead.getSourceId() != null) {
                    source = leadSourceDAO.getSourceById(lead.getSourceId());
                }

                if (lead.getCampaignId() != null) {
                    campaign = campaignDAO.getCampaignById(lead.getCampaignId());
                }

                // Build JSON response
                LeadDetailResponse detailResponse = new LeadDetailResponse();
                detailResponse.lead = lead;
                detailResponse.sourceName = source != null ? source.getSourceName() : null;
                detailResponse.campaignName = campaign != null ? campaign.getCampaignName() : null;

                // Use Gson with custom serializer for LocalDateTime
                Gson gson = new GsonBuilder()
                        .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
                        .create();

                PrintWriter out = response.getWriter();
                out.print(gson.toJson(detailResponse));
                out.flush();

            } else {
                // Regular page view
                // Get related data
                LeadSource source = null;
                Campaign campaign = null;
                if (lead.getSourceId() != null) {
                    source = leadSourceDAO.getSourceById(lead.getSourceId());
                }
                if (lead.getCampaignId() != null) {
                    campaign = campaignDAO.getCampaignById(lead.getCampaignId());
                }

                request.setAttribute("lead", lead);
                request.setAttribute("sourceName", source != null ? source.getSourceName() : null);
                request.setAttribute("campaignName", campaign != null ? campaign.getCampaignName() : null);
                request.setAttribute("ACTIVE_MENU", "LEAD_LIST");
                request.setAttribute("pageTitle", "Lead Detail - " + lead.getFullName());
                request.setAttribute("CONTENT_PAGE", "/view/sale/pages/lead/detail.jsp");
                request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid lead ID");
        }
    }

    @Override
    public String getServletInfo() {
        return "Lead Detail Servlet - Returns lead detail in JSON format";
    }

    // Inner class for JSON response
    private static class LeadDetailResponse {

        public Lead lead;
        public String sourceName;
        public String campaignName;
    }

    // Custom adapter for LocalDateTime
    private static class LocalDateTimeAdapter extends com.google.gson.TypeAdapter<LocalDateTime> {

        @Override
        public void write(com.google.gson.stream.JsonWriter out, LocalDateTime value) throws IOException {
            if (value == null) {
                out.nullValue();
            } else {
                out.value(value.toString());
            }
        }

        @Override
        public LocalDateTime read(com.google.gson.stream.JsonReader in) throws IOException {
            if (in.peek() == com.google.gson.stream.JsonToken.NULL) {
                in.nextNull();
                return null;
            }
            return LocalDateTime.parse(in.nextString());
        }
    }
}
