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
        String sql = "SELECT TOP 1 customer_code FROM customers ORDER BY customer_id DESC";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                String lastCode = rs.getString("customer_code");
                int number = Integer.parseInt(lastCode.substring(4));
                return String.format("CUS-%06d", number + 1);
            } else {
                return "CUS-000001";
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "CUS-" + System.currentTimeMillis();
    }

    // Insert new customer
    public boolean insertCustomer(Customer c) {
        String sql = "INSERT INTO customers (customer_code, full_name, email, phone, date_of_birth, gender, "
                + "address, city, source_id, converted_lead_id, customer_segment, status, owner_id, "
                + "total_courses, total_spent, health_score, satisfaction_score, "
                + "email_opt_out, sms_opt_out, notes, created_at, updated_at, created_by) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
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
            java.time.LocalDateTime now = java.time.LocalDateTime.now();
            st.setObject(21, now);
            st.setObject(22, now);
            if (c.getCreatedBy() != null) {
                st.setInt(23, c.getCreatedBy());
            } else {
                st.setNull(23, java.sql.Types.INTEGER);
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
    public List<Customer> getCustomersByManagerScope(int departmentId,
            String keyword, String status, int offset, int pageSize) {
        List<Customer> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT * FROM customers c WHERE c.owner_id IS NULL"
                + " AND c.created_by IN (SELECT user_id FROM users WHERE department_id = ?)");
        List<Object> params = new ArrayList<>();
        params.add(departmentId);

        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = "%" + keyword.trim() + "%";
            sql.append(" AND (c.full_name LIKE ? OR c.customer_code LIKE ? OR c.phone LIKE ? OR c.email LIKE ?)");
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND c.status = ?");
            params.add(status);
        }
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

    // Count unassigned customers in manager's department scope for pagination
    public int countCustomersByManagerScope(int departmentId,
            String keyword, String status) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM customers c WHERE c.owner_id IS NULL"
                + " AND c.created_by IN (SELECT user_id FROM users WHERE department_id = ?)");
        List<Object> params = new ArrayList<>();
        params.add(departmentId);

        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = "%" + keyword.trim() + "%";
            sql.append(" AND (c.full_name LIKE ? OR c.customer_code LIKE ? OR c.phone LIKE ? OR c.email LIKE ?)");
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND c.status = ?");
            params.add(status);
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
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
    public List<Customer> getPoolCustomers(int deptId, String keyword, int offset, int pageSize) {
        List<Customer> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT * FROM customers c" +
            " WHERE c.owner_id IS NULL" +
            " AND c.created_by IN (SELECT user_id FROM users WHERE department_id = ?)" +
            " AND NOT EXISTS (" +
            "   SELECT 1 FROM task_relations tr" +
            "   INNER JOIN tasks t ON t.task_id = tr.task_id" +
            "   WHERE tr.related_type = 'CUSTOMER' AND tr.related_id = c.customer_id" +
            "   AND (t.is_deleted = 0 OR t.is_deleted IS NULL) AND t.status NOT IN (2,3))"
        );
        List<Object> params = new ArrayList<>();
        params.add(deptId);
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (c.full_name LIKE ? OR c.phone LIKE ? OR c.customer_code LIKE ?)");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw); params.add(kw); params.add(kw);
        }
        sql.append(" ORDER BY c.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset); params.add(pageSize);

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) st.setObject(i + 1, params.get(i));
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) list.add(mapResultSetToCustomer(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int countPoolCustomers(int deptId, String keyword) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM customers c" +
            " WHERE c.owner_id IS NULL" +
            " AND c.created_by IN (SELECT user_id FROM users WHERE department_id = ?)" +
            " AND NOT EXISTS (" +
            "   SELECT 1 FROM task_relations tr" +
            "   INNER JOIN tasks t ON t.task_id = tr.task_id" +
            "   WHERE tr.related_type = 'CUSTOMER' AND tr.related_id = c.customer_id" +
            "   AND (t.is_deleted = 0 OR t.is_deleted IS NULL) AND t.status NOT IN (2,3))"
        );
        List<Object> params = new ArrayList<>();
        params.add(deptId);
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (c.full_name LIKE ? OR c.phone LIKE ? OR c.customer_code LIKE ?)");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw); params.add(kw); params.add(kw);
        }
        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) st.setObject(i + 1, params.get(i));
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<Customer> getCustomersByCreator(int userId) {
        List<Customer> list = new ArrayList<>();
        // SQL: Lọc chính xác cột created_by
        String sql = "SELECT * FROM customers WHERE created_by = ? ORDER BY created_at DESC";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
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
}
