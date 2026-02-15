package dao;

import dbConnection.DBContext;
import java.util.ArrayList;
import java.util.List;
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
        lead.createdAt = rs.getTimestamp("created_at").toLocalDateTime();
        lead.updatedAt = rs.getTimestamp("updated_at").toLocalDateTime();
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
        String sql = "INSERT INTO leads (lead_code, full_name, email, phone, source_id, campaign_id, " +
                     "job_title, company_name, interests, status, rating, lead_score, assigned_to, " +
                     "assigned_at, is_converted, notes, created_at, updated_at, created_by) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

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
        String sql = "UPDATE leads SET full_name = ?, email = ?, phone = ?, source_id = ?, " +
                     "campaign_id = ?, job_title = ?, company_name = ?, interests = ?, " +
                     "status = ?, rating = ?, lead_score = ?, assigned_to = ?, assigned_at = ?, " +
                     "notes = ?, updated_at = ? WHERE lead_id = ?";

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
        String sql = "UPDATE leads SET is_converted = 1, converted_at = GETDATE(), " +
                     "converted_customer_id = ?, status = 'Converted', updated_at = GETDATE() WHERE lead_id = ?";
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
        String sql = "SELECT * FROM leads WHERE assigned_to = ? AND status != 'New' AND status != 'Inactive' AND converted_customer_id IS NULL ORDER BY created_at DESC";

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
        String sql = "SELECT * FROM leads WHERE created_by = ? AND status != 'New' AND status != 'Inactive' AND converted_customer_id IS NULL ORDER BY created_at DESC";

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

}
