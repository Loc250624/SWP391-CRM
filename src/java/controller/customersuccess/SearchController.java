package controller.customersuccess;

import dao.ActivityDAO;
import model.Activity;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/support/search")
public class SearchController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Lấy thông tin từ Form
        String code = request.getParameter("sCode");
        String name = request.getParameter("sName");
        String phone = request.getParameter("sPhone");

        List<Activity> results = null;

        // 👉 TỐI ƯU HÓA: Kiểm tra xem người dùng CÓ THỰC SỰ nhập từ khóa không?
        boolean isSearching = (code != null && !code.trim().isEmpty()) || 
                              (name != null && !name.trim().isEmpty()) || 
                              (phone != null && !phone.trim().isEmpty());

        // Nếu có nhập từ khóa -> Mới mở kết nối Database để tìm
        if (isSearching) {
            ActivityDAO dao = new ActivityDAO();
            results = dao.searchGlobal(code, name, phone);
        }

        // Đẩy dữ liệu ra view (Nếu không tìm kiếm, results sẽ là null)
        request.setAttribute("searchResult", results);
        request.setAttribute("pageTitle", "Tìm kiếm khách hàng");
        request.setAttribute("contentPage", "/view/customersuccess/pages/search_customer.jsp");
        
        request.getRequestDispatcher("/view/customersuccess/pages/main_layout.jsp").forward(request, response);
    }
}