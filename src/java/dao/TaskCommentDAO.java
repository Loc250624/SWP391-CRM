package dao;

import dbConnection.DBContext;
import model.TaskComment;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class TaskCommentDAO extends DBContext {

    public boolean insertComment(int taskId, int userId, String content) {
        String sql = "INSERT INTO task_comments (task_id, user_id, content, created_at) VALUES (?, ?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, taskId);
            st.setInt(2, userId);
            st.setString(3, content);
            st.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<TaskComment> getCommentsByTaskId(int taskId) {
        List<TaskComment> list = new ArrayList<>();
        String sql = "SELECT * FROM task_comments WHERE task_id = ? ORDER BY created_at ASC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, taskId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    TaskComment c = new TaskComment();
                    c.setCommentId(rs.getInt("comment_id"));
                    c.setTaskId(rs.getInt("task_id"));
                    c.setUserId(rs.getInt("user_id"));
                    c.setContent(rs.getString("content"));
                    Timestamp ts = rs.getTimestamp("created_at");
                    if (ts != null) c.setCreatedAt(ts.toLocalDateTime());
                    list.add(c);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
