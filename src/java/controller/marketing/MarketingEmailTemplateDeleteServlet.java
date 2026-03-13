package controller.marketing;

import dao.EmailTemplateDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "MarketingEmailTemplateDeleteServlet", urlPatterns = { "/marketing/email/template/delete" })
public class MarketingEmailTemplateDeleteServlet extends HttpServlet {

    private EmailTemplateDAO templateDAO = new EmailTemplateDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                boolean success = templateDAO.deleteTemplate(id);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/marketing/email/template/list?msg=deleted");
                } else {
                    response.sendRedirect(
                            request.getContextPath() + "/marketing/email/template/list?error=delete_failed");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/marketing/email/template/list?error=invalid_id");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/marketing/email/template/list");
        }
    }
}
