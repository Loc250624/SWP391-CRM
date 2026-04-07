package model;

import java.time.LocalDateTime;

public class Notification {

    private int notificationId;
    private String notificationCode;
    private String title;
    private String message;
    private String summary;
    private String type;
    private String category;
    private String priority;
    private String relatedType;
    private Integer relatedId;
    private String actionUrl;
    private Integer senderId;
    private boolean isSystem;
    private String targetType;
    private String targetValue;
    private LocalDateTime scheduledAt;
    private boolean isSent;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Notification() {
    }

    public Notification(int notificationId, String notificationCode, String title, String message,
            String summary, String type, String category, String priority,
            String relatedType, Integer relatedId, String actionUrl,
            Integer senderId, boolean isSystem, String targetType, String targetValue,
            LocalDateTime scheduledAt, boolean isSent,
            LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.notificationId = notificationId;
        this.notificationCode = notificationCode;
        this.title = title;
        this.message = message;
        this.summary = summary;
        this.type = type;
        this.category = category;
        this.priority = priority;
        this.relatedType = relatedType;
        this.relatedId = relatedId;
        this.actionUrl = actionUrl;
        this.senderId = senderId;
        this.isSystem = isSystem;
        this.targetType = targetType;
        this.targetValue = targetValue;
        this.scheduledAt = scheduledAt;
        this.isSent = isSent;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public String getTypeVietnamese() {
        try {
            return enums.NotificationType.valueOf(type).getVietnamese();
        } catch (Exception e) {
            return type;
        }
    }

    public String getCategoryVietnamese() {
        try {
            return enums.NotificationCategory.valueOf(category).getVietnamese();
        } catch (Exception e) {
            return category;
        }
    }

    public String getPriorityVietnamese() {
        try {
            return enums.NotificationPriority.valueOf(priority).getVietnamese();
        } catch (Exception e) {
            return priority;
        }
    }

    public int getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }

    public String getNotificationCode() {
        return notificationCode;
    }

    public void setNotificationCode(String notificationCode) {
        this.notificationCode = notificationCode;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public String getRelatedType() {
        return relatedType;
    }

    public void setRelatedType(String relatedType) {
        this.relatedType = relatedType;
    }

    public Integer getRelatedId() {
        return relatedId;
    }

    public void setRelatedId(Integer relatedId) {
        this.relatedId = relatedId;
    }

    public String getActionUrl() {
        return actionUrl;
    }

    public void setActionUrl(String actionUrl) {
        this.actionUrl = actionUrl;
    }

    public Integer getSenderId() {
        return senderId;
    }

    public void setSenderId(Integer senderId) {
        this.senderId = senderId;
    }

    public boolean getIsSystem() {
        return isSystem;
    }

    public void setIsSystem(boolean isSystem) {
        this.isSystem = isSystem;
    }

    public String getTargetType() {
        return targetType;
    }

    public void setTargetType(String targetType) {
        this.targetType = targetType;
    }

    public String getTargetValue() {
        return targetValue;
    }

    public void setTargetValue(String targetValue) {
        this.targetValue = targetValue;
    }

    public LocalDateTime getScheduledAt() {
        return scheduledAt;
    }

    public void setScheduledAt(LocalDateTime scheduledAt) {
        this.scheduledAt = scheduledAt;
    }

    public boolean getIsSent() {
        return isSent;
    }

    public void setIsSent(boolean isSent) {
        this.isSent = isSent;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
