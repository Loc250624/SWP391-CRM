package model;

import java.time.LocalDateTime;

public class TicketResponse {

    public int responseId;
    public int ticketId;
    public String content;
    public boolean isInternal;
    public String responderType;
    public Integer responderId;
    public String responderName;
    public LocalDateTime createdAt;

    public TicketResponse() {
    }

    public TicketResponse(int responseId, int ticketId, String content, boolean isInternal, String responderType, Integer responderId, String responderName, LocalDateTime createdAt) {
        this.responseId = responseId;
        this.ticketId = ticketId;
        this.content = content;
        this.isInternal = isInternal;
        this.responderType = responderType;
        this.responderId = responderId;
        this.responderName = responderName;
        this.createdAt = createdAt;
    }

    public int getResponseId() {
        return responseId;
    }

    public void setResponseId(int responseId) {
        this.responseId = responseId;
    }

    public int getTicketId() {
        return ticketId;
    }

    public void setTicketId(int ticketId) {
        this.ticketId = ticketId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public boolean isIsInternal() {
        return isInternal;
    }

    public void setIsInternal(boolean isInternal) {
        this.isInternal = isInternal;
    }

    public String getResponderType() {
        return responderType;
    }

    public void setResponderType(String responderType) {
        this.responderType = responderType;
    }

    public Integer getResponderId() {
        return responderId;
    }

    public void setResponderId(Integer responderId) {
        this.responderId = responderId;
    }

    public String getResponderName() {
        return responderName;
    }

    public void setResponderName(String responderName) {
        this.responderName = responderName;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

}
