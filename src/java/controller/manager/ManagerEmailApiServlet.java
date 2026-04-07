package controller.manager;

import dao.EmailLogDAO;
import dao.EmailTemplateDAO;
import dao.UserDAO;
import model.EmailLog;
import model.EmailTemplate;
import util.EmailSendUtil;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;
import util.AuditUtil;

@WebServlet(name = "ManagerEmailDataServlet", urlPatterns = {"/manager/email-data"})
public class ManagerEmailApiServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(401);
            out.write("{\"error\":\"unauthorized\"}");
            return;
        }

        Users user = (Users) session.getAttribute("user");
        String roleCode = new UserDAO().getRoleCodeByUserId(user.getUserId());
        if (!"MANAGER".equals(roleCode)) {
            response.setStatus(403);
            out.write("{\"error\":\"forbidden\"}");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "kpi";

        switch (action) {
            case "kpi":
                writeKpi(out);
                break;
            case "logs":
                writeLogs(out, request);
                break;
            case "templates":
                writeTemplates(out);
                break;
            case "templateDetail":
                writeTemplateDetail(out, request);
                break;
            case "logDetail":
                writeLogDetail(out, request);
                break;
            case "configStatus":
                writeConfigStatus(out);
                break;
            default:
                out.write("{\"error\":\"unknown action\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(401);
            out.write("{\"error\":\"unauthorized\"}");
            return;
        }

        Users user = (Users) session.getAttribute("user");
        String roleCode = new UserDAO().getRoleCodeByUserId(user.getUserId());
        if (!"MANAGER".equals(roleCode)) {
            response.setStatus(403);
            out.write("{\"error\":\"forbidden\"}");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "saveConfig":
                handleSaveConfig(out, request, user);
                break;
            case "testConnection":
                handleTestConnection(out);
                break;
            case "resend":
                handleResend(out, request, user);
                break;
            default:
                out.write("{\"error\":\"unknown action\"}");
        }
    }

    // ── GET handlers ──

    private void writeKpi(PrintWriter out) {
        EmailLogDAO dao = new EmailLogDAO();
        Map<String, Integer> byStatus = dao.countByStatus();
        int total = dao.countAll();
        int sent = byStatus.getOrDefault("Sent", 0);
        int queued = byStatus.getOrDefault("Queued", 0);
        int failed = byStatus.getOrDefault("Failed", 0);
        int bounced = byStatus.getOrDefault("Bounced", 0);
        int opened = byStatus.getOrDefault("Opened", 0);

        double openRate = sent > 0 ? (opened * 100.0 / sent) : 0;
        double bounceRate = total > 0 ? (bounced * 100.0 / total) : 0;

        out.write("{\"total\":" + total
                + ",\"sent\":" + sent
                + ",\"queued\":" + queued
                + ",\"failed\":" + failed
                + ",\"bounced\":" + bounced
                + ",\"opened\":" + opened
                + ",\"openRate\":" + String.format("%.1f", openRate)
                + ",\"bounceRate\":" + String.format("%.1f", bounceRate)
                + ",\"configured\":" + EmailSendUtil.isConfigured()
                + "}");
    }

    private void writeLogs(PrintWriter out, HttpServletRequest request) {
        EmailLogDAO dao = new EmailLogDAO();
        String status = request.getParameter("status");
        String keyword = request.getParameter("keyword");
        int offset = parseIntOr(request.getParameter("offset"), 0);
        int limit = parseIntOr(request.getParameter("limit"), 20);

        if (status != null && status.isEmpty()) status = null;
        if (keyword != null && keyword.isEmpty()) keyword = null;

        List<EmailLog> logs = dao.getListPaged(status, keyword, offset, limit);
        int total = dao.countTotal(status, keyword);

        StringBuilder sb = new StringBuilder();
        sb.append("{\"total\":").append(total).append(",\"logs\":[");
        for (int i = 0; i < logs.size(); i++) {
            EmailLog l = logs.get(i);
            if (i > 0) sb.append(",");
            sb.append("{");
            sb.append("\"id\":").append(l.getEmailLogId());
            sb.append(",\"toEmail\":").append(jsonStr(l.getToEmail()));
            sb.append(",\"toName\":").append(jsonStr(l.getToName()));
            sb.append(",\"subject\":").append(jsonStr(l.getSubject()));
            sb.append(",\"status\":").append(jsonStr(l.getStatus()));
            sb.append(",\"relatedType\":").append(jsonStr(l.getRelatedType()));
            sb.append(",\"fromEmail\":").append(jsonStr(l.getFromEmail()));
            sb.append(",\"errorMessage\":").append(jsonStr(l.getErrorMessage()));
            sb.append(",\"createdAt\":").append(jsonStr(l.getCreatedAt() != null ? l.getCreatedAt().toString() : null));
            sb.append(",\"sentDate\":").append(jsonStr(l.getSentDate() != null ? l.getSentDate().toString() : null));
            sb.append("}");
        }
        sb.append("]}");
        out.write(sb.toString());
    }

    private void writeLogDetail(PrintWriter out, HttpServletRequest request) {
        int id = parseIntOr(request.getParameter("id"), 0);
        if (id <= 0) { out.write("{\"error\":\"invalid id\"}"); return; }

        EmailLogDAO dao = new EmailLogDAO();
        EmailLog l = dao.getById(id);
        if (l == null) { out.write("{\"error\":\"Không tìm thấy email\"}"); return; }

        StringBuilder sb = new StringBuilder("{");
        sb.append("\"id\":").append(l.getEmailLogId());
        sb.append(",\"toEmail\":").append(jsonStr(l.getToEmail()));
        sb.append(",\"toName\":").append(jsonStr(l.getToName()));
        sb.append(",\"fromEmail\":").append(jsonStr(l.getFromEmail()));
        sb.append(",\"fromName\":").append(jsonStr(l.getFromName()));
        sb.append(",\"ccEmails\":").append(jsonStr(l.getCcEmails()));
        sb.append(",\"bccEmails\":").append(jsonStr(l.getBccEmails()));
        sb.append(",\"subject\":").append(jsonStr(l.getSubject()));
        sb.append(",\"status\":").append(jsonStr(l.getStatus()));
        sb.append(",\"relatedType\":").append(jsonStr(l.getRelatedType()));
        sb.append(",\"bodyHtml\":").append(jsonStr(l.getBodyHtml()));
        sb.append(",\"bodyText\":").append(jsonStr(l.getBodyText()));
        sb.append(",\"errorMessage\":").append(jsonStr(l.getErrorMessage()));
        sb.append(",\"createdAt\":").append(jsonStr(l.getCreatedAt() != null ? l.getCreatedAt().toString() : null));
        sb.append(",\"sentDate\":").append(jsonStr(l.getSentDate() != null ? l.getSentDate().toString() : null));
        sb.append("}");
        out.write(sb.toString());
    }

    private void writeTemplates(PrintWriter out) {
        EmailTemplateDAO dao = new EmailTemplateDAO();
        List<EmailTemplate> templates = dao.getAll();

        StringBuilder sb = new StringBuilder();
        sb.append("{\"templates\":[");
        for (int i = 0; i < templates.size(); i++) {
            EmailTemplate t = templates.get(i);
            if (i > 0) sb.append(",");
            sb.append("{");
            sb.append("\"id\":").append(t.getTemplateId());
            sb.append(",\"code\":").append(jsonStr(t.getTemplateCode()));
            sb.append(",\"name\":").append(jsonStr(t.getTemplateName()));
            sb.append(",\"category\":").append(jsonStr(t.getCategory()));
            sb.append(",\"subject\":").append(jsonStr(t.getSubject()));
            sb.append(",\"description\":").append(jsonStr(t.getDescription()));
            sb.append(",\"isActive\":").append(t.getIsActive());
            sb.append(",\"isDefault\":").append(t.getIsDefault());
            sb.append(",\"variables\":").append(jsonStr(t.getAvailableVariables()));
            sb.append(",\"createdAt\":").append(jsonStr(t.getCreatedAt() != null ? t.getCreatedAt().toString() : null));
            sb.append("}");
        }
        sb.append("]}");
        out.write(sb.toString());
    }

    private void writeTemplateDetail(PrintWriter out, HttpServletRequest request) {
        int id = parseIntOr(request.getParameter("id"), 0);
        if (id <= 0) { out.write("{\"error\":\"invalid id\"}"); return; }

        EmailTemplateDAO dao = new EmailTemplateDAO();
        EmailTemplate t = dao.getById(id);
        if (t == null) { out.write("{\"error\":\"not found\"}"); return; }

        StringBuilder sb = new StringBuilder("{");
        sb.append("\"id\":").append(t.getTemplateId());
        sb.append(",\"code\":").append(jsonStr(t.getTemplateCode()));
        sb.append(",\"name\":").append(jsonStr(t.getTemplateName()));
        sb.append(",\"category\":").append(jsonStr(t.getCategory()));
        sb.append(",\"subject\":").append(jsonStr(t.getSubject()));
        sb.append(",\"bodyHtml\":").append(jsonStr(t.getBodyHtml()));
        sb.append(",\"bodyText\":").append(jsonStr(t.getBodyText()));
        sb.append(",\"description\":").append(jsonStr(t.getDescription()));
        sb.append(",\"variables\":").append(jsonStr(t.getAvailableVariables()));
        sb.append(",\"isActive\":").append(t.getIsActive());
        sb.append(",\"isDefault\":").append(t.getIsDefault());
        sb.append("}");
        out.write(sb.toString());
    }

    private void writeConfigStatus(PrintWriter out) {
        String pwd = EmailSendUtil.getSmtpPassword();
        boolean hasPassword = pwd != null && !pwd.isEmpty();
        out.write("{\"configured\":" + EmailSendUtil.isConfigured()
                + ",\"host\":" + jsonStr(EmailSendUtil.getSmtpHost())
                + ",\"port\":" + EmailSendUtil.getSmtpPort()
                + ",\"tls\":" + EmailSendUtil.isSmtpTls()
                + ",\"ssl\":" + EmailSendUtil.isSmtpSsl()
                + ",\"username\":" + jsonStr(EmailSendUtil.getSmtpUsername())
                + ",\"hasPassword\":" + hasPassword
                + ",\"fromEmail\":" + jsonStr(EmailSendUtil.getDefaultFromEmail())
                + ",\"fromName\":" + jsonStr(EmailSendUtil.getDefaultFromName())
                + "}");
    }

    // ── POST handlers ──

    private void handleSaveConfig(PrintWriter out, HttpServletRequest request, Users user) {
        String host = request.getParameter("host");
        int port = parseIntOr(request.getParameter("port"), 587);
        boolean tls = "true".equals(request.getParameter("tls"));
        boolean ssl = "true".equals(request.getParameter("ssl"));
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fromEmail = request.getParameter("fromEmail");
        String fromName = request.getParameter("fromName");

        if (host == null || host.isEmpty() || username == null || username.isEmpty()) {
            out.write("{\"success\":false,\"message\":\"Host và Email đăng nhập không được để trống\"}");
            return;
        }

        // Nếu không gửi password mới, giữ password cũ
        if (password == null || password.isEmpty()) {
            password = EmailSendUtil.getSmtpPassword();
        }

        EmailSendUtil.setConfig(host, port, tls, ssl, username, password, fromEmail, fromName, user.getUserId());
        AuditUtil.log(null, user.getUserId(), "Update", "SmtpConfig", null, null,
                "host=" + host + ", port=" + port + ", username=" + username);
        out.write("{\"success\":true,\"message\":\"Đã lưu cấu hình SMTP vào database\"}");
    }

    private void handleTestConnection(PrintWriter out) {
        EmailSendUtil.EmailResult result = EmailSendUtil.testConnection();
        out.write("{\"success\":" + result.isSuccess() + ",\"message\":" + jsonStr(result.getMessage()) + "}");
    }

    private void handleResend(PrintWriter out, HttpServletRequest request, Users user) {
        int logId = parseIntOr(request.getParameter("logId"), 0);
        if (logId <= 0) { out.write("{\"success\":false,\"message\":\"Invalid log ID\"}"); return; }

        EmailLogDAO logDAO = new EmailLogDAO();
        EmailLog log = logDAO.getById(logId);
        if (log == null) { out.write("{\"success\":false,\"message\":\"Không tìm thấy email\"}"); return; }

        EmailSendUtil.EmailRequest req = new EmailSendUtil.EmailRequest();
        req.setTo(log.getToEmail());
        req.setToName(log.getToName());
        req.setSubject(log.getSubject());
        req.setHtmlBody(log.getBodyHtml());
        req.setTextBody(log.getBodyText());
        req.setRelatedType(log.getRelatedType());
        req.setRelatedId(log.getRelatedId());
        req.setTemplateId(log.getTemplateId());
        req.setSentByUserId(user.getUserId());

        EmailSendUtil.EmailResult result = EmailSendUtil.send(req);
        out.write("{\"success\":" + result.isSuccess() + ",\"message\":" + jsonStr(result.getMessage()) + "}");
    }

    // ── Helpers ──

    private int parseIntOr(String s, int def) {
        if (s == null) return def;
        try { return Integer.parseInt(s); } catch (NumberFormatException e) { return def; }
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
