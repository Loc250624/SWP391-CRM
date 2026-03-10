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
import model.TaskAssignee;
import model.TaskRelation;

public class TaskDAO extends DBContext {

    // Base SELECT with JOINs to populate assignedTo and relatedType/relatedId
    private static final String BASE_SELECT =
        "SELECT t.*, ta.user_id AS assigned_to, tr.related_type, tr.related_id " +
        "FROM tasks t " +
        "LEFT JOIN task_assignees ta ON t.task_id = ta.task_id " +
        "LEFT JOIN task_relations tr ON t.task_id = tr.task_id";

    // Helper method to map ResultSet to Task object
    private Task mapResultSetToTask(ResultSet rs) throws SQLException {
        Task task = new Task();
        task.setTaskId(rs.getInt("task_id"));
        task.setTaskCode(rs.getString("task_code"));
        task.setTitle(rs.getString("title"));
        task.setDescription(rs.getString("description"));

        Timestamp dueDate = rs.getTimestamp("due_date");
        if (dueDate != null) {
            task.setDueDate(dueDate.toLocalDateTime());
        }

        Timestamp reminderAt = rs.getTimestamp("reminder_at");
        if (reminderAt != null) {
            task.setReminderAt(reminderAt.toLocalDateTime());
        }

        task.setPriority(rs.getObject("priority", Integer.class));
        task.setStatus(rs.getObject("status", Integer.class));

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

        // Populated from JOINs
        try {
            task.setAssignedTo(rs.getObject("assigned_to", Integer.class));
        } catch (SQLException ignored) {}
        try {
            task.setRelatedType(rs.getString("related_type"));
        } catch (SQLException ignored) {}
        try {
            task.setRelatedId(rs.getObject("related_id", Integer.class));
        } catch (SQLException ignored) {}

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

    // Insert new task (into tasks table only, returns generated task_id)
    // Caller should also insert into task_assignees and task_relations separately
    public boolean insertTask(Task task) {
        String sql = "INSERT INTO tasks (task_code, title, description, " +
                     "due_date, reminder_at, priority, status, created_at, updated_at, created_by) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            if (task.getTaskCode() == null || task.getTaskCode().isEmpty()) {
                task.setTaskCode(generateTaskCode());
            }

            st.setString(1, task.getTaskCode());
            st.setString(2, task.getTitle());
            st.setString(3, task.getDescription());

            if (task.getDueDate() != null) {
                st.setTimestamp(4, Timestamp.valueOf(task.getDueDate()));
            } else {
                st.setNull(4, java.sql.Types.TIMESTAMP);
            }

            if (task.getReminderAt() != null) {
                st.setTimestamp(5, Timestamp.valueOf(task.getReminderAt()));
            } else {
                st.setNull(5, java.sql.Types.TIMESTAMP);
            }

            int pri = task.getPriority() != null ? task.getPriority() : Priority.MEDIUM.ordinal();
            int sta = task.getStatus()   != null ? task.getStatus()   : TaskStatus.PENDING.ordinal();
            st.setInt(6, pri);
            st.setInt(7, sta);

            LocalDateTime now = LocalDateTime.now();
            st.setTimestamp(8, Timestamp.valueOf(now));
            st.setTimestamp(9, Timestamp.valueOf(now));

            if (task.getCreatedBy() != null) {
                st.setInt(10, task.getCreatedBy());
            } else {
                st.setNull(10, java.sql.Types.INTEGER);
            }

            int rowsAffected = st.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = st.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        task.setTaskId(generatedKeys.getInt(1));
                    }
                }

                // Auto-insert into task_assignees if assignedTo is set
                if (task.getAssignedTo() != null) {
                    insertTaskAssignee(task.getTaskId(), task.getAssignedTo(), task.getCreatedBy());
                }

                // Auto-insert into task_relations if relatedType/relatedId are set
                if (task.getRelatedType() != null && task.getRelatedId() != null) {
                    insertTaskRelation(task.getTaskId(), task.getRelatedType(), task.getRelatedId(), task.getCreatedBy());
                }

                return true;
            }

            return false;

        } catch (SQLException e) {
            System.err.println("=== insertTask FAILED ===");
            System.err.println("Message: "   + e.getMessage());
            System.err.println("SQLState: "  + e.getSQLState());
            System.err.println("ErrorCode: " + e.getErrorCode());
            e.printStackTrace();
            return false;
        }
    }

    // Helper: insert into task_assignees
    private void insertTaskAssignee(int taskId, int userId, Integer assignedBy) {
        String sql = "INSERT INTO task_assignees (task_id, user_id, role, task_status, assigned_by, assigned_at) " +
                     "VALUES (?, ?, 'ASSIGNEE', 0, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, taskId);
            st.setInt(2, userId);
            if (assignedBy != null) st.setInt(3, assignedBy);
            else st.setNull(3, java.sql.Types.INTEGER);
            st.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Helper: insert into task_relations
    private void insertTaskRelation(int taskId, String relatedType, int relatedId, Integer createdBy) {
        String sql = "INSERT INTO task_relations (task_id, related_type, related_id, created_at, created_by) " +
                     "VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, taskId);
            st.setString(2, relatedType);
            st.setInt(3, relatedId);
            st.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            if (createdBy != null) st.setInt(5, createdBy);
            else st.setNull(5, java.sql.Types.INTEGER);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Update existing task
    public boolean updateTask(Task task) {
        String sql = "UPDATE tasks SET title = ?, description = ?, " +
                     "due_date = ?, reminder_at = ?, priority = ?, status = ?, " +
                     "completed_at = ?, updated_at = ? WHERE task_id = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {

            st.setString(1, task.getTitle());
            st.setString(2, task.getDescription());

            if (task.getDueDate() != null) {
                st.setTimestamp(3, Timestamp.valueOf(task.getDueDate()));
            } else {
                st.setNull(3, java.sql.Types.TIMESTAMP);
            }

            if (task.getReminderAt() != null) {
                st.setTimestamp(4, Timestamp.valueOf(task.getReminderAt()));
            } else {
                st.setNull(4, java.sql.Types.TIMESTAMP);
            }

            st.setObject(5, task.getPriority(), java.sql.Types.TINYINT);
            st.setObject(6, task.getStatus(),   java.sql.Types.TINYINT);

            // Auto set completed_at when status is COMPLETED
            if (task.getStatus() != null && task.getStatus() == TaskStatus.COMPLETED.ordinal()) {
                if (task.getCompletedAt() == null) {
                    st.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now()));
                } else {
                    st.setTimestamp(7, Timestamp.valueOf(task.getCompletedAt()));
                }
            } else {
                st.setNull(7, java.sql.Types.TIMESTAMP);
            }

            st.setTimestamp(8, Timestamp.valueOf(LocalDateTime.now()));
            st.setInt(9, task.getTaskId());

            boolean updated = st.executeUpdate() > 0;

            if (updated) {
                // Update task_assignees if assignedTo changed
                if (task.getAssignedTo() != null) {
                    updateOrInsertAssignee(task.getTaskId(), task.getAssignedTo(), task.getCreatedBy());
                }

                // Update task_relations if relatedType/relatedId changed
                if (task.getRelatedType() != null && task.getRelatedId() != null) {
                    updateOrInsertRelation(task.getTaskId(), task.getRelatedType(), task.getRelatedId(), task.getCreatedBy());
                }
            }

            return updated;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Helper: update or insert assignee
    private void updateOrInsertAssignee(int taskId, int userId, Integer assignedBy) {
        String checkSql = "SELECT COUNT(*) FROM task_assignees WHERE task_id = ?";
        try (PreparedStatement st = connection.prepareStatement(checkSql)) {
            st.setInt(1, taskId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    // Update existing
                    String updateSql = "UPDATE task_assignees SET user_id = ?, assigned_by = ?, assigned_at = ? WHERE task_id = ?";
                    try (PreparedStatement st2 = connection.prepareStatement(updateSql)) {
                        st2.setInt(1, userId);
                        if (assignedBy != null) st2.setInt(2, assignedBy);
                        else st2.setNull(2, java.sql.Types.INTEGER);
                        st2.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
                        st2.setInt(4, taskId);
                        st2.executeUpdate();
                    }
                } else {
                    insertTaskAssignee(taskId, userId, assignedBy);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Helper: update or insert relation
    private void updateOrInsertRelation(int taskId, String relatedType, int relatedId, Integer createdBy) {
        String checkSql = "SELECT COUNT(*) FROM task_relations WHERE task_id = ?";
        try (PreparedStatement st = connection.prepareStatement(checkSql)) {
            st.setInt(1, taskId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    String updateSql = "UPDATE task_relations SET related_type = ?, related_id = ? WHERE task_id = ?";
                    try (PreparedStatement st2 = connection.prepareStatement(updateSql)) {
                        st2.setString(1, relatedType);
                        st2.setInt(2, relatedId);
                        st2.setInt(3, taskId);
                        st2.executeUpdate();
                    }
                } else {
                    insertTaskRelation(taskId, relatedType, relatedId, createdBy);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete task (hard delete) - also deletes from task_assignees and task_relations
    public boolean deleteTask(int taskId) {
        try {
            // Delete related records first
            try (PreparedStatement st = connection.prepareStatement("DELETE FROM task_assignees WHERE task_id = ?")) {
                st.setInt(1, taskId);
                st.executeUpdate();
            }
            try (PreparedStatement st = connection.prepareStatement("DELETE FROM task_relations WHERE task_id = ?")) {
                st.setInt(1, taskId);
                st.executeUpdate();
            }
            // Delete the task
            try (PreparedStatement st = connection.prepareStatement("DELETE FROM tasks WHERE task_id = ?")) {
                st.setInt(1, taskId);
                return st.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get task by ID
    public Task getTaskById(int taskId) {
        String sql = BASE_SELECT + " WHERE t.task_id = ?";

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

    // Get tasks assigned to a specific user (via task_assignees)
    public List<Task> getTasksByUser(int userId) {
        List<Task> tasks = new ArrayList<>();
        String sql = BASE_SELECT + " WHERE ta.user_id = ? ORDER BY t.due_date ASC";

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
        String sql = BASE_SELECT + " WHERE t.created_by = ? ORDER BY t.created_at DESC";

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
        StringBuilder sql = new StringBuilder(BASE_SELECT + " WHERE ta.user_id IN (");

        for (int i = 0; i < teamMemberIds.size(); i++) {
            sql.append("?");
            if (i < teamMemberIds.size() - 1) {
                sql.append(",");
            }
        }
        sql.append(") ORDER BY t.due_date ASC");

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
        StringBuilder sql = new StringBuilder(BASE_SELECT + " WHERE 1=1");

        if (assignedTo != null) {
            sql.append(" AND ta.user_id = ?");
        }

        if (status != null && !status.isEmpty()) {
            sql.append(" AND t.status = ?");
        }

        if (priority != null && !priority.isEmpty()) {
            sql.append(" AND t.priority = ?");
        }

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND (t.title LIKE ? OR t.description LIKE ?)");
        }

        // Sorting
        if (sortBy != null && !sortBy.isEmpty()) {
            sql.append(" ORDER BY t.").append(sortBy);
            if (sortOrder != null && sortOrder.equalsIgnoreCase("DESC")) {
                sql.append(" DESC");
            } else {
                sql.append(" ASC");
            }
        } else {
            sql.append(" ORDER BY t.due_date ASC");
        }

        // Pagination
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;

            if (assignedTo != null) {
                st.setInt(paramIndex++, assignedTo);
            }

            if (status != null && !status.isEmpty()) {
                st.setInt(paramIndex++, TaskStatus.valueOf(status).ordinal());
            }

            if (priority != null && !priority.isEmpty()) {
                st.setInt(paramIndex++, Priority.valueOf(priority).ordinal());
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
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) as total FROM tasks t " +
            "LEFT JOIN task_assignees ta ON t.task_id = ta.task_id WHERE 1=1");

        if (assignedTo != null) {
            sql.append(" AND ta.user_id = ?");
        }

        if (status != null && !status.isEmpty()) {
            sql.append(" AND t.status = ?");
        }

        if (priority != null && !priority.isEmpty()) {
            sql.append(" AND t.priority = ?");
        }

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND (t.title LIKE ? OR t.description LIKE ?)");
        }

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;

            if (assignedTo != null) {
                st.setInt(paramIndex++, assignedTo);
            }

            if (status != null && !status.isEmpty()) {
                st.setInt(paramIndex++, TaskStatus.valueOf(status).ordinal());
            }

            if (priority != null && !priority.isEmpty()) {
                st.setInt(paramIndex++, Priority.valueOf(priority).ordinal());
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
            "SUM(CASE WHEN t.status = 2 THEN 1 ELSE 0 END) as completed_tasks, " +
            "SUM(CASE WHEN t.status = 0 THEN 1 ELSE 0 END) as pending_tasks, " +
            "SUM(CASE WHEN t.status = 1 THEN 1 ELSE 0 END) as in_progress_tasks, " +
            "SUM(CASE WHEN t.due_date < GETDATE() AND t.status != 2 THEN 1 ELSE 0 END) as overdue_tasks, " +
            "SUM(CASE WHEN t.priority = 2 AND t.status != 2 THEN 1 ELSE 0 END) as high_priority_pending " +
            "FROM tasks t LEFT JOIN task_assignees ta ON t.task_id = ta.task_id WHERE 1=1"
        );

        if (userId != null) {
            sql.append(" AND ta.user_id = ?");
        } else if (teamMemberIds != null && !teamMemberIds.isEmpty()) {
            sql.append(" AND ta.user_id IN (");
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

        StringBuilder sql = new StringBuilder(BASE_SELECT + " WHERE ta.user_id IN (");
        for (int i = 0; i < teamMemberIds.size(); i++) {
            sql.append("?");
            if (i < teamMemberIds.size() - 1) {
                sql.append(",");
            }
        }
        sql.append(") ORDER BY ta.user_id, t.due_date ASC");

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
            BASE_SELECT + " WHERE YEAR(t.due_date) = ? AND MONTH(t.due_date) = ?"
        );

        if (userId != null) {
            sql.append(" AND ta.user_id = ?");
        } else if (teamMemberIds != null && !teamMemberIds.isEmpty()) {
            sql.append(" AND ta.user_id IN (");
            for (int i = 0; i < teamMemberIds.size(); i++) {
                sql.append("?");
                if (i < teamMemberIds.size() - 1) {
                    sql.append(",");
                }
            }
            sql.append(")");
        }

        sql.append(" ORDER BY t.due_date ASC");

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

    // Get tasks within a date range for a set of member IDs (used by calendar AJAX endpoint)
    public List<Task> getTasksByDateRange(List<Integer> memberIds,
            LocalDateTime startDate, LocalDateTime endDate,
            String statusFilter, String priorityFilter) {
        if (memberIds == null || memberIds.isEmpty()) return new ArrayList<>();
        List<Task> tasks = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT + " WHERE ta.user_id IN (");
        for (int i = 0; i < memberIds.size(); i++) sql.append(i > 0 ? ",?" : "?");
        sql.append(") AND t.due_date >= ? AND t.due_date < ?");
        if (statusFilter   != null && !statusFilter.isEmpty())   sql.append(" AND t.status = ?");
        if (priorityFilter != null && !priorityFilter.isEmpty()) sql.append(" AND t.priority = ?");
        sql.append(" ORDER BY t.due_date ASC");
        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Integer id : memberIds) st.setInt(idx++, id);
            st.setTimestamp(idx++, Timestamp.valueOf(startDate));
            st.setTimestamp(idx++, Timestamp.valueOf(endDate));
            if (statusFilter   != null && !statusFilter.isEmpty())   st.setString(idx++, statusFilter);
            if (priorityFilter != null && !priorityFilter.isEmpty()) st.setString(idx++, priorityFilter);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) tasks.add(mapResultSetToTask(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return tasks;
    }

    // Get upcoming tasks with reminders (for reminder feature)
    public List<Task> getUpcomingTasksWithReminders(int userId, int hoursAhead) {
        List<Task> tasks = new ArrayList<>();
        String sql = BASE_SELECT +
                     " WHERE ta.user_id = ? " +
                     "AND t.status != 2 AND t.status != 3 " +
                     "AND t.due_date BETWEEN GETDATE() AND DATEADD(HOUR, ?, GETDATE()) " +
                     "ORDER BY t.due_date ASC";

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

    // Get tasks created by a specific manager (for personal "My Tasks" view)
    public List<Task> getTasksByManager(int managerId, String status, String priority,
                                        String keyword, String sortBy, String sortOrder,
                                        int offset, int limit) {
        List<Task> tasks = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT + " WHERE t.created_by = ?");

        if (status != null && !status.isEmpty()) {
            sql.append(" AND t.status = ?");
        }
        if (priority != null && !priority.isEmpty()) {
            sql.append(" AND t.priority = ?");
        }
        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND (t.title LIKE ? OR t.description LIKE ?)");
        }

        if (sortBy != null && !sortBy.isEmpty()) {
            sql.append(" ORDER BY t.").append(sortBy);
            if ("DESC".equalsIgnoreCase(sortOrder)) sql.append(" DESC");
            else sql.append(" ASC");
        } else {
            sql.append(" ORDER BY t.due_date ASC");
        }

        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            st.setInt(idx++, managerId);
            if (status != null && !status.isEmpty())   st.setInt(idx++, TaskStatus.valueOf(status).ordinal());
            if (priority != null && !priority.isEmpty()) st.setInt(idx++, Priority.valueOf(priority).ordinal());
            if (keyword != null && !keyword.isEmpty()) {
                String pat = "%" + keyword + "%";
                st.setString(idx++, pat);
                st.setString(idx++, pat);
            }
            st.setInt(idx++, offset);
            st.setInt(idx, limit);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) tasks.add(mapResultSetToTask(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }

    // Count tasks created by manager (pagination)
    public int countTasksByManager(int managerId, String status, String priority, String keyword) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) AS total FROM tasks t WHERE t.created_by = ?");

        if (status != null && !status.isEmpty())    sql.append(" AND t.status = ?");
        if (priority != null && !priority.isEmpty()) sql.append(" AND t.priority = ?");
        if (keyword != null && !keyword.isEmpty())   sql.append(" AND (t.title LIKE ? OR t.description LIKE ?)");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            st.setInt(idx++, managerId);
            if (status != null && !status.isEmpty())   st.setInt(idx++, TaskStatus.valueOf(status).ordinal());
            if (priority != null && !priority.isEmpty()) st.setInt(idx++, Priority.valueOf(priority).ordinal());
            if (keyword != null && !keyword.isEmpty()) {
                String pat = "%" + keyword + "%";
                st.setString(idx++, pat);
                st.setString(idx++, pat);
            }
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Get team tasks with SQL-level filtering and pagination
    public List<Task> getTasksWithFilterForTeam(List<Integer> memberIds, Integer selectedEmployee,
                                                 String status, String priority, String keyword,
                                                 boolean overdueOnly, String sortBy, String sortOrder,
                                                 int offset, int limit) {
        if (memberIds == null || memberIds.isEmpty()) return new ArrayList<>();

        List<Task> tasks = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT + " WHERE ta.user_id IN (");
        for (int i = 0; i < memberIds.size(); i++) {
            sql.append(i > 0 ? ",?" : "?");
        }
        sql.append(")");

        if (selectedEmployee != null) sql.append(" AND ta.user_id = ?");
        if (status != null && !status.isEmpty())    sql.append(" AND t.status = ?");
        if (priority != null && !priority.isEmpty()) sql.append(" AND t.priority = ?");
        if (keyword != null && !keyword.isEmpty())   sql.append(" AND (t.title LIKE ? OR t.description LIKE ?)");
        if (overdueOnly) sql.append(" AND t.due_date < GETDATE() AND t.status NOT IN (2,3)");

        if (sortBy != null && !sortBy.isEmpty()) {
            sql.append(" ORDER BY t.").append(sortBy);
            if ("DESC".equalsIgnoreCase(sortOrder)) sql.append(" DESC");
            else sql.append(" ASC");
        } else {
            sql.append(" ORDER BY t.due_date ASC");
        }
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Integer id : memberIds) st.setInt(idx++, id);
            if (selectedEmployee != null)              st.setInt(idx++, selectedEmployee);
            if (status != null && !status.isEmpty())   st.setInt(idx++, TaskStatus.valueOf(status).ordinal());
            if (priority != null && !priority.isEmpty()) st.setInt(idx++, Priority.valueOf(priority).ordinal());
            if (keyword != null && !keyword.isEmpty()) {
                String pat = "%" + keyword + "%";
                st.setString(idx++, pat);
                st.setString(idx++, pat);
            }
            st.setInt(idx++, offset);
            st.setInt(idx, limit);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) tasks.add(mapResultSetToTask(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }

    // Count team tasks with SQL-level filtering
    public int countTasksWithFilterForTeam(List<Integer> memberIds, Integer selectedEmployee,
                                            String status, String priority, String keyword,
                                            boolean overdueOnly) {
        if (memberIds == null || memberIds.isEmpty()) return 0;

        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) AS total FROM tasks t " +
            "LEFT JOIN task_assignees ta ON t.task_id = ta.task_id " +
            "WHERE ta.user_id IN (");
        for (int i = 0; i < memberIds.size(); i++) {
            sql.append(i > 0 ? ",?" : "?");
        }
        sql.append(")");

        if (selectedEmployee != null) sql.append(" AND ta.user_id = ?");
        if (status != null && !status.isEmpty())    sql.append(" AND t.status = ?");
        if (priority != null && !priority.isEmpty()) sql.append(" AND t.priority = ?");
        if (keyword != null && !keyword.isEmpty())   sql.append(" AND (t.title LIKE ? OR t.description LIKE ?)");
        if (overdueOnly) sql.append(" AND t.due_date < GETDATE() AND t.status NOT IN (2,3)");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Integer id : memberIds) st.setInt(idx++, id);
            if (selectedEmployee != null)              st.setInt(idx++, selectedEmployee);
            if (status != null && !status.isEmpty())   st.setInt(idx++, TaskStatus.valueOf(status).ordinal());
            if (priority != null && !priority.isEmpty()) st.setInt(idx++, Priority.valueOf(priority).ordinal());
            if (keyword != null && !keyword.isEmpty()) {
                String pat = "%" + keyword + "%";
                st.setString(idx++, pat);
                st.setString(idx++, pat);
            }
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Insert next recurring task instance when a recurring task is completed
    public boolean insertNextRecurringInstance(Task completedTask) {
        if (completedTask == null || completedTask.getTitle() == null) return false;

        String title = completedTask.getTitle();
        String pattern = null;
        if (title.startsWith("[R-DAILY]"))   pattern = "DAILY";
        else if (title.startsWith("[R-WEEKLY]"))  pattern = "WEEKLY";
        else if (title.startsWith("[R-MONTHLY]")) pattern = "MONTHLY";

        if (pattern == null || completedTask.getDueDate() == null) return false;

        LocalDateTime nextDue;
        switch (pattern) {
            case "DAILY":   nextDue = completedTask.getDueDate().plusDays(1);  break;
            case "WEEKLY":  nextDue = completedTask.getDueDate().plusWeeks(1); break;
            case "MONTHLY": nextDue = completedTask.getDueDate().plusMonths(1); break;
            default: return false;
        }

        Task next = new Task();
        next.setTitle(title);
        next.setDescription(completedTask.getDescription());
        next.setAssignedTo(completedTask.getAssignedTo());
        next.setPriority(completedTask.getPriority());
        next.setStatus(TaskStatus.PENDING.ordinal());
        next.setDueDate(nextDue);
        next.setReminderAt(nextDue.minusHours(24));
        next.setRelatedType(completedTask.getRelatedType());
        next.setRelatedId(completedTask.getRelatedId());
        next.setCreatedBy(completedTask.getCreatedBy());

        return insertTask(next);
    }

    // Get all dept tasks with SLA filter (for Manager "All Tasks" view)
    // Uses JOIN with task_assignees for assigned_to filtering
    public List<Task> getAllDeptTasks(List<Integer> allMemberIds, Integer selectedEmployee,
                                      String status, String priority, String keyword,
                                      boolean overdueOnly, String slaFilter,
                                      String sortBy, String sortOrder, int offset, int limit,
                                      boolean assignedOnly) {
        if (allMemberIds == null || allMemberIds.isEmpty()) return new ArrayList<>();

        List<Task> tasks = new ArrayList<>();
        StringBuilder inClause = new StringBuilder();
        for (int i = 0; i < allMemberIds.size(); i++) inClause.append(i > 0 ? ",?" : "?");

        StringBuilder sql = new StringBuilder(
            BASE_SELECT + " WHERE (ta.user_id IN (" + inClause + ")" +
            " OR t.created_by IN (" + inClause + "))");

        if (assignedOnly) sql.append(" AND ta.user_id IS NOT NULL");
        if (selectedEmployee != null)                sql.append(" AND (ta.user_id = ? OR t.created_by = ?)");
        if (status != null && !status.isEmpty())     sql.append(" AND t.status = ?");
        if (priority != null && !priority.isEmpty()) sql.append(" AND t.priority = ?");
        if (keyword != null && !keyword.isEmpty())   sql.append(" AND (t.title LIKE ? OR t.description LIKE ?)");
        if (overdueOnly) sql.append(" AND t.due_date < GETDATE() AND t.status NOT IN (2,3)");
        if ("BREACHED".equals(slaFilter)) {
            sql.append(" AND DATEDIFF(HOUR, t.created_at, ISNULL(t.completed_at, GETDATE())) >" +
                       " (CASE t.priority WHEN 2 THEN 24 WHEN 1 THEN 72 ELSE 120 END)");
        } else if ("OK".equals(slaFilter)) {
            sql.append(" AND DATEDIFF(HOUR, t.created_at, ISNULL(t.completed_at, GETDATE())) <=" +
                       " (CASE t.priority WHEN 2 THEN 24 WHEN 1 THEN 72 ELSE 120 END)");
        }

        if (sortBy != null && !sortBy.isEmpty()) {
            sql.append(" ORDER BY t.").append(sortBy);
            sql.append("DESC".equalsIgnoreCase(sortOrder) ? " DESC" : " ASC");
        } else {
            sql.append(" ORDER BY t.due_date ASC");
        }
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Integer id : allMemberIds) st.setInt(idx++, id); // ta.user_id IN
            for (Integer id : allMemberIds) st.setInt(idx++, id); // created_by IN
            if (selectedEmployee != null) {
                st.setInt(idx++, selectedEmployee); // ta.user_id = ?
                st.setInt(idx++, selectedEmployee); // created_by = ?
            }
            if (status != null && !status.isEmpty())   st.setInt(idx++, TaskStatus.valueOf(status).ordinal());
            if (priority != null && !priority.isEmpty()) st.setInt(idx++, Priority.valueOf(priority).ordinal());
            if (keyword != null && !keyword.isEmpty()) {
                String pat = "%" + keyword + "%";
                st.setString(idx++, pat); st.setString(idx++, pat);
            }
            st.setInt(idx++, offset);
            st.setInt(idx, limit);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) tasks.add(mapResultSetToTask(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return tasks;
    }

    // Count all dept tasks
    public int countAllDeptTasks(List<Integer> allMemberIds, Integer selectedEmployee,
                                  String status, String priority, String keyword,
                                  boolean overdueOnly, String slaFilter,
                                  boolean assignedOnly) {
        if (allMemberIds == null || allMemberIds.isEmpty()) return 0;

        StringBuilder inClause = new StringBuilder();
        for (int i = 0; i < allMemberIds.size(); i++) inClause.append(i > 0 ? ",?" : "?");

        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) AS total FROM tasks t " +
            "LEFT JOIN task_assignees ta ON t.task_id = ta.task_id " +
            "WHERE (ta.user_id IN (" + inClause + ")" +
            " OR t.created_by IN (" + inClause + "))");

        if (assignedOnly) sql.append(" AND ta.user_id IS NOT NULL");
        if (selectedEmployee != null)                sql.append(" AND (ta.user_id = ? OR t.created_by = ?)");
        if (status != null && !status.isEmpty())     sql.append(" AND t.status = ?");
        if (priority != null && !priority.isEmpty()) sql.append(" AND t.priority = ?");
        if (keyword != null && !keyword.isEmpty())   sql.append(" AND (t.title LIKE ? OR t.description LIKE ?)");
        if (overdueOnly) sql.append(" AND t.due_date < GETDATE() AND t.status NOT IN (2,3)");
        if ("BREACHED".equals(slaFilter)) {
            sql.append(" AND DATEDIFF(HOUR, t.created_at, ISNULL(t.completed_at, GETDATE())) >" +
                       " (CASE t.priority WHEN 2 THEN 24 WHEN 1 THEN 72 ELSE 120 END)");
        } else if ("OK".equals(slaFilter)) {
            sql.append(" AND DATEDIFF(HOUR, t.created_at, ISNULL(t.completed_at, GETDATE())) <=" +
                       " (CASE t.priority WHEN 2 THEN 24 WHEN 1 THEN 72 ELSE 120 END)");
        }

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Integer id : allMemberIds) st.setInt(idx++, id);
            for (Integer id : allMemberIds) st.setInt(idx++, id);
            if (selectedEmployee != null) {
                st.setInt(idx++, selectedEmployee);
                st.setInt(idx++, selectedEmployee);
            }
            if (status != null && !status.isEmpty())   st.setInt(idx++, TaskStatus.valueOf(status).ordinal());
            if (priority != null && !priority.isEmpty()) st.setInt(idx++, Priority.valueOf(priority).ordinal());
            if (keyword != null && !keyword.isEmpty()) {
                String pat = "%" + keyword + "%";
                st.setString(idx++, pat); st.setString(idx++, pat);
            }
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    // Get task assignment status summary for a batch of related objects
    // Uses task_relations to find tasks by related type/id
    public Map<Integer, String> getTaskSummaryMapByRelatedType(String relatedType, List<Integer> ids) {
        Map<Integer, String> result = new HashMap<>();
        if (ids == null || ids.isEmpty()) return result;

        StringBuilder sql = new StringBuilder(
            "SELECT tr.related_id," +
            " MAX(CASE WHEN t.status = 1 THEN 1 ELSE 0 END) AS has_in_progress," +
            " MAX(CASE WHEN t.status = 0 THEN 1 ELSE 0 END) AS has_pending," +
            " MAX(CASE WHEN t.status = 2 THEN 1 ELSE 0 END) AS has_completed" +
            " FROM tasks t" +
            " INNER JOIN task_relations tr ON t.task_id = tr.task_id" +
            " WHERE tr.related_type = ? AND tr.related_id IN (");
        for (int i = 0; i < ids.size(); i++) sql.append(i > 0 ? ",?" : "?");
        sql.append(") AND t.status != 3 GROUP BY tr.related_id");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            st.setString(idx++, relatedType);
            for (Integer id : ids) st.setInt(idx++, id);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    int relatedId = rs.getInt("related_id");
                    boolean hasInProgress = rs.getInt("has_in_progress") > 0;
                    boolean hasPending    = rs.getInt("has_pending")     > 0;
                    boolean hasCompleted  = rs.getInt("has_completed")   > 0;
                    String taskStatus;
                    if      (hasInProgress) taskStatus = "IN_PROGRESS";
                    else if (hasPending)    taskStatus = "PENDING";
                    else if (hasCompleted)  taskStatus = "COMPLETED";
                    else                    taskStatus = "NONE";
                    result.put(relatedId, taskStatus);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return result;
    }

    // Get subtasks by parent task ID (via task_relations with related_type='SUBTASK')
    public List<Task> getSubtasksByParentId(int parentTaskId) {
        List<Task> tasks = new ArrayList<>();
        String sql = BASE_SELECT +
            " INNER JOIN task_relations tr2 ON t.task_id = tr2.task_id" +
            " WHERE tr2.related_type = 'SUBTASK' AND tr2.related_id = ? ORDER BY t.created_at ASC";
        // Note: This query has 2 JOINs on task_relations (tr from BASE_SELECT and tr2 for subtask filter)
        // We need a different approach - use a custom query without BASE_SELECT
        String customSql =
            "SELECT t.*, ta.user_id AS assigned_to, tr_main.related_type, tr_main.related_id " +
            "FROM tasks t " +
            "LEFT JOIN task_assignees ta ON t.task_id = ta.task_id " +
            "LEFT JOIN task_relations tr_main ON t.task_id = tr_main.task_id AND tr_main.related_type != 'SUBTASK' " +
            "INNER JOIN task_relations tr_sub ON t.task_id = tr_sub.task_id " +
            "WHERE tr_sub.related_type = 'SUBTASK' AND tr_sub.related_id = ? " +
            "ORDER BY t.created_at ASC";
        try (PreparedStatement st = connection.prepareStatement(customSql)) {
            st.setInt(1, parentTaskId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) tasks.add(mapResultSetToTask(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return tasks;
    }

    // Count subtasks for a parent task
    public int countSubtasksByParentId(int parentTaskId) {
        String sql = "SELECT COUNT(*) AS total FROM task_relations WHERE related_type = 'SUBTASK' AND related_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, parentTaskId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    // Count completed subtasks
    public int countCompletedSubtasks(int parentTaskId) {
        String sql = "SELECT COUNT(*) AS total FROM tasks t " +
                     "INNER JOIN task_relations tr ON t.task_id = tr.task_id " +
                     "WHERE tr.related_type = 'SUBTASK' AND tr.related_id = ? AND t.status = 2";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, parentTaskId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    // Get tasks by a list of IDs (for resolving dependency task objects)
    public List<Task> getTasksByIds(List<Integer> taskIds) {
        if (taskIds == null || taskIds.isEmpty()) return new ArrayList<>();

        List<Task> tasks = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT + " WHERE t.task_id IN (");
        for (int i = 0; i < taskIds.size(); i++) sql.append(i > 0 ? ",?" : "?");
        sql.append(")");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < taskIds.size(); i++) st.setInt(i + 1, taskIds.get(i));
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) tasks.add(mapResultSetToTask(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return tasks;
    }

    // Get SLA statistics for a list of member IDs
    public Map<String, Integer> getSLAStatsByMemberIds(List<Integer> memberIds) {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("total", 0); stats.put("ok", 0); stats.put("warning", 0); stats.put("breached", 0);

        if (memberIds == null || memberIds.isEmpty()) return stats;

        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) AS total," +
            " SUM(CASE WHEN elapsed <= sla_hours THEN 1 ELSE 0 END) AS ok_count," +
            " SUM(CASE WHEN elapsed > sla_hours * 0.8 AND elapsed <= sla_hours THEN 1 ELSE 0 END) AS warning_count," +
            " SUM(CASE WHEN elapsed > sla_hours THEN 1 ELSE 0 END) AS breached_count" +
            " FROM (SELECT DATEDIFF(HOUR, t.created_at, ISNULL(t.completed_at, GETDATE())) AS elapsed," +
            " CASE t.priority WHEN 2 THEN 24 WHEN 1 THEN 72 ELSE 120 END AS sla_hours" +
            " FROM tasks t" +
            " INNER JOIN task_assignees ta ON t.task_id = ta.task_id" +
            " WHERE ta.user_id IN ("
        );
        for (int i = 0; i < memberIds.size(); i++) sql.append(i > 0 ? ",?" : "?");
        sql.append(") AND t.status != 3) sub");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < memberIds.size(); i++) st.setInt(i + 1, memberIds.get(i));
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    stats.put("total",   rs.getInt("total"));
                    stats.put("ok",      rs.getInt("ok_count"));
                    stats.put("warning", rs.getInt("warning_count"));
                    stats.put("breached",rs.getInt("breached_count"));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return stats;
    }

    // Get per-employee performance KPI statistics
    public Map<String, Object> getEmployeePerformanceStats(int userId) {
        Map<String, Object> stats = new HashMap<>();
        String sql =
            "SELECT COUNT(*) AS total_tasks," +
            " SUM(CASE WHEN t.status = 2 THEN 1 ELSE 0 END) AS completed_tasks," +
            " SUM(CASE WHEN t.status = 1 THEN 1 ELSE 0 END) AS in_progress_tasks," +
            " SUM(CASE WHEN t.status = 0 THEN 1 ELSE 0 END) AS pending_tasks," +
            " SUM(CASE WHEN t.status = 3 THEN 1 ELSE 0 END) AS cancelled_tasks," +
            " SUM(CASE WHEN t.due_date < GETDATE() AND t.status NOT IN (2,3) THEN 1 ELSE 0 END) AS overdue_tasks," +
            " AVG(CASE WHEN t.status=2 AND t.completed_at IS NOT NULL" +
            "     THEN CAST(DATEDIFF(HOUR, t.created_at, t.completed_at) AS FLOAT) ELSE NULL END) AS avg_completion_hours," +
            " SUM(CASE WHEN t.status=2 AND t.completed_at IS NOT NULL AND" +
            "     DATEDIFF(HOUR, t.created_at, t.completed_at) <=" +
            "     (CASE t.priority WHEN 2 THEN 24 WHEN 1 THEN 72 ELSE 120 END) THEN 1 ELSE 0 END) AS on_time_count," +
            " SUM(CASE WHEN t.status != 3 AND" +
            "     DATEDIFF(HOUR, t.created_at, ISNULL(t.completed_at, GETDATE())) >" +
            "     (CASE t.priority WHEN 2 THEN 24 WHEN 1 THEN 72 ELSE 120 END) THEN 1 ELSE 0 END) AS sla_breach_count" +
            " FROM tasks t" +
            " INNER JOIN task_assignees ta ON t.task_id = ta.task_id" +
            " WHERE ta.user_id = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    int total     = rs.getInt("total_tasks");
                    int completed = rs.getInt("completed_tasks");
                    int cancelled = rs.getInt("cancelled_tasks");
                    int onTime    = rs.getInt("on_time_count");
                    int breached  = rs.getInt("sla_breach_count");
                    double avgHours = rs.getDouble("avg_completion_hours");

                    int active = total - cancelled;
                    double completionRate = active > 0 ? (completed * 100.0 / active)  : 0;
                    double onTimeRate     = completed > 0 ? (onTime * 100.0 / completed) : 0;
                    double slaBreachRate  = active > 0 ? (breached * 100.0 / active)   : 0;
                    double productivityScore = (completionRate / 100.0 * 0.4
                                             + onTimeRate / 100.0 * 0.4
                                             + (1.0 - slaBreachRate / 100.0) * 0.2) * 100.0;

                    stats.put("totalTasks",        total);
                    stats.put("completedTasks",    completed);
                    stats.put("inProgressTasks",   rs.getInt("in_progress_tasks"));
                    stats.put("pendingTasks",      rs.getInt("pending_tasks"));
                    stats.put("cancelledTasks",    cancelled);
                    stats.put("overdueTasks",      rs.getInt("overdue_tasks"));
                    stats.put("onTimeCount",       onTime);
                    stats.put("slaBreachCount",    breached);
                    stats.put("avgCompletionHours", avgHours);
                    stats.put("completionRate",    completionRate);
                    stats.put("onTimeRate",        onTimeRate);
                    stats.put("slaBreachRate",     slaBreachRate);
                    stats.put("productivityScore", productivityScore);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return stats;
    }

    // Static helpers for dependency IDs stored in description as "[DEPS:1,2,3]" prefix

    public static List<Integer> parseDependencyIds(String description) {
        List<Integer> ids = new ArrayList<>();
        if (description == null || !description.startsWith("[DEPS:")) return ids;
        int end = description.indexOf(']');
        if (end < 0) return ids;
        String idsStr = description.substring(6, end);
        for (String s : idsStr.split(",")) {
            try { ids.add(Integer.parseInt(s.trim())); } catch (NumberFormatException ignored) {}
        }
        return ids;
    }

    public static String setDependencyIds(String description, List<Integer> depIds) {
        String cleaned = getCleanDescription(description);
        if (depIds == null || depIds.isEmpty()) return cleaned;
        StringBuilder sb = new StringBuilder("[DEPS:");
        for (int i = 0; i < depIds.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append(depIds.get(i));
        }
        sb.append("]\n");
        return sb.toString() + (cleaned != null ? cleaned : "");
    }

    public static String getCleanDescription(String description) {
        if (description == null) return "";
        if (!description.startsWith("[DEPS:")) return description;
        int newline = description.indexOf('\n');
        return newline >= 0 ? description.substring(newline + 1) : "";
    }

    // Update only the assigned_to (in task_assignees table)
    public boolean updateTaskAssignedTo(int taskId, int newAssigneeId) {
        // Check if assignee record exists
        String checkSql = "SELECT COUNT(*) FROM task_assignees WHERE task_id = ?";
        try (PreparedStatement st = connection.prepareStatement(checkSql)) {
            st.setInt(1, taskId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    String sql = "UPDATE task_assignees SET user_id = ?, assigned_at = ? WHERE task_id = ?";
                    try (PreparedStatement st2 = connection.prepareStatement(sql)) {
                        st2.setInt(1, newAssigneeId);
                        st2.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
                        st2.setInt(3, taskId);
                        return st2.executeUpdate() > 0;
                    }
                } else {
                    insertTaskAssignee(taskId, newAssigneeId, null);
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cancel a task (set status = CANCELLED)
    public boolean cancelTask(int taskId) {
        String sql = "UPDATE tasks SET status = 3, updated_at = ? WHERE task_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            st.setInt(2, taskId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get overdue tasks
    public List<Task> getOverdueTasks(Integer userId, List<Integer> teamMemberIds) {
        List<Task> tasks = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            BASE_SELECT + " WHERE t.due_date < GETDATE() " +
            "AND t.status != 2 AND t.status != 3"
        );

        if (userId != null) {
            sql.append(" AND ta.user_id = ?");
        } else if (teamMemberIds != null && !teamMemberIds.isEmpty()) {
            sql.append(" AND ta.user_id IN (");
            for (int i = 0; i < teamMemberIds.size(); i++) {
                sql.append("?");
                if (i < teamMemberIds.size() - 1) {
                    sql.append(",");
                }
            }
            sql.append(")");
        }

        sql.append(" ORDER BY t.due_date ASC");

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

    // ── Group task methods (using task_relations with related_type='GROUP') ──

    // Get group task summaries
    public List<Task> getGroupTaskSummaries(List<Integer> memberIds, Integer selectedEmployee,
                                             String status, String priority, String keyword,
                                             String sortBy, String sortOrder,
                                             int offset, int limit) {
        // Group tasks are no longer stored via group_task_id column
        // Return empty list - group task feature needs redesign for new schema
        return new ArrayList<>();
    }

    public int countGroupTaskSummaries(List<Integer> memberIds, Integer selectedEmployee,
                                        String status, String priority, String keyword) {
        return 0;
    }

    public List<Task> getGroupTaskMembers(int groupTaskId) {
        return new ArrayList<>();
    }

    public boolean updateGroupTaskId(int taskId, int groupTaskId) {
        // No longer applicable - group_task_id column removed from DB
        return false;
    }

    public boolean dissolveGroupMembership(int taskId) {
        // No longer applicable
        return false;
    }
}
