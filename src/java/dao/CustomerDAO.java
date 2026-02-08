package dao;

import dbConnection.DBContext;
import model.Customer;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {
    public List<Customer> getAllCustomers() {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM customers";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Customer(
                    rs.getInt("customer_id"), rs.getString("customer_code"), rs.getString("full_name"),
                    rs.getString("email"), rs.getString("phone"), rs.getTimestamp("date_of_birth"),
                    rs.getString("gender"), rs.getString("address"), rs.getString("city"),
                    (Integer) rs.getObject("source_id"), (Integer) rs.getObject("converted_lead_id"),
                    rs.getString("customer_segment"), rs.getString("status"), (Integer) rs.getObject("owner_id"),
                    (Integer) rs.getObject("total_courses"), rs.getDouble("total_spent"),
                    rs.getTimestamp("first_purchase_date"), rs.getTimestamp("last_purchase_date"),
                    rs.getString("purchased_courses"), rs.getDouble("health_score"),
                    rs.getDouble("satisfaction_score"), rs.getBoolean("email_opt_out"),
                    rs.getBoolean("sms_opt_out"), rs.getString("notes"),
                    rs.getTimestamp("created_at"), rs.getTimestamp("updated_at"), (Integer) rs.getObject("created_by")
                ));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}