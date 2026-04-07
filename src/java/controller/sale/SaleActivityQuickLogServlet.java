package controller.sale;

import dao.ActivityDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.SessionHelper;

@WebServlet(name = "SaleActivityQuickLogServlet", urlPatterns = {"/sale/activity/quicklog"})
public class SaleActivityQuickLogServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        Integer currentUserId = SessionHelper.getLoggedInUserId(request);
        if (currentUserId == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"success\":false,\"message\":\"Chua dang nhap\"}");
            return;
        }

        String activityType = request.getParameter("activityType");
        String relatedType = request.getParameter("relatedType");
        String relatedIdStr = request.getParameter("relatedId");
        String subject = request.getParameter("subject");
        String description = request.getParameter("description");
        String status = request.getParameter("status");

        if (subject == null || subject.trim().isEmpty() || activityType == null || activityType.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\":false,\"message\":\"Vui long dien tieu de va loai hoat dong\"}");
            return;
        }

        if (status == null || status.trim().isEmpty()) {
            status = "Completed";
        }

        Integer relatedId = null;
        if (relatedIdStr != null && !relatedIdStr.isEmpty()) {
            try { relatedId = Integer.parseInt(relatedIdStr); } catch (NumberFormatException e) {}
        }

        ActivityDAO actDAO = new ActivityDAO();
        Timestamp now = Timestamp.valueOf(LocalDateTime.now());

        int newId = actDAO.insertSaleActivity(activityType, relatedType, relatedId,
                subject.trim(), description, now, null, null, null,
                currentUserId, status);

        if (newId > 0) {
            out.print("{\"success\":true,\"activityId\":" + newId + ",\"message\":\"Ghi nhan hoat dong thanh cong\"}");
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\":false,\"message\":\"Loi khi luu hoat dong\"}");
        }
    }
}
