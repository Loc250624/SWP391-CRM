package dao;

import dbConnection.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

public class RoleDAO extends DBContext {

    public List<Map<String, Object>> getAllRoles() {
        List<Map<String, Object>> roles = new ArrayList<>();
        String sql = "SELECT role_id, role_code, role_name FROM roles";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> role = new HashMap<>();
                role.put("role_id", rs.getInt("role_id"));
                role.put("role_code", rs.getString("role_code"));
                role.put("role_name", rs.getString("role_name"));
                roles.add(role);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return roles;
    }
}
