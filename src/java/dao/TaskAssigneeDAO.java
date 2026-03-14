package dao;

import dbConnection.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.TaskAssignee;

public class TaskAssigneeDAO extends DBContext {

    private TaskAssignee mapResultSet(ResultSet rs) throws SQLException {
        TaskAssignee ta = new TaskAssignee();
        ta.setId(rs.getInt("id"));
        ta.setTaskId(rs.getObject("task_id", Integer.class));
        ta.setUserId(rs.getObject("user_id", Integer.class));
        ta.setRole(rs.getString("role"));
        ta.setTaskStatus(rs.getObject("task_status", Integer.class));

        Timestamp acceptedAt = rs.getTimestamp("accepted_at");
        if (acceptedAt != null) ta.setAcceptedAt(acceptedAt.toLocalDateTime());

        ta.setDeclineReason(rs.getString("decline_reason"));
        ta.setProgress(rs.getObject("progress", Integer.class));
        ta.setAssignedBy(rs.getObject("assigned_by", Integer.class));

        Timestamp assignedAt = rs.getTimestamp("assigned_at");
        if (assignedAt != null) ta.setAssignedAt(assignedAt.toLocalDateTime());

        return ta;
    }

    public boolean insert(TaskAssignee ta) {
        String sql = "INSERT INTO task_assignees (task_id, user_id, role, task_status, accepted_at, " +
                     "decline_reason, progress, assigned_by, assigned_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            st.setObject(1, ta.getTaskId(), java.sql.Types.INTEGER);
            st.setObject(2, ta.getUserId(), java.sql.Types.INTEGER);
            st.setString(3, ta.getRole());
            st.setObject(4, ta.getTaskStatus(), java.sql.Types.TINYINT);

            if (ta.getAcceptedAt() != null) st.setTimestamp(5, Timestamp.valueOf(ta.getAcceptedAt()));
            else st.setNull(5, java.sql.Types.TIMESTAMP);

            st.setString(6, ta.getDeclineReason());
            st.setObject(7, ta.getProgress(), java.sql.Types.TINYINT);
            st.setObject(8, ta.getAssignedBy(), java.sql.Types.INTEGER);

            if (ta.getAssignedAt() != null) st.setTimestamp(9, Timestamp.valueOf(ta.getAssignedAt()));
            else st.setTimestamp(9, Timestamp.valueOf(LocalDateTime.now()));

            int rows = st.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = st.getGeneratedKeys()) {
                    if (keys.next()) ta.setId(keys.getInt(1));
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<TaskAssignee> getByTaskId(int taskId) {
        List<TaskAssignee> list = new ArrayList<>();
        String sql = "SELECT * FROM task_assignees WHERE task_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, taskId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public TaskAssignee getPrimaryAssignee(int taskId) {
        String sql = "SELECT TOP 1 * FROM task_assignees WHERE task_id = ? ORDER BY id ASC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, taskId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return mapResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateAssignee(int taskId, int newUserId, int assignedBy) {
        String sql = "UPDATE task_assignees SET user_id = ?, assigned_by = ?, assigned_at = ? WHERE task_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, newUserId);
            st.setInt(2, assignedBy);
            st.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            st.setInt(4, taskId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateTaskStatus(int taskId, int userId, int taskStatus) {
        String sql = "UPDATE task_assignees SET task_status = ? WHERE task_id = ? AND user_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, taskStatus);
            st.setInt(2, taskId);
            st.setInt(3, userId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteByTaskId(int taskId) {
        String sql = "DELETE FROM task_assignees WHERE task_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, taskId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
