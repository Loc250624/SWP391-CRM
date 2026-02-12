package model;

import java.time.LocalDateTime;

public class UserRole {

    public int userRoleId;
    public int userId;
    public int roleId;
    public LocalDateTime assignedAt;
    public Integer assignedBy; // nullable FK users

    public UserRole() {
    }

    public UserRole(int userRoleId, int userId, int roleId, LocalDateTime assignedAt, Integer assignedBy) {
        this.userRoleId = userRoleId;
        this.userId = userId;
        this.roleId = roleId;
        this.assignedAt = assignedAt;
        this.assignedBy = assignedBy;
    }

    public int getUserRoleId() {
        return userRoleId;
    }

    public void setUserRoleId(int userRoleId) {
        this.userRoleId = userRoleId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
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
