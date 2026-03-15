USE [CRM_System]
GO

-- ============================================================
-- BANG 1: notifications (master - luu noi dung thong bao)
-- ============================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'notifications')
BEGIN
    CREATE TABLE [dbo].[notifications] (
        [notification_id]   INT IDENTITY(1,1)   NOT NULL,
        [notification_code] NVARCHAR(20)        NULL,

        -- Noi dung
        [title]             NVARCHAR(200)       NOT NULL,
        [message]           NVARCHAR(MAX)       NULL,
        [summary]           NVARCHAR(500)       NULL,

        -- Phan loai
        [type]              NVARCHAR(50)        NOT NULL,
        [category]          NVARCHAR(50)        NULL,
        [priority]          NVARCHAR(20)        DEFAULT 'NORMAL',

        -- Lien ket doi tuong
        [related_type]      NVARCHAR(50)        NULL,
        [related_id]        INT                 NULL,
        [action_url]        NVARCHAR(500)       NULL,

        -- Nguoi gui / nguon
        [sender_id]         INT                 NULL,
        [is_system]         BIT                 DEFAULT 0,

        -- Broadcast / Scheduling
        [target_type]       NVARCHAR(50)        DEFAULT 'INDIVIDUAL',
        [target_value]      NVARCHAR(200)       NULL,
        [scheduled_at]      DATETIME2           NULL,
        [is_sent]           BIT                 DEFAULT 1,

        -- Audit
        [created_at]        DATETIME2           DEFAULT GETDATE(),
        [updated_at]        DATETIME2           NULL,

        CONSTRAINT [PK_notifications] PRIMARY KEY CLUSTERED ([notification_id]),
        CONSTRAINT [FK_notifications_sender] FOREIGN KEY ([sender_id]) REFERENCES [dbo].[users]([user_id])
    );

    PRINT N'Created table: notifications';
END
GO

-- Index: loc theo type + thoi gian
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_notifications_type_created')
BEGIN
    CREATE NONCLUSTERED INDEX [IX_notifications_type_created]
        ON [dbo].[notifications] ([type], [created_at] DESC);
END
GO

-- Index: tim thong bao lien quan den entity cu the
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_notifications_related')
BEGIN
    CREATE NONCLUSTERED INDEX [IX_notifications_related]
        ON [dbo].[notifications] ([related_type], [related_id]);
END
GO

-- Index: loc theo sender
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_notifications_sender')
BEGIN
    CREATE NONCLUSTERED INDEX [IX_notifications_sender]
        ON [dbo].[notifications] ([sender_id], [created_at] DESC);
END
GO

-- ============================================================
-- BANG 2: notification_recipients (per-user - trang thai doc)
-- ============================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'notification_recipients')
BEGIN
    CREATE TABLE [dbo].[notification_recipients] (
        [id]                INT IDENTITY(1,1)   NOT NULL,
        [notification_id]   INT                 NOT NULL,
        [user_id]           INT                 NOT NULL,

        -- Trang thai
        [is_read]           BIT                 DEFAULT 0,
        [read_at]           DATETIME2           NULL,
        [is_dismissed]      BIT                 DEFAULT 0,
        [dismissed_at]      DATETIME2           NULL,

        -- Delivery
        [channel]           NVARCHAR(20)        DEFAULT 'IN_APP',
        [delivery_status]   NVARCHAR(20)        DEFAULT 'SENT',
        [delivered_at]      DATETIME2           NULL,

        [created_at]        DATETIME2           DEFAULT GETDATE(),

        CONSTRAINT [PK_notification_recipients] PRIMARY KEY CLUSTERED ([id]),
        CONSTRAINT [FK_notif_recipients_notification] FOREIGN KEY ([notification_id])
            REFERENCES [dbo].[notifications]([notification_id]) ON DELETE CASCADE,
        CONSTRAINT [FK_notif_recipients_user] FOREIGN KEY ([user_id])
            REFERENCES [dbo].[users]([user_id])
    );

    PRINT N'Created table: notification_recipients';
END
GO

-- Index QUAN TRONG NHAT: dropdown chuong - lay thong bao chua doc cua user
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_notif_recipients_user_unread')
BEGIN
    CREATE NONCLUSTERED INDEX [IX_notif_recipients_user_unread]
        ON [dbo].[notification_recipients] ([user_id], [is_read], [is_dismissed])
        INCLUDE ([notification_id], [read_at], [created_at]);
END
GO

-- Index: dem nhanh so chua doc (badge so do tren chuong)
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_notif_recipients_unread_count')
BEGIN
    CREATE NONCLUSTERED INDEX [IX_notif_recipients_unread_count]
        ON [dbo].[notification_recipients] ([user_id], [is_read])
        WHERE [is_read] = 0 AND [is_dismissed] = 0;
END
GO

-- Unique: moi user chi nhan 1 thong bao 1 lan tren 1 channel
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'UQ_notif_recipient_channel')
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX [UQ_notif_recipient_channel]
        ON [dbo].[notification_recipients] ([notification_id], [user_id], [channel]);
END
GO

-- ============================================================
-- AUTO-GENERATE notification_code (trigger)
-- ============================================================
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_notifications_auto_code')
    DROP TRIGGER [dbo].[TR_notifications_auto_code];
GO

CREATE TRIGGER [dbo].[TR_notifications_auto_code]
ON [dbo].[notifications]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE n
    SET n.notification_code = 'NT-' + RIGHT('00000' + CAST(i.notification_id AS VARCHAR(5)), 5)
    FROM [dbo].[notifications] n
    INNER JOIN inserted i ON n.notification_id = i.notification_id
    WHERE n.notification_code IS NULL;
END
GO

PRINT N'=== Notification tables created successfully ===';
GO
