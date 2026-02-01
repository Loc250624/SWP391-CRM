package dao;

import dbConnection.DBContext; // <-- QUAN TRỌNG: Import từ đúng chỗ
import model.Ticket;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class TicketDAO {
    
    public boolean createTicket(Ticket ticket) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            // Gọi hàm kết nối
            conn = new DBContext().getConnection();
            
            String sql = "INSERT INTO tickets (customer_id, title, description, status_id, created_at) "
                       + "VALUES (?, ?, ?, ?, GETDATE())";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, ticket.getCustomerId());
            ps.setString(2, ticket.getTitle());
            ps.setString(3, ticket.getDescription());
            ps.setInt(4, ticket.getStatusId());
            
            int rows = ps.executeUpdate();
            return rows > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return false;
    }
}