package dao;

import dbConnection.DBContext;
import model.EmailTemplate;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class EmailTemplateDAO extends DBContext {

    public List<EmailTemplate> getAll() {
        List<EmailTemplate> list = new ArrayList<>();
        String sql = "SELECT * FROM email_templates ORDER BY created_at DESC";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<EmailTemplate> getActiveTemplates() {
        List<EmailTemplate> list = new ArrayList<>();
        String sql = "SELECT * FROM email_templates WHERE is_active = 1 ORDER BY category, template_name";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<EmailTemplate> getActiveByRole(String roleCode) {
        List<EmailTemplate> list = new ArrayList<>();
        String sql = "SELECT * FROM email_templates WHERE is_active = 1 "
                + "AND (allowed_roles IS NULL OR allowed_roles = '' OR allowed_roles LIKE ?) "
                + "ORDER BY category, template_name";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, "%" + roleCode + "%");
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<EmailTemplate> getActiveByCategory(String category) {
        List<EmailTemplate> list = new ArrayList<>();
        String sql = "SELECT * FROM email_templates WHERE is_active = 1 AND category = ? ORDER BY template_name";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, category);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public EmailTemplate getById(int templateId) {
        String sql = "SELECT * FROM email_templates WHERE template_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, templateId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public EmailTemplate getByCode(String templateCode) {
        String sql = "SELECT * FROM email_templates WHERE template_code = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, templateCode);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insert(EmailTemplate t) {
        String sql = "INSERT INTO email_templates "
                + "(template_code, template_name, category, subject, body_html, body_text, "
                + "available_variables, description, is_active, is_default, allowed_roles, created_at, created_by, updated_at, updated_by) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), ?, GETDATE(), ?)";
        try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            st.setString(1, t.getTemplateCode());
            st.setString(2, t.getTemplateName());
            st.setString(3, t.getCategory());
            st.setString(4, t.getSubject());
            st.setString(5, t.getBodyHtml());
            st.setString(6, t.getBodyText());
            st.setString(7, t.getAvailableVariables());
            st.setString(8, t.getDescription());
            st.setBoolean(9, t.getIsActive() != null ? t.getIsActive() : true);
            st.setBoolean(10, t.getIsDefault() != null ? t.getIsDefault() : false);
            st.setString(11, t.getAllowedRoles());
            setNullableInt(st, 12, t.getCreatedBy());
            setNullableInt(st, 13, t.getCreatedBy());
            int rows = st.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = st.getGeneratedKeys()) {
                    if (rs.next()) t.setTemplateId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean update(EmailTemplate t) {
        String sql = "UPDATE email_templates SET "
                + "template_code=?, template_name=?, category=?, subject=?, body_html=?, body_text=?, "
                + "available_variables=?, description=?, is_active=?, is_default=?, allowed_roles=?, updated_at=GETDATE(), updated_by=? "
                + "WHERE template_id=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, t.getTemplateCode());
            st.setString(2, t.getTemplateName());
            st.setString(3, t.getCategory());
            st.setString(4, t.getSubject());
            st.setString(5, t.getBodyHtml());
            st.setString(6, t.getBodyText());
            st.setString(7, t.getAvailableVariables());
            st.setString(8, t.getDescription());
            st.setBoolean(9, t.getIsActive() != null ? t.getIsActive() : true);
            st.setBoolean(10, t.getIsDefault() != null ? t.getIsDefault() : false);
            st.setString(11, t.getAllowedRoles());
            setNullableInt(st, 12, t.getUpdatedBy());
            st.setInt(13, t.getTemplateId());
            return st.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean toggleActive(int templateId, boolean active, int updatedBy) {
        String sql = "UPDATE email_templates SET is_active=?, updated_at=GETDATE(), updated_by=? WHERE template_id=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setBoolean(1, active);
            st.setInt(2, updatedBy);
            st.setInt(3, templateId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(int templateId) {
        String sql = "DELETE FROM email_templates WHERE template_id=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, templateId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean isCodeExists(String code, Integer excludeId) {
        String sql = excludeId != null
                ? "SELECT 1 FROM email_templates WHERE template_code=? AND template_id!=?"
                : "SELECT 1 FROM email_templates WHERE template_code=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, code);
            if (excludeId != null) st.setInt(2, excludeId);
            try (ResultSet rs = st.executeQuery()) { return rs.next(); }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    // ── Helpers ──

    private EmailTemplate map(ResultSet rs) throws SQLException {
        EmailTemplate t = new EmailTemplate();
        t.setTemplateId(rs.getInt("template_id"));
        t.setTemplateCode(rs.getString("template_code"));
        t.setTemplateName(rs.getString("template_name"));
        t.setCategory(rs.getString("category"));
        t.setSubject(rs.getString("subject"));
        t.setBodyHtml(rs.getString("body_html"));
        t.setBodyText(rs.getString("body_text"));
        t.setAvailableVariables(rs.getString("available_variables"));
        t.setDescription(rs.getString("description"));
        t.setIsActive(rs.getBoolean("is_active"));
        t.setIsDefault(rs.getBoolean("is_default"));
        try { t.setAllowedRoles(rs.getString("allowed_roles")); } catch (SQLException ignored) {}
        t.setCreatedAt(getNullableDateTime(rs, "created_at"));
        t.setCreatedBy(getNullableInt(rs, "created_by"));
        t.setUpdatedAt(getNullableDateTime(rs, "updated_at"));
        t.setUpdatedBy(getNullableInt(rs, "updated_by"));
        return t;
    }

    private void setNullableInt(PreparedStatement st, int idx, Integer val) throws SQLException {
        if (val != null) st.setInt(idx, val); else st.setNull(idx, Types.INTEGER);
    }

    private Integer getNullableInt(ResultSet rs, String col) throws SQLException {
        int v = rs.getInt(col); return rs.wasNull() ? null : v;
    }

    private LocalDateTime getNullableDateTime(ResultSet rs, String col) throws SQLException {
        Timestamp ts = rs.getTimestamp(col); return ts != null ? ts.toLocalDateTime() : null;
    }
}
