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
        return search(q, activeFilter, 1, Integer.MAX_VALUE).getItems();
    }

    public util.PagedResult<Category> search(String q, String activeFilter, int page, int pageSize) {
        List<Category> list = new ArrayList<>();
        int totalItems = 0;
        
        if (connection == null) {
            System.err.println("CategoryDAO.search: Connection is null!");
            return new util.PagedResult<>(list, 0, page, pageSize);
        }

        StringBuilder sql = new StringBuilder("SELECT * FROM course_categories WHERE 1=1 ");
        StringBuilder countSql = new StringBuilder("SELECT COUNT(*) FROM course_categories WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (q != null && !q.trim().isEmpty()) {
            String cond = "AND (category_name LIKE ? OR category_code LIKE ? OR description LIKE ?) ";
            sql.append(cond);
            countSql.append(cond);
            String like = "%" + q.trim() + "%";
            params.add(like); params.add(like); params.add(like);
        }
        
        if (activeFilter != null && !activeFilter.trim().isEmpty()) {
            if ("active".equals(activeFilter)) {
                sql.append("AND is_active = 1 ");
                countSql.append("AND is_active = 1 ");
            } else if ("inactive".equals(activeFilter)) {
                sql.append("AND is_active = 0 ");
                countSql.append("AND is_active = 0 ");
            }
        }
        
        // Count Query
        try (PreparedStatement st = connection.prepareStatement(countSql.toString())) {
            for (int i = 0; i < params.size(); i++) st.setObject(i + 1, params.get(i));
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) totalItems = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("CategoryDAO.search (count) Error: " + e.getMessage());
            e.printStackTrace();
        }

        // Items Query
        sql.append("ORDER BY category_id DESC ");
        if (pageSize != Integer.MAX_VALUE) {
            sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        }

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int pIdx = 1;
            for (Object p : params) st.setObject(pIdx++, p);
            if (pageSize != Integer.MAX_VALUE) {
                st.setInt(pIdx++, (page - 1) * pageSize);
                st.setInt(pIdx++, pageSize);
            }
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) {
            System.err.println("CategoryDAO.search (items) Error: " + e.getMessage());
            e.printStackTrace();
        }
        
        return new util.PagedResult<>(list, totalItems, page, pageSize);
    }

    // ─── CREATE ──────────────────────────────────────────────────
    public int insert(Category c) {
        if (connection == null) {
            System.err.println("CategoryDAO.insert: Connection is null!");
            return -1;
        }
        String sql = "INSERT INTO course_categories (category_code, category_name, description, is_active, created_at) "
                   + "VALUES (?, ?, ?, ?, GETDATE())";
        try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            st.setString(1, c.getCategoryCode() != null ? c.getCategoryCode().trim() : "");
            st.setString(2, c.getCategoryName() != null ? c.getCategoryName().trim() : "");
            st.setString(3, c.getDescription() != null ? c.getDescription().trim() : null);
            st.setBoolean(4, c.getIsActive() != null ? c.getIsActive() : true);
            
            int affectedRows = st.executeUpdate();
            if (affectedRows == 0) return -1;

            try (ResultSet gen = st.getGeneratedKeys()) {
                if (gen.next()) return gen.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("CategoryDAO.insert Error: " + e.getMessage());
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
            st.setString(1, name.trim());
            if (excludeId != null) st.setInt(2, excludeId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isCodeDuplicate(String code, Integer excludeId) {
        String sql = "SELECT COUNT(*) FROM course_categories WHERE category_code = ? "
                   + (excludeId != null ? "AND category_id <> ?" : "");
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, code.trim());
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
