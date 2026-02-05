package controller;

import dao.TicketDAO;
import model.Ticket;
import model.TicketResponse;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "CustomerSuccessServlet", urlPatterns = {"/customer-success"})
public class CustomerSuccessServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        TicketDAO dao = new TicketDAO();

        // --- 1. XỬ LÝ TAB (Cần xử lý / Lịch sử) ---
        String viewType = request.getParameter("view");

        // Mặc định nếu không có tham số thì là 'pending'
        if (viewType == null || viewType.isEmpty()) {
            viewType = "pending";
        }

        List<Ticket> list;
        if (viewType.equals("history")) {
            // SỬA: Truyền số 3 vào đây (3 là Status Closed)
            list = dao.getTicketsByStatus(3);
        } else {
            // Truyền số 1 vào đây (1 là Pending - DAO sẽ tự lấy cả 1 và 2)
            list = dao.getTicketsByStatus(1);
        }

        request.setAttribute("ticketList", list);
        request.setAttribute("currentView", viewType); // Gửi biến này về JSP để tô màu nút Tab

        // --- 2. XỬ LÝ CHI TIẾT TICKET (Nếu có chọn) ---
        String idRaw = request.getParameter("id");
        if (idRaw != null) {
            try {
                int id = Integer.parseInt(idRaw);

                // Lấy thông tin ticket
                Ticket selected = dao.getTicketById(id);
                request.setAttribute("selectedTicket", selected);

                // Lấy lịch sử chat
                List<TicketResponse> history = dao.getResponsesByTicketId(id);
                request.setAttribute("chatHistory", history);

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        request.getRequestDispatcher("view/customersuccess/customersuccess.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            int ticketId = Integer.parseInt(request.getParameter("ticketId"));
            String message = request.getParameter("message");

            // Lấy ID nhân viên từ session
            HttpSession session = request.getSession();
            Integer staffId = (Integer) session.getAttribute("userId");
            if (staffId == null) {
                staffId = 1; // ID mặc định để test
            }
            // Gửi tin nhắn và Đóng phiếu
            TicketDAO dao = new TicketDAO();
            dao.sendResponse(ticketId, staffId, message);

            // --- QUAN TRỌNG: CHUYỂN HƯỚNG ---
            // Sau khi trả lời, ticket chuyển sang trạng thái "Đã đóng".
            // Ta chuyển hướng về danh sách "Cần xử lý" để nhân viên làm việc tiếp.
            response.sendRedirect("customer-success?view=pending");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("customer-success");
        }
    }
}
