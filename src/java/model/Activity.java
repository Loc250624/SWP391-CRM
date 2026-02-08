/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;

/**
 *
 * @author hello
 */
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

    public Activity() {
    }

    public Activity(int activityId, String activityType, String relatedType, int relatedId, String subject, String description, LocalDateTime activityDate, Integer durationMinutes, String callDirection, String callResult, Integer performedBy, LocalDateTime createdAt, Integer createdBy) {
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
    }

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

}
