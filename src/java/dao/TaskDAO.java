package dao;

import dbConnection.DBContext;
import enums.Priority;
import enums.TaskStatus;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Task;

public class TaskDAO {

    private Connection conn;

    public TaskDAO() {
        try {
            conn = new DBContext().getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Task> getTasksByAssignee(int assigneeId) {
        List<Task> tasks = new ArrayList<>();
        String sql = "SELECT * FROM Tasks WHERE AssigneeID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, assigneeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    tasks.add(mapResultSetToTask(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }

    public List<Task> getTasksByDepartment(int departmentId) {
        // This query assumes a join with Users table to get department
        List<Task> tasks = new ArrayList<>();
        String sql = "SELECT t.* FROM Tasks t JOIN Users u ON t.AssigneeID = u.UserID WHERE u.DepartmentID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, departmentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    tasks.add(mapResultSetToTask(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }

    public Task getTaskById(int taskId) {
        String sql = "SELECT * FROM Tasks WHERE TaskID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, taskId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToTask(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int addTask(Task task) {
        String sql = "INSERT INTO Tasks (Title, Description, AssigneeID, DueDate, Priority, Status, CreatedBy, RelatedToEntityType, RelatedToEntityId) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, task.getTitle());
            ps.setString(2, task.getDescription());
            ps.setInt(3, task.getAssigneeId());
            ps.setDate(4, task.getDueDate());
            ps.setString(5, task.getPriority().name());
            ps.setString(6, task.getStatus().name());
            ps.setInt(7, task.getCreatedBy());
            ps.setString(8, task.getRelatedToEntityType());
            ps.setInt(9, task.getRelatedToEntityId());
            
            ps.executeUpdate();
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean updateTask(Task task) {
        String sql = "UPDATE Tasks SET Title = ?, Description = ?, AssigneeID = ?, DueDate = ?, Priority = ?, Status = ?, RelatedToEntityType = ?, RelatedToEntityId = ? WHERE TaskID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, task.getTitle());
            ps.setString(2, task.getDescription());
            ps.setInt(3, task.getAssigneeId());
            ps.setDate(4, task.getDueDate());
            ps.setString(5, task.getPriority().name());
            ps.setString(6, task.getStatus().name());
            ps.setString(7, task.getRelatedToEntityType());
            ps.setInt(8, task.getRelatedToEntityId());
            ps.setInt(9, task.getTaskId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteTask(int taskId) {
        String sql = "DELETE FROM Tasks WHERE TaskID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, taskId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Task mapResultSetToTask(ResultSet rs) throws SQLException {
        return new Task(
                rs.getInt("TaskID"),
                rs.getString("Title"),
                rs.getString("Description"),
                rs.getInt("AssigneeID"),
                rs.getDate("DueDate"),
                Priority.valueOf(rs.getString("Priority")),
                TaskStatus.valueOf(rs.getString("Status")),
                rs.getInt("CreatedBy"),
                rs.getTimestamp("CreatedAt"),
                rs.getString("RelatedToEntityType"),
                rs.getInt("RelatedToEntityId")
        );
    }
}