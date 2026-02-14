package controller.sale;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "SaleReportWinLossServlet", urlPatterns = {"/sale/report/win-loss"})
public class SaleReportWinLossServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("ACTIVE_MENU", "RPT_WINLOSS");
        request.setAttribute("pageTitle", "Win/Loss Report");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/report/win-loss.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }
}
