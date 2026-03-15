package dao;

import dbConnection.DBContext;
import model.EmailAttachment;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class EmailAttachmentDAO extends DBContext {

    public boolean insert(EmailAttachment a) {
        String sql = "INSERT INTO email_attachments "
                + "(email_log_id, file_name, file_path, file_size, file_type, content_type, is_inline, content_id, created_at) "
                + "VALUES (?,?,?,?,?,?,?,?,GETDATE())";
        try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            st.setInt(1, a.getEmailLogId());
            st.setString(2, a.getFileName());
            st.setString(3, a.getFilePath());
            if (a.getFileSize() != null) st.setInt(4, a.getFileSize()); else st.setNull(4, Types.INTEGER);
            st.setString(5, a.getFileType());
            st.setString(6, a.getContentType());
            st.setBoolean(7, a.getIsInline() != null ? a.getIsInline() : false);
            st.setString(8, a.getContentId());
            int rows = st.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = st.getGeneratedKeys()) {
                    if (rs.next()) a.setAttachmentId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<EmailAttachment> getByEmailLogId(int emailLogId) {
        List<EmailAttachment> list = new ArrayList<>();
        String sql = "SELECT * FROM email_attachments WHERE email_log_id=? ORDER BY created_at";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, emailLogId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private EmailAttachment map(ResultSet rs) throws SQLException {
        EmailAttachment a = new EmailAttachment();
        a.setAttachmentId(rs.getInt("attachment_id"));
        a.setEmailLogId(rs.getInt("email_log_id"));
        a.setFileName(rs.getString("file_name"));
        a.setFilePath(rs.getString("file_path"));
        int fs = rs.getInt("file_size"); a.setFileSize(rs.wasNull() ? null : fs);
        a.setFileType(rs.getString("file_type"));
        a.setContentType(rs.getString("content_type"));
        a.setIsInline(rs.getBoolean("is_inline"));
        a.setContentId(rs.getString("content_id"));
        Timestamp ts = rs.getTimestamp("created_at");
        a.setCreatedAt(ts != null ? ts.toLocalDateTime() : null);
        return a;
    }
}
