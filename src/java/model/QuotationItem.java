/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class QuotationItem {

    public Integer itemId;
    public Integer quotationId;
    public Integer courseId;

    public String itemType;
    public String description;
    public String detailedDescription;

    public Integer quantity;
    public BigDecimal unitPrice;
    public Integer discountPercent;
    public BigDecimal discountAmount;
    public BigDecimal lineTotal;

    public Integer sortOrder;
    public Boolean isOptional;

    public LocalDateTime createdAt;

    public QuotationItem() {
    }

    public QuotationItem(Integer itemId, Integer quotationId, Integer courseId, String itemType, String description, String detailedDescription, Integer quantity, BigDecimal unitPrice, Integer discountPercent, BigDecimal discountAmount, BigDecimal lineTotal, Integer sortOrder, Boolean isOptional, LocalDateTime createdAt) {
        this.itemId = itemId;
        this.quotationId = quotationId;
        this.courseId = courseId;
        this.itemType = itemType;
        this.description = description;
        this.detailedDescription = detailedDescription;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.discountPercent = discountPercent;
        this.discountAmount = discountAmount;
        this.lineTotal = lineTotal;
        this.sortOrder = sortOrder;
        this.isOptional = isOptional;
        this.createdAt = createdAt;
    }

    public Integer getItemId() {
        return itemId;
    }

    public void setItemId(Integer itemId) {
        this.itemId = itemId;
    }

    public Integer getQuotationId() {
        return quotationId;
    }

    public void setQuotationId(Integer quotationId) {
        this.quotationId = quotationId;
    }

    public Integer getCourseId() {
        return courseId;
    }

    public void setCourseId(Integer courseId) {
        this.courseId = courseId;
    }

    public String getItemType() {
        return itemType;
    }

    public void setItemType(String itemType) {
        this.itemType = itemType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDetailedDescription() {
        return detailedDescription;
    }

    public void setDetailedDescription(String detailedDescription) {
        this.detailedDescription = detailedDescription;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
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

    public BigDecimal getLineTotal() {
        return lineTotal;
    }

    public void setLineTotal(BigDecimal lineTotal) {
        this.lineTotal = lineTotal;
    }

    public Integer getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(Integer sortOrder) {
        this.sortOrder = sortOrder;
    }

    public Boolean getIsOptional() {
        return isOptional;
    }

    public void setIsOptional(Boolean isOptional) {
        this.isOptional = isOptional;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

}
