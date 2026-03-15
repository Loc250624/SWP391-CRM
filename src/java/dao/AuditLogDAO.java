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
}
