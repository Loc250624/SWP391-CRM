-- =====================================================
-- Table: system_settings (key-value for app config)
-- =====================================================

CREATE TABLE system_settings (
    setting_key   VARCHAR(100)   NOT NULL PRIMARY KEY,
    setting_value NVARCHAR(500)  NULL,
    description   NVARCHAR(255)  NULL,
    updated_by    INT            NULL,
    updated_at    DATETIME2      DEFAULT GETDATE()
);

-- Seed default SMTP config (empty values)
INSERT INTO system_settings (setting_key, setting_value, description) VALUES
('smtp_host',       'smtp.gmail.com',  N'SMTP server host'),
('smtp_port',       '587',             N'SMTP server port'),
('smtp_tls',        'true',            N'Enable STARTTLS'),
('smtp_ssl',        'false',           N'Enable SSL'),
('smtp_username',   '',                N'SMTP username / email'),
('smtp_password',   '',                N'SMTP password / app password'),
('smtp_from_email', '',                N'Default sender email'),
('smtp_from_name',  'CRM System',      N'Default sender display name');
