package controller;

import dao.LeadDAO;
import dao.LeadStatusDAO;
import model.Lead;
import model.LeadStatus;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "LeadListServlet", urlPatterns = {"/leads"})
public class LeadListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LeadDAO leadDAO = new LeadDAO();
        LeadStatusDAO statusDAO = new LeadStatusDAO();

        // dropdown + tabs cần list status
        List<LeadStatus> statuses = statusDAO.getAll();
        request.setAttribute("leadStatuses", statuses);

        // params
        String statusIdRaw = request.getParameter("statusId");  // tab/filter
        String q = request.getParameter("q");                  // search

        List<Lead> leads;

        // 1) Filter by status
        if (statusIdRaw != null && !statusIdRaw.isBlank()) {
            int statusId = Integer.parseInt(statusIdRaw);

            // nếu có search kèm theo -> dùng hàm search + status
            if (q != null && !q.isBlank()) {
                leads = leadDAO.searchLeadsByStatus(statusId, q);
            } else {
                leads = leadDAO.getLeadsByStatus(statusId);
            }
        } else {
            // 2) All leads
            if (q != null && !q.isBlank()) {
                leads = leadDAO.searchLeads(q);
            } else {
                leads = leadDAO.getLeadsForPipeline();
            }
        }

        request.setAttribute("leads", leads);
        request.setAttribute("q", q); // giữ lại text search trên UI

        request.getRequestDispatcher("/view/sales/leads.jsp").forward(request, response);
    }
}
