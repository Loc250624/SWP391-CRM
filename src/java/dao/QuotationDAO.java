package dao;

import dbConnection.DBContext;
import model.Quotation;
import java.sql.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Year;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class QuotationDAO extends DBContext {

    public String generateQuotationCode() {
        String year = String.valueOf(Year.now().getValue());
        String sql = "SELECT COUNT(*) FROM quotations WHERE quotation_code LIKE ?";
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, "QT-" + year + "-%");
            ResultSet rs = stmt.executeQuery();
            int count = 0;
            if (rs.next()) {
                count = rs.getInt(1);
            }
            return String.format("QT-%s-%04d", year, count + 1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "QT-" + year + "-0001";
    }

    public int insertQuotation(Quotation q) {
        String sql = "INSERT INTO quotations ("
                + "quotation_code, quotation_number, version, "
                + "opportunity_id, customer_id, lead_id, "
                + "quote_date, valid_until, expiry_days, status, "
                + "currency, subtotal, discount_type, discount_percent, discount_amount, "
                + "tax_percent, tax_amount, total_amount, "
                + "requires_approval, "
                + "title, description, terms_conditions, payment_terms, delivery_terms, "
                + "notes, internal_notes, created_by"
                + ") VALUES (?,?,?, ?,?,?, ?,?,?,?, ?,?,?,?,?, ?,?,?, ?, ?,?,?,?,?, ?,?,?)";
        try {
            PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            String code = q.getQuotationCode();
            stmt.setString(1, code);
            stmt.setString(2, q.getQuotationNumber() != null ? q.getQuotationNumber() : code);
            stmt.setInt(3, q.getVersion() != null ? q.getVersion() : 1);

            setNullableInt(stmt, 4, q.getOpportunityId());
            setNullableInt(stmt, 5, q.getCustomerId());
            setNullableInt(stmt, 6, q.getLeadId());

            stmt.setDate(7, q.getQuoteDate() != null ? Date.valueOf(q.getQuoteDate()) : Date.valueOf(LocalDate.now()));
            stmt.setDate(8, Date.valueOf(q.getValidUntil()));
            setNullableInt(stmt, 9, q.getExpiryDays());
            stmt.setString(10, q.getStatus() != null ? q.getStatus() : "Draft");

            stmt.setString(11, q.getCurrency() != null ? q.getCurrency() : "VND");
            stmt.setBigDecimal(12, q.getSubtotal() != null ? q.getSubtotal() : BigDecimal.ZERO);
            stmt.setString(13, q.getDiscountType());
            setNullableInt(stmt, 14, q.getDiscountPercent());
            stmt.setBigDecimal(15, q.getDiscountAmount() != null ? q.getDiscountAmount() : BigDecimal.ZERO);
            setNullableInt(stmt, 16, q.getTaxPercent());
            stmt.setBigDecimal(17, q.getTaxAmount() != null ? q.getTaxAmount() : BigDecimal.ZERO);
            stmt.setBigDecimal(18, q.getTotalAmount() != null ? q.getTotalAmount() : BigDecimal.ZERO);

            stmt.setBoolean(19, q.getRequiresApproval() != null ? q.getRequiresApproval() : true);

            stmt.setString(20, q.getTitle());
            stmt.setString(21, q.getDescription());
            stmt.setString(22, q.getTermsConditions());
            stmt.setString(23, q.getPaymentTerms());
            stmt.setString(24, q.getDeliveryTerms());
            stmt.setString(25, q.getNotes());
            stmt.setString(26, q.getInternalNotes());
            setNullableInt(stmt, 27, q.getCreatedBy());

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                ResultSet keys = stmt.getGeneratedKeys();
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean updateQuotation(Quotation q) {
        String sql = "UPDATE quotations SET "
                + "title=?, description=?, opportunity_id=?, customer_id=?, lead_id=?, "
                + "valid_until=?, expiry_days=?, status=?, "
                + "currency=?, subtotal=?, discount_type=?, discount_percent=?, discount_amount=?, "
                + "tax_percent=?, tax_amount=?, total_amount=?, "
                + "terms_conditions=?, payment_terms=?, delivery_terms=?, "
                + "notes=?, internal_notes=?, updated_by=? "
                + "WHERE quotation_id=?";
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, q.getTitle());
            stmt.setString(2, q.getDescription());
            setNullableInt(stmt, 3, q.getOpportunityId());
            setNullableInt(stmt, 4, q.getCustomerId());
            setNullableInt(stmt, 5, q.getLeadId());
            stmt.setDate(6, q.getValidUntil() != null ? Date.valueOf(q.getValidUntil()) : null);
            setNullableInt(stmt, 7, q.getExpiryDays());
            stmt.setString(8, q.getStatus());
            stmt.setString(9, q.getCurrency());
            stmt.setBigDecimal(10, q.getSubtotal());
            stmt.setString(11, q.getDiscountType());
            setNullableInt(stmt, 12, q.getDiscountPercent());
            stmt.setBigDecimal(13, q.getDiscountAmount());
            setNullableInt(stmt, 14, q.getTaxPercent());
            stmt.setBigDecimal(15, q.getTaxAmount());
            stmt.setBigDecimal(16, q.getTotalAmount());
            stmt.setString(17, q.getTermsConditions());
            stmt.setString(18, q.getPaymentTerms());
            stmt.setString(19, q.getDeliveryTerms());
            stmt.setString(20, q.getNotes());
            stmt.setString(21, q.getInternalNotes());
            setNullableInt(stmt, 22, q.getUpdatedBy());
            stmt.setInt(23, q.getQuotationId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Quotation getQuotationById(int id) {
        String sql = "SELECT * FROM quotations WHERE quotation_id = ?";
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Quotation> getQuotationsByUserId(int userId) {
        List<Quotation> list = new ArrayList<>();
        String sql = "SELECT * FROM quotations WHERE created_by = ? ORDER BY created_at DESC";
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(extractFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Quotation> getQuotationsByOpportunityId(int oppId) {
        List<Quotation> list = new ArrayList<>();
        String sql = "SELECT * FROM quotations WHERE opportunity_id = ? ORDER BY created_at DESC";
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, oppId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(extractFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Quotation> searchQuotations(int userId, String keyword, String status) {
        List<Quotation> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM quotations WHERE created_by = ?");
        List<Object> params = new ArrayList<>();
        params.add(userId);

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (title LIKE ? OR quotation_code LIKE ?)");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND status = ?");
            params.add(status.trim());
        }
        sql.append(" ORDER BY created_at DESC");

        try {
            PreparedStatement stmt = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof Integer) {
                    stmt.setInt(i + 1, (Integer) p);
                } else {
                    stmt.setString(i + 1, (String) p);
                }
            }
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(extractFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean deleteQuotation(int id) {
        String sql = "DELETE FROM quotations WHERE quotation_id = ?";
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Map<String, Integer> countByStatus(int userId) {
        Map<String, Integer> counts = new HashMap<>();
        String sql = "SELECT status, COUNT(*) as cnt FROM quotations WHERE created_by = ? GROUP BY status";
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                counts.put(rs.getString("status"), rs.getInt("cnt"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return counts;
    }

    // ==================== QUOTATION ITEMS ====================

    public List<Map<String, Object>> getItemsByQuotationId(int quotationId) {
        List<Map<String, Object>> items = new ArrayList<>();
        String sql = "SELECT qi.*, c.course_name, c.course_code FROM quotation_items qi "
                + "LEFT JOIN courses c ON qi.course_id = c.course_id "
                + "WHERE qi.quotation_id = ? ORDER BY qi.sort_order, qi.item_id";
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, quotationId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("itemId", rs.getInt("item_id"));
                item.put("quotationId", rs.getInt("quotation_id"));
                item.put("courseId", getNullableInt(rs, "course_id"));
                item.put("itemType", rs.getString("item_type"));
                item.put("description", rs.getString("description"));
                item.put("detailedDescription", rs.getString("detailed_description"));
                item.put("quantity", rs.getInt("quantity"));
                item.put("unitPrice", rs.getBigDecimal("unit_price"));
                item.put("discountPercent", rs.getInt("discount_percent"));
                item.put("discountAmount", rs.getBigDecimal("discount_amount"));
                item.put("lineTotal", rs.getBigDecimal("line_total"));
                item.put("sortOrder", rs.getInt("sort_order"));
                item.put("isOptional", rs.getBoolean("is_optional"));
                item.put("courseName", rs.getString("course_name"));
                item.put("courseCode", rs.getString("course_code"));
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    public int insertItem(int quotationId, Integer courseId, String itemType, String description,
                          int quantity, BigDecimal unitPrice, int discountPercent,
                          BigDecimal discountAmount, BigDecimal lineTotal, int sortOrder, boolean isOptional) {
        String sql = "INSERT INTO quotation_items (quotation_id, course_id, item_type, description, "
                + "quantity, unit_price, discount_percent, discount_amount, line_total, sort_order, is_optional) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, quotationId);
            setNullableInt(stmt, 2, courseId);
            stmt.setString(3, itemType != null ? itemType : "Course");
            stmt.setString(4, description);
            stmt.setInt(5, quantity);
            stmt.setBigDecimal(6, unitPrice);
            stmt.setInt(7, discountPercent);
            stmt.setBigDecimal(8, discountAmount);
            stmt.setBigDecimal(9, lineTotal);
            stmt.setInt(10, sortOrder);
            stmt.setBoolean(11, isOptional);
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                ResultSet keys = stmt.getGeneratedKeys();
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean deleteItemsByQuotationId(int quotationId) {
        String sql = "DELETE FROM quotation_items WHERE quotation_id = ?";
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, quotationId);
            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ==================== QUOTATION VERSIONS ====================

    public int insertVersion(int quotationId, int versionNumber, String snapshotData,
                             BigDecimal totalAmount, String changeReason, String changeSummary, int createdBy) {
        String sql = "INSERT INTO quotation_versions (quotation_id, version_number, snapshot_data, "
                + "total_amount, change_reason, change_summary, created_by) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, quotationId);
            stmt.setInt(2, versionNumber);
            stmt.setString(3, snapshotData);
            stmt.setBigDecimal(4, totalAmount);
            stmt.setString(5, changeReason);
            stmt.setString(6, changeSummary);
            stmt.setInt(7, createdBy);
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                ResultSet keys = stmt.getGeneratedKeys();
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public List<Map<String, Object>> getVersionsByQuotationId(int quotationId) {
        List<Map<String, Object>> versions = new ArrayList<>();
        String sql = "SELECT * FROM quotation_versions WHERE quotation_id = ? ORDER BY version_number DESC";
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, quotationId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> v = new HashMap<>();
                v.put("versionId", rs.getInt("version_id"));
                v.put("quotationId", rs.getInt("quotation_id"));
                v.put("versionNumber", rs.getInt("version_number"));
                v.put("snapshotData", rs.getString("snapshot_data"));
                v.put("totalAmount", rs.getBigDecimal("total_amount"));
                v.put("changeReason", rs.getString("change_reason"));
                v.put("changeSummary", rs.getString("change_summary"));
                v.put("createdAt", getNullableLocalDateTime(rs, "created_at"));
                v.put("createdBy", rs.getInt("created_by"));
                versions.add(v);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return versions;
    }

    // ==================== TRACKING LOGS ====================

    public int insertTrackingLog(int quotationId, String eventType, String ipAddress,
                                 String userAgent, String deviceType, String browser) {
        String sql = "INSERT INTO quotation_tracking_logs (quotation_id, event_type, ip_address, "
                + "user_agent, device_type, browser) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, quotationId);
            stmt.setString(2, eventType);
            stmt.setString(3, ipAddress);
            stmt.setString(4, userAgent);
            stmt.setString(5, deviceType);
            stmt.setString(6, browser);
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                ResultSet keys = stmt.getGeneratedKeys();
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public List<Map<String, Object>> getTrackingLogsByQuotationId(int quotationId) {
        List<Map<String, Object>> logs = new ArrayList<>();
        String sql = "SELECT * FROM quotation_tracking_logs WHERE quotation_id = ? ORDER BY event_date DESC";
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, quotationId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> log = new HashMap<>();
                log.put("logId", rs.getInt("log_id"));
                log.put("quotationId", rs.getInt("quotation_id"));
                log.put("eventType", rs.getString("event_type"));
                log.put("eventDate", getNullableLocalDateTime(rs, "event_date"));
                log.put("ipAddress", rs.getString("ip_address"));
                log.put("userAgent", rs.getString("user_agent"));
                log.put("deviceType", rs.getString("device_type"));
                log.put("browser", rs.getString("browser"));
                log.put("locationCountry", rs.getString("location_country"));
                log.put("locationCity", rs.getString("location_city"));
                log.put("sessionId", rs.getString("session_id"));
                log.put("pageUrl", rs.getString("page_url"));
                log.put("referrerUrl", rs.getString("referrer_url"));
                log.put("durationSeconds", getNullableInt(rs, "duration_seconds"));
                log.put("metadata", rs.getString("metadata"));
                log.put("emailLogId", getNullableInt(rs, "email_log_id"));
                logs.add(log);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return logs;
    }

    // ==================== STATUS WORKFLOW ====================

    public boolean approveQuotation(int quotationId, int approvedBy, String approvalNotes) {
        String sql = "UPDATE quotations SET status='Approved', approved_by=?, approved_date=GETDATE(), "
                + "approval_notes=? WHERE quotation_id=? AND status='Draft'";
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, approvedBy);
            stmt.setString(2, approvalNotes);
            stmt.setInt(3, quotationId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean rejectQuotation(int quotationId, int rejectedBy, String reason) {
        String sql = "UPDATE quotations SET status='Rejected', rejected_by=?, rejected_date=GETDATE(), "
                + "rejection_reason=? WHERE quotation_id=? AND status='Draft'";
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, rejectedBy);
            stmt.setString(2, reason);
            stmt.setInt(3, quotationId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean sendQuotation(int quotationId, int sentBy) {
        String sql = "UPDATE quotations SET status='Sent', sent_by=?, sent_date=GETDATE() "
                + "WHERE quotation_id=? AND status='Approved'";
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, sentBy);
            stmt.setInt(2, quotationId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateSubtotalAndTotal(int quotationId) {
        String sql = "UPDATE quotations SET "
                + "subtotal = ISNULL((SELECT SUM(line_total) FROM quotation_items WHERE quotation_id = ?), 0), "
                + "total_amount = ISNULL((SELECT SUM(line_total) FROM quotation_items WHERE quotation_id = ?), 0) "
                + "WHERE quotation_id = ?";
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, quotationId);
            stmt.setInt(2, quotationId);
            stmt.setInt(3, quotationId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Quotation> getPendingApprovalQuotations() {
        List<Quotation> list = new ArrayList<>();
        String sql = "SELECT * FROM quotations WHERE status='Draft' AND requires_approval=1 ORDER BY created_at DESC";
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(extractFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==================== COURSES (helper) ====================

    public List<Map<String, Object>> getActiveCourses() {
        List<Map<String, Object>> courses = new ArrayList<>();
        String sql = "SELECT course_id, course_code, course_name, price FROM courses WHERE is_active = 1 ORDER BY course_name";
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> c = new HashMap<>();
                c.put("courseId", rs.getInt("course_id"));
                c.put("courseCode", rs.getString("course_code"));
                c.put("courseName", rs.getString("course_name"));
                c.put("price", rs.getBigDecimal("price"));
                courses.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }

    // ==================== EXTRACT ====================

    private Quotation extractFromResultSet(ResultSet rs) throws SQLException {
        Quotation q = new Quotation();
        q.setQuotationId(rs.getInt("quotation_id"));
        q.setQuotationCode(rs.getString("quotation_code"));
        q.setQuotationNumber(rs.getString("quotation_number"));
        q.setVersion(rs.getInt("version"));

        q.setOpportunityId(getNullableInt(rs, "opportunity_id"));
        q.setCustomerId(getNullableInt(rs, "customer_id"));
        q.setLeadId(getNullableInt(rs, "lead_id"));

        q.setQuoteDate(getNullableLocalDate(rs, "quote_date"));
        q.setValidUntil(getNullableLocalDate(rs, "valid_until"));
        q.setExpiryDays(getNullableInt(rs, "expiry_days"));
        q.setStatus(rs.getString("status"));

        q.setCurrency(rs.getString("currency"));
        q.setSubtotal(rs.getBigDecimal("subtotal"));
        q.setDiscountType(rs.getString("discount_type"));
        q.setDiscountPercent(getNullableInt(rs, "discount_percent"));
        q.setDiscountAmount(rs.getBigDecimal("discount_amount"));
        q.setTaxPercent(getNullableInt(rs, "tax_percent"));
        q.setTaxAmount(rs.getBigDecimal("tax_amount"));
        q.setTotalAmount(rs.getBigDecimal("total_amount"));

        q.setRequiresApproval(rs.getBoolean("requires_approval"));
        q.setApprovedBy(getNullableInt(rs, "approved_by"));
        q.setApprovedDate(getNullableLocalDateTime(rs, "approved_date"));
        q.setApprovalNotes(rs.getString("approval_notes"));
        q.setRejectedBy(getNullableInt(rs, "rejected_by"));
        q.setRejectedDate(getNullableLocalDateTime(rs, "rejected_date"));
        q.setRejectionReason(rs.getString("rejection_reason"));

        q.setSentDate(getNullableLocalDateTime(rs, "sent_date"));
        q.setSentBy(getNullableInt(rs, "sent_by"));
        q.setFirstViewedDate(getNullableLocalDateTime(rs, "first_viewed_date"));
        q.setLastViewedDate(getNullableLocalDateTime(rs, "last_viewed_date"));
        q.setViewCount(getNullableInt(rs, "view_count"));
        q.setTotalViewDurationSeconds(getNullableInt(rs, "total_view_duration_seconds"));

        q.setAcceptedDate(getNullableLocalDateTime(rs, "accepted_date"));
        q.setAcceptedByName(rs.getString("accepted_by_name"));
        q.setAcceptedByEmail(rs.getString("accepted_by_email"));
        q.setAcceptedIpAddress(rs.getString("accepted_ip_address"));

        q.setCustomerRejectedDate(getNullableLocalDateTime(rs, "customer_rejected_date"));
        q.setCustomerRejectionReason(rs.getString("customer_rejection_reason"));

        q.setPdfPath(rs.getString("pdf_path"));
        q.setPdfUrl(rs.getString("pdf_url"));
        q.setPdfGeneratedDate(getNullableLocalDateTime(rs, "pdf_generated_date"));

        q.setTrackingToken(rs.getString("tracking_token"));
        q.setTrackingUrl(rs.getString("tracking_url"));
        q.setEmailTrackingEnabled(rs.getBoolean("email_tracking_enabled"));
        q.setLastEmailSentId(getNullableInt(rs, "last_email_sent_id"));

        q.setTitle(rs.getString("title"));
        q.setDescription(rs.getString("description"));
        q.setTermsConditions(rs.getString("terms_conditions"));
        q.setPaymentTerms(rs.getString("payment_terms"));
        q.setDeliveryTerms(rs.getString("delivery_terms"));
        q.setNotes(rs.getString("notes"));
        q.setInternalNotes(rs.getString("internal_notes"));

        q.setCreatedAt(getNullableLocalDateTime(rs, "created_at"));
        q.setCreatedBy(getNullableInt(rs, "created_by"));
        q.setUpdatedAt(getNullableLocalDateTime(rs, "updated_at"));
        q.setUpdatedBy(getNullableInt(rs, "updated_by"));

        return q;
    }

    // ==================== HELPERS ====================

    private void setNullableInt(PreparedStatement stmt, int index, Integer value) throws SQLException {
        if (value != null) {
            stmt.setInt(index, value);
        } else {
            stmt.setNull(index, Types.INTEGER);
        }
    }

    private Integer getNullableInt(ResultSet rs, String col) throws SQLException {
        int val = rs.getInt(col);
        return rs.wasNull() ? null : val;
    }

    private LocalDate getNullableLocalDate(ResultSet rs, String col) throws SQLException {
        Date d = rs.getDate(col);
        return d != null ? d.toLocalDate() : null;
    }

    private LocalDateTime getNullableLocalDateTime(ResultSet rs, String col) throws SQLException {
        Timestamp ts = rs.getTimestamp(col);
        return ts != null ? ts.toLocalDateTime() : null;
    }
}
