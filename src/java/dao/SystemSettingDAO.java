package dao;

import dbConnection.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

public class SystemSettingDAO extends DBContext {

    public String get(String key) {
        String sql = "SELECT setting_value FROM system_settings WHERE setting_key = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, key);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getString("setting_value");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Map<String, String> getByPrefix(String prefix) {
        Map<String, String> map = new HashMap<>();
        String sql = "SELECT setting_key, setting_value FROM system_settings WHERE setting_key LIKE ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, prefix + "%");
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                map.put(rs.getString("setting_key"), rs.getString("setting_value"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    public boolean set(String key, String value, Integer updatedBy) {
        String sql = "MERGE system_settings AS t "
                + "USING (SELECT ? AS k) AS s ON t.setting_key = s.k "
                + "WHEN MATCHED THEN UPDATE SET setting_value = ?, updated_by = ?, updated_at = GETDATE() "
                + "WHEN NOT MATCHED THEN INSERT (setting_key, setting_value, updated_by) VALUES (?, ?, ?);";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, key);
            st.setString(2, value);
            if (updatedBy != null) st.setInt(3, updatedBy); else st.setNull(3, java.sql.Types.INTEGER);
            st.setString(4, key);
            st.setString(5, value);
            if (updatedBy != null) st.setInt(6, updatedBy); else st.setNull(6, java.sql.Types.INTEGER);
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void setMultiple(Map<String, String> settings, Integer updatedBy) {
        for (Map.Entry<String, String> entry : settings.entrySet()) {
            set(entry.getKey(), entry.getValue(), updatedBy);
        }
    }
}
