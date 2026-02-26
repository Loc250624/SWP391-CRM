package model;

import java.time.LocalDateTime;

public class Activity {

    public int activityId;
    public String activityType;
    public String relatedType;
    public int relatedId;
    public String subject;
    public String description;
    public LocalDateTime activityDate;
    public Integer durationMinutes;
    public String callDirection;
    public String callResult;
    public Integer performedBy;
    public LocalDateTime createdAt;
    public Integer createdBy;
    
    // THÊM MỚI: Trạng thái của báo cáo (Pending/Completed)
    public String status; 
    
    private String performerName;
    private String customerName;
    private String customerPhone;

    public Activity() {
    }

    // Cập nhật Constructor có tham số để bao gồm status
    public Activity(int activityId, String activityType, String relatedType, int relatedId, 
                    String subject, String description, LocalDateTime activityDate, 
                    Integer durationMinutes, String callDirection, String callResult, 
                    Integer performedBy, LocalDateTime createdAt, Integer createdBy, String status) {
        this.activityId = activityId;
        this.activityType = activityType;
        this.relatedType = relatedType;
        this.relatedId = relatedId;
        this.subject = subject;
        this.description = description;
        this.activityDate = activityDate;
        this.durationMinutes = durationMinutes;
        this.callDirection = callDirection;
        this.callResult = callResult;
        this.performedBy = performedBy;
        this.createdAt = createdAt;
        this.createdBy = createdBy;
        this.status = status; //
    }

    // --- GETTER VÀ SETTER CHO STATUS ---
    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // --- GIỮ NGUYÊN CÁC GETTER/SETTER CŨ ---
    public int getActivityId() {
        return activityId;
    }

    public void setActivityId(int activityId) {
        this.activityId = activityId;
    }

    public String getActivityType() {
        return activityType;
    }

    public void setActivityType(String activityType) {
        this.activityType = activityType;
    }

    public String getRelatedType() {
        return relatedType;
    }

    public void setRelatedType(String relatedType) {
        this.relatedType = relatedType;
    }

    public int getRelatedId() {
        return relatedId;
    }

    public void setRelatedId(int relatedId) {
        this.relatedId = relatedId;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDateTime getActivityDate() {
        return activityDate;
    }

    public void setActivityDate(LocalDateTime activityDate) {
        this.activityDate = activityDate;
    }

    public Integer getDurationMinutes() {
        return durationMinutes;
    }

    public void setDurationMinutes(Integer durationMinutes) {
        this.durationMinutes = durationMinutes;
    }

    public String getCallDirection() {
        return callDirection;
    }

    public void setCallDirection(String callDirection) {
        this.callDirection = callDirection;
    }

    public String getCallResult() {
        return callResult;
    }

    public void setCallResult(String callResult) {
        this.callResult = callResult;
    }

    public Integer getPerformedBy() {
        return performedBy;
    }

    public void setPerformedBy(Integer performedBy) {
        this.performedBy = performedBy;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public Integer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Integer createdBy) {
        this.createdBy = createdBy;
    }

    public String getPerformerName() {
        return performerName;
    }

    public void setPerformerName(String performerName) {
        this.performerName = performerName;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }
}