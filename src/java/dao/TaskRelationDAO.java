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
import model.TaskRelation;

public class TaskRelationDAO extends DBContext {

    private TaskRelation mapResultSet(ResultSet rs) throws SQLException {
        TaskRelation tr = new TaskRelation();
        tr.setId(rs.getInt("id"));
        tr.setTaskId(rs.getObject("task_id", Integer.class));
        tr.setRelatedType(rs.getString("related_type"));
        tr.setRelatedId(rs.getObject("related_id", Integer.class));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) tr.setCreatedAt(createdAt.toLocalDateTime());

        tr.setCreatedBy(rs.getObject("created_by", Integer.class));
        return tr;
    }

    public boolean insert(TaskRelation tr) {
        String sql = "INSERT INTO task_relations (task_id, related_type, related_id, created_at, created_by) " +
                     "VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            st.setObject(1, tr.getTaskId(), java.sql.Types.INTEGER);
            st.setString(2, tr.getRelatedType());
            st.setObject(3, tr.getRelatedId(), java.sql.Types.INTEGER);
            st.setTimestamp(4, Timestamp.valueOf(tr.getCreatedAt() != null ? tr.getCreatedAt() : LocalDateTime.now()));
            st.setObject(5, tr.getCreatedBy(), java.sql.Types.INTEGER);

            int rows = st.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = st.getGeneratedKeys()) {
                    if (keys.next()) tr.setId(keys.getInt(1));
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<TaskRelation> getByTaskId(int taskId) {
        List<TaskRelation> list = new ArrayList<>();
        String sql = "SELECT * FROM task_relations WHERE task_id = ?";
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

    public TaskRelation getPrimaryRelation(int taskId) {
        String sql = "SELECT TOP 1 * FROM task_relations WHERE task_id = ? ORDER BY id ASC";
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

    public boolean deleteByTaskId(int taskId) {
        String sql = "DELETE FROM task_relations WHERE task_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, taskId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
