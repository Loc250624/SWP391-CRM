package dao;

import dbConnection.DBContext;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import model.Lead;

public class LeadDAO extends DBContext {

    // Helper method to map ResultSet to Lead object
    private Lead mapResultSetToLead(ResultSet rs) throws SQLException {
        Lead lead = new Lead();

        lead.leadId = rs.getInt("lead_id");
        lead.leadCode = rs.getString("lead_code");
        lead.fullName = rs.getString("full_name");
        lead.email = rs.getString("email");
        lead.phone = rs.getString("phone");
        lead.sourceId = rs.getObject("source_id", Integer.class);
        lead.campaignId = rs.getObject("campaign_id", Integer.class);
        lead.jobTitle = rs.getString("job_title");
        lead.companyName = rs.getString("company_name");
        lead.interests = rs.getString("interests");
        lead.status = rs.getString("status");
        lead.rating = rs.getString("rating");
        lead.leadScore = rs.getInt("lead_score");
        lead.assignedTo = rs.getObject("assigned_to", Integer.class);
        lead.assignedAt = rs.getTimestamp("assigned_at") != null ? rs.getTimestamp("assigned_at").toLocalDateTime() : null;
        lead.isConverted = rs.getBoolean("is_converted");
        lead.convertedAt = rs.getTimestamp("converted_at") != null ? rs.getTimestamp("converted_at").toLocalDateTime() : null;
        lead.convertedCustomerId = rs.getObject("converted_customer_id", Integer.class);
        lead.notes = rs.getString("notes");
        lead.createdAt = rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null;
        lead.updatedAt = rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null;
        lead.createdBy = rs.getObject("created_by", Integer.class);

        return lead;
    }

    // Get all leads
    public List<Lead> getAllLeads() {
        List<Lead> leadList = new ArrayList<>();
        String sql = "SELECT * FROM leads ORDER BY created_at DESC";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                leadList.add(mapResultSetToLead(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return leadList;
    }

    // Get lead by ID
    public Lead getLeadById(int leadId) {
        String sql = "SELECT * FROM leads WHERE lead_id = ?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, leadId);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return mapResultSetToLead(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Generate unique lead code (LD-000001, LD-000002, ...)
    public String generateLeadCode() {
        String sql = "SELECT TOP 1 lead_code FROM leads ORDER BY lead_id DESC";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                String lastCode = rs.getString("lead_code");
                // Extract number from LD-000001
                int number = Integer.parseInt(lastCode.substring(3));
                return String.format("LD-%06d", number + 1);
            } else {
                // First lead
                return "LD-000001";
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Fallback
        return "LD-" + System.currentTimeMillis();
    }

    // Insert new lead
    public boolean insertLead(Lead lead) {
        String sql = "INSERT INTO leads (lead_code, full_name, email, phone, source_id, campaign_id, "
                + "job_title, company_name, interests, status, rating, lead_score, assigned_to, "
                + "assigned_at, is_converted, notes, created_at, updated_at, created_by) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            // Generate lead code if not set
            if (lead.leadCode == null || lead.leadCode.isEmpty()) {
                lead.leadCode = generateLeadCode();
            }

            PreparedStatement st = connection.prepareStatement(sql);

            st.setString(1, lead.leadCode);
            st.setString(2, lead.fullName);
            st.setString(3, lead.email);
            st.setString(4, lead.phone);

            // Handle nullable Integer fields
            if (lead.sourceId != null) {
                st.setInt(5, lead.sourceId);
            } else {
                st.setNull(5, java.sql.Types.INTEGER);
            }

            if (lead.campaignId != null) {
                st.setInt(6, lead.campaignId);
            } else {
                st.setNull(6, java.sql.Types.INTEGER);
            }

            st.setString(7, lead.jobTitle);
            st.setString(8, lead.companyName);
            st.setString(9, lead.interests);
            st.setString(10, lead.status != null ? lead.status : "NEW");
            st.setString(11, lead.rating);
            st.setInt(12, lead.leadScore);

            if (lead.assignedTo != null) {
                st.setInt(13, lead.assignedTo);
            } else {
                st.setNull(13, java.sql.Types.INTEGER);
            }

            if (lead.assignedAt != null) {
                st.setObject(14, lead.assignedAt);
            } else {
                st.setNull(14, java.sql.Types.TIMESTAMP);
            }

            st.setBoolean(15, lead.isConverted);
            st.setString(16, lead.notes);

            LocalDateTime now = LocalDateTime.now();
            st.setObject(17, now);
            st.setObject(18, now);

            if (lead.createdBy != null) {
                st.setInt(19, lead.createdBy);
            } else {
                st.setNull(19, java.sql.Types.INTEGER);
            }

            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update existing lead
    public boolean updateLead(Lead lead) {
        String sql = "UPDATE leads SET full_name = ?, email = ?, phone = ?, source_id = ?, "
                + "campaign_id = ?, job_title = ?, company_name = ?, interests = ?, "
                + "status = ?, rating = ?, lead_score = ?, assigned_to = ?, assigned_at = ?, "
                + "notes = ?, updated_at = ? WHERE lead_id = ?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);

            st.setString(1, lead.fullName);
            st.setString(2, lead.email);
            st.setString(3, lead.phone);

            if (lead.sourceId != null) {
                st.setInt(4, lead.sourceId);
            } else {
                st.setNull(4, java.sql.Types.INTEGER);
            }

            if (lead.campaignId != null) {
                st.setInt(5, lead.campaignId);
            } else {
                st.setNull(5, java.sql.Types.INTEGER);
            }

            st.setString(6, lead.jobTitle);
            st.setString(7, lead.companyName);
            st.setString(8, lead.interests);
            st.setString(9, lead.status);
            st.setString(10, lead.rating);
            st.setInt(11, lead.leadScore);

            if (lead.assignedTo != null) {
                st.setInt(12, lead.assignedTo);
            } else {
                st.setNull(12, java.sql.Types.INTEGER);
            }

            if (lead.assignedAt != null) {
                st.setObject(13, lead.assignedAt);
            } else {
                st.setNull(13, java.sql.Types.TIMESTAMP);
            }

            st.setString(14, lead.notes);
            st.setObject(15, LocalDateTime.now());
            st.setInt(16, lead.leadId);

            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Mark lead as converted to customer
    public boolean markLeadConverted(int leadId, int customerId) {
        String sql = "UPDATE leads SET is_converted = 1, converted_at = GETDATE(), "
                + "converted_customer_id = ?, status = 'Converted', updated_at = GETDATE() WHERE lead_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, customerId);
            st.setInt(2, leadId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Soft delete lead: set status = 'Delete' and cancel related opportunities
    public boolean deleteLead(int leadId) {
        String sqlLead = "UPDATE leads SET status = 'Inactive', updated_at = GETDATE() WHERE lead_id = ?";
        String sqlOpp = "UPDATE opportunities SET status = 'Cancelled', updated_at = GETDATE() WHERE lead_id = ?";

        try {
            PreparedStatement st = connection.prepareStatement(sqlLead);
            st.setInt(1, leadId);
            int rows = st.executeUpdate();

            // Cancel all opportunities linked to this lead
            PreparedStatement st2 = connection.prepareStatement(sqlOpp);
            st2.setInt(1, leadId);
            st2.executeUpdate();

            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get leads by status
    public List<Lead> getLeadsByStatus(String status) {
        List<Lead> leadList = new ArrayList<>();
        String sql = "SELECT * FROM leads WHERE status = ? ORDER BY created_at DESC";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, status);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                leadList.add(mapResultSetToLead(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return leadList;
    }

    // Get leads by assigned user
    public List<Lead> getLeadsByAssignedUser(int userId) {
        List<Lead> leadList = new ArrayList<>();
        String sql = "SELECT * FROM leads WHERE assigned_to = ? ORDER BY created_at DESC";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                leadList.add(mapResultSetToLead(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return leadList;
    }

    // Get leads assigned to user (excluding New, Delete, and converted leads)
    public List<Lead> getAssignedLeads(int userId) {
        List<Lead> leadList = new ArrayList<>();
        String sql = "SELECT * FROM leads WHERE assigned_to = ? AND status != 'New' AND converted_customer_id IS NULL ORDER BY created_at DESC";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                leadList.add(mapResultSetToLead(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return leadList;
    }

    // Get leads created by user (excluding New, Delete, and converted leads)
    public List<Lead> getCreatedLeads(int userId) {
        List<Lead> leadList = new ArrayList<>();
        String sql = "SELECT * FROM leads WHERE created_by = ? AND status != 'New' AND converted_customer_id IS NULL ORDER BY created_at DESC";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                leadList.add(mapResultSetToLead(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return leadList;
    }

    // Get leads eligible for opportunity creation (filtered by status, not converted)
    public List<Lead> getLeadsForOpportunity(int userId) {
        List<Lead> leadList = new ArrayList<>();
        String sql = "SELECT * FROM leads WHERE (created_by = ? OR assigned_to = ?) "
                + "AND status IN ('Assigned', 'Working', 'Unqualified', 'Nurturing') "
                + "AND is_converted = 0 ORDER BY created_at DESC";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            st.setInt(2, userId);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                leadList.add(mapResultSetToLead(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return leadList;
    }

    // Update lead status
    public boolean updateLeadStatus(int leadId, String status) {
        String sql = "UPDATE leads SET status = ?, updated_at = GETDATE() WHERE lead_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, status);
            st.setInt(2, leadId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get unassigned leads in manager's department (assigned_to IS NULL).
    // Scope: lead was created by someone in the manager's department.
    // Excludes leads created by SALE role users (sales tự tạo).
    public List<Lead> getLeadsByManagerScope(int departmentId,
            String keyword, String status, Integer sourceId, int offset, int pageSize) {
        List<Lead> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT * FROM leads l WHERE l.assigned_to IS NULL"
                + " AND l.created_by IN (SELECT user_id FROM users WHERE department_id = ?)"
                + " AND l.created_by NOT IN ("
                + "   SELECT ur.user_id FROM user_roles ur"
                + "   INNER JOIN roles r ON r.role_id = ur.role_id"
                + "   WHERE LOWER(r.role_code) = 'sales')");
        List<Object> params = new ArrayList<>();
        params.add(departmentId);

        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = "%" + keyword.trim() + "%";
            sql.append(" AND (l.full_name LIKE ? OR l.lead_code LIKE ? OR l.phone LIKE ? OR l.email LIKE ?)");
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND l.status = ?");
            params.add(status);
        }
        if (sourceId != null) {
            sql.append(" AND l.source_id = ?");
            params.add(sourceId);
        }
        sql.append(" ORDER BY l.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(pageSize);

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                st.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToLead(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Count unassigned leads in manager's department scope for pagination
    // Excludes leads created by SALE role users.
    public int countLeadsByManagerScope(int departmentId,
            String keyword, String status, Integer sourceId) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM leads l WHERE l.assigned_to IS NULL"
                + " AND l.created_by IN (SELECT user_id FROM users WHERE department_id = ?)"
                + " AND l.created_by NOT IN ("
                + "   SELECT ur.user_id FROM user_roles ur"
                + "   INNER JOIN roles r ON r.role_id = ur.role_id"
                + "   WHERE LOWER(r.role_code) = 'sales')");
        List<Object> params = new ArrayList<>();
        params.add(departmentId);

        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = "%" + keyword.trim() + "%";
            sql.append(" AND (l.full_name LIKE ? OR l.lead_code LIKE ? OR l.phone LIKE ? OR l.email LIKE ?)");
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND l.status = ?");
            params.add(status);
        }
        if (sourceId != null) {
            sql.append(" AND l.source_id = ?");
            params.add(sourceId);
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

    // Assign a Lead to a Sales user (set assigned_to and assigned_at)
    public boolean updateLeadAssignedTo(int leadId, int salesId) {
        String sql = "UPDATE leads SET assigned_to = ?, assigned_at = ?, updated_at = ? WHERE lead_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            LocalDateTime now = LocalDateTime.now();
            st.setInt(1, salesId);
            st.setObject(2, now);
            st.setObject(3, now);
            st.setInt(4, leadId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get leads that a sales user can see (created by them OR assigned to them)
    public List<Lead> getLeadsBySalesUser(int userId) {
        List<Lead> leadList = new ArrayList<>();
        String sql = "SELECT * FROM leads WHERE created_by = ? OR assigned_to = ? ORDER BY created_at DESC";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            st.setInt(2, userId);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                leadList.add(mapResultSetToLead(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return leadList;
    }

    public List<Lead> searchLeadsByPhone(String phoneQuery) {
        List<Lead> list = new ArrayList<>();
        // Chỉ lọc theo cột phone
        String sql = "SELECT * FROM leads WHERE phone LIKE ? AND is_converted = 0 ORDER BY created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + phoneQuery + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToLead(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Lead> searchLeadsByEmail(String emailQuery) {
        List<Lead> list = new ArrayList<>();
        String sql = "SELECT * FROM leads WHERE email LIKE ? AND is_converted = 0 ORDER BY created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + emailQuery + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToLead(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Batch fetch lead full_name by IDs — used for "related object" column in task list
    public Map<Integer, String> getLeadNameMap(List<Integer> leadIds) {
        Map<Integer, String> map = new HashMap<>();
        if (leadIds == null || leadIds.isEmpty()) {
            return map;
        }
        StringBuilder sql = new StringBuilder("SELECT lead_id, full_name FROM leads WHERE lead_id IN (");
        for (int i = 0; i < leadIds.size(); i++) {
            sql.append(i > 0 ? ",?" : "?");
        }
        sql.append(")");
        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < leadIds.size(); i++) {
                st.setInt(i + 1, leadIds.get(i));
            }
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getInt("lead_id"), rs.getString("full_name"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
    }
    // Lấy danh sách Lead CHỈ do người dùng hiện tại tạo ra

    public List<Lead> getLeadsByCreator(int userId) {
        List<Lead> list = new ArrayList<>();
        // SQL: Lọc chính xác theo ID người tạo và sắp xếp mới nhất lên đầu
        String sql = "SELECT * FROM leads WHERE created_by = ? ORDER BY created_at DESC";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    // Sử dụng hàm mapResultSetToLead tương tự như bên Customer
                    list.add(mapResultSetToLead(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ── Unassigned leads (Pool logic) with filters for Manager Lead page ──
    // Only status = 'New' (case-insensitive), excludes SALES-created leads, excludes leads with active tasks.
    public List<Lead> getUnassignedLeadsForManager(
            String keyword, Integer sourceId, String dateFrom, String dateTo, int offset, int pageSize) {
        List<Lead> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT * FROM leads l" +
            " WHERE l.assigned_to IS NULL" +
            " AND LOWER(l.status) = 'new'" +
            " AND l.created_by NOT IN (" +
            "   SELECT ur.user_id FROM user_roles ur" +
            "   INNER JOIN roles r ON r.role_id = ur.role_id" +
            "   WHERE LOWER(r.role_code) = 'sales')" +
            " AND NOT EXISTS (" +
            "   SELECT 1 FROM task_relations tr" +
            "   INNER JOIN tasks t ON t.task_id = tr.task_id" +
            "   WHERE tr.related_type = 'LEAD' AND tr.related_id = l.lead_id" +
            "   AND (t.is_deleted = 0 OR t.is_deleted IS NULL) AND t.status NOT IN (2,3))"
        );
        List<Object> params = new ArrayList<>();
        appendCommonFilters(sql, params, keyword, sourceId, dateFrom, dateTo);
        sql.append(" ORDER BY l.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset); params.add(pageSize);

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) st.setObject(i + 1, params.get(i));
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) list.add(mapResultSetToLead(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public int countUnassignedLeadsForManager(
            String keyword, Integer sourceId, String dateFrom, String dateTo) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM leads l" +
            " WHERE l.assigned_to IS NULL" +
            " AND LOWER(l.status) = 'new'" +
            " AND l.created_by NOT IN (" +
            "   SELECT ur.user_id FROM user_roles ur" +
            "   INNER JOIN roles r ON r.role_id = ur.role_id" +
            "   WHERE LOWER(r.role_code) = 'sales')" +
            " AND NOT EXISTS (" +
            "   SELECT 1 FROM task_relations tr" +
            "   INNER JOIN tasks t ON t.task_id = tr.task_id" +
            "   WHERE tr.related_type = 'LEAD' AND tr.related_id = l.lead_id" +
            "   AND (t.is_deleted = 0 OR t.is_deleted IS NULL) AND t.status NOT IN (2,3))"
        );
        List<Object> params = new ArrayList<>();
        appendCommonFilters(sql, params, keyword, sourceId, dateFrom, dateTo);
        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) st.setObject(i + 1, params.get(i));
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // Helper: append keyword, source, date filters
    private void appendCommonFilters(StringBuilder sql, List<Object> params,
            String keyword, Integer sourceId, String dateFrom, String dateTo) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (l.full_name LIKE ? OR l.phone LIKE ? OR l.lead_code LIKE ? OR l.email LIKE ?)");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw); params.add(kw); params.add(kw); params.add(kw);
        }
        if (sourceId != null) {
            sql.append(" AND l.source_id = ?");
            params.add(sourceId);
        }
        if (dateFrom != null) {
            sql.append(" AND CAST(l.created_at AS DATE) >= ?");
            params.add(dateFrom);
        }
        if (dateTo != null) {
            sql.append(" AND CAST(l.created_at AS DATE) <= ?");
            params.add(dateTo);
        }
    }

    // ── All unassigned leads for picker (status=new, not SALES-created, no active tasks) ──
    public List<Lead> getUnassignedLeadsForPicker() {
        List<Lead> list = new ArrayList<>();
        String sql =
            "SELECT * FROM leads l" +
            " WHERE l.assigned_to IS NULL" +
            " AND LOWER(l.status) = 'new'" +
            " AND l.created_by NOT IN (" +
            "   SELECT ur.user_id FROM user_roles ur" +
            "   INNER JOIN roles r ON r.role_id = ur.role_id" +
            "   WHERE LOWER(r.role_code) = 'sales')" +
            " AND NOT EXISTS (" +
            "   SELECT 1 FROM task_relations tr" +
            "   INNER JOIN tasks t ON t.task_id = tr.task_id" +
            "   WHERE tr.related_type = 'LEAD' AND tr.related_id = l.lead_id" +
            "   AND (t.is_deleted = 0 OR t.is_deleted IS NULL) AND t.status NOT IN (2,3))" +
            " ORDER BY l.created_at DESC";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) list.add(mapResultSetToLead(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // ── CRM Pool: unassigned leads with no active tasks ──
    public List<Lead> getPoolLeads(String keyword, int offset, int pageSize) {
        List<Lead> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT * FROM leads l" +
            " WHERE l.assigned_to IS NULL" +
            " AND l.created_by NOT IN (" +
            "   SELECT ur.user_id FROM user_roles ur" +
            "   INNER JOIN roles r ON r.role_id = ur.role_id" +
            "   WHERE LOWER(r.role_code) = 'sales')" +
            " AND NOT EXISTS (" +
            "   SELECT 1 FROM task_relations tr" +
            "   INNER JOIN tasks t ON t.task_id = tr.task_id" +
            "   WHERE tr.related_type = 'LEAD' AND tr.related_id = l.lead_id" +
            "   AND (t.is_deleted = 0 OR t.is_deleted IS NULL) AND t.status NOT IN (2,3))"
        );
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (l.full_name LIKE ? OR l.phone LIKE ? OR l.lead_code LIKE ?)");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw); params.add(kw); params.add(kw);
        }
        sql.append(" ORDER BY l.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset); params.add(pageSize);

        System.out.println("[LeadDAO.getPoolLeads] SQL: " + sql.toString());
        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) st.setObject(i + 1, params.get(i));
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) list.add(mapResultSetToLead(rs));
            }
        } catch (Exception e) {
            System.out.println("[LeadDAO.getPoolLeads] ERROR: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("[LeadDAO.getPoolLeads] Result size: " + list.size());
        return list;
    }

    public int countPoolLeads(String keyword) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM leads l" +
            " WHERE l.assigned_to IS NULL" +
            " AND l.created_by NOT IN (" +
            "   SELECT ur.user_id FROM user_roles ur" +
            "   INNER JOIN roles r ON r.role_id = ur.role_id" +
            "   WHERE LOWER(r.role_code) = 'sales')" +
            " AND NOT EXISTS (" +
            "   SELECT 1 FROM task_relations tr" +
            "   INNER JOIN tasks t ON t.task_id = tr.task_id" +
            "   WHERE tr.related_type = 'LEAD' AND tr.related_id = l.lead_id" +
            "   AND (t.is_deleted = 0 OR t.is_deleted IS NULL) AND t.status NOT IN (2,3))"
        );
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (l.full_name LIKE ? OR l.phone LIKE ? OR l.lead_code LIKE ?)");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw); params.add(kw); params.add(kw);
        }
        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) st.setObject(i + 1, params.get(i));
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // ── Leads assigned by a specific manager (via task_relations) ──
    // Returns leads that have tasks created by this manager linked via task_relations.
    public List<Lead> getAssignedLeadsByManager(int managerId,
            String keyword, String status, Integer sourceId,
            String dateFrom, String dateTo, int offset, int pageSize) {
        List<Lead> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT DISTINCT l.* FROM leads l"
            + " INNER JOIN task_relations tr ON tr.related_type = 'LEAD' AND tr.related_id = l.lead_id"
            + " INNER JOIN tasks t ON t.task_id = tr.task_id"
            + " WHERE t.created_by = ?"
            + " AND (t.is_deleted = 0 OR t.is_deleted IS NULL)");
        List<Object> params = new ArrayList<>();
        params.add(managerId);

        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = "%" + keyword.trim() + "%";
            sql.append(" AND (l.full_name LIKE ? OR l.lead_code LIKE ? OR l.phone LIKE ? OR l.email LIKE ?)");
            params.add(kw); params.add(kw); params.add(kw); params.add(kw);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND LOWER(l.status) = LOWER(?)");
            params.add(status);
        }
        if (sourceId != null) {
            sql.append(" AND l.source_id = ?");
            params.add(sourceId);
        }
        if (dateFrom != null) {
            sql.append(" AND CAST(l.created_at AS DATE) >= ?");
            params.add(dateFrom);
        }
        if (dateTo != null) {
            sql.append(" AND CAST(l.created_at AS DATE) <= ?");
            params.add(dateTo);
        }
        sql.append(" ORDER BY l.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset); params.add(pageSize);

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) st.setObject(i + 1, params.get(i));
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) list.add(mapResultSetToLead(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int countAssignedLeadsByManager(int managerId,
            String keyword, String status, Integer sourceId,
            String dateFrom, String dateTo) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(DISTINCT l.lead_id) FROM leads l"
            + " INNER JOIN task_relations tr ON tr.related_type = 'LEAD' AND tr.related_id = l.lead_id"
            + " INNER JOIN tasks t ON t.task_id = tr.task_id"
            + " WHERE t.created_by = ?"
            + " AND (t.is_deleted = 0 OR t.is_deleted IS NULL)");
        List<Object> params = new ArrayList<>();
        params.add(managerId);

        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = "%" + keyword.trim() + "%";
            sql.append(" AND (l.full_name LIKE ? OR l.lead_code LIKE ? OR l.phone LIKE ? OR l.email LIKE ?)");
            params.add(kw); params.add(kw); params.add(kw); params.add(kw);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND LOWER(l.status) = LOWER(?)");
            params.add(status);
        }
        if (sourceId != null) {
            sql.append(" AND l.source_id = ?");
            params.add(sourceId);
        }
        if (dateFrom != null) {
            sql.append(" AND CAST(l.created_at AS DATE) >= ?");
            params.add(dateFrom);
        }
        if (dateTo != null) {
            sql.append(" AND CAST(l.created_at AS DATE) <= ?");
            params.add(dateTo);
        }
        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) st.setObject(i + 1, params.get(i));
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    // ── All leads with filters + pagination (for Manager "Tất cả Lead" tab) ──
    public List<Lead> getAllLeadsFiltered(
            String keyword, String status, Integer sourceId,
            String dateFrom, String dateTo, int offset, int pageSize) {
        List<Lead> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM leads l WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = "%" + keyword.trim() + "%";
            sql.append(" AND (l.full_name LIKE ? OR l.lead_code LIKE ? OR l.phone LIKE ? OR l.email LIKE ?)");
            params.add(kw); params.add(kw); params.add(kw); params.add(kw);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND LOWER(l.status) = LOWER(?)");
            params.add(status);
        }
        if (sourceId != null) {
            sql.append(" AND l.source_id = ?");
            params.add(sourceId);
        }
        if (dateFrom != null) {
            sql.append(" AND CAST(l.created_at AS DATE) >= ?");
            params.add(dateFrom);
        }
        if (dateTo != null) {
            sql.append(" AND CAST(l.created_at AS DATE) <= ?");
            params.add(dateTo);
        }
        sql.append(" ORDER BY l.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset); params.add(pageSize);

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) st.setObject(i + 1, params.get(i));
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) list.add(mapResultSetToLead(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int countAllLeadsFiltered(
            String keyword, String status, Integer sourceId,
            String dateFrom, String dateTo) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM leads l WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = "%" + keyword.trim() + "%";
            sql.append(" AND (l.full_name LIKE ? OR l.lead_code LIKE ? OR l.phone LIKE ? OR l.email LIKE ?)");
            params.add(kw); params.add(kw); params.add(kw); params.add(kw);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND LOWER(l.status) = LOWER(?)");
            params.add(status);
        }
        if (sourceId != null) {
            sql.append(" AND l.source_id = ?");
            params.add(sourceId);
        }
        if (dateFrom != null) {
            sql.append(" AND CAST(l.created_at AS DATE) >= ?");
            params.add(dateFrom);
        }
        if (dateTo != null) {
            sql.append(" AND CAST(l.created_at AS DATE) <= ?");
            params.add(dateTo);
        }
        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) st.setObject(i + 1, params.get(i));
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<Lead> searchLeadsByPhoneAndCreator(String phone, int userId) {
        List<Lead> list = new ArrayList<>();
        // SQL: Tìm kiếm số điện thoại nhưng chỉ giới hạn trong các bản ghi do user này tạo
        String sql = "SELECT * FROM leads WHERE phone LIKE ? AND created_by = ? ORDER BY created_at DESC";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            // Gán tham số tìm kiếm (ví dụ: %090%)
            st.setString(1, "%" + phone + "%");
            st.setInt(2, userId);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    // Sử dụng hàm mapResultSetToLead đã có trong DAO của bạn
                    list.add(mapResultSetToLead(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
      public util.PagedResult<Lead> search(String phoneQuery, String status, int page, int pageSize) {
        List<Lead> list = new ArrayList<>();
        int totalItems = 0;

        StringBuilder sql = new StringBuilder("SELECT * FROM leads WHERE status != 'Inactive' ");
        StringBuilder countSql = new StringBuilder("SELECT COUNT(*) FROM leads WHERE status != 'Inactive' ");
        List<Object> params = new ArrayList<>();

        if (phoneQuery != null && !phoneQuery.trim().isEmpty()) {
            String cond = "AND phone LIKE ? ";
            sql.append(cond);
            countSql.append(cond);
            params.add("%" + phoneQuery.trim() + "%");
        }

        if (status != null && !status.trim().isEmpty()) {
            String cond = "AND status = ? ";
            sql.append(cond);
            countSql.append(cond);
            params.add(status.trim());
        }

        // Count Query
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

        // Items Query
        sql.append("ORDER BY created_at DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int pIdx = 1;
            for (Object p : params) {
                st.setObject(pIdx++, p);
            }
            st.setInt(pIdx++, (page - 1) * pageSize);
            st.setInt(pIdx++, pageSize);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToLead(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return new util.PagedResult<>(list, totalItems, page, pageSize);
    }
}
