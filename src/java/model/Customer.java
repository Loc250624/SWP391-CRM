package model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class Customer {

    public int customerId;
    public String customerCode;
    public String fullName;
    public String email;
    public String phone;
    public LocalDate dateOfBirth;
    public String gender;
    public String address;
    public String city;
    public Integer sourceId;
    public Integer convertedLeadId;
    public String customerSegment;
    public String status;
    public Integer ownerId;
    public int totalCourses;
    public BigDecimal totalSpent;
    public LocalDate firstPurchaseDate;
    public LocalDate lastPurchaseDate;
    public String purchasedCourses;
    public Integer healthScore;
    public Integer satisfactionScore;
    public boolean emailOptOut;
    public boolean smsOptOut;
    public String notes;
    public LocalDateTime createdAt;
    public LocalDateTime updatedAt;
    public Integer createdBy;

    public Customer() {
    }

    public Customer(int customerId, String customerCode, String fullName, String email, String phone, LocalDate dateOfBirth, String gender, String address, String city, Integer sourceId, Integer convertedLeadId, String customerSegment, String status, Integer ownerId, int totalCourses, BigDecimal totalSpent, LocalDate firstPurchaseDate, LocalDate lastPurchaseDate, String purchasedCourses, Integer healthScore, Integer satisfactionScore, boolean emailOptOut, boolean smsOptOut, String notes, LocalDateTime createdAt, LocalDateTime updatedAt, Integer createdBy) {
        this.customerId = customerId;
        this.customerCode = customerCode;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
        this.address = address;
        this.city = city;
        this.sourceId = sourceId;
        this.convertedLeadId = convertedLeadId;
        this.customerSegment = customerSegment;
        this.status = status;
        this.ownerId = ownerId;
        this.totalCourses = totalCourses;
        this.totalSpent = totalSpent;
        this.firstPurchaseDate = firstPurchaseDate;
        this.lastPurchaseDate = lastPurchaseDate;
        this.purchasedCourses = purchasedCourses;
        this.healthScore = healthScore;
        this.satisfactionScore = satisfactionScore;
        this.emailOptOut = emailOptOut;
        this.smsOptOut = smsOptOut;
        this.notes = notes;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.createdBy = createdBy;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public String getCustomerCode() {
        return customerCode;
    }

    public void setCustomerCode(String customerCode) {
        this.customerCode = customerCode;
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

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public Integer getSourceId() {
        return sourceId;
    }

    public void setSourceId(Integer sourceId) {
        this.sourceId = sourceId;
    }

    public Integer getConvertedLeadId() {
        return convertedLeadId;
    }

    public void setConvertedLeadId(Integer convertedLeadId) {
        this.convertedLeadId = convertedLeadId;
    }

    public String getCustomerSegment() {
        return customerSegment;
    }

    public void setCustomerSegment(String customerSegment) {
        this.customerSegment = customerSegment;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(Integer ownerId) {
        this.ownerId = ownerId;
    }

    public int getTotalCourses() {
        return totalCourses;
    }

    public void setTotalCourses(int totalCourses) {
        this.totalCourses = totalCourses;
    }

    public BigDecimal getTotalSpent() {
        return totalSpent;
    }

    public void setTotalSpent(BigDecimal totalSpent) {
        this.totalSpent = totalSpent;
    }

    public LocalDate getFirstPurchaseDate() {
        return firstPurchaseDate;
    }

    public void setFirstPurchaseDate(LocalDate firstPurchaseDate) {
        this.firstPurchaseDate = firstPurchaseDate;
    }

    public LocalDate getLastPurchaseDate() {
        return lastPurchaseDate;
    }

    public void setLastPurchaseDate(LocalDate lastPurchaseDate) {
        this.lastPurchaseDate = lastPurchaseDate;
    }

    public String getPurchasedCourses() {
        return purchasedCourses;
    }

    public void setPurchasedCourses(String purchasedCourses) {
        this.purchasedCourses = purchasedCourses;
    }

    public Integer getHealthScore() {
        return healthScore;
    }

    public void setHealthScore(Integer healthScore) {
        this.healthScore = healthScore;
    }

    public Integer getSatisfactionScore() {
        return satisfactionScore;
    }

    public void setSatisfactionScore(Integer satisfactionScore) {
        this.satisfactionScore = satisfactionScore;
    }

    public boolean isEmailOptOut() {
        return emailOptOut;
    }

    public void setEmailOptOut(boolean emailOptOut) {
        this.emailOptOut = emailOptOut;
    }

    public boolean isSmsOptOut() {
        return smsOptOut;
    }

    public void setSmsOptOut(boolean smsOptOut) {
        this.smsOptOut = smsOptOut;
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
