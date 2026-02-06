/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class Quotation {

    public Integer quotationId;
    public String quotationCode;
    public String quotationNumber;
    public Integer version;

    public Integer opportunityId;
    public Integer customerId;
    public Integer leadId;

    public LocalDate quoteDate;
    public LocalDate validUntil;
    public Integer expiryDays;

    public String status;

    public String currency;
    public BigDecimal subtotal;
    public String discountType;
    public Integer discountPercent;
    public BigDecimal discountAmount;
    public Integer taxPercent;
    public BigDecimal taxAmount;
    public BigDecimal totalAmount;

    public Boolean requiresApproval;
    public Integer approvedBy;
    public LocalDateTime approvedDate;
    public String approvalNotes;
    public Integer rejectedBy;
    public LocalDateTime rejectedDate;
    public String rejectionReason;

    public LocalDateTime sentDate;
    public Integer sentBy;
    public LocalDateTime firstViewedDate;
    public LocalDateTime lastViewedDate;
    public Integer viewCount;
    public Integer totalViewDurationSeconds;

    public LocalDateTime acceptedDate;
    public String acceptedByName;
    public String acceptedByEmail;
    public String acceptedIpAddress;

    public LocalDateTime customerRejectedDate;
    public String customerRejectionReason;

    public String pdfPath;
    public String pdfUrl;
    public LocalDateTime pdfGeneratedDate;

    public String trackingToken;
    public String trackingUrl;
    public Boolean emailTrackingEnabled;
    public Integer lastEmailSentId;

    public String title;
    public String description;
    public String termsConditions;
    public String paymentTerms;
    public String deliveryTerms;
    public String notes;
    public String internalNotes;

    public LocalDateTime createdAt;
    public Integer createdBy;
    public LocalDateTime updatedAt;
    public Integer updatedBy;

    public Quotation() {
    }

    public Quotation(Integer quotationId, String quotationCode, String quotationNumber, Integer version, Integer opportunityId, Integer customerId, Integer leadId, LocalDate quoteDate, LocalDate validUntil, Integer expiryDays, String status, String currency, BigDecimal subtotal, String discountType, Integer discountPercent, BigDecimal discountAmount, Integer taxPercent, BigDecimal taxAmount, BigDecimal totalAmount, Boolean requiresApproval, Integer approvedBy, LocalDateTime approvedDate, String approvalNotes, Integer rejectedBy, LocalDateTime rejectedDate, String rejectionReason, LocalDateTime sentDate, Integer sentBy, LocalDateTime firstViewedDate, LocalDateTime lastViewedDate, Integer viewCount, Integer totalViewDurationSeconds, LocalDateTime acceptedDate, String acceptedByName, String acceptedByEmail, String acceptedIpAddress, LocalDateTime customerRejectedDate, String customerRejectionReason, String pdfPath, String pdfUrl, LocalDateTime pdfGeneratedDate, String trackingToken, String trackingUrl, Boolean emailTrackingEnabled, Integer lastEmailSentId, String title, String description, String termsConditions, String paymentTerms, String deliveryTerms, String notes, String internalNotes, LocalDateTime createdAt, Integer createdBy, LocalDateTime updatedAt, Integer updatedBy) {
        this.quotationId = quotationId;
        this.quotationCode = quotationCode;
        this.quotationNumber = quotationNumber;
        this.version = version;
        this.opportunityId = opportunityId;
        this.customerId = customerId;
        this.leadId = leadId;
        this.quoteDate = quoteDate;
        this.validUntil = validUntil;
        this.expiryDays = expiryDays;
        this.status = status;
        this.currency = currency;
        this.subtotal = subtotal;
        this.discountType = discountType;
        this.discountPercent = discountPercent;
        this.discountAmount = discountAmount;
        this.taxPercent = taxPercent;
        this.taxAmount = taxAmount;
        this.totalAmount = totalAmount;
        this.requiresApproval = requiresApproval;
        this.approvedBy = approvedBy;
        this.approvedDate = approvedDate;
        this.approvalNotes = approvalNotes;
        this.rejectedBy = rejectedBy;
        this.rejectedDate = rejectedDate;
        this.rejectionReason = rejectionReason;
        this.sentDate = sentDate;
        this.sentBy = sentBy;
        this.firstViewedDate = firstViewedDate;
        this.lastViewedDate = lastViewedDate;
        this.viewCount = viewCount;
        this.totalViewDurationSeconds = totalViewDurationSeconds;
        this.acceptedDate = acceptedDate;
        this.acceptedByName = acceptedByName;
        this.acceptedByEmail = acceptedByEmail;
        this.acceptedIpAddress = acceptedIpAddress;
        this.customerRejectedDate = customerRejectedDate;
        this.customerRejectionReason = customerRejectionReason;
        this.pdfPath = pdfPath;
        this.pdfUrl = pdfUrl;
        this.pdfGeneratedDate = pdfGeneratedDate;
        this.trackingToken = trackingToken;
        this.trackingUrl = trackingUrl;
        this.emailTrackingEnabled = emailTrackingEnabled;
        this.lastEmailSentId = lastEmailSentId;
        this.title = title;
        this.description = description;
        this.termsConditions = termsConditions;
        this.paymentTerms = paymentTerms;
        this.deliveryTerms = deliveryTerms;
        this.notes = notes;
        this.internalNotes = internalNotes;
        this.createdAt = createdAt;
        this.createdBy = createdBy;
        this.updatedAt = updatedAt;
        this.updatedBy = updatedBy;
    }

    public Integer getQuotationId() {
        return quotationId;
    }

    public void setQuotationId(Integer quotationId) {
        this.quotationId = quotationId;
    }

    public String getQuotationCode() {
        return quotationCode;
    }

    public void setQuotationCode(String quotationCode) {
        this.quotationCode = quotationCode;
    }

    public String getQuotationNumber() {
        return quotationNumber;
    }

    public void setQuotationNumber(String quotationNumber) {
        this.quotationNumber = quotationNumber;
    }

    public Integer getVersion() {
        return version;
    }

    public void setVersion(Integer version) {
        this.version = version;
    }

    public Integer getOpportunityId() {
        return opportunityId;
    }

    public void setOpportunityId(Integer opportunityId) {
        this.opportunityId = opportunityId;
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

    public LocalDate getQuoteDate() {
        return quoteDate;
    }

    public void setQuoteDate(LocalDate quoteDate) {
        this.quoteDate = quoteDate;
    }

    public LocalDate getValidUntil() {
        return validUntil;
    }

    public void setValidUntil(LocalDate validUntil) {
        this.validUntil = validUntil;
    }

    public Integer getExpiryDays() {
        return expiryDays;
    }

    public void setExpiryDays(Integer expiryDays) {
        this.expiryDays = expiryDays;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }

    public String getDiscountType() {
        return discountType;
    }

    public void setDiscountType(String discountType) {
        this.discountType = discountType;
    }

    public Integer getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(Integer discountPercent) {
        this.discountPercent = discountPercent;
    }

    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }

    public Integer getTaxPercent() {
        return taxPercent;
    }

    public void setTaxPercent(Integer taxPercent) {
        this.taxPercent = taxPercent;
    }

    public BigDecimal getTaxAmount() {
        return taxAmount;
    }

    public void setTaxAmount(BigDecimal taxAmount) {
        this.taxAmount = taxAmount;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Boolean getRequiresApproval() {
        return requiresApproval;
    }

    public void setRequiresApproval(Boolean requiresApproval) {
        this.requiresApproval = requiresApproval;
    }

    public Integer getApprovedBy() {
        return approvedBy;
    }

    public void setApprovedBy(Integer approvedBy) {
        this.approvedBy = approvedBy;
    }

    public LocalDateTime getApprovedDate() {
        return approvedDate;
    }

    public void setApprovedDate(LocalDateTime approvedDate) {
        this.approvedDate = approvedDate;
    }

    public String getApprovalNotes() {
        return approvalNotes;
    }

    public void setApprovalNotes(String approvalNotes) {
        this.approvalNotes = approvalNotes;
    }

    public Integer getRejectedBy() {
        return rejectedBy;
    }

    public void setRejectedBy(Integer rejectedBy) {
        this.rejectedBy = rejectedBy;
    }

    public LocalDateTime getRejectedDate() {
        return rejectedDate;
    }

    public void setRejectedDate(LocalDateTime rejectedDate) {
        this.rejectedDate = rejectedDate;
    }

    public String getRejectionReason() {
        return rejectionReason;
    }

    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }

    public LocalDateTime getSentDate() {
        return sentDate;
    }

    public void setSentDate(LocalDateTime sentDate) {
        this.sentDate = sentDate;
    }

    public Integer getSentBy() {
        return sentBy;
    }

    public void setSentBy(Integer sentBy) {
        this.sentBy = sentBy;
    }

    public LocalDateTime getFirstViewedDate() {
        return firstViewedDate;
    }

    public void setFirstViewedDate(LocalDateTime firstViewedDate) {
        this.firstViewedDate = firstViewedDate;
    }

    public LocalDateTime getLastViewedDate() {
        return lastViewedDate;
    }

    public void setLastViewedDate(LocalDateTime lastViewedDate) {
        this.lastViewedDate = lastViewedDate;
    }

    public Integer getViewCount() {
        return viewCount;
    }

    public void setViewCount(Integer viewCount) {
        this.viewCount = viewCount;
    }

    public Integer getTotalViewDurationSeconds() {
        return totalViewDurationSeconds;
    }

    public void setTotalViewDurationSeconds(Integer totalViewDurationSeconds) {
        this.totalViewDurationSeconds = totalViewDurationSeconds;
    }

    public LocalDateTime getAcceptedDate() {
        return acceptedDate;
    }

    public void setAcceptedDate(LocalDateTime acceptedDate) {
        this.acceptedDate = acceptedDate;
    }

    public String getAcceptedByName() {
        return acceptedByName;
    }

    public void setAcceptedByName(String acceptedByName) {
        this.acceptedByName = acceptedByName;
    }

    public String getAcceptedByEmail() {
        return acceptedByEmail;
    }

    public void setAcceptedByEmail(String acceptedByEmail) {
        this.acceptedByEmail = acceptedByEmail;
    }

    public String getAcceptedIpAddress() {
        return acceptedIpAddress;
    }

    public void setAcceptedIpAddress(String acceptedIpAddress) {
        this.acceptedIpAddress = acceptedIpAddress;
    }

    public LocalDateTime getCustomerRejectedDate() {
        return customerRejectedDate;
    }

    public void setCustomerRejectedDate(LocalDateTime customerRejectedDate) {
        this.customerRejectedDate = customerRejectedDate;
    }

    public String getCustomerRejectionReason() {
        return customerRejectionReason;
    }

    public void setCustomerRejectionReason(String customerRejectionReason) {
        this.customerRejectionReason = customerRejectionReason;
    }

    public String getPdfPath() {
        return pdfPath;
    }

    public void setPdfPath(String pdfPath) {
        this.pdfPath = pdfPath;
    }

    public String getPdfUrl() {
        return pdfUrl;
    }

    public void setPdfUrl(String pdfUrl) {
        this.pdfUrl = pdfUrl;
    }

    public LocalDateTime getPdfGeneratedDate() {
        return pdfGeneratedDate;
    }

    public void setPdfGeneratedDate(LocalDateTime pdfGeneratedDate) {
        this.pdfGeneratedDate = pdfGeneratedDate;
    }

    public String getTrackingToken() {
        return trackingToken;
    }

    public void setTrackingToken(String trackingToken) {
        this.trackingToken = trackingToken;
    }

    public String getTrackingUrl() {
        return trackingUrl;
    }

    public void setTrackingUrl(String trackingUrl) {
        this.trackingUrl = trackingUrl;
    }

    public Boolean getEmailTrackingEnabled() {
        return emailTrackingEnabled;
    }

    public void setEmailTrackingEnabled(Boolean emailTrackingEnabled) {
        this.emailTrackingEnabled = emailTrackingEnabled;
    }

    public Integer getLastEmailSentId() {
        return lastEmailSentId;
    }

    public void setLastEmailSentId(Integer lastEmailSentId) {
        this.lastEmailSentId = lastEmailSentId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getTermsConditions() {
        return termsConditions;
    }

    public void setTermsConditions(String termsConditions) {
        this.termsConditions = termsConditions;
    }

    public String getPaymentTerms() {
        return paymentTerms;
    }

    public void setPaymentTerms(String paymentTerms) {
        this.paymentTerms = paymentTerms;
    }

    public String getDeliveryTerms() {
        return deliveryTerms;
    }

    public void setDeliveryTerms(String deliveryTerms) {
        this.deliveryTerms = deliveryTerms;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getInternalNotes() {
        return internalNotes;
    }

    public void setInternalNotes(String internalNotes) {
        this.internalNotes = internalNotes;
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

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Integer getUpdatedBy() {
        return updatedBy;
    }

    public void setUpdatedBy(Integer updatedBy) {
        this.updatedBy = updatedBy;
    }

}
