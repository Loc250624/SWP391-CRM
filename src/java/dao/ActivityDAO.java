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

    // ==================== SALES MODULE METHODS ====================

    public Activity getActivityById(int activityId) {
        String sql = "SELECT a.*, "
                + "(u.last_name + ' ' + u.first_name) AS performer_name, "
                + "COALESCE(c.full_name, l.full_name) AS contact_name "
                + "FROM activities a "
                + "LEFT JOIN users u ON a.performed_by = u.user_id "
                + "LEFT JOIN customers c ON a.related_type = 'Customer' AND a.related_id = c.customer_id "
                + "LEFT JOIN leads l ON a.related_type = 'Lead' AND a.related_id = l.lead_id "
                + "WHERE a.activity_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, activityId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Activity a = mapFullActivity(rs);
                a.setPerformerName(rs.getString("performer_name"));
                a.setCustomerName(rs.getString("contact_name"));
                return a;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Activity> getActivitiesByUser(int userId, String typeFilter, String keyword) {
        List<Activity> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT a.*, "
                + "(u.last_name + ' ' + u.first_name) AS performer_name, "
                + "COALESCE(c.full_name, l.full_name) AS contact_name "
                + "FROM activities a "
                + "LEFT JOIN users u ON a.performed_by = u.user_id "
                + "LEFT JOIN customers c ON a.related_type = 'Customer' AND a.related_id = c.customer_id "
                + "LEFT JOIN leads l ON a.related_type = 'Lead' AND a.related_id = l.lead_id "
                + "WHERE a.performed_by = ?");
        java.util.List<Object> params = new java.util.ArrayList<>();
        params.add(userId);

        if (typeFilter != null && !typeFilter.isEmpty()) {
            sql.append(" AND a.activity_type = ?");
            params.add(typeFilter);
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (a.subject LIKE ? OR a.description LIKE ?)");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
        }
        sql.append(" ORDER BY a.activity_date DESC, a.created_at DESC");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof Integer) ps.setInt(i + 1, (Integer) p);
                else ps.setString(i + 1, (String) p);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Activity a = mapFullActivity(rs);
                a.setPerformerName(rs.getString("performer_name"));
                a.setCustomerName(rs.getString("contact_name"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public java.util.Map<String, Integer> getActivityStats(int userId) {
        java.util.Map<String, Integer> stats = new java.util.HashMap<>();
        String sql = "SELECT "
                + "COUNT(*) AS total, "
                + "SUM(CASE WHEN activity_type = 'Call' THEN 1 ELSE 0 END) AS calls, "
                + "SUM(CASE WHEN activity_type = 'Email' THEN 1 ELSE 0 END) AS emails, "
                + "SUM(CASE WHEN activity_type = 'Meeting' THEN 1 ELSE 0 END) AS meetings "
                + "FROM activities WHERE performed_by = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                stats.put("total", rs.getInt("total"));
                stats.put("calls", rs.getInt("calls"));
                stats.put("emails", rs.getInt("emails"));
                stats.put("meetings", rs.getInt("meetings"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    public int insertSaleActivity(String activityType, String relatedType, Integer relatedId,
                                   String subject, String description, Timestamp activityDate,
                                   Integer durationMinutes, String callDirection, String callResult,
                                   int performedBy, String status) {
        String sql = "INSERT INTO activities (activity_type, related_type, related_id, subject, [description], "
                + "activity_date, duration_minutes, call_direction, call_result, performed_by, created_by, "
                + "status, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, activityType);
            ps.setString(2, relatedType);
            if (relatedId != null) ps.setInt(3, relatedId);
            else ps.setNull(3, java.sql.Types.INTEGER);
            ps.setString(4, subject);
            ps.setString(5, description);
            if (activityDate != null) ps.setTimestamp(6, activityDate);
            else ps.setNull(6, java.sql.Types.TIMESTAMP);
            if (durationMinutes != null) ps.setInt(7, durationMinutes);
            else ps.setNull(7, java.sql.Types.INTEGER);
            ps.setString(8, callDirection);
            ps.setString(9, callResult);
            ps.setInt(10, performedBy);
            ps.setInt(11, performedBy);
            ps.setString(12, status != null ? status : "Completed");
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean updateActivity(int activityId, String activityType, String relatedType, Integer relatedId,
                                   String subject, String description, Timestamp activityDate,
                                   Integer durationMinutes, String callDirection, String callResult, String status) {
        String sql = "UPDATE activities SET activity_type=?, related_type=?, related_id=?, subject=?, "
                + "[description]=?, activity_date=?, duration_minutes=?, call_direction=?, call_result=?, status=? "
                + "WHERE activity_id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, activityType);
            ps.setString(2, relatedType);
            if (relatedId != null) ps.setInt(3, relatedId);
            else ps.setNull(3, java.sql.Types.INTEGER);
            ps.setString(4, subject);
            ps.setString(5, description);
            if (activityDate != null) ps.setTimestamp(6, activityDate);
            else ps.setNull(6, java.sql.Types.TIMESTAMP);
            if (durationMinutes != null) ps.setInt(7, durationMinutes);
            else ps.setNull(7, java.sql.Types.INTEGER);
            ps.setString(8, callDirection);
            ps.setString(9, callResult);
            ps.setString(10, status);
            ps.setInt(11, activityId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Activity> getActivitiesByUserAndDateRange(int userId, java.sql.Date startDate, java.sql.Date endDate) {
        List<Activity> list = new ArrayList<>();
        String sql = "SELECT a.*, "
                + "(u.last_name + ' ' + u.first_name) AS performer_name, "
                + "COALESCE(c.full_name, l.full_name) AS contact_name "
                + "FROM activities a "
                + "LEFT JOIN users u ON a.performed_by = u.user_id "
                + "LEFT JOIN customers c ON a.related_type = 'Customer' AND a.related_id = c.customer_id "
                + "LEFT JOIN leads l ON a.related_type = 'Lead' AND a.related_id = l.lead_id "
                + "WHERE a.performed_by = ? AND CAST(a.activity_date AS DATE) BETWEEN ? AND ? "
                + "ORDER BY a.activity_date ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setDate(2, startDate);
            ps.setDate(3, endDate);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Activity a = mapFullActivity(rs);
                a.setPerformerName(rs.getString("performer_name"));
                a.setCustomerName(rs.getString("contact_name"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Activity mapFullActivity(ResultSet rs) throws SQLException {
        Activity a = new Activity();
        a.setActivityId(rs.getInt("activity_id"));
        a.setActivityType(rs.getString("activity_type"));
        a.setRelatedType(rs.getString("related_type"));
        a.setRelatedId(rs.getInt("related_id"));
        a.setSubject(rs.getString("subject"));
        a.setDescription(rs.getString("description"));
        Timestamp actDate = rs.getTimestamp("activity_date");
        if (actDate != null) a.setActivityDate(actDate.toLocalDateTime());
        a.setDurationMinutes(rs.getObject("duration_minutes") != null ? rs.getInt("duration_minutes") : null);
        a.setCallDirection(rs.getString("call_direction"));
        a.setCallResult(rs.getString("call_result"));
        a.setPerformedBy(rs.getObject("performed_by") != null ? rs.getInt("performed_by") : null);
        Timestamp created = rs.getTimestamp("created_at");
        if (created != null) a.setCreatedAt(created.toLocalDateTime());
        a.setCreatedBy(rs.getObject("created_by") != null ? rs.getInt("created_by") : null);
        a.setStatus(rs.getString("status"));
        return a;
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
