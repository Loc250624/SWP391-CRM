package controller.manager;

import dao.CustomerDAO;
import dao.LeadDAO;
import dao.LeadSourceDAO;
import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Customer;
import model.Lead;
import model.LeadSource;
import model.Users;

/**
 * GET /manager/task/object-info?type=LEAD|CUSTOMER&id={objectId}
 *
 * Returns JSON with full Lead or Customer details for AJAX auto-fill
 * in the task creation form. Only accessible by MANAGER role.
 *
 * Lead response fields:
 *   type, fullName, phone, email, sourceName, assignedUserName,
 *   interests, notes, rating, status
 *
 * Customer response fields:
 *   type, fullName, phone, email, sourceName, assignedUserName,
 *   customerSegment, purchasedCourses, notes, status
 */
@WebServlet(name = "ManagerObjectInfoServlet", urlPatterns = {"/manager/task/object-info"})
public class ManagerObjectInfoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        // ── Auth check ──────────────────────────────────────────────────────
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"error\":\"Unauthorized\"}");
            return;
        }

        Users currentUser = (Users) session.getAttribute("user");
        UserDAO userDAO = new UserDAO();

        if (!"MANAGER".equals(userDAO.getRoleCodeByUserId(currentUser.getUserId()))) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            out.print("{\"error\":\"Forbidden\"}");
            return;
        }

        // ── Validate params ─────────────────────────────────────────────────
        String type    = request.getParameter("type");
        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Missing id\"}");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idParam.trim());
            if (id <= 0) throw new NumberFormatException("non-positive");
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Invalid id\"}");
            return;
        }

        // ── Fetch and serialize ─────────────────────────────────────────────
        if ("LEAD".equals(type)) {
            Lead lead = new LeadDAO().getLeadById(id);
            if (lead == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"error\":\"Lead not found\"}");
                return;
            }

            String sourceName    = resolveSourceName(lead.getSourceId());
            String assignedName  = resolveUserName(lead.getAssignedTo(), userDAO);

            out.print("{");
            out.print("\"type\":\"LEAD\",");
            out.print("\"fullName\":\""       + esc(lead.getFullName())  + "\",");
            out.print("\"phone\":\""          + esc(lead.getPhone())     + "\",");
            out.print("\"email\":\""          + esc(lead.getEmail())     + "\",");
            out.print("\"sourceName\":\""     + esc(sourceName)          + "\",");
            out.print("\"assignedUserName\":\"" + esc(assignedName)      + "\",");
            out.print("\"interests\":\""      + esc(lead.getInterests()) + "\",");
            out.print("\"notes\":\""          + esc(lead.getNotes())     + "\",");
            out.print("\"rating\":\""         + esc(lead.getRating())    + "\",");
            out.print("\"status\":\""         + esc(lead.getStatus())    + "\"");
            out.print("}");

        } else if ("CUSTOMER".equals(type)) {
            Customer cust = new CustomerDAO().getCustomerById(id);
            if (cust == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"error\":\"Customer not found\"}");
                return;
            }

            String sourceName = resolveSourceName(cust.getSourceId());
            String ownerName  = resolveUserName(cust.getOwnerId(), userDAO);

            out.print("{");
            out.print("\"type\":\"CUSTOMER\",");
            out.print("\"fullName\":\""        + esc(cust.getFullName())         + "\",");
            out.print("\"phone\":\""           + esc(cust.getPhone())            + "\",");
            out.print("\"email\":\""           + esc(cust.getEmail())            + "\",");
            out.print("\"sourceName\":\""      + esc(sourceName)                 + "\",");
            out.print("\"assignedUserName\":\"" + esc(ownerName)                 + "\",");
            out.print("\"customerSegment\":\"" + esc(cust.getCustomerSegment())  + "\",");
            out.print("\"purchasedCourses\":\"" + esc(cust.getPurchasedCourses())+ "\",");
            out.print("\"notes\":\""           + esc(cust.getNotes())            + "\",");
            out.print("\"status\":\""          + esc(cust.getStatus())           + "\"");
            out.print("}");

        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Invalid type. Use LEAD or CUSTOMER\"}");
        }
    }

    // ── Helpers ─────────────────────────────────────────────────────────────

    private String resolveSourceName(Integer sourceId) {
        if (sourceId == null) return "";
        LeadSource src = new LeadSourceDAO().getSourceById(sourceId);
        return src != null ? src.getSourceName() : "";
    }

    private String resolveUserName(Integer userId, UserDAO userDAO) {
        if (userId == null) return "";
        Users u = userDAO.getUserById(userId);
        if (u == null) return "";
        String name = (u.getFirstName() != null ? u.getFirstName() : "")
                    + " "
                    + (u.getLastName()  != null ? u.getLastName()  : "");
        return name.trim();
    }

    /** Escapes characters unsafe inside a JSON string value. */
    private String esc(String v) {
        if (v == null) return "";
        return v.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n")
                .replace("\t", "\\t");
    }
}
