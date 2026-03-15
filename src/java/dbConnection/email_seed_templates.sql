-- =====================================================
-- Seed data: Default email templates
-- Run this AFTER the email_templates table exists
-- =====================================================

-- 1. Quotation Send Email
INSERT INTO email_templates (template_code, template_name, category, subject, body_html, body_text, description, available_variables, is_active, is_default, created_by)
VALUES (
    'QUOT_SEND',
    N'Gửi báo giá cho khách hàng',
    'Quotation',
    N'Báo giá {quotation_code} từ CRM System',
    N'<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
    <div style="background: #2563eb; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0;">
        <h2 style="margin: 0;">Báo giá</h2>
        <p style="margin: 5px 0 0; opacity: 0.9;">{quotation_code}</p>
    </div>
    <div style="padding: 24px; border: 1px solid #e5e7eb; border-top: none; border-radius: 0 0 8px 8px;">
        <p>Xin chào <strong>{customer_name}</strong>,</p>
        <p>Cảm ơn bạn đã quan tâm đến dịch vụ của chúng tôi. Dưới đây là thông tin báo giá:</p>
        <table style="width: 100%; border-collapse: collapse; margin: 16px 0;">
            <tr style="background: #f9fafb;">
                <td style="padding: 10px; border: 1px solid #e5e7eb;"><strong>Mã báo giá</strong></td>
                <td style="padding: 10px; border: 1px solid #e5e7eb;">{quotation_code}</td>
            </tr>
            <tr>
                <td style="padding: 10px; border: 1px solid #e5e7eb;"><strong>Tổng giá trị</strong></td>
                <td style="padding: 10px; border: 1px solid #e5e7eb;">{total_amount} {currency}</td>
            </tr>
            <tr style="background: #f9fafb;">
                <td style="padding: 10px; border: 1px solid #e5e7eb;"><strong>Hiệu lực đến</strong></td>
                <td style="padding: 10px; border: 1px solid #e5e7eb;">{valid_until}</td>
            </tr>
        </table>
        <p>Vui lòng liên hệ với chúng tôi nếu bạn có bất kỳ câu hỏi nào.</p>
        <p>Trân trọng,<br><strong>CRM System</strong></p>
    </div>
</div>',
    N'Xin chào {customer_name}, Báo giá {quotation_code} - Tổng: {total_amount} {currency} - Hiệu lực đến: {valid_until}. Vui lòng liên hệ nếu có câu hỏi.',
    N'Email tự động gửi khi báo giá được gửi đến khách hàng',
    'customer_name, quotation_code, total_amount, currency, valid_until',
    1, 1, 1
);

-- 2. Quotation Expiring Reminder
INSERT INTO email_templates (template_code, template_name, category, subject, body_html, body_text, description, available_variables, is_active, is_default, created_by)
VALUES (
    'QUOT_REMIND',
    N'Nhắc nhở báo giá sắp hết hạn',
    'Quotation',
    N'Báo giá {quotation_code} sắp hết hiệu lực',
    N'<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
    <div style="background: #f59e0b; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0;">
        <h2 style="margin: 0;">Nhắc nhở báo giá</h2>
        <p style="margin: 5px 0 0; opacity: 0.9;">Sắp hết hiệu lực</p>
    </div>
    <div style="padding: 24px; border: 1px solid #e5e7eb; border-top: none; border-radius: 0 0 8px 8px;">
        <p>Xin chào <strong>{customer_name}</strong>,</p>
        <p>Chúng tôi muốn nhắc bạn rằng báo giá <strong>{quotation_code}</strong> sẽ hết hiệu lực vào ngày <strong>{valid_until}</strong>.</p>
        <div style="background: #fffbeb; border: 1px solid #f59e0b; border-radius: 6px; padding: 16px; margin: 16px 0;">
            <p style="margin: 0; color: #92400e;"><strong>Tổng giá trị:</strong> {total_amount} VND</p>
            <p style="margin: 8px 0 0; color: #92400e;"><strong>Hết hạn:</strong> {valid_until}</p>
        </div>
        <p>Nếu bạn vẫn quan tâm, vui lòng phản hồi sớm để chúng tôi có thể tiếp tục hỗ trợ.</p>
        <p>Trân trọng,<br><strong>CRM System</strong></p>
    </div>
</div>',
    N'Xin chào {customer_name}, Báo giá {quotation_code} sẽ hết hiệu lực vào {valid_until}. Tổng giá trị: {total_amount}. Vui lòng phản hồi sớm.',
    N'Email nhắc nhở tự động khi báo giá sắp hết hiệu lực',
    'customer_name, quotation_code, total_amount, valid_until',
    1, 1, 1
);

-- 3. Customer Welcome Email
INSERT INTO email_templates (template_code, template_name, category, subject, body_html, body_text, description, available_variables, is_active, is_default, created_by)
VALUES (
    'CUSTOMER_WELCOME',
    N'Chào mừng khách hàng mới',
    'Customer',
    N'Chào mừng {customer_name} - Cảm ơn bạn đã tin tưởng!',
    N'<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
    <div style="background: #059669; color: white; padding: 24px; text-align: center; border-radius: 8px 8px 0 0;">
        <h2 style="margin: 0;">Chào mừng bạn!</h2>
        <p style="margin: 5px 0 0; opacity: 0.9;">Cảm ơn đã trở thành khách hàng của chúng tôi</p>
    </div>
    <div style="padding: 24px; border: 1px solid #e5e7eb; border-top: none; border-radius: 0 0 8px 8px;">
        <p>Xin chào <strong>{customer_name}</strong>,</p>
        <p>Chúng tôi rất vui được chào đón bạn trở thành khách hàng của chúng tôi!</p>
        <p>Mã khách hàng của bạn là: <strong>{customer_code}</strong></p>
        <div style="background: #ecfdf5; border-radius: 6px; padding: 16px; margin: 16px 0;">
            <p style="margin: 0; color: #065f46;"><strong>Bạn sẽ nhận được:</strong></p>
            <ul style="color: #065f46; margin: 8px 0 0; padding-left: 20px;">
                <li>Hỗ trợ chuyên nghiệp từ đội ngũ của chúng tôi</li>
                <li>Thông tin cập nhật về sản phẩm và dịch vụ mới</li>
                <li>Ưu đãi đặc biệt dành riêng cho khách hàng</li>
            </ul>
        </div>
        <p>Nếu bạn cần hỗ trợ, đừng ngần ngại liên hệ với chúng tôi.</p>
        <p>Trân trọng,<br><strong>CRM System</strong></p>
    </div>
</div>',
    N'Xin chào {customer_name}, Chào mừng bạn trở thành khách hàng! Mã KH: {customer_code}. Liên hệ chúng tôi nếu cần hỗ trợ.',
    N'Email chào mừng tự động gửi khi tạo khách hàng mới',
    'customer_name, customer_code',
    1, 1, 1
);
