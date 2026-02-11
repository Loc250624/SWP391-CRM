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
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
}
