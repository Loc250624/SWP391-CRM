package controller.sale;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "SaleReportRevenueServlet", urlPatterns = {"/sale/report/revenue"})
public class SaleReportRevenueServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("ACTIVE_MENU", "RPT_REVENUE");
        request.setAttribute("pageTitle", "Revenue Report");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/report/revenue.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }
}
