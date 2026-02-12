/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;

public class QuotationTrackingLog {

    public Integer logId;
    public Integer quotationId;

    public String eventType;
    public LocalDateTime eventDate;

    public String ipAddress;
    public String userAgent;
    public String deviceType;
    public String browser;
    public String locationCountry;
    public String locationCity;

    public String sessionId;
    public String pageUrl;
    public String referrerUrl;
    public Integer durationSeconds;

    public String metadata;
    public Integer emailLogId;

    public QuotationTrackingLog() {
    }

    public QuotationTrackingLog(Integer logId, Integer quotationId, String eventType, LocalDateTime eventDate, String ipAddress, String userAgent, String deviceType, String browser, String locationCountry, String locationCity, String sessionId, String pageUrl, String referrerUrl, Integer durationSeconds, String metadata, Integer emailLogId) {
        this.logId = logId;
        this.quotationId = quotationId;
        this.eventType = eventType;
        this.eventDate = eventDate;
        this.ipAddress = ipAddress;
        this.userAgent = userAgent;
        this.deviceType = deviceType;
        this.browser = browser;
        this.locationCountry = locationCountry;
        this.locationCity = locationCity;
        this.sessionId = sessionId;
        this.pageUrl = pageUrl;
        this.referrerUrl = referrerUrl;
        this.durationSeconds = durationSeconds;
        this.metadata = metadata;
        this.emailLogId = emailLogId;
    }

    public Integer getLogId() {
        return logId;
    }

    public void setLogId(Integer logId) {
        this.logId = logId;
    }

    public Integer getQuotationId() {
        return quotationId;
    }

    public void setQuotationId(Integer quotationId) {
        this.quotationId = quotationId;
    }

    public String getEventType() {
        return eventType;
    }

    public void setEventType(String eventType) {
        this.eventType = eventType;
    }

    public LocalDateTime getEventDate() {
        return eventDate;
    }

    public void setEventDate(LocalDateTime eventDate) {
        this.eventDate = eventDate;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getUserAgent() {
        return userAgent;
    }

    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }

    public String getDeviceType() {
        return deviceType;
    }

    public void setDeviceType(String deviceType) {
        this.deviceType = deviceType;
    }

    public String getBrowser() {
        return browser;
    }

    public void setBrowser(String browser) {
        this.browser = browser;
    }

    public String getLocationCountry() {
        return locationCountry;
    }

    public void setLocationCountry(String locationCountry) {
        this.locationCountry = locationCountry;
    }

    public String getLocationCity() {
        return locationCity;
    }

    public void setLocationCity(String locationCity) {
        this.locationCity = locationCity;
    }

    public String getSessionId() {
        return sessionId;
    }

    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }

    public String getPageUrl() {
        return pageUrl;
    }

    public void setPageUrl(String pageUrl) {
        this.pageUrl = pageUrl;
    }

    public String getReferrerUrl() {
        return referrerUrl;
    }

    public void setReferrerUrl(String referrerUrl) {
        this.referrerUrl = referrerUrl;
    }

    public Integer getDurationSeconds() {
        return durationSeconds;
    }

    public void setDurationSeconds(Integer durationSeconds) {
        this.durationSeconds = durationSeconds;
    }

    public String getMetadata() {
        return metadata;
    }

    public void setMetadata(String metadata) {
        this.metadata = metadata;
    }

    public Integer getEmailLogId() {
        return emailLogId;
    }

    public void setEmailLogId(Integer emailLogId) {
        this.emailLogId = emailLogId;
    }

}
