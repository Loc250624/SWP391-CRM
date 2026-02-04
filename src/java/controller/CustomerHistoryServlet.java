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

@WebServlet(name = "CustomerHistoryServlet", urlPatterns = {"/history"})
public class CustomerHistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer customerId = (Integer) session.getAttribute("customerId");
        
        // --- GIẢ LẬP LOGIN (TEST) ---
        // Vì trong DB bạn đã có khách ID = 1 (Alex Test), ta fix cứng để test
        if (customerId == null) {
            customerId = 1; 
            session.setAttribute("customerId", 1);
            session.setAttribute("customerName", "Alex Test");
        }
        // ----------------------------

        TicketDAO dao = new TicketDAO();

        // 1. Lấy danh sách phiếu của RIÊNG khách hàng này
        List<Ticket> list = dao.getTicketsByCustomerId(customerId);
        request.setAttribute("ticketList", list);

        // 2. Nếu khách bấm vào xem chi tiết 1 phiếu
        String idRaw = request.getParameter("id");
        if (idRaw != null) {
            try {
                int ticketId = Integer.parseInt(idRaw);
                Ticket selected = dao.getTicketById(ticketId);
                
                // Bảo mật: Chỉ cho xem nếu phiếu đó đúng là của mình
                if (selected != null && selected.getCustomerId() == customerId) {
                    request.setAttribute("selectedTicket", selected);
                    
                    // Lấy lịch sử chat (Câu trả lời của Staff)
                    List<TicketResponse> history = dao.getResponsesByTicketId(ticketId);
                    request.setAttribute("chatHistory", history);
                }
            } catch (Exception e) { e.printStackTrace(); }
        }

        // Chuyển sang trang giao diện
        request.getRequestDispatcher("view/customersuccess/customer_history.jsp").forward(request, response);
    }
}