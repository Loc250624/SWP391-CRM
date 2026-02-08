package model;

import java.sql.Timestamp;

public class Customer {
    private int customerId;
    private String customerCode;
    private String fullName;
    private String email;
    private String phone;
    private Timestamp dateOfBirth;
    private String gender;
    private String address;
    private String city;
    private Integer sourceId;
    private Integer convertedLeadId;
    private String customerSegment;
    private String status;
    private Integer ownerId;
    private Integer totalCourses;
    private Double totalSpent;
    private Timestamp firstPurchaseDate;
    private Timestamp lastPurchaseDate;
    private String purchasedCourses;
    private Double healthScore;
    private Double satisfactionScore;
    private boolean emailOptOut;
    private boolean smsOptOut;
    private String notes;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Integer createdBy;

    public Customer() {}

    public Customer(int customerId, String customerCode, String fullName, String email, String phone, Timestamp dateOfBirth, String gender, String address, String city, Integer sourceId, Integer convertedLeadId, String customerSegment, String status, Integer ownerId, Integer totalCourses, Double totalSpent, Timestamp firstPurchaseDate, Timestamp lastPurchaseDate, String purchasedCourses, Double healthScore, Double satisfactionScore, boolean emailOptOut, boolean smsOptOut, String notes, Timestamp createdAt, Timestamp updatedAt, Integer createdBy) {
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

    // --- TOÀN BỘ GETTER/SETTER CẦN THIẾT ---
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public String getCustomerCode() { return customerCode; }
    public void setCustomerCode(String customerCode) { this.customerCode = customerCode; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public Timestamp getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(Timestamp dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    // Trường gender bị thiếu dẫn đến lỗi của bạn
    public String getGender() { return gender; } 
    public void setGender(String gender) { this.gender = gender; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public Integer getSourceId() { return sourceId; }
    public void setSourceId(Integer sourceId) { this.sourceId = sourceId; }

    public Integer getConvertedLeadId() { return convertedLeadId; }
    public void setConvertedLeadId(Integer convertedLeadId) { this.convertedLeadId = convertedLeadId; }

    public String getCustomerSegment() { return customerSegment; }
    public void setCustomerSegment(String customerSegment) { this.customerSegment = customerSegment; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Integer getOwnerId() { return ownerId; }
    public void setOwnerId(Integer ownerId) { this.ownerId = ownerId; }

    public Integer getTotalCourses() { return totalCourses; }
    public void setTotalCourses(Integer totalCourses) { this.totalCourses = totalCourses; }

    public Double getTotalSpent() { return totalSpent; }
    public void setTotalSpent(Double totalSpent) { this.totalSpent = totalSpent; }

    public Timestamp getFirstPurchaseDate() { return firstPurchaseDate; }
    public void setFirstPurchaseDate(Timestamp firstPurchaseDate) { this.firstPurchaseDate = firstPurchaseDate; }

    public Timestamp getLastPurchaseDate() { return lastPurchaseDate; }
    public void setLastPurchaseDate(Timestamp lastPurchaseDate) { this.lastPurchaseDate = lastPurchaseDate; }

    public String getPurchasedCourses() { return purchasedCourses; }
    public void setPurchasedCourses(String purchasedCourses) { this.purchasedCourses = purchasedCourses; }

    public Double getHealthScore() { return healthScore; }
    public void setHealthScore(Double healthScore) { this.healthScore = healthScore; }

    public Double getSatisfactionScore() { return satisfactionScore; }
    public void setSatisfactionScore(Double satisfactionScore) { this.satisfactionScore = satisfactionScore; }

    public boolean isEmailOptOut() { return emailOptOut; }
    public void setEmailOptOut(boolean emailOptOut) { this.emailOptOut = emailOptOut; }

    public boolean isSmsOptOut() { return smsOptOut; }
    public void setSmsOptOut(boolean smsOptOut) { this.smsOptOut = smsOptOut; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public Integer getCreatedBy() { return createdBy; }
    public void setCreatedBy(Integer createdBy) { this.createdBy = createdBy; }
}