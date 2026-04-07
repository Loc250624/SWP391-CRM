package controller.sale;

import dao.CustomerDAO;
import dao.LeadDAO;
import dao.OpportunityDAO;
import dao.QuotationDAO;
import model.Customer;
import model.Lead;
import model.Opportunity;
import model.Quotation;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.SessionHelper;

@WebServlet(name = "SaleQuotationListServlet", urlPatterns = {"/sale/quotation/list"})
public class SaleQuotationListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Integer currentUserId = SessionHelper.getLoggedInUserId(request);
        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        QuotationDAO quotDAO = new QuotationDAO();
        OpportunityDAO oppDAO = new OpportunityDAO();
        LeadDAO leadDAO = new LeadDAO();
        CustomerDAO customerDAO = new CustomerDAO();

        String keyword = request.getParameter("keyword");
        String statusFilter = request.getParameter("status");

        List<Quotation> quotations;
        if ((keyword != null && !keyword.trim().isEmpty()) || (statusFilter != null && !statusFilter.trim().isEmpty())) {
            quotations = quotDAO.searchQuotations(currentUserId, keyword, statusFilter);
        } else {
            quotations = quotDAO.getQuotationsByUserId(currentUserId);
        }

        // Build name maps
        Map<Integer, String> oppNameMap = new HashMap<>();
        Map<Integer, String> leadNameMap = new HashMap<>();
        Map<Integer, String> customerNameMap = new HashMap<>();

        for (Quotation q : quotations) {
            if (q.getOpportunityId() != null && !oppNameMap.containsKey(q.getOpportunityId())) {
                Opportunity opp = oppDAO.getOpportunityById(q.getOpportunityId());
                if (opp != null) oppNameMap.put(q.getOpportunityId(), opp.getOpportunityName());
            }
            if (q.getLeadId() != null && !leadNameMap.containsKey(q.getLeadId())) {
                Lead lead = leadDAO.getLeadById(q.getLeadId());
                if (lead != null) leadNameMap.put(q.getLeadId(), lead.getFullName());
            }
            if (q.getCustomerId() != null && !customerNameMap.containsKey(q.getCustomerId())) {
                Customer cust = customerDAO.getCustomerById(q.getCustomerId());
                if (cust != null) customerNameMap.put(q.getCustomerId(), cust.getFullName());
            }
        }

        // Counts by status
        Map<String, Integer> statusCounts = quotDAO.countByStatus(currentUserId);
        int total = 0;
        for (int c : statusCounts.values()) total += c;

        request.setAttribute("quotations", quotations);
        request.setAttribute("oppNameMap", oppNameMap);
        request.setAttribute("leadNameMap", leadNameMap);
        request.setAttribute("customerNameMap", customerNameMap);
        request.setAttribute("statusCounts", statusCounts);
        request.setAttribute("totalCount", total);
        request.setAttribute("keyword", keyword);
        request.setAttribute("statusFilter", statusFilter);

        request.setAttribute("ACTIVE_MENU", "QUOT_LIST");
        request.setAttribute("pageTitle", "Danh sach De xuat & Bao gia");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/quotation/list.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }
}
