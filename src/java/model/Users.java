package model;

import java.time.LocalDateTime;

/**
 * Model User hoàn chỉnh - Đã cập nhật sang LocalDateTime
 */
public class Users {

    // 1. Các cột cơ bản từ bảng users
    private int userId;
    private String employeeCode;
    private String email;
    private String passwordHash; 
    private String firstName;
    private String lastName;
    private String phone;
    private String avatarUrl;
    private int departmentId;
    private String status;
    private LocalDateTime createdAt; // Kiểu hiện đại
    private LocalDateTime updatedAt; // Kiểu hiện đại

    // 2. Các cột bổ sung từ logic JOIN (Roles & Departments)
    private String fullName;
    private String roleCode;
    private String departmentName;

    // Constructor mặc định (Không tham số)
    public Users() {
    }

    // Constructor đầy đủ tham số (Thứ tự khớp với hàm login trong DAO)
    public Users(int userId, String employeeCode, String email, String passwordHash,
                String firstName, String lastName, String phone, String avatarUrl,
                int departmentId, String status, LocalDateTime createdAt, LocalDateTime updatedAt, 
                String roleCode, String departmentName) {
        this.userId = userId;
        this.employeeCode = employeeCode;
        this.email = email;
        this.passwordHash = passwordHash;
        this.firstName = firstName;
        this.lastName = lastName;
        this.phone = phone;
        this.avatarUrl = avatarUrl;
        this.departmentId = departmentId;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.roleCode = roleCode;
        this.departmentName = departmentName;

        // Tự động ghép Full Name
        updateFullName();
    }

    // --- GETTERS AND SETTERS ---

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getEmployeeCode() { return employeeCode; }
    public void setEmployeeCode(String employeeCode) { this.employeeCode = employeeCode; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { 
        this.firstName = firstName;
        updateFullName();
    }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { 
        this.lastName = lastName;
        updateFullName();
    }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }

    public int getDepartmentId() { return departmentId; }
    public void setDepartmentId(int departmentId) { this.departmentId = departmentId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getRoleCode() { return roleCode; }
    public void setRoleCode(String roleCode) { this.roleCode = roleCode; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    /**
     * Hàm hỗ trợ tự động cập nhật họ tên
     */
    private void updateFullName() {
        String fName = (firstName != null) ? firstName : "";
        String lName = (lastName != null) ? lastName : "";
        this.fullName = (lName + " " + fName).trim();
    }
}