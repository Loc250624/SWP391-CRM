/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;

public class EmailLog {

    public Integer emailLogId;

    public String relatedType;
    public Integer relatedId;
    public Integer quotationId;

    public Integer templateId;
    public String fromEmail;
    public String fromName;
    public String toEmail;
    public String toName;
    public String ccEmails;
    public String bccEmails;
    public String replyTo;

    public String subject;
    public String bodyHtml;
    public String bodyText;
    public Boolean hasAttachments;
    public Integer attachmentCount;
    public String attachmentsInfo;

    public String status;
    public LocalDateTime sentDate;
    public Integer sentBy;

    public String provider;
    public String providerMessageId;
    public String providerResponse;

    public Boolean trackingEnabled;
    public String trackingPixelUrl;
    public LocalDateTime openedDate;
    public Integer openCount;
    public LocalDateTime lastOpenedDate;
    public LocalDateTime clickedDate;
    public Integer clickCount;
    public LocalDateTime lastClickedDate;

    public LocalDateTime bouncedDate;
    public String bounceReason;
    public String errorMessage;
    public Integer retryCount;
    public LocalDateTime nextRetryDate;

    public LocalDateTime createdAt;

    public EmailLog() {
    }

    public EmailLog(Integer emailLogId, String relatedType, Integer relatedId, Integer quotationId, Integer templateId, String fromEmail, String fromName, String toEmail, String toName, String ccEmails, String bccEmails, String replyTo, String subject, String bodyHtml, String bodyText, Boolean hasAttachments, Integer attachmentCount, String attachmentsInfo, String status, LocalDateTime sentDate, Integer sentBy, String provider, String providerMessageId, String providerResponse, Boolean trackingEnabled, String trackingPixelUrl, LocalDateTime openedDate, Integer openCount, LocalDateTime lastOpenedDate, LocalDateTime clickedDate, Integer clickCount, LocalDateTime lastClickedDate, LocalDateTime bouncedDate, String bounceReason, String errorMessage, Integer retryCount, LocalDateTime nextRetryDate, LocalDateTime createdAt) {
        this.emailLogId = emailLogId;
        this.relatedType = relatedType;
        this.relatedId = relatedId;
        this.quotationId = quotationId;
        this.templateId = templateId;
        this.fromEmail = fromEmail;
        this.fromName = fromName;
        this.toEmail = toEmail;
        this.toName = toName;
        this.ccEmails = ccEmails;
        this.bccEmails = bccEmails;
        this.replyTo = replyTo;
        this.subject = subject;
        this.bodyHtml = bodyHtml;
        this.bodyText = bodyText;
        this.hasAttachments = hasAttachments;
        this.attachmentCount = attachmentCount;
        this.attachmentsInfo = attachmentsInfo;
        this.status = status;
        this.sentDate = sentDate;
        this.sentBy = sentBy;
        this.provider = provider;
        this.providerMessageId = providerMessageId;
        this.providerResponse = providerResponse;
        this.trackingEnabled = trackingEnabled;
        this.trackingPixelUrl = trackingPixelUrl;
        this.openedDate = openedDate;
        this.openCount = openCount;
        this.lastOpenedDate = lastOpenedDate;
        this.clickedDate = clickedDate;
        this.clickCount = clickCount;
        this.lastClickedDate = lastClickedDate;
        this.bouncedDate = bouncedDate;
        this.bounceReason = bounceReason;
        this.errorMessage = errorMessage;
        this.retryCount = retryCount;
        this.nextRetryDate = nextRetryDate;
        this.createdAt = createdAt;
    }

    public Integer getEmailLogId() {
        return emailLogId;
    }

    public void setEmailLogId(Integer emailLogId) {
        this.emailLogId = emailLogId;
    }

    public String getRelatedType() {
        return relatedType;
    }

    public void setRelatedType(String relatedType) {
        this.relatedType = relatedType;
    }

    public Integer getRelatedId() {
        return relatedId;
    }

    public void setRelatedId(Integer relatedId) {
        this.relatedId = relatedId;
    }

    public Integer getQuotationId() {
        return quotationId;
    }

    public void setQuotationId(Integer quotationId) {
        this.quotationId = quotationId;
    }

    public Integer getTemplateId() {
        return templateId;
    }

    public void setTemplateId(Integer templateId) {
        this.templateId = templateId;
    }

    public String getFromEmail() {
        return fromEmail;
    }

    public void setFromEmail(String fromEmail) {
        this.fromEmail = fromEmail;
    }

    public String getFromName() {
        return fromName;
    }

    public void setFromName(String fromName) {
        this.fromName = fromName;
    }

    public String getToEmail() {
        return toEmail;
    }

    public void setToEmail(String toEmail) {
        this.toEmail = toEmail;
    }

    public String getToName() {
        return toName;
    }

    public void setToName(String toName) {
        this.toName = toName;
    }

    public String getCcEmails() {
        return ccEmails;
    }

    public void setCcEmails(String ccEmails) {
        this.ccEmails = ccEmails;
    }

    public String getBccEmails() {
        return bccEmails;
    }

    public void setBccEmails(String bccEmails) {
        this.bccEmails = bccEmails;
    }

    public String getReplyTo() {
        return replyTo;
    }

    public void setReplyTo(String replyTo) {
        this.replyTo = replyTo;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getBodyHtml() {
        return bodyHtml;
    }

    public void setBodyHtml(String bodyHtml) {
        this.bodyHtml = bodyHtml;
    }

    public String getBodyText() {
        return bodyText;
    }

    public void setBodyText(String bodyText) {
        this.bodyText = bodyText;
    }

    public Boolean getHasAttachments() {
        return hasAttachments;
    }

    public void setHasAttachments(Boolean hasAttachments) {
        this.hasAttachments = hasAttachments;
    }

    public Integer getAttachmentCount() {
        return attachmentCount;
    }

    public void setAttachmentCount(Integer attachmentCount) {
        this.attachmentCount = attachmentCount;
    }

    public String getAttachmentsInfo() {
        return attachmentsInfo;
    }

    public void setAttachmentsInfo(String attachmentsInfo) {
        this.attachmentsInfo = attachmentsInfo;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    public String getProvider() {
        return provider;
    }

    public void setProvider(String provider) {
        this.provider = provider;
    }

    public String getProviderMessageId() {
        return providerMessageId;
    }

    public void setProviderMessageId(String providerMessageId) {
        this.providerMessageId = providerMessageId;
    }

    public String getProviderResponse() {
        return providerResponse;
    }

    public void setProviderResponse(String providerResponse) {
        this.providerResponse = providerResponse;
    }

    public Boolean getTrackingEnabled() {
        return trackingEnabled;
    }

    public void setTrackingEnabled(Boolean trackingEnabled) {
        this.trackingEnabled = trackingEnabled;
    }

    public String getTrackingPixelUrl() {
        return trackingPixelUrl;
    }

    public void setTrackingPixelUrl(String trackingPixelUrl) {
        this.trackingPixelUrl = trackingPixelUrl;
    }

    public LocalDateTime getOpenedDate() {
        return openedDate;
    }

    public void setOpenedDate(LocalDateTime openedDate) {
        this.openedDate = openedDate;
    }

    public Integer getOpenCount() {
        return openCount;
    }

    public void setOpenCount(Integer openCount) {
        this.openCount = openCount;
    }

    public LocalDateTime getLastOpenedDate() {
        return lastOpenedDate;
    }

    public void setLastOpenedDate(LocalDateTime lastOpenedDate) {
        this.lastOpenedDate = lastOpenedDate;
    }

    public LocalDateTime getClickedDate() {
        return clickedDate;
    }

    public void setClickedDate(LocalDateTime clickedDate) {
        this.clickedDate = clickedDate;
    }

    public Integer getClickCount() {
        return clickCount;
    }

    public void setClickCount(Integer clickCount) {
        this.clickCount = clickCount;
    }

    public LocalDateTime getLastClickedDate() {
        return lastClickedDate;
    }

    public void setLastClickedDate(LocalDateTime lastClickedDate) {
        this.lastClickedDate = lastClickedDate;
    }

    public LocalDateTime getBouncedDate() {
        return bouncedDate;
    }

    public void setBouncedDate(LocalDateTime bouncedDate) {
        this.bouncedDate = bouncedDate;
    }

    public String getBounceReason() {
        return bounceReason;
    }

    public void setBounceReason(String bounceReason) {
        this.bounceReason = bounceReason;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public Integer getRetryCount() {
        return retryCount;
    }

    public void setRetryCount(Integer retryCount) {
        this.retryCount = retryCount;
    }

    public LocalDateTime getNextRetryDate() {
        return nextRetryDate;
    }

    public void setNextRetryDate(LocalDateTime nextRetryDate) {
        this.nextRetryDate = nextRetryDate;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

}
