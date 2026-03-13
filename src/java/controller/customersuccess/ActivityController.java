package controller.customersuccess;

import dao.ActivityDAO;
import model.Activity;
import model.Users;
import java.io.IOException;
import java.time.LocalDate;
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
            // Lưu ý: DAO của bạn hiện đã lọc AND status = 'Completed' trong hàm này
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

            // Chỉ hiển thị các báo cáo đã Hoàn thành trong nhật ký
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        // Lấy thông tin nhân viên từ session
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;

        if (user == null) {
            response.getWriter().write("session_expired");
            return;
        }

        try {
            // 1. Lấy dữ liệu định danh từ Modal
            int relatedId = Integer.parseInt(request.getParameter("customerId"));
            String subject = request.getParameter("subject");
            String description = request.getParameter("description");

            // 2. LẤY LOẠI ĐỐI TƯỢNG (Mới): Để biết là Customer hay Lead
            String relatedType = request.getParameter("relatedType");
            if (relatedType == null || relatedType.isEmpty()) {
                relatedType = "Customer"; // Mặc định nếu trang gọi không truyền (ví dụ trang List Customer cũ)
            }

            // 3. LẤY TRẠNG THÁI (Mấu chốt để phân loại Hàng chờ hay Lịch sử)
            String status = request.getParameter("status");
            if (status == null || status.isEmpty()) {
                status = "Completed"; // Mặc định là Hoàn thành
            }

            ActivityDAO dao = new ActivityDAO();

            // 4. THỰC THI LƯU: Truyền đủ 6 tham số vào DAO để xử lý chính xác
            boolean success = dao.insertActivity(relatedId, relatedType, subject, description, user.getUserId(), status);

            // 5. TRẢ VỀ KẾT QUẢ CHO AJAX
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(success ? "success" : "error");

        } catch (NumberFormatException e) {
            response.getWriter().write("invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error");
        }
    }
}
