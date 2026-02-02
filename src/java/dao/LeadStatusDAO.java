package dao;

import dbConnection.DBContext;
import model.LeadStatus;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class LeadStatusDAO {

    // Lấy tất cả trạng thái lead
    public List<LeadStatus> getAll() {
        List<LeadStatus> list = new ArrayList<>();

        String sql = "SELECT id, code, name FROM lead_status";

        try {
            DBContext db = new DBContext();
            Connection con = db.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                LeadStatus status = new LeadStatus();
                status.setId(rs.getInt("id"));
                status.setCode(rs.getString("code"));
                status.setName(rs.getString("name"));

                list.add(status);
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
