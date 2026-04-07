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

        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {

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

    public int getTotalActiveCoursesCount() {
        String sql = "SELECT COUNT(*) FROM courses WHERE status = 'Active'";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy tất cả khóa học theo category_id
    public List<Course> getCoursesByCategoryId(int categoryId) {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT * FROM courses WHERE category_id = ? ORDER BY course_name";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, categoryId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Course c = new Course();
                    c.setCourseId(rs.getInt("course_id"));
                    c.setCourseCode(rs.getString("course_code"));
                    c.setCourseName(rs.getString("course_name"));
                    c.setCategoryId(rs.getInt("category_id"));
                    c.setShortDescription(rs.getString("short_description"));
                    c.setPrice(rs.getBigDecimal("price"));
                    c.setOriginalPrice(rs.getBigDecimal("original_price"));
                    c.setDiscountPercentage(rs.getObject("discount_percentage") != null ? rs.getInt("discount_percentage") : null);
                    c.setDurationHours(rs.getObject("duration_hours") != null ? rs.getInt("duration_hours") : null);
                    c.setTotalLessons(rs.getObject("total_lessons") != null ? rs.getInt("total_lessons") : null);
                    c.setLevel(rs.getString("level"));
                    c.setInstructorName(rs.getString("instructor_name"));
                    c.setTotalEnrolled(rs.getObject("total_enrolled") != null ? rs.getInt("total_enrolled") : null);
                    c.setRatingAvg(rs.getBigDecimal("rating_avg"));
                    c.setRatingCount(rs.getObject("rating_count") != null ? rs.getInt("rating_count") : null);
                    c.setThumbnailUrl(rs.getString("thumbnail_url"));
                    c.setStatus(rs.getString("status"));
                    if (rs.getTimestamp("created_at") != null) {
                        c.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    }
                    list.add(c);
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi tại CourseDAO - getCoursesByCategoryId: " + e.getMessage());
        }
        return list;
    }

    // 2. Dành cho CUSTOMER: Lấy các khóa học mà người này CHƯA ĐĂNG KÝ
    public List<Course> getAvailableCoursesForCustomer(int customerId) {
        List<Course> list = new ArrayList<>();
        // SQL THÔNG MINH HƠN: Chỉ chặn những khóa học ĐANG CÒN HẠN (30 ngày kể từ ngày đăng ký).
        // Nếu khóa học đã đăng ký quá 30 ngày (hết hạn), nó sẽ KHÔNG bị chặn và được hiện ra để Upsale!
        String sql = "SELECT * FROM courses WHERE status = 'Active' "
                + "AND course_id NOT IN ("
                + "    SELECT course_id FROM customer_enrollments "
                + "    WHERE customer_id = ? "
                + "    AND DATEADD(day, 30, enrolled_date) > GETDATE()"
                + ")";

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
