package dao;

import dbConnection.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.EmailTemplate;

public class EmailTemplateDAO extends DBContext {

    public List<EmailTemplate> getAllTemplates() {
        List<EmailTemplate> list = new ArrayList<>();
        String sql = "SELECT * FROM email_templates ORDER BY created_at DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToTemplate(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public EmailTemplate getTemplateById(int id) {
        String sql = "SELECT * FROM email_templates WHERE template_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapResultSetToTemplate(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertTemplate(EmailTemplate t) {
        String sql = "INSERT INTO email_templates (template_code, template_name, category, subject, body_html, body_text, "
                + "available_variables, description, is_active, is_default, created_at, created_by, updated_at, updated_by) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), ?, GETDATE(), ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
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
            st.setObject(11, t.getCreatedBy());
            st.setObject(12, t.getUpdatedBy());
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateTemplate(EmailTemplate t) {
        String sql = "UPDATE email_templates SET template_code=?, template_name=?, category=?, subject=?, body_html=?, "
                + "body_text=?, available_variables=?, description=?, is_active=?, is_default=?, updated_at=GETDATE(), updated_by=? "
                + "WHERE template_id=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, t.getTemplateCode());
            st.setString(2, t.getTemplateName());
            st.setString(3, t.getCategory());
            st.setString(4, t.getSubject());
            st.setString(5, t.getBodyHtml());
            st.setString(6, t.getBodyText());
            st.setString(7, t.getAvailableVariables());
            st.setString(8, t.getDescription());
            st.setBoolean(9, t.getIsActive());
            st.setBoolean(10, t.getIsDefault());
            st.setObject(11, t.getUpdatedBy());
            st.setInt(12, t.getTemplateId());
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteTemplate(int id) {
        String sql = "DELETE FROM email_templates WHERE template_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private EmailTemplate mapResultSetToTemplate(ResultSet rs) throws SQLException {
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
        t.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        t.setCreatedBy(rs.getObject("created_by", Integer.class));
        t.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        t.setUpdatedBy(rs.getObject("updated_by", Integer.class));
        return t;
    }
}
