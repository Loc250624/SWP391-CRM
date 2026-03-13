package controller.sale;

import dao.QuotationDAO;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.SessionHelper;

@WebServlet(name = "SaleQuotationTrackingServlet", urlPatterns = {"/sale/quotation/tracking"})
public class SaleQuotationTrackingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer currentUserId = SessionHelper.getLoggedInUserId(request);
        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        QuotationDAO quotDAO = new QuotationDAO();

        // Stats
        Map<String, Integer> stats = quotDAO.getTrackingStats(currentUserId);
        request.setAttribute("stats", stats);

        // Tracking list
        List<Map<String, Object>> trackingList = quotDAO.getTrackingOverview(currentUserId);
        request.setAttribute("trackingList", trackingList);

        request.setAttribute("ACTIVE_MENU", "QUOT_TRACKING");
        request.setAttribute("pageTitle", "Theo doi Bao gia");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/quotation/tracking.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }
}
