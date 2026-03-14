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

        List<Activity> activities = actDAO.getActivitiesByUser(currentUserId, typeFilter, keyword);
        request.setAttribute("activities", activities);

        Map<String, Integer> stats = actDAO.getActivityStats(currentUserId);
        request.setAttribute("stats", stats);
        request.setAttribute("typeFilter", typeFilter);
        request.setAttribute("keyword", keyword);

        request.setAttribute("ACTIVE_MENU", "ACT_LIST");
        request.setAttribute("pageTitle", "Danh sach Hoat dong");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/activity/list.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }
}
