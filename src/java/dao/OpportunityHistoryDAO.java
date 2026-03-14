package dao;

import dbConnection.DBContext;
import model.OpportunityHistory;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class OpportunityHistoryDAO extends DBContext {

    public boolean insertHistory(OpportunityHistory h) {
        String sql = "INSERT INTO opportunity_history (opportunity_id, field_name, old_value, new_value, changed_by) VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, h.getOpportunityId());
            stmt.setString(2, h.getFieldName());
            stmt.setString(3, h.getOldValue());
            stmt.setString(4, h.getNewValue());
            if (h.getChangedBy() != null) {
                stmt.setInt(5, h.getChangedBy());
            } else {
                stmt.setNull(5, Types.INTEGER);
            }
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void logChange(int opportunityId, String fieldName, String oldValue, String newValue, Integer changedBy) {
        if (oldValue == null) oldValue = "";
        if (newValue == null) newValue = "";
        if (oldValue.equals(newValue)) return;

        OpportunityHistory h = new OpportunityHistory();
        h.setOpportunityId(opportunityId);
        h.setFieldName(fieldName);
        h.setOldValue(oldValue.isEmpty() ? null : oldValue);
        h.setNewValue(newValue.isEmpty() ? null : newValue);
        h.setChangedBy(changedBy);
        insertHistory(h);
    }

    public List<OpportunityHistory> getHistoryByOpportunityId(int opportunityId) {
        List<OpportunityHistory> list = new ArrayList<>();
        String sql = "SELECT * FROM opportunity_history WHERE opportunity_id = ? ORDER BY changed_at DESC";
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, opportunityId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(extractFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<OpportunityHistory> getHistoryByUserId(int userId) {
        List<OpportunityHistory> list = new ArrayList<>();
        String sql = "SELECT h.* FROM opportunity_history h "
                + "JOIN opportunities o ON h.opportunity_id = o.opportunity_id "
                + "WHERE o.owner_id = ? OR o.created_by = ? "
                + "ORDER BY h.changed_at DESC";
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(extractFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private OpportunityHistory extractFromResultSet(ResultSet rs) throws SQLException {
        OpportunityHistory h = new OpportunityHistory();
        h.setHistoryId(rs.getInt("history_id"));
        h.setOpportunityId(rs.getInt("opportunity_id"));
        h.setFieldName(rs.getString("field_name"));
        h.setOldValue(rs.getString("old_value"));
        h.setNewValue(rs.getString("new_value"));
        Timestamp ts = rs.getTimestamp("changed_at");
        if (ts != null) h.setChangedAt(ts.toLocalDateTime());
        int cb = rs.getInt("changed_by");
        h.setChangedBy(rs.wasNull() ? null : cb);
        return h;
    }
}
