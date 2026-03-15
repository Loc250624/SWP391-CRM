package dao;

import dbConnection.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserRoleDAO extends DBContext {

    public int getRoleIdByUserId(int userId) {
        String sql = "SELECT role_id FROM user_roles WHERE user_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("role_id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public void updateUserRole(int userId, int newRoleId) {
        // Check if user already has a role
        int existingRoleId = getRoleIdByUserId(userId);
        
        String sql;
        if (existingRoleId != -1) {
            sql = "UPDATE user_roles SET role_id = ? WHERE user_id = ?";
        } else {
            sql = "INSERT INTO user_roles (role_id, user_id) VALUES (?, ?)";
        }

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, newRoleId);
            st.setInt(2, userId);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
