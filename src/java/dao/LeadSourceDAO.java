package dao;

import dbConnection.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.LeadSource;

public class LeadSourceDAO extends DBContext {

    // Get all active lead sources
    public List<LeadSource> getAllActiveSources() {
        List<LeadSource> sourceList = new ArrayList<>();
        String sql = "SELECT * FROM lead_sources WHERE is_active = 1 ORDER BY source_name";

        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                LeadSource source = new LeadSource();
                source.setSourceId(rs.getInt("source_id"));
                source.setSourceCode(rs.getString("source_code"));
                source.setSourceName(rs.getString("source_name"));
                source.setDescription(rs.getString("description"));
                source.setIsActive(rs.getBoolean("is_active"));
                source.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());

                sourceList.add(source);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return sourceList;
    }

    // Get source by ID
    public LeadSource getSourceById(int sourceId) {
        String sql = "SELECT * FROM lead_sources WHERE source_id = ?";

        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setInt(1, sourceId);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                LeadSource source = new LeadSource();
                source.setSourceId(rs.getInt("source_id"));
                source.setSourceCode(rs.getString("source_code"));
                source.setSourceName(rs.getString("source_name"));
                source.setDescription(rs.getString("description"));
                source.setIsActive(rs.getBoolean("is_active"));
                source.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                return source;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
