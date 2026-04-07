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
            // TRƯỜNG HỢP 1: Xem lịch sử phiếu báo cáo chi tiết của 1 KH/Lead cụ thể
            int id = Integer.parseInt(idParam);
            
            // Gọi hàm lấy báo cáo linh hoạt (Lead hoặc Customer)
            List<Activity> list = dao.getReportsHistory(id, typeParam);

            request.setAttribute("activities", list);
            request.setAttribute("pageTitle", "Lịch sử phiếu báo cáo - " + typeParam);
            
            // Chỉ định trang nội dung hiển thị trong main_layout
            request.setAttribute("contentPage", "/view/customersuccess/pages/activity_history.jsp");
            
        } else {
            // TRƯỜNG HỢP 2: Nhật ký hoạt động cá nhân theo tháng của nhân viên
            LocalDate now = LocalDate.now();
            int currentMonth = now.getMonthValue();
            int currentYear = now.getYear();
            
            // 1. Lấy danh sách các hoạt động hỗ trợ
            List<Activity> staffLogs = dao.getActivitiesByMonth(user.getUserId(), currentMonth, currentYear);

            // 2. 👉 BỔ SUNG: Lấy thống kê Upsale (Khóa học & Doanh thu)
            java.util.Map<String, Double> upsaleStats = dao.getMonthlyUpsaleStats(user.getUserId(), currentMonth, currentYear);
            request.setAttribute("upsaleCount", upsaleStats.get("upsaleCount").intValue());
            request.setAttribute("totalRevenue", upsaleStats.get("totalRevenue"));

            // 3. Gửi dữ liệu ra View
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
        // Cần import model.Users nếu báo đỏ
        model.Users user = (session != null) ? (model.Users) session.getAttribute("user") : null;

        if (user == null) {
            response.getWriter().write("session_expired");
            return;
        }

        try {
            // 1. Lấy dữ liệu cơ bản
            int relatedId = Integer.parseInt(request.getParameter("id"));
            String relatedType = request.getParameter("type"); 
            String subject = request.getParameter("subject");
            String status = request.getParameter("status"); 

            String description = request.getParameter("description");
            if (description == null) description = "";

            if (relatedType == null || relatedType.isEmpty()) relatedType = "Customer";
            if (status == null || status.isEmpty()) status = "Completed";

            // 2. Bắt lấy mảng khóa học (Upsale) từ Select2 gửi lên
            String[] courseIds = request.getParameterValues("courseIds");

            // 3. Phân công (Mặc định hoặc Chuyển tiếp)
            String assignToParam = request.getParameter("assignTo");
            int performedBy;
            if (assignToParam != null && !assignToParam.isEmpty()) {
                performedBy = Integer.parseInt(assignToParam); 
            } else {
                performedBy = user.getUserId(); 
            }

            // 4. GỌI SIÊU HÀM TRANSACTION XỬ LÝ
            dao.ActivityDAO dao = new dao.ActivityDAO();
            boolean success = dao.processUpsaleTransaction(relatedId, relatedType, subject, description, performedBy, status, courseIds);

            // 5. Trả kết quả về cho AJAX
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(success ? "success" : "error");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error");
        }
    }
}