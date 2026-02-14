/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package dao;

import dbConnection.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Customer;

public class CustomerDAO extends DBContext{

    public List<Customer> getAllCustomers() {
        List<Customer> danhSach = new ArrayList<>();
        String sql = "SELECT * FROM customers";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
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
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
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
        String sql = "INSERT INTO customers (customer_code, full_name, email, phone, date_of_birth, gender, " +
                     "address, city, source_id, converted_lead_id, customer_segment, status, owner_id, " +
                     "total_courses, total_spent, health_score, satisfaction_score, " +
                     "email_opt_out, sms_opt_out, notes, created_at, updated_at, created_by) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
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
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update existing customer
    public boolean updateCustomer(Customer c) {
        String sql = "UPDATE customers SET full_name = ?, email = ?, phone = ?, date_of_birth = ?, gender = ?, " +
                     "address = ?, city = ?, source_id = ?, customer_segment = ?, status = ?, owner_id = ?, " +
                     "health_score = ?, satisfaction_score = ?, email_opt_out = ?, sms_opt_out = ?, " +
                     "notes = ?, updated_at = ? WHERE customer_id = ?";
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
}
