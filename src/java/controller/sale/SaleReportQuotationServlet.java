package controller.sale;

import dao.QuotationDAO;
import model.Quotation;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.SessionHelper;

@WebServlet(name = "SaleReportQuotationServlet", urlPatterns = {"/sale/report/quotation"})
public class SaleReportQuotationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer currentUserId = SessionHelper.getLoggedInUserId(request);
        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        QuotationDAO quotDAO = new QuotationDAO();
        List<Quotation> allQuots = quotDAO.getQuotationsByUserId(currentUserId);
        if (allQuots == null) allQuots = new ArrayList<>();

        Map<String, Integer> statusCounts = quotDAO.countByStatus(currentUserId);

        int total = allQuots.size();
        int draftCount = statusCounts.getOrDefault("Draft", 0);
        int sentCount = statusCounts.getOrDefault("Sent", 0);
        int acceptedCount = statusCounts.getOrDefault("Accepted", 0);
        int rejectedCount = statusCounts.getOrDefault("Rejected", 0);

        int responded = acceptedCount + rejectedCount;
        int sentAndResponded = sentCount + responded;
        int acceptanceRate = responded > 0 ? (acceptedCount * 100 / responded) : 0;

        BigDecimal totalValue = BigDecimal.ZERO;
        int valueCount = 0;
        for (Quotation q : allQuots) {
            if (q.getTotalAmount() != null && q.getTotalAmount().compareTo(BigDecimal.ZERO) > 0) {
                totalValue = totalValue.add(q.getTotalAmount());
                valueCount++;
            }
        }
        BigDecimal avgValue = valueCount > 0
                ? totalValue.divide(BigDecimal.valueOf(valueCount), 0, RoundingMode.HALF_UP)
                : BigDecimal.ZERO;

        request.setAttribute("total", total);
        request.setAttribute("draftCount", draftCount);
        request.setAttribute("sentCount", sentCount);
        request.setAttribute("acceptedCount", acceptedCount);
        request.setAttribute("rejectedCount", rejectedCount);
        request.setAttribute("acceptanceRate", acceptanceRate);
        request.setAttribute("avgValue", avgValue);

        request.setAttribute("ACTIVE_MENU", "RPT_QUOTATION");
        request.setAttribute("pageTitle", "Bao cao Bao gia");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/report/quotation.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }
}
