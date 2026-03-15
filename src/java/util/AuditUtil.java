package util;

import dao.AuditLogDAO;
import model.AuditLog;
import jakarta.servlet.http.HttpServletRequest;

/**
 * Utility class for audit logging. Call one-liners from any servlet.
 *
 * Usage examples:
 *   AuditUtil.log(request, userId, "Create", "Customer", customerId, null, "fullName=Nguyen Van A, email=a@b.com");
 *   AuditUtil.log(request, userId, "Update", "Lead", leadId, "status=New", "status=Contacted");
 *   AuditUtil.log(request, userId, "Delete", "Quotation", quotId, "code=Q-001", null);
 *   AuditUtil.logLogin(request, userId);
 */
public class AuditUtil {

    /**
     * Log an audit entry.
     */
    public static void log(HttpServletRequest request, Integer userId,
            String action, String entityType, Integer entityId,
            String oldValues, String newValues) {
        try {
            AuditLog entry = new AuditLog();
            entry.setUserId(userId);
            entry.setAction(action);
            entry.setEntityType(entityType);
            entry.setEntityId(entityId);
            entry.setOldValues(oldValues);
            entry.setNewValues(newValues);
            if (request != null) {
                entry.setIpAddress(getClientIp(request));
                entry.setUserAgent(truncate(request.getHeader("User-Agent"), 500));
            }
            new AuditLogDAO().insert(entry);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Log without request context (background tasks, schedulers).
     */
    public static void log(Integer userId, String action, String entityType,
            Integer entityId, String oldValues, String newValues) {
        log(null, userId, action, entityType, entityId, oldValues, newValues);
    }

    // ── Shortcut methods ──

    public static void logCreate(HttpServletRequest request, Integer userId,
            String entityType, Integer entityId, String newValues) {
        log(request, userId, "Create", entityType, entityId, null, newValues);
    }

    public static void logUpdate(HttpServletRequest request, Integer userId,
            String entityType, Integer entityId, String oldValues, String newValues) {
        log(request, userId, "Update", entityType, entityId, oldValues, newValues);
    }

    public static void logDelete(HttpServletRequest request, Integer userId,
            String entityType, Integer entityId, String oldValues) {
        log(request, userId, "Delete", entityType, entityId, oldValues, null);
    }

    public static void logLogin(HttpServletRequest request, Integer userId) {
        log(request, userId, "Login", "User", userId, null, null);
    }

    public static void logLogout(HttpServletRequest request, Integer userId) {
        log(request, userId, "Logout", "User", userId, null, null);
    }

    // ── Helpers ──

    private static String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("X-Real-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        // Take first IP if multiple (X-Forwarded-For can be comma-separated)
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        return ip;
    }

    private static String truncate(String s, int maxLen) {
        if (s == null) return null;
        return s.length() > maxLen ? s.substring(0, maxLen) : s;
    }
}
