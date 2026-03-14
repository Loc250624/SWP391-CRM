package dao;

import dbConnection.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.CustomerTag;

public class CustomerTagDAO extends DBContext {

    public List<CustomerTag> getAllActiveTags() {
        List<CustomerTag> list = new ArrayList<>();
        String sql = "SELECT * FROM customer_tags WHERE is_active = 1 ORDER BY tag_name";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Integer> getTagIdsByCustomerId(int customerId) {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT tag_id FROM customer_tag_assignments WHERE customer_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, customerId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getInt("tag_id"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<CustomerTag> getTagsByCustomerId(int customerId) {
        List<CustomerTag> list = new ArrayList<>();
        String sql = "SELECT t.* FROM customer_tags t "
                + "INNER JOIN customer_tag_assignments a ON t.tag_id = a.tag_id "
                + "WHERE a.customer_id = ? AND t.is_active = 1 ORDER BY t.tag_name";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, customerId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void assignTags(int customerId, List<Integer> tagIds, Integer assignedBy) {
        // Delete existing assignments
        String deleteSql = "DELETE FROM customer_tag_assignments WHERE customer_id = ?";
        try (PreparedStatement st = connection.prepareStatement(deleteSql)) {
            st.setInt(1, customerId);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Insert new assignments
        if (tagIds != null && !tagIds.isEmpty()) {
            String insertSql = "INSERT INTO customer_tag_assignments (customer_id, tag_id, assigned_at, assigned_by) VALUES (?, ?, GETDATE(), ?)";
            for (int tagId : tagIds) {
                try (PreparedStatement st = connection.prepareStatement(insertSql)) {
                    st.setInt(1, customerId);
                    st.setInt(2, tagId);
                    if (assignedBy != null) {
                        st.setInt(3, assignedBy);
                    } else {
                        st.setNull(3, java.sql.Types.INTEGER);
                    }
                    st.executeUpdate();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private CustomerTag mapResultSet(ResultSet rs) throws SQLException {
        CustomerTag t = new CustomerTag();
        t.setTagId(rs.getInt("tag_id"));
        t.setTagName(rs.getString("tag_name"));
        t.setTagColor(rs.getString("tag_color"));
        t.setDescription(rs.getString("description"));
        t.setIsActive(rs.getBoolean("is_active"));
        if (rs.getTimestamp("created_at") != null) {
            t.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        }
        return t;
    }
}
