package controller.sale;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "SaleReportForecastServlet", urlPatterns = {"/sale/report/forecast"})
public class SaleReportForecastServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("ACTIVE_MENU", "RPT_FORECAST");
        request.setAttribute("pageTitle", "Forecast Report");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/report/forecast.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }
}
