/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dbConnection.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Customer;

public class CustomerDAO extends DBContext {

    public List<Customer> getAllCustomers() {
        List<Customer> danhSach = new ArrayList<>();
        String sql = "SELECT * FROM customers";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                danhSach.add(mapResultSetToCustomer(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return danhSach;
    }

    // Unassigned customers for picker: owner_id IS NULL + status = 'active' (case-insensitive)
    public List<Customer> getUnassignedCustomersForPicker() {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM customers WHERE owner_id IS NULL"
                + " AND LOWER(status) = 'active'"
                + " ORDER BY created_at DESC";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToCustomer(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Customer getCustomerById(int customerId) {
        String sql = "SELECT * FROM customers WHERE customer_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, customerId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCustomer(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get customers that a sales user can see (created by them OR owned by them)
    public List<Customer> getCustomersBySalesUser(int userId) {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM customers WHERE created_by = ? OR owner_id = ? ORDER BY created_at DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            st.setInt(2, userId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToCustomer(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Generate unique customer code (CUS-000001, CUS-000002, ...)
    public String generateCustomerCode() {
        String sql = "SELECT MAX(CAST(SUBSTRING(customer_code, 5, LEN(customer_code) - 4) AS INT)) "
                + "FROM customers WHERE customer_code LIKE 'CUS-[0-9][0-9][0-9][0-9][0-9][0-9]'";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                int maxNumber = rs.getInt(1);
                return String.format("CUS-%06d", maxNumber + 1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "CUS-000001";
    }

    // Insert new customer
    public boolean insertCustomer(Customer c) {
        String sql = "INSERT INTO customers (customer_code, full_name, email, phone, date_of_birth, gender, "
                + "address, city, source_id, converted_lead_id, customer_segment, status, owner_id, "
                + "total_courses, total_spent, health_score, satisfaction_score, "
                + "email_opt_out, sms_opt_out, notes, "
                + "first_purchase_date, last_purchase_date, purchased_courses, "
                + "created_at, updated_at, created_by) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            if (c.getCustomerCode() == null || c.getCustomerCode().isEmpty()) {
                c.setCustomerCode(generateCustomerCode());
            }
            st.setString(1, c.getCustomerCode());
            st.setString(2, c.getFullName());
            st.setString(3, c.getEmail());
            st.setString(4, c.getPhone());
            if (c.getDateOfBirth() != null) {
                st.setObject(5, c.getDateOfBirth());
            } else {
                st.setNull(5, java.sql.Types.DATE);
            }
            st.setString(6, c.getGender());
            st.setString(7, c.getAddress());
            st.setString(8, c.getCity());
            if (c.getSourceId() != null) {
                st.setInt(9, c.getSourceId());
            } else {
                st.setNull(9, java.sql.Types.INTEGER);
            }
            if (c.getConvertedLeadId() != null) {
                st.setInt(10, c.getConvertedLeadId());
            } else {
                st.setNull(10, java.sql.Types.INTEGER);
            }
            st.setString(11, c.getCustomerSegment() != null ? c.getCustomerSegment() : "New");
            st.setString(12, c.getStatus() != null ? c.getStatus() : "Active");
            if (c.getOwnerId() != null) {
                st.setInt(13, c.getOwnerId());
            } else {
                st.setNull(13, java.sql.Types.INTEGER);
            }
            st.setInt(14, c.getTotalCourses());
            st.setBigDecimal(15, c.getTotalSpent() != null ? c.getTotalSpent() : java.math.BigDecimal.ZERO);
            if (c.getHealthScore() != null) {
                st.setInt(16, c.getHealthScore());
            } else {
                st.setNull(16, java.sql.Types.INTEGER);
            }
            if (c.getSatisfactionScore() != null) {
                st.setInt(17, c.getSatisfactionScore());
            } else {
                st.setNull(17, java.sql.Types.INTEGER);
            }
            st.setBoolean(18, c.isEmailOptOut());
            st.setBoolean(19, c.isSmsOptOut());
            st.setString(20, c.getNotes());
            if (c.getFirstPurchaseDate() != null) {
                st.setObject(21, c.getFirstPurchaseDate());
            } else {
                st.setNull(21, java.sql.Types.DATE);
            }
            if (c.getLastPurchaseDate() != null) {
                st.setObject(22, c.getLastPurchaseDate());
            } else {
                st.setNull(22, java.sql.Types.DATE);
            }
            st.setString(23, c.getPurchasedCourses());
            java.time.LocalDateTime now = java.time.LocalDateTime.now();
            st.setObject(24, now);
            st.setObject(25, now);
            if (c.getCreatedBy() != null) {
                st.setInt(26, c.getCreatedBy());
            } else {
                st.setNull(26, java.sql.Types.INTEGER);
            }
            int rowsAffected = st.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = st.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        c.setCustomerId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update existing customer
    public boolean updateCustomer(Customer c) {
        String sql = "UPDATE customers SET full_name = ?, email = ?, phone = ?, date_of_birth = ?, gender = ?, "
                + "address = ?, city = ?, source_id = ?, customer_segment = ?, status = ?, owner_id = ?, "
                + "health_score = ?, satisfaction_score = ?, email_opt_out = ?, sms_opt_out = ?, "
                + "notes = ?, updated_at = ? WHERE customer_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, c.getFullName());
            st.setString(2, c.getEmail());
            st.setString(3, c.getPhone());
            if (c.getDateOfBirth() != null) {
                st.setObject(4, c.getDateOfBirth());
            } else {
                st.setNull(4, java.sql.Types.DATE);
            }
            st.setString(5, c.getGender());
            st.setString(6, c.getAddress());
            st.setString(7, c.getCity());
            if (c.getSourceId() != null) {
                st.setInt(8, c.getSourceId());
            } else {
                st.setNull(8, java.sql.Types.INTEGER);
            }
            st.setString(9, c.getCustomerSegment());
            st.setString(10, c.getStatus());
            if (c.getOwnerId() != null) {
                st.setInt(11, c.getOwnerId());
            } else {
                st.setNull(11, java.sql.Types.INTEGER);
            }
            if (c.getHealthScore() != null) {
                st.setInt(12, c.getHealthScore());
            } else {
                st.setNull(12, java.sql.Types.INTEGER);
            }
            if (c.getSatisfactionScore() != null) {
                st.setInt(13, c.getSatisfactionScore());
            } else {
                st.setNull(13, java.sql.Types.INTEGER);
            }
            st.setBoolean(14, c.isEmailOptOut());
            st.setBoolean(15, c.isSmsOptOut());
            st.setString(16, c.getNotes());
            st.setObject(17, java.time.LocalDateTime.now());
            st.setInt(18, c.getCustomerId());
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get unassigned customers in manager's department (owner_id IS NULL).
    // Scope: customer was created by someone in the manager's department.
    // ── Unassigned customers (owner_id IS NULL) with filters ──
    public List<Customer> getCustomersByManagerScope(
            String keyword, String status, String segment,
            String dateFrom, String dateTo, String course,
            int offset, int pageSize) {
        List<Customer> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT * FROM customers c WHERE c.owner_id IS NULL");
        List<Object> params = new ArrayList<>();

        appendCustomerFilters(sql, params, keyword, status, segment, dateFrom, dateTo, course);
        sql.append(" ORDER BY c.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(pageSize);

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                st.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToCustomer(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countCustomersByManagerScope(
            String keyword, String status, String segment,
            String dateFrom, String dateTo, String course) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM customers c WHERE c.owner_id IS NULL");
        List<Object> params = new ArrayList<>();
        appendCustomerFilters(sql, params, keyword, status, segment, dateFrom, dateTo, course);
        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                st.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ── Assigned customers (owner_id IS NOT NULL) with filters ──
    public List<Customer> getAssignedCustomers(
            String keyword, String status, String segment,
            String dateFrom, String dateTo, String course,
            int offset, int pageSize) {
        List<Customer> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT * FROM customers c WHERE c.owner_id IS NOT NULL");
        List<Object> params = new ArrayList<>();

        appendCustomerFilters(sql, params, keyword, status, segment, dateFrom, dateTo, course);
        sql.append(" ORDER BY c.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(pageSize);

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                st.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToCustomer(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countAssignedCustomers(
            String keyword, String status, String segment,
            String dateFrom, String dateTo, String course) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM customers c WHERE c.owner_id IS NOT NULL");
        List<Object> params = new ArrayList<>();
        appendCustomerFilters(sql, params, keyword, status, segment, dateFrom, dateTo, course);
        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                st.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ── Shared filter builder ──
    private void appendCustomerFilters(StringBuilder sql, List<Object> params,
            String keyword, String status, String segment,
            String dateFrom, String dateTo, String course) {
        sql.append(" AND LOWER(c.status) = 'active'");
        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = "%" + keyword.trim() + "%";
            sql.append(" AND (c.full_name LIKE ? OR c.customer_code LIKE ? OR c.phone LIKE ? OR c.email LIKE ?)");
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }
        if (segment != null && !segment.trim().isEmpty()) {
            sql.append(" AND LOWER(c.customer_segment) = LOWER(?)");
            params.add(segment);
        }
        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            sql.append(" AND c.created_at >= ?");
            params.add(dateFrom.trim() + " 00:00:00");
        }
        if (dateTo != null && !dateTo.trim().isEmpty()) {
            sql.append(" AND c.created_at <= ?");
            params.add(dateTo.trim() + " 23:59:59");
        }
        if (course != null && !course.trim().isEmpty()) {
            sql.append(" AND c.purchased_courses LIKE ?");
            params.add("%" + course.trim() + "%");
        }
    }

    // Get distinct customer segments for filter dropdown
    public List<String> getDistinctSegments() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT customer_segment FROM customers WHERE customer_segment IS NOT NULL AND customer_segment != '' ORDER BY customer_segment";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("customer_segment"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get distinct statuses for filter dropdown
    public List<String> getDistinctStatuses() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT status FROM customers WHERE status IS NOT NULL AND status != '' ORDER BY status";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("status"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get distinct course names from courses table for filter dropdown
    public List<String> getDistinctCourseNames() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT course_name FROM courses WHERE status = 'Active' ORDER BY course_name";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("course_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get enrolled courses for a customer from customer_enrollments JOIN courses
    public List<Map<String, Object>> getEnrolledCourses(int customerId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT c.course_code, c.course_name, c.price, c.level, c.duration_hours, "
                + "c.total_lessons, c.instructor_name, c.status AS course_status, "
                + "ce.enrollment_code, ce.enrolled_date, ce.original_price, ce.discount_amount, "
                + "ce.final_amount, ce.payment_status, ce.learning_status, "
                + "ce.progress_percentage, ce.lessons_completed "
                + "FROM customer_enrollments ce "
                + "INNER JOIN courses c ON c.course_id = ce.course_id "
                + "WHERE ce.customer_id = ? "
                + "ORDER BY ce.enrolled_date DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, customerId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("courseCode", rs.getString("course_code"));
                    m.put("courseName", rs.getString("course_name"));
                    m.put("price", rs.getBigDecimal("price"));
                    m.put("level", rs.getString("level"));
                    m.put("durationHours", rs.getObject("duration_hours"));
                    m.put("totalLessons", rs.getObject("total_lessons"));
                    m.put("instructorName", rs.getString("instructor_name"));
                    m.put("courseStatus", rs.getString("course_status"));
                    m.put("enrollmentCode", rs.getString("enrollment_code"));
                    m.put("enrolledDate", rs.getObject("enrolled_date"));
                    m.put("originalPrice", rs.getBigDecimal("original_price"));
                    m.put("discountAmount", rs.getBigDecimal("discount_amount"));
                    m.put("finalAmount", rs.getBigDecimal("final_amount"));
                    m.put("paymentStatus", rs.getString("payment_status"));
                    m.put("learningStatus", rs.getString("learning_status"));
                    m.put("progressPercentage", rs.getInt("progress_percentage"));
                    m.put("lessonsCompleted", rs.getInt("lessons_completed"));
                    list.add(m);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Assign a Customer to a Sales user (set owner_id)
    public boolean updateCustomerOwnerId(int customerId, int salesId) {
        String sql = "UPDATE customers SET owner_id = ?, updated_at = ? WHERE customer_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, salesId);
            st.setObject(2, java.time.LocalDateTime.now());
            st.setInt(3, customerId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Count tasks linked to a customer
    public int countTasksByCustomerId(int customerId) {
        String sql = "SELECT COUNT(*) FROM tasks WHERE related_type = 'CUSTOMER' AND related_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, customerId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Get most recent task date for a customer (last interaction)
    public java.time.LocalDateTime getLastActivityDateByCustomerId(int customerId) {
        String sql = "SELECT TOP 1 created_at FROM tasks WHERE related_type = 'CUSTOMER' AND related_id = ? ORDER BY created_at DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, customerId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next() && rs.getTimestamp("created_at") != null) {
                    return rs.getTimestamp("created_at").toLocalDateTime();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Delete customer
    public boolean deleteCustomer(int customerId) {
        String sql = "DELETE FROM customers WHERE customer_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, customerId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getTotalCustomersCount() {
        String sql = "SELECT COUNT(*) FROM customers";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Customer mapResultSetToCustomer(ResultSet rs) throws SQLException {
        Customer c = new Customer();
        c.setCustomerId(rs.getInt("customer_id"));
        c.setCustomerCode(rs.getString("customer_code"));
        c.setFullName(rs.getString("full_name"));
        c.setEmail(rs.getString("email"));
        c.setPhone(rs.getString("phone"));
        if (rs.getDate("date_of_birth") != null) {
            c.setDateOfBirth(rs.getDate("date_of_birth").toLocalDate());
        }
        c.setGender(rs.getString("gender"));
        c.setAddress(rs.getString("address"));
        c.setCity(rs.getString("city"));
        c.setSourceId(rs.getObject("source_id", Integer.class));
        c.setConvertedLeadId(rs.getObject("converted_lead_id", Integer.class));
        c.setCustomerSegment(rs.getString("customer_segment"));
        c.setStatus(rs.getString("status"));
        c.setOwnerId(rs.getObject("owner_id", Integer.class));
        c.setTotalCourses(rs.getInt("total_courses"));
        c.setTotalSpent(rs.getBigDecimal("total_spent"));
        if (rs.getDate("first_purchase_date") != null) {
            c.setFirstPurchaseDate(rs.getDate("first_purchase_date").toLocalDate());
        }
        if (rs.getDate("last_purchase_date") != null) {
            c.setLastPurchaseDate(rs.getDate("last_purchase_date").toLocalDate());
        }
        c.setPurchasedCourses(rs.getString("purchased_courses"));
        c.setHealthScore(rs.getObject("health_score", Integer.class));
        c.setSatisfactionScore(rs.getObject("satisfaction_score", Integer.class));
        c.setEmailOptOut(rs.getBoolean("email_opt_out"));
        c.setSmsOptOut(rs.getBoolean("sms_opt_out"));
        c.setNotes(rs.getString("notes"));
        if (rs.getTimestamp("created_at") != null) {
            c.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        }
        if (rs.getTimestamp("updated_at") != null) {
            c.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        }
        c.setCreatedBy(rs.getObject("created_by", Integer.class));
        return c;
    }

    // Batch fetch customer full_name by IDs — used for "related object" column in task list
    public Map<Integer, String> getCustomerNameMap(List<Integer> customerIds) {
        Map<Integer, String> map = new HashMap<>();
        if (customerIds == null || customerIds.isEmpty()) {
            return map;
        }
        StringBuilder sql = new StringBuilder("SELECT customer_id, full_name FROM customers WHERE customer_id IN (");
        for (int i = 0; i < customerIds.size(); i++) {
            sql.append(i > 0 ? ",?" : "?");
        }
        sql.append(")");
        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < customerIds.size(); i++) {
                st.setInt(i + 1, customerIds.get(i));
            }
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getInt("customer_id"), rs.getString("full_name"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
    }
    // Lấy danh sách khách hàng CHỈ do người dùng này tạo ra

    // ── CRM Pool: unassigned customers with no active tasks ──
    public List<Customer> getPoolCustomers(String keyword, int offset, int pageSize) {
        List<Customer> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT * FROM customers c"
                + " WHERE c.owner_id IS NULL"
                + " AND c.created_by NOT IN ("
                + "   SELECT ur.user_id FROM user_roles ur"
                + "   INNER JOIN roles r ON r.role_id = ur.role_id"
                + "   WHERE r.role_code = 'SALE')"
                + " AND NOT EXISTS ("
                + "   SELECT 1 FROM task_relations tr"
                + "   INNER JOIN tasks t ON t.task_id = tr.task_id"
                + "   WHERE tr.related_type = 'CUSTOMER' AND tr.related_id = c.customer_id"
                + "   AND (t.is_deleted = 0 OR t.is_deleted IS NULL) AND t.status NOT IN (2,3))"
        );
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (c.full_name LIKE ? OR c.phone LIKE ? OR c.customer_code LIKE ?)");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }
        sql.append(" ORDER BY c.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(pageSize);

        System.out.println("[CustomerDAO.getPoolCustomers] SQL: " + sql.toString());
        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                st.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToCustomer(rs));
                }
            }
        } catch (Exception e) {
            System.out.println("[CustomerDAO.getPoolCustomers] ERROR: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("[CustomerDAO.getPoolCustomers] Result size: " + list.size());
        return list;
    }

    public int countPoolCustomers(String keyword) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM customers c"
                + " WHERE c.owner_id IS NULL"
                + " AND c.created_by NOT IN ("
                + "   SELECT ur.user_id FROM user_roles ur"
                + "   INNER JOIN roles r ON r.role_id = ur.role_id"
                + "   WHERE r.role_code = 'SALE')"
                + " AND NOT EXISTS ("
                + "   SELECT 1 FROM task_relations tr"
                + "   INNER JOIN tasks t ON t.task_id = tr.task_id"
                + "   WHERE tr.related_type = 'CUSTOMER' AND tr.related_id = c.customer_id"
                + "   AND (t.is_deleted = 0 OR t.is_deleted IS NULL) AND t.status NOT IN (2,3))"
        );
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (c.full_name LIKE ? OR c.phone LIKE ? OR c.customer_code LIKE ?)");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }
        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                st.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

   public List<Customer> getCustomersByCreator(int userId) {
        List<Customer> list = new ArrayList<>();
        // SQL V8.1: ĐÃ SỬA LỖI (XÓA COMMENT SQL GÂY LỖI) VÀ TỐI ƯU GIAO DIỆN
        String sql = "SELECT c.*, "
                   + "CASE "
                   + "    WHEN LOWER(c.status) = 'inactive' THEN '<span class=\"text-muted opacity-50\">-</span>' "
                   + "    ELSE COALESCE( "
                   + "        NULLIF((SELECT STRING_AGG( "
                   + "            '<div class=\"d-flex align-items-start gap-2 mb-3\">' "
                   + "            + '<i class=\"bi bi-journal-bookmark-fill text-primary\" style=\"margin-top: 2px;\"></i>' "
                   + "            + '<div class=\"d-flex flex-column gap-1\">' "
                   + "            + '  <span class=\"fw-bold text-dark\" style=\"font-size: 13.5px; line-height: 1.2;\">' + ISNULL(crs.course_name, 'Khóa học chưa xác định') + '</span>' "
                   + "            + '  <span class=\"badge rounded-pill bg-warning text-dark timer shadow-sm\" style=\"font-size: 11px; padding: 4px 10px; width: fit-content;\" data-endtime=\"' + CONVERT(varchar, DATEADD(day, 30, ce.enrolled_date), 120) + '\">' "
                   + "            + '    <i class=\"bi bi-clock-history me-1\"></i> Đang tính...</span>' "
                   + "            + '</div>' "
                   + "            + '</div>', '') "
                   + "            FROM customer_enrollments ce "
                   + "            LEFT JOIN courses crs ON ce.course_id = crs.course_id "
                   + "            WHERE ce.customer_id = c.customer_id "
                   + "            AND DATEADD(day, 30, ce.enrolled_date) > GETDATE()), ''), "
                   + "        '<span class=\"text-muted fst-italic small\">Chưa đăng ký</span>' "
                   + "    ) "
                   + "END AS timer_courses "
                   + "FROM customers c "
                   + "WHERE c.created_by = ? "
                   + "ORDER BY c.created_at DESC";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Customer c = mapResultSetToCustomer(rs);
                    c.setPurchasedCourses(rs.getString("timer_courses"));
                    list.add(c);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
