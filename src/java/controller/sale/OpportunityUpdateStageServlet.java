package controller.sale;

import dao.OpportunityDAO;
import dao.OpportunityHistoryDAO;
import model.Opportunity;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.SessionHelper;

@WebServlet(name = "OpportunityUpdateStageServlet", urlPatterns = {"/sale/opportunity/updateStage"})
public class OpportunityUpdateStageServlet extends HttpServlet {

    private OpportunityDAO opportunityDAO = new OpportunityDAO();
    private OpportunityHistoryDAO historyDAO = new OpportunityHistoryDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // Get parameters
            String opportunityIdParam = request.getParameter("opportunityId");
            String stageIdParam = request.getParameter("stageId");

            // Validate parameters
            if (opportunityIdParam == null || opportunityIdParam.isEmpty()
                    || stageIdParam == null || stageIdParam.isEmpty()) {
                out.print("{\"success\": false, \"message\": \"Missing required parameters\"}");
                return;
            }

            int opportunityId = Integer.parseInt(opportunityIdParam);
            int stageId = Integer.parseInt(stageIdParam);

            // Get the opportunity
            Opportunity opportunity = opportunityDAO.getOpportunityById(opportunityId);

            if (opportunity == null) {
                out.print("{\"success\": false, \"message\": \"Opportunity not found\"}");
                return;
            }

            // Block if already Won/Lost
            if ("Won".equals(opportunity.getStatus()) || "Lost".equals(opportunity.getStatus())) {
                out.print("{\"success\": false, \"message\": \"Opportunity da dong (Won/Lost), khong the thay doi.\"}");
                return;
            }

            // Log stage change
            int oldStageId = opportunity.getStageId();

            // Update the stage
            opportunity.setStageId(stageId);
            boolean updated = opportunityDAO.updateOpportunity(opportunity);

            if (updated) {
                // Log history
                Integer userId = SessionHelper.getLoggedInUserId(request);
                historyDAO.logChange(opportunityId, "stage_id", String.valueOf(oldStageId), String.valueOf(stageId), userId);

                out.print("{\"success\": true, \"message\": \"Stage updated successfully\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Failed to update stage\"}");
            }

        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"Invalid parameter format\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Internal server error: " + e.getMessage() + "\"}");
        } finally {
            out.flush();
        }
    }

    @Override
    public String getServletInfo() {
        return "Opportunity Update Stage Servlet - Updates opportunity stage via AJAX";
    }
}
