package controller.manager;

import dao.CustomerDAO;
import dao.LeadDAO;
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
import model.Users;

/**
 * GET /manager/task/ajax/related-info
 * Params: type (LEAD | CUSTOMER), id (int)
 * Returns JSON: fullName, phone, email, status, rating/segment, assignedToName
 */
@WebServlet(name = "ManagerTaskRelatedInfoAjaxServlet", urlPatterns = {"/manager/task/ajax/related-info"})
public class ManagerTaskRelatedInfoAjaxServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            out.print("{\"success\":false,\"message\":\"Phiên đăng nhập hết hạn\"}");
            return;
        }

        Users currentUser = (Users) session.getAttribute("user");
        UserDAO userDAO = new UserDAO();
        String roleCode = userDAO.getRoleCodeByUserId(currentUser.getUserId());

        if (!"MANAGER".equals(roleCode)) {
            out.print("{\"success\":false,\"message\":\"Không có quyền\"}");
            return;
        }

        String type = request.getParameter("type");
        String idStr = request.getParameter("id");

        if (type == null || idStr == null) {
            out.print("{\"success\":false,\"message\":\"Thiếu tham số\"}");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException e) {
            out.print("{\"success\":false,\"message\":\"ID không hợp lệ\"}");
            return;
        }

        if ("LEAD".equalsIgnoreCase(type)) {
            Lead lead = new LeadDAO().getLeadById(id);
            if (lead == null) {
                out.print("{\"success\":false,\"message\":\"Không tìm thấy Lead\"}");
                return;
            }
            String assignedToName = "";
            if (lead.assignedTo != null) {
                Users u = userDAO.getUserById(lead.assignedTo);
                if (u != null) {
                    String fn = u.getFirstName() != null ? u.getFirstName() : "";
                    String ln = u.getLastName()  != null ? u.getLastName()  : "";
                    assignedToName = (fn + " " + ln).trim();
                }
            }
            out.print("{\"success\":true," +
                "\"fullName\":" + jsonStr(lead.fullName) + "," +
                "\"phone\":" + jsonStr(lead.phone) + "," +
                "\"email\":" + jsonStr(lead.email) + "," +
                "\"status\":" + jsonStr(lead.status) + "," +
                "\"rating\":" + jsonStr(lead.rating) + "," +
                "\"interests\":" + jsonStr(lead.interests) + "," +
                "\"notes\":" + jsonStr(lead.notes) + "," +
                "\"assignedToName\":" + jsonStr(assignedToName) + "}");

        } else if ("CUSTOMER".equalsIgnoreCase(type)) {
            Customer cust = new CustomerDAO().getCustomerById(id);
            if (cust == null) {
                out.print("{\"success\":false,\"message\":\"Không tìm thấy Khách hàng\"}");
                return;
            }
            String ownerName = "";
            if (cust.ownerId != null) {
                Users u = userDAO.getUserById(cust.ownerId);
                if (u != null) {
                    String fn = u.getFirstName() != null ? u.getFirstName() : "";
                    String ln = u.getLastName()  != null ? u.getLastName()  : "";
                    ownerName = (fn + " " + ln).trim();
                }
            }
            out.print("{\"success\":true," +
                "\"fullName\":" + jsonStr(cust.fullName) + "," +
                "\"phone\":" + jsonStr(cust.phone) + "," +
                "\"email\":" + jsonStr(cust.email) + "," +
                "\"status\":" + jsonStr(cust.status) + "," +
                "\"segment\":" + jsonStr(cust.customerSegment) + "," +
                "\"totalSpent\":" + (cust.totalSpent != null ? cust.totalSpent : 0) + "," +
                "\"notes\":" + jsonStr(cust.notes) + "," +
                "\"assignedToName\":" + jsonStr(ownerName) + "}");
        } else {
            out.print("{\"success\":false,\"message\":\"Loại đối tượng không hợp lệ\"}");
        }
    }

    private String jsonStr(String s) {
        if (s == null) return "\"\"";
        return "\"" + s.replace("\\", "\\\\").replace("\"", "\\\"")
                       .replace("\n", "\\n").replace("\r", "\\r") + "\"";
    }
}
