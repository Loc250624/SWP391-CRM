package controller.sale;

import dao.ActivityDAO;
import model.Activity;
import java.io.IOException;
import java.sql.Date;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.SessionHelper;

@WebServlet(name = "SaleActivityCalendarServlet", urlPatterns = {"/sale/activity/calendar"})
public class SaleActivityCalendarServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer currentUserId = SessionHelper.getLoggedInUserId(request);
        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Determine week based on offset param
        String offsetStr = request.getParameter("weekOffset");
        int weekOffset = 0;
        if (offsetStr != null) {
            try { weekOffset = Integer.parseInt(offsetStr); } catch (NumberFormatException e) {}
        }

        LocalDate today = LocalDate.now();
        LocalDate weekStart = today.plusWeeks(weekOffset).with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        LocalDate weekEnd = weekStart.plusDays(6);

        ActivityDAO actDAO = new ActivityDAO();
        List<Activity> weekActivities = actDAO.getActivitiesByUserAndDateRange(
                currentUserId, Date.valueOf(weekStart), Date.valueOf(weekEnd));

        // Upcoming activities (next 7 days from today)
        List<Activity> upcoming = actDAO.getActivitiesByUserAndDateRange(
                currentUserId, Date.valueOf(today), Date.valueOf(today.plusDays(7)));

        request.setAttribute("weekActivities", weekActivities);
        request.setAttribute("upcoming", upcoming);
        request.setAttribute("weekStart", weekStart);
        request.setAttribute("weekEnd", weekEnd);
        request.setAttribute("weekOffset", weekOffset);

        request.setAttribute("ACTIVE_MENU", "ACT_CALENDAR");
        request.setAttribute("pageTitle", "Lich hen");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/activity/calendar.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }
}
