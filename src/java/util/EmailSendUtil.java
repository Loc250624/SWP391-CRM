package util;

import jakarta.mail.Session;
import jakarta.mail.internet.MimeMessage;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

public class EmailSendUtil {

    public static class EmailConfig {
        private String host;
        private int port;
        private boolean tls;
        private boolean ssl;
        private String username;
        private String password;
        private String defaultFromEmail;
        private String defaultFromName;

        public String getHost() {
            return host;
        }

        public void setHost(String host) {
            this.host = host;
        }

        public int getPort() {
            return port;
        }

        public void setPort(int port) {
            this.port = port;
        }

        public boolean isTls() {
            return tls;
        }

        public void setTls(boolean tls) {
            this.tls = tls;
        }

        public boolean isSsl() {
            return ssl;
        }

        public void setSsl(boolean ssl) {
            this.ssl = ssl;
        }

        public String getUsername() {
            return username;
        }

        public void setUsername(String username) {
            this.username = username;
        }

        public String getPassword() {
            return password;
        }

        public void setPassword(String password) {
            this.password = password;
        }

        public String getDefaultFromEmail() {
            return defaultFromEmail;
        }

        public void setDefaultFromEmail(String defaultFromEmail) {
            this.defaultFromEmail = defaultFromEmail;
        }

        public String getDefaultFromName() {
            return defaultFromName;
        }

        public void setDefaultFromName(String defaultFromName) {
            this.defaultFromName = defaultFromName;
        }
    }

    public static class EmailRequest {
        private String to;
        private List<String> cc = new ArrayList<>();
        private List<String> bcc = new ArrayList<>();
        private String subject;
        private String htmlBody;
        private String textBody;

        public String getTo() {
            return to;
        }

        public void setTo(String to) {
            this.to = to;
        }

        public List<String> getCc() {
            return cc;
        }

        public void setCc(List<String> cc) {
            this.cc = cc;
        }

        public List<String> getBcc() {
            return bcc;
        }

        public void setBcc(List<String> bcc) {
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
    }

    public static class EmailResult {
        private boolean success;
        private String message;
        private String providerMessageId;

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
    }

    public EmailResult send(EmailConfig config, EmailRequest request) {
        EmailResult result = new EmailResult();
        result.setSuccess(false);
        result.setMessage("Email sending is not implemented yet.");
        return result;
    }

    protected Session buildSession(EmailConfig config) {
        Properties props = new Properties();
        props.put("mail.smtp.host", config.getHost());
        props.put("mail.smtp.port", String.valueOf(config.getPort()));
        props.put("mail.smtp.starttls.enable", String.valueOf(config.isTls()));
        props.put("mail.smtp.ssl.enable", String.valueOf(config.isSsl()));
        props.put("mail.smtp.auth", String.valueOf(config.getUsername() != null && !config.getUsername().isEmpty()));
        return Session.getInstance(props);
    }

    protected MimeMessage buildMessage(Session session, EmailConfig config, EmailRequest request) {
        return new MimeMessage(session);
    }
}
