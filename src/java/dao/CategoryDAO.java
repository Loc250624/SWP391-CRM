package dao;

import dbConnection.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Category;

public class CategoryDAO extends DBContext {

    // ─── Map ResultSet → Category ───────────────────────────────
    private Category map(ResultSet rs) throws SQLException {
        Category c = new Category();
        c.setCategoryId(rs.getInt("category_id"));
        c.setCategoryCode(rs.getString("category_code"));
        c.setCategoryName(rs.getString("category_name"));
        c.setDescription(rs.getString("description"));
        c.setIsActive(rs.getBoolean("is_active"));
        if (rs.getTimestamp("created_at") != null) {
            c.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        }
        return c;
    }

    // ─── READ ALL ────────────────────────────────────────────────
    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM course_categories ORDER BY category_id DESC";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ─── READ ALL ACTIVE (for dropdowns) ────────────────────────
    public List<Category> getActiveCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM course_categories WHERE is_active = 1 ORDER BY category_name";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ─── READ ONE ────────────────────────────────────────────────
    public Category getById(int id) {
        String sql = "SELECT * FROM course_categories WHERE category_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ─── SEARCH ─────────────────────────────────────────────────
    public List<Category> search(String q, String activeFilter) {
        List<Category> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM course_categories WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (q != null && !q.trim().isEmpty()) {
            sql.append("AND (category_name LIKE ? OR category_code LIKE ? OR description LIKE ?) ");
            String like = "%" + q.trim() + "%";
            params.add(like); params.add(like); params.add(like);
        }
        if ("active".equals(activeFilter)) {
            sql.append("AND is_active = 1 ");
        } else if ("inactive".equals(activeFilter)) {
            sql.append("AND is_active = 0 ");
        }
        sql.append("ORDER BY category_id DESC");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) st.setObject(i + 1, params.get(i));
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ─── CREATE ──────────────────────────────────────────────────
    public int insert(Category c) {
        String sql = "INSERT INTO course_categories (category_code, category_name, description, is_active, created_at) "
                   + "VALUES (?, ?, ?, ?, GETDATE())";
        try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            st.setString(1, c.getCategoryCode());
            st.setString(2, c.getCategoryName());
            st.setString(3, c.getDescription());
            st.setBoolean(4, c.getIsActive() != null ? c.getIsActive() : true);
            st.executeUpdate();
            try (ResultSet gen = st.getGeneratedKeys()) {
                if (gen.next()) return gen.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    // ─── UPDATE ──────────────────────────────────────────────────
    public boolean update(Category c) {
        String sql = "UPDATE course_categories SET category_code=?, category_name=?, description=?, is_active=? "
                   + "WHERE category_id=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, c.getCategoryCode());
            st.setString(2, c.getCategoryName());
            st.setString(3, c.getDescription());
            st.setBoolean(4, c.getIsActive() != null ? c.getIsActive() : true);
            st.setInt(5, c.getCategoryId());
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ─── DELETE ──────────────────────────────────────────────────
    public boolean delete(int id) {
        String sql = "DELETE FROM course_categories WHERE category_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ─── SOFT DELETE (toggle is_active) ─────────────────────────
    public boolean toggleActive(int id) {
        String sql = "UPDATE course_categories SET is_active = CASE WHEN is_active=1 THEN 0 ELSE 1 END WHERE category_id=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ─── CHECK DUPLICATE NAME ───────────────────────────────────
    public boolean isNameDuplicate(String name, Integer excludeId) {
        String sql = "SELECT COUNT(*) FROM course_categories WHERE category_name = ? "
                   + (excludeId != null ? "AND category_id <> ?" : "");
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, name);
            if (excludeId != null) st.setInt(2, excludeId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ─── COUNT COURSES IN CATEGORY ───────────────────────────────
    public int countCourses(int categoryId) {
        String sql = "SELECT COUNT(*) FROM courses WHERE category_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, categoryId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
