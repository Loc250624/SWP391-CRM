package controller.sale;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "SaleReportQuotationServlet", urlPatterns = {"/sale/report/quotation"})
public class SaleReportQuotationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("ACTIVE_MENU", "RPT_QUOTATION");
        request.setAttribute("pageTitle", "Quotation Report");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/report/quotation.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }
}
