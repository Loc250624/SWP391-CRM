/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package dao;

import dbConnection.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Customer;

public class CustomerDAO extends DBContext{

    public List<Customer> getAllCustomers() {
        List<Customer> danhSach = new ArrayList<>();
        String sql = "SELECT * FROM customers";
        try (PreparedStatement st = getConnection().prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                danhSach.add(mapResultSetToCustomer(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return danhSach;
    }

    public Customer getCustomerById(int customerId) {
        String sql = "SELECT * FROM customers WHERE customer_id = ?";
        try (PreparedStatement st = getConnection().prepareStatement(sql)) {
            st.setInt(1, customerId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCustomer(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private Customer mapResultSetToCustomer(ResultSet rs) throws Exception {
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
