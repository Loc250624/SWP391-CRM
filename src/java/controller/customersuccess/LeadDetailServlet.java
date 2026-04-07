package controller.customersuccess;

import dao.LeadDAO;
import model.Lead;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; // Thêm thư viện session

@WebServlet(name = "LeadDetailServlet", urlPatterns = {"/support/leads/detail"})
public class LeadDetailServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Kiểm tra đăng nhập (Bảo mật hệ thống)
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 2. Lấy ID từ tham số URL
            String idRaw = request.getParameter("id");
            if (idRaw == null || idRaw.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/support/leads");
                return;
            }

            int id = Integer.parseInt(idRaw);
            LeadDAO dao = new LeadDAO();
            
            // 3. Truy vấn thông tin đầy đủ của Lead
            Lead lead = dao.getLeadById(id);
            
            // 4. Kiểm tra xem Lead có tồn tại không để tránh lỗi NullPointerException
            if (lead != null) {
                request.setAttribute("l", lead); // Gán biến 'l' để dùng trong lead_detail.jsp
                request.setAttribute("pageTitle", "Chi tiết Lead: " + lead.getLeadCode());
                request.setAttribute("contentPage", "/view/customersuccess/pages/lead_detail.jsp");
                
                // 5. Chuyển hướng đến layout chính để render
                request.getRequestDispatcher("/view/customersuccess/pages/main_layout.jsp").forward(request, response);
            } else {
                // Nếu ID không tồn tại trong DB, quay về trang danh sách
                response.sendRedirect(request.getContextPath() + "/support/leads");
            }
            
        } catch (Exception e) {
            // Xử lý khi ID không phải là số hoặc lỗi SQL
            response.sendRedirect(request.getContextPath() + "/support/leads");
        }
    }
}