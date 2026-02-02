package controller;

import dao.LeadDAO;
import model.Lead;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "LeadDetailServlet", urlPatterns = {"/lead-detail"})
public class LeadDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 1) Lấy id từ URL: /lead-detail?id=1
            String idRaw = request.getParameter("id");
            if (idRaw == null || idRaw.isBlank()) {
                response.sendRedirect(request.getContextPath() + "/leads");
                return;
            }

            int id = Integer.parseInt(idRaw);

            // 2) Gọi DAO lấy lead theo id
            LeadDAO dao = new LeadDAO();
            Lead lead = dao.getLeadById(id);

            // 3) Nếu không tìm thấy lead -> quay về list
            if (lead == null) {
                response.sendRedirect(request.getContextPath() + "/leads");
                return;
            }

            // 4) Đẩy dữ liệu sang JSP
            request.setAttribute("lead", lead);
            request.getRequestDispatcher("/view/sales/lead-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            // id không phải số
            response.sendRedirect(request.getContextPath() + "/leads");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/leads");
        }
    }
}
