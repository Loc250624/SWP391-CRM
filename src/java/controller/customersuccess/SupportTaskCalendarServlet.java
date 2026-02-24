package controller.customersuccess;

import dao.TaskDAO;
import dao.UserDAO;
import java.io.IOException;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Task;
import model.Users;

@WebServlet(name = "SupportTaskCalendarServlet", urlPatterns = {"/support/task/calendar"})
public class SupportTaskCalendarServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Users currentUser = (Users) session.getAttribute("user");
        UserDAO userDAO = new UserDAO();
        String roleCode = userDAO.getRoleCodeByUserId(currentUser.getUserId());

        if (!"SUPPORT".equals(roleCode)) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        LocalDate today = LocalDate.now();
        int year = today.getYear();
        int month = today.getMonthValue();

        try {
            String yearParam = request.getParameter("year");
            String monthParam = request.getParameter("month");
            if (yearParam != null && !yearParam.isEmpty()) {
                year = Integer.parseInt(yearParam);
            }
            if (monthParam != null && !monthParam.isEmpty()) {
                month = Integer.parseInt(monthParam);
                if (month < 1) month = 1;
                if (month > 12) month = 12;
            }
        } catch (NumberFormatException e) {
            // Use defaults
        }

        TaskDAO taskDAO = new TaskDAO();
        List<Task> tasks = taskDAO.getTasksForCalendar(year, month, currentUser.getUserId(), null);

        // Group tasks by day of month
        Map<Integer, List<Task>> tasksByDate = new HashMap<>();
        for (Task task : tasks) {
            if (task.getDueDate() != null) {
                int day = task.getDueDate().getDayOfMonth();
                tasksByDate.computeIfAbsent(day, k -> new ArrayList<>()).add(task);
            }
        }

        YearMonth yearMonth = YearMonth.of(year, month);
        int daysInMonth = yearMonth.lengthOfMonth();
        LocalDate firstDay = yearMonth.atDay(1);
        int firstDayOfWeek = firstDay.getDayOfWeek().getValue(); // 1=Mon, 7=Sun

        YearMonth previousMonth = yearMonth.minusMonths(1);
        YearMonth nextMonth = yearMonth.plusMonths(1);

        request.setAttribute("tasksByDate", tasksByDate);
        request.setAttribute("year", year);
        request.setAttribute("month", month);
        request.setAttribute("daysInMonth", daysInMonth);
        request.setAttribute("firstDayOfWeek", firstDayOfWeek);
        request.setAttribute("previousYear", previousMonth.getYear());
        request.setAttribute("previousMonth", previousMonth.getMonthValue());
        request.setAttribute("nextYear", nextMonth.getYear());
        request.setAttribute("nextMonth", nextMonth.getMonthValue());

        request.setAttribute("pageTitle", "Lịch Công việc");
        request.setAttribute("contentPage", "/view/support/task/task-calendar.jsp");
        request.getRequestDispatcher("/view/customersuccess/main_layout.jsp").forward(request, response);
    }
}
