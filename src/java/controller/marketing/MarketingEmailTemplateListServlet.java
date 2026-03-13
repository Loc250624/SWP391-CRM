package controller.marketing;

import dao.EmailTemplateDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.EmailTemplate;

@WebServlet(name = "MarketingEmailTemplateListServlet", urlPatterns = {"/marketing/email/template/list"})
public class MarketingEmailTemplateListServlet extends HttpServlet {

    private EmailTemplateDAO templateDAO = new EmailTemplateDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<EmailTemplate> templates = templateDAO.getAllTemplates();

        request.setAttribute("templates", templates);
        request.setAttribute("ACTIVE_MENU", "EMAIL_TEMPLATES");
        request.setAttribute("pageTitle", "Mẫu Email");
        request.setAttribute("CONTENT_PAGE", "/view/marketing/email/template_list.jsp");
        request.getRequestDispatcher("/view/marketing/layout.jsp").forward(request, response);
    }
}
