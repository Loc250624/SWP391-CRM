package controller.sale;

import dao.CustomerDAO;
import dao.LeadDAO;
import dao.OpportunityDAO;
import dao.QuotationDAO;
import dao.UserDAO;
import model.Customer;
import model.Lead;
import model.Opportunity;
import model.Quotation;
import model.Users;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.SessionHelper;

@WebServlet(name = "SaleQuotationDetailServlet", urlPatterns = {"/sale/quotation/detail"})
public class SaleQuotationDetailServlet extends HttpServlet {

    private final QuotationDAO quotationDAO = new QuotationDAO();
    private final OpportunityDAO oppDAO = new OpportunityDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();
    private final LeadDAO leadDAO = new LeadDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer currentUserId = SessionHelper.getLoggedInUserId(request);
        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/sale/quotation/list");
            return;
        }

        try {
            int quotationId = Integer.parseInt(idParam);
            Quotation quotation = quotationDAO.getQuotationById(quotationId);

            if (quotation == null) {
                response.sendRedirect(request.getContextPath() + "/sale/quotation/list");
                return;
            }

            // Load items
            List<Map<String, Object>> items = quotationDAO.getItemsByQuotationId(quotationId);
            request.setAttribute("items", items);

            // Load versions
            List<Map<String, Object>> versions = quotationDAO.getVersionsByQuotationId(quotationId);
            request.setAttribute("versions", versions);

            // Load tracking logs
            List<Map<String, Object>> trackingLogs = quotationDAO.getTrackingLogsByQuotationId(quotationId);
            request.setAttribute("trackingLogs", trackingLogs);

            // Load linked opportunity name
            if (quotation.getOpportunityId() != null) {
                Opportunity opp = oppDAO.getOpportunityById(quotation.getOpportunityId());
                if (opp != null) {
                    request.setAttribute("linkedOpp", opp);
                }
            }

            // Load linked lead name
            if (quotation.getLeadId() != null) {
                Lead lead = leadDAO.getLeadById(quotation.getLeadId());
                if (lead != null) {
                    request.setAttribute("linkedLead", lead);
                }
            }

            // Load linked customer name
            if (quotation.getCustomerId() != null) {
                Customer customer = customerDAO.getCustomerById(quotation.getCustomerId());
                if (customer != null) {
                    request.setAttribute("linkedCustomer", customer);
                }
            }

            // Load approvedBy user name
            if (quotation.getApprovedBy() != null) {
                Users approver = userDAO.getUserById(quotation.getApprovedBy());
                if (approver != null) {
                    request.setAttribute("approverName", approver.getFirstName() + " " + approver.getLastName());
                }
            }

            // Load sentBy user name
            if (quotation.getSentBy() != null) {
                Users sender = userDAO.getUserById(quotation.getSentBy());
                if (sender != null) {
                    request.setAttribute("senderName", sender.getFirstName() + " " + sender.getLastName());
                }
            }

            // Load createdBy user name
            if (quotation.getCreatedBy() != null) {
                Users creator = userDAO.getUserById(quotation.getCreatedBy());
                if (creator != null) {
                    request.setAttribute("creatorName", creator.getFirstName() + " " + creator.getLastName());
                }
            }

            // Insert tracking log for viewing
            String ip = request.getRemoteAddr();
            String ua = request.getHeader("User-Agent");
            String deviceType = parseDeviceType(ua);
            String browser = parseBrowser(ua);
            quotationDAO.insertTrackingLog(quotationId, "VIEWED", ip, ua, deviceType, browser);

            request.setAttribute("quotation", quotation);
            request.setAttribute("ACTIVE_MENU", "QUOT_LIST");
            request.setAttribute("pageTitle", "Chi tiet Bao gia - " + quotation.getQuotationCode());
            request.setAttribute("CONTENT_PAGE", "/view/sale/pages/quotation/detail.jsp");
            request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/sale/quotation/list");
        }
    }

    private String parseDeviceType(String ua) {
        if (ua == null) return "Unknown";
        String lower = ua.toLowerCase();
        if (lower.contains("mobile") || lower.contains("android") || lower.contains("iphone")) return "Mobile";
        if (lower.contains("tablet") || lower.contains("ipad")) return "Tablet";
        return "Desktop";
    }

    private String parseBrowser(String ua) {
        if (ua == null) return "Unknown";
        if (ua.contains("Edg/")) return "Edge";
        if (ua.contains("Chrome/")) return "Chrome";
        if (ua.contains("Firefox/")) return "Firefox";
        if (ua.contains("Safari/") && !ua.contains("Chrome")) return "Safari";
        return "Other";
    }
}
