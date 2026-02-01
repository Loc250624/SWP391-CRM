package model;

import java.sql.Timestamp;

public class Ticket {
    private int id;
    private int customerId;
    private String title;
    private String description;
    private int statusId;
    private Timestamp createdAt;

    public Ticket() {}

    public Ticket(int customerId, String title, String description, int statusId) {
        this.customerId = customerId;
        this.title = title;
        this.description = description;
        this.statusId = statusId;
    }

    // Getter và Setter (Bắt buộc phải có để JSP truy cập được nếu cần)
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public int getStatusId() { return statusId; }
    public void setStatusId(int statusId) { this.statusId = statusId; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}