package controller.sale;

import dao.OpportunityDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Opportunity;

@WebServlet(name = "SaleOpportunityStageUpdateServlet", urlPatterns = {"/sale/opportunity/stage"})
public class SaleOpportunityStageUpdateServlet extends HttpServlet {

    private OpportunityDAO opportunityDAO = new OpportunityDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        Integer currentUserId = 1;
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            try {
                currentUserId = (Integer) session.getAttribute("userId");
            } catch (Exception e) {
            }
        }

        String oppIdParam = request.getParameter("opportunityId");
        String stageIdParam = request.getParameter("stageId");

        if (oppIdParam == null || stageIdParam == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\":false,\"message\":\"Missing parameters\"}");
            return;
        }

        try {
            int oppId = Integer.parseInt(oppIdParam);
            int newStageId = Integer.parseInt(stageIdParam);

            Opportunity opp = opportunityDAO.getOpportunityById(oppId);
            if (opp == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"success\":false,\"message\":\"Opportunity not found\"}");
                return;
            }

            boolean hasPermission = (opp.getCreatedBy() != null && opp.getCreatedBy().equals(currentUserId))
                    || (opp.getOwnerId() != null && opp.getOwnerId().equals(currentUserId));

            if (!hasPermission) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                out.print("{\"success\":false,\"message\":\"No permission\"}");
                return;
            }

            opp.setStageId(newStageId);
            boolean success = opportunityDAO.updateOpportunity(opp);

            if (success) {
                out.print("{\"success\":true,\"message\":\"Stage updated\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"success\":false,\"message\":\"Update failed\"}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\":false,\"message\":\"Invalid parameters\"}");
        }
    }
}
