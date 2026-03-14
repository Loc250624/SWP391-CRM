package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Customer;
import util.PagedResult;

public class CustomerCoreDAO extends CustomerDAO {

    public PagedResult<Customer> searchCustomers(String q, String status, Integer tagId, String segment, int page, int pageSize) {
        List<Customer> list = new ArrayList<>();
        int totalItems = 0;
        
        StringBuilder sql = new StringBuilder("SELECT DISTINCT c.* FROM customers c ");
        StringBuilder countSql = new StringBuilder("SELECT COUNT(DISTINCT c.customer_id) FROM customers c ");
        
        if (tagId != null) {
            sql.append(" JOIN customer_tag_assignments cta ON c.customer_id = cta.customer_id ");
            countSql.append(" JOIN customer_tag_assignments cta ON c.customer_id = cta.customer_id ");
        }
        
        sql.append(" WHERE 1=1 ");
        countSql.append(" WHERE 1=1 ");
        
        List<Object> params = new ArrayList<>();
        
        if (q != null && !q.trim().isEmpty()) {
            sql.append(" AND (c.full_name LIKE ? OR c.email LIKE ? OR c.phone LIKE ?) ");
            countSql.append(" AND (c.full_name LIKE ? OR c.email LIKE ? OR c.phone LIKE ?) ");
            String likeQ = "%" + q.trim() + "%";
            params.add(likeQ);
            params.add(likeQ);
            params.add(likeQ);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND c.status = ? ");
            countSql.append(" AND c.status = ? ");
            params.add(status.trim());
        }
        if (segment != null && !segment.trim().isEmpty()) {
            sql.append(" AND c.customer_segment = ? ");
            countSql.append(" AND c.customer_segment = ? ");
            params.add(segment.trim());
        }
        if (tagId != null) {
            sql.append(" AND cta.tag_id = ? ");
            countSql.append(" AND cta.tag_id = ? ");
            params.add(tagId);
        }
        
        // Count total items
        try (PreparedStatement st = connection.prepareStatement(countSql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                st.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    totalItems = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        // Items for current page
        sql.append(" ORDER BY c.customer_id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * pageSize);
        params.add(pageSize);
        
        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                st.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(getCustomerFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return new PagedResult<>(list, totalItems, page, pageSize);
    }
    
    public int createCustomer(Customer c) {
        boolean success = insertCustomer(c);
        if (success) {
            return c.getCustomerId();
        }
        return -1;
    }

    public List<Customer> findDuplicatesByEmail() {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM customers WHERE email IN ("
                + "  SELECT email FROM customers WHERE email IS NOT NULL AND email <> '' "
                + "  GROUP BY email HAVING COUNT(*) > 1"
                + ") ORDER BY email, customer_id";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(getCustomerFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Customer> findDuplicatesByPhone() {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM customers WHERE phone IN ("
                + "  SELECT phone FROM customers WHERE phone IS NOT NULL AND phone <> '' "
                + "  GROUP BY phone HAVING COUNT(*) > 1"
                + ") ORDER BY phone, customer_id";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(getCustomerFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Customer getCustomerFromResultSet(ResultSet rs) throws SQLException {
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
