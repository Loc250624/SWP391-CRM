package controller.customersuccess;

import dao.ActivityDAO;
import model.Activity;
import model.Users;
import java.io.IOException;
import java.time.LocalDate; // Thêm import này
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "ActivityController", urlPatterns = {"/support/activities"})
public class ActivityController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        ActivityDAO dao = new ActivityDAO();
        String customerIdParam = request.getParameter("customerId");

        if (customerIdParam != null && !customerIdParam.isEmpty()) {
            // TRƯỜNG HỢP 1: Xem lịch sử chi tiết của 1 khách hàng cụ thể
            int customerId = Integer.parseInt(customerIdParam);
            List<Activity> list = dao.getActivitiesByCustomerId(customerId);
            request.setAttribute("activities", list);
            request.setAttribute("pageTitle", "Chi tiết lịch sử chăm sóc");
            request.setAttribute("contentPage", "/view/customersuccess/pages/activity_history.jsp");
        } else {
            // TRƯỜNG HỢP 2: Xem Nhật ký công việc theo THÁNG hiện tại
            LocalDate now = LocalDate.now();
            int currentMonth = now.getMonthValue();
            int currentYear = now.getYear();

            // Gọi hàm lọc theo tháng trong DAO
            List<Activity> staffLogs = dao.getActivitiesByMonth(user.getUserId(), currentMonth, currentYear);

            request.setAttribute("activities", staffLogs);
            request.setAttribute("month", currentMonth);
            request.setAttribute("year", currentYear);
            request.setAttribute("pageTitle", "Nhật ký hoạt động của tôi");
            request.setAttribute("contentPage", "/view/customersuccess/pages/activity_log.jsp");
        }

        request.getRequestDispatcher("/view/customersuccess/pages/main_layout.jsp").forward(request, response);
    }

    @Override
    // Vị trí: controller.customersuccess/ActivityController.java
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users user = (Users) session.getAttribute("user");

        try {
            int customerId = Integer.parseInt(request.getParameter("customerId"));
            String subject = request.getParameter("subject");
            String description = request.getParameter("description");

            // LẤY THÊM TRẠNG THÁI TỪ MODAL GỬI VỀ
            String status = request.getParameter("status");
            if (status == null || status.isEmpty()) {
                status = "Completed"; // Mặc định là hoàn thành nếu không có giá trị
            }

            ActivityDAO dao = new ActivityDAO();
            // CẬP NHẬT GỌI HÀM VỚI 5 THAM SỐ (Hết lỗi gạch đỏ)
            boolean success = dao.insertActivity(customerId, subject, description, user.getUserId(), status);

            response.setContentType("text/plain");
            response.getWriter().write(success ? "success" : "error");
        } catch (Exception e) {
            response.getWriter().write("error");
        }
    }
}
