package dao;

import dbConnection.DBContext;
import model.CRMPoolItem;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for the CRM Pool page — a UNION of unassigned Leads and Customers.
 *
 * An item is in the pool when ALL of:
 *   1. Lead:     assigned_to IS NULL
 *      Customer: owner_id   IS NULL
 *   2. No Task exists yet for this item (NOT EXISTS in tasks table)
 *   3. Created by someone in the manager's department
 */
public class CRMPoolDAO extends DBContext {

    private static final String DEPT_SUBQ =
        "(SELECT user_id FROM users WHERE department_id = ?)";

    // ── SQL fragment builders ──────────────────────────────────────────────

    private void appendLeadBranch(StringBuilder sql, List<Object> params,
                                   int deptId, String kw) {
        sql.append("SELECT 'LEAD' AS item_type, l.lead_id AS item_id,")
           .append(" l.full_name, l.phone, l.source_id, l.created_at")
           .append(" FROM leads l")
           .append(" WHERE l.assigned_to IS NULL")
           .append(" AND l.created_by IN ").append(DEPT_SUBQ);
        params.add(deptId);
        sql.append(" AND NOT EXISTS (SELECT 1 FROM tasks t" +
                   " WHERE t.related_type = 'LEAD' AND t.related_id = l.lead_id)");
        if (kw != null) {
            sql.append(" AND (l.full_name LIKE ? OR l.phone LIKE ? OR l.lead_code LIKE ?)");
            params.add(kw); params.add(kw); params.add(kw);
        }
    }

    private void appendCustomerBranch(StringBuilder sql, List<Object> params,
                                       int deptId, String kw) {
        sql.append("SELECT 'CUSTOMER' AS item_type, c.customer_id AS item_id,")
           .append(" c.full_name, c.phone, c.source_id, c.created_at")
           .append(" FROM customers c")
           .append(" WHERE c.owner_id IS NULL")
           .append(" AND c.created_by IN ").append(DEPT_SUBQ);
        params.add(deptId);
        sql.append(" AND NOT EXISTS (SELECT 1 FROM tasks t" +
                   " WHERE t.related_type = 'CUSTOMER' AND t.related_id = c.customer_id)");
        if (kw != null) {
            sql.append(" AND (c.full_name LIKE ? OR c.phone LIKE ? OR c.customer_code LIKE ?)");
            params.add(kw); params.add(kw); params.add(kw);
        }
    }

    // ── Public methods ─────────────────────────────────────────────────────

    /**
     * Fetch one page of CRM Pool items.
     *
     * @param deptId     manager's department
     * @param keyword    searches name / phone / code (null = no filter)
     * @param typeFilter "LEAD" | "CUSTOMER" | null = all
     * @param offset     pagination offset
     * @param pageSize   page size
     */
    public List<CRMPoolItem> getPoolItems(int deptId, String keyword,
                                           String typeFilter, int offset, int pageSize) {
        List<CRMPoolItem> list = new ArrayList<>();
        String kw = (keyword != null && !keyword.trim().isEmpty())
                    ? "%" + keyword.trim() + "%" : null;

        StringBuilder sql  = new StringBuilder();
        List<Object>  params = new ArrayList<>();

        if ("LEAD".equals(typeFilter)) {
            appendLeadBranch(sql, params, deptId, kw);
        } else if ("CUSTOMER".equals(typeFilter)) {
            appendCustomerBranch(sql, params, deptId, kw);
        } else {
            // UNION ALL both
            StringBuilder leadSql = new StringBuilder();
            appendLeadBranch(leadSql, params, deptId, kw);

            StringBuilder custSql = new StringBuilder();
            appendCustomerBranch(custSql, params, deptId, kw);

            sql.append("SELECT * FROM (")
               .append(leadSql).append(" UNION ALL ").append(custSql)
               .append(") pool");
        }

        if (!"LEAD".equals(typeFilter) && !"CUSTOMER".equals(typeFilter)) {
            sql.append(" ORDER BY pool.created_at DESC");
        } else {
            sql.append(" ORDER BY created_at DESC");
        }
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(pageSize);

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) st.setObject(i + 1, params.get(i));
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Timestamp ts = rs.getTimestamp("created_at");
                    list.add(new CRMPoolItem(
                        rs.getString("item_type"),
                        rs.getInt("item_id"),
                        rs.getString("full_name"),
                        rs.getString("phone"),
                        rs.getObject("source_id") != null ? rs.getInt("source_id") : null,
                        ts != null ? ts.toLocalDateTime() : null
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Count total CRM Pool items for pagination.
     */
    public int countPoolItems(int deptId, String keyword, String typeFilter) {
        String kw = (keyword != null && !keyword.trim().isEmpty())
                    ? "%" + keyword.trim() + "%" : null;

        StringBuilder innerSql = new StringBuilder();
        List<Object>  params   = new ArrayList<>();

        if ("LEAD".equals(typeFilter)) {
            innerSql.append("SELECT l.lead_id AS pool_id")
                    .append(" FROM leads l")
                    .append(" WHERE l.assigned_to IS NULL")
                    .append(" AND l.created_by IN ").append(DEPT_SUBQ);
            params.add(deptId);
            innerSql.append(" AND NOT EXISTS (SELECT 1 FROM tasks t" +
                            " WHERE t.related_type = 'LEAD' AND t.related_id = l.lead_id)");
            if (kw != null) {
                innerSql.append(" AND (l.full_name LIKE ? OR l.phone LIKE ? OR l.lead_code LIKE ?)");
                params.add(kw); params.add(kw); params.add(kw);
            }
        } else if ("CUSTOMER".equals(typeFilter)) {
            innerSql.append("SELECT c.customer_id AS pool_id")
                    .append(" FROM customers c")
                    .append(" WHERE c.owner_id IS NULL")
                    .append(" AND c.created_by IN ").append(DEPT_SUBQ);
            params.add(deptId);
            innerSql.append(" AND NOT EXISTS (SELECT 1 FROM tasks t" +
                            " WHERE t.related_type = 'CUSTOMER' AND t.related_id = c.customer_id)");
            if (kw != null) {
                innerSql.append(" AND (c.full_name LIKE ? OR c.phone LIKE ? OR c.customer_code LIKE ?)");
                params.add(kw); params.add(kw); params.add(kw);
            }
        } else {
            // UNION ALL both branches for counting
            innerSql.append("SELECT l.lead_id AS pool_id")
                    .append(" FROM leads l")
                    .append(" WHERE l.assigned_to IS NULL")
                    .append(" AND l.created_by IN ").append(DEPT_SUBQ);
            params.add(deptId);
            innerSql.append(" AND NOT EXISTS (SELECT 1 FROM tasks t" +
                            " WHERE t.related_type = 'LEAD' AND t.related_id = l.lead_id)");
            if (kw != null) {
                innerSql.append(" AND (l.full_name LIKE ? OR l.phone LIKE ? OR l.lead_code LIKE ?)");
                params.add(kw); params.add(kw); params.add(kw);
            }

            innerSql.append(" UNION ALL SELECT c.customer_id AS pool_id")
                    .append(" FROM customers c")
                    .append(" WHERE c.owner_id IS NULL")
                    .append(" AND c.created_by IN ").append(DEPT_SUBQ);
            params.add(deptId);
            innerSql.append(" AND NOT EXISTS (SELECT 1 FROM tasks t" +
                            " WHERE t.related_type = 'CUSTOMER' AND t.related_id = c.customer_id)");
            if (kw != null) {
                innerSql.append(" AND (c.full_name LIKE ? OR c.phone LIKE ? OR c.customer_code LIKE ?)");
                params.add(kw); params.add(kw); params.add(kw);
            }
        }

        String sql = "SELECT COUNT(*) FROM (" + innerSql + ") pool";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) st.setObject(i + 1, params.get(i));
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
