/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;

public class TaskAssignee {

    private Integer id;
    public Integer taskId;
    public Integer userId;
    public String role;
    public Integer taskStatus;
    public LocalDateTime acceptedAt;
    public String declineReason;
    public Integer progress;
    public Integer assignedBy;
    public LocalDateTime assignedAt;

    public TaskAssignee() {
    }

    public TaskAssignee(Integer id, Integer taskId, Integer userId, String role, Integer taskStatus, LocalDateTime acceptedAt, String declineReason, Integer progress, Integer assignedBy, LocalDateTime assignedAt) {
        this.id = id;
        this.taskId = taskId;
        this.userId = userId;
        this.role = role;
        this.taskStatus = taskStatus;
        this.acceptedAt = acceptedAt;
        this.declineReason = declineReason;
        this.progress = progress;
        this.assignedBy = assignedBy;
        this.assignedAt = assignedAt;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getTaskId() {
        return taskId;
    }

    public void setTaskId(Integer taskId) {
        this.taskId = taskId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Integer getTaskStatus() {
        return taskStatus;
    }

    public void setTaskStatus(Integer taskStatus) {
        this.taskStatus = taskStatus;
    }

    public LocalDateTime getAcceptedAt() {
        return acceptedAt;
    }

    public void setAcceptedAt(LocalDateTime acceptedAt) {
        this.acceptedAt = acceptedAt;
    }

    public String getDeclineReason() {
        return declineReason;
    }

    public void setDeclineReason(String declineReason) {
        this.declineReason = declineReason;
    }

    public Integer getProgress() {
        return progress;
    }

    public void setProgress(Integer progress) {
        this.progress = progress;
    }

    public Integer getAssignedBy() {
        return assignedBy;
    }

    public void setAssignedBy(Integer assignedBy) {
        this.assignedBy = assignedBy;
    }

    public LocalDateTime getAssignedAt() {
        return assignedAt;
    }

    public void setAssignedAt(LocalDateTime assignedAt) {
        this.assignedAt = assignedAt;
    }

}
