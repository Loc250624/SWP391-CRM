package controller;

import dao.LeadDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "UpdateLeadStatusServlet", urlPatterns = {"/update-lead-status"})
public class UpdateLeadStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int leadId = Integer.parseInt(request.getParameter("leadId"));
        int statusId = Integer.parseInt(request.getParameter("statusId"));

        LeadDAO dao = new LeadDAO();
        boolean ok = dao.updateLeadStatus(leadId, statusId);

        // Redirect về /leads kèm thông báo
        if (ok) {
            response.sendRedirect(request.getContextPath() + "/leads?msg=Update+success");
        } else {
            response.sendRedirect(request.getContextPath() + "/leads?msg=Update+failed");
        }
    }
}

