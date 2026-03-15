package model;

import java.time.LocalDateTime;

public class NotificationRecipient {

    private int id;
    private int notificationId;
    private int userId;
    private boolean isRead;
    private LocalDateTime readAt;
    private boolean isDismissed;
    private LocalDateTime dismissedAt;
    private String channel;
    private String deliveryStatus;
    private LocalDateTime deliveredAt;
    private LocalDateTime createdAt;

    public NotificationRecipient() {
    }

    public NotificationRecipient(int id, int notificationId, int userId, boolean isRead,
            LocalDateTime readAt, boolean isDismissed, LocalDateTime dismissedAt,
            String channel, String deliveryStatus, LocalDateTime deliveredAt,
            LocalDateTime createdAt) {
        this.id = id;
        this.notificationId = notificationId;
        this.userId = userId;
        this.isRead = isRead;
        this.readAt = readAt;
        this.isDismissed = isDismissed;
        this.dismissedAt = dismissedAt;
        this.channel = channel;
        this.deliveryStatus = deliveryStatus;
        this.deliveredAt = deliveredAt;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public boolean getIsRead() {
        return isRead;
    }

    public void setIsRead(boolean isRead) {
        this.isRead = isRead;
    }

    public LocalDateTime getReadAt() {
        return readAt;
    }

    public void setReadAt(LocalDateTime readAt) {
        this.readAt = readAt;
    }

    public boolean getIsDismissed() {
        return isDismissed;
    }

    public void setIsDismissed(boolean isDismissed) {
        this.isDismissed = isDismissed;
    }

    public LocalDateTime getDismissedAt() {
        return dismissedAt;
    }

    public void setDismissedAt(LocalDateTime dismissedAt) {
        this.dismissedAt = dismissedAt;
    }

    public String getChannel() {
        return channel;
    }

    public void setChannel(String channel) {
        this.channel = channel;
    }

    public String getDeliveryStatus() {
        return deliveryStatus;
    }

    public void setDeliveryStatus(String deliveryStatus) {
        this.deliveryStatus = deliveryStatus;
    }

    public LocalDateTime getDeliveredAt() {
        return deliveredAt;
    }

    public void setDeliveredAt(LocalDateTime deliveredAt) {
        this.deliveredAt = deliveredAt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
