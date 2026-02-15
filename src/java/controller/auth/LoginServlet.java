package controller.auth;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Users;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
        } else {
            request.getRequestDispatcher("view/auth/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO userDAO = new UserDAO();
        Users user = userDAO.login(email, password);

        if (user != null) {
        
            String roleCode = userDAO.getRoleCodeByUserId(user.getUserId());
            
            // 2. Lưu thông tin vào Session để quản lý đăng nhập
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("role", roleCode);

            // 3. Điều hướng dựa trên danh sách Role
            if (roleCode == null) {
                response.sendRedirect(request.getContextPath() + "/home");
            } else {
                switch (roleCode.toUpperCase()) {
                    case "ADMIN":
                        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                        break;
                    case "MARKETING":
                        response.sendRedirect(request.getContextPath() + "/marketing/dashboard");
                        break;
                    case "SALES":
                        response.sendRedirect(request.getContextPath() + "/sale/dashboard");
                        break;
                    case "SUPPORT":
                        response.sendRedirect(request.getContextPath() + "/support/dashboard");
                        break;
                    case "MANAGER":
                        response.sendRedirect(request.getContextPath() + "/manager/dashboard");
                        break;
                    default:
                        response.sendRedirect(request.getContextPath() + "/home");
                        break;
                }
            }
        } else {
         
            request.setAttribute("error", "Email hoặc mật khẩu không đúng.");
            request.getRequestDispatcher("view/auth/login.jsp").forward(request, response);
        }
    }
}
