-- =====================================================
-- Add allowed_roles column to email_templates
-- Controls which roles can use each template
-- NULL or empty = all roles can use (Manager always has access)
-- =====================================================

ALTER TABLE email_templates ADD allowed_roles VARCHAR(200) NULL;

-- Quotation templates: only SALES and MANAGER
UPDATE email_templates SET allowed_roles = 'SALES,MANAGER' WHERE category = 'Quotation';

-- Customer templates: SALES and MANAGER
UPDATE email_templates SET allowed_roles = 'SALES,MANAGER' WHERE category = 'Customer';

-- Lead templates: SALES and MANAGER
UPDATE email_templates SET allowed_roles = 'SALES,MANAGER' WHERE category = 'Lead';

-- Ticket/Support templates: SUPPORT and MANAGER
UPDATE email_templates SET allowed_roles = 'SUPPORT,MANAGER' WHERE category = 'Ticket';

-- Campaign templates: MANAGER only
UPDATE email_templates SET allowed_roles = 'MANAGER' WHERE category = 'Campaign';

-- General templates: all roles
UPDATE email_templates SET allowed_roles = NULL WHERE category = 'General';
