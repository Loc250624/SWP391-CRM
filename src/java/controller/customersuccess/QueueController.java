package controller.customersuccess;

import dao.ActivityDAO;
import model.Activity;
import model.Users; // Bổ sung import Users
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; // Bổ sung import HttpSession

/**
 * Controller xử lý Hàng chờ hỗ trợ cho cả Khách hàng và Leads.
 * Đồng bộ danh sách 'Pending' để nhân viên quản lý tập trung.
 */
@WebServlet(name = "QueueController", urlPatterns = {"/support/queue", "/support/queue/complete"})
public class QueueController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. LẤY THÔNG TIN NHÂN VIÊN ĐANG ĐĂNG NHẬP
        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;

        // Nếu chưa đăng nhập thì đẩy về trang login
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        ActivityDAO dao = new ActivityDAO();
        
        // 2. TRUYỀN ID NHÂN VIÊN VÀO HÀM ĐỂ LỌC DỮ LIỆU
        // Lấy danh sách phiếu 'Pending' của Khách hàng
        List<Activity> pendingList = dao.getPendingActivities(user.getUserId());
        
        // Gộp thêm danh sách phiếu 'Pending' của Leads
        List<Activity> pendingLeads = dao.getPendingLeads(user.getUserId());
        if (pendingLeads != null) {
            pendingList.addAll(pendingLeads);
        }
        
        // 3. Sắp xếp hoặc gửi dữ liệu ra View
        request.setAttribute("pendingList", pendingList);
        request.setAttribute("pageTitle", "Hàng chờ hỗ trợ");
        
        // ĐỒNG BỘ LAYOUT
        request.setAttribute("contentPage", "/view/customersuccess/pages/queue_list.jsp");
        
        request.getRequestDispatcher("/view/customersuccess/pages/main_layout.jsp").forward(request, response);
    }

   @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        if (user == null) {
            response.getWriter().write("error");
            return;
        }

        try {
            // Lấy dữ liệu từ Form (Bao gồm cả Upsale)
            int id = Integer.parseInt(request.getParameter("id"));
            String subject = request.getParameter("subject"); 
            String desc = request.getParameter("description");
            String[] courseIds = request.getParameterValues("courseIds");
            
            ActivityDAO dao = new ActivityDAO();
            
            // Gọi "Siêu hàm" Transaction mới
            boolean isUpdated = dao.completeActivityWithUpsaleTransaction(id, subject, desc, courseIds, user.getUserId());
            
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
            if (isUpdated) {
                response.getWriter().write("success");
            } else {
                response.getWriter().write("error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error");
        }
    }
}