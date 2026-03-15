package dao;

import dbConnection.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Campaign;

public class CampaignDAO extends DBContext {

    // Get all active campaigns
    public List<Campaign> getAllActiveCampaigns() {
        List<Campaign> campaignList = new ArrayList<>();
        String sql = "SELECT * FROM campaigns WHERE status IN ('Planning', 'Active') ORDER BY campaign_name";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Campaign campaign = new Campaign();
                campaign.setCampaignId(rs.getInt("campaign_id"));
                campaign.setCampaignCode(rs.getString("campaign_code"));
                campaign.setCampaignName(rs.getString("campaign_name"));
                campaign.setCampaignType(rs.getString("campaign_type"));
                campaign.setStatus(rs.getString("status"));
                campaign.setDescription(rs.getString("description"));

                // Nullable fields
                if (rs.getDate("start_date") != null) {
                    campaign.setStartDate(rs.getDate("start_date").toLocalDate());
                }
                if (rs.getDate("end_date") != null) {
                    campaign.setEndDate(rs.getDate("end_date").toLocalDate());
                }

                campaign.setBudget(rs.getBigDecimal("budget"));
                campaign.setActualCost(rs.getBigDecimal("actual_cost"));
                campaign.setTargetLeads(rs.getObject("target_leads", Integer.class));
                campaign.setOwnerId(rs.getObject("owner_id", Integer.class));
                campaign.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                campaign.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                campaign.setCreatedBy(rs.getObject("created_by", Integer.class));

                campaignList.add(campaign);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return campaignList;
    }

    // Get campaign by ID
    public Campaign getCampaignById(int campaignId) {
        String sql = "SELECT * FROM campaigns WHERE campaign_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, campaignId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapResultSetToCampaign(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Insert new campaign
    public boolean insertCampaign(Campaign campaign) {
        String sql = "INSERT INTO campaigns (campaign_code, campaign_name, campaign_type, status, "
                + "description, start_date, end_date, budget, actual_cost, target_leads, owner_id, "
                + "created_at, updated_at, created_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE(), ?)";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, campaign.getCampaignCode());
            st.setString(2, campaign.getCampaignName());
            st.setString(3, campaign.getCampaignType());
            st.setString(4, campaign.getStatus() != null ? campaign.getStatus() : "Planning");
            st.setString(5, campaign.getDescription());
            st.setObject(6, campaign.getStartDate());
            st.setObject(7, campaign.getEndDate());
            st.setBigDecimal(8, campaign.getBudget());
            st.setBigDecimal(9, campaign.getActualCost());
            st.setObject(10, campaign.getTargetLeads());
            st.setObject(11, campaign.getOwnerId());
            st.setObject(12, campaign.getCreatedBy());

            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update existing campaign
    public boolean updateCampaign(Campaign campaign) {
        String sql = "UPDATE campaigns SET campaign_code = ?, campaign_name = ?, campaign_type = ?, "
                + "status = ?, description = ?, start_date = ?, end_date = ?, budget = ?, "
                + "actual_cost = ?, target_leads = ?, owner_id = ?, updated_at = GETDATE() "
                + "WHERE campaign_id = ?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, campaign.getCampaignCode());
            st.setString(2, campaign.getCampaignName());
            st.setString(3, campaign.getCampaignType());
            st.setString(4, campaign.getStatus());
            st.setString(5, campaign.getDescription());
            st.setObject(6, campaign.getStartDate());
            st.setObject(7, campaign.getEndDate());
            st.setBigDecimal(8, campaign.getBudget());
            st.setBigDecimal(9, campaign.getActualCost());
            st.setObject(10, campaign.getTargetLeads());
            st.setObject(11, campaign.getOwnerId());
            st.setInt(12, campaign.getCampaignId());

            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete campaign
    public boolean deleteCampaign(int campaignId) {
        String sql = "DELETE FROM campaigns WHERE campaign_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, campaignId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all campaigns with pagination
    public List<Campaign> getCampaigns(int page, int pageSize, String search) {
        List<Campaign> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT * FROM campaigns WHERE campaign_name LIKE ? "
                + "ORDER BY created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, "%" + (search == null ? "" : search) + "%");
            st.setInt(2, offset);
            st.setInt(3, pageSize);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToCampaign(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalCampaigns(String search) {
        String sql = "SELECT COUNT(*) FROM campaigns WHERE campaign_name LIKE ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, "%" + (search == null ? "" : search) + "%");
            ResultSet rs = st.executeQuery();
            if (rs.next())
                return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Campaign mapResultSetToCampaign(ResultSet rs) throws SQLException {
        Campaign campaign = new Campaign();
        campaign.setCampaignId(rs.getInt("campaign_id"));
        campaign.setCampaignCode(rs.getString("campaign_code"));
        campaign.setCampaignName(rs.getString("campaign_name"));
        campaign.setCampaignType(rs.getString("campaign_type"));
        campaign.setStatus(rs.getString("status"));
        campaign.setDescription(rs.getString("description"));
        if (rs.getDate("start_date") != null) {
            campaign.setStartDate(rs.getDate("start_date").toLocalDate());
        }
        if (rs.getDate("end_date") != null) {
            campaign.setEndDate(rs.getDate("end_date").toLocalDate());
        }
        campaign.setBudget(rs.getBigDecimal("budget"));
        campaign.setActualCost(rs.getBigDecimal("actual_cost"));
        campaign.setTargetLeads(rs.getObject("target_leads", Integer.class));
        campaign.setOwnerId(rs.getObject("owner_id", Integer.class));
        campaign.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        campaign.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        campaign.setCreatedBy(rs.getObject("created_by", Integer.class));
        return campaign;
    }
}
