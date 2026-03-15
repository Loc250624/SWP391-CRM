package dao;

import dbConnection.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.CustomerEnrollment;

public class EnrollmentDAO extends DBContext {

    public List<CustomerEnrollment> getEnrollmentsByCustomerId(int customerId) {
        List<CustomerEnrollment> list = new ArrayList<>();
        // Query joins with courses to get course name
        String sql = "SELECT e.*, c.course_name " +
                "FROM customer_enrollments e " +
                "JOIN courses c ON e.course_id = c.course_id " +
                "WHERE e.customer_id = ? " +
                "ORDER BY e.enrolled_date DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CustomerEnrollment e = new CustomerEnrollment();
                e.setEnrollmentId(rs.getInt("enrollment_id"));
                e.setEnrollmentCode(rs.getString("enrollment_code"));
                e.setCustomerId(rs.getInt("customer_id"));
                e.setCourseId(rs.getInt("course_id"));
                if (rs.getDate("enrolled_date") != null) {
                    e.setEnrolledDate(rs.getDate("enrolled_date").toLocalDate());
                }
                e.setFinalAmount(rs.getBigDecimal("final_amount"));
                e.setPaymentStatus(rs.getString("payment_status"));
                e.setLearningStatus(rs.getString("learning_status"));
                e.setProgressPercentage(rs.getInt("progress_percentage"));
                e.setCourseName(rs.getString("course_name"));
                list.add(e);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
