package model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class CustomerEnrollment {

    public Integer enrollmentId;
    public String enrollmentCode;

    public Integer customerId;
    public Integer courseId;

    public LocalDate enrolledDate;

    public BigDecimal originalPrice;
    public BigDecimal discountAmount;
    public BigDecimal finalAmount;

    public String paymentMethod;
    public String paymentStatus;

    public LocalDate paidDate;
    public String transactionRef;
    public String invoiceNumber;

    public LocalDate startDate;
    public LocalDate expectedCompletionDate;
    public LocalDate actualCompletionDate;

    public String learningStatus;
    public Integer progressPercentage;
    public Integer lessonsCompleted;
    public LocalDateTime lastAccessedDate;

    public Boolean certificateIssued;
    public String certificateNumber;
    public LocalDate certificateIssuedDate;
    public String certificateUrl;

    public Integer rating;
    public String review;
    public LocalDate reviewedDate;

    public Integer sourceId;
    public Integer campaignId;
    public String referralCode;
    public String promoCode;

    public Integer assignedTo;

    public String notes;
    public String internalNotes;

    public LocalDateTime createdAt;
    public LocalDateTime updatedAt;
    public Integer createdBy;

    public CustomerEnrollment() {
    }

    public CustomerEnrollment(Integer enrollmentId, String enrollmentCode, Integer customerId, Integer courseId, LocalDate enrolledDate, BigDecimal originalPrice, BigDecimal discountAmount, BigDecimal finalAmount, String paymentMethod, String paymentStatus, LocalDate paidDate, String transactionRef, String invoiceNumber, LocalDate startDate, LocalDate expectedCompletionDate, LocalDate actualCompletionDate, String learningStatus, Integer progressPercentage, Integer lessonsCompleted, LocalDateTime lastAccessedDate, Boolean certificateIssued, String certificateNumber, LocalDate certificateIssuedDate, String certificateUrl, Integer rating, String review, LocalDate reviewedDate, Integer sourceId, Integer campaignId, String referralCode, String promoCode, Integer assignedTo, String notes, String internalNotes, LocalDateTime createdAt, LocalDateTime updatedAt, Integer createdBy) {
        this.enrollmentId = enrollmentId;
        this.enrollmentCode = enrollmentCode;
        this.customerId = customerId;
        this.courseId = courseId;
        this.enrolledDate = enrolledDate;
        this.originalPrice = originalPrice;
        this.discountAmount = discountAmount;
        this.finalAmount = finalAmount;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.paidDate = paidDate;
        this.transactionRef = transactionRef;
        this.invoiceNumber = invoiceNumber;
        this.startDate = startDate;
        this.expectedCompletionDate = expectedCompletionDate;
        this.actualCompletionDate = actualCompletionDate;
        this.learningStatus = learningStatus;
        this.progressPercentage = progressPercentage;
        this.lessonsCompleted = lessonsCompleted;
        this.lastAccessedDate = lastAccessedDate;
        this.certificateIssued = certificateIssued;
        this.certificateNumber = certificateNumber;
        this.certificateIssuedDate = certificateIssuedDate;
        this.certificateUrl = certificateUrl;
        this.rating = rating;
        this.review = review;
        this.reviewedDate = reviewedDate;
        this.sourceId = sourceId;
        this.campaignId = campaignId;
        this.referralCode = referralCode;
        this.promoCode = promoCode;
        this.assignedTo = assignedTo;
        this.notes = notes;
        this.internalNotes = internalNotes;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.createdBy = createdBy;
    }

    public Integer getEnrollmentId() {
        return enrollmentId;
    }

    public void setEnrollmentId(Integer enrollmentId) {
        this.enrollmentId = enrollmentId;
    }

    public String getEnrollmentCode() {
        return enrollmentCode;
    }

    public void setEnrollmentCode(String enrollmentCode) {
        this.enrollmentCode = enrollmentCode;
    }

    public Integer getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Integer customerId) {
        this.customerId = customerId;
    }

    public Integer getCourseId() {
        return courseId;
    }

    public void setCourseId(Integer courseId) {
        this.courseId = courseId;
    }

    public LocalDate getEnrolledDate() {
        return enrolledDate;
    }

    public void setEnrolledDate(LocalDate enrolledDate) {
        this.enrolledDate = enrolledDate;
    }

    public BigDecimal getOriginalPrice() {
        return originalPrice;
    }

    public void setOriginalPrice(BigDecimal originalPrice) {
        this.originalPrice = originalPrice;
    }

    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }

    public BigDecimal getFinalAmount() {
        return finalAmount;
    }

    public void setFinalAmount(BigDecimal finalAmount) {
        this.finalAmount = finalAmount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public LocalDate getPaidDate() {
        return paidDate;
    }

    public void setPaidDate(LocalDate paidDate) {
        this.paidDate = paidDate;
    }

    public String getTransactionRef() {
        return transactionRef;
    }

    public void setTransactionRef(String transactionRef) {
        this.transactionRef = transactionRef;
    }

    public String getInvoiceNumber() {
        return invoiceNumber;
    }

    public void setInvoiceNumber(String invoiceNumber) {
        this.invoiceNumber = invoiceNumber;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getExpectedCompletionDate() {
        return expectedCompletionDate;
    }

    public void setExpectedCompletionDate(LocalDate expectedCompletionDate) {
        this.expectedCompletionDate = expectedCompletionDate;
    }

    public LocalDate getActualCompletionDate() {
        return actualCompletionDate;
    }

    public void setActualCompletionDate(LocalDate actualCompletionDate) {
        this.actualCompletionDate = actualCompletionDate;
    }

    public String getLearningStatus() {
        return learningStatus;
    }

    public void setLearningStatus(String learningStatus) {
        this.learningStatus = learningStatus;
    }

    public Integer getProgressPercentage() {
        return progressPercentage;
    }

    public void setProgressPercentage(Integer progressPercentage) {
        this.progressPercentage = progressPercentage;
    }

    public Integer getLessonsCompleted() {
        return lessonsCompleted;
    }

    public void setLessonsCompleted(Integer lessonsCompleted) {
        this.lessonsCompleted = lessonsCompleted;
    }

    public LocalDateTime getLastAccessedDate() {
        return lastAccessedDate;
    }

    public void setLastAccessedDate(LocalDateTime lastAccessedDate) {
        this.lastAccessedDate = lastAccessedDate;
    }

    public Boolean getCertificateIssued() {
        return certificateIssued;
    }

    public void setCertificateIssued(Boolean certificateIssued) {
        this.certificateIssued = certificateIssued;
    }

    public String getCertificateNumber() {
        return certificateNumber;
    }

    public void setCertificateNumber(String certificateNumber) {
        this.certificateNumber = certificateNumber;
    }

    public LocalDate getCertificateIssuedDate() {
        return certificateIssuedDate;
    }

    public void setCertificateIssuedDate(LocalDate certificateIssuedDate) {
        this.certificateIssuedDate = certificateIssuedDate;
    }

    public String getCertificateUrl() {
        return certificateUrl;
    }

    public void setCertificateUrl(String certificateUrl) {
        this.certificateUrl = certificateUrl;
    }

    public Integer getRating() {
        return rating;
    }

    public void setRating(Integer rating) {
        this.rating = rating;
    }

    public String getReview() {
        return review;
    }

    public void setReview(String review) {
        this.review = review;
    }

    public LocalDate getReviewedDate() {
        return reviewedDate;
    }

    public void setReviewedDate(LocalDate reviewedDate) {
        this.reviewedDate = reviewedDate;
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

    public String getReferralCode() {
        return referralCode;
    }

    public void setReferralCode(String referralCode) {
        this.referralCode = referralCode;
    }

    public String getPromoCode() {
        return promoCode;
    }

    public void setPromoCode(String promoCode) {
        this.promoCode = promoCode;
    }

    public Integer getAssignedTo() {
        return assignedTo;
    }

    public void setAssignedTo(Integer assignedTo) {
        this.assignedTo = assignedTo;
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
