package controller.marketing;

import dao.EmailTemplateDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.EmailTemplate;
import util.SessionHelper;

@WebServlet(name = "MarketingEmailTemplateFormServlet", urlPatterns = { "/marketing/email/template/form" })
public class MarketingEmailTemplateFormServlet extends HttpServlet {

    private EmailTemplateDAO templateDAO = new EmailTemplateDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                EmailTemplate template = templateDAO.getTemplateById(id);
                request.setAttribute("template", template);
            } catch (NumberFormatException e) {
                // ignore
            }
        }

        request.setAttribute("ACTIVE_MENU", "EMAIL_TEMPLATES");
        request.setAttribute("pageTitle", idStr == null ? "Tạo mẫu Email mới" : "Chỉnh sửa mẫu Email");
        request.setAttribute("CONTENT_PAGE", "/view/marketing/email/template_form.jsp");
        request.getRequestDispatcher("/view/marketing/layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = SessionHelper.getLoggedInUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idStr = request.getParameter("templateId");
        EmailTemplate t;
        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            t = templateDAO.getTemplateById(id);
            t.setUpdatedBy(userId);
        } else {
            t = new EmailTemplate();
            t.setCreatedBy(userId);
            t.setUpdatedBy(userId);
        }

        t.setTemplateCode(request.getParameter("templateCode"));
        t.setTemplateName(request.getParameter("templateName"));
        t.setCategory(request.getParameter("category"));
        t.setSubject(request.getParameter("subject"));
        t.setBodyHtml(request.getParameter("bodyHtml"));
        t.setBodyText(request.getParameter("bodyText"));
        t.setDescription(request.getParameter("description"));
        t.setIsActive(request.getParameter("isActive") != null);
        t.setIsDefault(request.getParameter("isDefault") != null);

        // Mocking available variables for now
        t.setAvailableVariables("{full_name}, {email}, {company_name}");

        boolean success;
        if (t.getTemplateId() != null && t.getTemplateId() > 0) {
            success = templateDAO.updateTemplate(t);
        } else {
            success = templateDAO.insertTemplate(t);
        }

        if (success) {
            response.sendRedirect(request.getContextPath() + "/marketing/email/template/list?msg=success");
        } else {
            request.setAttribute("error", "Không thể lưu mẫu email. Vui lòng kiểm tra lại dữ liệu.");
            request.setAttribute("template", t);
            doGet(request, response);
        }
    }
}
