package controller;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Đường dẫn này ĐÚNG vì login.jsp nằm ngay trong view
        request.getRequestDispatcher("view/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String pass = request.getParameter("password");

        UserDAO dao = new UserDAO();
        User user = dao.login(email, pass);

        if (user == null) {
            request.setAttribute("error", "Email hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("view/login.jsp").forward(request, response);
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("account", user);

            String role = user.getRoleCode(); 
            
            // --- SỬA LẠI ĐƯỜNG DẪN Ở ĐÂY CHO KHỚP VỚI ẢNH ---
            switch (role) {
                case "ADMIN":
                    // Phải thêm "view/" đằng trước
                    response.sendRedirect("view/admin/dashboard.jsp"); 
                    break;
                    
                case "SUPPORT": 
                    // Cái này bạn làm đúng rồi
                    response.sendRedirect("support/dashboard");
                    break;
                    
                case "SALES":
                    // Phải thêm "view/" đằng trước
                    response.sendRedirect("view/sales/home.jsp");
                    break;
                    
                case "MARKETING":
                    // Thêm case cho Marketing (dựa theo ảnh)
                    response.sendRedirect("view/marketing/dashboard.jsp");
                    break;
                    
                case "MANAGER":
                    // Thêm case cho Manager (dựa theo ảnh)
                    response.sendRedirect("view/manager/report.jsp");
                    break;
                    
                default:
                    response.sendRedirect("index.html");
            }
        }
    }
}