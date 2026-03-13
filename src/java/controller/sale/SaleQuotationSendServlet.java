package controller.sale;

import dao.QuotationDAO;
import model.Quotation;
import java.io.IOException;
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
