package controller.sale;

import dao.ActivityDAO;
import model.Activity;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.SessionHelper;

@WebServlet(name = "SaleActivityListServlet", urlPatterns = {"/sale/activity/list"})
public class SaleActivityListServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer currentUserId = SessionHelper.getLoggedInUserId(request);
        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        ActivityDAO actDAO = new ActivityDAO();

        String typeFilter = request.getParameter("type");
        String keyword = request.getParameter("keyword");
        String statusFilter = request.getParameter("status");
        String relatedTypeFilter = request.getParameter("relatedType");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String pageParam = request.getParameter("page");

        int currentPage = 1;
        if (pageParam != null && !pageParam.isEmpty()) {
            try { currentPage = Integer.parseInt(pageParam); } catch (NumberFormatException e) {}
            if (currentPage < 1) currentPage = 1;
        }

        int offset = (currentPage - 1) * PAGE_SIZE;

        List<Activity> activities = actDAO.getActivitiesByUserFiltered(
                currentUserId, typeFilter, keyword, statusFilter, relatedTypeFilter, startDate, endDate, offset, PAGE_SIZE);
        int totalCount = actDAO.countActivitiesByUserFiltered(
                currentUserId, typeFilter, keyword, statusFilter, relatedTypeFilter, startDate, endDate);
        int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);
        if (totalPages < 1) totalPages = 1;

        Map<String, Integer> stats = actDAO.getActivityStats(currentUserId);

        request.setAttribute("activities", activities);
        request.setAttribute("stats", stats);
        request.setAttribute("typeFilter", typeFilter);
        request.setAttribute("keyword", keyword);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("relatedTypeFilter", relatedTypeFilter);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCount", totalCount);

        request.setAttribute("ACTIVE_MENU", "ACT_LIST");
        request.setAttribute("pageTitle", "Danh sach Hoat dong");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/activity/list.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }
}
