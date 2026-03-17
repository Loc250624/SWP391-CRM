package dao;

import dbConnection.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.CustomerEnrollment;

public class EnrollmentDAO extends DBContext {

    // Generate unique enrollment code (ENR-000001, ENR-000002, ...)
    public String generateEnrollmentCode() {
        String sql = "SELECT MAX(CAST(SUBSTRING(enrollment_code, 5, LEN(enrollment_code) - 4) AS INT)) "
                + "FROM customer_enrollments WHERE enrollment_code LIKE 'ENR-[0-9][0-9][0-9][0-9][0-9][0-9]'";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                int maxNumber = rs.getInt(1);
                return String.format("ENR-%06d", maxNumber + 1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "ENR-000001";
    }

    // Insert a new enrollment record; sets enrollmentId on success
    public boolean insertEnrollment(CustomerEnrollment en) {
        String sql = "INSERT INTO customer_enrollments ("
                + "enrollment_code, customer_id, course_id, enrolled_date, "
                + "original_price, discount_amount, final_amount, "
                + "payment_status, learning_status, progress_percentage, lessons_completed, "
                + "source_id, campaign_id, assigned_to, notes, "
                + "created_at, updated_at, created_by"
                + ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            if (en.getEnrollmentCode() == null || en.getEnrollmentCode().isEmpty()) {
                en.setEnrollmentCode(generateEnrollmentCode());
            }
            st.setString(1, en.getEnrollmentCode());
            st.setInt(2, en.getCustomerId());
            st.setInt(3, en.getCourseId());
            st.setObject(4, en.getEnrolledDate() != null ? en.getEnrolledDate() : java.time.LocalDate.now());

            st.setBigDecimal(5, en.getOriginalPrice() != null ? en.getOriginalPrice() : java.math.BigDecimal.ZERO);
            st.setBigDecimal(6, en.getDiscountAmount() != null ? en.getDiscountAmount() : java.math.BigDecimal.ZERO);
            st.setBigDecimal(7, en.getFinalAmount() != null ? en.getFinalAmount() : java.math.BigDecimal.ZERO);

            st.setString(8, en.getPaymentStatus() != null ? en.getPaymentStatus() : "Pending");
            st.setString(9, en.getLearningStatus() != null ? en.getLearningStatus() : "Not Started");
            st.setInt(10, en.getProgressPercentage() != null ? en.getProgressPercentage() : 0);
            st.setInt(11, en.getLessonsCompleted() != null ? en.getLessonsCompleted() : 0);

            if (en.getSourceId() != null) {
                st.setInt(12, en.getSourceId());
            } else {
                st.setNull(12, java.sql.Types.INTEGER);
            }
            if (en.getCampaignId() != null) {
                st.setInt(13, en.getCampaignId());
            } else {
                st.setNull(13, java.sql.Types.INTEGER);
            }
            if (en.getAssignedTo() != null) {
                st.setInt(14, en.getAssignedTo());
            } else {
                st.setNull(14, java.sql.Types.INTEGER);
            }
            st.setString(15, en.getNotes());

            java.time.LocalDateTime now = java.time.LocalDateTime.now();
            st.setObject(16, now);
            st.setObject(17, now);
            if (en.getCreatedBy() != null) {
                st.setInt(18, en.getCreatedBy());
            } else {
                st.setNull(18, java.sql.Types.INTEGER);
            }

            int rows = st.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = st.getGeneratedKeys()) {
                    if (keys.next()) {
                        en.setEnrollmentId(keys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteEnrollmentsByCustomerId(int customerId) {
        String sql = "DELETE FROM customer_enrollments WHERE customer_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, customerId);
            st.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

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

    public List<CustomerEnrollment> getAllEnrollments() {
        List<CustomerEnrollment> list = new ArrayList<>();
        String sql = "SELECT e.*, c.course_name, cust.full_name as customer_name " +
                "FROM customer_enrollments e " +
                "JOIN courses c ON e.course_id = c.course_id " +
                "JOIN customers cust ON e.customer_id = cust.customer_id " +
                "ORDER BY e.enrolled_date DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
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
                e.setNotes(rs.getString("customer_name")); // Borrowing notes field to store customer name for display
                list.add(e);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
