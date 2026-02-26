package controller.admin;

import dao.CustomerCoreDAO;
import dao.CustomerTagDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;
import model.CustomerTag;
import util.PagedResult;

@WebServlet(name = "AdminCustomerListServlet", urlPatterns = {"/admin/customer/list", "/admin/customer/export"})
public class AdminCustomerListServlet extends HttpServlet {

    private CustomerCoreDAO dao    = new CustomerCoreDAO();
    private CustomerTagDAO  tagDAO = new CustomerTagDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/admin/customer/export".equals(path)) {
            handleExport(request, response);
            return;
        }

        // ----- LIST -----
        String q       = request.getParameter("q");
        String status  = request.getParameter("status");
        String segment = request.getParameter("segment");
        String tagStr  = request.getParameter("tag");
        String pageStr = request.getParameter("page");
        String psStr   = request.getParameter("pageSize");

        Integer tagId = null;
        if (tagStr != null && !tagStr.trim().isEmpty()) {
            try { tagId = Integer.parseInt(tagStr.trim()); } catch (NumberFormatException ignored) {}
        }

        int pageSize = 10;
        if (psStr != null) {
            try { pageSize = Integer.parseInt(psStr); } catch (NumberFormatException ignored) {}
        }

        int page = 1;
        if (pageStr != null) {
            try { page = Math.max(1, Integer.parseInt(pageStr)); } catch (NumberFormatException ignored) {}
        }

        PagedResult<Customer> paged = dao.searchCustomers(q, status, tagId, segment, page, pageSize);

        List<CustomerTag> allTags = tagDAO.getAllActiveTags();
        Map<Integer, List<CustomerTag>> tagsByCustomer = new HashMap<>();
        for (Customer c : paged.getItems()) {
            tagsByCustomer.put(c.getCustomerId(), tagDAO.getTagsByCustomerId(c.getCustomerId()));
        }

        request.setAttribute("paged",          paged);
        request.setAttribute("allTags",         allTags);
        request.setAttribute("tagsByCustomer",  tagsByCustomer);
        request.setAttribute("q",               q);
        request.setAttribute("status",          status);
        request.setAttribute("segment",         segment);
        request.setAttribute("tag",             tagStr);
        request.setAttribute("pageSize",        pageSize);

        request.setAttribute("CONTENT_PAGE", "/view/admin/customercore/list.jsp");
        request.setAttribute("pageTitle", "Quản lý Khách hàng");
        request.setAttribute("ACTIVE_MENU", "CUSTOMER_LIST");
        request.getRequestDispatcher("/view/admin/layout.jsp").forward(request, response);
    }

    private void handleExport(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String q       = request.getParameter("q");
        String status  = request.getParameter("status");
        String segment = request.getParameter("segment");
        String tagStr  = request.getParameter("tag");

        Integer tagId = null;
        if (tagStr != null && !tagStr.trim().isEmpty()) {
            try { tagId = Integer.parseInt(tagStr.trim()); } catch (NumberFormatException ignored) {}
        }

        PagedResult<Customer> all = dao.searchCustomers(q, status, tagId, segment, 1, Integer.MAX_VALUE);

        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"customers-admin.csv\"");

        PrintWriter pw = response.getWriter();
        pw.println("ID,Full Name,Email,Phone,Status,Segment,City");
        for (Customer c : all.getItems()) {
            pw.printf("%d,\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"%n",
                    c.getCustomerId(),
                    safe(c.getFullName()),
                    safe(c.getEmail()),
                    safe(c.getPhone()),
                    safe(c.getStatus()),
                    safe(c.getCustomerSegment()),
                    safe(c.getCity()));
        }
        pw.flush();
    }

    private String safe(String s) {
        return s == null ? "" : s.replace("\"", "\"\"");
    }
}
