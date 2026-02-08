package model;

import java.time.LocalDateTime;

public class Pipeline {

    public int pipelineId;
    public String pipelineCode;
    public String pipelineName;
    public String description;    // nullable
    public boolean isDefault;
    public boolean isActive;
    public LocalDateTime createdAt;
    public Integer createdBy;     // nullable FK users

    public Pipeline() {
    }

    public Pipeline(int pipelineId, String pipelineCode, String pipelineName, String description, boolean isDefault, boolean isActive, LocalDateTime createdAt, Integer createdBy) {
        this.pipelineId = pipelineId;
        this.pipelineCode = pipelineCode;
        this.pipelineName = pipelineName;
        this.description = description;
        this.isDefault = isDefault;
        this.isActive = isActive;
        this.createdAt = createdAt;
        this.createdBy = createdBy;
    }

    public int getPipelineId() {
        return pipelineId;
    }

    public void setPipelineId(int pipelineId) {
        this.pipelineId = pipelineId;
    }

    public String getPipelineCode() {
        return pipelineCode;
    }

    public void setPipelineCode(String pipelineCode) {
        this.pipelineCode = pipelineCode;
    }

    public String getPipelineName() {
        return pipelineName;
    }

    public void setPipelineName(String pipelineName) {
        this.pipelineName = pipelineName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isIsDefault() {
        return isDefault;
    }

    public void setIsDefault(boolean isDefault) {
        this.isDefault = isDefault;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
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
