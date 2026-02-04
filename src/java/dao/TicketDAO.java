package dao;

import dbConnection.DBContext;
import model.Ticket;
import model.TicketResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class TicketDAO {

    // 1. Tạo Ticket mới (Dành cho Khách hàng gửi yêu cầu)
    public boolean createTicket(Ticket ticket) {
        String sql = "INSERT INTO tickets (customer_id, title, description, status_id, created_at) VALUES (?, ?, ?, ?, GETDATE())";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ticket.getCustomerId());
            ps.setString(2, ticket.getTitle());
            ps.setString(3, ticket.getDescription());
            ps.setInt(4, 1); // 1 = OPEN
            return ps.executeUpdate() > 0;
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return false;
    }

    // 2. Lấy Ticket theo Loại (Dành cho Dashboard Nhân viên)
    public List<Ticket> getTicketsByStatus(int type) {
        List<Ticket> list = new ArrayList<>();
        String sql = "";

        // Type 1: Cần xử lý (Mới + Đang xử lý)
        if (type == 1) {
            sql = "SELECT * FROM tickets WHERE status_id IN (1, 2) ORDER BY created_at DESC";
        } 
        // Type 3: Lịch sử (Đã đóng)
        else {
            sql = "SELECT * FROM tickets WHERE status_id = 3 ORDER BY created_at DESC";
        }

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Ticket t = new Ticket();
                t.setId(rs.getInt("id"));
                t.setCustomerId(rs.getInt("customer_id"));
                t.setTitle(rs.getString("title"));
                t.setDescription(rs.getString("description"));
                t.setStatusId(rs.getInt("status_id"));
                t.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(t);
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    // 3. Lấy Ticket theo ID (Dùng chung)
    public Ticket getTicketById(int id) {
        String sql = "SELECT * FROM tickets WHERE id = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Ticket t = new Ticket();
                t.setId(rs.getInt("id"));
                t.setCustomerId(rs.getInt("customer_id"));
                t.setTitle(rs.getString("title"));
                t.setDescription(rs.getString("description"));
                t.setStatusId(rs.getInt("status_id"));
                t.setCreatedAt(rs.getTimestamp("created_at"));
                return t;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // 4. Lấy nội dung chat (Dùng chung)
    public List<TicketResponse> getResponsesByTicketId(int ticketId) {
        List<TicketResponse> list = new ArrayList<>();
        String sql = "SELECT * FROM ticket_responses WHERE ticket_id = ? ORDER BY created_at ASC";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ticketId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TicketResponse tr = new TicketResponse();
                tr.setId(rs.getInt("id"));
                tr.setTicketId(rs.getInt("ticket_id"));
                tr.setSenderId(rs.getInt("sender_id"));
                tr.setContent(rs.getString("content"));
                tr.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(tr);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 5. Gửi phản hồi & ĐÓNG PHIẾU (Dành cho Nhân viên)
    public void sendResponse(int ticketId, int senderId, String content) {
        String insertSql = "INSERT INTO ticket_responses (ticket_id, sender_id, content, created_at) VALUES (?, ?, ?, GETDATE())";
        String updateStatusSql = "UPDATE tickets SET status_id = 3 WHERE id = ?"; 

        Connection conn = null;
        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction

            // B1: Thêm tin nhắn
            PreparedStatement ps1 = conn.prepareStatement(insertSql);
            ps1.setInt(1, ticketId);
            ps1.setInt(2, senderId);
            ps1.setString(3, content);
            ps1.executeUpdate();

            // B2: Cập nhật trạng thái sang Đã đóng (3)
            PreparedStatement ps2 = conn.prepareStatement(updateStatusSql);
            ps2.setInt(1, ticketId);
            ps2.executeUpdate();
            
            // Xác nhận lưu
            conn.commit();

        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback(); // Hoàn tác nếu lỗi
            } catch (Exception ex) {}
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    // 6. Lấy danh sách Ticket theo ID Khách hàng (Dành cho trang Lịch sử Khách hàng)
    public List<Ticket> getTicketsByCustomerId(int customerId) {
        List<Ticket> list = new ArrayList<>();
        String sql = "SELECT * FROM tickets WHERE customer_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Ticket t = new Ticket();
                t.setId(rs.getInt("id"));
                t.setCustomerId(rs.getInt("customer_id"));
                t.setTitle(rs.getString("title"));
                t.setDescription(rs.getString("description"));
                t.setStatusId(rs.getInt("status_id"));
                t.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(t);
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return list;
    }
}