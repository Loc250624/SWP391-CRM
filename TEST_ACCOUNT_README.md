# Test Manager Account - Setup Instructions

## 📋 Overview
This document provides instructions for creating and using a test Manager account to test the **Module 4: Activities and Collaboration - Task Management** features.

---

## 🔑 Login Credentials

**Email:** `manager@test.com`
**Password:** `123456`

---

## 📦 Account Details

- **User ID:** 100
- **Employee Code:** MGR-001
- **Full Name:** Test Manager
- **Department:** Phòng Kinh doanh (SALES - Department ID: 2)
- **Role:** MANAGER (Quản lý - Role ID: 5)
- **Status:** Active
- **Phone:** 0901234567

---

## 🚀 Setup Instructions

### Step 1: Run the SQL Script

1. Open **SQL Server Management Studio (SSMS)**
2. Connect to your SQL Server instance
3. Select the `CRM_System` database
4. Open the file: `test_manager_account.sql`
5. Execute the script (F5 or press Execute button)

### Step 2: Verify Account Creation

Run this query to verify the account was created:

```sql
SELECT
    u.user_id,
    u.employee_code,
    u.email,
    u.first_name,
    u.last_name,
    u.department_id,
    u.status,
    r.role_code,
    r.role_name
FROM users u
INNER JOIN user_roles ur ON u.user_id = ur.user_id
INNER JOIN roles r ON ur.role_id = r.role_id
WHERE u.email = 'manager@test.com';
```

Expected output:
- Email: manager@test.com
- Role Code: MANAGER
- Status: Active

### Step 3: Login to CRM System

1. Start your application server (Tomcat/GlassFish)
2. Navigate to: `http://localhost:8080/SWP391-CRM/`
3. Login with:
   - **Email:** manager@test.com
   - **Password:** 123456
4. You should be redirected to the Manager dashboard

---

## 📊 Sample Tasks Created

The SQL script automatically creates **5 sample tasks** for testing:

### Task 1: TSK-000001 - Review Q1 Sales Report
- **Priority:** HIGH (Cao)
- **Status:** PENDING (Chờ xử lý)
- **Due Date:** 2 days ago (OVERDUE)
- **Description:** Review and analyze Q1 sales performance report from sales team

### Task 2: TSK-000002 - Team Meeting Preparation
- **Priority:** MEDIUM (Trung bình)
- **Status:** IN_PROGRESS (Đang thực hiện)
- **Due Date:** Today
- **Description:** Prepare agenda and materials for weekly team meeting

### Task 3: TSK-000003 - Update CRM User Guide
- **Priority:** LOW (Thấp)
- **Status:** PENDING (Chờ xử lý)
- **Due Date:** 7 days from now
- **Description:** Update documentation for new CRM features

### Task 4: TSK-000004 - [R] Weekly Team Status Update
- **Priority:** MEDIUM (Trung bình)
- **Status:** PENDING (Chờ xử lý)
- **Due Date:** 7 days from now
- **Type:** RECURRING (Weekly)
- **Description:** Recurring weekly task - Collect and submit team status updates

### Task 5: TSK-000005 - Onboard New Sales Representative
- **Priority:** HIGH (Cao)
- **Status:** COMPLETED (Hoàn thành)
- **Due Date:** 5 days ago
- **Completed:** 3 days ago
- **Description:** Complete onboarding process for new hire

---

## 🎯 Features to Test

### 1. Task List View (`/manager/task/list`)
- ✅ View personal tasks vs team tasks
- ✅ Filter by status, priority, date range
- ✅ Search functionality
- ✅ Pagination
- ✅ Overdue task warnings

### 2. Create Task (`/manager/task/create`)
- ✅ Create new task with all fields
- ✅ Link task to Lead/Customer/Opportunity
- ✅ Set priority and deadline
- ✅ Assign to user

### 3. Task Detail View (`/manager/task/detail?id=101`)
- ✅ View complete task information
- ✅ See assigned user details
- ✅ View related objects (Lead/Customer/Opportunity)
- ✅ Action buttons (Edit, Delete, Update Status, etc.)

### 4. Edit Task (`/manager/task/edit?id=101`)
- ✅ Modify task details
- ✅ Change assignee
- ✅ Update description

### 5. Update Task Status (`/manager/task/status?id=101`)
- ✅ Change status: PENDING → IN_PROGRESS → COMPLETED
- ✅ Cancel task
- ✅ Visual status flow

### 6. Set Priority (`/manager/task/priority?id=101`)
- ✅ Change priority: HIGH / MEDIUM / LOW
- ✅ Visual priority cards

### 7. Set Deadline (`/manager/task/deadline?id=101`)
- ✅ Change due date
- ✅ Quick date selection (+1 day, +3 days, +1 week, etc.)
- ✅ Extension warnings

### 8. Assign Task (`/manager/task/assign?id=101`)
- ✅ Assign/reassign task to team member
- ✅ View current assignee

### 9. Task Calendar (`/manager/task/calendar`)
- ✅ Monthly calendar view
- ✅ Tasks displayed on due dates
- ✅ Personal vs team toggle
- ✅ Month navigation

### 10. Task Reminders (`/manager/task/reminder`)
- ✅ View overdue tasks
- ✅ View tasks due today
- ✅ View tasks due this week
- ✅ High priority pending tasks

### 11. Recurring Tasks (`/manager/task/recurring?id=104`)
- ✅ Enable/disable recurring
- ✅ Set recurrence pattern (Daily/Weekly/Monthly)
- ✅ Preview next occurrences
- ✅ Set repeat count and end date

### 12. Task Reports (`/manager/task/report`)
- ✅ Overall statistics
- ✅ Completion rates
- ✅ Employee performance
- ✅ Task distribution charts

### 13. Delete Task
- ✅ Delete task with confirmation

---

## 🔍 Testing Checklist

- [ ] Login successfully with test account
- [ ] Access Task List page
- [ ] View 5 sample tasks
- [ ] See 1 overdue task warning (red badge)
- [ ] Filter tasks by status
- [ ] Search for tasks
- [ ] Create a new task
- [ ] Edit an existing task
- [ ] Update task status
- [ ] Change task priority
- [ ] Set new deadline
- [ ] Assign task to yourself
- [ ] View task calendar
- [ ] Check task reminders page
- [ ] Configure recurring task
- [ ] View task completion report
- [ ] Delete a task
- [ ] Link task to a Lead/Customer/Opportunity

---

## 📝 Notes

- All tasks are assigned to the test Manager account (User ID: 100)
- The account is in the SALES department (ID: 2)
- Password is stored in plain text (not secure, but matches current system implementation)
- Task IDs start from 101 to avoid conflicts with existing data
- User ID is 100 to avoid conflicts

---

## 🗑️ Cleanup (Optional)

To remove the test account and data, run:

```sql
USE [CRM_System]
GO

-- Delete tasks
DELETE FROM tasks WHERE task_id BETWEEN 101 AND 105;

-- Delete user role
DELETE FROM user_roles WHERE user_id = 100;

-- Delete user
DELETE FROM users WHERE user_id = 100;

-- Reset identity if needed
-- DBCC CHECKIDENT ('tasks', RESEED, 100);
-- DBCC CHECKIDENT ('users', RESEED, 99);
-- DBCC CHECKIDENT ('user_roles', RESEED, 99);

PRINT 'Test account and data removed successfully.';
```

---

## ⚠️ Troubleshooting

### Cannot Login
1. Verify user exists: `SELECT * FROM users WHERE email = 'manager@test.com'`
2. Check status is 'Active'
3. Verify role assignment: Check `user_roles` table
4. Clear browser cache and cookies

### Tasks Not Showing
1. Verify tasks exist: `SELECT * FROM tasks WHERE assigned_to = 100`
2. Check task status values match enum (PENDING, IN_PROGRESS, COMPLETED, CANCELLED)
3. Verify user_id = 100 in session

### Permission Denied
1. Verify role_code = 'MANAGER' in user_roles
2. Check servlet role validation logic
3. Ensure session contains correct user and role information

---

## 📞 Support

If you encounter any issues, check:
1. Database connection in `DBConnect.java`
2. Server logs in Tomcat/GlassFish
3. Browser console for JavaScript errors
4. SQL Server for database errors

---

**Last Updated:** 2026-02-15
**Module:** Activities and Collaboration - Task Management
**Role:** Manager
**Version:** 1.0.0
