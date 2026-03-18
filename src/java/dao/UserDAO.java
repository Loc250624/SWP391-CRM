package dao;

import dbConnection.DBContext;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Users;

public class UserDAO extends DBContext {

    public Users login(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password_hash = ? AND status = 'Active'";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, email);
            st.setString(2, password);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public String getRoleCodeByUserId(int userId) {
        String sql = "SELECT r.role_code FROM roles r "
                + "JOIN user_roles ur ON r.role_id = ur.role_id "
                + "WHERE ur.user_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("role_code");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Users> getAllUsers() {
        List<Users> danhSach = new ArrayList<>();
        String sql = "SELECT * FROM users";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                danhSach.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return danhSach;
    }

    public List<Map<String, Object>> getAllUsersWithRoles() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT u.*, r.role_name, r.role_code FROM users u " +
                "LEFT JOIN user_roles ur ON u.user_id = ur.user_id " +
                "LEFT JOIN roles r ON ur.role_id = r.role_id";
        try (PreparedStatement st = connection.prepareStatement(sql);
                ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("userId", rs.getInt("user_id"));
                map.put("firstName", rs.getString("first_name"));
                map.put("lastName", rs.getString("last_name"));
                map.put("email", rs.getString("email"));
                map.put("employeeCode", rs.getString("employee_code"));
                map.put("status", rs.getString("status"));
                map.put("roleName", rs.getString("role_name"));
                map.put("roleCode", rs.getString("role_code"));
                map.put("avatarUrl", rs.getString("avatar_url"));
                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getUsersFiltered(String search, String roleCode, String status, int page, int pageSize) {
        List<Map<String, Object>> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        StringBuilder sql = new StringBuilder(
            "SELECT u.user_id, u.first_name, u.last_name, u.email, u.employee_code, " +
            "u.status, u.avatar_url, r.role_name, r.role_code " +
            "FROM users u " +
            "LEFT JOIN user_roles ur ON u.user_id = ur.user_id " +
            "LEFT JOIN roles r ON ur.role_id = r.role_id " +
            "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (u.first_name + ' ' + u.last_name LIKE ? OR u.email LIKE ? OR u.employee_code LIKE ?) ");
            String like = "%" + search.trim() + "%";
            params.add(like); params.add(like); params.add(like);
        }
        if (roleCode != null && !roleCode.trim().isEmpty()) {
            sql.append("AND r.role_code = ? ");
            params.add(roleCode.trim());
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND u.status = ? ");
            params.add(status.trim());
        }
        sql.append("ORDER BY u.user_id ASC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(pageSize);

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                st.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("userId", rs.getInt("user_id"));
                    map.put("firstName", rs.getString("first_name"));
                    map.put("lastName", rs.getString("last_name"));
                    map.put("email", rs.getString("email"));
                    map.put("employeeCode", rs.getString("employee_code"));
                    map.put("status", rs.getString("status"));
                    map.put("roleName", rs.getString("role_name"));
                    map.put("roleCode", rs.getString("role_code"));
                    map.put("avatarUrl", rs.getString("avatar_url"));
                    list.add(map);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countUsersFiltered(String search, String roleCode, String status) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM users u " +
            "LEFT JOIN user_roles ur ON u.user_id = ur.user_id " +
            "LEFT JOIN roles r ON ur.role_id = r.role_id " +
            "WHERE 1=1 "
        );
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (u.first_name + ' ' + u.last_name LIKE ? OR u.email LIKE ? OR u.employee_code LIKE ?) ");
            String like = "%" + search.trim() + "%";
            params.add(like); params.add(like); params.add(like);
        }
        if (roleCode != null && !roleCode.trim().isEmpty()) {
            sql.append("AND r.role_code = ? ");
            params.add(roleCode.trim());
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND u.status = ? ");
            params.add(status.trim());
        }

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                st.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Users getUserById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int insertUser(Users u) {
        String sql = "INSERT INTO users (employee_code, email, password_hash, first_name, last_name, phone, status, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        try (PreparedStatement st = connection.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            st.setString(1, u.getEmployeeCode());
            st.setString(2, u.getEmail());
            st.setString(3, u.getPasswordHash() != null ? u.getPasswordHash() : "123"); // Default password
            st.setString(4, u.getFirstName());
            st.setString(5, u.getLastName());
            st.setString(6, u.getPhone());
            st.setString(7, u.getStatus());

            int affectedRows = st.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = st.getGeneratedKeys()) {
                    if (rs.next())
                        return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public List<Users> getUsersByDepartment(int departmentId) {
        List<Users> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE department_id = ? AND status = 'Active' ORDER BY first_name, last_name";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, departmentId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateUser(Users u) {
        String sql = "UPDATE users SET first_name = ?, last_name = ?, email = ?, phone = ?, status = ?, updated_at = GETDATE() WHERE user_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, u.getFirstName());
            st.setString(2, u.getLastName());
            st.setString(3, u.getEmail());
            st.setString(4, u.getPhone());
            st.setString(5, u.getStatus());
            st.setInt(6, u.getUserId());
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean setUserStatus(int userId, String status) {
        String sql = "UPDATE users SET status = ?, updated_at = GETDATE() WHERE user_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, status);
            st.setInt(2, userId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteUser(int userId) {
        // Hard delete - only use if no foreign key constraints
        String sql = "DELETE FROM users WHERE user_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            // If constraint violation, fall back to deactivate
            return setUserStatus(userId, "Inactive");
        }
    }
    public List<Users> getUsersByRoleCode(String roleCode) {
        List<Users> list = new ArrayList<>();
        String sql = "SELECT u.* FROM users u "
                   + "INNER JOIN user_roles ur ON ur.user_id = u.user_id "
                   + "INNER JOIN roles r ON r.role_id = ur.role_id "
                   + "WHERE LOWER(r.role_code) = LOWER(?) AND u.status = 'Active' "
                   + "ORDER BY u.first_name, u.last_name";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, roleCode);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalUsersCount() {
        String sql = "SELECT COUNT(*) FROM users WHERE status = 'Active'";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public String getLastEmployeeCodeByPrefix(String prefix) {
        String sql = "SELECT TOP 1 employee_code FROM users WHERE employee_code LIKE ? ORDER BY employee_code DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, prefix + "%");
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("employee_code");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Users mapResultSetToUser(ResultSet rs) throws SQLException {
        Users u = new Users();
        u.setUserId(rs.getInt("user_id"));
        u.setEmployeeCode(rs.getString("employee_code"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setFirstName(rs.getString("first_name"));
        u.setLastName(rs.getString("last_name"));
        u.setPhone(rs.getString("phone"));
        u.setAvatarUrl(rs.getString("avatar_url"));
        u.setDepartmentId(rs.getObject("department_id") != null ? rs.getInt("department_id") : 0);
        u.setStatus(rs.getString("status"));

        Timestamp created = rs.getTimestamp("created_at");
        if (created != null) {
            u.setCreatedAt(created.toLocalDateTime());
        }
        Timestamp updated = rs.getTimestamp("updated_at");
        if (updated != null) {
            u.setUpdatedAt(updated.toLocalDateTime());
        }

        return u;
    }
}
