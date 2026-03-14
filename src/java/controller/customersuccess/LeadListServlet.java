package controller.customersuccess;

import dao.LeadDAO;
import model.Lead;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "LeadListServlet", urlPatterns = {"/support/leads"})
public class LeadListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Kiểm tra session và lấy thông tin User đang đăng nhập
        HttpSession session = request.getSession(false);
        model.Users user = (session != null) ? (model.Users) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 2. Lấy ID người dùng và tham số tìm kiếm
        int currentUserId = user.getUserId();
        String phoneQuery = request.getParameter("search");

        LeadDAO dao = new LeadDAO();
        List<Lead> list;

        // 3. Sử dụng 2 hàm mới bạn vừa thêm vào DAO
        if (phoneQuery != null && !phoneQuery.trim().isEmpty()) {
            // Nếu có nhập SĐT -> Tìm kiếm trong danh sách của tôi
            list = dao.searchLeadsByPhoneAndCreator(phoneQuery.trim(), currentUserId);
            request.setAttribute("searchValue", phoneQuery);
        } else {
            // Nếu không nhập -> Hiện toàn bộ danh sách của tôi
            list = dao.getLeadsByCreator(currentUserId);
        }

        // 4. Đẩy dữ liệu ra view
        request.setAttribute("leadList", list);
        request.setAttribute("pageTitle", "Danh sách Leads của tôi");
        request.setAttribute("contentPage", "/view/customersuccess/pages/leads_list.jsp");

        request.getRequestDispatcher("/view/customersuccess/pages/main_layout.jsp").forward(request, response);
    }
}
