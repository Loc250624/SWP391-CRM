package controller.customersuccess;

import dao.ActivityDAO;
import model.Activity;
import model.Users;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "ReceiveController", urlPatterns = {"/support/receive"})
public class ReceiveController extends HttpServlet {

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
        
        // 1. Lấy danh sách phiếu Pending do người khác chuyển cho user hiện tại
        List<Activity> myTickets = dao.getMyAssignedTickets(user.getUserId());

        // 2. Truyền dữ liệu ra giao diện (Dùng biến pendingList để tái sử dụng file queue_list.jsp)
        request.setAttribute("pendingList", myTickets);
        request.setAttribute("pageTitle", "Phiếu hỗ trợ được phân công");
        
        // Tái sử dụng file giao diện hàng chờ để hiển thị
        request.setAttribute("contentPage", "/view/customersuccess/pages/queue_list.jsp");

        request.getRequestDispatcher("/view/customersuccess/pages/main_layout.jsp").forward(request, response);
    }
}