package dao;

import dbConnection.DBContext;
import model.Lead;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class LeadDAO {

    // 1) Lấy danh sách leads cho Sales Pipeline (JOIN để lấy tên status)
    public List<Lead> getLeadsForPipeline() {
        List<Lead> list = new ArrayList<>();

        String sql = """
            SELECT l.id, l.full_name, l.email, l.phone, l.financial_level, l.total_score,
                   l.lead_status_id, l.created_at,
                   ls.name AS lead_status_name
            FROM leads l
            LEFT JOIN lead_status ls ON l.lead_status_id = ls.id
            ORDER BY l.created_at DESC
        """;

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Lead lead = new Lead();
                lead.setId(rs.getInt("id"));
                lead.setFullName(rs.getString("full_name"));
                lead.setEmail(rs.getString("email"));
                lead.setPhone(rs.getString("phone"));
                lead.setFinancialLevel(rs.getString("financial_level"));
                lead.setTotalScore(rs.getInt("total_score"));
                lead.setLeadStatusId(rs.getInt("lead_status_id"));
                lead.setCreatedAt(rs.getDate("created_at"));
                lead.setLeadStatusName(rs.getString("lead_status_name"));
                list.add(lead);
            }

        } catch (Exception e) {
            System.out.println("Error in getLeadsForPipeline()");
            e.printStackTrace();
        }

        return list;
    }

    // 2) Lọc leads theo status (Sales hay dùng)
    public List<Lead> getLeadsByStatus(int leadStatusId) {
        List<Lead> list = new ArrayList<>();

        String sql = """
            SELECT l.id, l.full_name, l.email, l.phone, l.financial_level, l.total_score,
                   l.lead_status_id, l.created_at,
                   ls.name AS lead_status_name
            FROM leads l
            LEFT JOIN lead_status ls ON l.lead_status_id = ls.id
            WHERE l.lead_status_id = ?
            ORDER BY l.created_at DESC
        """;

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, leadStatusId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Lead lead = new Lead();
                    lead.setId(rs.getInt("id"));
                    lead.setFullName(rs.getString("full_name"));
                    lead.setEmail(rs.getString("email"));
                    lead.setPhone(rs.getString("phone"));
                    lead.setFinancialLevel(rs.getString("financial_level"));
                    lead.setTotalScore(rs.getInt("total_score"));
                    lead.setLeadStatusId(rs.getInt("lead_status_id"));
                    lead.setCreatedAt(rs.getDate("created_at"));
                    lead.setLeadStatusName(rs.getString("lead_status_name"));
                    list.add(lead);
                }
            }

        } catch (Exception e) {
            System.out.println("Error in getLeadsByStatus()");
            e.printStackTrace();
        }

        return list;
    }

   public boolean updateLeadStatus(int leadId, int newStatusId) {

    int current = getCurrentStatusId(leadId);
    if (current == -1) return false;

    // Business rule: không cho lùi status
    if (newStatusId < current) {
        return false;
    }

    String sql = "UPDATE leads SET lead_status_id = ? WHERE id = ?";
    try (var con = new DBContext().getConnection();
         var ps = con.prepareStatement(sql)) {

        ps.setInt(1, newStatusId);
        ps.setInt(2, leadId);
        return ps.executeUpdate() > 0;

    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}

     public int getCurrentStatusId(int leadId) {
    String sql = "SELECT lead_status_id FROM leads WHERE id = ?";
    try (var con = new DBContext().getConnection();
         var ps = con.prepareStatement(sql)) {

        ps.setInt(1, leadId);
        try (var rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt("lead_status_id");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return -1; // không tìm thấy
}
     public Lead getLeadById(int id) {
    String sql = """
        SELECT l.id, l.full_name, l.email, l.phone, l.age, l.financial_level, l.total_score,
               l.lead_status_id, l.created_at, ls.name AS lead_status_name
        FROM leads l
        LEFT JOIN lead_status ls ON l.lead_status_id = ls.id
        WHERE l.id = ?
    """;

    try (var con = new DBContext().getConnection();
         var ps = con.prepareStatement(sql)) {

        ps.setInt(1, id);
        try (var rs = ps.executeQuery()) {
            if (rs.next()) {
                Lead lead = new Lead();
                lead.setId(rs.getInt("id"));
                lead.setFullName(rs.getString("full_name"));
                lead.setEmail(rs.getString("email"));
                lead.setPhone(rs.getString("phone"));
                lead.setFinancialLevel(rs.getString("financial_level"));
                lead.setTotalScore(rs.getInt("total_score"));
                lead.setLeadStatusId(rs.getInt("lead_status_id"));
                lead.setLeadStatusName(rs.getString("lead_status_name"));
                lead.setCreatedAt(rs.getDate("created_at"));
                return lead;
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}
     public List<Lead> searchLeads(String keyword) {
    List<Lead> list = new java.util.ArrayList<>();

    String sql = """
        SELECT l.id, l.full_name, l.email, l.phone, l.financial_level, l.total_score,
               l.lead_status_id, l.created_at,
               ls.name AS lead_status_name
        FROM leads l
        LEFT JOIN lead_status ls ON l.lead_status_id = ls.id
        WHERE l.full_name LIKE ? OR l.email LIKE ? OR l.phone LIKE ?
        ORDER BY l.created_at DESC
    """;

    try (var con = new dbConnection.DBContext().getConnection();
         var ps = con.prepareStatement(sql)) {

        String k = "%" + keyword.trim() + "%";
        ps.setString(1, k);
        ps.setString(2, k);
        ps.setString(3, k);

        try (var rs = ps.executeQuery()) {
            while (rs.next()) {
                model.Lead lead = new model.Lead();
                lead.setId(rs.getInt("id"));
                lead.setFullName(rs.getString("full_name"));
                lead.setEmail(rs.getString("email"));
                lead.setPhone(rs.getString("phone"));
                lead.setFinancialLevel(rs.getString("financial_level"));
                lead.setTotalScore(rs.getInt("total_score"));
                lead.setLeadStatusId(rs.getInt("lead_status_id"));
                lead.setCreatedAt(rs.getDate("created_at"));
                lead.setLeadStatusName(rs.getString("lead_status_name"));
                list.add(lead);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}
public List<Lead> searchLeadsByStatus(int statusId, String keyword) {
    List<Lead> list = new java.util.ArrayList<>();

    String sql = """
        SELECT l.id, l.full_name, l.email, l.phone, l.financial_level, l.total_score,
               l.lead_status_id, l.created_at,
               ls.name AS lead_status_name
        FROM leads l
        LEFT JOIN lead_status ls ON l.lead_status_id = ls.id
        WHERE l.lead_status_id = ?
          AND (l.full_name LIKE ? OR l.email LIKE ? OR l.phone LIKE ?)
        ORDER BY l.created_at DESC
    """;

    try (var con = new dbConnection.DBContext().getConnection();
         var ps = con.prepareStatement(sql)) {

        String k = "%" + keyword.trim() + "%";
        ps.setInt(1, statusId);
        ps.setString(2, k);
        ps.setString(3, k);
        ps.setString(4, k);

        try (var rs = ps.executeQuery()) {
            while (rs.next()) {
                model.Lead lead = new model.Lead();
                lead.setId(rs.getInt("id"));
                lead.setFullName(rs.getString("full_name"));
                lead.setEmail(rs.getString("email"));
                lead.setPhone(rs.getString("phone"));
                lead.setFinancialLevel(rs.getString("financial_level"));
                lead.setTotalScore(rs.getInt("total_score"));
                lead.setLeadStatusId(rs.getInt("lead_status_id"));
                lead.setCreatedAt(rs.getDate("created_at"));
                lead.setLeadStatusName(rs.getString("lead_status_name"));
                list.add(lead);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}


}