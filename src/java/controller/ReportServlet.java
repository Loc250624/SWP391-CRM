package controller;

import dao.TicketDAO;
import model.Ticket;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ReportServlet", urlPatterns = {"/report"})
public class ReportServlet extends HttpServlet {

    // 1. GET: Hiển thị form (file jsp)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("view/customersuccess/report.jsp").forward(request, response);
    }

    // 2. POST: Nhận dữ liệu từ form -> Gọi DAO -> Lưu
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 1. Kiểm tra đăng nhập
        HttpSession session = request.getSession();
        Integer customerId = (Integer) session.getAttribute("customerId");

        if (customerId == null) {
            response.sendRedirect("home");
            return;
        }

        // 2. Lấy dữ liệu
        String title = request.getParameter("title");
        String desc = request.getParameter("description");

        // 3. Gọi DAO lưu
        Ticket ticket = new Ticket(customerId, title, desc, 1);
        TicketDAO dao = new TicketDAO();
        boolean success = dao.createTicket(ticket);

        if (success) {
            // --- THAY ĐỔI Ở ĐÂY ---
            // Gắn thông báo vào Request (chỉ tồn tại trong lần tải trang này)
            request.setAttribute("successMessage", "Gửi báo cáo thành công!");

            // Forward (Chuyển tiếp) lại chính trang report.jsp để hiển thị thông báo
            request.getRequestDispatcher("view/customersuccess/report.jsp").forward(request, response);
        } else {
            response.getWriter().print("Lỗi: Không lưu được ticket!");
        }
    }
}
