/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dbConnection.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CampaignMarketingDAO {

    private static final String GET_ALL_CAMPAIGN_NAMES =
            "SELECT campaign_name FROM campaigns ORDER BY campaign_name";

    public List<String> getAllCampaignNames() {
        List<String> campaignNames = new ArrayList<>();

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(GET_ALL_CAMPAIGN_NAMES);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                campaignNames.add(rs.getString("campaign_name"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return campaignNames;
    }
}

