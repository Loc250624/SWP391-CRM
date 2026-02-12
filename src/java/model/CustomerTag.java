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
public class CustomerTag {

    public int tagId;
    public String tagName;
    public String tagColor;
    public String description;
    public boolean isActive;
    public LocalDateTime createdAt;

    public CustomerTag() {
    }

    public CustomerTag(int tagId, String tagName, String tagColor, String description, boolean isActive, LocalDateTime createdAt) {
        this.tagId = tagId;
        this.tagName = tagName;
        this.tagColor = tagColor;
        this.description = description;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }

    public int getTagId() {
        return tagId;
    }

    public void setTagId(int tagId) {
        this.tagId = tagId;
    }

    public String getTagName() {
        return tagName;
    }

    public void setTagName(String tagName) {
        this.tagName = tagName;
    }

    public String getTagColor() {
        return tagColor;
    }

    public void setTagColor(String tagColor) {
        this.tagColor = tagColor;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

}
