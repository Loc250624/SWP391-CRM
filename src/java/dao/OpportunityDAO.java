/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package dao;

import dbConnection.DBContext;
import model.Opportunity;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class OpportunityDAO extends DBContext {

    /**
     * Get all opportunities (Admin view)
     */
    public List<Opportunity> getAllOpportunities() {
        List<Opportunity> opportunities = new ArrayList<>();
        String sql = "SELECT * FROM opportunities ORDER BY created_at DESC";

        try {
            PreparedStatement stmt = getConnection().prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Opportunity opp = extractOpportunityFromResultSet(rs);
                opportunities.add(opp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return opportunities;
    }

    /**
     * Get opportunities by sales user (Permission-aware: owner_id OR
     * created_by)
     */
    public List<Opportunity> getOpportunitiesBySalesUser(int userId) {
        List<Opportunity> opportunities = new ArrayList<>();
        String sql = "SELECT * FROM opportunities WHERE owner_id = ? OR created_by = ? ORDER BY created_at DESC";

        try {
            PreparedStatement stmt = getConnection().prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setInt(2, userId);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Opportunity opp = extractOpportunityFromResultSet(rs);
                opportunities.add(opp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return opportunities;
    }

    /**
     * Get opportunity by ID
     */
    public Opportunity getOpportunityById(int opportunityId) {
        String sql = "SELECT * FROM opportunities WHERE opportunity_id = ?";

        try {
            PreparedStatement stmt = getConnection().prepareStatement(sql);
            stmt.setInt(1, opportunityId);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractOpportunityFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Get opportunities by pipeline ID
     */
    public List<Opportunity> getOpportunitiesByPipeline(int pipelineId) {
        List<Opportunity> opportunities = new ArrayList<>();
        String sql = "SELECT * FROM opportunities WHERE pipeline_id = ? ORDER BY created_at DESC";

        try {
            PreparedStatement stmt = getConnection().prepareStatement(sql);
            stmt.setInt(1, pipelineId);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Opportunity opp = extractOpportunityFromResultSet(rs);
                opportunities.add(opp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return opportunities;
    }

    /**
     * Get opportunities by pipeline ID and sales user (Permission-aware)
     */
    public List<Opportunity> getOpportunitiesByPipelineAndUser(int pipelineId, int userId) {
        List<Opportunity> opportunities = new ArrayList<>();
        String sql = "SELECT * FROM opportunities "
                + "WHERE pipeline_id = ? AND (owner_id = ? OR created_by = ?) "
                + "ORDER BY created_at DESC";

        try {
            PreparedStatement stmt = getConnection().prepareStatement(sql);
            stmt.setInt(1, pipelineId);
            stmt.setInt(2, userId);
            stmt.setInt(3, userId);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Opportunity opp = extractOpportunityFromResultSet(rs);
                opportunities.add(opp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return opportunities;
    }

    /**
     * Get opportunities by stage ID
     */
    public List<Opportunity> getOpportunitiesByStage(int stageId) {
        List<Opportunity> opportunities = new ArrayList<>();
        String sql = "SELECT * FROM opportunities WHERE stage_id = ? ORDER BY created_at DESC";

        try {
            PreparedStatement stmt = getConnection().prepareStatement(sql);
            stmt.setInt(1, stageId);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Opportunity opp = extractOpportunityFromResultSet(rs);
                opportunities.add(opp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return opportunities;
    }

    /**
     * Get opportunities by stage and user (Permission-aware)
     */
    public List<Opportunity> getOpportunitiesByStageAndUser(int stageId, int userId) {
        List<Opportunity> opportunities = new ArrayList<>();
        String sql = "SELECT * FROM opportunities "
                + "WHERE stage_id = ? AND (owner_id = ? OR created_by = ?) "
                + "ORDER BY created_at DESC";

        try {
            PreparedStatement stmt = getConnection().prepareStatement(sql);
            stmt.setInt(1, stageId);
            stmt.setInt(2, userId);
            stmt.setInt(3, userId);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Opportunity opp = extractOpportunityFromResultSet(rs);
                opportunities.add(opp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return opportunities;
    }

    /**
     * Insert new opportunity
     */
    public boolean insertOpportunity(Opportunity opp) {
        String sql = "INSERT INTO opportunities "
                + "(opportunity_code, opportunity_name, lead_id, customer_id, pipeline_id, stage_id, "
                + "estimated_value, probability, expected_close_date, actual_close_date, status, "
                + "won_lost_reason, source_id, campaign_id, owner_id, notes, created_at, updated_at, created_by) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE(), ?)";

        try {
            // Generate opportunity code if not set
            if (opp.getOpportunityCode() == null || opp.getOpportunityCode().isEmpty()) {
                opp.setOpportunityCode(generateOpportunityCode());
            }

            PreparedStatement stmt = getConnection().prepareStatement(sql);
            stmt.setString(1, opp.getOpportunityCode());
            stmt.setString(2, opp.getOpportunityName());
            setNullableInt(stmt, 3, opp.getLeadId());
            setNullableInt(stmt, 4, opp.getCustomerId());
            stmt.setInt(5, opp.getPipelineId());
            stmt.setInt(6, opp.getStageId());
            stmt.setBigDecimal(7, opp.getEstimatedValue());
            stmt.setInt(8, opp.getProbability());
            setNullableDate(stmt, 9, opp.getExpectedCloseDate());
            setNullableDate(stmt, 10, opp.getActualCloseDate());
            stmt.setString(11, opp.getStatus());
            stmt.setString(12, opp.getWonLostReason());
            setNullableInt(stmt, 13, opp.getSourceId());
            setNullableInt(stmt, 14, opp.getCampaignId());
            setNullableInt(stmt, 15, opp.getOwnerId());
            stmt.setString(16, opp.getNotes());
            setNullableInt(stmt, 17, opp.getCreatedBy());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update existing opportunity
     */
    public boolean updateOpportunity(Opportunity opp) {
        String sql = "UPDATE opportunities SET "
                + "opportunity_name = ?, lead_id = ?, customer_id = ?, pipeline_id = ?, stage_id = ?, "
                + "estimated_value = ?, probability = ?, expected_close_date = ?, actual_close_date = ?, "
                + "status = ?, won_lost_reason = ?, source_id = ?, campaign_id = ?, owner_id = ?, "
                + "notes = ?, updated_at = GETDATE() "
                + "WHERE opportunity_id = ?";

        try {
            PreparedStatement stmt = getConnection().prepareStatement(sql);
            stmt.setString(1, opp.getOpportunityName());
            setNullableInt(stmt, 2, opp.getLeadId());
            setNullableInt(stmt, 3, opp.getCustomerId());
            stmt.setInt(4, opp.getPipelineId());
            stmt.setInt(5, opp.getStageId());
            stmt.setBigDecimal(6, opp.getEstimatedValue());
            stmt.setInt(7, opp.getProbability());
            setNullableDate(stmt, 8, opp.getExpectedCloseDate());
            setNullableDate(stmt, 9, opp.getActualCloseDate());
            stmt.setString(10, opp.getStatus());
            stmt.setString(11, opp.getWonLostReason());
            setNullableInt(stmt, 12, opp.getSourceId());
            setNullableInt(stmt, 13, opp.getCampaignId());
            setNullableInt(stmt, 14, opp.getOwnerId());
            stmt.setString(15, opp.getNotes());
            stmt.setInt(16, opp.getOpportunityId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete opportunity by ID (Soft delete - mark as inactive or hard delete)
     */
    public boolean deleteOpportunity(int opportunityId) {
        String sql = "DELETE FROM opportunities WHERE opportunity_id = ?";

        try {
            PreparedStatement stmt = getConnection().prepareStatement(sql);
            stmt.setInt(1, opportunityId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Generate unique opportunity code (OPP-000001, OPP-000002, etc.)
     */
    private String generateOpportunityCode() {
        String sql = "SELECT MAX(CAST(SUBSTRING(opportunity_code, 5, LEN(opportunity_code)) AS INT)) AS max_code "
                + "FROM opportunities WHERE opportunity_code LIKE 'OPP-%'";

        try {
            PreparedStatement stmt = getConnection().prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                int maxCode = rs.getInt("max_code");
                int newCode = maxCode + 1;
                return String.format("OPP-%06d", newCode);
            } else {
                return "OPP-000001";
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Return default code if error
            return "OPP-" + System.currentTimeMillis();
        }
    }

    /**
     * Get count of opportunities by status
     */
    public int getOpportunityCountByStatus(String status) {
        String sql = "SELECT COUNT(*) AS total FROM opportunities WHERE status = ?";

        try {
            PreparedStatement stmt = getConnection().prepareStatement(sql);
            stmt.setString(1, status);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    /**
     * Get total value of opportunities by status
     */
    public BigDecimal getTotalValueByStatus(String status) {
        String sql = "SELECT ISNULL(SUM(estimated_value), 0) AS total_value FROM opportunities WHERE status = ?";

        try {
            PreparedStatement stmt = getConnection().prepareStatement(sql);
            stmt.setString(1, status);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal("total_value");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return BigDecimal.ZERO;
    }

    // ===== HELPER METHODS =====
    /**
     * Extract Opportunity object from ResultSet
     */
    private Opportunity extractOpportunityFromResultSet(ResultSet rs) throws Exception {
        Opportunity opp = new Opportunity();

        opp.setOpportunityId(rs.getInt("opportunity_id"));
        opp.setOpportunityCode(rs.getString("opportunity_code"));
        opp.setOpportunityName(rs.getString("opportunity_name"));
        opp.setLeadId(getNullableInt(rs, "lead_id"));
        opp.setCustomerId(getNullableInt(rs, "customer_id"));
        opp.setPipelineId(rs.getInt("pipeline_id"));
        opp.setStageId(rs.getInt("stage_id"));
        opp.setEstimatedValue(rs.getBigDecimal("estimated_value"));
        opp.setProbability(rs.getInt("probability"));
        opp.setExpectedCloseDate(getNullableLocalDate(rs, "expected_close_date"));
        opp.setActualCloseDate(getNullableLocalDate(rs, "actual_close_date"));
        opp.setStatus(rs.getString("status"));
        opp.setWonLostReason(rs.getString("won_lost_reason"));
        opp.setSourceId(getNullableInt(rs, "source_id"));
        opp.setCampaignId(getNullableInt(rs, "campaign_id"));
        opp.setOwnerId(getNullableInt(rs, "owner_id"));
        opp.setNotes(rs.getString("notes"));
        opp.setCreatedAt(getNullableLocalDateTime(rs, "created_at"));
        opp.setUpdatedAt(getNullableLocalDateTime(rs, "updated_at"));
        opp.setCreatedBy(getNullableInt(rs, "created_by"));

        return opp;
    }

    /**
     * Set nullable integer parameter
     */
    private void setNullableInt(PreparedStatement stmt, int index, Integer value) throws Exception {
        if (value == null) {
            stmt.setNull(index, Types.INTEGER);
        } else {
            stmt.setInt(index, value);
        }
    }

    /**
     * Set nullable date parameter
     */
    private void setNullableDate(PreparedStatement stmt, int index, LocalDate value) throws Exception {
        if (value == null) {
            stmt.setNull(index, Types.DATE);
        } else {
            stmt.setDate(index, Date.valueOf(value));
        }
    }

    /**
     * Get nullable integer from ResultSet
     */
    private Integer getNullableInt(ResultSet rs, String columnName) throws Exception {
        int value = rs.getInt(columnName);
        return rs.wasNull() ? null : value;
    }

    /**
     * Get nullable LocalDate from ResultSet
     */
    private LocalDate getNullableLocalDate(ResultSet rs, String columnName) throws Exception {
        Date date = rs.getDate(columnName);
        return date != null ? date.toLocalDate() : null;
    }

    /**
     * Get nullable LocalDateTime from ResultSet
     */
    private LocalDateTime getNullableLocalDateTime(ResultSet rs, String columnName) throws Exception {
        Timestamp timestamp = rs.getTimestamp(columnName);
        return timestamp != null ? timestamp.toLocalDateTime() : null;
    }
}
