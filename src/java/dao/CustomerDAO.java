package dao;

import dbConnection.DBContext;
import model.Customer;
import model.Course;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {

    // 1. Lấy thông tin cá nhân
    public Customer getCustomerById(int id) {
        String sql = "SELECT * FROM customers WHERE id = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Customer c = new Customer();
                c.setId(rs.getInt("id"));
                c.setFullName(rs.getString("full_name"));
                c.setEmail(rs.getString("email"));
                c.setPhone(rs.getString("phone"));
                c.setCreatedAt(rs.getTimestamp("created_at"));
                return c;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // 2. Lấy danh sách khóa học đã mua (Full thông tin)
    public List<Course> getCoursesByCustomerId(int customerId) {
        List<Course> list = new ArrayList<>();
        
        // JOIN 3 bảng: courses <-> customer_courses <-> customers
        String sql = "SELECT c.* FROM courses c " +
                     "JOIN customer_courses cc ON c.id = cc.course_id " +
                     "WHERE cc.customer_id = ?";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Course c = new Course();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setPrice(rs.getDouble("price"));
                c.setDescription(rs.getString("description")); // Đã có cột này
                c.setImage(rs.getString("image"));             // Đã có cột này
                list.add(c);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}