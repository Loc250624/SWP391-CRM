package dao;

import dbConnection.DBContext;
import model.Comment;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class TaskCommentDAO extends DBContext {

    private static final String RELATED_TYPE = "TASK";

    public boolean insertComment(int taskId, int userId, String content) {
        String sql = "INSERT INTO comments (related_type, related_id, content, created_at, created_by) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, RELATED_TYPE);
            st.setInt(2, taskId);
            st.setString(3, content);
            st.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            st.setInt(5, userId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Comment> getCommentsByTaskId(int taskId) {
        List<Comment> list = new ArrayList<>();
        String sql = "SELECT * FROM comments WHERE related_type = ? AND related_id = ? ORDER BY created_at ASC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, RELATED_TYPE);
            st.setInt(2, taskId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Comment c = new Comment();
                    c.setCommentId(rs.getInt("comment_id"));
                    c.setRelatedType(rs.getString("related_type"));
                    c.setRelatedId(rs.getInt("related_id"));
                    c.setContent(rs.getString("content"));
                    c.setParentCommentId(rs.getObject("parent_comment_id", Integer.class));
                    Timestamp ts = rs.getTimestamp("created_at");
                    if (ts != null) c.setCreatedAt(ts.toLocalDateTime());
                    c.setCreatedBy(rs.getInt("created_by"));
                    list.add(c);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
