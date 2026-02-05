package model;

import java.time.LocalDateTime;

public class LeadSource {
    public int sourceId;
    public String sourceCode;     // WEBSITE/FACEBOOK/...
    public String sourceName;
    public String description;    // nullable
    public boolean isActive;
    public LocalDateTime createdAt;

    public LeadSource() {}

    public LeadSource(int sourceId, String sourceCode, String sourceName, String description, boolean isActive, LocalDateTime createdAt) {
        this.sourceId = sourceId;
        this.sourceCode = sourceCode;
        this.sourceName = sourceName;
        this.description = description;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }

    public int getSourceId() {
        return sourceId;
    }

    public void setSourceId(int sourceId) {
        this.sourceId = sourceId;
    }

    public String getSourceCode() {
        return sourceCode;
    }

    public void setSourceCode(String sourceCode) {
        this.sourceCode = sourceCode;
    }

    public String getSourceName() {
        return sourceName;
    }

    public void setSourceName(String sourceName) {
        this.sourceName = sourceName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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
    
}
