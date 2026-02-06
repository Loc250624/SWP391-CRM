package model;

import java.time.LocalDateTime;

public class Lead {

    public int leadId;
    public String leadCode;               // LD-000001

    public String fullName;
    public String email;                  // nullable
    public String phone;                  // nullable

    public Integer sourceId;              // nullable FK
    public Integer campaignId;            // nullable FK

    public String jobTitle;               // nullable
    public String companyName;            // nullable
    public String interests;              // nullable

    public String status;                 // new/contacted/qualified/...
    public String rating;                 // hot/warm/cold (nullable)
    public int leadScore;                 // default 0

    public Integer assignedTo;            // nullable FK users
    public LocalDateTime assignedAt;      // nullable

    public boolean isConverted;           // default 0
    public LocalDateTime convertedAt;     // nullable
    public Integer convertedCustomerId;   // nullable FK customers

    public String notes;                  // nullable (nvarchar(max))
    public LocalDateTime createdAt;
    public LocalDateTime updatedAt;
    public Integer createdBy;             // nullable FK users

    public Lead() {
    }

    public Lead(int leadId, String leadCode, String fullName, String email, String phone, Integer sourceId, Integer campaignId, String jobTitle, String companyName, String interests, String status, String rating, int leadScore, Integer assignedTo, LocalDateTime assignedAt, boolean isConverted, LocalDateTime convertedAt, Integer convertedCustomerId, String notes, LocalDateTime createdAt, LocalDateTime updatedAt, Integer createdBy) {
        this.leadId = leadId;
        this.leadCode = leadCode;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.sourceId = sourceId;
        this.campaignId = campaignId;
        this.jobTitle = jobTitle;
        this.companyName = companyName;
        this.interests = interests;
        this.status = status;
        this.rating = rating;
        this.leadScore = leadScore;
        this.assignedTo = assignedTo;
        this.assignedAt = assignedAt;
        this.isConverted = isConverted;
        this.convertedAt = convertedAt;
        this.convertedCustomerId = convertedCustomerId;
        this.notes = notes;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.createdBy = createdBy;
    }

    public int getLeadId() {
        return leadId;
    }

    public void setLeadId(int leadId) {
        this.leadId = leadId;
    }

    public String getLeadCode() {
        return leadCode;
    }

    public void setLeadCode(String leadCode) {
        this.leadCode = leadCode;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
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

    public String getJobTitle() {
        return jobTitle;
    }

    public void setJobTitle(String jobTitle) {
        this.jobTitle = jobTitle;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getInterests() {
        return interests;
    }

    public void setInterests(String interests) {
        this.interests = interests;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getRating() {
        return rating;
    }

    public void setRating(String rating) {
        this.rating = rating;
    }

    public int getLeadScore() {
        return leadScore;
    }

    public void setLeadScore(int leadScore) {
        this.leadScore = leadScore;
    }

    public Integer getAssignedTo() {
        return assignedTo;
    }

    public void setAssignedTo(Integer assignedTo) {
        this.assignedTo = assignedTo;
    }

    public LocalDateTime getAssignedAt() {
        return assignedAt;
    }

    public void setAssignedAt(LocalDateTime assignedAt) {
        this.assignedAt = assignedAt;
    }

    public boolean isIsConverted() {
        return isConverted;
    }

    public void setIsConverted(boolean isConverted) {
        this.isConverted = isConverted;
    }

    public LocalDateTime getConvertedAt() {
        return convertedAt;
    }

    public void setConvertedAt(LocalDateTime convertedAt) {
        this.convertedAt = convertedAt;
    }

    public Integer getConvertedCustomerId() {
        return convertedCustomerId;
    }

    public void setConvertedCustomerId(Integer convertedCustomerId) {
        this.convertedCustomerId = convertedCustomerId;
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
