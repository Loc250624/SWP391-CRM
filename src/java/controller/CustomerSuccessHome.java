package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// URL Pattern mình vẫn giữ là "/support/dashboard" để không phải sửa lại code ở LoginServlet
// Nếu bạn muốn đổi URL, nhớ vào LoginServlet sửa lại dòng response.sendRedirect luôn nhé.
@WebServlet(name = "CustomerSuccessHome", urlPatterns = {"/support/dashboard"})
public class CustomerSuccessHome extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Kiểm tra bảo mật: Nếu chưa đăng nhập thì đá về trang Login
        HttpSession session = request.getSession();
        if (session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 2. Forward (Chuyển tiếp) yêu cầu đến file JSP giao diện
        // Lưu ý: Đường dẫn này phải trỏ đúng nơi bạn đặt file home.jsp
        // Nếu bạn đã làm bước bảo mật (chuyển vào WEB-INF) thì sửa đường dẫn thêm /WEB-INF/ ở đầu
        request.getRequestDispatcher("/view/customersuccess/home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu sau này có xử lý form ở trang home thì viết code ở đây
        doGet(request, response);
    }
}