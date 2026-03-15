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

@WebServlet(name = "SaleActivityCancelServlet", urlPatterns = {"/sale/activity/cancel"})
public class SaleActivityCancelServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer currentUserId = SessionHelper.getLoggedInUserId(request);
        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idParam = request.getParameter("activityId");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/sale/activity/list");
            return;
        }

        try {
            int activityId = Integer.parseInt(idParam);
            ActivityDAO actDAO = new ActivityDAO();
            Activity activity = actDAO.getActivityById(activityId);

            if (activity == null) {
                response.sendRedirect(request.getContextPath() + "/sale/activity/list?error=not_found");
                return;
            }

            // Validate ownership
            if (activity.getPerformedBy() == null || !activity.getPerformedBy().equals(currentUserId)) {
                response.sendRedirect(request.getContextPath() + "/sale/activity/list?error=no_permission");
                return;
            }

            actDAO.deleteActivity(activityId);
            response.sendRedirect(request.getContextPath() + "/sale/activity/list?deleted=1");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/sale/activity/list");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/sale/activity/list");
    }
}
