package controller.sale;

import dao.ActivityDAO;
import model.Activity;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.SessionHelper;

@WebServlet(name = "SaleActivityDetailServlet", urlPatterns = {"/sale/activity/detail"})
public class SaleActivityDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer currentUserId = SessionHelper.getLoggedInUserId(request);
        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/sale/activity/list");
            return;
        }

        try {
            int activityId = Integer.parseInt(idParam);
            ActivityDAO actDAO = new ActivityDAO();
            Activity activity = actDAO.getActivityById(activityId);

            if (activity == null) {
                response.sendRedirect(request.getContextPath() + "/sale/activity/list");
                return;
            }

            request.setAttribute("activity", activity);
            request.setAttribute("ACTIVE_MENU", "ACT_LIST");
            request.setAttribute("pageTitle", "Chi tiet Hoat dong");
            request.setAttribute("CONTENT_PAGE", "/view/sale/pages/activity/detail.jsp");
            request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/sale/activity/list");
        }
    }
}
