package controller.manager;

import dao.EmailTemplateDAO;
import dao.UserDAO;
import model.EmailTemplate;
import util.EmailSendUtil;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;

@WebServlet(name = "ManagerEmailSendServlet", urlPatterns = {"/manager/email/send"})
public class ManagerEmailSendServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Users currentUser = (Users) session.getAttribute("user");
        UserDAO userDAO = new UserDAO();
        String roleCode = userDAO.getRoleCodeByUserId(currentUser.getUserId());

        if (!"MANAGER".equals(roleCode)) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        // Load templates for dropdown
        List<EmailTemplate> templates = new EmailTemplateDAO().getActiveTemplates();
        request.setAttribute("templates", templates);
        request.setAttribute("smtpConfigured", EmailSendUtil.isConfigured());

        request.setAttribute("ACTIVE_MENU", "EMAIL_MANAGE");
        request.setAttribute("pageTitle", "Gửi Email");
        request.setAttribute("CONTENT_PAGE", "/view/manager/email/email-send.jsp");
        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Users currentUser = (Users) session.getAttribute("user");
        UserDAO userDAO = new UserDAO();
        if (!"MANAGER".equals(userDAO.getRoleCodeByUserId(currentUser.getUserId()))) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        String toEmail = request.getParameter("toEmail");
        String toName = request.getParameter("toName");
        String ccEmails = request.getParameter("ccEmails");
        String bccEmails = request.getParameter("bccEmails");
        String subject = request.getParameter("subject");
        String bodyHtml = request.getParameter("bodyHtml");
        String fromEmail = request.getParameter("fromEmail");
        String fromName = request.getParameter("fromName");

        if (toEmail == null || toEmail.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Email người nhận không được để trống");
            response.sendRedirect(request.getContextPath() + "/manager/email/send");
            return;
        }
        if (subject == null || subject.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Chủ đề email không được để trống");
            response.sendRedirect(request.getContextPath() + "/manager/email/send");
            return;
        }

        EmailSendUtil.EmailRequest emailReq = new EmailSendUtil.EmailRequest();
        emailReq.setTo(toEmail.trim());
        emailReq.setToName(toName != null ? toName.trim() : null);
        emailReq.setSubject(subject.trim());
        emailReq.setHtmlBody(bodyHtml);
        emailReq.setSentByUserId(currentUser.getUserId());
        emailReq.setRelatedType("MANUAL");

        if (ccEmails != null && !ccEmails.trim().isEmpty()) {
            emailReq.setCc(java.util.Arrays.asList(ccEmails.split(",")));
        }
        if (bccEmails != null && !bccEmails.trim().isEmpty()) {
            emailReq.setBcc(java.util.Arrays.asList(bccEmails.split(",")));
        }

        EmailSendUtil.EmailResult result = EmailSendUtil.send(emailReq,
                fromEmail != null && !fromEmail.isEmpty() ? fromEmail : null,
                fromName != null && !fromName.isEmpty() ? fromName : null);

        if (result.isSuccess()) {
            session.setAttribute("successMessage", "Email đã gửi thành công đến " + toEmail);
        } else {
            session.setAttribute("errorMessage", result.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/manager/email");
    }
}
