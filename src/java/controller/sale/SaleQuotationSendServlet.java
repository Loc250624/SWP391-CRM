package controller.sale;

import dao.CustomerDAO;
import dao.QuotationDAO;
import model.Customer;
import model.Quotation;
import util.EmailSendUtil;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.SessionHelper;

@WebServlet(name = "SaleQuotationSendServlet", urlPatterns = {"/sale/quotation/send"})
public class SaleQuotationSendServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer currentUserId = SessionHelper.getLoggedInUserId(request);
        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idParam = request.getParameter("quotationId");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/sale/quotation/list");
            return;
        }

        int quotationId = Integer.parseInt(idParam);
        QuotationDAO quotDAO = new QuotationDAO();
        Quotation q = quotDAO.getQuotationById(quotationId);

        if (q == null || !"Approved".equals(q.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/sale/quotation/detail?id=" + quotationId + "&error=invalid_status");
            return;
        }

        boolean success = quotDAO.sendQuotation(quotationId, currentUserId);
        if (success) {
            String ip = request.getRemoteAddr();
            String ua = request.getHeader("User-Agent");
            String deviceType = parseDeviceType(ua);
            String browser = parseBrowser(ua);
            quotDAO.insertTrackingLog(quotationId, "SENT", ip, ua, deviceType, browser);

            // Notify quotation sent
            java.util.List<Integer> notifyIds = new java.util.ArrayList<>();
            if (q.getCreatedBy() != null && q.getCreatedBy() != currentUserId) {
                notifyIds.add(q.getCreatedBy());
            }
            if (!notifyIds.isEmpty()) {
                util.NotificationUtil.notifyQuotationSent(
                        quotationId, q.getQuotationCode(),
                        q.getOpportunityId() != null ? q.getOpportunityId() : 0,
                        currentUserId, notifyIds);
            }

            // Auto-send quotation email to customer
            if (EmailSendUtil.isConfigured() && q.getCustomerId() != null) {
                Customer cust = new CustomerDAO().getCustomerById(q.getCustomerId());
                if (cust != null && cust.getEmail() != null && !cust.getEmail().isEmpty()) {
                    Map<String, String> vars = new HashMap<>();
                    vars.put("customer_name", cust.getFullName());
                    vars.put("quotation_code", q.getQuotationCode());
                    vars.put("total_amount", q.getTotalAmount() != null ? q.getTotalAmount().toPlainString() : "0");
                    vars.put("valid_until", q.getValidUntil() != null ? q.getValidUntil().toString() : "");
                    vars.put("currency", q.getCurrency() != null ? q.getCurrency() : "VND");
                    EmailSendUtil.sendWithTemplateAsync("QUOT_SEND", vars,
                            cust.getEmail(), cust.getFullName(), currentUserId);
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/sale/quotation/detail?id=" + quotationId + "&sent=1");
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
