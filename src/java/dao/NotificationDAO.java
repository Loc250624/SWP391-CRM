package dao;

import dbConnection.DBContext;
import model.Notification;
import model.NotificationRecipient;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class NotificationDAO extends DBContext {


    public int insertNotification(Notification n) {
        String sql = "INSERT INTO notifications (title, message, summary, type, category, priority, "
                + "related_type, related_id, action_url, sender_id, is_system, "
                + "target_type, target_value, scheduled_at, is_sent, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
        try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            st.setString(1, n.getTitle());
            st.setString(2, n.getMessage());
            st.setString(3, n.getSummary());
            st.setString(4, n.getType());
            st.setString(5, n.getCategory());
            st.setString(6, n.getPriority() != null ? n.getPriority() : "NORMAL");
            st.setString(7, n.getRelatedType());
            if (n.getRelatedId() != null) {
                st.setInt(8, n.getRelatedId());
            } else {
                st.setNull(8, Types.INTEGER);
            }
            st.setString(9, n.getActionUrl());
            if (n.getSenderId() != null) {
                st.setInt(10, n.getSenderId());
            } else {
                st.setNull(10, Types.INTEGER);
            }
            st.setBoolean(11, n.getIsSystem());
            st.setString(12, n.getTargetType() != null ? n.getTargetType() : "INDIVIDUAL");
            st.setString(13, n.getTargetValue());
            if (n.getScheduledAt() != null) {
                st.setTimestamp(14, Timestamp.valueOf(n.getScheduledAt()));
            } else {
                st.setNull(14, Types.TIMESTAMP);
            }
            st.setBoolean(15, n.getIsSent());

            int rows = st.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = st.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean insertRecipient(int notificationId, int userId, String channel) {
        String sql = "INSERT INTO notification_recipients (notification_id, user_id, channel, delivery_status, created_at) "
                + "VALUES (?, ?, ?, 'SENT', GETDATE())";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, notificationId);
            st.setInt(2, userId);
            st.setString(3, channel != null ? channel : "IN_APP");
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int insertRecipients(int notificationId, List<Integer> userIds, String channel) {
        String sql = "INSERT INTO notification_recipients (notification_id, user_id, channel, delivery_status, created_at) "
                + "VALUES (?, ?, ?, 'SENT', GETDATE())";
        int count = 0;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            for (int userId : userIds) {
                st.setInt(1, notificationId);
                st.setInt(2, userId);
                st.setString(3, channel != null ? channel : "IN_APP");
                st.addBatch();
            }
            int[] results = st.executeBatch();
            for (int r : results) {
                if (r > 0) count++;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }


    public int createAndSend(String title, String summary, String type, String category,
            String priority, String relatedType, Integer relatedId,
            String actionUrl, Integer senderId, boolean isSystem, int recipientUserId) {
        Notification n = new Notification();
        n.setTitle(title);
        n.setSummary(summary);
        n.setType(type);
        n.setCategory(category);
        n.setPriority(priority);
        n.setRelatedType(relatedType);
        n.setRelatedId(relatedId);
        n.setActionUrl(actionUrl);
        n.setSenderId(senderId);
        n.setIsSystem(isSystem);
        n.setIsSent(true);

        int notifId = insertNotification(n);
        if (notifId > 0) {
            insertRecipient(notifId, recipientUserId, "IN_APP");
        }
        return notifId;
    }

    public int createAndSendToMany(String title, String summary, String type, String category,
            String priority, String relatedType, Integer relatedId,
            String actionUrl, Integer senderId, boolean isSystem,
            List<Integer> recipientUserIds) {
        Notification n = new Notification();
        n.setTitle(title);
        n.setSummary(summary);
        n.setType(type);
        n.setCategory(category);
        n.setPriority(priority);
        n.setRelatedType(relatedType);
        n.setRelatedId(relatedId);
        n.setActionUrl(actionUrl);
        n.setSenderId(senderId);
        n.setIsSystem(isSystem);
        n.setIsSent(true);

        int notifId = insertNotification(n);
        if (notifId > 0) {
            insertRecipients(notifId, recipientUserIds, "IN_APP");
        }
        return notifId;
    }
  
    public List<Map<String, Object>> getByUserId(int userId, int offset, int limit) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT n.*, "
                + "nr.id AS nr_id, nr.user_id AS nr_user_id, nr.is_read, nr.read_at, "
                + "nr.is_dismissed, nr.dismissed_at, nr.channel, nr.delivery_status, "
                + "nr.delivered_at, nr.created_at AS nr_created_at, "
                + "ISNULL(u.first_name + ' ' + u.last_name, '') AS sender_name "
                + "FROM notification_recipients nr "
                + "JOIN notifications n ON n.notification_id = nr.notification_id "
                + "LEFT JOIN users u ON u.user_id = n.sender_id "
                + "WHERE nr.user_id = ? AND nr.is_dismissed = 0 "
                + "ORDER BY nr.is_read ASC, n.created_at DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            st.setInt(2, offset);
            st.setInt(3, limit);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("notification", mapNotificationFromResultSet(rs));
                    row.put("recipient", mapRecipientFromResultSet(rs));
                    row.put("senderName", rs.getString("sender_name"));
                    list.add(row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<Map<String, Object>> getUnreadByUserId(int userId, int limit) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT n.*, "
                + "nr.id AS nr_id, nr.user_id AS nr_user_id, nr.is_read, nr.read_at, "
                + "nr.is_dismissed, nr.dismissed_at, nr.channel, nr.delivery_status, "
                + "nr.delivered_at, nr.created_at AS nr_created_at, "
                + "ISNULL(u.first_name + ' ' + u.last_name, '') AS sender_name "
                + "FROM notification_recipients nr "
                + "JOIN notifications n ON n.notification_id = nr.notification_id "
                + "LEFT JOIN users u ON u.user_id = n.sender_id "
                + "WHERE nr.user_id = ? AND nr.is_read = 0 AND nr.is_dismissed = 0 "
                + "ORDER BY n.created_at DESC "
                + "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            st.setInt(2, limit);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("notification", mapNotificationFromResultSet(rs));
                    row.put("recipient", mapRecipientFromResultSet(rs));
                    row.put("senderName", rs.getString("sender_name"));
                    list.add(row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countUnread(int userId) {
        String sql = "SELECT COUNT(*) FROM notification_recipients "
                + "WHERE user_id = ? AND is_read = 0 AND is_dismissed = 0";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countTotal(int userId) {
        String sql = "SELECT COUNT(*) FROM notification_recipients "
                + "WHERE user_id = ? AND is_dismissed = 0";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean markAsRead(int notificationId, int userId) {
        String sql = "UPDATE notification_recipients SET is_read = 1, read_at = GETDATE() "
                + "WHERE notification_id = ? AND user_id = ? AND is_read = 0";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, notificationId);
            st.setInt(2, userId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int markAllAsRead(int userId) {
        String sql = "UPDATE notification_recipients SET is_read = 1, read_at = GETDATE() "
                + "WHERE user_id = ? AND is_read = 0 AND is_dismissed = 0";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            return st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public boolean dismiss(int notificationId, int userId) {
        String sql = "UPDATE notification_recipients SET is_dismissed = 1, dismissed_at = GETDATE() "
                + "WHERE notification_id = ? AND user_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, notificationId);
            st.setInt(2, userId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Map<String, Object>> getNotificationList(String typeFilter, String categoryFilter,
            String priorityFilter, String keyword,
            int offset, int limit) {
        List<Map<String, Object>> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT n.*, ")
                .append("ISNULL(u.first_name + ' ' + u.last_name, '') AS sender_name, ")
                .append("(SELECT COUNT(*) FROM notification_recipients nr WHERE nr.notification_id = n.notification_id) AS recipient_count, ")
                .append("(SELECT COUNT(*) FROM notification_recipients nr WHERE nr.notification_id = n.notification_id AND nr.is_read = 1) AS read_count ")
                .append("FROM notifications n ")
                .append("LEFT JOIN users u ON u.user_id = n.sender_id ")
                .append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (typeFilter != null && !typeFilter.isEmpty()) {
            sql.append("AND n.type = ? ");
            params.add(typeFilter);
        }
        if (categoryFilter != null && !categoryFilter.isEmpty()) {
            sql.append("AND n.category = ? ");
            params.add(categoryFilter);
        }
        if (priorityFilter != null && !priorityFilter.isEmpty()) {
            sql.append("AND n.priority = ? ");
            params.add(priorityFilter);
        }
        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (n.title LIKE ? OR n.summary LIKE ?) ");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }

        sql.append("ORDER BY n.created_at DESC ")
                .append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(limit);

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof String) {
                    st.setString(i + 1, (String) p);
                } else if (p instanceof Integer) {
                    st.setInt(i + 1, (Integer) p);
                }
            }
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("notification", mapNotificationFromResultSet(rs));
                    row.put("senderName", rs.getString("sender_name"));
                    row.put("recipientCount", rs.getInt("recipient_count"));
                    row.put("readCount", rs.getInt("read_count"));
                    list.add(row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countNotifications(String typeFilter, String categoryFilter,
            String priorityFilter, String keyword) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM notifications n WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (typeFilter != null && !typeFilter.isEmpty()) {
            sql.append("AND n.type = ? ");
            params.add(typeFilter);
        }
        if (categoryFilter != null && !categoryFilter.isEmpty()) {
            sql.append("AND n.category = ? ");
            params.add(categoryFilter);
        }
        if (priorityFilter != null && !priorityFilter.isEmpty()) {
            sql.append("AND n.priority = ? ");
            params.add(priorityFilter);
        }
        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (n.title LIKE ? OR n.summary LIKE ?) ");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof String) {
                    st.setString(i + 1, (String) p);
                } else if (p instanceof Integer) {
                    st.setInt(i + 1, (Integer) p);
                }
            }
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }


    public Notification getById(int notificationId) {
        String sql = "SELECT * FROM notifications WHERE notification_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, notificationId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapNotificationFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }


    public List<NotificationRecipient> getRecipientsByNotificationId(int notificationId) {
        List<NotificationRecipient> list = new ArrayList<>();
        String sql = "SELECT * FROM notification_recipients WHERE notification_id = ? ORDER BY created_at ASC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, notificationId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRecipientDirect(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public String getSenderName(Integer senderId) {
        if (senderId == null) return null;
        String sql = "SELECT first_name + ' ' + last_name AS full_name FROM users WHERE user_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, senderId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("full_name");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int[] getRecipientStats(int notificationId) {
        String sql = "SELECT COUNT(*) AS total, SUM(CASE WHEN is_read = 1 THEN 1 ELSE 0 END) AS read_count "
                + "FROM notification_recipients WHERE notification_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, notificationId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return new int[]{rs.getInt("total"), rs.getInt("read_count")};
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return new int[]{0, 0};
    }

    public boolean deleteNotification(int notificationId) {
        String sql = "DELETE FROM notifications WHERE notification_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, notificationId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Notification mapNotificationFromResultSet(ResultSet rs) throws SQLException {
        Notification n = new Notification();
        n.setNotificationId(rs.getInt("notification_id"));
        n.setNotificationCode(rs.getString("notification_code"));
        n.setTitle(rs.getString("title"));
        n.setMessage(rs.getString("message"));
        n.setSummary(rs.getString("summary"));
        n.setType(rs.getString("type"));
        n.setCategory(rs.getString("category"));
        n.setPriority(rs.getString("priority"));
        n.setRelatedType(rs.getString("related_type"));
        n.setRelatedId(rs.getObject("related_id", Integer.class));
        n.setActionUrl(rs.getString("action_url"));
        n.setSenderId(rs.getObject("sender_id", Integer.class));
        n.setIsSystem(rs.getBoolean("is_system"));
        n.setTargetType(rs.getString("target_type"));
        n.setTargetValue(rs.getString("target_value"));

        Timestamp scheduledTs = rs.getTimestamp("scheduled_at");
        if (scheduledTs != null) n.setScheduledAt(scheduledTs.toLocalDateTime());

        n.setIsSent(rs.getBoolean("is_sent"));

        Timestamp createdTs = rs.getTimestamp("created_at");
        if (createdTs != null) n.setCreatedAt(createdTs.toLocalDateTime());

        Timestamp updatedTs = rs.getTimestamp("updated_at");
        if (updatedTs != null) n.setUpdatedAt(updatedTs.toLocalDateTime());

        return n;
    }

    private NotificationRecipient mapRecipientFromResultSet(ResultSet rs) throws SQLException {
        NotificationRecipient nr = new NotificationRecipient();
        nr.setId(rs.getInt("nr_id"));
        nr.setNotificationId(rs.getInt("notification_id"));
        nr.setUserId(rs.getInt("nr_user_id"));
        nr.setIsRead(rs.getBoolean("is_read"));

        Timestamp readTs = rs.getTimestamp("read_at");
        if (readTs != null) nr.setReadAt(readTs.toLocalDateTime());

        nr.setIsDismissed(rs.getBoolean("is_dismissed"));

        Timestamp dismissedTs = rs.getTimestamp("dismissed_at");
        if (dismissedTs != null) nr.setDismissedAt(dismissedTs.toLocalDateTime());

        nr.setChannel(rs.getString("channel"));
        nr.setDeliveryStatus(rs.getString("delivery_status"));

        Timestamp deliveredTs = rs.getTimestamp("delivered_at");
        if (deliveredTs != null) nr.setDeliveredAt(deliveredTs.toLocalDateTime());

        Timestamp createdTs = rs.getTimestamp("nr_created_at");
        if (createdTs != null) nr.setCreatedAt(createdTs.toLocalDateTime());

        return nr;
    }

    /**
     * Map recipient khi SELECT * FROM notification_recipients (khong co alias).
     */
    private NotificationRecipient mapRecipientDirect(ResultSet rs) throws SQLException {
        NotificationRecipient nr = new NotificationRecipient();
        nr.setId(rs.getInt("id"));
        nr.setNotificationId(rs.getInt("notification_id"));
        nr.setUserId(rs.getInt("user_id"));
        nr.setIsRead(rs.getBoolean("is_read"));

        Timestamp readTs = rs.getTimestamp("read_at");
        if (readTs != null) nr.setReadAt(readTs.toLocalDateTime());

        nr.setIsDismissed(rs.getBoolean("is_dismissed"));

        Timestamp dismissedTs = rs.getTimestamp("dismissed_at");
        if (dismissedTs != null) nr.setDismissedAt(dismissedTs.toLocalDateTime());

        nr.setChannel(rs.getString("channel"));
        nr.setDeliveryStatus(rs.getString("delivery_status"));

        Timestamp deliveredTs = rs.getTimestamp("delivered_at");
        if (deliveredTs != null) nr.setDeliveredAt(deliveredTs.toLocalDateTime());

        Timestamp createdTs = rs.getTimestamp("created_at");
        if (createdTs != null) nr.setCreatedAt(createdTs.toLocalDateTime());

        return nr;
    }
}
