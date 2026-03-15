package dao;

import dbConnection.DBContext;
import model.AuditLog;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AuditLogDAO extends DBContext {

    public int insert(AuditLog log) {
        String sql = "INSERT INTO audit_logs (user_id, action, entity_type, entity_id, "
                + "old_values, new_values, ip_address, user_agent, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
        try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            setNullableInt(st, 1, log.getUserId());
            st.setString(2, log.getAction());
            st.setString(3, log.getEntityType());
            setNullableInt(st, 4, log.getEntityId());
            st.setString(5, log.getOldValues());
            st.setString(6, log.getNewValues());
            st.setString(7, log.getIpAddress());
            st.setString(8, log.getUserAgent());
            int rows = st.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = st.getGeneratedKeys()) {
                    if (rs.next()) return rs.getInt(1);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public List<AuditLog> getListPaged(String action, String entityType,
            String keyword, int offset, int limit) {
        List<AuditLog> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT a.*, CONCAT(u.first_name, ' ', u.last_name) AS user_name, u.email AS user_email "
                + "FROM audit_logs a LEFT JOIN users u ON a.user_id = u.user_id WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (action != null && !action.isEmpty()) {
            sql.append("AND a.action = ? ");
            params.add(action);
        }
        if (entityType != null && !entityType.isEmpty()) {
            sql.append("AND a.entity_type = ? ");
            params.add(entityType);
        }
        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (u.first_name LIKE ? OR u.last_name LIKE ? OR u.email LIKE ? OR a.ip_address LIKE ? "
                    + "OR a.old_values LIKE ? OR a.new_values LIKE ?) ");
            String kw = "%" + keyword + "%";
            for (int i = 0; i < 6; i++) params.add(kw);
        }

        sql.append("ORDER BY a.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(limit);

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof Integer) st.setInt(i + 1, (Integer) p);
                else st.setString(i + 1, (String) p);
            }
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    AuditLog log = map(rs);
                    log.setUserName(rs.getString("user_name"));
                    log.setUserEmail(rs.getString("user_email"));
                    list.add(log);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int countTotal(String action, String entityType, String keyword) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM audit_logs a LEFT JOIN users u ON a.user_id = u.user_id WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (action != null && !action.isEmpty()) {
            sql.append("AND a.action = ? ");
            params.add(action);
        }
        if (entityType != null && !entityType.isEmpty()) {
            sql.append("AND a.entity_type = ? ");
            params.add(entityType);
        }
        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (u.first_name LIKE ? OR u.last_name LIKE ? OR u.email LIKE ? OR a.ip_address LIKE ? "
                    + "OR a.old_values LIKE ? OR a.new_values LIKE ?) ");
            String kw = "%" + keyword + "%";
            for (int i = 0; i < 6; i++) params.add(kw);
        }

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof Integer) st.setInt(i + 1, (Integer) p);
                else st.setString(i + 1, (String) p);
            }
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public Map<String, Integer> getKpi() {
        Map<String, Integer> kpi = new HashMap<>();
        try {
            // Total logs (30 days)
            try (PreparedStatement st = connection.prepareStatement(
                    "SELECT COUNT(*) FROM audit_logs WHERE created_at >= DATEADD(DAY, -30, GETDATE())");
                 ResultSet rs = st.executeQuery()) {
                if (rs.next()) kpi.put("total", rs.getInt(1));
            }
            // Update + Delete count
            try (PreparedStatement st = connection.prepareStatement(
                    "SELECT COUNT(*) FROM audit_logs WHERE action IN ('Update','Delete') AND created_at >= DATEADD(DAY, -30, GETDATE())");
                 ResultSet rs = st.executeQuery()) {
                if (rs.next()) kpi.put("changes", rs.getInt(1));
            }
            // Active users today
            try (PreparedStatement st = connection.prepareStatement(
                    "SELECT COUNT(DISTINCT user_id) FROM audit_logs WHERE CAST(created_at AS DATE) = CAST(GETDATE() AS DATE)");
                 ResultSet rs = st.executeQuery()) {
                if (rs.next()) kpi.put("activeUsers", rs.getInt(1));
            }
            // Distinct IPs today
            try (PreparedStatement st = connection.prepareStatement(
                    "SELECT COUNT(DISTINCT ip_address) FROM audit_logs WHERE CAST(created_at AS DATE) = CAST(GETDATE() AS DATE)");
                 ResultSet rs = st.executeQuery()) {
                if (rs.next()) kpi.put("distinctIps", rs.getInt(1));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return kpi;
    }

    public AuditLog getById(int logId) {
        String sql = "SELECT a.*, CONCAT(u.first_name, ' ', u.last_name) AS user_name, u.email AS user_email "
                + "FROM audit_logs a LEFT JOIN users u ON a.user_id = u.user_id WHERE a.log_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, logId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    AuditLog log = map(rs);
                    log.setUserName(rs.getString("user_name"));
                    log.setUserEmail(rs.getString("user_email"));
                    return log;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    private AuditLog map(ResultSet rs) throws SQLException {
        AuditLog l = new AuditLog();
        l.setLogId(rs.getInt("log_id"));
        l.setUserId(getNullableInt(rs, "user_id"));
        l.setAction(rs.getString("action"));
        l.setEntityType(rs.getString("entity_type"));
        l.setEntityId(getNullableInt(rs, "entity_id"));
        l.setOldValues(rs.getString("old_values"));
        l.setNewValues(rs.getString("new_values"));
        l.setIpAddress(rs.getString("ip_address"));
        l.setUserAgent(rs.getString("user_agent"));
        Timestamp ts = rs.getTimestamp("created_at");
        l.setCreatedAt(ts != null ? ts.toLocalDateTime() : null);
        return l;
    }

    private void setNullableInt(PreparedStatement st, int idx, Integer val) throws SQLException {
        if (val != null) st.setInt(idx, val); else st.setNull(idx, Types.INTEGER);
    }

    private Integer getNullableInt(ResultSet rs, String col) throws SQLException {
        int v = rs.getInt(col); return rs.wasNull() ? null : v;
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
    
}
