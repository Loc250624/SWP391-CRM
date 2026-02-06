/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;

public class EmailAttachment {

    public Integer attachmentId;
    public Integer emailLogId;

    public String fileName;
    public String filePath;
    public Integer fileSize;
    public String fileType;
    public String contentType;

    public Boolean isInline;
    public String contentId;

    public LocalDateTime createdAt;

    public EmailAttachment() {
    }

    public EmailAttachment(Integer attachmentId, Integer emailLogId, String fileName, String filePath, Integer fileSize, String fileType, String contentType, Boolean isInline, String contentId, LocalDateTime createdAt) {
        this.attachmentId = attachmentId;
        this.emailLogId = emailLogId;
        this.fileName = fileName;
        this.filePath = filePath;
        this.fileSize = fileSize;
        this.fileType = fileType;
        this.contentType = contentType;
        this.isInline = isInline;
        this.contentId = contentId;
        this.createdAt = createdAt;
    }

    public Integer getAttachmentId() {
        return attachmentId;
    }

    public void setAttachmentId(Integer attachmentId) {
        this.attachmentId = attachmentId;
    }

    public Integer getEmailLogId() {
        return emailLogId;
    }

    public void setEmailLogId(Integer emailLogId) {
        this.emailLogId = emailLogId;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public Integer getFileSize() {
        return fileSize;
    }

    public void setFileSize(Integer fileSize) {
        this.fileSize = fileSize;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public String getContentType() {
        return contentType;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public Boolean getIsInline() {
        return isInline;
    }

    public void setIsInline(Boolean isInline) {
        this.isInline = isInline;
    }

    public String getContentId() {
        return contentId;
    }

    public void setContentId(String contentId) {
        this.contentId = contentId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

}
