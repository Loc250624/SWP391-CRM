package dao;

import dbConnection.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Activity;

public class ActivityDAO extends DBContext {

    /**
     * CẬP NHẬT: Thêm cột 'status' vào câu lệnh INSERT. status sẽ nhận giá trị
     * 'Pending' (Hàng chờ) hoặc 'Completed' (Hoàn thành).
     */
    public boolean insertActivity(int relatedId, String relatedType, String subject, String description, int performedBy, String status) {
        // Câu lệnh SQL: Dùng dấu ? cho related_type thay vì fix cứng 'Customer'
        String sql = "INSERT INTO activities (activity_type, related_type, related_id, subject, [description], "
                + "status, activity_date, performed_by, created_at) "
                + "VALUES ('REPORT', ?, ?, ?, ?, ?, GETDATE(), ?, GETDATE())";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, relatedType); // Tham số mới thêm vào
            ps.setInt(2, relatedId);
            ps.setString(3, subject);
            ps.setString(4, description);
            ps.setString(5, status);
            ps.setInt(6, performedBy);

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
    public List<Activity> getReportsHistory(int id, String type) {
        List<Activity> list = new ArrayList<>();
        String sql = "SELECT a.*, (u.last_name + ' ' + u.first_name) AS full_performer_name "
                + "FROM activities a LEFT JOIN users u ON a.performed_by = u.user_id "
                + "WHERE a.related_id = ? AND a.related_type = ? " // Lọc theo ID và Loại (Lead/Customer)
                + "AND a.status = 'Completed' ORDER BY a.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setString(2, type);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Activity a = mapResultSetToActivity(rs); // Dùng hàm map có sẵn của bạn
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
   public List<Activity> getPendingActivities(int userId) {
        List<Activity> list = new ArrayList<>();
        String sql = "SELECT a.*, c.full_name, c.phone "
                + "FROM activities a "
                + "INNER JOIN customers c ON a.related_id = c.customer_id "
                + "WHERE a.status = 'Pending' AND a.related_type = 'Customer' "
                + "AND a.performed_by = ? " 
                // Thêm dòng này để chặn phiếu chuyển tiếp
                + "AND (a.[description] NOT LIKE N'Phiếu yêu cầu hỗ trợ được chuyển tiếp%' OR a.[description] IS NULL) "
                + "ORDER BY a.created_at ASC";
                
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId); 
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Activity a = mapResultSetToActivity(rs);
                a.setCustomerName(rs.getString("full_name"));
                a.setCustomerPhone(rs.getString("phone"));
                a.setRelatedType("Customer");
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
                if (p instanceof Integer) {
                    ps.setInt(i + 1, (Integer) p);
                } else {
                    ps.setString(i + 1, (String) p);
                }
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
            if (relatedId != null) {
                ps.setInt(3, relatedId);
            } else {
                ps.setNull(3, java.sql.Types.INTEGER);
            }
            ps.setString(4, subject);
            ps.setString(5, description);
            if (activityDate != null) {
                ps.setTimestamp(6, activityDate);
            } else {
                ps.setNull(6, java.sql.Types.TIMESTAMP);
            }
            if (durationMinutes != null) {
                ps.setInt(7, durationMinutes);
            } else {
                ps.setNull(7, java.sql.Types.INTEGER);
            }
            ps.setString(8, callDirection);
            ps.setString(9, callResult);
            ps.setInt(10, performedBy);
            ps.setInt(11, performedBy);
            ps.setString(12, status != null ? status : "Completed");
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    return keys.getInt(1);
                }
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
            if (relatedId != null) {
                ps.setInt(3, relatedId);
            } else {
                ps.setNull(3, java.sql.Types.INTEGER);
            }
            ps.setString(4, subject);
            ps.setString(5, description);
            if (activityDate != null) {
                ps.setTimestamp(6, activityDate);
            } else {
                ps.setNull(6, java.sql.Types.TIMESTAMP);
            }
            if (durationMinutes != null) {
                ps.setInt(7, durationMinutes);
            } else {
                ps.setNull(7, java.sql.Types.INTEGER);
            }
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
        if (actDate != null) {
            a.setActivityDate(actDate.toLocalDateTime());
        }
        a.setDurationMinutes(rs.getObject("duration_minutes") != null ? rs.getInt("duration_minutes") : null);
        a.setCallDirection(rs.getString("call_direction"));
        a.setCallResult(rs.getString("call_result"));
        a.setPerformedBy(rs.getObject("performed_by") != null ? rs.getInt("performed_by") : null);
        Timestamp created = rs.getTimestamp("created_at");
        if (created != null) {
            a.setCreatedAt(created.toLocalDateTime());
        }
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

    // CẬP NHẬT: Lấy nhật ký hoạt động cho cả Lead và Customer
    public List<Activity> getActivitiesByMonth(int staffId, int month, int year) {
        List<Activity> list = new ArrayList<>();
        // Dùng LEFT JOIN kết hợp COALESCE để lấy dữ liệu từ cả 2 bảng
        String sql = "SELECT a.*, "
                + "COALESCE(c.full_name, l.full_name) AS contact_name, "
                + "COALESCE(c.phone, l.phone) AS contact_phone "
                + "FROM activities a "
                + "LEFT JOIN customers c ON a.related_type = 'Customer' AND a.related_id = c.customer_id "
                + "LEFT JOIN leads l ON a.related_type = 'Lead' AND a.related_id = l.lead_id "
                + "WHERE a.performed_by = ? "
                + "AND a.status = 'Completed' "
                + "AND MONTH(a.created_at) = ? AND YEAR(a.created_at) = ? "
                + "ORDER BY a.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, staffId);
            ps.setInt(2, month);
            ps.setInt(3, year);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                // Tận dụng hàm map cơ bản của bạn
                Activity a = mapResultSetToActivity(rs);

                // Gán tên và SĐT lấy được (không phân biệt là Lead hay Customer)
                a.setCustomerName(rs.getString("contact_name"));
                a.setCustomerPhone(rs.getString("contact_phone"));
                a.setRelatedType(rs.getString("related_type")); // Lưu lại type để phân biệt trên giao diện

                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Activity> searchGlobal(String code, String name, String phone) {
        List<Activity> list = new ArrayList<>();
        // SQL: Tìm kiếm tổng hợp từ cả 2 bảng bằng UNION ALL
        String sql = "SELECT 'Customer' as source, c.customer_id as id, c.customer_code as code, "
                + "c.full_name, c.phone, c.status, c.created_by, (u.last_name + ' ' + u.first_name) as creator_name "
                + "FROM customers c LEFT JOIN users u ON c.created_by = u.user_id "
                + "WHERE (? = '' OR c.customer_code LIKE ?) "
                + "  AND (? = '' OR c.full_name LIKE ?) "
                + "  AND (? = '' OR c.phone LIKE ?) "
                + "UNION ALL "
                + "SELECT 'Lead' as source, l.lead_id as id, l.lead_code as code, "
                + "l.full_name, l.phone, l.status, l.created_by, (u.last_name + ' ' + u.first_name) as creator_name "
                + "FROM leads l LEFT JOIN users u ON l.created_by = u.user_id "
                + "WHERE (? = '' OR l.lead_code LIKE ?) "
                + "  AND (? = '' OR l.full_name LIKE ?) "
                + "  AND (? = '' OR l.phone LIKE ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String c = (code == null) ? "" : code.trim();
            String n = (name == null) ? "" : name.trim();
            String p = (phone == null) ? "" : phone.trim();

            // Gán 12 tham số cho 2 khối UNION
            for (int i = 0; i <= 6; i += 6) {
                ps.setString(i + 1, c);
                ps.setString(i + 2, "%" + c + "%");
                ps.setString(i + 3, n);
                ps.setString(i + 4, "%" + n + "%");
                ps.setString(i + 5, p);
                ps.setString(i + 6, "%" + p + "%");
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Activity a = new Activity();
                a.setRelatedId(rs.getInt("id"));
                a.setRelatedType(rs.getString("source"));
                a.setSubject(rs.getString("code"));
                a.setCustomerName(rs.getString("full_name"));
                a.setCustomerPhone(rs.getString("phone"));
                a.setStatus(rs.getString("status"));
                a.setCreatedBy(rs.getInt("created_by"));
                a.setPerformerName(rs.getString("creator_name"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Activity> getPendingLeads(int userId) {
        List<Activity> list = new ArrayList<>();
        String sql = "SELECT a.*, l.full_name, l.phone "
                + "FROM activities a "
                + "INNER JOIN leads l ON a.related_id = l.lead_id "
                + "WHERE a.status = 'Pending' AND a.related_type = 'Lead' "
                + "AND a.performed_by = ? " 
                // Thêm dòng này để chặn phiếu chuyển tiếp
                + "AND (a.[description] NOT LIKE N'Phiếu yêu cầu hỗ trợ được chuyển tiếp%' OR a.[description] IS NULL) "
                + "ORDER BY a.created_at ASC";
                
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Activity a = mapResultSetToActivity(rs);
                a.setCustomerName(rs.getString("full_name"));
                a.setCustomerPhone(rs.getString("phone"));
                a.setRelatedType("Lead");
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==================== NEW SALE MODULE METHODS ====================

    public boolean deleteActivity(int activityId) {
        String sql = "DELETE FROM activities WHERE activity_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, activityId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Activity> getActivitiesByRelatedEntity(int relatedId, String relatedType) {
        List<Activity> list = new ArrayList<>();
        String sql = "SELECT a.*, "
                + "(u.last_name + ' ' + u.first_name) AS performer_name, "
                + "COALESCE(c.full_name, l.full_name) AS contact_name "
                + "FROM activities a "
                + "LEFT JOIN users u ON a.performed_by = u.user_id "
                + "LEFT JOIN customers c ON a.related_type = 'Customer' AND a.related_id = c.customer_id "
                + "LEFT JOIN leads l ON a.related_type = 'Lead' AND a.related_id = l.lead_id "
                + "WHERE a.related_id = ? AND a.related_type = ? "
                + "ORDER BY a.activity_date DESC, a.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, relatedId);
            ps.setString(2, relatedType);
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

    public List<Activity> getActivitiesByRelatedEntityForOpportunity(int opportunityId) {
        List<Activity> list = new ArrayList<>();
        String sql = "SELECT a.*, "
                + "(u.last_name + ' ' + u.first_name) AS performer_name, "
                + "COALESCE(c.full_name, l.full_name) AS contact_name "
                + "FROM activities a "
                + "LEFT JOIN users u ON a.performed_by = u.user_id "
                + "LEFT JOIN customers c ON a.related_type = 'Customer' AND a.related_id = c.customer_id "
                + "LEFT JOIN leads l ON a.related_type = 'Lead' AND a.related_id = l.lead_id "
                + "WHERE a.related_id = ? AND a.related_type = 'Opportunity' "
                + "ORDER BY a.activity_date DESC, a.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, opportunityId);
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

    public List<Activity> getActivitiesByUserFiltered(int userId, String typeFilter, String keyword,
            String statusFilter, String relatedTypeFilter, String startDate, String endDate, int offset, int limit) {
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
        List<Object> params = new ArrayList<>();
        params.add(userId);

        if (typeFilter != null && !typeFilter.isEmpty()) {
            sql.append(" AND a.activity_type = ?");
            params.add(typeFilter);
        }
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND a.status = ?");
            params.add(statusFilter);
        }
        if (relatedTypeFilter != null && !relatedTypeFilter.isEmpty()) {
            sql.append(" AND a.related_type = ?");
            params.add(relatedTypeFilter);
        }
        if (startDate != null && !startDate.isEmpty()) {
            sql.append(" AND CAST(a.activity_date AS DATE) >= ?");
            params.add(startDate);
        }
        if (endDate != null && !endDate.isEmpty()) {
            sql.append(" AND CAST(a.activity_date AS DATE) <= ?");
            params.add(endDate);
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (a.subject LIKE ? OR a.[description] LIKE ?)");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
        }
        sql.append(" ORDER BY a.activity_date DESC, a.created_at DESC");
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(limit);

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof Integer) {
                    ps.setInt(i + 1, (Integer) p);
                } else {
                    ps.setString(i + 1, (String) p);
                }
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

    public int countActivitiesByUserFiltered(int userId, String typeFilter, String keyword,
            String statusFilter, String relatedTypeFilter, String startDate, String endDate) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) AS cnt FROM activities a WHERE a.performed_by = ?");
        List<Object> params = new ArrayList<>();
        params.add(userId);

        if (typeFilter != null && !typeFilter.isEmpty()) {
            sql.append(" AND a.activity_type = ?");
            params.add(typeFilter);
        }
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND a.status = ?");
            params.add(statusFilter);
        }
        if (relatedTypeFilter != null && !relatedTypeFilter.isEmpty()) {
            sql.append(" AND a.related_type = ?");
            params.add(relatedTypeFilter);
        }
        if (startDate != null && !startDate.isEmpty()) {
            sql.append(" AND CAST(a.activity_date AS DATE) >= ?");
            params.add(startDate);
        }
        if (endDate != null && !endDate.isEmpty()) {
            sql.append(" AND CAST(a.activity_date AS DATE) <= ?");
            params.add(endDate);
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (a.subject LIKE ? OR a.[description] LIKE ?)");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof Integer) {
                    ps.setInt(i + 1, (Integer) p);
                } else {
                    ps.setString(i + 1, (String) p);
                }
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("cnt");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Activity> getRecentActivitiesByUser(int userId, int limit) {
        List<Activity> list = new ArrayList<>();
        String sql = "SELECT TOP (?) a.*, "
                + "(u.last_name + ' ' + u.first_name) AS performer_name, "
                + "COALESCE(c.full_name, l.full_name) AS contact_name "
                + "FROM activities a "
                + "LEFT JOIN users u ON a.performed_by = u.user_id "
                + "LEFT JOIN customers c ON a.related_type = 'Customer' AND a.related_id = c.customer_id "
                + "LEFT JOIN leads l ON a.related_type = 'Lead' AND a.related_id = l.lead_id "
                + "WHERE a.performed_by = ? "
                + "ORDER BY a.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, userId);
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

    public boolean markActivityCompleted(int activityId) {
        String sql = "UPDATE activities SET status = 'Completed' WHERE activity_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, activityId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ==================== MANAGER ACTIVITY LOG ====================

    /**
     * Lấy KPI tổng quan cho trang Log Activities của Manager.
     * Đếm tổng hoạt động, số meeting, call, email trong 7 ngày gần nhất.
     */
    public Map<String, Integer> getManagerActivityKpi() {
        Map<String, Integer> kpi = new HashMap<>();
        String sql = "SELECT "
                + "COUNT(*) AS total, "
                + "SUM(CASE WHEN activity_type = 'Meeting' THEN 1 ELSE 0 END) AS meetings, "
                + "SUM(CASE WHEN activity_type = 'Call' THEN 1 ELSE 0 END) AS calls, "
                + "SUM(CASE WHEN activity_type = 'Email' THEN 1 ELSE 0 END) AS emails "
                + "FROM activities a "
                + "INNER JOIN users u ON a.performed_by = u.user_id "
                + "INNER JOIN user_roles ur ON ur.user_id = u.user_id "
                + "INNER JOIN roles r ON r.role_id = ur.role_id "
                + "WHERE LOWER(r.role_code) IN ('sales', 'support')";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                kpi.put("total", rs.getInt("total"));
                kpi.put("meetings", rs.getInt("meetings"));
                kpi.put("calls", rs.getInt("calls"));
                kpi.put("emails", rs.getInt("emails"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return kpi;
    }

    /**
     * Lấy danh sách activities có phân trang và bộ lọc cho Manager.
     * Chỉ lấy activities của nhân viên Sales và Customer Success (SUPPORT).
     */
    public List<Activity> getManagerActivityLogPaged(String activityType, String relatedType,
            String roleFilter, String keyword, String status, int offset, int limit) {
        List<Activity> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT a.*, "
                + "(u.last_name + ' ' + u.first_name) AS performer_name, "
                + "COALESCE(c.full_name, l.full_name) AS contact_name, "
                + "r.role_code AS performer_role "
                + "FROM activities a "
                + "INNER JOIN users u ON a.performed_by = u.user_id "
                + "INNER JOIN user_roles ur ON ur.user_id = u.user_id "
                + "INNER JOIN roles r ON r.role_id = ur.role_id "
                + "LEFT JOIN customers c ON a.related_type = 'Customer' AND a.related_id = c.customer_id "
                + "LEFT JOIN leads l ON a.related_type = 'Lead' AND a.related_id = l.lead_id "
                + "WHERE LOWER(r.role_code) IN ('sales', 'support') ");

        List<Object> params = new ArrayList<>();

        if (activityType != null && !activityType.isEmpty()) {
            sql.append("AND a.activity_type = ? ");
            params.add(activityType);
        }
        if (relatedType != null && !relatedType.isEmpty()) {
            sql.append("AND a.related_type = ? ");
            params.add(relatedType);
        }
        if (roleFilter != null && !roleFilter.isEmpty()) {
            sql.append("AND LOWER(r.role_code) = LOWER(?) ");
            params.add(roleFilter);
        }
        if (status != null && !status.isEmpty()) {
            sql.append("AND a.status = ? ");
            params.add(status);
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (a.subject LIKE ? OR a.[description] LIKE ? "
                    + "OR (u.last_name + ' ' + u.first_name) LIKE ? "
                    + "OR COALESCE(c.full_name, l.full_name) LIKE ?) ");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }

        sql.append("ORDER BY a.created_at DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(limit);

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof Integer) {
                    ps.setInt(i + 1, (Integer) p);
                } else {
                    ps.setString(i + 1, (String) p);
                }
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

    /**
     * Đếm tổng số activities cho phân trang (Manager).
     */
    public int countManagerActivityLog(String activityType, String relatedType,
            String roleFilter, String keyword, String status) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) AS cnt "
                + "FROM activities a "
                + "INNER JOIN users u ON a.performed_by = u.user_id "
                + "INNER JOIN user_roles ur ON ur.user_id = u.user_id "
                + "INNER JOIN roles r ON r.role_id = ur.role_id "
                + "LEFT JOIN customers c ON a.related_type = 'Customer' AND a.related_id = c.customer_id "
                + "LEFT JOIN leads l ON a.related_type = 'Lead' AND a.related_id = l.lead_id "
                + "WHERE LOWER(r.role_code) IN ('sales', 'support') ");

        List<Object> params = new ArrayList<>();

        if (activityType != null && !activityType.isEmpty()) {
            sql.append("AND a.activity_type = ? ");
            params.add(activityType);
        }
        if (relatedType != null && !relatedType.isEmpty()) {
            sql.append("AND a.related_type = ? ");
            params.add(relatedType);
        }
        if (roleFilter != null && !roleFilter.isEmpty()) {
            sql.append("AND LOWER(r.role_code) = LOWER(?) ");
            params.add(roleFilter);
        }
        if (status != null && !status.isEmpty()) {
            sql.append("AND a.status = ? ");
            params.add(status);
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (a.subject LIKE ? OR a.[description] LIKE ? "
                    + "OR (u.last_name + ' ' + u.first_name) LIKE ? "
                    + "OR COALESCE(c.full_name, l.full_name) LIKE ?) ");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof Integer) {
                    ps.setInt(i + 1, (Integer) p);
                } else {
                    ps.setString(i + 1, (String) p);
                }
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("cnt");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // LẤY DANH SÁCH PHIẾU ĐƯỢC CHUYỂN TIẾP CHO RIÊNG NHÂN VIÊN
   // LẤY DANH SÁCH PHIẾU ĐƯỢC CHUYỂN TIẾP CHO RIÊNG NHÂN VIÊN
    public List<Activity> getMyAssignedTickets(int userId) {
        List<Activity> list = new ArrayList<>();
        
        // CẬP NHẬT: Thêm điều kiện lọc a.[description] LIKE N'Phiếu yêu cầu hỗ trợ được chuyển tiếp%'
        String sql = "SELECT a.*, "
                   + "COALESCE(c.full_name, l.full_name) AS contact_name, "
                   + "COALESCE(c.phone, l.phone) AS contact_phone "
                   + "FROM activities a "
                   + "LEFT JOIN customers c ON a.related_type = 'Customer' AND a.related_id = c.customer_id "
                   + "LEFT JOIN leads l ON a.related_type = 'Lead' AND a.related_id = l.lead_id "
                   + "WHERE a.performed_by = ? AND a.status = 'Pending' "
                   + "AND a.[description] LIKE N'Phiếu yêu cầu hỗ trợ được chuyển tiếp%' "
                   + "ORDER BY a.created_at ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                // Tận dụng hàm map có sẵn của bạn
                Activity a = mapResultSetToActivity(rs);
                a.setCustomerName(rs.getString("contact_name"));
                a.setCustomerPhone(rs.getString("contact_phone"));
                a.setRelatedType(rs.getString("related_type"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
