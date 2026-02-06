package dao;

import dbConnection.DBContext;
import java.util.ArrayList;
import java.util.List;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.Lead;

public class LeadDAO extends DBContext {

    public List<Lead> getAllLeads() {
        List<Lead> leadList = new ArrayList<>();
        String sql = "SELECT * FROM leads";

        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
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

                leadList.add(lead);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return leadList;
    }

}
