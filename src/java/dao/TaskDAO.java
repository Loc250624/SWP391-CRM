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
            // Fallback schema v2 (snake_case)
            String sqlV2 = "SELECT * FROM tasks WHERE assigned_to = ?";
            try (PreparedStatement psV2 = conn.prepareStatement(sqlV2)) {
                psV2.setInt(1, assigneeId);
                try (ResultSet rs2 = psV2.executeQuery()) {
                    while (rs2.next()) {
                        tasks.add(mapResultSetToTaskV2(rs2));
                    }
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
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
            // Fallback schema v2 (snake_case)
            String sqlV2 = "SELECT t.* FROM tasks t JOIN users u ON t.assigned_to = u.user_id WHERE u.department_id = ?";
            try (PreparedStatement psV2 = conn.prepareStatement(sqlV2)) {
                psV2.setInt(1, departmentId);
                try (ResultSet rs2 = psV2.executeQuery()) {
                    while (rs2.next()) {
                        tasks.add(mapResultSetToTaskV2(rs2));
                    }
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
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
            // Fallback schema v2 (snake_case)
            String sqlV2 = "SELECT * FROM tasks WHERE task_id = ?";
            try (PreparedStatement psV2 = conn.prepareStatement(sqlV2)) {
                psV2.setInt(1, taskId);
                try (ResultSet rs2 = psV2.executeQuery()) {
                    if (rs2.next()) {
                        return mapResultSetToTaskV2(rs2);
                    }
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
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
            // Fallback schema v2 (snake_case) có task_code
            String sqlV2 = "INSERT INTO tasks (task_code, title, description, assigned_to, due_date, priority, status, created_by, related_type, related_id, created_at, updated_at) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, getdate(), getdate())";
            try (PreparedStatement psV2 = conn.prepareStatement(sqlV2, Statement.RETURN_GENERATED_KEYS)) {
                psV2.setString(1, taoMaCongViec());
                psV2.setString(2, task.getTitle());
                psV2.setString(3, task.getDescription());

                if (task.getAssigneeId() > 0) {
                    psV2.setInt(4, task.getAssigneeId());
                } else {
                    psV2.setNull(4, java.sql.Types.INTEGER);
                }

                if (task.getDueDate() != null) {
                    psV2.setTimestamp(5, new java.sql.Timestamp(task.getDueDate().getTime()));
                } else {
                    psV2.setNull(5, java.sql.Types.TIMESTAMP);
                }

                psV2.setString(6, task.getPriority().name());
                psV2.setString(7, task.getStatus().name());
                psV2.setInt(8, task.getCreatedBy());

                if (task.getRelatedToEntityType() != null && !task.getRelatedToEntityType().isEmpty()) {
                    psV2.setString(9, task.getRelatedToEntityType());
                } else {
                    psV2.setNull(9, java.sql.Types.NVARCHAR);
                }

                if (task.getRelatedToEntityId() > 0) {
                    psV2.setInt(10, task.getRelatedToEntityId());
                } else {
                    psV2.setNull(10, java.sql.Types.INTEGER);
                }

                psV2.executeUpdate();
                try (ResultSet generatedKeys = psV2.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
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
            // Fallback schema v2 (snake_case)
            String sqlV2 = "UPDATE tasks SET title = ?, description = ?, assigned_to = ?, due_date = ?, priority = ?, status = ?, related_type = ?, related_id = ?, updated_at = getdate() WHERE task_id = ?";
            try (PreparedStatement psV2 = conn.prepareStatement(sqlV2)) {
                psV2.setString(1, task.getTitle());
                psV2.setString(2, task.getDescription());

                if (task.getAssigneeId() > 0) {
                    psV2.setInt(3, task.getAssigneeId());
                } else {
                    psV2.setNull(3, java.sql.Types.INTEGER);
                }

                if (task.getDueDate() != null) {
                    psV2.setTimestamp(4, new java.sql.Timestamp(task.getDueDate().getTime()));
                } else {
                    psV2.setNull(4, java.sql.Types.TIMESTAMP);
                }

                psV2.setString(5, task.getPriority().name());
                psV2.setString(6, task.getStatus().name());

                if (task.getRelatedToEntityType() != null && !task.getRelatedToEntityType().isEmpty()) {
                    psV2.setString(7, task.getRelatedToEntityType());
                } else {
                    psV2.setNull(7, java.sql.Types.NVARCHAR);
                }

                if (task.getRelatedToEntityId() > 0) {
                    psV2.setInt(8, task.getRelatedToEntityId());
                } else {
                    psV2.setNull(8, java.sql.Types.INTEGER);
                }

                psV2.setInt(9, task.getTaskId());
                return psV2.executeUpdate() > 0;
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
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
            // Fallback schema v2 (snake_case)
            String sqlV2 = "DELETE FROM tasks WHERE task_id = ?";
            try (PreparedStatement psV2 = conn.prepareStatement(sqlV2)) {
                psV2.setInt(1, taskId);
                return psV2.executeUpdate() > 0;
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
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

    private Task mapResultSetToTaskV2(ResultSet rs) throws SQLException {
        int nguoiDuocGiao = rs.getInt("assigned_to");
        if (rs.wasNull()) {
            nguoiDuocGiao = 0;
        }

        java.sql.Timestamp tsHan = rs.getTimestamp("due_date");
        java.sql.Date ngayHetHan = tsHan != null ? new java.sql.Date(tsHan.getTime()) : null;

        int lienKetId = 0;
        Object lienKetObj = rs.getObject("related_id");
        if (lienKetObj != null) {
            lienKetId = rs.getInt("related_id");
        }

        return new Task(
                rs.getInt("task_id"),
                rs.getString("title"),
                rs.getString("description"),
                nguoiDuocGiao,
                ngayHetHan,
                chuyenUuTien(rs.getString("priority")),
                chuyenTrangThai(rs.getString("status")),
                rs.getInt("created_by"),
                rs.getTimestamp("created_at"),
                rs.getString("related_type"),
                lienKetId
        );
    }

    private TaskStatus chuyenTrangThai(String giaTri) {
        if (giaTri == null) {
            return TaskStatus.PENDING;
        }
        String chuanHoa = giaTri.trim().toUpperCase().replace(" ", "_");
        try {
            return TaskStatus.valueOf(chuanHoa);
        } catch (Exception e) {
            return TaskStatus.PENDING;
        }
    }

    private Priority chuyenUuTien(String giaTri) {
        if (giaTri == null) {
            return Priority.MEDIUM;
        }
        String chuanHoa = giaTri.trim().toUpperCase();
        try {
            return Priority.valueOf(chuanHoa);
        } catch (Exception e) {
            return Priority.MEDIUM;
        }
    }

    private String taoMaCongViec() {
        String thoiGian = java.time.LocalDateTime.now()
                .format(java.time.format.DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        return "TSK-" + thoiGian;
    }
}
