package model;

import java.sql.Timestamp;

public class User {

    // Các cột trong bảng users
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
    private Timestamp createdAt;
    private Timestamp updatedAt; 

    // Các cột bổ sung từ bảng khác (Joined columns)
    private String fullName;
    private String roleCode;
    private String departmentName;

    public User() {
    }

    // Constructor đầy đủ (Đã thêm tham số updatedAt)
    public User(int userId, String employeeCode, String email, String passwordHash,
            String firstName, String lastName, String phone, String avatarUrl,
            int departmentId, String status, Timestamp createdAt, Timestamp updatedAt, 
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

        // Tự động ghép Full Name
        this.fullName = (lastName != null ? lastName : "") + " " + (firstName != null ? firstName : "");
        this.roleCode = roleCode;
        this.departmentName = departmentName;
    }

    // --- GETTERS AND SETTERS ---

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getEmployeeCode() {
        return employeeCode;
    }

    public void setEmployeeCode(String employeeCode) {
        this.employeeCode = employeeCode;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public int getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(int departmentId) {
        this.departmentId = departmentId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getFullName() {
        return fullName;
    }

    // Lưu ý: fullName thường là thuộc tính dẫn xuất (derived), nên có thể không cần Setter
    // nếu bạn muốn set thủ công thì giữ lại, không thì xóa cũng được.
    public void setFullName(String fullName) { 
        this.fullName = fullName; 
    }

    public String getRoleCode() {
        return roleCode;
    }

    public void setRoleCode(String roleCode) {
        this.roleCode = roleCode;
    }

    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }
}