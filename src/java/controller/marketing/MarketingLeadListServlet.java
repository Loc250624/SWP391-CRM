package controller.marketing;

import dao.LeadDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Lead;

@WebServlet(name = "MarketingLeadListServlet", urlPatterns = { "/marketing/lead/list" })
public class MarketingLeadListServlet extends HttpServlet {

    private LeadDAO leadDAO = new LeadDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String search = request.getParameter("search");
        String status = request.getParameter("status");

        // Pagination
        int page = 1;
        try {
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                page = Integer.parseInt(pageStr);
            }
        } catch (NumberFormatException e) {
            page = 1;
        }
        int pageSize = 10;

        util.PagedResult<Lead> pagedResult = leadDAO.search(search, status, page, pageSize);

        request.setAttribute("pagedResult", pagedResult);
        request.setAttribute("leads", pagedResult.getItems()); // Keep for compatibility
        request.setAttribute("search", search);
        request.setAttribute("status", status);
        request.setAttribute("ACTIVE_MENU", "LEAD_LIST");
        request.setAttribute("pageTitle", "Danh sách Lead");
        request.setAttribute("CONTENT_PAGE", "/view/marketing/lead/list.jsp");
        request.getRequestDispatcher("/view/marketing/layout.jsp").forward(request, response);
    }
}
