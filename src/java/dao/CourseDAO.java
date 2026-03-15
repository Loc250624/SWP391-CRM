package dao;

import dbConnection.DBContext;
import java.math.BigDecimal; 
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Course;

public class CourseDAO extends DBContext {

    // 1. Dành cho LEAD: Lấy tất cả khóa học đang trạng thái Active
    public List<Course> getAllActiveCourses() {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT * FROM courses WHERE status = 'Active'";
        
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
             
            while (rs.next()) {
                Course c = new Course();
                c.setCourseId(rs.getInt("course_id"));
                c.setCourseName(rs.getString("course_name"));
                
                // Đã sửa thành getBigDecimal để khớp với Model của bạn
                c.setPrice(rs.getBigDecimal("price")); 
                
                list.add(c);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi tại CourseDAO - getAllActiveCourses: " + e.getMessage());
        }
        return list;
    }

    // 2. Dành cho CUSTOMER: Lấy các khóa học mà người này CHƯA ĐĂNG KÝ
    public List<Course> getAvailableCoursesForCustomer(int customerId) {
        List<Course> list = new ArrayList<>();
        // SQL thông minh: Tìm các khóa học KHÔNG NẰM TRONG danh sách đã mua của ID này
        String sql = "SELECT * FROM courses WHERE status = 'Active' "
                   + "AND course_id NOT IN (SELECT course_id FROM customer_enrollments WHERE customer_id = ?)";
                   
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, customerId);
            
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Course c = new Course();
                    c.setCourseId(rs.getInt("course_id"));
                    c.setCourseName(rs.getString("course_name"));
                    
                    // Đã sửa thành getBigDecimal
                    c.setPrice(rs.getBigDecimal("price")); 
                    
                    list.add(c);
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi tại CourseDAO - getAvailableCoursesForCustomer: " + e.getMessage());
        }
        return list;
    }
}