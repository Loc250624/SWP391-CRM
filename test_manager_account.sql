-- ========================================
-- Test Manager Account for Login Testing
-- ========================================
-- Database: CRM_System
-- Created: 2026-02-15
-- Purpose: Create test Manager account for Module 4 Task Management testing

USE [CRM_System]
GO

-- Insert Test Manager User
SET IDENTITY_INSERT [dbo].[users] ON
GO

INSERT [dbo].[users]
    ([user_id], [employee_code], [email], [password_hash], [first_name], [last_name], [phone], [avatar_url], [department_id], [status], [created_at], [updated_at])
VALUES
    (100, N'MGR-001', N'manager@test.com', N'123456', N'Test', N'Manager', N'0901234567', NULL, 2, N'Active', GETDATE(), GETDATE())
GO

SET IDENTITY_INSERT [dbo].[users] OFF
GO

-- Assign MANAGER Role to Test User
SET IDENTITY_INSERT [dbo].[user_roles] ON
GO

INSERT [dbo].[user_roles]
    ([user_role_id], [user_id], [role_id], [assigned_at], [assigned_by])
VALUES
    (100, 100, 5, GETDATE(), NULL)
GO

SET IDENTITY_INSERT [dbo].[user_roles] OFF
GO

-- ========================================
-- Test Data: Create Some Sample Tasks
-- ========================================
-- These sample tasks will help test the Task Management features

SET IDENTITY_INSERT [dbo].[tasks] ON
GO

-- Task 1: High priority task assigned to manager (overdue)
INSERT [dbo].[tasks]
    ([task_id], [task_code], [title], [description], [assigned_to], [created_by], [priority], [status], [due_date], [created_at], [updated_at])
VALUES
    (101, N'TSK-000001', N'Review Q1 Sales Report', N'Review and analyze Q1 sales performance report from sales team', 100, 100, N'HIGH', N'PENDING', DATEADD(day, -2, GETDATE()), GETDATE(), GETDATE())
GO

-- Task 2: Medium priority task (due today)
INSERT [dbo].[tasks]
    ([task_id], [task_code], [title], [description], [assigned_to], [created_by], [priority], [status], [due_date], [created_at], [updated_at])
VALUES
    (102, N'TSK-000002', N'Team Meeting Preparation', N'Prepare agenda and materials for weekly team meeting', 100, 100, N'MEDIUM', N'IN_PROGRESS', CAST(GETDATE() AS DATE), GETDATE(), GETDATE())
GO

-- Task 3: Low priority task (due next week)
INSERT [dbo].[tasks]
    ([task_id], [task_code], [title], [description], [assigned_to], [created_by], [priority], [status], [due_date], [created_at], [updated_at])
VALUES
    (103, N'TSK-000003', N'Update CRM User Guide', N'Update documentation for new CRM features', 100, 100, N'LOW', N'PENDING', DATEADD(day, 7, GETDATE()), GETDATE(), GETDATE())
GO

-- Task 4: Recurring weekly task
INSERT [dbo].[tasks]
    ([task_id], [task_code], [title], [description], [assigned_to], [created_by], [priority], [status], [due_date], [created_at], [updated_at])
VALUES
    (104, N'TSK-000004', N'[R] Weekly Team Status Update', N'Recurring weekly task - Collect and submit team status updates. Recurrence: WEEKLY', 100, 100, N'MEDIUM', N'PENDING', DATEADD(day, 7, GETDATE()), GETDATE(), GETDATE())
GO

-- Task 5: Completed task
INSERT [dbo].[tasks]
    ([task_id], [task_code], [title], [description], [assigned_to], [created_by], [priority], [status], [due_date], [completed_at], [created_at], [updated_at])
VALUES
    (105, N'TSK-000005', N'Onboard New Sales Representative', N'Complete onboarding process for new hire', 100, 100, N'HIGH', N'COMPLETED', DATEADD(day, -5, GETDATE()), DATEADD(day, -3, GETDATE()), DATEADD(day, -7, GETDATE()), GETDATE())
GO

SET IDENTITY_INSERT [dbo].[tasks] OFF
GO

PRINT '========================================';
PRINT 'Test Manager Account Created Successfully!';
PRINT '========================================';
PRINT '';
PRINT 'Login Credentials:';
PRINT '  Email:    manager@test.com';
PRINT '  Password: 123456';
PRINT '';
PRINT 'User Details:';
PRINT '  User ID:       100';
PRINT '  Employee Code: MGR-001';
PRINT '  Full Name:     Test Manager';
PRINT '  Department:    Phòng Kinh doanh (SALES)';
PRINT '  Role:          MANAGER (Quản lý)';
PRINT '  Status:        Active';
PRINT '';
PRINT 'Sample Tasks Created: 5 tasks';
PRINT '  - 1 Overdue task (High priority)';
PRINT '  - 1 Due today (Medium priority, In Progress)';
PRINT '  - 1 Due next week (Low priority)';
PRINT '  - 1 Recurring weekly task';
PRINT '  - 1 Completed task';
PRINT '';
PRINT 'Access the Task Management Module at:';
PRINT '  http://localhost:8080/SWP391-CRM/manager/task/list';
PRINT '';
PRINT '========================================';
GO
