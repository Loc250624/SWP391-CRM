package model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class Campaign {
    public int campaignId;
    public String campaignCode;
    public String campaignName;
    public String campaignType;       // email/facebook/google/...
    public String status;             // Draft/Active/...
    public String description;        // nullable (nvarchar(max))
    public LocalDate startDate;       // nullable
    public LocalDate endDate;         // nullable
    public BigDecimal budget;         // nullable
    public BigDecimal actualCost;     // nullable
    public Integer targetLeads;       // nullable
    public Integer ownerId;           // nullable FK users
    public LocalDateTime createdAt;
    public LocalDateTime updatedAt;
    public Integer createdBy;         // nullable FK users

    public Campaign() {}

    public Campaign(int campaignId, String campaignCode, String campaignName, String campaignType, String status, String description, LocalDate startDate, LocalDate endDate, BigDecimal budget, BigDecimal actualCost, Integer targetLeads, Integer ownerId, LocalDateTime createdAt, LocalDateTime updatedAt, Integer createdBy) {
        this.campaignId = campaignId;
        this.campaignCode = campaignCode;
        this.campaignName = campaignName;
        this.campaignType = campaignType;
        this.status = status;
        this.description = description;
        this.startDate = startDate;
        this.endDate = endDate;
        this.budget = budget;
        this.actualCost = actualCost;
        this.targetLeads = targetLeads;
        this.ownerId = ownerId;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.createdBy = createdBy;
    }

    public int getCampaignId() {
        return campaignId;
    }

    public void setCampaignId(int campaignId) {
        this.campaignId = campaignId;
    }

    public String getCampaignCode() {
        return campaignCode;
    }

    public void setCampaignCode(String campaignCode) {
        this.campaignCode = campaignCode;
    }

    public String getCampaignName() {
        return campaignName;
    }

    public void setCampaignName(String campaignName) {
        this.campaignName = campaignName;
    }

    public String getCampaignType() {
        return campaignType;
    }

    public void setCampaignType(String campaignType) {
        this.campaignType = campaignType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public BigDecimal getBudget() {
        return budget;
    }

    public void setBudget(BigDecimal budget) {
        this.budget = budget;
    }

    public BigDecimal getActualCost() {
        return actualCost;
    }

    public void setActualCost(BigDecimal actualCost) {
        this.actualCost = actualCost;
    }

    public Integer getTargetLeads() {
        return targetLeads;
    }

    public void setTargetLeads(Integer targetLeads) {
        this.targetLeads = targetLeads;
    }

    public Integer getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(Integer ownerId) {
        this.ownerId = ownerId;
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

    public Integer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Integer createdBy) {
        this.createdBy = createdBy;
    }
    
}
