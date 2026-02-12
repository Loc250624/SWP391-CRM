/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class QuotationVersion {

    public Integer versionId;
    public Integer quotationId;
    public Integer versionNumber;

    public String snapshotData;

    public BigDecimal totalAmount;
    public String changeReason;
    public String changeSummary;

    public LocalDateTime createdAt;
    public Integer createdBy;

    public QuotationVersion() {
    }

    public QuotationVersion(Integer versionId, Integer quotationId, Integer versionNumber, String snapshotData, BigDecimal totalAmount, String changeReason, String changeSummary, LocalDateTime createdAt, Integer createdBy) {
        this.versionId = versionId;
        this.quotationId = quotationId;
        this.versionNumber = versionNumber;
        this.snapshotData = snapshotData;
        this.totalAmount = totalAmount;
        this.changeReason = changeReason;
        this.changeSummary = changeSummary;
        this.createdAt = createdAt;
        this.createdBy = createdBy;
    }

    public Integer getVersionId() {
        return versionId;
    }

    public void setVersionId(Integer versionId) {
        this.versionId = versionId;
    }

    public Integer getQuotationId() {
        return quotationId;
    }

    public void setQuotationId(Integer quotationId) {
        this.quotationId = quotationId;
    }

    public Integer getVersionNumber() {
        return versionNumber;
    }

    public void setVersionNumber(Integer versionNumber) {
        this.versionNumber = versionNumber;
    }

    public String getSnapshotData() {
        return snapshotData;
    }

    public void setSnapshotData(String snapshotData) {
        this.snapshotData = snapshotData;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getChangeReason() {
        return changeReason;
    }

    public void setChangeReason(String changeReason) {
        this.changeReason = changeReason;
    }

    public String getChangeSummary() {
        return changeSummary;
    }

    public void setChangeSummary(String changeSummary) {
        this.changeSummary = changeSummary;
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

}
