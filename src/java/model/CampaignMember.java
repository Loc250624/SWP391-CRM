package model;

import java.time.LocalDateTime;

public class CampaignMember {
    public int memberId;
    public int campaignId;
    public Integer leadId;            // nullable
    public Integer customerId;        // nullable
    public String status;             // added/sent/opened/...
    public LocalDateTime respondedAt; // nullable
    public boolean hasConverted;      // default 0
    public LocalDateTime createdAt;

    public CampaignMember() {}

    public CampaignMember(int memberId, int campaignId, Integer leadId, Integer customerId, String status, LocalDateTime respondedAt, boolean hasConverted, LocalDateTime createdAt) {
        this.memberId = memberId;
        this.campaignId = campaignId;
        this.leadId = leadId;
        this.customerId = customerId;
        this.status = status;
        this.respondedAt = respondedAt;
        this.hasConverted = hasConverted;
        this.createdAt = createdAt;
    }

    public int getMemberId() {
        return memberId;
    }

    public void setMemberId(int memberId) {
        this.memberId = memberId;
    }

    public int getCampaignId() {
        return campaignId;
    }

    public void setCampaignId(int campaignId) {
        this.campaignId = campaignId;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getRespondedAt() {
        return respondedAt;
    }

    public void setRespondedAt(LocalDateTime respondedAt) {
        this.respondedAt = respondedAt;
    }

    public boolean isHasConverted() {
        return hasConverted;
    }

    public void setHasConverted(boolean hasConverted) {
        this.hasConverted = hasConverted;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
}
