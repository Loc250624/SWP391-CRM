package controller.customersuccess;

import dao.EmailTemplateDAO;
import dao.UserDAO;
import model.EmailTemplate;
import model.Users;
import util.EmailSendUtil;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "SupportEmailSendServlet", urlPatterns = {"/support/email/send"})
public class SupportEmailSendServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Users currentUser = (Users) session.getAttribute("user");
        String action = request.getParameter("action");

        // API: template detail
        if ("templateDetail".equals(action)) {
            response.setContentType("application/json;charset=UTF-8");
            PrintWriter out = response.getWriter();
            int id = 0;
            try { id = Integer.parseInt(request.getParameter("id")); } catch (Exception ignored) {}
            if (id <= 0) { out.write("{\"error\":\"invalid id\"}"); return; }

            EmailTemplate t = new EmailTemplateDAO().getById(id);
            if (t == null) { out.write("{\"error\":\"not found\"}"); return; }

            if (t.getAllowedRoles() != null && !t.getAllowedRoles().isEmpty()
                    && !t.getAllowedRoles().contains("SUPPORT")) {
                out.write("{\"error\":\"Bạn không có quyền sử dụng mẫu này\"}");
                return;
            }

            out.write("{\"id\":" + t.getTemplateId()
                    + ",\"subject\":" + jsonStr(t.getSubject())
                    + ",\"bodyHtml\":" + jsonStr(t.getBodyHtml())
                    + ",\"variables\":" + jsonStr(t.getAvailableVariables())
                    + "}");
            return;
        }

        // Page render
        List<EmailTemplate> templates = new EmailTemplateDAO().getActiveByRole("SUPPORT");
        request.setAttribute("templates", templates);
        request.setAttribute("smtpConfigured", EmailSendUtil.isConfigured());

        request.setAttribute("pageTitle", "Gửi Email");
        request.setAttribute("contentPage", "/view/customersuccess/pages/email/email-send.jsp");
        request.getRequestDispatcher("/view/customersuccess/pages/main_layout.jsp").forward(request, response);
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
            response.sendRedirect(request.getContextPath() + "/support/email/send");
            return;
        }
        if (subject == null || subject.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Chủ đề email không được để trống");
            response.sendRedirect(request.getContextPath() + "/support/email/send");
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

        response.sendRedirect(request.getContextPath() + "/support/email/send");
    }

    private String jsonStr(String val) {
        if (val == null) return "null";
        return "\"" + val.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t") + "\"";
    }
}
