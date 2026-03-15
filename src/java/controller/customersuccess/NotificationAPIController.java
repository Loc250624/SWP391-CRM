package controller.customersuccess;

import dao.ActivityDAO;
import model.Users;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "NotificationAPIController", urlPatterns = {"/support/api/notifications"})
public class NotificationAPIController extends HttpServlet {

    // Trả về số lượng chấm đỏ (Số phiếu chưa đọc)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        if (user != null) {
            int count = new ActivityDAO().countUnreadAssignedTickets(user.getUserId());
            response.getWriter().write(String.valueOf(count));
        }
    }

    // Xử lý tắt chấm đỏ khi click vào phiếu
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("markRead".equals(action)) {
            int activityId = Integer.parseInt(request.getParameter("id"));
            new ActivityDAO().markActivityAsRead(activityId);
            response.getWriter().write("success");
        }
    }
}