package dao;

import dbConnection.DBContext;
import enums.Priority;
import enums.TaskStatus;
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

    // ── Soft-delete filter applied to all queries ──
    private static final String NOT_DELETED = "(t.is_deleted = 0 OR t.is_deleted IS NULL)";

    // ── Base SELECT that brings in primary assignee + primary relation via OUTER APPLY ──
    private static final String BASE_SELECT =
        "SELECT t.*, " +
        "ta_p.user_id AS assigned_to, " +
        "tr_p.related_type, tr_p.related_id " +
        "FROM tasks t " +
        "OUTER APPLY (SELECT TOP 1 user_id FROM task_assignees WHERE task_id = t.task_id ORDER BY id ASC) ta_p " +
        "OUTER APPLY (SELECT TOP 1 related_type, related_id FROM task_relations WHERE task_id = t.task_id ORDER BY id ASC) tr_p ";

    // ── Map ResultSet → Task ──
    private Task mapResultSetToTask(ResultSet rs) throws SQLException {
        Task task = new Task();
        task.setTaskId(rs.getInt("task_id"));
        task.setTaskCode(rs.getString("task_code"));
        task.setTitle(rs.getString("title"));
        task.setDescription(rs.getString("description"));
        task.setPriority(rs.getObject("priority", Integer.class));
        task.setStatus(rs.getObject("status", Integer.class));

        Timestamp dueDate = rs.getTimestamp("due_date");
        if (dueDate != null) task.setDueDate(dueDate.toLocalDateTime());

        Timestamp reminderAt = rs.getTimestamp("reminder_at");
        if (reminderAt != null) task.setReminderAt(reminderAt.toLocalDateTime());

        Timestamp completedAt = rs.getTimestamp("completed_at");
        if (completedAt != null) task.setCompletedAt(completedAt.toLocalDateTime());

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) task.setCreatedAt(createdAt.toLocalDateTime());

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) task.setUpdatedAt(updatedAt.toLocalDateTime());

        task.setCreatedBy(rs.getObject("created_by", Integer.class));

        // is_deleted, deleted_at, deleted_by
        try {
            Object isDelObj = rs.getObject("is_deleted");
            if (isDelObj != null) task.setIsDeleted(rs.getBoolean("is_deleted"));
        } catch (SQLException ignored) {}
        try {
            Timestamp delAt = rs.getTimestamp("deleted_at");
            if (delAt != null) task.setDeletedAt(delAt.toLocalDateTime());
        } catch (SQLException ignored) {}
        try {
            task.setDeletedBy(rs.getObject("deleted_by", Integer.class));
        } catch (SQLException ignored) {}

        // Optional columns from OUTER APPLY (may not exist in plain queries)
        try { task.setAssignedTo(rs.getObject("assigned_to", Integer.class)); } catch (SQLException ignored) {}
        try { task.setRelatedType(rs.getString("related_type")); } catch (SQLException ignored) {}
        try {
            Object relId = rs.getObject("related_id");
            if (relId != null) task.setRelatedId(rs.getInt("related_id"));
        } catch (SQLException ignored) {}

        task.setGroupTaskId(null);

        return task;
    }

    // ── Generate unique task code ──
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

    // ── Insert new task + auto-insert assignee & relation ──
    public boolean insertTask(Task task) {
        String sql = "INSERT INTO tasks (task_code, title, description, priority, status, " +
                     "due_date, reminder_at, created_at, updated_at, created_by) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            if (task.getTaskCode() == null || task.getTaskCode().isEmpty()) {
                task.setTaskCode(generateTaskCode());
            }

            st.setString(1, task.getTaskCode());
            st.setString(2, task.getTitle());
            st.setString(3, task.getDescription());

            if (task.getPriority() != null) st.setInt(4, task.getPriority());
            else st.setNull(4, java.sql.Types.INTEGER);

            if (task.getStatus() != null) st.setInt(5, task.getStatus());
            else st.setInt(5, TaskStatus.PENDING.ordinal());

            if (task.getDueDate() != null) st.setTimestamp(6, Timestamp.valueOf(task.getDueDate()));
            else st.setNull(6, java.sql.Types.TIMESTAMP);

            if (task.getReminderAt() != null) st.setTimestamp(7, Timestamp.valueOf(task.getReminderAt()));
            else st.setNull(7, java.sql.Types.TIMESTAMP);

            st.setTimestamp(8, Timestamp.valueOf(LocalDateTime.now()));
            st.setTimestamp(9, Timestamp.valueOf(LocalDateTime.now()));

            if (task.getCreatedBy() != null) st.setInt(10, task.getCreatedBy());
            else st.setNull(10, java.sql.Types.INTEGER);

            int rowsAffected = st.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = st.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        task.setTaskId(generatedKeys.getInt(1));
                    }
                }

                // Auto-insert into task_assignees
                if (task.getAssignedTo() != null) {
                    TaskAssignee ta = new TaskAssignee();
                    ta.setTaskId(task.getTaskId());
                    ta.setUserId(task.getAssignedTo());
                    ta.setRole("ASSIGNEE");
                    ta.setTaskStatus(0);
                    ta.setProgress(0);
                    ta.setAssignedBy(task.getCreatedBy());
                    ta.setAssignedAt(LocalDateTime.now());
                    new TaskAssigneeDAO().insert(ta);
                }

                // Auto-insert into task_relations
                if (task.getRelatedType() != null && task.getRelatedId() != null) {
                    TaskRelation tr = new TaskRelation();
                    tr.setTaskId(task.getTaskId());
                    tr.setRelatedType(task.getRelatedType());
                    tr.setRelatedId(task.getRelatedId());
                    tr.setCreatedAt(LocalDateTime.now());
                    tr.setCreatedBy(task.getCreatedBy());
                    new TaskRelationDAO().insert(tr);
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

    // ── Update existing task + sync assignee & relation ──
    public boolean updateTask(Task task) {
        String sql = "UPDATE tasks SET title = ?, description = ?, " +
                     "due_date = ?, reminder_at = ?, priority = ?, status = ?, " +
                     "completed_at = ?, updated_at = ? WHERE task_id = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, task.getTitle());
            st.setString(2, task.getDescription());

            if (task.getDueDate() != null) st.setTimestamp(3, Timestamp.valueOf(task.getDueDate()));
            else st.setNull(3, java.sql.Types.TIMESTAMP);

            if (task.getReminderAt() != null) st.setTimestamp(4, Timestamp.valueOf(task.getReminderAt()));
            else st.setNull(4, java.sql.Types.TIMESTAMP);

            if (task.getPriority() != null) st.setInt(5, task.getPriority());
            else st.setNull(5, java.sql.Types.INTEGER);

            if (task.getStatus() != null) st.setInt(6, task.getStatus());
            else st.setNull(6, java.sql.Types.INTEGER);

            if (task.getCompletedAt() != null) st.setTimestamp(7, Timestamp.valueOf(task.getCompletedAt()));
            else st.setNull(7, java.sql.Types.TIMESTAMP);

            st.setTimestamp(8, Timestamp.valueOf(LocalDateTime.now()));
            st.setInt(9, task.getTaskId());

            boolean updated = st.executeUpdate() > 0;

            if (updated) {
                // Sync assignee
                if (task.getAssignedTo() != null) {
                    TaskAssigneeDAO taDao = new TaskAssigneeDAO();
                    TaskAssignee existing = taDao.getPrimaryAssignee(task.getTaskId());
                    if (existing != null) {
                        if (!task.getAssignedTo().equals(existing.getUserId())) {
                            taDao.updateAssignee(task.getTaskId(), task.getAssignedTo(),
                                    task.getCreatedBy() != null ? task.getCreatedBy() : 0);
                        }
                    } else {
                        TaskAssignee ta = new TaskAssignee();
                        ta.setTaskId(task.getTaskId());
                        ta.setUserId(task.getAssignedTo());
                        ta.setRole("ASSIGNEE");
                        ta.setTaskStatus(task.getStatus() != null ? task.getStatus() : 0);
                        ta.setProgress(0);
                        ta.setAssignedBy(task.getCreatedBy());
                        ta.setAssignedAt(LocalDateTime.now());
                        taDao.insert(ta);
                    }
                }

                // Sync relation
                if (task.getRelatedType() != null && task.getRelatedId() != null) {
                    TaskRelationDAO trDao = new TaskRelationDAO();
                    trDao.deleteByTaskId(task.getTaskId());
                    TaskRelation tr = new TaskRelation();
                    tr.setTaskId(task.getTaskId());
                    tr.setRelatedType(task.getRelatedType());
                    tr.setRelatedId(task.getRelatedId());
                    tr.setCreatedAt(LocalDateTime.now());
                    tr.setCreatedBy(task.getCreatedBy());
                    trDao.insert(tr);
                }
            }

            return updated;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ── Soft-delete task ──
    public boolean deleteTask(int taskId) {
        String sql = "UPDATE tasks SET is_deleted = 1, deleted_at = ?, updated_at = ? WHERE task_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            Timestamp now = Timestamp.valueOf(LocalDateTime.now());
            st.setTimestamp(1, now);
            st.setTimestamp(2, now);
            st.setInt(3, taskId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ── Soft-delete task with user tracking ──
    public boolean deleteTask(int taskId, int deletedBy) {
        String sql = "UPDATE tasks SET is_deleted = 1, deleted_at = ?, deleted_by = ?, updated_at = ? WHERE task_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            Timestamp now = Timestamp.valueOf(LocalDateTime.now());
            st.setTimestamp(1, now);
            st.setInt(2, deletedBy);
            st.setTimestamp(3, now);
            st.setInt(4, taskId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ── No-op (group_task_id column no longer exists) ──
    public boolean updateGroupTaskId(int taskId, int groupTaskId) {
        return true;
    }

    // ── Get task by ID ──
    public Task getTaskById(int taskId) {
        String sql = BASE_SELECT + "WHERE t.task_id = ? AND " + NOT_DELETED;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, taskId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return mapResultSetToTask(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ── Get tasks assigned to a specific user ──
    public List<Task> getTasksByUser(int userId) {
        List<Task> tasks = new ArrayList<>();
        String sql = BASE_SELECT +
            "WHERE EXISTS (SELECT 1 FROM task_assignees ta WHERE ta.task_id = t.task_id AND ta.user_id = ?) " +
            "AND " + NOT_DELETED + " ORDER BY t.due_date ASC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) tasks.add(mapResultSetToTask(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }

    // ── Get tasks created by a specific user ──
    public List<Task> getTasksByCreator(int creatorId) {
        List<Task> tasks = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE t.created_by = ? AND " + NOT_DELETED + " ORDER BY t.created_at DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, creatorId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) tasks.add(mapResultSetToTask(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }

    // ── Get tasks for team members ──
    public List<Task> getTasksByTeam(List<Integer> teamMemberIds) {
        if (teamMemberIds == null || teamMemberIds.isEmpty()) return new ArrayList<>();
        List<Task> tasks = new ArrayList<>();

        String sql = BASE_SELECT +
            "WHERE EXISTS (SELECT 1 FROM task_assignees ta WHERE ta.task_id = t.task_id AND ta.user_id IN (" +
            buildInClause(teamMemberIds.size()) + ")) AND " + NOT_DELETED + " ORDER BY t.due_date ASC";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            int idx = 1;
            for (Integer id : teamMemberIds) st.setInt(idx++, id);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) tasks.add(mapResultSetToTask(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }

    // ── Helper: build IN-clause placeholders ──
    private String buildInClause(int size) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < size; i++) sb.append(i > 0 ? ",?" : "?");
        return sb.toString();
    }

    // ── Helper: build EXISTS filter for assignee ──
    private String buildAssigneeExistsFilter(int memberCount) {
        return "EXISTS (SELECT 1 FROM task_assignees ta WHERE ta.task_id = t.task_id AND ta.user_id IN (" +
               buildInClause(memberCount) + "))";
    }

    // ── Get tasks with filters (pagination) ──
    public List<Task> getTasksWithFilter(Integer assignedTo, String status, String priority,
                                         String keyword, String sortBy, String sortOrder,
                                         int offset, int limit) {
        List<Task> tasks = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT + "WHERE " + NOT_DELETED);

        if (assignedTo != null) {
            sql.append(" AND EXISTS (SELECT 1 FROM task_assignees ta WHERE ta.task_id = t.task_id AND ta.user_id = ?)");
        }
        if (status != null && !status.isEmpty()) sql.append(" AND t.status = ?");
        if (priority != null && !priority.isEmpty()) sql.append(" AND t.priority = ?");
        if (keyword != null && !keyword.isEmpty()) sql.append(" AND (t.title LIKE ? OR t.description LIKE ?)");

        if (sortBy != null && !sortBy.isEmpty()) {
            sql.append(" ORDER BY t.").append(sortBy);
            if ("DESC".equalsIgnoreCase(sortOrder)) sql.append(" DESC"); else sql.append(" ASC");
        } else {
            sql.append(" ORDER BY t.due_date ASC");
        }
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (assignedTo != null) st.setInt(idx++, assignedTo);
            if (status != null && !status.isEmpty()) st.setInt(idx++, TaskStatus.valueOf(status).ordinal());
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }

    // ── Count tasks with filter ──
    public int countTasksWithFilter(Integer assignedTo, String status, String priority, String keyword) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) AS total FROM tasks t WHERE " + NOT_DELETED);

        if (assignedTo != null) {
            sql.append(" AND EXISTS (SELECT 1 FROM task_assignees ta WHERE ta.task_id = t.task_id AND ta.user_id = ?)");
        }
        if (status != null && !status.isEmpty()) sql.append(" AND t.status = ?");
        if (priority != null && !priority.isEmpty()) sql.append(" AND t.priority = ?");
        if (keyword != null && !keyword.isEmpty()) sql.append(" AND (t.title LIKE ? OR t.description LIKE ?)");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (assignedTo != null) st.setInt(idx++, assignedTo);
            if (status != null && !status.isEmpty()) st.setInt(idx++, TaskStatus.valueOf(status).ordinal());
            if (priority != null && !priority.isEmpty()) st.setInt(idx++, Priority.valueOf(priority).ordinal());
            if (keyword != null && !keyword.isEmpty()) {
                String pat = "%" + keyword + "%";
                st.setString(idx++, pat); st.setString(idx++, pat);
            }
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ── Get task statistics ──
    public Map<String, Object> getTaskStatistics(Integer userId, List<Integer> teamMemberIds) {
        Map<String, Object> stats = new HashMap<>();
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) AS total, " +
            "SUM(CASE WHEN t.status = 0 THEN 1 ELSE 0 END) AS pending, " +
            "SUM(CASE WHEN t.status = 1 THEN 1 ELSE 0 END) AS in_progress, " +
            "SUM(CASE WHEN t.status = 2 THEN 1 ELSE 0 END) AS completed, " +
            "SUM(CASE WHEN t.status = 3 THEN 1 ELSE 0 END) AS cancelled, " +
            "SUM(CASE WHEN t.due_date < GETDATE() AND t.status NOT IN (2,3) THEN 1 ELSE 0 END) AS overdue " +
            "FROM tasks t WHERE " + NOT_DELETED
        );

        if (userId != null) {
            sql.append(" AND EXISTS (SELECT 1 FROM task_assignees ta WHERE ta.task_id = t.task_id AND ta.user_id = ?)");
        } else if (teamMemberIds != null && !teamMemberIds.isEmpty()) {
            sql.append(" AND EXISTS (SELECT 1 FROM task_assignees ta WHERE ta.task_id = t.task_id AND ta.user_id IN (")
               .append(buildInClause(teamMemberIds.size())).append("))");
        }

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (userId != null) {
                st.setInt(idx++, userId);
            } else if (teamMemberIds != null && !teamMemberIds.isEmpty()) {
                for (Integer id : teamMemberIds) st.setInt(idx++, id);
            }
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    stats.put("total", rs.getInt("total"));
                    stats.put("pending", rs.getInt("pending"));
                    stats.put("in_progress", rs.getInt("in_progress"));
                    stats.put("completed", rs.getInt("completed"));
                    stats.put("cancelled", rs.getInt("cancelled"));
                    stats.put("overdue", rs.getInt("overdue"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    // ── Get tasks grouped by employee ──
    public Map<Integer, List<Task>> getTasksGroupedByEmployee(List<Integer> teamMemberIds) {
        Map<Integer, List<Task>> groupedTasks = new HashMap<>();
        if (teamMemberIds == null || teamMemberIds.isEmpty()) return groupedTasks;

        StringBuilder sql = new StringBuilder(
            "SELECT t.*, ta.user_id AS assigned_to, " +
            "tr_p.related_type, tr_p.related_id " +
            "FROM tasks t " +
            "INNER JOIN task_assignees ta ON ta.task_id = t.task_id " +
            "OUTER APPLY (SELECT TOP 1 related_type, related_id FROM task_relations WHERE task_id = t.task_id ORDER BY id ASC) tr_p " +
            "WHERE ta.user_id IN (" + buildInClause(teamMemberIds.size()) + ") " +
            "AND " + NOT_DELETED + " ORDER BY ta.user_id, t.due_date ASC"
        );

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Integer id : teamMemberIds) st.setInt(idx++, id);
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

    // ── Get tasks for calendar view ──
    public List<Task> getTasksForCalendar(int year, int month, Integer userId, List<Integer> teamMemberIds) {
        List<Task> tasks = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            BASE_SELECT + "WHERE YEAR(t.due_date) = ? AND MONTH(t.due_date) = ? AND " + NOT_DELETED
        );

        if (userId != null) {
            sql.append(" AND EXISTS (SELECT 1 FROM task_assignees ta WHERE ta.task_id = t.task_id AND ta.user_id = ?)");
        } else if (teamMemberIds != null && !teamMemberIds.isEmpty()) {
            sql.append(" AND EXISTS (SELECT 1 FROM task_assignees ta WHERE ta.task_id = t.task_id AND ta.user_id IN (")
               .append(buildInClause(teamMemberIds.size())).append("))");
        }
        sql.append(" ORDER BY t.due_date ASC");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            st.setInt(idx++, year);
            st.setInt(idx++, month);
            if (userId != null) {
                st.setInt(idx++, userId);
            } else if (teamMemberIds != null && !teamMemberIds.isEmpty()) {
                for (Integer id : teamMemberIds) st.setInt(idx++, id);
            }
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) tasks.add(mapResultSetToTask(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }

    // ── Get tasks within a date range ──
    public List<Task> getTasksByDateRange(List<Integer> memberIds,
            LocalDateTime startDate, LocalDateTime endDate,
            String statusFilter, String priorityFilter) {
        if (memberIds == null || memberIds.isEmpty()) return new ArrayList<>();
        List<Task> tasks = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
            BASE_SELECT + "WHERE EXISTS (SELECT 1 FROM task_assignees ta WHERE ta.task_id = t.task_id AND ta.user_id IN (" +
            buildInClause(memberIds.size()) + ")) AND t.due_date >= ? AND t.due_date < ? AND " + NOT_DELETED
        );

        if (statusFilter != null && !statusFilter.isEmpty()) sql.append(" AND t.status = ?");
        if (priorityFilter != null && !priorityFilter.isEmpty()) sql.append(" AND t.priority = ?");
        sql.append(" ORDER BY t.due_date ASC");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Integer id : memberIds) st.setInt(idx++, id);
            st.setTimestamp(idx++, Timestamp.valueOf(startDate));
            st.setTimestamp(idx++, Timestamp.valueOf(endDate));
            if (statusFilter != null && !statusFilter.isEmpty()) st.setString(idx++, statusFilter);
            if (priorityFilter != null && !priorityFilter.isEmpty()) st.setString(idx++, priorityFilter);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) tasks.add(mapResultSetToTask(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }

    // ── Get upcoming tasks with reminders ──
    public List<Task> getUpcomingTasksWithReminders(int userId, int hoursAhead) {
        List<Task> tasks = new ArrayList<>();
        String sql = BASE_SELECT +
            "WHERE EXISTS (SELECT 1 FROM task_assignees ta WHERE ta.task_id = t.task_id AND ta.user_id = ?) " +
            "AND t.status != 2 AND t.status != 3 " +
            "AND t.due_date BETWEEN GETDATE() AND DATEADD(HOUR, ?, GETDATE()) " +
            "AND " + NOT_DELETED + " ORDER BY t.due_date ASC";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            st.setInt(2, hoursAhead);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) tasks.add(mapResultSetToTask(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }

    // ── Get tasks by manager (individual tasks only: assignee count <= 1) ──
    public List<Task> getTasksByManager(int managerId, String status, String priority,
                                        String keyword, String sortBy, String sortOrder,
                                        int offset, int limit) {
        List<Task> tasks = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            BASE_SELECT + "WHERE t.created_by = ? " +
            "AND (SELECT COUNT(*) FROM task_assignees WHERE task_id = t.task_id) <= 1 " +
            "AND " + NOT_DELETED
        );

        if (status != null && !status.isEmpty()) sql.append(" AND t.status = ?");
        if (priority != null && !priority.isEmpty()) sql.append(" AND t.priority = ?");
        if (keyword != null && !keyword.isEmpty()) sql.append(" AND (t.title LIKE ? OR t.description LIKE ?)");

        if (sortBy != null && !sortBy.isEmpty()) {
            sql.append(" ORDER BY t.").append(sortBy);
            if ("DESC".equalsIgnoreCase(sortOrder)) sql.append(" DESC"); else sql.append(" ASC");
        } else {
            sql.append(" ORDER BY t.due_date ASC");
        }
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            st.setInt(idx++, managerId);
            if (status != null && !status.isEmpty()) st.setInt(idx++, TaskStatus.valueOf(status).ordinal());
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }

    // ── Count tasks by manager ──
    public int countTasksByManager(int managerId, String status, String priority, String keyword) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) AS total FROM tasks t WHERE t.created_by = ? " +
            "AND (SELECT COUNT(*) FROM task_assignees WHERE task_id = t.task_id) <= 1 " +
            "AND " + NOT_DELETED
        );

        if (status != null && !status.isEmpty()) sql.append(" AND t.status = ?");
        if (priority != null && !priority.isEmpty()) sql.append(" AND t.priority = ?");
        if (keyword != null && !keyword.isEmpty()) sql.append(" AND (t.title LIKE ? OR t.description LIKE ?)");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            st.setInt(idx++, managerId);
            if (status != null && !status.isEmpty()) st.setInt(idx++, TaskStatus.valueOf(status).ordinal());
            if (priority != null && !priority.isEmpty()) st.setInt(idx++, Priority.valueOf(priority).ordinal());
            if (keyword != null && !keyword.isEmpty()) {
                String pat = "%" + keyword + "%";
                st.setString(idx++, pat); st.setString(idx++, pat);
            }
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ── Get team tasks with filtering and pagination (individual tasks only) ──
    public List<Task> getTasksWithFilterForTeam(List<Integer> memberIds, Integer selectedEmployee,
                                                 String status, String priority, String keyword,
                                                 boolean overdueOnly, String sortBy, String sortOrder,
                                                 int offset, int limit) {
        if (memberIds == null || memberIds.isEmpty()) return new ArrayList<>();

        List<Task> tasks = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            BASE_SELECT + "WHERE " + buildAssigneeExistsFilter(memberIds.size()) +
            " AND (SELECT COUNT(*) FROM task_assignees WHERE task_id = t.task_id) <= 1" +
            " AND " + NOT_DELETED
        );

        if (selectedEmployee != null) {
            sql.append(" AND EXISTS (SELECT 1 FROM task_assignees ta2 WHERE ta2.task_id = t.task_id AND ta2.user_id = ?)");
        }
        if (status != null && !status.isEmpty()) sql.append(" AND t.status = ?");
        if (priority != null && !priority.isEmpty()) sql.append(" AND t.priority = ?");
        if (keyword != null && !keyword.isEmpty()) sql.append(" AND (t.title LIKE ? OR t.description LIKE ?)");
        if (overdueOnly) sql.append(" AND t.due_date < GETDATE() AND t.status NOT IN (2,3)");

        if (sortBy != null && !sortBy.isEmpty()) {
            sql.append(" ORDER BY t.").append(sortBy);
            if ("DESC".equalsIgnoreCase(sortOrder)) sql.append(" DESC"); else sql.append(" ASC");
        } else {
            sql.append(" ORDER BY t.due_date ASC");
        }
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Integer id : memberIds) st.setInt(idx++, id);
            if (selectedEmployee != null) st.setInt(idx++, selectedEmployee);
            if (status != null && !status.isEmpty()) st.setInt(idx++, TaskStatus.valueOf(status).ordinal());
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }

    // ── Count team tasks ──
    public int countTasksWithFilterForTeam(List<Integer> memberIds, Integer selectedEmployee,
                                            String status, String priority, String keyword,
                                            boolean overdueOnly) {
        if (memberIds == null || memberIds.isEmpty()) return 0;

        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) AS total FROM tasks t WHERE " + buildAssigneeExistsFilter(memberIds.size()) +
            " AND (SELECT COUNT(*) FROM task_assignees WHERE task_id = t.task_id) <= 1" +
            " AND " + NOT_DELETED
        );

        if (selectedEmployee != null) {
            sql.append(" AND EXISTS (SELECT 1 FROM task_assignees ta2 WHERE ta2.task_id = t.task_id AND ta2.user_id = ?)");
        }
        if (status != null && !status.isEmpty()) sql.append(" AND t.status = ?");
        if (priority != null && !priority.isEmpty()) sql.append(" AND t.priority = ?");
        if (keyword != null && !keyword.isEmpty()) sql.append(" AND (t.title LIKE ? OR t.description LIKE ?)");
        if (overdueOnly) sql.append(" AND t.due_date < GETDATE() AND t.status NOT IN (2,3)");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Integer id : memberIds) st.setInt(idx++, id);
            if (selectedEmployee != null) st.setInt(idx++, selectedEmployee);
            if (status != null && !status.isEmpty()) st.setInt(idx++, TaskStatus.valueOf(status).ordinal());
            if (priority != null && !priority.isEmpty()) st.setInt(idx++, Priority.valueOf(priority).ordinal());
            if (keyword != null && !keyword.isEmpty()) {
                String pat = "%" + keyword + "%";
                st.setString(idx++, pat); st.setString(idx++, pat);
            }
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ── Insert next recurring task instance ──
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

    // ── Get all dept tasks with SLA filter ──
    public List<Task> getAllDeptTasks(List<Integer> allMemberIds, Integer selectedEmployee,
                                      String status, String priority, String keyword,
                                      boolean overdueOnly, String slaFilter,
                                      String sortBy, String sortOrder, int offset, int limit,
                                      boolean assignedOnly) {
        if (allMemberIds == null || allMemberIds.isEmpty()) return new ArrayList<>();

        List<Task> tasks = new ArrayList<>();
        String inClause = buildInClause(allMemberIds.size());

        StringBuilder sql = new StringBuilder(
            BASE_SELECT + "WHERE (" +
            "EXISTS (SELECT 1 FROM task_assignees ta WHERE ta.task_id = t.task_id AND ta.user_id IN (" + inClause + "))" +
            " OR t.created_by IN (" + inClause + ")) AND " + NOT_DELETED
        );

        if (assignedOnly) sql.append(" AND EXISTS (SELECT 1 FROM task_assignees WHERE task_id = t.task_id)");
        if (selectedEmployee != null) {
            sql.append(" AND (EXISTS (SELECT 1 FROM task_assignees ta3 WHERE ta3.task_id = t.task_id AND ta3.user_id = ?) OR t.created_by = ?)");
        }
        if (status != null && !status.isEmpty()) sql.append(" AND t.status = ?");
        if (priority != null && !priority.isEmpty()) sql.append(" AND t.priority = ?");
        if (keyword != null && !keyword.isEmpty()) sql.append(" AND (t.title LIKE ? OR t.description LIKE ?)");
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
            for (Integer id : allMemberIds) st.setInt(idx++, id); // assignees IN
            for (Integer id : allMemberIds) st.setInt(idx++, id); // created_by IN
            if (selectedEmployee != null) {
                st.setInt(idx++, selectedEmployee);
                st.setInt(idx++, selectedEmployee);
            }
            if (status != null && !status.isEmpty()) st.setInt(idx++, TaskStatus.valueOf(status).ordinal());
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }

    // ── Count all dept tasks ──
    public int countAllDeptTasks(List<Integer> allMemberIds, Integer selectedEmployee,
                                  String status, String priority, String keyword,
                                  boolean overdueOnly, String slaFilter,
                                  boolean assignedOnly) {
        if (allMemberIds == null || allMemberIds.isEmpty()) return 0;

        String inClause = buildInClause(allMemberIds.size());
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) AS total FROM tasks t WHERE (" +
            "EXISTS (SELECT 1 FROM task_assignees ta WHERE ta.task_id = t.task_id AND ta.user_id IN (" + inClause + "))" +
            " OR t.created_by IN (" + inClause + ")) AND " + NOT_DELETED
        );

        if (assignedOnly) sql.append(" AND EXISTS (SELECT 1 FROM task_assignees WHERE task_id = t.task_id)");
        if (selectedEmployee != null) {
            sql.append(" AND (EXISTS (SELECT 1 FROM task_assignees ta3 WHERE ta3.task_id = t.task_id AND ta3.user_id = ?) OR t.created_by = ?)");
        }
        if (status != null && !status.isEmpty()) sql.append(" AND t.status = ?");
        if (priority != null && !priority.isEmpty()) sql.append(" AND t.priority = ?");
        if (keyword != null && !keyword.isEmpty()) sql.append(" AND (t.title LIKE ? OR t.description LIKE ?)");
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
            if (status != null && !status.isEmpty()) st.setInt(idx++, TaskStatus.valueOf(status).ordinal());
            if (priority != null && !priority.isEmpty()) st.setInt(idx++, Priority.valueOf(priority).ordinal());
            if (keyword != null && !keyword.isEmpty()) {
                String pat = "%" + keyword + "%";
                st.setString(idx++, pat); st.setString(idx++, pat);
            }
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ── Task summary by related type (uses task_relations JOIN) ──
    public Map<Integer, String> getTaskSummaryMapByRelatedType(String relatedType, List<Integer> ids) {
        Map<Integer, String> result = new HashMap<>();
        if (ids == null || ids.isEmpty()) return result;

        StringBuilder sql = new StringBuilder(
            "SELECT tr.related_id," +
            " MAX(CASE WHEN t.status = 1 THEN 1 ELSE 0 END) AS has_in_progress," +
            " MAX(CASE WHEN t.status = 0 THEN 1 ELSE 0 END) AS has_pending," +
            " MAX(CASE WHEN t.status = 2 THEN 1 ELSE 0 END) AS has_completed" +
            " FROM tasks t" +
            " INNER JOIN task_relations tr ON tr.task_id = t.task_id" +
            " WHERE tr.related_type = ? AND tr.related_id IN (" +
            buildInClause(ids.size()) +
            ") AND t.status != 3 AND " + NOT_DELETED + " GROUP BY tr.related_id"
        );

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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    // ── Get subtasks by parent task ID (via task_relations SUBTASK) ──
    public List<Task> getSubtasksByParentId(int parentTaskId) {
        List<Task> tasks = new ArrayList<>();
        String sql = BASE_SELECT +
            "INNER JOIN task_relations tr_sub ON tr_sub.task_id = t.task_id " +
            "AND tr_sub.related_type = 'SUBTASK' AND tr_sub.related_id = ? " +
            "WHERE " + NOT_DELETED + " ORDER BY t.created_at ASC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, parentTaskId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) tasks.add(mapResultSetToTask(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }

    // ── Count subtasks ──
    public int countSubtasksByParentId(int parentTaskId) {
        String sql = "SELECT COUNT(*) AS total FROM tasks t " +
            "INNER JOIN task_relations tr ON tr.task_id = t.task_id " +
            "WHERE tr.related_type = 'SUBTASK' AND tr.related_id = ? AND " + NOT_DELETED;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, parentTaskId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ── Count completed subtasks ──
    public int countCompletedSubtasks(int parentTaskId) {
        String sql = "SELECT COUNT(*) AS total FROM tasks t " +
            "INNER JOIN task_relations tr ON tr.task_id = t.task_id " +
            "WHERE tr.related_type = 'SUBTASK' AND tr.related_id = ? AND t.status = 2 AND " + NOT_DELETED;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, parentTaskId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ── Get tasks by a list of IDs ──
    public List<Task> getTasksByIds(List<Integer> taskIds) {
        if (taskIds == null || taskIds.isEmpty()) return new ArrayList<>();
        List<Task> tasks = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE t.task_id IN (" + buildInClause(taskIds.size()) + ") AND " + NOT_DELETED;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            for (int i = 0; i < taskIds.size(); i++) st.setInt(i + 1, taskIds.get(i));
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) tasks.add(mapResultSetToTask(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }

    // ── SLA statistics ──
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
            " FROM tasks t WHERE EXISTS (SELECT 1 FROM task_assignees ta WHERE ta.task_id = t.task_id AND ta.user_id IN (" +
            buildInClause(memberIds.size()) +
            ")) AND t.status != 3 AND " + NOT_DELETED + ") sub"
        );

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < memberIds.size(); i++) st.setInt(i + 1, memberIds.get(i));
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    stats.put("total",    rs.getInt("total"));
                    stats.put("ok",       rs.getInt("ok_count"));
                    stats.put("warning",  rs.getInt("warning_count"));
                    stats.put("breached", rs.getInt("breached_count"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    // ── Employee performance KPI statistics ──
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
            " WHERE EXISTS (SELECT 1 FROM task_assignees ta WHERE ta.task_id = t.task_id AND ta.user_id = ?)" +
            " AND " + NOT_DELETED;

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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    // ── Static helpers for dependency IDs in description "[DEPS:1,2,3]" ──

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

    // ── Group task methods ──
    // New concept: group task = 1 task row with multiple assignees in task_assignees.

    /** Tasks that have more than 1 assignee (group tasks). */
    public List<Task> getGroupTaskSummaries(List<Integer> memberIds, Integer selectedEmployee,
                                             String status, String priority, String keyword,
                                             String sortBy, String sortOrder,
                                             int offset, int limit) {
        if (memberIds == null || memberIds.isEmpty()) return new ArrayList<>();

        List<Task> tasks = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            BASE_SELECT + "WHERE " + buildAssigneeExistsFilter(memberIds.size()) +
            " AND (SELECT COUNT(*) FROM task_assignees WHERE task_id = t.task_id) > 1" +
            " AND " + NOT_DELETED
        );

        if (selectedEmployee != null) {
            sql.append(" AND EXISTS (SELECT 1 FROM task_assignees ta2 WHERE ta2.task_id = t.task_id AND ta2.user_id = ?)");
        }
        if (status != null && !status.isEmpty()) sql.append(" AND t.status = ?");
        if (priority != null && !priority.isEmpty()) sql.append(" AND t.priority = ?");
        if (keyword != null && !keyword.isEmpty()) sql.append(" AND (t.title LIKE ? OR t.description LIKE ?)");

        if (sortBy != null && !sortBy.isEmpty()) {
            sql.append(" ORDER BY t.").append(sortBy);
            if ("DESC".equalsIgnoreCase(sortOrder)) sql.append(" DESC"); else sql.append(" ASC");
        } else {
            sql.append(" ORDER BY t.due_date ASC");
        }
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Integer id : memberIds) st.setInt(idx++, id);
            if (selectedEmployee != null) st.setInt(idx++, selectedEmployee);
            if (status != null && !status.isEmpty()) st.setInt(idx++, TaskStatus.valueOf(status).ordinal());
            if (priority != null && !priority.isEmpty()) st.setInt(idx++, Priority.valueOf(priority).ordinal());
            if (keyword != null && !keyword.isEmpty()) {
                String pat = "%" + keyword + "%";
                st.setString(idx++, pat); st.setString(idx++, pat);
            }
            st.setInt(idx++, offset);
            st.setInt(idx, limit);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Task task = mapResultSetToTask(rs);
                    task.setGroupTaskId(task.getTaskId());
                    tasks.add(task);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }

    /** Count group task summaries. */
    public int countGroupTaskSummaries(List<Integer> memberIds, Integer selectedEmployee,
                                        String status, String priority, String keyword) {
        if (memberIds == null || memberIds.isEmpty()) return 0;

        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) AS total FROM tasks t WHERE " + buildAssigneeExistsFilter(memberIds.size()) +
            " AND (SELECT COUNT(*) FROM task_assignees WHERE task_id = t.task_id) > 1" +
            " AND " + NOT_DELETED
        );

        if (selectedEmployee != null) {
            sql.append(" AND EXISTS (SELECT 1 FROM task_assignees ta2 WHERE ta2.task_id = t.task_id AND ta2.user_id = ?)");
        }
        if (status != null && !status.isEmpty()) sql.append(" AND t.status = ?");
        if (priority != null && !priority.isEmpty()) sql.append(" AND t.priority = ?");
        if (keyword != null && !keyword.isEmpty()) sql.append(" AND (t.title LIKE ? OR t.description LIKE ?)");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Integer id : memberIds) st.setInt(idx++, id);
            if (selectedEmployee != null) st.setInt(idx++, selectedEmployee);
            if (status != null && !status.isEmpty()) st.setInt(idx++, TaskStatus.valueOf(status).ordinal());
            if (priority != null && !priority.isEmpty()) st.setInt(idx++, Priority.valueOf(priority).ordinal());
            if (keyword != null && !keyword.isEmpty()) {
                String pat = "%" + keyword + "%";
                st.setString(idx++, pat); st.setString(idx++, pat);
            }
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Returns "member" views for a group task.
     * 1 task + N assignees → returns task N times with different assignedTo.
     */
    public List<Task> getGroupTaskMembers(int groupTaskId) {
        List<Task> tasks = new ArrayList<>();
        Task baseTask = getTaskById(groupTaskId);
        if (baseTask == null) return tasks;

        List<TaskAssignee> assignees = new TaskAssigneeDAO().getByTaskId(groupTaskId);
        for (TaskAssignee a : assignees) {
            Task memberView = new Task();
            memberView.setTaskId(baseTask.getTaskId());
            memberView.setTaskCode(baseTask.getTaskCode());
            memberView.setTitle(baseTask.getTitle());
            memberView.setDescription(baseTask.getDescription());
            memberView.setPriority(baseTask.getPriority());
            memberView.setStatus(a.getTaskStatus() != null ? a.getTaskStatus() : baseTask.getStatus());
            memberView.setRelatedType(baseTask.getRelatedType());
            memberView.setRelatedId(baseTask.getRelatedId());
            memberView.setAssignedTo(a.getUserId());
            memberView.setGroupTaskId(baseTask.getTaskId());
            memberView.setDueDate(baseTask.getDueDate());
            memberView.setReminderAt(baseTask.getReminderAt());
            memberView.setCompletedAt(baseTask.getCompletedAt());
            memberView.setCreatedAt(baseTask.getCreatedAt());
            memberView.setUpdatedAt(baseTask.getUpdatedAt());
            memberView.setCreatedBy(baseTask.getCreatedBy());
            tasks.add(memberView);
        }
        return tasks;
    }

    // ── Update assigned_to → updates task_assignees ──
    public boolean updateTaskAssignedTo(int taskId, int newAssigneeId) {
        TaskAssigneeDAO taDao = new TaskAssigneeDAO();
        TaskAssignee existing = taDao.getPrimaryAssignee(taskId);
        if (existing != null) {
            return taDao.updateAssignee(taskId, newAssigneeId, 0);
        } else {
            TaskAssignee ta = new TaskAssignee();
            ta.setTaskId(taskId);
            ta.setUserId(newAssigneeId);
            ta.setRole("ASSIGNEE");
            ta.setTaskStatus(0);
            ta.setProgress(0);
            ta.setAssignedAt(LocalDateTime.now());
            return taDao.insert(ta);
        }
    }

    // ── Cancel a task ──
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

    // ── Dissolve group membership ──
    public boolean dissolveGroupMembership(int taskId) {
        TaskAssigneeDAO taDao = new TaskAssigneeDAO();
        TaskAssignee primary = taDao.getPrimaryAssignee(taskId);
        if (primary == null) return false;
        taDao.deleteByTaskId(taskId);
        return taDao.insert(primary);
    }

    // ── Get overdue tasks ──
    public List<Task> getOverdueTasks(Integer userId, List<Integer> teamMemberIds) {
        List<Task> tasks = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            BASE_SELECT + "WHERE t.due_date < GETDATE() AND t.status != 2 AND t.status != 3 AND " + NOT_DELETED
        );

        if (userId != null) {
            sql.append(" AND EXISTS (SELECT 1 FROM task_assignees ta WHERE ta.task_id = t.task_id AND ta.user_id = ?)");
        } else if (teamMemberIds != null && !teamMemberIds.isEmpty()) {
            sql.append(" AND EXISTS (SELECT 1 FROM task_assignees ta WHERE ta.task_id = t.task_id AND ta.user_id IN (")
               .append(buildInClause(teamMemberIds.size())).append("))");
        }
        sql.append(" ORDER BY t.due_date ASC");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (userId != null) {
                st.setInt(idx++, userId);
            } else if (teamMemberIds != null && !teamMemberIds.isEmpty()) {
                for (Integer id : teamMemberIds) st.setInt(idx++, id);
            }
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) tasks.add(mapResultSetToTask(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }

    // ── Check if a related object already has an active task ──
    public boolean hasActiveTaskForRelated(String relatedType, int relatedId) {
        String sql = "SELECT COUNT(*) AS cnt FROM tasks t " +
            "INNER JOIN task_relations tr ON tr.task_id = t.task_id " +
            "WHERE tr.related_type = ? AND tr.related_id = ? " +
            "AND t.status NOT IN (2, 3) AND " + NOT_DELETED;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, relatedType);
            st.setInt(2, relatedId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt("cnt") > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
