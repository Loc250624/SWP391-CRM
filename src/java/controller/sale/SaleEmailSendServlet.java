package controller.sale;

import dao.ActivityDAO;
import dao.EmailTemplateDAO;
import model.EmailTemplate;
import util.EmailSendUtil;
import util.SessionHelper;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "SaleEmailSendServlet", urlPatterns = {"/sale/email/send"})
public class SaleEmailSendServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer currentUserId = SessionHelper.getLoggedInUserId(request);
        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

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

            // Check role access
            if (t.getAllowedRoles() != null && !t.getAllowedRoles().isEmpty()
                    && !t.getAllowedRoles().contains("SALES")) {
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
        List<EmailTemplate> templates = new EmailTemplateDAO().getActiveByRole("SALES");
        request.setAttribute("templates", templates);
        request.setAttribute("smtpConfigured", EmailSendUtil.isConfigured());

        request.setAttribute("ACTIVE_MENU", "EMAIL_SEND");
        request.setAttribute("pageTitle", "Gửi Email");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/email/email-send.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Integer currentUserId = SessionHelper.getLoggedInUserId(request);
        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        HttpSession session = request.getSession();

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
            response.sendRedirect(request.getContextPath() + "/sale/email/send");
            return;
        }
        if (subject == null || subject.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Chủ đề email không được để trống");
            response.sendRedirect(request.getContextPath() + "/sale/email/send");
            return;
        }

        EmailSendUtil.EmailRequest emailReq = new EmailSendUtil.EmailRequest();
        emailReq.setTo(toEmail.trim());
        emailReq.setToName(toName != null ? toName.trim() : null);
        emailReq.setSubject(subject.trim());
        emailReq.setHtmlBody(bodyHtml);
        emailReq.setSentByUserId(currentUserId);
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

            // Log activity
            String relatedType = request.getParameter("relatedType");
            String relatedIdStr = request.getParameter("relatedId");
            Integer relatedId = null;
            if (relatedIdStr != null && !relatedIdStr.isEmpty()) {
                try { relatedId = Integer.parseInt(relatedIdStr); } catch (NumberFormatException ignored) {}
            }

            String recipient = (toName != null && !toName.trim().isEmpty())
                    ? toName.trim() + " (" + toEmail.trim() + ")"
                    : toEmail.trim();
            String actDesc = "Đã gửi email đến " + recipient + "\nChủ đề: " + subject.trim();

            new ActivityDAO().insertSaleActivity(
                    "Email",
                    relatedType != null && !relatedType.isEmpty() ? relatedType : "Customer",
                    relatedId != null ? relatedId : 0,
                    "Gửi email: " + subject.trim(),
                    actDesc,
                    new Timestamp(System.currentTimeMillis()),
                    null, null, null,
                    currentUserId,
                    "Completed");
        } else {
            session.setAttribute("errorMessage", result.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/sale/email/send");
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
