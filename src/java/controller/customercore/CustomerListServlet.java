package controller.customercore;

import dao.CustomerCoreDAO;
import dao.CustomerTagDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Customer;
import model.CustomerTag;
import util.PagedResult;

@WebServlet(name = "CustomerCoreListServlet", urlPatterns = {"/customercore/customer/list"})
public class CustomerListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // UTF-8
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        // filters
        String q = trim(req.getParameter("q"));
        String status = trim(req.getParameter("status"));   // Active/Inactive/...
        String tag = trim(req.getParameter("tag"));         // tag_id
        String segment = trim(req.getParameter("segment")); // VIP/MBI/...

        int page = parseInt(req.getParameter("page"), 1);
        int pageSize = parseInt(req.getParameter("pageSize"), 10);
        if (page < 1) page = 1;
        if (pageSize < 5) pageSize = 5;
        if (pageSize > 50) pageSize = 50;

        Integer tagId = null;
        if (tag != null && !tag.isBlank()) {
            try {
                tagId = Integer.parseInt(tag);
            } catch (Exception ignored) {
            }
        }

        // ✅ dùng đúng DAO: CustomerCoreDAO (vì method searchCustomers nằm ở đây)
        CustomerCoreDAO customerDAO = new CustomerCoreDAO();
        CustomerTagDAO tagDAO = new CustomerTagDAO();

        // data + paging
        PagedResult<Customer> pr = customerDAO.searchCustomers(q, status, tagId, segment, page, pageSize);

        // map customerId -> tags (để show pills)
        Map<Integer, List<CustomerTag>> tagsByCustomer = new HashMap<>();
        if (pr != null && pr.getItems() != null) {
            for (Customer c : pr.getItems()) {
                tagsByCustomer.put(c.getCustomerId(), tagDAO.getTagsByCustomerId(c.getCustomerId()));
            }
        }

        // attributes for JSP
        req.setAttribute("paged", pr);
        req.setAttribute("tagsByCustomer", tagsByCustomer);
        req.setAttribute("allTags", tagDAO.getAllActiveTags());
        // keep filter values on UI
        req.setAttribute("q", q);
        req.setAttribute("status", status);
        req.setAttribute("tag", tag);
        // Go exactly to the customercore views without hijacking module 2
        req.getRequestDispatcher("/view/customercore/list.jsp").forward(req, resp);
    }

    private String trim(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }

    private int parseInt(String s, int def) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }
}
