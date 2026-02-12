/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 *
 * @author hello
 */
public class Opportunity {

    public int opportunityId;
    public String opportunityCode;
    public String opportunityName;
    public Integer leadId;
    public Integer customerId;
    public int pipelineId;
    public int stageId;
    public BigDecimal estimatedValue;
    public int probability;
    public LocalDate expectedCloseDate;
    public LocalDate actualCloseDate;
    public String status;
    public String wonLostReason;
    public Integer sourceId;
    public Integer campaignId;
    public Integer ownerId;
    public String notes;
    public LocalDateTime createdAt;
    public LocalDateTime updatedAt;
    public Integer createdBy;

    public Opportunity() {
    }

    public Opportunity(int opportunityId, String opportunityCode, String opportunityName, Integer leadId, Integer customerId, int pipelineId, int stageId, BigDecimal estimatedValue, int probability, LocalDate expectedCloseDate, LocalDate actualCloseDate, String status, String wonLostReason, Integer sourceId, Integer campaignId, Integer ownerId, String notes, LocalDateTime createdAt, LocalDateTime updatedAt, Integer createdBy) {
        this.opportunityId = opportunityId;
        this.opportunityCode = opportunityCode;
        this.opportunityName = opportunityName;
        this.leadId = leadId;
        this.customerId = customerId;
        this.pipelineId = pipelineId;
        this.stageId = stageId;
        this.estimatedValue = estimatedValue;
        this.probability = probability;
        this.expectedCloseDate = expectedCloseDate;
        this.actualCloseDate = actualCloseDate;
        this.status = status;
        this.wonLostReason = wonLostReason;
        this.sourceId = sourceId;
        this.campaignId = campaignId;
        this.ownerId = ownerId;
        this.notes = notes;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.createdBy = createdBy;
    }

    public int getOpportunityId() {
        return opportunityId;
    }

    public void setOpportunityId(int opportunityId) {
        this.opportunityId = opportunityId;
    }

    public String getOpportunityCode() {
        return opportunityCode;
    }

    public void setOpportunityCode(String opportunityCode) {
        this.opportunityCode = opportunityCode;
    }

    public String getOpportunityName() {
        return opportunityName;
    }

    public void setOpportunityName(String opportunityName) {
        this.opportunityName = opportunityName;
    }

    public Integer getLeadId() {
        return leadId;
    }

    public void setLeadId(Integer leadId) {
        this.leadId = leadId;
    }

    public Integer getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Integer customerId) {
        this.customerId = customerId;
    }

    public int getPipelineId() {
        return pipelineId;
    }

    public void setPipelineId(int pipelineId) {
        this.pipelineId = pipelineId;
    }

    public int getStageId() {
        return stageId;
    }

    public void setStageId(int stageId) {
        this.stageId = stageId;
    }

    public BigDecimal getEstimatedValue() {
        return estimatedValue;
    }

    public void setEstimatedValue(BigDecimal estimatedValue) {
        this.estimatedValue = estimatedValue;
    }

    public int getProbability() {
        return probability;
    }

    public void setProbability(int probability) {
        this.probability = probability;
    }

    public LocalDate getExpectedCloseDate() {
        return expectedCloseDate;
    }

    public void setExpectedCloseDate(LocalDate expectedCloseDate) {
        this.expectedCloseDate = expectedCloseDate;
    }

    public LocalDate getActualCloseDate() {
        return actualCloseDate;
    }

    public void setActualCloseDate(LocalDate actualCloseDate) {
        this.actualCloseDate = actualCloseDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getWonLostReason() {
        return wonLostReason;
    }

    public void setWonLostReason(String wonLostReason) {
        this.wonLostReason = wonLostReason;
    }

    public Integer getSourceId() {
        return sourceId;
    }

    public void setSourceId(Integer sourceId) {
        this.sourceId = sourceId;
    }

    public Integer getCampaignId() {
        return campaignId;
    }

    public void setCampaignId(Integer campaignId) {
        this.campaignId = campaignId;
    }

    public Integer getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(Integer ownerId) {
        this.ownerId = ownerId;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
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
