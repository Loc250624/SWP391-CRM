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
        
        // Lấy đúng tên tham số từ thuộc tính 'name' của thẻ <input>
        String code = request.getParameter("sCode");
        String name = request.getParameter("sName");
        String phone = request.getParameter("sPhone");

        ActivityDAO dao = new ActivityDAO();
        List<Activity> results = dao.searchGlobal(code, name, phone);

        request.setAttribute("searchResult", results);
        request.setAttribute("pageTitle", "Tìm kiếm khách hàng");
        request.setAttribute("contentPage", "/view/customersuccess/pages/search_customer.jsp");
        
        request.getRequestDispatcher("/view/customersuccess/pages/main_layout.jsp").forward(request, response);
    }
}