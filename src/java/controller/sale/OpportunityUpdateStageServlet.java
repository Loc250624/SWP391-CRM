package controller.sale;

import dao.OpportunityDAO;
import model.Opportunity;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "OpportunityUpdateStageServlet", urlPatterns = {"/sale/opportunity/updateStage"})
public class OpportunityUpdateStageServlet extends HttpServlet {

    private OpportunityDAO opportunityDAO = new OpportunityDAO();

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

            // Update the stage
            opportunity.setStageId(stageId);
            boolean updated = opportunityDAO.updateOpportunity(opportunity);

            if (updated) {
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
