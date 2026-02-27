package model;

import java.time.LocalDateTime;

public class TaskRelation {

    private Integer id;
    public Integer taskId;
    public String relatedType;
    public Integer relatedId;
    public LocalDateTime createdAt;
    public Integer createdBy;

    public TaskRelation() {
    }

    public TaskRelation(Integer id, Integer taskId, String relatedType, Integer relatedId, LocalDateTime createdAt, Integer createdBy) {
        this.id = id;
        this.taskId = taskId;
        this.relatedType = relatedType;
        this.relatedId = relatedId;
        this.createdAt = createdAt;
        this.createdBy = createdBy;
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
