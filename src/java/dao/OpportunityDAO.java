/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package dao;

import dbConnection.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Opportunity;

public class OpportunityDAO extends DBContext{

    public List<Opportunity> getAllOpportunities() {
        List<Opportunity> danhSach = new ArrayList<>();
        String sql = "SELECT * FROM opportunities";
        try (PreparedStatement st = getConnection().prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                danhSach.add(mapResultSetToOpportunity(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return danhSach;
    }

    public Opportunity getOpportunityById(int opportunityId) {
        String sql = "SELECT * FROM opportunities WHERE opportunity_id = ?";
        try (PreparedStatement st = getConnection().prepareStatement(sql)) {
            st.setInt(1, opportunityId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToOpportunity(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private Opportunity mapResultSetToOpportunity(ResultSet rs) throws Exception {
        Opportunity o = new Opportunity();
        o.setOpportunityId(rs.getInt("opportunity_id"));
        o.setOpportunityCode(rs.getString("opportunity_code"));
        o.setOpportunityName(rs.getString("opportunity_name"));
        o.setLeadId(rs.getObject("lead_id", Integer.class));
        o.setCustomerId(rs.getObject("customer_id", Integer.class));
        o.setPipelineId(rs.getInt("pipeline_id"));
        o.setStageId(rs.getInt("stage_id"));
        o.setEstimatedValue(rs.getBigDecimal("estimated_value"));
        o.setProbability(rs.getInt("probability"));
        if (rs.getDate("expected_close_date") != null) {
            o.setExpectedCloseDate(rs.getDate("expected_close_date").toLocalDate());
        }
        if (rs.getDate("actual_close_date") != null) {
            o.setActualCloseDate(rs.getDate("actual_close_date").toLocalDate());
        }
        o.setStatus(rs.getString("status"));
        o.setWonLostReason(rs.getString("won_lost_reason"));
        o.setSourceId(rs.getObject("source_id", Integer.class));
        o.setCampaignId(rs.getObject("campaign_id", Integer.class));
        o.setOwnerId(rs.getObject("owner_id", Integer.class));
        o.setNotes(rs.getString("notes"));
        if (rs.getTimestamp("created_at") != null) {
            o.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        }
        if (rs.getTimestamp("updated_at") != null) {
            o.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        }
        o.setCreatedBy(rs.getObject("created_by", Integer.class));
        return o;
    }
}
