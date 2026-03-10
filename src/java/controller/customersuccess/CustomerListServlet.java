package controller.customersuccess;

import dao.CustomerDAO;
import model.Customer;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "CustomerListServlet", urlPatterns = {"/support/customers"})
public class CustomerListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Lấy Session hiện tại
        HttpSession session = request.getSession(false);

        // 2. Ép kiểu object 'user' từ session về class Users của bạn
        // Giả sử class model của bạn tên là Users và được lưu với key "user"
        model.Users user = (session != null) ? (model.Users) session.getAttribute("user") : null;

        // 3. Nếu chưa đăng nhập thì đá về trang login
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 4. Gọi DAO và sử dụng ID của người đang đăng nhập để lọc
        CustomerDAO dao = new CustomerDAO();

        // Chú ý: Bạn cần thêm hàm getCustomersByCreator vào CustomerDAO (xem bước 2 ở dưới)
        List<Customer> list = dao.getCustomersByCreator(user.getUserId());

        // 5. Đẩy dữ liệu ra JSP
        request.setAttribute("customerList", list);
        request.setAttribute("pageTitle", "Khách hàng của tôi");
        request.setAttribute("contentPage", "/view/customersuccess/pages/customer_list.jsp");

        request.getRequestDispatcher("/view/customersuccess/pages/main_layout.jsp").forward(request, response);
    }
}
