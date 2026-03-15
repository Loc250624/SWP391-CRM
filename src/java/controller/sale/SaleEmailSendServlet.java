package controller.sale;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import dao.ActivityDAO;
import dao.CustomerDAO;
import dao.EmailTemplateDAO;
import dao.LeadDAO;
import model.Customer;
import model.EmailTemplate;
import model.Lead;
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

            if (t.getAllowedRoles() != null && !t.getAllowedRoles().isEmpty()
                    && !t.getAllowedRoles().contains("SALES")) {
                out.write("{\"error\":\"Bạn không có quyền sử dụng mẫu này\"}");
                return;
            }

            out.write("{\"id\":" + t.getTemplateId()
                    + ",\"code\":" + jsonStr(t.getTemplateCode())
                    + ",\"category\":" + jsonStr(t.getCategory())
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

        // Load recipients (only this user's customers/leads)
        List<Customer> customers = new CustomerDAO().getCustomersBySalesUser(currentUserId);
        List<Lead> leads = new LeadDAO().getLeadsBySalesUser(currentUserId);
        request.setAttribute("customers", customers);
        request.setAttribute("leads", leads);

        // Load staff users
        dao.UserDAO userDAO = new dao.UserDAO();
        List<model.Users> saleUsers = userDAO.getUsersByRoleCode("SALES");
        List<model.Users> supportUsers = userDAO.getUsersByRoleCode("SUPPORT");
        request.setAttribute("saleUsers", saleUsers);
        request.setAttribute("supportUsers", supportUsers);

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
        String fromEmail = request.getParameter("fromEmail");
        String fromName = request.getParameter("fromName");
        String recipientsJson = request.getParameter("recipientsJson");

        // Multi-recipient send
        if (recipientsJson != null && !recipientsJson.trim().isEmpty()) {
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
                    req.setSentByUserId(currentUserId);
                    req.setRelatedType(type.isEmpty() ? "MANUAL" : type);
                    Integer relatedId = null;
                    if (!id.isEmpty()) {
                        try { relatedId = Integer.parseInt(id); req.setRelatedId(relatedId); } catch (NumberFormatException ignored) {}
                    }

                    EmailSendUtil.EmailResult result = EmailSendUtil.send(req,
                            fromEmail != null && !fromEmail.isEmpty() ? fromEmail : null,
                            fromName != null && !fromName.isEmpty() ? fromName : null);

                    if (result.isSuccess()) {
                        success++;
                        // Log activity
                        String recipient = (name != null && !name.isEmpty())
                                ? name + " (" + email + ")" : email;
                        String actDesc = "Đã gửi email đến " + recipient + "\nChủ đề: " + subject;
                        new ActivityDAO().insertSaleActivity(
                                "Email",
                                type != null && !type.isEmpty() ? type : "Customer",
                                relatedId != null ? relatedId : 0,
                                "Gửi email: " + subject,
                                actDesc,
                                new Timestamp(System.currentTimeMillis()),
                                null, null, null,
                                currentUserId,
                                "Completed");
                    } else {
                        failed++;
                        if (errors.length() > 0) errors.append("; ");
                        errors.append(email).append(": ").append(result.getMessage());
                    }
                }

                if (failed == 0) {
                    session.setAttribute("successMessage", "Đã gửi thành công " + success + " email");
                } else {
                    session.setAttribute("errorMessage",
                            "Gửi thành công " + success + "/" + (success + failed)
                                    + " email. Lỗi: " + errors.toString());
                }
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMessage", "Lỗi xử lý dữ liệu: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/sale/email/send");
            return;
        }

        // Fallback: legacy single send
        String toEmail = request.getParameter("toEmail");
        String toName = request.getParameter("toName");
        String subject = request.getParameter("subject");
        String bodyHtml = request.getParameter("bodyHtml");

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

        EmailSendUtil.EmailResult result = EmailSendUtil.send(emailReq,
                fromEmail != null && !fromEmail.isEmpty() ? fromEmail : null,
                fromName != null && !fromName.isEmpty() ? fromName : null);

        if (result.isSuccess()) {
            session.setAttribute("successMessage", "Email đã gửi thành công đến " + toEmail);
        } else {
            session.setAttribute("errorMessage", result.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/sale/email/send");
    }

    private String getJsonStr(JsonObject obj, String key) {
        JsonElement el = obj.get(key);
        return (el != null && !el.isJsonNull()) ? el.getAsString() : "";
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
