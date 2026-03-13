package dao;

import dbConnection.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.EmailLog;

public class EmailLogDAO extends DBContext {

    public List<EmailLog> getAllLogs() {
        List<EmailLog> list = new ArrayList<>();
        String sql = "SELECT * FROM email_logs ORDER BY sent_at DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToLog(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insertLog(EmailLog log) {
        String sql = "INSERT INTO email_logs (template_id, sender_id, recipient_email, lead_id, customer_id, "
                + "subject, body_content, sent_at, status, error_message, open_count, click_count, last_opened_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE(), ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setObject(1, log.getTemplateId());
            st.setObject(2, log.getSentBy());
            st.setString(3, log.getToEmail());
            
            Integer leadId = null;
            Integer customerId = null;
            if ("LEAD".equalsIgnoreCase(log.getRelatedType())) {
                leadId = log.getRelatedId();
            } else if ("CUSTOMER".equalsIgnoreCase(log.getRelatedType())) {
                customerId = log.getRelatedId();
            }
            st.setObject(4, leadId);
            st.setObject(5, customerId);
            
            st.setString(6, log.getSubject());
            st.setString(7, log.getBodyHtml() != null ? log.getBodyHtml() : log.getBodyText());
            st.setString(8, log.getStatus());
            st.setString(9, log.getErrorMessage());
            st.setInt(10, log.getOpenCount() != null ? log.getOpenCount() : 0);
            st.setInt(11, log.getClickCount() != null ? log.getClickCount() : 0);
            st.setObject(12, log.getLastOpenedDate());
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private EmailLog mapResultSetToLog(ResultSet rs) throws SQLException {
        EmailLog log = new EmailLog();
        log.setEmailLogId(rs.getInt("log_id"));
        log.setTemplateId(rs.getObject("template_id", Integer.class));
        log.setSentBy(rs.getObject("sender_id", Integer.class));
        log.setToEmail(rs.getString("recipient_email"));
        
        Integer leadId = rs.getObject("lead_id", Integer.class);
        Integer customerId = rs.getObject("customer_id", Integer.class);
        if (leadId != null) {
            log.setRelatedType("LEAD");
            log.setRelatedId(leadId);
        } else if (customerId != null) {
            log.setRelatedType("CUSTOMER");
            log.setRelatedId(customerId);
        }
        
        log.setSubject(rs.getString("subject"));
        log.setBodyHtml(rs.getString("body_content"));
        log.setSentDate(rs.getTimestamp("sent_at") != null ? rs.getTimestamp("sent_at").toLocalDateTime() : null);
        log.setStatus(rs.getString("status"));
        log.setErrorMessage(rs.getString("error_message"));
        log.setOpenCount(rs.getInt("open_count"));
        log.setClickCount(rs.getInt("click_count"));
        if (rs.getTimestamp("last_opened_at") != null) {
            log.setLastOpenedDate(rs.getTimestamp("last_opened_at").toLocalDateTime());
        }
        return log;
    }
}
