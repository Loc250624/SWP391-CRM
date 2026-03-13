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
            st.setObject(2, log.getSenderId());
            st.setString(3, log.getRecipientEmail());
            st.setObject(4, log.getLeadId());
            st.setObject(5, log.getCustomerId());
            st.setString(6, log.getSubject());
            st.setString(7, log.getBodyContent());
            st.setString(8, log.getStatus());
            st.setString(9, log.getErrorMessage());
            st.setInt(10, log.getOpenCount());
            st.setInt(11, log.getClickCount());
            st.setObject(12, log.getLastOpenedAt());
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private EmailLog mapResultSetToLog(ResultSet rs) throws SQLException {
        EmailLog log = new EmailLog();
        log.setLogId(rs.getInt("log_id"));
        log.setTemplateId(rs.getObject("template_id", Integer.class));
        log.setSenderId(rs.getObject("sender_id", Integer.class));
        log.setRecipientEmail(rs.getString("recipient_email"));
        log.setLeadId(rs.getObject("lead_id", Integer.class));
        log.setCustomerId(rs.getObject("customer_id", Integer.class));
        log.setSubject(rs.getString("subject"));
        log.setBodyContent(rs.getString("body_content"));
        log.setSentAt(rs.getTimestamp("sent_at").toLocalDateTime());
        log.setStatus(rs.getString("status"));
        log.setErrorMessage(rs.getString("error_message"));
        log.setOpenCount(rs.getInt("open_count"));
        log.setClickCount(rs.getInt("click_count"));
        if (rs.getTimestamp("last_opened_at") != null) {
            log.setLastOpenedAt(rs.getTimestamp("last_opened_at").toLocalDateTime());
        }
        return log;
    }
}
