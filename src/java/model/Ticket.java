/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;

/**
 *
 * @author hello
 */
public class Ticket {

    public int ticketId;
    public String ticketCode;
    public Integer customerId;
    public Integer leadId;
    public String requesterName;
    public String requesterEmail;
    public String requesterPhone;
    public String subject;
    public String description;
    public String category;
    public String priority;
    public String channel;
    public String status;
    public Integer assignedTo;
    public LocalDateTime assignedAt;
    public LocalDateTime firstResponseAt;
    public LocalDateTime resolvedAt;
    public LocalDateTime closedAt;
    public Integer closedBy;
    public Integer satisfactionRating;
    public String satisfactionComment;
    public LocalDateTime createdAt;
    public LocalDateTime updatedAt;
    public Integer createdBy;

    public Ticket() {
    }

    public Ticket(int ticketId, String ticketCode, Integer customerId, Integer leadId, String requesterName, String requesterEmail, String requesterPhone, String subject, String description, String category, String priority, String channel, String status, Integer assignedTo, LocalDateTime assignedAt, LocalDateTime firstResponseAt, LocalDateTime resolvedAt, LocalDateTime closedAt, Integer closedBy, Integer satisfactionRating, String satisfactionComment, LocalDateTime createdAt, LocalDateTime updatedAt, Integer createdBy) {
        this.ticketId = ticketId;
        this.ticketCode = ticketCode;
        this.customerId = customerId;
        this.leadId = leadId;
        this.requesterName = requesterName;
        this.requesterEmail = requesterEmail;
        this.requesterPhone = requesterPhone;
        this.subject = subject;
        this.description = description;
        this.category = category;
        this.priority = priority;
        this.channel = channel;
        this.status = status;
        this.assignedTo = assignedTo;
        this.assignedAt = assignedAt;
        this.firstResponseAt = firstResponseAt;
        this.resolvedAt = resolvedAt;
        this.closedAt = closedAt;
        this.closedBy = closedBy;
        this.satisfactionRating = satisfactionRating;
        this.satisfactionComment = satisfactionComment;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.createdBy = createdBy;
    }

    public int getTicketId() {
        return ticketId;
    }

    public void setTicketId(int ticketId) {
        this.ticketId = ticketId;
    }

    public String getTicketCode() {
        return ticketCode;
    }

    public void setTicketCode(String ticketCode) {
        this.ticketCode = ticketCode;
    }

    public Integer getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Integer customerId) {
        this.customerId = customerId;
    }

    public Integer getLeadId() {
        return leadId;
    }

    public void setLeadId(Integer leadId) {
        this.leadId = leadId;
    }

    public String getRequesterName() {
        return requesterName;
    }

    public void setRequesterName(String requesterName) {
        this.requesterName = requesterName;
    }

    public String getRequesterEmail() {
        return requesterEmail;
    }

    public void setRequesterEmail(String requesterEmail) {
        this.requesterEmail = requesterEmail;
    }

    public String getRequesterPhone() {
        return requesterPhone;
    }

    public void setRequesterPhone(String requesterPhone) {
        this.requesterPhone = requesterPhone;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public String getChannel() {
        return channel;
    }

    public void setChannel(String channel) {
        this.channel = channel;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    public LocalDateTime getFirstResponseAt() {
        return firstResponseAt;
    }

    public void setFirstResponseAt(LocalDateTime firstResponseAt) {
        this.firstResponseAt = firstResponseAt;
    }

    public LocalDateTime getResolvedAt() {
        return resolvedAt;
    }

    public void setResolvedAt(LocalDateTime resolvedAt) {
        this.resolvedAt = resolvedAt;
    }

    public LocalDateTime getClosedAt() {
        return closedAt;
    }

    public void setClosedAt(LocalDateTime closedAt) {
        this.closedAt = closedAt;
    }

    public Integer getClosedBy() {
        return closedBy;
    }

    public void setClosedBy(Integer closedBy) {
        this.closedBy = closedBy;
    }

    public Integer getSatisfactionRating() {
        return satisfactionRating;
    }

    public void setSatisfactionRating(Integer satisfactionRating) {
        this.satisfactionRating = satisfactionRating;
    }

    public String getSatisfactionComment() {
        return satisfactionComment;
    }

    public void setSatisfactionComment(String satisfactionComment) {
        this.satisfactionComment = satisfactionComment;
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
