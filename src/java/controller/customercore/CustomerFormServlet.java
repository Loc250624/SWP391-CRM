package controller.customercore;

import dao.CustomerCoreDAO;
import dao.CustomerTagDAO;
import java.util.HashSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import model.Customer;

@WebServlet(name = "CustomerFormServlet", urlPatterns = {"/customercore/customer/form"})
public class CustomerFormServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String idStr = req.getParameter("id");
        CustomerCoreDAO customerDAO = new CustomerCoreDAO();
        CustomerTagDAO assignmentDAO = new CustomerTagDAO();

        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                Customer c = customerDAO.getCustomerById(id);
                if (c != null) {
                    req.setAttribute("customer", c);
                    Set<Integer> checkedTagIds = new HashSet<>(assignmentDAO.getTagIdsByCustomerId(id));
                    req.setAttribute("checkedTagIds", checkedTagIds);
                }
            } catch (Exception ignored) {
            }
        }

        try {
            CustomerTagDAO tagDAO = new CustomerTagDAO();
            req.setAttribute("allTags", tagDAO.getAllActiveTags());
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        req.getRequestDispatcher("/view/customercore/form.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String idStr = req.getParameter("id");
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String status = req.getParameter("status");
        String segment = req.getParameter("segment");
        String city = req.getParameter("city");
        String[] tagIdsArr = req.getParameterValues("tagIds");

        Customer c = new Customer();
        c.setFullName(fullName);
        c.setEmail(email);
        c.setPhone(phone);
        c.setStatus(status);
        c.setCustomerSegment(segment);
        c.setCity(city);

        CustomerCoreDAO customerDAO = new CustomerCoreDAO();
        CustomerTagDAO assignmentDAO = new CustomerTagDAO();

        int customerId = -1;
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                customerId = Integer.parseInt(idStr);
                c.setCustomerId(customerId);
                customerDAO.updateCustomer(c);
            } catch (Exception ignored) {
            }
        } else {
            customerId = customerDAO.createCustomer(c);
        }

        if (customerId > 0) {
            List<Integer> tagIds = new ArrayList<>();
            if (tagIdsArr != null) {
                for (String t : tagIdsArr) {
                    try {
                        tagIds.add(Integer.parseInt(t));
                    } catch (Exception ignored) {}
                }
            }
            assignmentDAO.assignTags(customerId, tagIds, null);
        }

        resp.sendRedirect(req.getContextPath() + "/customercore/customer/list");
    }
}
