package controller.manager;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import dao.CustomerDAO;
import dao.EmailLogDAO;
import dao.EmailTemplateDAO;
import dao.LeadDAO;
import dao.UserDAO;
import model.Customer;
import model.EmailLog;
import model.EmailTemplate;
import model.Lead;
import model.Users;
import util.EmailSendUtil;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

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

        // Load failed email for retry/edit
        String retryParam = request.getParameter("retry");
        if (retryParam != null && !retryParam.isEmpty()) {
            try {
                int retryLogId = Integer.parseInt(retryParam);
                EmailLog retryLog = new EmailLogDAO().getById(retryLogId);
                if (retryLog != null) {
                    request.setAttribute("retryLog", retryLog);
                }
            } catch (NumberFormatException ignored) {}
        }

        // Load templates for dropdown
        List<EmailTemplate> templates = new EmailTemplateDAO().getActiveTemplates();
        request.setAttribute("templates", templates);
        request.setAttribute("smtpConfigured", EmailSendUtil.isConfigured());

        // Load recipients
        List<Customer> customers = new CustomerDAO().getAllCustomers();
        List<Lead> leads = new LeadDAO().getAllLeads();
        List<Users> saleUsers = userDAO.getUsersByRoleCode("SALES");
        List<Users> supportUsers = userDAO.getUsersByRoleCode("SUPPORT");
        request.setAttribute("customers", customers);
        request.setAttribute("leads", leads);
        request.setAttribute("saleUsers", saleUsers);
        request.setAttribute("supportUsers", supportUsers);

        request.setAttribute("ACTIVE_MENU", "EMAIL_MANAGE");
        request.setAttribute("pageTitle", request.getAttribute("retryLog") != null ? "Chỉnh sửa & Gửi lại Email" : "Gửi Email");
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

        String fromEmail = request.getParameter("fromEmail");
        String fromName = request.getParameter("fromName");
        String recipientsJson = request.getParameter("recipientsJson");

        // Multi-recipient send
        if (recipientsJson != null && !recipientsJson.trim().isEmpty()) {
            sendMultipleEmails(session, currentUser, recipientsJson, fromEmail, fromName);
            response.sendRedirect(request.getContextPath() + "/manager/email");
            return;
        }

        // Fallback: legacy single send
        String toEmail = request.getParameter("toEmail");
        String toName = request.getParameter("toName");
        String subject = request.getParameter("subject");
        String bodyHtml = request.getParameter("bodyHtml");

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

    private void sendMultipleEmails(HttpSession session, Users currentUser,
                                     String recipientsJson, String fromEmail, String fromName) {
        try {
            JsonArray arr = new JsonParser().parse(recipientsJson).getAsJsonArray();
            int success = 0, failed = 0;
            StringBuilder errors = new StringBuilder();

            for (int i = 0; i < arr.size(); i++) {
                JsonObject obj = arr.get(i).getAsJsonObject();
                String email = getJsonStr(obj, "email");
                String name = getJsonStr(obj, "name");
                String subject = getJsonStr(obj, "subject");
                String bodyHtml = getJsonStr(obj, "bodyHtml");
                String type = getJsonStr(obj, "type");
                String id = getJsonStr(obj, "id");

                EmailSendUtil.EmailRequest req = new EmailSendUtil.EmailRequest();
                req.setTo(email);
                req.setToName(name.isEmpty() ? null : name);
                req.setSubject(subject);
                req.setHtmlBody(bodyHtml);
                req.setSentByUserId(currentUser.getUserId());
                req.setRelatedType(type.isEmpty() ? "MANUAL" : type);
                if (!id.isEmpty()) {
                    try { req.setRelatedId(Integer.parseInt(id)); } catch (NumberFormatException ignored) {}
                }

                EmailSendUtil.EmailResult result = EmailSendUtil.send(req,
                        fromEmail != null && !fromEmail.isEmpty() ? fromEmail : null,
                        fromName != null && !fromName.isEmpty() ? fromName : null);

                if (result.isSuccess()) {
                    success++;
                } else {
                    failed++;
                    if (errors.length() > 0) errors.append("; ");
                    errors.append(email).append(": ").append(result.getMessage());
                }
            }

            if (failed == 0) {
                session.setAttribute("successMessage",
                        "Đã gửi thành công " + success + " email");
            } else {
                session.setAttribute("errorMessage",
                        "Gửi thành công " + success + "/" + (success + failed)
                                + " email. Lỗi: " + errors.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi xử lý dữ liệu: " + e.getMessage());
        }
    }

    private String getJsonStr(JsonObject obj, String key) {
        JsonElement el = obj.get(key);
        return (el != null && !el.isJsonNull()) ? el.getAsString() : "";
    }
}
