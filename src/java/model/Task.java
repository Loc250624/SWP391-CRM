package model;

import enums.Priority;
import enums.TaskStatus;
import java.time.LocalDateTime;

public class Task {

    private Integer taskId;
    public String taskCode;
    public String title;
    public String description;

    public Integer priority; 
    public Integer status;  

    public String relatedType;
    public Integer relatedId;
    public Integer assignedTo;
    public Integer groupTaskId;

    public LocalDateTime dueDate;
    public LocalDateTime reminderAt;
    public LocalDateTime completedAt;

    public Boolean isDeleted;
    public LocalDateTime deletedAt;
    public Integer deletedBy;

    public LocalDateTime createdAt;
    public LocalDateTime updatedAt;
    public Integer createdBy;

    public Task() {
    }


    public String getPriorityName() {
        if (priority == null) return null;
        Priority[] values = Priority.values();
        if (priority < 0 || priority >= values.length) return null;
        return values[priority].name();
    }

    public String getPriorityVietnamese() {
        String name = getPriorityName();
        if (name == null) return "";
        switch (name) {
            case "HIGH":   return "Cao";
            case "MEDIUM": return "Trung bình";
            case "LOW":    return "Thấp";
            default:       return name;
        }
    }

    public String getStatusName() {
        if (status == null) return null;
        TaskStatus[] values = TaskStatus.values();
        if (status < 0 || status >= values.length) return null;
        return values[status].name();
    }

    public String getStatusVietnamese() {
        String name = getStatusName();
        if (name == null) return "";
        switch (name) {
            case "PENDING":     return "Chờ xử lý";
            case "IN_PROGRESS": return "Đang thực hiện";
            case "COMPLETED":   return "Hoàn thành";
            case "CANCELLED":   return "Đã hủy";
            default:            return name;
        }
    }



    public Integer getTaskId() { return taskId; }
    public void setTaskId(Integer taskId) { this.taskId = taskId; }

    public String getTaskCode() { return taskCode; }
    public void setTaskCode(String taskCode) { this.taskCode = taskCode; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Integer getPriority() { return priority; }
    public void setPriority(Integer priority) { this.priority = priority; }

    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }

    public String getRelatedType() { return relatedType; }
    public void setRelatedType(String relatedType) { this.relatedType = relatedType; }

    public Integer getRelatedId() { return relatedId; }
    public void setRelatedId(Integer relatedId) { this.relatedId = relatedId; }

    public Integer getAssignedTo() { return assignedTo; }
    public void setAssignedTo(Integer assignedTo) { this.assignedTo = assignedTo; }

    public Integer getGroupTaskId() { return groupTaskId; }
    public void setGroupTaskId(Integer groupTaskId) { this.groupTaskId = groupTaskId; }

    public LocalDateTime getDueDate() { return dueDate; }
    public void setDueDate(LocalDateTime dueDate) { this.dueDate = dueDate; }

    public LocalDateTime getReminderAt() { return reminderAt; }
    public void setReminderAt(LocalDateTime reminderAt) { this.reminderAt = reminderAt; }

    public LocalDateTime getCompletedAt() { return completedAt; }
    public void setCompletedAt(LocalDateTime completedAt) { this.completedAt = completedAt; }

    public Boolean getIsDeleted() { return isDeleted; }
    public void setIsDeleted(Boolean isDeleted) { this.isDeleted = isDeleted; }

    public LocalDateTime getDeletedAt() { return deletedAt; }
    public void setDeletedAt(LocalDateTime deletedAt) { this.deletedAt = deletedAt; }

    public Integer getDeletedBy() { return deletedBy; }
    public void setDeletedBy(Integer deletedBy) { this.deletedBy = deletedBy; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public Integer getCreatedBy() { return createdBy; }
    public void setCreatedBy(Integer createdBy) { this.createdBy = createdBy; }
}
