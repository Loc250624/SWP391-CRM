# Task Management Module for Manager - Implementation Documentation

## Overview
This document provides a comprehensive guide to the Task Management module implemented for the Manager role in the CRM system. The implementation strictly follows the existing database structure, model classes, enum values, and relationships without modifying any existing code.

## Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [Database Structure](#database-structure)
3. [Components Implemented](#components-implemented)
4. [Features](#features)
5. [Validation Logic](#validation-logic)
6. [Role Checking](#role-checking)
7. [Pagination](#pagination)
8. [Statistics and Reports](#statistics-and-reports)
9. [Recurring Tasks](#recurring-tasks)
10. [SQL Queries Reference](#sql-queries-reference)
11. [Flow Diagrams](#flow-diagrams)

---

## Architecture Overview

The implementation follows strict MVC (Model-View-Controller) architecture:

```
┌─────────────────────────────────────────────────────────┐
│                         VIEW LAYER                       │
│  /web/view/manager/task/*.jsp                           │
│  - task-list.jsp (List & Filter)                        │
│  - task-create.jsp (Create/Edit Form)                   │
│  - task-detail.jsp (Detail View)                        │
│  - task-calendar.jsp (Calendar View)                    │
│  - task-report.jsp (Statistics & Reports)               │
└─────────────────────────────────────────────────────────┘
                          ↕
┌─────────────────────────────────────────────────────────┐
│                    CONTROLLER LAYER                      │
│  /src/java/controller/manager/*.java                    │
│  - ManagerTaskListServlet                               │
│  - ManagerTaskFormServlet                               │
│  - ManagerTaskDetailServlet                             │
│  - ManagerTaskDeleteServlet                             │
│  - ManagerTaskCalendarServlet                           │
│  - ManagerTaskReportServlet                             │
└─────────────────────────────────────────────────────────┘
                          ↕
┌─────────────────────────────────────────────────────────┐
│                       DAO LAYER                          │
│  /src/java/dao/TaskDAO.java                             │
│  - insertTask()                                          │
│  - updateTask()                                          │
│  - deleteTask()                                          │
│  - getTaskById()                                         │
│  - getTasksByUser()                                      │
│  - getTasksByTeam()                                      │
│  - getTasksWithFilter()                                  │
│  - getTaskStatistics()                                   │
│  - getTasksGroupedByEmployee()                          │
│  - getTasksForCalendar()                                 │
│  - getUpcomingTasksWithReminders()                      │
│  - getOverdueTasks()                                     │
└─────────────────────────────────────────────────────────┘
                          ↕
┌─────────────────────────────────────────────────────────┐
│                      MODEL LAYER                         │
│  /src/java/model/Task.java (EXISTING - NOT MODIFIED)   │
│  Fields: taskId, taskCode, title, description,          │
│          relatedType, relatedId, assignedTo, dueDate,  │
│          reminderAt, priority, status, completedAt,     │
│          createdAt, updatedAt, createdBy                │
└─────────────────────────────────────────────────────────┘
                          ↕
┌─────────────────────────────────────────────────────────┐
│                      DATABASE LAYER                      │
│  SQL Server Database - tasks table                      │
└─────────────────────────────────────────────────────────┘
```

---

## Database Structure

### Tasks Table Schema (Existing - Not Modified)

```sql
CREATE TABLE tasks (
    task_id INT PRIMARY KEY IDENTITY(1,1),
    task_code NVARCHAR(50) NOT NULL UNIQUE,
    title NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    related_type NVARCHAR(50),
    related_id INT,
    assigned_to INT,
    due_date DATETIME,
    reminder_at DATETIME,
    priority NVARCHAR(20),
    status NVARCHAR(20),
    completed_at DATETIME,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    created_by INT,

    FOREIGN KEY (assigned_to) REFERENCES users(user_id),
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);
```

### Field Descriptions

- **task_id**: Primary key, auto-increment
- **task_code**: Unique code (format: TSK-000001, TSK-000002, ...)
- **title**: Task title (required, max 255 chars)
- **description**: Detailed description (optional, unlimited length)
- **related_type**: Type of related object (Lead, Customer, Opportunity)
- **related_id**: ID of related object (foreign key reference)
- **assigned_to**: User ID of assignee (foreign key to users table)
- **due_date**: Deadline for task completion
- **reminder_at**: Reminder datetime (auto-set to 24 hours before due_date)
- **priority**: LOW, MEDIUM, HIGH (from Priority enum)
- **status**: PENDING, IN_PROGRESS, COMPLETED, CANCELLED (from TaskStatus enum)
- **completed_at**: Timestamp when task was completed (auto-set when status = COMPLETED)
- **created_at**: Auto-generated creation timestamp
- **updated_at**: Auto-generated update timestamp
- **created_by**: User ID of creator (foreign key to users table)

---

## Components Implemented

### 1. DAO Layer - TaskDAO.java

#### Methods Added (No Existing Methods Modified):

**Basic CRUD Operations:**
- `String generateTaskCode()` - Generates unique task code (TSK-XXXXXX format)
- `boolean insertTask(Task task)` - Insert new task
- `boolean updateTask(Task task)` - Update existing task
- `boolean deleteTask(int taskId)` - Hard delete task
- `Task getTaskById(int taskId)` - Get task by ID

**Query Methods:**
- `List<Task> getTasksByUser(int userId)` - Personal tasks for a user
- `List<Task> getTasksByCreator(int creatorId)` - Tasks created by a user
- `List<Task> getTasksByTeam(List<Integer> teamMemberIds)` - Team tasks

**Advanced Filtering:**
- `List<Task> getTasksWithFilter(Integer assignedTo, String status, String priority, String keyword, String sortBy, String sortOrder, int offset, int limit)` - Complex filtering with pagination
- `int countTasksWithFilter(...)` - Count for pagination

**Statistics & Reports:**
- `Map<String, Object> getTaskStatistics(Integer userId, List<Integer> teamMemberIds)` - Overall statistics
- `Map<Integer, List<Task>> getTasksGroupedByEmployee(List<Integer> teamMemberIds)` - Group by employee

**Calendar & Reminders:**
- `List<Task> getTasksForCalendar(int year, int month, Integer userId, List<Integer> teamMemberIds)` - Calendar view
- `List<Task> getUpcomingTasksWithReminders(int userId, int hoursAhead)` - Upcoming tasks
- `List<Task> getOverdueTasks(Integer userId, List<Integer> teamMemberIds)` - Overdue tasks

### 2. Controller Layer

#### ManagerTaskListServlet
- **URL Pattern**: `/manager/task/list`
- **Functions**:
  - Display personal tasks (assigned to current manager)
  - Display team tasks (assigned to team members in same department)
  - Filter by status, priority, employee, keyword
  - Pagination support
  - Sorting (by due date, priority, created date)

#### ManagerTaskFormServlet
- **URL Pattern**: `/manager/task/form`
- **Functions**:
  - Create new task (GET: show form, POST: process creation)
  - Edit existing task (GET: show form with data, POST: process update)
  - Validation of all input fields
  - Dynamic loading of related objects (Lead, Customer, Opportunity)

#### ManagerTaskDetailServlet
- **URL Pattern**: `/manager/task/detail`
- **Functions**:
  - Display full task details
  - Show assigned user info
  - Show creator info
  - Show related object info (with links)

#### ManagerTaskDeleteServlet
- **URL Pattern**: `/manager/task/delete`
- **Functions**:
  - Delete task (hard delete)
  - Confirmation before deletion

#### ManagerTaskCalendarServlet
- **URL Pattern**: `/manager/task/calendar`
- **Functions**:
  - Monthly calendar view
  - Personal calendar / Team calendar
  - Tasks grouped by due date
  - Month navigation

#### ManagerTaskReportServlet
- **URL Pattern**: `/manager/task/report`
- **Functions**:
  - Overall statistics
  - Employee performance metrics
  - Overdue tasks list
  - Completion rate visualization

### 3. View Layer

#### task-list.jsp
- Task list with filters
- Personal/Team view tabs
- Pagination controls
- Sort options
- Status and priority badges
- Color-coded priorities

#### task-create.jsp
- Create/Edit form
- Form validation (client & server side)
- Dynamic related object dropdown
- Date picker with min date validation
- Help sidebar

#### task-detail.jsp
- Full task information
- User avatar displays
- Related object links
- Edit/Delete actions
- Status badges

#### task-calendar.jsp
- Monthly calendar grid
- Task tooltips on hover
- Color-coded by priority
- View toggle (personal/team)
- Month navigation

#### task-report.jsp
- Statistics cards
- Progress bars
- Employee performance table
- Overdue tasks list
- Completion rate charts

---

## Features

### 1. Create Task
**Flow:**
1. Manager clicks "Tạo Công việc" button
2. System displays create form
3. Manager fills required fields:
   - Title (required)
   - Assigned employee (required)
   - Due date (required, must be future date)
   - Priority (required, default: MEDIUM)
   - Status (required, default: PENDING)
   - Description (optional)
   - Related object (optional)
4. System validates input
5. System auto-generates task_code (TSK-000001, ...)
6. System sets created_by = current manager ID
7. System sets created_at = current timestamp
8. System sets reminder_at = due_date - 24 hours
9. System saves to database
10. Redirect to task list with success message

**Validation:**
- Title: Required, max 255 chars
- Assigned employee: Must exist in users table
- Due date: Cannot be in the past
- Priority: Must be valid enum value (LOW, MEDIUM, HIGH)
- Status: Must be valid enum value (PENDING, IN_PROGRESS, COMPLETED, CANCELLED)

### 2. Edit Task
**Flow:**
1. Manager clicks edit button on task
2. System loads existing task data
3. Manager modifies fields
4. System validates changes
5. System updates updated_at timestamp
6. System updates completed_at if status changed to COMPLETED
7. System saves changes
8. Redirect to task detail with success message

### 3. Delete Task
**Flow:**
1. Manager clicks delete button
2. JavaScript confirmation dialog appears
3. If confirmed, system performs hard delete
4. Redirect to task list with success message

### 4. View Personal Tasks
**Flow:**
1. Manager navigates to task list (personal view)
2. System queries tasks WHERE assigned_to = manager_user_id
3. System applies filters (status, priority, keyword)
4. System applies sorting
5. System applies pagination
6. Display tasks in table format

### 5. View Team Tasks
**Flow:**
1. Manager navigates to task list (team view)
2. System gets all users in manager's department
3. System queries tasks WHERE assigned_to IN (team_member_ids)
4. System applies filters (status, priority, employee, keyword)
5. System applies sorting
6. System applies pagination
7. Display tasks in table format

### 6. View Task Detail
**Flow:**
1. Manager clicks task title/detail button
2. System loads task by ID
3. System loads assigned user info (JOIN with users table)
4. System loads creator info (JOIN with users table)
5. System loads related object info:
   - If Lead: JOIN with leads table
   - If Customer: JOIN with customers table
   - If Opportunity: JOIN with opportunities table
6. Display all information

### 7. Assign/Reassign Task
**Flow:**
1. Manager edits task
2. Manager selects new assignee from dropdown
3. System validates assignee exists
4. System updates assigned_to field
5. Save changes

### 8. Update Task Status
**Flow:**
1. Manager edits task
2. Manager selects new status
3. System validates status enum
4. If status = COMPLETED:
   - System sets completed_at = current timestamp
5. If status != COMPLETED:
   - System sets completed_at = NULL
6. Save changes

**Status Transitions:**
- PENDING → IN_PROGRESS
- PENDING → CANCELLED
- IN_PROGRESS → COMPLETED
- IN_PROGRESS → CANCELLED
- Any status can be changed to any other status (manager has full control)

### 9. Set Deadline
**Flow:**
1. Manager sets due_date in form
2. System validates date format (YYYY-MM-DD)
3. System validates date is not in past (for new tasks)
4. System auto-calculates reminder_at = due_date - 24 hours
5. Save changes

### 10. Set Priority
**Flow:**
1. Manager selects priority from dropdown
2. System validates enum value
3. Save changes

**Priority Levels:**
- LOW (Thấp) - Gray badge
- MEDIUM (Trung bình) - Yellow badge
- HIGH (Cao) - Red badge

### 11. Link Task to Object
**Flow:**
1. Manager selects related_type from dropdown (Lead/Customer/Opportunity)
2. JavaScript dynamically loads related objects of selected type
3. Manager selects specific object from second dropdown
4. System sets related_type and related_id
5. Save changes

**Related Type Support:**
- Lead: Links to leads table via lead_id
- Customer: Links to customers table via customer_id
- Opportunity: Links to opportunities table via opportunity_id

### 12. Task Reminder
**Implementation:**
- System automatically sets reminder_at = due_date - 24 hours
- In task list, overdue tasks show red "Quá hạn" badge
- Reminder logic:
  ```java
  if (task.getDueDate() != null && task.getDueDate().isBefore(LocalDateTime.now())
      && !task.getStatus().equals("COMPLETED")) {
      // Show overdue warning
  }
  ```

### 13. Task Calendar View
**Flow:**
1. Manager navigates to calendar view
2. System displays current month by default
3. System queries tasks for selected month/year
4. System groups tasks by due_date day
5. Display tasks in calendar grid
6. Each day shows:
   - Day number
   - Task count badge
   - Up to 3 tasks (clickable)
   - "+X more" for additional tasks
7. Color coding by priority

### 14. Task Completion Report
**Metrics Calculated:**
- Total tasks
- Completed tasks
- Pending tasks
- In-progress tasks
- Overdue tasks
- Completion rate = (completed / total) * 100
- Per-employee statistics
- High priority pending tasks

**SQL Query:**
```sql
SELECT
    COUNT(*) as total_tasks,
    SUM(CASE WHEN status = 'COMPLETED' THEN 1 ELSE 0 END) as completed_tasks,
    SUM(CASE WHEN status = 'PENDING' THEN 1 ELSE 0 END) as pending_tasks,
    SUM(CASE WHEN status = 'IN_PROGRESS' THEN 1 ELSE 0 END) as in_progress_tasks,
    SUM(CASE WHEN due_date < GETDATE() AND status != 'COMPLETED' THEN 1 ELSE 0 END) as overdue_tasks
FROM tasks
WHERE assigned_to IN (team_member_ids)
```

### 15. Recurring Task
**Implementation Approach:**
Since the tasks table doesn't have recurring fields, recurring functionality is implemented through logical generation:

**Concept:**
1. When a recurring task is completed (status changed to COMPLETED)
2. System checks if task should recur (based on business logic or flag in description)
3. System creates a new task with:
   - Same title, description, priority, assigned_to, related_type, related_id
   - New task_code (auto-generated)
   - New due_date (calculated based on recurrence pattern)
   - Status = PENDING
   - New created_at, updated_at
   - Same created_by

**Example Implementation (Service Layer):**
```java
public void handleRecurringTask(Task completedTask) {
    // Check if task should recur (e.g., title contains "[Recurring]")
    if (completedTask.getTitle().contains("[Recurring]")) {
        Task newTask = new Task();
        newTask.setTitle(completedTask.getTitle());
        newTask.setDescription(completedTask.getDescription());
        newTask.setAssignedTo(completedTask.getAssignedTo());
        newTask.setPriority(completedTask.getPriority());
        newTask.setRelatedType(completedTask.getRelatedType());
        newTask.setRelatedId(completedTask.getRelatedId());

        // Set new due date (e.g., +1 week)
        LocalDateTime newDueDate = completedTask.getDueDate().plusWeeks(1);
        newTask.setDueDate(newDueDate);
        newTask.setReminderAt(newDueDate.minusHours(24));

        newTask.setStatus(TaskStatus.PENDING.name());
        newTask.setCreatedBy(completedTask.getCreatedBy());

        taskDAO.insertTask(newTask);
    }
}
```

---

## Validation Logic

### Server-Side Validation (in Servlets)

```java
// Title validation
if (title == null || title.trim().isEmpty()) {
    session.setAttribute("errorMessage", "Tiêu đề không được để trống");
    return;
}

// Assigned user validation
Integer assignedTo = Integer.parseInt(assignedToStr);
Users assignedUser = userDAO.getUserById(assignedTo);
if (assignedUser == null) {
    session.setAttribute("errorMessage", "Người được giao không tồn tại");
    return;
}

// Due date validation (for create only)
LocalDateTime dueDate = LocalDateTime.parse(dueDateStr + "T23:59:59");
if ("create".equals(formAction) && dueDate.isBefore(LocalDateTime.now())) {
    session.setAttribute("errorMessage", "Ngày hết hạn không được ở quá khứ");
    return;
}

// Enum validation
try {
    Priority.valueOf(priority);
} catch (IllegalArgumentException e) {
    session.setAttribute("errorMessage", "Mức độ ưu tiên không hợp lệ");
    return;
}

try {
    TaskStatus.valueOf(status);
} catch (IllegalArgumentException e) {
    session.setAttribute("errorMessage", "Trạng thái không hợp lệ");
    return;
}
```

### Client-Side Validation (in JSP)

```javascript
// Date picker min date
const dueDateInput = document.getElementById('dueDate');
const today = new Date().toISOString().split('T')[0];
dueDateInput.setAttribute('min', today);

// Required fields
<input type="text" required maxlength="255">
<select required>...</select>
```

---

## Role Checking

**Implementation in Every Servlet:**

```java
HttpSession session = request.getSession();
Users currentUser = (Users) session.getAttribute("user");

// Check if user is logged in
if (currentUser == null) {
    response.sendRedirect(request.getContextPath() + "/auth/login");
    return;
}

// Check if user has MANAGER role
UserDAO userDAO = new UserDAO();
String roleCode = userDAO.getRoleCodeByUserId(currentUser.getUserId());

if (!"MANAGER".equals(roleCode)) {
    response.sendRedirect(request.getContextPath() + "/error/403.jsp");
    return;
}
```

**SQL Query for Role Check:**
```sql
SELECT r.role_code
FROM roles r
JOIN user_roles ur ON r.role_id = ur.role_id
WHERE ur.user_id = ?
```

**Access Control:**
- Only managers can access `/manager/task/*` URLs
- Direct URL access is prevented by role checking
- Session validation on every request
- 403 Forbidden page for unauthorized access

---

## Pagination Logic

### Implementation

**Controller Side:**
```java
// Get page parameter
int page = 1;
int pageSize = 20;
try {
    String pageParam = request.getParameter("page");
    if (pageParam != null && !pageParam.isEmpty()) {
        page = Integer.parseInt(pageParam);
    }
} catch (NumberFormatException e) {
    page = 1;
}

// Calculate offset
int offset = (page - 1) * pageSize;

// Get paginated data
List<Task> taskList = taskDAO.getTasksWithFilter(
    assignedTo, statusFilter, priorityFilter,
    keyword, sortBy, sortOrder, offset, pageSize
);

// Get total count for pagination
int totalTasks = taskDAO.countTasksWithFilter(
    assignedTo, statusFilter, priorityFilter, keyword
);

// Calculate total pages
int totalPages = (int) Math.ceil((double) totalTasks / pageSize);
```

**SQL Query (SQL Server - OFFSET FETCH):**
```sql
SELECT * FROM tasks
WHERE assigned_to = ?
AND status = ?
AND priority = ?
AND (title LIKE ? OR description LIKE ?)
ORDER BY due_date ASC
OFFSET ? ROWS
FETCH NEXT ? ROWS ONLY
```

**View Side (JSP):**
```jsp
<c:if test="${totalPages > 1}">
    <nav>
        <ul class="pagination">
            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                <a class="page-link" href="?page=${currentPage - 1}">Previous</a>
            </li>
            <c:forEach begin="1" end="${totalPages}" var="i">
                <li class="page-item ${currentPage == i ? 'active' : ''}">
                    <a class="page-link" href="?page=${i}">${i}</a>
                </li>
            </c:forEach>
            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                <a class="page-link" href="?page=${currentPage + 1}">Next</a>
            </li>
        </ul>
    </nav>
</c:if>
```

---

## Statistics Calculation Logic

### Overall Statistics Query

```sql
SELECT
    COUNT(*) as total_tasks,
    SUM(CASE WHEN status = 'COMPLETED' THEN 1 ELSE 0 END) as completed_tasks,
    SUM(CASE WHEN status = 'PENDING' THEN 1 ELSE 0 END) as pending_tasks,
    SUM(CASE WHEN status = 'IN_PROGRESS' THEN 1 ELSE 0 END) as in_progress_tasks,
    SUM(CASE WHEN due_date < GETDATE() AND status != 'COMPLETED' THEN 1 ELSE 0 END) as overdue_tasks,
    SUM(CASE WHEN priority = 'HIGH' AND status != 'COMPLETED' THEN 1 ELSE 0 END) as high_priority_pending
FROM tasks
WHERE assigned_to IN (?, ?, ?, ...)
```

### Completion Rate Calculation

```java
int total = rs.getInt("total_tasks");
int completed = rs.getInt("completed_tasks");
double completionRate = total > 0 ? (completed * 100.0 / total) : 0;
stats.put("completionRate", completionRate);
```

### Per-Employee Statistics

```java
Map<Integer, Map<String, Object>> employeeStats = new HashMap<>();
for (Users member : teamMembersList) {
    List<Integer> singleMember = new ArrayList<>();
    singleMember.add(member.getUserId());
    Map<String, Object> stats = taskDAO.getTaskStatistics(null, singleMember);
    employeeStats.put(member.getUserId(), stats);
}
```

---

## Recurring Task Generation Logic

### Approach 1: On Completion (Recommended)

When task status is updated to COMPLETED, check if it should recur:

```java
// In updateTask method
if (TaskStatus.COMPLETED.name().equals(task.getStatus())) {
    task.setCompletedAt(LocalDateTime.now());

    // Check if recurring (e.g., based on title marker)
    if (task.getTitle().startsWith("[R]") || task.getDescription().contains("RECURRING")) {
        generateRecurringTask(task);
    }
}

private void generateRecurringTask(Task completedTask) {
    Task newTask = new Task();
    newTask.setTitle(completedTask.getTitle());
    newTask.setDescription(completedTask.getDescription());
    newTask.setAssignedTo(completedTask.getAssignedTo());
    newTask.setPriority(completedTask.getPriority());
    newTask.setStatus(TaskStatus.PENDING.name());
    newTask.setRelatedType(completedTask.getRelatedType());
    newTask.setRelatedId(completedTask.getRelatedId());
    newTask.setCreatedBy(completedTask.getCreatedBy());

    // Calculate next due date based on pattern
    // Example: Weekly recurrence
    LocalDateTime nextDueDate = completedTask.getDueDate().plusWeeks(1);
    newTask.setDueDate(nextDueDate);
    newTask.setReminderAt(nextDueDate.minusHours(24));

    insertTask(newTask);
}
```

### Approach 2: Scheduled Job

Create a background job that runs daily to check for recurring tasks:

```java
public void generateRecurringTasks() {
    // Find all completed tasks that should recur
    List<Task> recurringTasks = getRecurringTasksToGenerate();

    for (Task task : recurringTasks) {
        // Check if next occurrence doesn't already exist
        if (!hasNextOccurrence(task)) {
            generateRecurringTask(task);
        }
    }
}
```

---

## SQL Queries Reference

### 1. Insert Task
```sql
INSERT INTO tasks (
    task_code, title, description, related_type, related_id,
    assigned_to, due_date, reminder_at, priority, status,
    created_at, updated_at, created_by
) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
```

### 2. Update Task
```sql
UPDATE tasks
SET title = ?, description = ?, related_type = ?, related_id = ?,
    assigned_to = ?, due_date = ?, reminder_at = ?, priority = ?,
    status = ?, completed_at = ?, updated_at = ?
WHERE task_id = ?
```

### 3. Delete Task
```sql
DELETE FROM tasks WHERE task_id = ?
```

### 4. Get Task by ID
```sql
SELECT * FROM tasks WHERE task_id = ?
```

### 5. Get Tasks by User (Personal)
```sql
SELECT * FROM tasks
WHERE assigned_to = ?
ORDER BY due_date ASC
```

### 6. Get Tasks by Team
```sql
SELECT * FROM tasks
WHERE assigned_to IN (?, ?, ?, ...)
ORDER BY due_date ASC
```

### 7. Get Tasks with Filters and Pagination
```sql
SELECT * FROM tasks
WHERE assigned_to = ?
AND status = ?
AND priority = ?
AND (title LIKE ? OR description LIKE ?)
ORDER BY due_date ASC
OFFSET ? ROWS
FETCH NEXT ? ROWS ONLY
```

### 8. Count Tasks for Pagination
```sql
SELECT COUNT(*) as total
FROM tasks
WHERE assigned_to = ?
AND status = ?
AND priority = ?
AND (title LIKE ? OR description LIKE ?)
```

### 9. Get Calendar Tasks
```sql
SELECT * FROM tasks
WHERE YEAR(due_date) = ?
AND MONTH(due_date) = ?
AND assigned_to IN (?, ?, ?, ...)
ORDER BY due_date ASC
```

### 10. Get Overdue Tasks
```sql
SELECT * FROM tasks
WHERE due_date < GETDATE()
AND status != 'COMPLETED'
AND status != 'CANCELLED'
AND assigned_to IN (?, ?, ?, ...)
ORDER BY due_date ASC
```

---

## Flow Diagrams

### Create Task Flow
```
User clicks "Create Task"
    ↓
ManagerTaskFormServlet (doGet)
    ↓
Display task-create.jsp
    ↓
User fills form
    ↓
User submits
    ↓
ManagerTaskFormServlet (doPost)
    ↓
Validate inputs
    ├─ Invalid → Show error → Back to form
    ↓
    Valid
    ↓
Generate task_code
    ↓
Set created_by, created_at
    ↓
Calculate reminder_at
    ↓
TaskDAO.insertTask()
    ↓
Redirect to task list with success message
```

### View Team Tasks Flow
```
User clicks "Team Tasks" tab
    ↓
ManagerTaskListServlet (doGet)
    ↓
Get current user from session
    ↓
Check role = MANAGER
    ├─ Not Manager → 403 Forbidden
    ↓
    Is Manager
    ↓
Get team members (same department)
    ↓
Get filters from request
    ↓
TaskDAO.getTasksByTeam(teamMemberIds)
    ↓
Apply filters manually
    ↓
Apply pagination
    ↓
Forward to task-list.jsp
    ↓
Display tasks in table
```

### Calendar View Flow
```
User clicks "Calendar" tab
    ↓
ManagerTaskCalendarServlet (doGet)
    ↓
Get year, month parameters
    ↓
Check view type (personal/team)
    ├─ Personal → Get tasks for current user
    ├─ Team → Get tasks for team members
    ↓
TaskDAO.getTasksForCalendar(year, month, userId/teamIds)
    ↓
Group tasks by day of month
    ↓
Calculate calendar grid
    ↓
Forward to task-calendar.jsp
    ↓
Display monthly calendar with tasks
```

---

## Additional Notes

### Error Handling
- All servlets use try-catch blocks
- Database errors are logged via e.printStackTrace()
- User-friendly error messages displayed in session
- Invalid input redirects to previous page with error

### Security Considerations
- SQL injection prevented by PreparedStatement
- Role-based access control enforced
- Session validation on every request
- XSS prevented by proper JSP escaping

### Performance Optimizations
- Pagination limits query results
- Index on task_id, assigned_to, status, priority, due_date
- N+1 query problem avoided by batch loading
- Efficient SQL with OFFSET FETCH

### Code Maintainability
- Clear method names following Java conventions
- Comprehensive JavaDoc comments
- Separation of concerns (MVC)
- Reusable helper methods
- Consistent error handling

---

## Testing Checklist

### Functional Testing
- [ ] Create task with valid data
- [ ] Create task with invalid data (past due date, invalid enum, etc.)
- [ ] Edit task and update all fields
- [ ] Delete task
- [ ] View personal tasks
- [ ] View team tasks
- [ ] Filter by status, priority, employee, keyword
- [ ] Sort tasks by different columns
- [ ] Navigate pagination
- [ ] View task detail
- [ ] Link task to Lead/Customer/Opportunity
- [ ] View calendar (personal and team)
- [ ] Navigate calendar months
- [ ] View task report
- [ ] Check overdue task detection
- [ ] Verify reminder calculation

### Security Testing
- [ ] Access task URLs without login → Redirect to login
- [ ] Access task URLs as non-manager → 403 Forbidden
- [ ] SQL injection attempts
- [ ] XSS attempts in title/description

### Performance Testing
- [ ] Load task list with 1000+ tasks
- [ ] Filter and pagination performance
- [ ] Calendar view with many tasks
- [ ] Report generation speed

---

## Deployment Instructions

1. **Compile Java files:**
   ```bash
   javac -d build/classes src/java/dao/TaskDAO.java
   javac -d build/classes src/java/controller/manager/*.java
   ```

2. **Copy JSP files:**
   ```bash
   cp -r web/view/manager/task/* build/web/view/manager/task/
   ```

3. **Deploy WAR file to Tomcat/Application Server**

4. **Verify database connection in DBContext.java**

5. **Access application:**
   ```
   http://localhost:8080/CRM/manager/task/list
   ```

---

## Support & Maintenance

For questions or issues, refer to:
- Database schema documentation
- Existing model class documentation
- Enum class definitions
- DAO method JavaDoc

---

**End of Documentation**
