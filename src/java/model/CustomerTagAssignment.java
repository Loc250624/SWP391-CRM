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
public class CustomerTagAssignment {

    public int assignmentId;
    public int customerId;
    public int tagId;
    public LocalDateTime assignedAt;
    public Integer assignedBy;

    public CustomerTagAssignment() {
    }

    public CustomerTagAssignment(int assignmentId, int customerId, int tagId, LocalDateTime assignedAt, Integer assignedBy) {
        this.assignmentId = assignmentId;
        this.customerId = customerId;
        this.tagId = tagId;
        this.assignedAt = assignedAt;
        this.assignedBy = assignedBy;
    }

    public int getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(int assignmentId) {
        this.assignmentId = assignmentId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getTagId() {
        return tagId;
    }

    public void setTagId(int tagId) {
        this.tagId = tagId;
    }

    public LocalDateTime getAssignedAt() {
        return assignedAt;
    }

    public void setAssignedAt(LocalDateTime assignedAt) {
        this.assignedAt = assignedAt;
    }

    public Integer getAssignedBy() {
        return assignedBy;
    }

    public void setAssignedBy(Integer assignedBy) {
        this.assignedBy = assignedBy;
    }

}
