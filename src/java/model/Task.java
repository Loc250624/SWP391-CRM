package model;

import enums.Priority;
import enums.TaskStatus;
import java.sql.Date;
import java.sql.Timestamp;

public class Task {
    private int taskId;
    private String title;
    private String description;
    private int assigneeId;
    private Date dueDate;
    private Priority priority;
    private TaskStatus status;
    private int createdBy;
    private Timestamp createdAt;
    private String relatedToEntityType;
    private int relatedToEntityId;

    public Task() {
    }

    public Task(int taskId, String title, String description, int assigneeId, Date dueDate, Priority priority, TaskStatus status, int createdBy, Timestamp createdAt, String relatedToEntityType, int relatedToEntityId) {
        this.taskId = taskId;
        this.title = title;
        this.description = description;
        this.assigneeId = assigneeId;
        this.dueDate = dueDate;
        this.priority = priority;
        this.status = status;
        this.createdBy = createdBy;
        this.createdAt = createdAt;
        this.relatedToEntityType = relatedToEntityType;
        this.relatedToEntityId = relatedToEntityId;
    }

    // Getters and Setters for all fields

    public int getTaskId() { return taskId; }
    public void setTaskId(int taskId) { this.taskId = taskId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public int getAssigneeId() { return assigneeId; }
    public void setAssigneeId(int assigneeId) { this.assigneeId = assigneeId; }
    public Date getDueDate() { return dueDate; }
    public void setDueDate(Date dueDate) { this.dueDate = dueDate; }
    public Priority getPriority() { return priority; }
    public void setPriority(Priority priority) { this.priority = priority; }
    public TaskStatus getStatus() { return status; }
    public void setStatus(TaskStatus status) { this.status = status; }
    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public String getRelatedToEntityType() { return relatedToEntityType; }
    public void setRelatedToEntityType(String relatedToEntityType) { this.relatedToEntityType = relatedToEntityType; }
    public int getRelatedToEntityId() { return relatedToEntityId; }
    public void setRelatedToEntityId(int relatedToEntityId) { this.relatedToEntityId = relatedToEntityId; }
}