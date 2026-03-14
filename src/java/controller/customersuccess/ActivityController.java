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
        
        // ĐỒNG BỘ: Nhận id và type (Lead/Customer) từ URL để lọc báo cáo
        String idParam = request.getParameter("id");
        String typeParam = request.getParameter("type");

        if (idParam != null && typeParam != null) {
            // TRƯỜNG HỢP 1: Xem lịch sử phiếu báo cáo chi tiết
            int id = Integer.parseInt(idParam);
            
            // Gọi hàm lấy báo cáo linh hoạt (Lead hoặc Customer)
            List<Activity> list = dao.getReportsHistory(id, typeParam);

            request.setAttribute("activities", list);
            request.setAttribute("pageTitle", "Lịch sử phiếu báo cáo - " + typeParam);
            
            // Chỉ định trang nội dung hiển thị trong main_layout
            request.setAttribute("contentPage", "/view/customersuccess/pages/activity_history.jsp");
            
        } else {
            // TRƯỜNG HỢP 2: Nhật ký hoạt động cá nhân theo tháng
            LocalDate now = LocalDate.now();
            List<Activity> staffLogs = dao.getActivitiesByMonth(user.getUserId(), now.getMonthValue(), now.getYear());

            request.setAttribute("activities", staffLogs);
            request.setAttribute("month", now.getMonthValue());
            request.setAttribute("year", now.getYear());
            request.setAttribute("pageTitle", "Nhật ký hoạt động của tôi");
            request.setAttribute("contentPage", "/view/customersuccess/pages/activity_log.jsp");
        }

        request.getRequestDispatcher("/view/customersuccess/pages/main_layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;

        if (user == null) {
            response.getWriter().write("session_expired");
            return;
        }

        try {
            // 1. Lấy dữ liệu cơ bản từ các Modal
            int relatedId = Integer.parseInt(request.getParameter("id"));
            String relatedType = request.getParameter("type"); // Xác định phiếu cho Lead hay Customer
            String subject = request.getParameter("subject");
            String status = request.getParameter("status"); // 'Completed' (Lưu) hoặc 'Pending' (Hàng chờ)

            // Lấy nội dung chi tiết (Modal chuyển tiếp có thể gửi null, nên cần bắt lỗi)
            String description = request.getParameter("description");
            if (description == null) description = "";

            // Kiểm tra mặc định nếu thiếu tham số
            if (relatedType == null || relatedType.isEmpty()) relatedType = "Customer";
            if (status == null || status.isEmpty()) status = "Completed";

            // 2. XỬ LÝ CHUYỂN TIẾP: Xác định người sẽ nhận phiếu hỗ trợ này
            String assignToParam = request.getParameter("assignTo");
            int performedBy;
            if (assignToParam != null && !assignToParam.isEmpty()) {
                // Nếu có tham số assignTo (từ Modal Chuyển tiếp), giao việc cho nhân viên phụ trách đó
                performedBy = Integer.parseInt(assignToParam); 
            } else {
                // Nếu không có (từ Modal Tạo phiếu bình thường), tự giao cho chính mình
                performedBy = user.getUserId(); 
            }

            ActivityDAO dao = new ActivityDAO();

            // 3. Thực hiện lưu vào DB với biến performedBy linh hoạt
            boolean success = dao.insertActivity(relatedId, relatedType, subject, description, performedBy, status);

            // 4. Trả về kết quả cho AJAX để hiện thông báo
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(success ? "success" : "error");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error");
        }
    }
}