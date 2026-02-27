package dao;

import dbConnection.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Activity;

public class ActivityDAO extends DBContext {

    /**
     * CẬP NHẬT: Thêm cột 'status' vào câu lệnh INSERT. status sẽ nhận giá trị
     * 'Pending' (Hàng chờ) hoặc 'Completed' (Hoàn thành).
     */
    public boolean insertActivity(int customerId, String subject, String description, int performedBy, String status) {
        String sql = "INSERT INTO activities (activity_type, related_type, related_id, subject, [description], "
                + "status, activity_date, performed_by, created_at) "
                + "VALUES ('REPORT', 'Customer', ?, ?, ?, ?, GETDATE(), ?, GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setString(2, subject);
            ps.setString(3, description);
            ps.setString(4, status); // Lưu trạng thái từ Modal gửi về
            ps.setInt(5, performedBy);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * CẬP NHẬT: Lấy danh sách lịch sử của 1 khách hàng. Chỉ lấy các báo cáo đã
     * hoàn thành ('Completed') để hiển thị trong Lịch sử.
     */
    // 1. CHỈ LẤY CÁC BÁO CÁO ĐÃ XONG CHO TRANG LỊCH SỬ
    public List<Activity> getActivitiesByCustomerId(int customerId) {
        List<Activity> list = new ArrayList<>();
        // Đảm bảo có điều kiện: AND a.status = 'Completed'
        String sql = "SELECT a.*, (u.last_name + ' ' + u.first_name) AS full_performer_name "
                + "FROM activities a "
                + "LEFT JOIN users u ON a.performed_by = u.user_id "
                + "WHERE a.related_id = ? AND a.related_type = 'Customer' "
                + "AND a.status = 'Completed' "
                + "ORDER BY a.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Activity a = mapResultSetToActivity(rs);
                a.setPerformerName(rs.getString("full_performer_name"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

// 2. HÀM CẬP NHẬT NỘI DUNG VÀ HOÀN THÀNH
    public boolean updateAndCompleteActivity(int activityId, String subject, String description) {
        // Cho phép cập nhật lại cả tiêu đề và nội dung trước khi đóng phiếu
        String sql = "UPDATE activities SET subject = ?, [description] = ?, status = 'Completed', created_at = GETDATE() "
                + "WHERE activity_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, subject);
            ps.setString(2, description);
            ps.setInt(3, activityId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * THÊM MỚI: Lấy danh sách các báo cáo đang ở trạng thái 'Pending'. Sử dụng
     * cho trang "Hàng chờ".
     */
    public List<Activity> getPendingActivities() {
        List<Activity> list = new ArrayList<>();
        String sql = "SELECT a.*, c.full_name, c.phone "
                + "FROM activities a "
                + "INNER JOIN customers c ON a.related_id = c.customer_id "
                + "WHERE a.status = 'Pending' AND a.related_type = 'Customer' "
                + "ORDER BY a.created_at ASC"; // Ưu tiên việc cũ hiện lên trước
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Activity a = mapResultSetToActivity(rs);
                a.setCustomerName(rs.getString("full_name"));
                a.setCustomerPhone(rs.getString("phone"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * THÊM MỚI: Cập nhật một phiếu từ Hàng chờ sang Hoàn thành. Logic: Khi nhân
     * viên xử lý xong, đổi status sang 'Completed' và cập nhật nội dung.
     */
    public boolean completeActivity(int activityId, String finalDescription) {
        String sql = "UPDATE activities SET status = 'Completed', [description] = ?, created_at = GETDATE() "
                + "WHERE activity_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, finalDescription);
            ps.setInt(2, activityId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // --- HÀM HỖ TRỢ ĐỂ TRÁNH VIẾT LẶP CODE (CLEAN CODE) ---
    private Activity mapResultSetToActivity(ResultSet rs) throws SQLException {
        Activity a = new Activity();
        a.setActivityId(rs.getInt("activity_id"));
        a.setSubject(rs.getString("subject"));
        a.setDescription(rs.getString("description"));
        a.setStatus(rs.getString("status")); // Đã thêm vào Model

        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) {
            a.setCreatedAt(ts.toLocalDateTime());
        }
        return a;
    }

    // Giữ nguyên hàm báo cáo theo tháng (Có bổ sung Mapping sạch hơn)
    public List<Activity> getActivitiesByMonth(int staffId, int month, int year) {
        List<Activity> list = new ArrayList<>();
        // THÊM: AND a.status = 'Completed' để không hiện phiếu đang chờ
        String sql = "SELECT a.*, c.full_name, c.phone "
                + "FROM activities a "
                + "INNER JOIN customers c ON a.related_id = c.customer_id "
                + "WHERE a.performed_by = ? AND a.related_type = 'Customer' "
                + "AND a.status = 'Completed' "
                + "AND MONTH(a.created_at) = ? AND YEAR(a.created_at) = ? "
                + "ORDER BY a.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, staffId);
            ps.setInt(2, month);
            ps.setInt(3, year);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Activity a = mapResultSetToActivity(rs);
                a.setCustomerName(rs.getString("full_name"));
                a.setCustomerPhone(rs.getString("phone"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
