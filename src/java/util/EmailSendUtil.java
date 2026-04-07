package util;

import dao.EmailLogDAO;
import dao.EmailTemplateDAO;
import dao.SystemSettingDAO;
import model.EmailLog;
import model.EmailTemplate;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class EmailSendUtil {

    // ── SMTP config fields (loaded from DB on first access) ──
    private static String smtpHost = "smtp.gmail.com";
    private static int smtpPort = 587;
    private static boolean smtpTls = true;
    private static boolean smtpSsl = false;
    private static String smtpUsername = "";
    private static String smtpPassword = "";
    private static String defaultFromEmail = "";
    private static String defaultFromName = "CRM System";

    private static boolean configLoaded = false;

    private static final ExecutorService threadPool = Executors.newFixedThreadPool(3);

    // ══════════════════════════════════════════════════════════════
    // Config management
    // ══════════════════════════════════════════════════════════════

    /**
     * Load cấu hình SMTP từ bảng system_settings. Gọi 1 lần khi app khởi động
     * hoặc tự động gọi lần đầu khi cần.
     */
    public static synchronized void loadFromDB() {
        try {
            SystemSettingDAO dao = new SystemSettingDAO();
            Map<String, String> settings = dao.getByPrefix("smtp_");

            if (!settings.isEmpty()) {
                smtpHost = settings.getOrDefault("smtp_host", "smtp.gmail.com");
                smtpPort = parseIntSafe(settings.get("smtp_port"), 587);
                smtpTls = "true".equals(settings.getOrDefault("smtp_tls", "true"));
                smtpSsl = "true".equals(settings.getOrDefault("smtp_ssl", "false"));
                smtpUsername = settings.getOrDefault("smtp_username", "");
                smtpPassword = settings.getOrDefault("smtp_password", "");
                defaultFromEmail = settings.getOrDefault("smtp_from_email", "");
                defaultFromName = settings.getOrDefault("smtp_from_name", "CRM System");
            }
            configLoaded = true;
        } catch (Exception e) {
            e.printStackTrace();
            configLoaded = true; // mark loaded to avoid retry loop
        }
    }

    private static void ensureConfigLoaded() {
        if (!configLoaded) {
            loadFromDB();
        }
    }

    /**
     * Cập nhật config vào memory + lưu xuống DB.
     */
    public static void setConfig(String host, int port, boolean tls, boolean ssl,
            String username, String password,
            String fromEmail, String fromName) {
        smtpHost = host;
        smtpPort = port;
        smtpTls = tls;
        smtpSsl = ssl;
        smtpUsername = username;
        smtpPassword = password;
        defaultFromEmail = fromEmail;
        defaultFromName = fromName;
        configLoaded = true;

        // Persist to DB
        saveToDB(null);
    }

    public static void setConfig(String host, int port, boolean tls, boolean ssl,
            String username, String password,
            String fromEmail, String fromName, Integer updatedBy) {
        smtpHost = host;
        smtpPort = port;
        smtpTls = tls;
        smtpSsl = ssl;
        smtpUsername = username;
        smtpPassword = password;
        defaultFromEmail = fromEmail;
        defaultFromName = fromName;
        configLoaded = true;

        saveToDB(updatedBy);
    }

    private static void saveToDB(Integer updatedBy) {
        try {
            SystemSettingDAO dao = new SystemSettingDAO();
            java.util.HashMap<String, String> map = new java.util.HashMap<>();
            map.put("smtp_host", smtpHost);
            map.put("smtp_port", String.valueOf(smtpPort));
            map.put("smtp_tls", String.valueOf(smtpTls));
            map.put("smtp_ssl", String.valueOf(smtpSsl));
            map.put("smtp_username", smtpUsername);
            map.put("smtp_password", smtpPassword);
            map.put("smtp_from_email", defaultFromEmail);
            map.put("smtp_from_name", defaultFromName);
            dao.setMultiple(map, updatedBy);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static boolean isConfigured() {
        ensureConfigLoaded();
        return smtpUsername != null && !smtpUsername.isEmpty()
                && smtpPassword != null && !smtpPassword.isEmpty();
    }

    private static int parseIntSafe(String s, int def) {
        if (s == null) return def;
        try { return Integer.parseInt(s); } catch (NumberFormatException e) { return def; }
    }

    public static String getSmtpHost() {
        ensureConfigLoaded();
        return smtpHost;
    }

    public static int getSmtpPort() {
        ensureConfigLoaded();
        return smtpPort;
    }

    public static boolean isSmtpTls() {
        ensureConfigLoaded();
        return smtpTls;
    }

    public static boolean isSmtpSsl() {
        ensureConfigLoaded();
        return smtpSsl;
    }

    public static String getSmtpUsername() {
        ensureConfigLoaded();
        return smtpUsername;
    }

    public static String getSmtpPassword() {
        ensureConfigLoaded();
        return smtpPassword;
    }

    public static String getDefaultFromEmail() {
        ensureConfigLoaded();
        return defaultFromEmail;
    }

    public static String getDefaultFromName() {
        ensureConfigLoaded();
        return defaultFromName;
    }

    // ══════════════════════════════════════════════════════════════
    // Core send — synchronous
    // ══════════════════════════════════════════════════════════════
    /**
     * Gửi email đồng bộ. Trả về EmailResult. Tự động log vào email_logs.
     */
    public static EmailResult send(EmailRequest request) {
        return send(request, defaultFromEmail, defaultFromName);
    }

    public static EmailResult send(EmailRequest request, String fromEmail, String fromName) {
        EmailResult result = new EmailResult();

        if (!isConfigured()) {
            result.setSuccess(false);
            result.setMessage("SMTP chưa được cấu hình. Vui lòng cấu hình email trước khi gửi.");
            return result;
        }

        // Log to DB first (status = Sending)
        EmailLogDAO logDAO = new EmailLogDAO();
        EmailLog log = new EmailLog();
        log.setRelatedType(request.getRelatedType() != null ? request.getRelatedType() : "MANUAL");
        log.setRelatedId(request.getRelatedId() != null ? request.getRelatedId() : 0);
        log.setQuotationId(request.getQuotationId());
        log.setTemplateId(request.getTemplateId());
        log.setFromEmail(fromEmail != null ? fromEmail : defaultFromEmail);
        log.setFromName(fromName != null ? fromName : defaultFromName);
        log.setToEmail(request.getTo());
        log.setToName(request.getToName());
        log.setCcEmails(request.getCc() != null ? String.join(",", request.getCc()) : null);
        log.setBccEmails(request.getBcc() != null ? String.join(",", request.getBcc()) : null);
        log.setSubject(request.getSubject());
        log.setBodyHtml(request.getHtmlBody());
        log.setBodyText(request.getTextBody());
        log.setStatus("Sending");
        log.setSentBy(request.getSentByUserId());
        log.setProvider("Smtp");
        log.setTrackingEnabled(request.isTrackingEnabled());

        int logId = logDAO.insert(log);

        try {
            // Build session
            Properties props = new Properties();
            props.put("mail.smtp.host", smtpHost);
            props.put("mail.smtp.port", String.valueOf(smtpPort));
            props.put("mail.smtp.auth", "true");
            if (smtpTls) {
                props.put("mail.smtp.starttls.enable", "true");
            }
            if (smtpSsl) {
                props.put("mail.smtp.ssl.enable", "true");
            }

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(smtpUsername, smtpPassword);
                }
            });

            // Build message
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(
                    fromEmail != null ? fromEmail : defaultFromEmail,
                    fromName != null ? fromName : defaultFromName, "UTF-8"));
            message.setRecipients(Message.RecipientType.TO,
                    InternetAddress.parse(request.getTo()));

            if (request.getCc() != null && !request.getCc().isEmpty()) {
                message.setRecipients(Message.RecipientType.CC,
                        InternetAddress.parse(String.join(",", request.getCc())));
            }
            if (request.getBcc() != null && !request.getBcc().isEmpty()) {
                message.setRecipients(Message.RecipientType.BCC,
                        InternetAddress.parse(String.join(",", request.getBcc())));
            }

            message.setSubject(request.getSubject(), "UTF-8");

            // Set body (prefer HTML)
            if (request.getHtmlBody() != null && !request.getHtmlBody().isEmpty()) {
                message.setContent(request.getHtmlBody(), "text/html; charset=UTF-8");
            } else if (request.getTextBody() != null) {
                message.setText(request.getTextBody(), "UTF-8");
            }

            // Send
            Transport.send(message);

            // Update log status
            if (logId > 0) {
                logDAO.updateStatus(logId, "Sent", null);
            }

            result.setSuccess(true);
            result.setMessage("Email đã gửi thành công");
            result.setLogId(logId);

        } catch (Exception e) {
            e.printStackTrace();
            String errMsg = e.getMessage() != null ? e.getMessage() : e.getClass().getSimpleName();
            if (logId > 0) {
                logDAO.updateStatus(logId, "Failed", errMsg);
            }
            result.setSuccess(false);
            result.setMessage("Gửi email thất bại: " + errMsg);
            result.setLogId(logId);
        }

        return result;
    }

    // ══════════════════════════════════════════════════════════════
    // Send with template
    // ══════════════════════════════════════════════════════════════
    /**
     * Gửi email sử dụng template code. Variables sẽ được replace trong subject
     * và body.
     */
    public static EmailResult sendWithTemplate(String templateCode,
            Map<String, String> variables,
            String toEmail, String toName,
            Integer sentByUserId) {
        EmailTemplateDAO templateDAO = new EmailTemplateDAO();
        EmailTemplate template = templateDAO.getByCode(templateCode);

        if (template == null || !Boolean.TRUE.equals(template.getIsActive())) {
            EmailResult r = new EmailResult();
            r.setSuccess(false);
            r.setMessage("Không tìm thấy template: " + templateCode);
            return r;
        }

        String subject = renderTemplate(template.getSubject(), variables);
        String htmlBody = renderTemplate(template.getBodyHtml(), variables);
        String textBody = template.getBodyText() != null
                ? renderTemplate(template.getBodyText(), variables) : null;

        EmailRequest request = new EmailRequest();
        request.setTo(toEmail);
        request.setToName(toName);
        request.setSubject(subject);
        request.setHtmlBody(htmlBody);
        request.setTextBody(textBody);
        request.setTemplateId(template.getTemplateId());
        request.setSentByUserId(sentByUserId);
        request.setRelatedType(template.getCategory());

        return send(request);
    }

    // ══════════════════════════════════════════════════════════════
    // Async send
    // ══════════════════════════════════════════════════════════════
    public static void sendAsync(EmailRequest request) {
        threadPool.submit(() -> send(request));
    }

    public static void sendWithTemplateAsync(String templateCode,
            Map<String, String> variables,
            String toEmail, String toName,
            Integer sentByUserId) {
        threadPool.submit(() -> sendWithTemplate(templateCode, variables, toEmail, toName, sentByUserId));
    }

    // ══════════════════════════════════════════════════════════════
    // Template engine — replace {variable} patterns
    // ══════════════════════════════════════════════════════════════
    public static String renderTemplate(String template, Map<String, String> variables) {
        if (template == null || variables == null) {
            return template;
        }
        String result = template;
        for (Map.Entry<String, String> entry : variables.entrySet()) {
            String key = entry.getKey();
            String value = entry.getValue() != null ? entry.getValue() : "";
            // Support both {key} and {{key}} patterns
            result = result.replace("{" + key + "}", value);
            result = result.replace("{{" + key + "}}", value);
        }
        return result;
    }

    // ══════════════════════════════════════════════════════════════
    // Test connection
    // ══════════════════════════════════════════════════════════════
    public static EmailResult testConnection() {
        EmailResult result = new EmailResult();
        if (!isConfigured()) {
            result.setSuccess(false);
            result.setMessage("SMTP chưa được cấu hình");
            return result;
        }
        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", smtpHost);
            props.put("mail.smtp.port", String.valueOf(smtpPort));
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.connectiontimeout", "5000");
            props.put("mail.smtp.timeout", "5000");
            if (smtpTls) {
                props.put("mail.smtp.starttls.enable", "true");
            }
            if (smtpSsl) {
                props.put("mail.smtp.ssl.enable", "true");
            }

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(smtpUsername, smtpPassword);
                }
            });
            Transport transport = session.getTransport("smtp");
            transport.connect();
            transport.close();

            result.setSuccess(true);
            result.setMessage("Kết nối SMTP thành công!");
        } catch (Exception e) {
            result.setSuccess(false);
            result.setMessage("Kết nối thất bại: " + e.getMessage());
        }
        return result;
    }

    // ══════════════════════════════════════════════════════════════
    // Inner classes
    // ══════════════════════════════════════════════════════════════
    public static class EmailRequest {

        private String to;
        private String toName;
        private java.util.List<String> cc;
        private java.util.List<String> bcc;
        private String subject;
        private String htmlBody;
        private String textBody;
        private Integer sentByUserId;
        private Integer templateId;
        private String relatedType;
        private Integer relatedId;
        private Integer quotationId;
        private boolean trackingEnabled = true;

        public String getTo() {
            return to;
        }

        public void setTo(String to) {
            this.to = to;
        }

        public String getToName() {
            return toName;
        }

        public void setToName(String toName) {
            this.toName = toName;
        }

        public java.util.List<String> getCc() {
            return cc;
        }

        public void setCc(java.util.List<String> cc) {
            this.cc = cc;
        }

        public java.util.List<String> getBcc() {
            return bcc;
        }

        public void setBcc(java.util.List<String> bcc) {
            this.bcc = bcc;
        }

        public String getSubject() {
            return subject;
        }

        public void setSubject(String subject) {
            this.subject = subject;
        }

        public String getHtmlBody() {
            return htmlBody;
        }

        public void setHtmlBody(String htmlBody) {
            this.htmlBody = htmlBody;
        }

        public String getTextBody() {
            return textBody;
        }

        public void setTextBody(String textBody) {
            this.textBody = textBody;
        }

        public Integer getSentByUserId() {
            return sentByUserId;
        }

        public void setSentByUserId(Integer sentByUserId) {
            this.sentByUserId = sentByUserId;
        }

        public Integer getTemplateId() {
            return templateId;
        }

        public void setTemplateId(Integer templateId) {
            this.templateId = templateId;
        }

        public String getRelatedType() {
            return relatedType;
        }

        public void setRelatedType(String relatedType) {
            this.relatedType = relatedType;
        }

        public Integer getRelatedId() {
            return relatedId;
        }

        public void setRelatedId(Integer relatedId) {
            this.relatedId = relatedId;
        }

        public Integer getQuotationId() {
            return quotationId;
        }

        public void setQuotationId(Integer quotationId) {
            this.quotationId = quotationId;
        }

        public boolean isTrackingEnabled() {
            return trackingEnabled;
        }

        public void setTrackingEnabled(boolean trackingEnabled) {
            this.trackingEnabled = trackingEnabled;
        }
    }

    public static class EmailResult {

        private boolean success;
        private String message;
        private String providerMessageId;
        private int logId;

        public boolean isSuccess() {
            return success;
        }

        public void setSuccess(boolean success) {
            this.success = success;
        }

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }

        public String getProviderMessageId() {
            return providerMessageId;
        }

        public void setProviderMessageId(String providerMessageId) {
            this.providerMessageId = providerMessageId;
        }

        public int getLogId() {
            return logId;
        }

        public void setLogId(int logId) {
            this.logId = logId;
        }
    }
}
