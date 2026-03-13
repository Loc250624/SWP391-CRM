package controller.marketing;

import dao.EmailLogDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.EmailLog;

@WebServlet(name = "MarketingEmailLogServlet", urlPatterns = {"/marketing/email/log"})
public class MarketingEmailLogServlet extends HttpServlet {

    private EmailLogDAO logDAO = new EmailLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<EmailLog> logs = logDAO.getAllLogs();

        request.setAttribute("logs", logs);
        request.setAttribute("ACTIVE_MENU", "EMAIL_LOG");
        request.setAttribute("pageTitle", "Lịch sử gửi Email");
        request.setAttribute("CONTENT_PAGE", "/view/marketing/email/log_list.jsp");
        request.getRequestDispatcher("/view/marketing/layout.jsp").forward(request, response);
    }
}
