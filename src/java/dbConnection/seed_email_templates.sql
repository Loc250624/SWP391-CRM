-- Seed new internal email templates (run once)
-- Skip if template_code already exists

-- 1. Thong bao giao viec cho Sale
IF NOT EXISTS (SELECT 1 FROM email_templates WHERE template_code = 'SALE_TASK_ASSIGN')
INSERT INTO email_templates (template_code, template_name, category, subject, body_html, description, available_variables, is_active, is_default, allowed_roles, created_at, updated_at)
VALUES ('SALE_TASK_ASSIGN', N'Thông báo giao việc cho Sale', 'Internal',
N'Bạn có nhiệm vụ mới cần thực hiện',
N'<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;"><div style="background: #7c3aed; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0;"><h2 style="margin: 0;">Nhiệm vụ mới</h2><p style="margin: 5px 0 0; opacity: 0.9;">Bạn được giao một nhiệm vụ mới</p></div><div style="padding: 24px; border: 1px solid #e5e7eb; border-top: none; border-radius: 0 0 8px 8px;"><p>Xin chào <strong>{staff_name}</strong>,</p><p>Bạn vừa được giao một nhiệm vụ mới. Vui lòng đăng nhập hệ thống CRM để xem chi tiết và thực hiện.</p><div style="background: #f5f3ff; border: 1px solid #7c3aed; border-radius: 6px; padding: 16px; margin: 16px 0;"><p style="margin: 0; color: #5b21b6;"><strong>Lưu ý:</strong> Vui lòng cập nhật tiến độ thường xuyên trên hệ thống.</p></div><p>Trân trọng,<br><strong>Quản lý CRM</strong></p></div></div>',
N'Gửi cho nhân viên Sale khi được giao nhiệm vụ mới',
'staff_name', 1, 1, 'MANAGER', GETDATE(), GETDATE());

-- 2. Thong bao giao lead cho Sale
IF NOT EXISTS (SELECT 1 FROM email_templates WHERE template_code = 'SALE_LEAD_ASSIGN')
INSERT INTO email_templates (template_code, template_name, category, subject, body_html, description, available_variables, is_active, is_default, allowed_roles, created_at, updated_at)
VALUES ('SALE_LEAD_ASSIGN', N'Thông báo giao lead cho Sale', 'Internal',
N'Bạn có lead mới: {lead_name}',
N'<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;"><div style="background: #2563eb; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0;"><h2 style="margin: 0;">Lead mới</h2><p style="margin: 5px 0 0; opacity: 0.9;">Bạn được giao một lead mới</p></div><div style="padding: 24px; border: 1px solid #e5e7eb; border-top: none; border-radius: 0 0 8px 8px;"><p>Xin chào <strong>{staff_name}</strong>,</p><p>Bạn vừa được giao theo dõi lead mới. Dưới đây là thông tin:</p><table style="width: 100%; border-collapse: collapse; margin: 16px 0;"><tr style="background: #f9fafb;"><td style="padding: 10px; border: 1px solid #e5e7eb;"><strong>Tên lead</strong></td><td style="padding: 10px; border: 1px solid #e5e7eb;">{lead_name}</td></tr><tr><td style="padding: 10px; border: 1px solid #e5e7eb;"><strong>Email</strong></td><td style="padding: 10px; border: 1px solid #e5e7eb;">{email}</td></tr><tr style="background: #f9fafb;"><td style="padding: 10px; border: 1px solid #e5e7eb;"><strong>Điện thoại</strong></td><td style="padding: 10px; border: 1px solid #e5e7eb;">{phone}</td></tr><tr><td style="padding: 10px; border: 1px solid #e5e7eb;"><strong>Công ty</strong></td><td style="padding: 10px; border: 1px solid #e5e7eb;">{company_name}</td></tr></table><p>Vui lòng liên hệ lead trong thời gian sớm nhất.</p><p>Trân trọng,<br><strong>Quản lý CRM</strong></p></div></div>',
N'Gửi cho nhân viên Sale khi được giao lead mới',
'staff_name, lead_name, email, phone, company_name', 1, 1, 'MANAGER', GETDATE(), GETDATE());

-- 3. Bao cao hieu suat Sale
IF NOT EXISTS (SELECT 1 FROM email_templates WHERE template_code = 'SALE_PERFORMANCE')
INSERT INTO email_templates (template_code, template_name, category, subject, body_html, description, available_variables, is_active, is_default, allowed_roles, created_at, updated_at)
VALUES ('SALE_PERFORMANCE', N'Báo cáo hiệu suất Sale', 'Internal',
N'Báo cáo hiệu suất - {staff_name}',
N'<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;"><div style="background: #ea580c; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0;"><h2 style="margin: 0;">Báo cáo hiệu suất</h2><p style="margin: 5px 0 0; opacity: 0.9;">Tổng kết hoạt động</p></div><div style="padding: 24px; border: 1px solid #e5e7eb; border-top: none; border-radius: 0 0 8px 8px;"><p>Xin chào <strong>{staff_name}</strong>,</p><p>Đây là bản báo cáo tổng kết hiệu suất hoạt động của bạn. Vui lòng xem xét và liên hệ quản lý nếu có thắc mắc.</p><div style="background: #fff7ed; border: 1px solid #ea580c; border-radius: 6px; padding: 16px; margin: 16px 0;"><p style="margin: 0; color: #9a3412;">Hãy tiếp tục cố gắng và hoàn thành các mục tiêu đã đề ra!</p></div><p>Trân trọng,<br><strong>Quản lý CRM</strong></p></div></div>',
N'Gửi báo cáo hiệu suất cho nhân viên Sale',
'staff_name', 1, 1, 'MANAGER', GETDATE(), GETDATE());

-- 4. Nhac theo doi khach hang (CS)
IF NOT EXISTS (SELECT 1 FROM email_templates WHERE template_code = 'CS_FOLLOWUP_REMIND')
INSERT INTO email_templates (template_code, template_name, category, subject, body_html, description, available_variables, is_active, is_default, allowed_roles, created_at, updated_at)
VALUES ('CS_FOLLOWUP_REMIND', N'Nhắc theo dõi khách hàng', 'Internal',
N'Nhắc nhở: Theo dõi khách hàng {customer_name}',
N'<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;"><div style="background: #0891b2; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0;"><h2 style="margin: 0;">Nhắc nhở Follow-up</h2><p style="margin: 5px 0 0; opacity: 0.9;">Khách hàng cần được theo dõi</p></div><div style="padding: 24px; border: 1px solid #e5e7eb; border-top: none; border-radius: 0 0 8px 8px;"><p>Xin chào <strong>{staff_name}</strong>,</p><p>Đây là nhắc nhở về việc theo dõi khách hàng:</p><table style="width: 100%; border-collapse: collapse; margin: 16px 0;"><tr style="background: #f9fafb;"><td style="padding: 10px; border: 1px solid #e5e7eb;"><strong>Khách hàng</strong></td><td style="padding: 10px; border: 1px solid #e5e7eb;">{customer_name}</td></tr><tr><td style="padding: 10px; border: 1px solid #e5e7eb;"><strong>Mã KH</strong></td><td style="padding: 10px; border: 1px solid #e5e7eb;">{customer_code}</td></tr><tr style="background: #f9fafb;"><td style="padding: 10px; border: 1px solid #e5e7eb;"><strong>Email</strong></td><td style="padding: 10px; border: 1px solid #e5e7eb;">{email}</td></tr><tr><td style="padding: 10px; border: 1px solid #e5e7eb;"><strong>Điện thoại</strong></td><td style="padding: 10px; border: 1px solid #e5e7eb;">{phone}</td></tr></table><p>Vui lòng liên hệ khách hàng và cập nhật trạng thái trên hệ thống.</p><p>Trân trọng,<br><strong>Quản lý CRM</strong></p></div></div>',
N'Nhắc nhở Customer Success theo dõi khách hàng',
'staff_name, customer_name, customer_code, email, phone', 1, 1, 'MANAGER,SUPPORT', GETDATE(), GETDATE());

-- 5. Thong bao giao viec cho CS
IF NOT EXISTS (SELECT 1 FROM email_templates WHERE template_code = 'CS_TASK_ASSIGN')
INSERT INTO email_templates (template_code, template_name, category, subject, body_html, description, available_variables, is_active, is_default, allowed_roles, created_at, updated_at)
VALUES ('CS_TASK_ASSIGN', N'Thông báo giao việc cho CS', 'Internal',
N'Bạn có nhiệm vụ hỗ trợ khách hàng mới',
N'<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;"><div style="background: #0d9488; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0;"><h2 style="margin: 0;">Nhiệm vụ hỗ trợ</h2><p style="margin: 5px 0 0; opacity: 0.9;">Bạn được giao nhiệm vụ mới</p></div><div style="padding: 24px; border: 1px solid #e5e7eb; border-top: none; border-radius: 0 0 8px 8px;"><p>Xin chào <strong>{staff_name}</strong>,</p><p>Bạn vừa được giao một nhiệm vụ hỗ trợ khách hàng mới. Vui lòng đăng nhập hệ thống CRM để xem chi tiết.</p><div style="background: #f0fdfa; border: 1px solid #0d9488; border-radius: 6px; padding: 16px; margin: 16px 0;"><p style="margin: 0; color: #134e4a;"><strong>Lưu ý:</strong> Hãy phản hồi khách hàng trong thời gian sớm nhất để đảm bảo sự hài lòng.</p></div><p>Trân trọng,<br><strong>Quản lý CRM</strong></p></div></div>',
N'Gửi cho nhân viên CS khi được giao nhiệm vụ hỗ trợ',
'staff_name', 1, 1, 'MANAGER,SUPPORT', GETDATE(), GETDATE());

-- 6. Thong bao chung cho nhom
IF NOT EXISTS (SELECT 1 FROM email_templates WHERE template_code = 'TEAM_ANNOUNCE')
INSERT INTO email_templates (template_code, template_name, category, subject, body_html, description, available_variables, is_active, is_default, allowed_roles, created_at, updated_at)
VALUES ('TEAM_ANNOUNCE', N'Thông báo chung cho nhóm', 'Internal',
N'Thông báo từ quản lý',
N'<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;"><div style="background: #4f46e5; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0;"><h2 style="margin: 0;">Thông báo</h2><p style="margin: 5px 0 0; opacity: 0.9;">Thông tin quan trọng từ quản lý</p></div><div style="padding: 24px; border: 1px solid #e5e7eb; border-top: none; border-radius: 0 0 8px 8px;"><p>Xin chào <strong>{staff_name}</strong>,</p><p>Đây là thông báo chung từ bộ phận quản lý. Vui lòng đọc kỹ và thực hiện theo hướng dẫn.</p><div style="background: #eef2ff; border: 1px solid #4f46e5; border-radius: 6px; padding: 16px; margin: 16px 0;"><p style="margin: 0; color: #3730a3;">Nếu có thắc mắc, vui lòng liên hệ trực tiếp với quản lý của bạn.</p></div><p>Trân trọng,<br><strong>Quản lý CRM</strong></p></div></div>',
N'Mẫu thông báo chung gửi cho toàn bộ nhân viên',
'staff_name', 1, 1, 'MANAGER', GETDATE(), GETDATE());

-- 7. Theo doi lead
IF NOT EXISTS (SELECT 1 FROM email_templates WHERE template_code = 'LEAD_FOLLOWUP')
INSERT INTO email_templates (template_code, template_name, category, subject, body_html, description, available_variables, is_active, is_default, allowed_roles, created_at, updated_at)
VALUES ('LEAD_FOLLOWUP', N'Theo dõi lead', 'Lead',
N'Cảm ơn {lead_name} - Chúng tôi muốn kết nối với bạn',
N'<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;"><div style="background: #16a34a; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0;"><h2 style="margin: 0;">Kết nối</h2><p style="margin: 5px 0 0; opacity: 0.9;">Chúng tôi muốn hỗ trợ bạn</p></div><div style="padding: 24px; border: 1px solid #e5e7eb; border-top: none; border-radius: 0 0 8px 8px;"><p>Xin chào <strong>{lead_name}</strong>,</p><p>Cảm ơn bạn đã quan tâm đến dịch vụ của chúng tôi. Chúng tôi muốn kết nối để tìm hiểu thêm về nhu cầu của bạn và xem có thể hỗ trợ bạn như thế nào.</p><p>Bạn có thể liên hệ với chúng tôi bất cứ lúc nào hoặc phản hồi email này để được tư vấn chi tiết.</p><p>Rất mong được hợp tác cùng bạn!</p><p>Trân trọng,<br><strong>CRM System</strong></p></div></div>',
N'Email theo dõi gửi cho lead tiềm năng',
'lead_name', 1, 1, 'MANAGER,SALES', GETDATE(), GETDATE());

-- 8. Cam on khach hang
IF NOT EXISTS (SELECT 1 FROM email_templates WHERE template_code = 'CUSTOMER_THANKYOU')
INSERT INTO email_templates (template_code, template_name, category, subject, body_html, description, available_variables, is_active, is_default, allowed_roles, created_at, updated_at)
VALUES ('CUSTOMER_THANKYOU', N'Cảm ơn khách hàng', 'Customer',
N'Cảm ơn {customer_name} đã đồng hành cùng chúng tôi!',
N'<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;"><div style="background: #be185d; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0;"><h2 style="margin: 0;">Cảm ơn bạn!</h2><p style="margin: 5px 0 0; opacity: 0.9;">Sự tin tưởng của bạn là động lực của chúng tôi</p></div><div style="padding: 24px; border: 1px solid #e5e7eb; border-top: none; border-radius: 0 0 8px 8px;"><p>Xin chào <strong>{customer_name}</strong>,</p><p>Chúng tôi xin chân thành cảm ơn bạn đã tin tưởng và đồng hành cùng chúng tôi trong thời gian qua.</p><p>Sự hài lòng của bạn là ưu tiên hàng đầu của chúng tôi. Nếu bạn cần bất kỳ hỗ trợ nào, đừng ngần ngại liên hệ.</p><div style="background: #fdf2f8; border: 1px solid #be185d; border-radius: 6px; padding: 16px; margin: 16px 0;"><p style="margin: 0; color: #9d174d;">Chúng tôi luôn sẵn sàng lắng nghe và phục vụ bạn tốt hơn!</p></div><p>Trân trọng,<br><strong>CRM System</strong></p></div></div>',
N'Email cảm ơn gửi cho khách hàng',
'customer_name', 1, 1, 'MANAGER,SALES,SUPPORT', GETDATE(), GETDATE());

PRINT 'Done! Inserted new email templates.';
