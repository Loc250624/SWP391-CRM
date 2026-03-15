package util;

import dao.NotificationDAO;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;
import model.Notification;
import model.NotificationRecipient;

public class NotificationUtil {

    // ── Tao thong bao task assigned ──────────────────────────────────
    public static void notifyTaskAssigned(int taskId, String taskCode, String taskTitle,
            String priority, List<Integer> assigneeIds, int senderId) {
        try {
            NotificationDAO dao = new NotificationDAO();
            String taskUrl = "/task/detail?id=" + taskId;
            String summary = taskCode != null
                    ? taskCode + ": " + taskTitle
                    : taskTitle;

            for (int assigneeId : assigneeIds) {
                dao.createAndSend(
                        "Bạn được giao công việc mới",
                        summary,
                        "TASK_ASSIGNED",
                        "SYSTEM",
                        "HIGH".equalsIgnoreCase(priority) ? "HIGH" : "NORMAL",
                        "TASK",
                        taskId,
                        taskUrl,
                        senderId,
                        false,
                        assigneeId
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ── Tao thong bao task status changed ────────────────────────────
    public static void notifyTaskStatusChanged(int taskId, String taskCode, String taskTitle,
            String newStatus, int changedByUserId, List<Integer> notifyUserIds) {
        try {
            NotificationDAO dao = new NotificationDAO();
            String taskUrl = "/task/detail?id=" + taskId;
            String summary = (taskCode != null ? taskCode + ": " : "") + taskTitle;
            String title;
            String priority = "NORMAL";

            switch (newStatus) {
                case "COMPLETED":
                    title = "Công việc đã hoàn thành";
                    break;
                case "CANCELLED":
                    title = "Công việc đã bị hủy";
                    priority = "HIGH";
                    break;
                default:
                    title = "Trạng thái công việc thay đổi";
                    break;
            }

            for (int userId : notifyUserIds) {
                if (userId != changedByUserId) {
                    dao.createAndSend(title, summary,
                            "TASK_STATUS_CHANGED", "SYSTEM", priority,
                            "TASK", taskId, taskUrl,
                            changedByUserId, false, userId);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ── Tao thong bao comment on task ────────────────────────────────
    public static void notifyTaskComment(int taskId, String taskCode, String taskTitle,
            int commenterUserId, List<Integer> notifyUserIds) {
        try {
            NotificationDAO dao = new NotificationDAO();
            String taskUrl = "/task/detail?id=" + taskId;
            String summary = (taskCode != null ? taskCode + ": " : "") + taskTitle;

            for (int userId : notifyUserIds) {
                if (userId != commenterUserId) {
                    dao.createAndSend(
                            "Bình luận mới trên công việc",
                            summary,
                            "TASK_COMMENT",
                            "SYSTEM",
                            "NORMAL",
                            "TASK",
                            taskId,
                            taskUrl,
                            commenterUserId,
                            false,
                            userId
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ── Lead assigned ────────────────────────────────────────────────
    public static void notifyLeadAssigned(int leadId, String leadCode, String leadName,
            int assigneeId, int senderId) {
        try {
            new NotificationDAO().createAndSend(
                    "Bạn được giao Lead mới",
                    (leadCode != null ? leadCode + ": " : "") + leadName,
                    "LEAD_ASSIGNED", "SYSTEM", "NORMAL",
                    "LEAD", leadId, "/lead/detail?id=" + leadId,
                    senderId, false, assigneeId);
        } catch (Exception e) { e.printStackTrace(); }
    }

    // ── Lead converted ────────────────────────────────────────────────
    public static void notifyLeadConverted(int leadId, String leadCode, String leadName,
            int changedByUserId, List<Integer> notifyUserIds) {
        try {
            NotificationDAO dao = new NotificationDAO();
            String summary = (leadCode != null ? leadCode + ": " : "") + leadName;
            for (int userId : notifyUserIds) {
                if (userId != changedByUserId) {
                    dao.createAndSend("Lead đã được chuyển đổi", summary,
                            "LEAD_CONVERTED", "SYSTEM", "NORMAL",
                            "LEAD", leadId, "/lead/detail?id=" + leadId,
                            changedByUserId, false, userId);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    // ── Lead status changed ───────────────────────────────────────────
    public static void notifyLeadStatusChanged(int leadId, String leadCode, String leadName,
            String newStatus, int changedByUserId, List<Integer> notifyUserIds) {
        try {
            NotificationDAO dao = new NotificationDAO();
            String summary = (leadCode != null ? leadCode + ": " : "") + leadName + " → " + newStatus;
            for (int userId : notifyUserIds) {
                if (userId != changedByUserId) {
                    dao.createAndSend("Trạng thái Lead thay đổi", summary,
                            "LEAD_STATUS_CHANGED", "SYSTEM", "NORMAL",
                            "LEAD", leadId, "/lead/detail?id=" + leadId,
                            changedByUserId, false, userId);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    // ── Customer created ──────────────────────────────────────────────
    public static void notifyCustomerCreated(int customerId, String customerCode, String customerName,
            int createdByUserId, List<Integer> notifyUserIds) {
        try {
            NotificationDAO dao = new NotificationDAO();
            String summary = (customerCode != null ? customerCode + ": " : "") + customerName;
            for (int userId : notifyUserIds) {
                if (userId != createdByUserId) {
                    dao.createAndSend("Khách hàng mới được tạo", summary,
                            "CUSTOMER_CREATED", "SYSTEM", "NORMAL",
                            "CUSTOMER", customerId, "/customer/detail?id=" + customerId,
                            createdByUserId, false, userId);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    // ── Opportunity created ───────────────────────────────────────────
    public static void notifyOpportunityCreated(int oppId, String oppCode, String oppName,
            int createdByUserId, List<Integer> notifyUserIds) {
        try {
            NotificationDAO dao = new NotificationDAO();
            String summary = (oppCode != null ? oppCode + ": " : "") + oppName;
            for (int userId : notifyUserIds) {
                if (userId != createdByUserId) {
                    dao.createAndSend("Cơ hội mới được tạo", summary,
                            "OPPORTUNITY_CREATED", "SYSTEM", "NORMAL",
                            "OPPORTUNITY", oppId, "/opportunity/detail?id=" + oppId,
                            createdByUserId, false, userId);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    // ── Opportunity stage changed ─────────────────────────────────────
    public static void notifyOpportunityStageChanged(int oppId, String oppCode, String oppName,
            String newStage, int changedByUserId, List<Integer> notifyUserIds) {
        try {
            NotificationDAO dao = new NotificationDAO();
            String summary = (oppCode != null ? oppCode + ": " : "") + oppName + " → " + newStage;
            for (int userId : notifyUserIds) {
                if (userId != changedByUserId) {
                    dao.createAndSend("Giai đoạn cơ hội thay đổi", summary,
                            "OPPORTUNITY_STAGE_CHANGED", "SYSTEM", "NORMAL",
                            "OPPORTUNITY", oppId, "/opportunity/detail?id=" + oppId,
                            changedByUserId, false, userId);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    // ── Opportunity won ───────────────────────────────────────────────
    public static void notifyOpportunityWon(int oppId, String oppCode, String oppName,
            int changedByUserId, List<Integer> notifyUserIds) {
        try {
            NotificationDAO dao = new NotificationDAO();
            String summary = (oppCode != null ? oppCode + ": " : "") + oppName;
            for (int userId : notifyUserIds) {
                if (userId != changedByUserId) {
                    dao.createAndSend("Cơ hội đã thắng!", summary,
                            "OPPORTUNITY_WON", "SYSTEM", "HIGH",
                            "OPPORTUNITY", oppId, "/opportunity/detail?id=" + oppId,
                            changedByUserId, false, userId);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    // ── Opportunity lost ──────────────────────────────────────────────
    public static void notifyOpportunityLost(int oppId, String oppCode, String oppName,
            int changedByUserId, List<Integer> notifyUserIds) {
        try {
            NotificationDAO dao = new NotificationDAO();
            String summary = (oppCode != null ? oppCode + ": " : "") + oppName;
            for (int userId : notifyUserIds) {
                if (userId != changedByUserId) {
                    dao.createAndSend("Cơ hội đã thua", summary,
                            "OPPORTUNITY_LOST", "SYSTEM", "HIGH",
                            "OPPORTUNITY", oppId, "/opportunity/detail?id=" + oppId,
                            changedByUserId, false, userId);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    // ── Quotation sent ────────────────────────────────────────────────
    public static void notifyQuotationSent(int quotationId, String quotCode, int oppId,
            int sentByUserId, List<Integer> notifyUserIds) {
        try {
            NotificationDAO dao = new NotificationDAO();
            for (int userId : notifyUserIds) {
                if (userId != sentByUserId) {
                    dao.createAndSend("Báo giá đã được gửi", quotCode,
                            "QUOTATION_SENT", "SYSTEM", "NORMAL",
                            "QUOTATION", quotationId, "/quotation/detail?id=" + quotationId,
                            sentByUserId, false, userId);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    // ── Quotation approved ────────────────────────────────────────────
    public static void notifyQuotationApproved(int quotationId, String quotCode,
            int approvedByUserId, List<Integer> notifyUserIds) {
        try {
            NotificationDAO dao = new NotificationDAO();
            for (int userId : notifyUserIds) {
                if (userId != approvedByUserId) {
                    dao.createAndSend("Báo giá đã được duyệt", quotCode,
                            "QUOTATION_APPROVED", "SYSTEM", "NORMAL",
                            "QUOTATION", quotationId, "/quotation/detail?id=" + quotationId,
                            approvedByUserId, false, userId);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    // ── Quotation rejected ────────────────────────────────────────────
    public static void notifyQuotationRejected(int quotationId, String quotCode, String reason,
            int rejectedByUserId, List<Integer> notifyUserIds) {
        try {
            NotificationDAO dao = new NotificationDAO();
            String summary = quotCode + (reason != null ? " - " + reason : "");
            for (int userId : notifyUserIds) {
                if (userId != rejectedByUserId) {
                    dao.createAndSend("Báo giá bị từ chối", summary,
                            "QUOTATION_REJECTED", "SYSTEM", "HIGH",
                            "QUOTATION", quotationId, "/quotation/detail?id=" + quotationId,
                            rejectedByUserId, false, userId);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    // ── Quotation expiring (background scheduler) ─────────────────────
    public static void notifyQuotationExpiring(int quotationId, String quotCode,
            List<Integer> notifyUserIds) {
        try {
            NotificationDAO dao = new NotificationDAO();
            for (int userId : notifyUserIds) {
                dao.createAndSend("Báo giá sắp hết hạn", quotCode,
                        "QUOTATION_EXPIRING", "SYSTEM", "HIGH",
                        "QUOTATION", quotationId, "/quotation/detail?id=" + quotationId,
                        null, true, userId);
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    // ── Task overdue (background scheduler) ───────────────────────────
    public static void notifyTaskOverdue(int taskId, String taskCode, String taskTitle,
            List<Integer> notifyUserIds) {
        try {
            NotificationDAO dao = new NotificationDAO();
            String summary = (taskCode != null ? taskCode + ": " : "") + taskTitle;
            for (int userId : notifyUserIds) {
                dao.createAndSend("Công việc đã quá hạn!", summary,
                        "TASK_OVERDUE", "SYSTEM", "URGENT",
                        "TASK", taskId, "/task/detail?id=" + taskId,
                        null, true, userId);
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    // ── Task reminder (background scheduler) ──────────────────────────
    public static void notifyTaskReminder(int taskId, String taskCode, String taskTitle,
            List<Integer> notifyUserIds) {
        try {
            NotificationDAO dao = new NotificationDAO();
            String summary = (taskCode != null ? taskCode + ": " : "") + taskTitle;
            for (int userId : notifyUserIds) {
                dao.createAndSend("Nhắc nhở: Công việc sắp đến hạn", summary,
                        "TASK_REMINDER", "SYSTEM", "HIGH",
                        "TASK", taskId, "/task/detail?id=" + taskId,
                        null, true, userId);
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    // ══════════════════════════════════════════════════════════════════
    // JSON helpers — dung chung cho moi API servlet cua cac role
    // ══════════════════════════════════════════════════════════════════

    public static void writeUnreadCount(PrintWriter out, int userId) {
        NotificationDAO dao = new NotificationDAO();
        int count = dao.countUnread(userId);
        out.write("{\"unreadCount\":" + count + "}");
    }

    public static void writeNotificationList(PrintWriter out, int userId, int limit) {
        NotificationDAO dao = new NotificationDAO();
        List<Map<String, Object>> rows = dao.getByUserId(userId, 0, limit);
        int unread = dao.countUnread(userId);

        StringBuilder sb = new StringBuilder();
        sb.append("{\"unreadCount\":").append(unread);
        sb.append(",\"notifications\":[");

        for (int i = 0; i < rows.size(); i++) {
            Map<String, Object> row = rows.get(i);
            Notification n = (Notification) row.get("notification");
            NotificationRecipient nr = (NotificationRecipient) row.get("recipient");
            String senderName = (String) row.get("senderName");

            if (i > 0) sb.append(",");
            sb.append("{");
            sb.append("\"id\":").append(n.getNotificationId());
            sb.append(",\"title\":").append(jsonStr(n.getTitle()));
            sb.append(",\"summary\":").append(jsonStr(n.getSummary()));
            sb.append(",\"type\":").append(jsonStr(n.getType()));
            sb.append(",\"priority\":").append(jsonStr(n.getPriority()));
            sb.append(",\"actionUrl\":").append(jsonStr(n.getActionUrl()));
            sb.append(",\"senderName\":").append(jsonStr(senderName));
            sb.append(",\"isRead\":").append(nr.getIsRead());
            sb.append(",\"createdAt\":").append(jsonStr(
                    n.getCreatedAt() != null ? n.getCreatedAt().toString() : null));
            sb.append("}");
        }

        sb.append("]}");
        out.write(sb.toString());
    }

    public static void handleMarkRead(PrintWriter out, int userId, String notificationIdStr) {
        NotificationDAO dao = new NotificationDAO();
        if (notificationIdStr != null) {
            try {
                int notifId = Integer.parseInt(notificationIdStr);
                dao.markAsRead(notifId, userId);
                out.write("{\"success\":true}");
            } catch (NumberFormatException e) {
                out.write("{\"error\":\"invalid id\"}");
            }
        } else {
            out.write("{\"error\":\"missing notificationId\"}");
        }
    }

    public static void handleMarkAllRead(PrintWriter out, int userId) {
        NotificationDAO dao = new NotificationDAO();
        int count = dao.markAllAsRead(userId);
        out.write("{\"success\":true,\"count\":" + count + "}");
    }

    public static void handleDismiss(PrintWriter out, int userId, String notificationIdStr) {
        NotificationDAO dao = new NotificationDAO();
        if (notificationIdStr != null) {
            try {
                int notifId = Integer.parseInt(notificationIdStr);
                dao.dismiss(notifId, userId);
                out.write("{\"success\":true}");
            } catch (NumberFormatException e) {
                out.write("{\"error\":\"invalid id\"}");
            }
        } else {
            out.write("{\"error\":\"missing notificationId\"}");
        }
    }

    // ── Paged list cho trang quan ly thong bao ──────────────────────

    public static void writePagedNotificationList(PrintWriter out, int userId,
            int offset, int limit, boolean unreadOnly) {
        NotificationDAO dao = new NotificationDAO();
        List<Map<String, Object>> rows;
        if (unreadOnly) {
            rows = dao.getUnreadByUserId(userId, limit);
        } else {
            rows = dao.getByUserId(userId, offset, limit);
        }
        int unread = dao.countUnread(userId);
        int total = dao.countTotal(userId);

        StringBuilder sb = new StringBuilder();
        sb.append("{\"unreadCount\":").append(unread);
        sb.append(",\"total\":").append(total);
        sb.append(",\"notifications\":[");

        for (int i = 0; i < rows.size(); i++) {
            Map<String, Object> row = rows.get(i);
            Notification n = (Notification) row.get("notification");
            NotificationRecipient nr = (NotificationRecipient) row.get("recipient");
            String senderName = (String) row.get("senderName");

            if (i > 0) sb.append(",");
            sb.append("{");
            sb.append("\"id\":").append(n.getNotificationId());
            sb.append(",\"title\":").append(jsonStr(n.getTitle()));
            sb.append(",\"summary\":").append(jsonStr(n.getSummary()));
            sb.append(",\"type\":").append(jsonStr(n.getType()));
            sb.append(",\"priority\":").append(jsonStr(n.getPriority()));
            sb.append(",\"actionUrl\":").append(jsonStr(n.getActionUrl()));
            sb.append(",\"senderName\":").append(jsonStr(senderName));
            sb.append(",\"isRead\":").append(nr.getIsRead());
            sb.append(",\"createdAt\":").append(jsonStr(
                    n.getCreatedAt() != null ? n.getCreatedAt().toString() : null));
            sb.append("}");
        }

        sb.append("]}");
        out.write(sb.toString());
    }

    // ── Sent list (notifications created by a specific sender) ───

    public static void writeSentNotificationList(PrintWriter out, int senderId,
            String keyword, int limit) {
        NotificationDAO dao = new NotificationDAO();
        // Use getNotificationList with no type/category/priority filter, just keyword
        List<Map<String, Object>> rows = dao.getNotificationListBySender(senderId, keyword, 0, limit);

        StringBuilder sb = new StringBuilder();
        sb.append("{\"notifications\":[");

        for (int i = 0; i < rows.size(); i++) {
            Map<String, Object> row = rows.get(i);
            Notification n = (Notification) row.get("notification");
            int recipientCount = (Integer) row.get("recipientCount");
            int readCount = (Integer) row.get("readCount");

            if (i > 0) sb.append(",");
            sb.append("{");
            sb.append("\"id\":").append(n.getNotificationId());
            sb.append(",\"code\":").append(jsonStr(n.getNotificationCode()));
            sb.append(",\"title\":").append(jsonStr(n.getTitle()));
            sb.append(",\"summary\":").append(jsonStr(n.getSummary()));
            sb.append(",\"type\":").append(jsonStr(n.getType()));
            sb.append(",\"priority\":").append(jsonStr(n.getPriority()));
            sb.append(",\"recipientCount\":").append(recipientCount);
            sb.append(",\"readCount\":").append(readCount);
            sb.append(",\"createdAt\":").append(jsonStr(
                    n.getCreatedAt() != null ? n.getCreatedAt().toString() : null));
            sb.append("}");
        }

        sb.append("]}");
        out.write(sb.toString());
    }

    // ── Private ──────────────────────────────────────────────────────

    private static String jsonStr(String val) {
        if (val == null) return "null";
        return "\"" + val.replace("\\", "\\\\")
                        .replace("\"", "\\\"")
                        .replace("\n", "\\n")
                        .replace("\r", "\\r")
                        .replace("\t", "\\t") + "\"";
    }
}
