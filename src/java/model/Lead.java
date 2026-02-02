package model;

import java.sql.Date;

public class Lead {

    private int id;
    private String fullName;
    private String email;
    private String phone;
    private String financialLevel;
    private int totalScore;
    private int leadStatusId;
    private Date createdAt;

    // thêm để hiển thị tên status (JOIN)
    private String leadStatusName;

    public Lead() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

    public String getFinancialLevel() {
        return financialLevel;
    }

    public void setFinancialLevel(String financialLevel) {
        this.financialLevel = financialLevel;
    }

    public int getTotalScore() {
        return totalScore;
    }

    public void setTotalScore(int totalScore) {
        this.totalScore = totalScore;
    }

    public int getLeadStatusId() {
        return leadStatusId;
    }

    public void setLeadStatusId(int leadStatusId) {
        this.leadStatusId = leadStatusId;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getLeadStatusName() {
        return leadStatusName;
    }

    public void setLeadStatusName(String leadStatusName) {
        this.leadStatusName = leadStatusName;
    }
}
