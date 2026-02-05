package dao;

import dbConnection.DBContext;
import model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {
    
    public User login(String email, String password) {
        // Query nối bảng users + roles + departments để lấy Full thông tin
        // u.* : Lấy hết cột bảng users (bao gồm cả updated_at)
        String sql = "SELECT u.*, r.role_code, d.department_name " +
                     "FROM users u " +
                     "JOIN user_roles ur ON u.user_id = ur.user_id " +
                     "JOIN roles r ON ur.role_id = r.role_id " +
                     "LEFT JOIN departments d ON u.department_id = d.department_id " +
                     "WHERE u.email = ? AND u.password_hash = ? AND u.status = 'Active'";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.setString(2, password);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                // Khởi tạo User với full tham số (Lưu ý thứ tự phải khớp với Constructor bên Model)
                return new User(
                    rs.getInt("user_id"),
                    rs.getString("employee_code"),
                    rs.getString("email"),
                    rs.getString("password_hash"),
                    rs.getString("first_name"),
                    rs.getString("last_name"),
                    rs.getString("phone"),
                    rs.getString("avatar_url"),
                    rs.getInt("department_id"),
                    rs.getString("status"),
                    rs.getTimestamp("created_at"),
                    rs.getTimestamp("updated_at"), // <--- ĐÃ BỔ SUNG DÒNG NÀY
                    rs.getString("role_code"),      
                    rs.getString("department_name") 
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}