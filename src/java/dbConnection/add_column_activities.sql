  INSERT INTO [CRM_System_n].[dbo].[users] 
(
    [employee_code], [email], [password_hash], 
    [first_name], [last_name], [phone], [avatar_url], 
    [department_id], [status], [created_at], [updated_at]
)
VALUES
('ADM001', 'admin@crm.com', '123', N'Quản Trị', N'Viên', NULL, NULL, 4, 'Active', '2026-02-06 00:33:14.080', '2026-02-06 00:33:14.080'),
('MKT001', 'marketing@crm.com', '123', N'Nhân Viên', 'Marketing', NULL, NULL, 1, 'Active', '2026-02-06 00:33:14.080', '2026-02-06 00:33:14.080'),
('SAL001', 'sales@crm.com', '123', N'Nhân Viên', 'Sale', NULL, NULL, 2, 'Active', '2026-02-06 00:33:14.080', '2026-02-06 00:33:14.080'),
('MNG001', 'manager@crm.com', '123', N'Quản Lý', N'Tổng', NULL, NULL, 4, 'Active', '2026-02-06 00:33:14.080', '2026-02-06 00:33:14.080'),
('SUP001', 'support1@crm.com', '123', N'Hỗ Trợ', N'Viên 1', NULL, NULL, 3, 'Active', '2026-02-06 00:33:14.080', '2026-02-06 00:33:14.080'),
('SUP002', 'support2@crm.com', '123', N'Hỗ Trợ', N'Viên 2', NULL, NULL, 3, 'Active', '2026-02-06 00:33:14.080', '2026-02-06 00:33:14.080');



  INSERT INTO [CRM_System_n].[dbo].[user_roles] 
(
    [user_id], 
    [role_id], 
    [assigned_at], 
    [assigned_by]
)
VALUES
(1, 1, '2026-02-06 00:35:44.870', NULL),
(2, 2, '2026-02-06 00:35:44.870', NULL),
(3, 3, '2026-02-06 00:35:44.870', NULL),
(4, 5, '2026-02-06 00:35:44.870', NULL),
(5, 4, '2026-02-06 00:35:44.870', NULL),
(6, 4, '2026-02-06 00:35:44.870', NULL);


INSERT INTO [CRM_System_n].[dbo].[customers] 
(
    [customer_code], [full_name], [email], [phone], [date_of_birth], 
    [gender], [address], [city], [source_id], [converted_lead_id], 
    [customer_segment], [status], [owner_id], [total_courses], [total_spent], 
    [first_purchase_date], [last_purchase_date], [purchased_courses], 
    [health_score], [satisfaction_score], [email_opt_out], [sms_opt_out], 
    [notes], [created_at], [updated_at], [created_by]
)
VALUES
('KH0001', N'Nguyễn Văn An', 'an.nguyen@email.com', '0901234567', '1990-05-15', 'Male', N'123 Lê Lợi', N'Hà Nội', 1, NULL, 'VIP', 'Active', 3, 3, 15000000, '2025-01-10', '2026-02-01', N'Khóa học Marketing, Khóa học SEO', 85, 5, 0, 0, N'Khách hàng thân thiết', GETDATE(), GETDATE(), 1),

('KH0002', N'Trần Thị Bích', 'bich.tran@email.com', '0912345678', '1995-08-22', 'Female', N'456 Nguyễn Trãi', N'TP.HCM', 2, NULL, 'Regular', 'Active', 3, 1, 3000000, '2025-11-20', '2025-11-20', N'Khóa học Thiết kế Cơ bản', 70, 4, 1, 0, N'Chỉ quan tâm thiết kế', GETDATE(), GETDATE(), 1),

('KH0003', N'Lê Hoàng Cường', 'cuong.le@email.com', '0987654321', '1988-12-05', 'Male', N'789 Điện Biên Phủ', N'Đà Nẵng', 3, NULL, 'New', 'Active', 2, 1, 2500000, '2026-02-15', '2026-02-15', N'Khóa học Lập trình Python', 90, 5, 0, 0, N'Khách hàng mới chốt từ Ads', GETDATE(), GETDATE(), 2),

('KH0004', N'Phạm Mỹ Dung', 'dung.pham@email.com', '0971112233', '1998-03-30', 'Female', N'321 Trần Phú', N'Cần Thơ', 1, NULL, 'Regular', 'Inactive', 3, 2, 8000000, '2024-05-10', '2024-12-01', N'Khóa học Tiếng Anh Giao tiếp', 40, 3, 0, 1, N'Ít tương tác dạo gần đây', GETDATE(), GETDATE(), 1),

('KH0005', N'Hoàng Tuấn Em', 'em.hoang@email.com', '0933445566', '2001-07-11', 'Male', N'654 Võ Văn Ngân', N'TP.HCM', 4, NULL, 'VIP', 'Active', 2, 4, 22000000, '2025-02-28', '2026-01-15', N'Combo Lập trình Fullstack', 95, 5, 0, 0, N'Học viên xuất sắc', GETDATE(), GETDATE(), 2),

('KH0006', N'Vũ Bích Phượng', 'phuong.vu@email.com', '0944556677', '1992-09-09', 'Female', N'987 Láng Hạ', N'Hà Nội', 2, NULL, 'Regular', 'Active', 5, 1, 4500000, '2025-10-05', '2025-10-05', N'Khóa học Quản lý Tài chính', 80, 4, 0, 0, NULL, GETDATE(), GETDATE(), 1),

('KH0007', N'Đặng Văn Giang', 'giang.dang@email.com', '0966778899', '1985-11-20', 'Male', N'111 Hùng Vương', N'Hải Phòng', 5, NULL, 'Churned', 'Inactive', 5, 1, 2000000, '2024-01-15', '2024-01-15', N'Khóa học Excel Cơ bản', 20, 2, 1, 1, N'Đã hủy đăng ký nhận tin', GETDATE(), GETDATE(), 1),

('KH0008', N'Bùi Thị Hoa', 'hoa.bui@email.com', '0999888777', '1999-01-25', 'Female', N'222 Quang Trung', N'Nha Trang', 1, NULL, 'New', 'Active', 3, 1, 5500000, '2026-02-20', '2026-02-20', N'Khóa học Data Analysis', 88, 5, 0, 0, N'Cần hỗ trợ thêm về cài đặt phần mềm', GETDATE(), GETDATE(), 3);
INSERT INTO [CRM_System_n].[dbo].[leads] 
    ([lead_code], [full_name], [email], [phone], [source_id], [campaign_id], [job_title], 
     [company_name], [interests], [status], [rating], [lead_score], [assigned_to], 
     [assigned_at], [is_converted], [notes], [created_at], [updated_at], [created_by])
VALUES 
    -- Người 1: Lead tiềm năng cao từ Facebook Ads
    ('LD001', N'Nguyễn Minh Quang', 'quang.nm@gmail.com', '0901234567', 1, 10, N'Trưởng phòng Kỹ thuật', 
     N'Công ty Công nghệ Việt', N'Khóa học Java nâng cao', 'New', 'Hot', 85, 2, 
     GETDATE(), 0, N'Khách hàng cực kỳ quan tâm đến Spring Boot', GETDATE(), GETDATE(), 1),

    -- Người 2: Lead đang trong quá trình tư vấn
    ('LD002', N'Trần Thị Thanh Thảo', 'thanhthao.dev@outlook.com', '0912999888', 2, 11, N'Lập trình viên Web', 
     N'Startup Global', N'Flutter & Mobile App', 'Contacted', 'Warm', 60, 2, 
     GETDATE(), 0, N'Đã gọi điện tư vấn lần 1, khách hẹn cuối tuần trả lời', GETDATE(), GETDATE(), 1),

    -- Người 3: Lead tự tìm đến qua Website (Organic)
    ('LD003', N'Lê Hoàng Nam', 'namlh.business@vn.com', '0988777666', 3, NULL, N'Giám đốc Dự án', 
     N'Tập đoàn Xây dựng Thăng Long', N'Quản trị doanh nghiệp CRM', 'In Progress', 'Warm', 45, 3, 
     GETDATE(), 0, N'Quan tâm đến giải pháp quản lý Lead tập trung', GETDATE(), GETDATE(), 1);

ALTER TABLE activities ADD [status] NVARCHAR(50) DEFAULT 'Completed';
UPDATE [CRM_System_n].[dbo].[activities] 
SET [status] = 'Completed' 
WHERE [status] IS NULL;



