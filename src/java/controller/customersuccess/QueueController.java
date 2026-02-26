package controller.customersuccess;

import dao.ActivityDAO;
import model.Activity;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Controller xử lý Hàng chờ hỗ trợ khách hàng
 * Hỗ trợ xem danh sách 'Pending' và hoàn thiện báo cáo
 */
@WebServlet(name = "QueueController", urlPatterns = {"/support/queue", "/support/queue/complete"})
public class QueueController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        ActivityDAO dao = new ActivityDAO();
        
        // Lấy danh sách các phiếu đang ở trạng thái 'Pending'
        List<Activity> pendingList = dao.getPendingActivities();
        
        request.setAttribute("pendingList", pendingList);
        request.setAttribute("pageTitle", "Hàng chờ");
        request.setAttribute("contentPage", "/view/customersuccess/pages/queue_list.jsp");
        
        request.getRequestDispatcher("/view/customersuccess/pages/main_layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // 1. Lấy ID, Tiêu đề mới và Nội dung chi tiết từ AJAX
            int id = Integer.parseInt(request.getParameter("id"));
            String subject = request.getParameter("subject"); // THÊM MỚI: Nhận tiêu đề đã sửa
            String desc = request.getParameter("description");
            
            ActivityDAO dao = new ActivityDAO();
            
            // 2. CẬP NHẬT: Gọi hàm xử lý cả Tiêu đề, Nội dung và chuyển status sang 'Completed'
            // Lưu ý: Đảm bảo bạn đã đổi tên hoặc cập nhật hàm này trong ActivityDAO
            boolean isUpdated = dao.updateAndCompleteActivity(id, subject, desc);
            
            response.setContentType("text/plain");
            if (isUpdated) {
                response.getWriter().write("success");
            } else {
                response.getWriter().write("error");
            }
        } catch (NumberFormatException e) {
            response.getWriter().write("error");
        }
    }
}