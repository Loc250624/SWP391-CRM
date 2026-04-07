package dao;

import dbConnection.DBContext;
import model.EmailLog;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class EmailLogDAO extends DBContext {

    public int insert(EmailLog log) {
        String sql = "INSERT INTO email_logs "
                + "(related_type, related_id, quotation_id, template_id, from_email, from_name, "
                + "to_email, to_name, cc_emails, bcc_emails, reply_to, subject, body_html, body_text, "
                + "has_attachments, attachment_count, attachments_info, status, sent_date, sent_by, "
                + "provider, provider_message_id, provider_response, tracking_enabled, error_message, created_at) "
                + "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,GETDATE())";
        try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            st.setString(1, log.getRelatedType());
            setNullableInt(st, 2, log.getRelatedId());
            setNullableInt(st, 3, log.getQuotationId());
            setNullableInt(st, 4, log.getTemplateId());
            st.setString(5, log.getFromEmail());
            st.setString(6, log.getFromName());
            st.setString(7, log.getToEmail());
            st.setString(8, log.getToName());
            st.setString(9, log.getCcEmails());
            st.setString(10, log.getBccEmails());
            st.setString(11, log.getReplyTo());
            st.setString(12, log.getSubject());
            st.setString(13, log.getBodyHtml());
            st.setString(14, log.getBodyText());
            st.setBoolean(15, log.getHasAttachments() != null ? log.getHasAttachments() : false);
            st.setInt(16, log.getAttachmentCount() != null ? log.getAttachmentCount() : 0);
            st.setString(17, log.getAttachmentsInfo());
            st.setString(18, log.getStatus() != null ? log.getStatus() : "Queued");
            setNullableTimestamp(st, 19, log.getSentDate());
            setNullableInt(st, 20, log.getSentBy());
            st.setString(21, log.getProvider());
            st.setString(22, log.getProviderMessageId());
            st.setString(23, log.getProviderResponse());
            st.setBoolean(24, log.getTrackingEnabled() != null ? log.getTrackingEnabled() : true);
            st.setString(25, log.getErrorMessage());

            int rows = st.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = st.getGeneratedKeys()) {
                    if (rs.next()) {
                        int id = rs.getInt(1);
                        log.setEmailLogId(id);
                        return id;
                    }
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public boolean updateStatus(int emailLogId, String status, String errorMessage) {
        String sql;
        if ("Sent".equals(status)) {
            sql = "UPDATE email_logs SET status=?, sent_date=GETDATE(), error_message=? WHERE email_log_id=?";
        } else {
            sql = "UPDATE email_logs SET status=?, error_message=? WHERE email_log_id=?";
        }
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, status);
            st.setString(2, errorMessage);
            st.setInt(3, emailLogId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateProviderInfo(int emailLogId, String provider, String providerMessageId, String providerResponse) {
        String sql = "UPDATE email_logs SET provider=?, provider_message_id=?, provider_response=? WHERE email_log_id=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, provider);
            st.setString(2, providerMessageId);
            st.setString(3, providerResponse);
            st.setInt(4, emailLogId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public EmailLog getById(int emailLogId) {
        String sql = "SELECT * FROM email_logs WHERE email_log_id=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, emailLogId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<EmailLog> getByRelated(String relatedType, int relatedId) {
        List<EmailLog> list = new ArrayList<>();
        String sql = "SELECT * FROM email_logs WHERE related_type=? AND related_id=? ORDER BY created_at DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, relatedType);
            st.setInt(2, relatedId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<EmailLog> getListPaged(String status, String keyword, int offset, int limit) {
        List<EmailLog> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM email_logs WHERE 1=1");
        if (status != null && !status.isEmpty()) sql.append(" AND status=?");
        if (keyword != null && !keyword.isEmpty()) sql.append(" AND (to_email LIKE ? OR subject LIKE ? OR to_name LIKE ?)");
        sql.append(" ORDER BY created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (status != null && !status.isEmpty()) st.setString(idx++, status);
            if (keyword != null && !keyword.isEmpty()) {
                String kw = "%" + keyword + "%";
                st.setString(idx++, kw);
                st.setString(idx++, kw);
                st.setString(idx++, kw);
            }
            st.setInt(idx++, offset);
            st.setInt(idx, limit);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int countTotal(String status, String keyword) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM email_logs WHERE 1=1");
        if (status != null && !status.isEmpty()) sql.append(" AND status=?");
        if (keyword != null && !keyword.isEmpty()) sql.append(" AND (to_email LIKE ? OR subject LIKE ? OR to_name LIKE ?)");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (status != null && !status.isEmpty()) st.setString(idx++, status);
            if (keyword != null && !keyword.isEmpty()) {
                String kw = "%" + keyword + "%";
                st.setString(idx++, kw);
                st.setString(idx++, kw);
                st.setString(idx++, kw);
            }
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public Map<String, Integer> countByStatus() {
        Map<String, Integer> map = new HashMap<>();
        String sql = "SELECT status, COUNT(*) AS cnt FROM email_logs GROUP BY status";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) map.put(rs.getString("status"), rs.getInt("cnt"));
        } catch (SQLException e) { e.printStackTrace(); }
        return map;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM email_logs";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    // ── Helpers ──

    private EmailLog map(ResultSet rs) throws SQLException {
        EmailLog l = new EmailLog();
        l.setEmailLogId(rs.getInt("email_log_id"));
        l.setRelatedType(rs.getString("related_type"));
        l.setRelatedId(getNullableInt(rs, "related_id"));
        l.setQuotationId(getNullableInt(rs, "quotation_id"));
        l.setTemplateId(getNullableInt(rs, "template_id"));
        l.setFromEmail(rs.getString("from_email"));
        l.setFromName(rs.getString("from_name"));
        l.setToEmail(rs.getString("to_email"));
        l.setToName(rs.getString("to_name"));
        l.setCcEmails(rs.getString("cc_emails"));
        l.setBccEmails(rs.getString("bcc_emails"));
        l.setReplyTo(rs.getString("reply_to"));
        l.setSubject(rs.getString("subject"));
        l.setBodyHtml(rs.getString("body_html"));
        l.setBodyText(rs.getString("body_text"));
        l.setHasAttachments(rs.getBoolean("has_attachments"));
        l.setAttachmentCount(getNullableInt(rs, "attachment_count"));
        l.setAttachmentsInfo(rs.getString("attachments_info"));
        l.setStatus(rs.getString("status"));
        l.setSentDate(getNullableDateTime(rs, "sent_date"));
        l.setSentBy(getNullableInt(rs, "sent_by"));
        l.setProvider(rs.getString("provider"));
        l.setProviderMessageId(rs.getString("provider_message_id"));
        l.setProviderResponse(rs.getString("provider_response"));
        l.setTrackingEnabled(rs.getBoolean("tracking_enabled"));
        l.setTrackingPixelUrl(rs.getString("tracking_pixel_url"));
        l.setOpenedDate(getNullableDateTime(rs, "opened_date"));
        l.setOpenCount(getNullableInt(rs, "open_count"));
        l.setLastOpenedDate(getNullableDateTime(rs, "last_opened_date"));
        l.setClickedDate(getNullableDateTime(rs, "clicked_date"));
        l.setClickCount(getNullableInt(rs, "click_count"));
        l.setLastClickedDate(getNullableDateTime(rs, "last_clicked_date"));
        l.setBouncedDate(getNullableDateTime(rs, "bounced_date"));
        l.setBounceReason(rs.getString("bounce_reason"));
        l.setErrorMessage(rs.getString("error_message"));
        l.setRetryCount(getNullableInt(rs, "retry_count"));
        l.setNextRetryDate(getNullableDateTime(rs, "next_retry_date"));
        l.setCreatedAt(getNullableDateTime(rs, "created_at"));
        return l;
    }

    private void setNullableInt(PreparedStatement st, int idx, Integer val) throws SQLException {
        if (val != null) st.setInt(idx, val); else st.setNull(idx, Types.INTEGER);
    }

    private void setNullableTimestamp(PreparedStatement st, int idx, LocalDateTime val) throws SQLException {
        if (val != null) st.setTimestamp(idx, Timestamp.valueOf(val)); else st.setNull(idx, Types.TIMESTAMP);
    }

    private Integer getNullableInt(ResultSet rs, String col) throws SQLException {
        int v = rs.getInt(col); return rs.wasNull() ? null : v;
    }

    private LocalDateTime getNullableDateTime(ResultSet rs, String col) throws SQLException {
        Timestamp ts = rs.getTimestamp(col); return ts != null ? ts.toLocalDateTime() : null;
    }
}
