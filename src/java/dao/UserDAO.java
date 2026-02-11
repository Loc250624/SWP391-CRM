package dao;

import dbConnection.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Users; 

public class UserDAO extends DBContext {

    public Users login(String email, String password) {
        String sql = "SELECT u.*, r.role_code, d.department_name " +
                     "FROM users u " +
                     "JOIN user_roles ur ON u.user_id = ur.user_id " +
                     "JOIN roles r ON ur.role_id = r.role_id " +
                     "LEFT JOIN departments d ON u.department_id = d.department_id " +
                     "WHERE u.email = ? AND u.password_hash = ? AND u.status = 'Active'";
        
        try (Connection conn = connection;
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.setString(2, password);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

  
    public List<Users> getAllUsers() {
        List<Users> danhSach = new ArrayList<>();
        // Nếu muốn hiện tên phòng ban ở danh sách, hãy dùng câu SQL JOIN giống hàm login
        String sql = "SELECT u.*, r.role_code, d.department_name " +
                     "FROM users u " +
                     "LEFT JOIN user_roles ur ON u.user_id = ur.user_id " +
                     "LEFT JOIN roles r ON ur.role_id = r.role_id " +
                     "LEFT JOIN departments d ON u.department_id = d.department_id";
        
        try (Connection conn = connection;
             PreparedStatement st = conn.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                danhSach.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return danhSach;
    }

    
    public Users getUserById(int userId) {
        String sql = "SELECT u.*, r.role_code, d.department_name " +
                     "FROM users u " +
                     "LEFT JOIN user_roles ur ON u.user_id = ur.user_id " +
                     "LEFT JOIN roles r ON ur.role_id = r.role_id " +
                     "LEFT JOIN departments d ON u.department_id = d.department_id " +
                     "WHERE u.user_id = ?";
        
        try (Connection conn = connection;
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Users mapResultSetToUser(ResultSet rs) throws SQLException {
        Users u = new Users();
        u.setUserId(rs.getInt("user_id"));
        u.setEmployeeCode(rs.getString("employee_code"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setFirstName(rs.getString("first_name"));
        u.setLastName(rs.getString("last_name"));
        u.setPhone(rs.getString("phone"));
        u.setAvatarUrl(rs.getString("avatar_url"));
        u.setDepartmentId(rs.getObject("department_id", Integer.class));
        u.setStatus(rs.getString("status"));
        
        // Map ngày tháng
        Timestamp created = rs.getTimestamp("created_at");
        if (created != null) u.setCreatedAt(created.toLocalDateTime());
        
        Timestamp updated = rs.getTimestamp("updated_at");
        if (updated != null) u.setUpdatedAt(updated.toLocalDateTime());

        // Map các thông tin JOIN thêm (nếu có)
       
        
        return u;
    }
}