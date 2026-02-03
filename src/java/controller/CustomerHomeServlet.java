package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// Đường dẫn truy cập trên trình duyệt sẽ là: /home
@WebServlet(name = "CustomerHomeServlet", urlPatterns = {"/customerhome"})
public class CustomerHomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Xử lý Session (Giả lập người dùng đã đăng nhập)
        HttpSession session = request.getSession();
        
        // Nếu chưa có thông tin trong Session, ta tự tạo (giả lập ID = 1)
        if (session.getAttribute("customerId") == null) {
            session.setAttribute("customerName", "Alex"); // Tên hiển thị trên Header
            session.setAttribute("customerId", 1);        // ID dùng để lưu vào Database
        }

        // 2. Gửi dữ liệu cần thiết sang file JSP
        request.setAttribute("pageTitle", "LearnSphere - Trang chủ");

        // 3. Chuyển hướng đến file giao diện (View)
        // LƯU Ý: Đường dẫn này phải CHÍNH XÁC với thư mục bạn đã tạo trong 'Web Pages'
        request.getRequestDispatcher("view/customersuccess/home.jsp").forward(request, response);
    }

    // Hàm doPost để trống vì trang chủ thường chỉ dùng GET để xem
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
}