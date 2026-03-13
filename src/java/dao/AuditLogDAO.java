package dao;

import dbConnection.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.AuditLog;

public class AuditLogDAO extends DBContext {

    public List<java.util.Map<String, Object>> getLogsByEntity(String entityType, int entityId) {
        List<java.util.Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT al.*, u.first_name, u.last_name " +
                "FROM audit_logs al " +
                "LEFT JOIN users u ON al.user_id = u.user_id " +
                "WHERE al.entity_type = ? AND al.entity_id = ? " +
                "ORDER BY al.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, entityType);
            ps.setInt(2, entityId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                java.util.Map<String, Object> log = new java.util.HashMap<>();
                log.put("logId", rs.getInt("log_id"));
                log.put("userId", rs.getInt("user_id"));
                log.put("action", rs.getString("action"));
                log.put("oldValues", rs.getString("old_values"));
                log.put("newValues", rs.getString("new_values"));
                log.put("ipAddress", rs.getString("ip_address"));
                log.put("userAgent", rs.getString("user_agent"));
                log.put("createdAt", rs.getTimestamp("created_at"));
                log.put("performerName", rs.getString("first_name") + " " + rs.getString("last_name"));
                list.add(log);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void log(int userId, String action, String entityType, int entityId, String oldValues, String newValues,
            String ipAddress, String userAgent) {
        String sql = "INSERT INTO audit_logs (user_id, action, entity_type, entity_id, old_values, new_values, ip_address, user_agent, created_at) "
                +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (userId > 0)
                ps.setInt(1, userId);
            else
                ps.setNull(1, java.sql.Types.INTEGER);
            ps.setString(2, action);
            ps.setString(3, entityType);
            ps.setInt(4, entityId);
            ps.setString(5, oldValues);
            ps.setString(6, newValues);
            ps.setString(7, ipAddress);
            ps.setString(8, userAgent);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
