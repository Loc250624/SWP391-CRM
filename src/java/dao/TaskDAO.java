package dao;

import dbConnection.DBContext;
import enums.Priority;
import enums.TaskStatus;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Task;

public class TaskDAO extends DBContext {

    // Helper method to map ResultSet to Task object
    private Task mapResultSetToTask(ResultSet rs) throws SQLException {
        Task task = new Task();
        task.setTaskId(rs.getInt("task_id"));
        task.setTaskCode(rs.getString("task_code"));
        task.setTitle(rs.getString("title"));
        task.setDescription(rs.getString("description"));
        task.setRelatedType(rs.getString("related_type"));
        task.setRelatedId(rs.getObject("related_id", Integer.class));
        task.setAssignedTo(rs.getObject("assigned_to", Integer.class));

        Timestamp dueDate = rs.getTimestamp("due_date");
        if (dueDate != null) {
            task.setDueDate(dueDate.toLocalDateTime());
        }

        Timestamp reminderAt = rs.getTimestamp("reminder_at");
        if (reminderAt != null) {
            task.setReminderAt(reminderAt.toLocalDateTime());
        }

        task.setPriority(rs.getString("priority"));
        task.setStatus(rs.getString("status"));

        Timestamp completedAt = rs.getTimestamp("completed_at");
        if (completedAt != null) {
            task.setCompletedAt(completedAt.toLocalDateTime());
        }

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            task.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            task.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        task.setCreatedBy(rs.getObject("created_by", Integer.class));

        return task;
    }

    // Generate unique task code (TSK-000001, TSK-000002, ...)
    public String generateTaskCode() {
        String sql = "SELECT TOP 1 task_code FROM tasks ORDER BY task_id DESC";

        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {

            if (rs.next()) {
                String lastCode = rs.getString("task_code");
                if (lastCode != null && lastCode.startsWith("TSK-")) {
                    int number = Integer.parseInt(lastCode.substring(4));
                    return String.format("TSK-%06d", number + 1);
                }
            }
            return "TSK-000001";
        } catch (SQLException e) {
            e.printStackTrace();
            return "TSK-" + System.currentTimeMillis();
        }
    }

    // Insert new task
    public boolean insertTask(Task task) {
        String sql = "INSERT INTO tasks (task_code, title, description, related_type, related_id, " +
                     "assigned_to, due_date, reminder_at, priority, status, created_at, updated_at, created_by) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            if (task.getTaskCode() == null || task.getTaskCode().isEmpty()) {
                task.setTaskCode(generateTaskCode());
            }

            st.setString(1, task.getTaskCode());
            st.setString(2, task.getTitle());
            st.setString(3, task.getDescription());
            st.setString(4, task.getRelatedType());

            if (task.getRelatedId() != null) {
                st.setInt(5, task.getRelatedId());
            } else {
                st.setNull(5, java.sql.Types.INTEGER);
            }

            if (task.getAssignedTo() != null) {
                st.setInt(6, task.getAssignedTo());
            } else {
                st.setNull(6, java.sql.Types.INTEGER);
            }

            if (task.getDueDate() != null) {
                st.setTimestamp(7, Timestamp.valueOf(task.getDueDate()));
            } else {
                st.setNull(7, java.sql.Types.TIMESTAMP);
            }

            if (task.getReminderAt() != null) {
                st.setTimestamp(8, Timestamp.valueOf(task.getReminderAt()));
            } else {
                st.setNull(8, java.sql.Types.TIMESTAMP);
            }

            st.setString(9, task.getPriority() != null ? task.getPriority() : Priority.MEDIUM.name());
            st.setString(10, task.getStatus() != null ? task.getStatus() : TaskStatus.PENDING.name());

            LocalDateTime now = LocalDateTime.now();
            st.setTimestamp(11, Timestamp.valueOf(now));
            st.setTimestamp(12, Timestamp.valueOf(now));

            if (task.getCreatedBy() != null) {
                st.setInt(13, task.getCreatedBy());
            } else {
                st.setNull(13, java.sql.Types.INTEGER);
            }

            int rowsAffected = st.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = st.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        task.setTaskId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }

            return false;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update existing task
    public boolean updateTask(Task task) {
        String sql = "UPDATE tasks SET title = ?, description = ?, related_type = ?, related_id = ?, " +
                     "assigned_to = ?, due_date = ?, reminder_at = ?, priority = ?, status = ?, " +
                     "completed_at = ?, updated_at = ? WHERE task_id = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {

            st.setString(1, task.getTitle());
            st.setString(2, task.getDescription());
            st.setString(3, task.getRelatedType());

            if (task.getRelatedId() != null) {
                st.setInt(4, task.getRelatedId());
            } else {
                st.setNull(4, java.sql.Types.INTEGER);
            }

            if (task.getAssignedTo() != null) {
                st.setInt(5, task.getAssignedTo());
            } else {
                st.setNull(5, java.sql.Types.INTEGER);
            }

            if (task.getDueDate() != null) {
                st.setTimestamp(6, Timestamp.valueOf(task.getDueDate()));
            } else {
                st.setNull(6, java.sql.Types.TIMESTAMP);
            }

            if (task.getReminderAt() != null) {
                st.setTimestamp(7, Timestamp.valueOf(task.getReminderAt()));
            } else {
                st.setNull(7, java.sql.Types.TIMESTAMP);
            }

            st.setString(8, task.getPriority());
            st.setString(9, task.getStatus());

            // Auto set completed_at when status is COMPLETED
            if (TaskStatus.COMPLETED.name().equals(task.getStatus())) {
                if (task.getCompletedAt() == null) {
                    st.setTimestamp(10, Timestamp.valueOf(LocalDateTime.now()));
                } else {
                    st.setTimestamp(10, Timestamp.valueOf(task.getCompletedAt()));
                }
            } else {
                st.setNull(10, java.sql.Types.TIMESTAMP);
            }

            st.setTimestamp(11, Timestamp.valueOf(LocalDateTime.now()));
            st.setInt(12, task.getTaskId());

            return st.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete task (hard delete)
    public boolean deleteTask(int taskId) {
        String sql = "DELETE FROM tasks WHERE task_id = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, taskId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get task by ID
    public Task getTaskById(int taskId) {
        String sql = "SELECT * FROM tasks WHERE task_id = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, taskId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToTask(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Get tasks assigned to a specific user (Personal Tasks)
    public List<Task> getTasksByUser(int userId) {
        List<Task> tasks = new ArrayList<>();
        String sql = "SELECT * FROM tasks WHERE assigned_to = ? ORDER BY due_date ASC";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    tasks.add(mapResultSetToTask(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tasks;
    }

    // Get tasks created by a specific user
    public List<Task> getTasksByCreator(int creatorId) {
        List<Task> tasks = new ArrayList<>();
        String sql = "SELECT * FROM tasks WHERE created_by = ? ORDER BY created_at DESC";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, creatorId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    tasks.add(mapResultSetToTask(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tasks;
    }

    // Get tasks for team members (Manager view - get tasks assigned to team members)
    public List<Task> getTasksByTeam(List<Integer> teamMemberIds) {
        if (teamMemberIds == null || teamMemberIds.isEmpty()) {
            return new ArrayList<>();
        }

        List<Task> tasks = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM tasks WHERE assigned_to IN (");

        for (int i = 0; i < teamMemberIds.size(); i++) {
            sql.append("?");
            if (i < teamMemberIds.size() - 1) {
                sql.append(",");
            }
        }
        sql.append(") ORDER BY due_date ASC");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < teamMemberIds.size(); i++) {
                st.setInt(i + 1, teamMemberIds.get(i));
            }

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    tasks.add(mapResultSetToTask(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tasks;
    }

    // Get tasks with filters (for list view with pagination)
    public List<Task> getTasksWithFilter(Integer assignedTo, String status, String priority,
                                         String keyword, String sortBy, String sortOrder,
                                         int offset, int limit) {
        List<Task> tasks = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM tasks WHERE 1=1");

        if (assignedTo != null) {
            sql.append(" AND assigned_to = ?");
        }

        if (status != null && !status.isEmpty()) {
            sql.append(" AND status = ?");
        }

        if (priority != null && !priority.isEmpty()) {
            sql.append(" AND priority = ?");
        }

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND (title LIKE ? OR description LIKE ?)");
        }

        // Sorting
        if (sortBy != null && !sortBy.isEmpty()) {
            sql.append(" ORDER BY ").append(sortBy);
            if (sortOrder != null && sortOrder.equalsIgnoreCase("DESC")) {
                sql.append(" DESC");
            } else {
                sql.append(" ASC");
            }
        } else {
            sql.append(" ORDER BY due_date ASC");
        }

        // Pagination
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;

            if (assignedTo != null) {
                st.setInt(paramIndex++, assignedTo);
            }

            if (status != null && !status.isEmpty()) {
                st.setString(paramIndex++, status);
            }

            if (priority != null && !priority.isEmpty()) {
                st.setString(paramIndex++, priority);
            }

            if (keyword != null && !keyword.isEmpty()) {
                String searchPattern = "%" + keyword + "%";
                st.setString(paramIndex++, searchPattern);
                st.setString(paramIndex++, searchPattern);
            }

            st.setInt(paramIndex++, offset);
            st.setInt(paramIndex++, limit);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    tasks.add(mapResultSetToTask(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tasks;
    }

    // Count tasks with filter (for pagination)
    public int countTasksWithFilter(Integer assignedTo, String status, String priority, String keyword) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) as total FROM tasks WHERE 1=1");

        if (assignedTo != null) {
            sql.append(" AND assigned_to = ?");
        }

        if (status != null && !status.isEmpty()) {
            sql.append(" AND status = ?");
        }

        if (priority != null && !priority.isEmpty()) {
            sql.append(" AND priority = ?");
        }

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND (title LIKE ? OR description LIKE ?)");
        }

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;

            if (assignedTo != null) {
                st.setInt(paramIndex++, assignedTo);
            }

            if (status != null && !status.isEmpty()) {
                st.setString(paramIndex++, status);
            }

            if (priority != null && !priority.isEmpty()) {
                st.setString(paramIndex++, priority);
            }

            if (keyword != null && !keyword.isEmpty()) {
                String searchPattern = "%" + keyword + "%";
                st.setString(paramIndex++, searchPattern);
                st.setString(paramIndex++, searchPattern);
            }

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    // Get task statistics (for reports)
    public Map<String, Object> getTaskStatistics(Integer userId, List<Integer> teamMemberIds) {
        Map<String, Object> stats = new HashMap<>();

        StringBuilder sql = new StringBuilder(
            "SELECT " +
            "COUNT(*) as total_tasks, " +
            "SUM(CASE WHEN status = 'COMPLETED' THEN 1 ELSE 0 END) as completed_tasks, " +
            "SUM(CASE WHEN status = 'PENDING' THEN 1 ELSE 0 END) as pending_tasks, " +
            "SUM(CASE WHEN status = 'IN_PROGRESS' THEN 1 ELSE 0 END) as in_progress_tasks, " +
            "SUM(CASE WHEN due_date < GETDATE() AND status != 'COMPLETED' THEN 1 ELSE 0 END) as overdue_tasks, " +
            "SUM(CASE WHEN priority = 'HIGH' AND status != 'COMPLETED' THEN 1 ELSE 0 END) as high_priority_pending " +
            "FROM tasks WHERE 1=1"
        );

        if (userId != null) {
            sql.append(" AND assigned_to = ?");
        } else if (teamMemberIds != null && !teamMemberIds.isEmpty()) {
            sql.append(" AND assigned_to IN (");
            for (int i = 0; i < teamMemberIds.size(); i++) {
                sql.append("?");
                if (i < teamMemberIds.size() - 1) {
                    sql.append(",");
                }
            }
            sql.append(")");
        }

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;

            if (userId != null) {
                st.setInt(paramIndex++, userId);
            } else if (teamMemberIds != null && !teamMemberIds.isEmpty()) {
                for (Integer memberId : teamMemberIds) {
                    st.setInt(paramIndex++, memberId);
                }
            }

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    stats.put("totalTasks", rs.getInt("total_tasks"));
                    stats.put("completedTasks", rs.getInt("completed_tasks"));
                    stats.put("pendingTasks", rs.getInt("pending_tasks"));
                    stats.put("inProgressTasks", rs.getInt("in_progress_tasks"));
                    stats.put("overdueTasks", rs.getInt("overdue_tasks"));
                    stats.put("highPriorityPending", rs.getInt("high_priority_pending"));

                    int total = rs.getInt("total_tasks");
                    int completed = rs.getInt("completed_tasks");
                    double completionRate = total > 0 ? (completed * 100.0 / total) : 0;
                    stats.put("completionRate", completionRate);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return stats;
    }

    // Get tasks grouped by employee (for manager report)
    public Map<Integer, List<Task>> getTasksGroupedByEmployee(List<Integer> teamMemberIds) {
        Map<Integer, List<Task>> groupedTasks = new HashMap<>();

        if (teamMemberIds == null || teamMemberIds.isEmpty()) {
            return groupedTasks;
        }

        StringBuilder sql = new StringBuilder("SELECT * FROM tasks WHERE assigned_to IN (");
        for (int i = 0; i < teamMemberIds.size(); i++) {
            sql.append("?");
            if (i < teamMemberIds.size() - 1) {
                sql.append(",");
            }
        }
        sql.append(") ORDER BY assigned_to, due_date ASC");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < teamMemberIds.size(); i++) {
                st.setInt(i + 1, teamMemberIds.get(i));
            }

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Task task = mapResultSetToTask(rs);
                    Integer assignedTo = task.getAssignedTo();

                    if (assignedTo != null) {
                        groupedTasks.computeIfAbsent(assignedTo, k -> new ArrayList<>()).add(task);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return groupedTasks;
    }

    // Get tasks for calendar view (grouped by date)
    public List<Task> getTasksForCalendar(int year, int month, Integer userId, List<Integer> teamMemberIds) {
        List<Task> tasks = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
            "SELECT * FROM tasks WHERE YEAR(due_date) = ? AND MONTH(due_date) = ?"
        );

        if (userId != null) {
            sql.append(" AND assigned_to = ?");
        } else if (teamMemberIds != null && !teamMemberIds.isEmpty()) {
            sql.append(" AND assigned_to IN (");
            for (int i = 0; i < teamMemberIds.size(); i++) {
                sql.append("?");
                if (i < teamMemberIds.size() - 1) {
                    sql.append(",");
                }
            }
            sql.append(")");
        }

        sql.append(" ORDER BY due_date ASC");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            st.setInt(paramIndex++, year);
            st.setInt(paramIndex++, month);

            if (userId != null) {
                st.setInt(paramIndex++, userId);
            } else if (teamMemberIds != null && !teamMemberIds.isEmpty()) {
                for (Integer memberId : teamMemberIds) {
                    st.setInt(paramIndex++, memberId);
                }
            }

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    tasks.add(mapResultSetToTask(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tasks;
    }

    // Get upcoming tasks with reminders (for reminder feature)
    public List<Task> getUpcomingTasksWithReminders(int userId, int hoursAhead) {
        List<Task> tasks = new ArrayList<>();
        String sql = "SELECT * FROM tasks WHERE assigned_to = ? " +
                     "AND status != 'COMPLETED' AND status != 'CANCELLED' " +
                     "AND due_date BETWEEN GETDATE() AND DATEADD(HOUR, ?, GETDATE()) " +
                     "ORDER BY due_date ASC";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            st.setInt(2, hoursAhead);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    tasks.add(mapResultSetToTask(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tasks;
    }

    // Get overdue tasks
    public List<Task> getOverdueTasks(Integer userId, List<Integer> teamMemberIds) {
        List<Task> tasks = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT * FROM tasks WHERE due_date < GETDATE() " +
            "AND status != 'COMPLETED' AND status != 'CANCELLED'"
        );

        if (userId != null) {
            sql.append(" AND assigned_to = ?");
        } else if (teamMemberIds != null && !teamMemberIds.isEmpty()) {
            sql.append(" AND assigned_to IN (");
            for (int i = 0; i < teamMemberIds.size(); i++) {
                sql.append("?");
                if (i < teamMemberIds.size() - 1) {
                    sql.append(",");
                }
            }
            sql.append(")");
        }

        sql.append(" ORDER BY due_date ASC");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;

            if (userId != null) {
                st.setInt(paramIndex++, userId);
            } else if (teamMemberIds != null && !teamMemberIds.isEmpty()) {
                for (Integer memberId : teamMemberIds) {
                    st.setInt(paramIndex++, memberId);
                }
            }

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    tasks.add(mapResultSetToTask(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tasks;
    }
}
