package controller.manager;

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

@WebServlet(name = "ManagerTaskCalendarServlet", urlPatterns = {"/manager/task/calendar"})
public class ManagerTaskCalendarServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");

        // Role checking
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        UserDAO userDAO = new UserDAO();
        String roleCode = userDAO.getRoleCodeByUserId(currentUser.getUserId());

        if (!"MANAGER".equals(roleCode)) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        // Get year and month parameters
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
            }
        } catch (NumberFormatException e) {
            // Use default values
        }

        // Get view type
        String viewType = request.getParameter("view");
        if (viewType == null || viewType.isEmpty()) {
            viewType = "personal";
        }

        TaskDAO taskDAO = new TaskDAO();
        List<Task> tasks = new ArrayList<>();

        if ("personal".equals(viewType)) {
            // Personal calendar - tasks assigned to current manager
            tasks = taskDAO.getTasksForCalendar(year, month, currentUser.getUserId(), null);

        } else if ("team".equals(viewType)) {
            // Team calendar - tasks of all team members
            List<Users> teamMembers = userDAO.getAllUsers();
            List<Integer> teamMemberIds = new ArrayList<>();

            for (Users user : teamMembers) {
                if (user.getDepartmentId() == currentUser.getDepartmentId()
                        && user.getUserId() != currentUser.getUserId()) {
                    teamMemberIds.add(user.getUserId());
                }
            }

            if (!teamMemberIds.isEmpty()) {
                tasks = taskDAO.getTasksForCalendar(year, month, null, teamMemberIds);
            }
        }

        // Group tasks by date
        Map<Integer, List<Task>> tasksByDate = new HashMap<>();
        for (Task task : tasks) {
            if (task.getDueDate() != null) {
                int day = task.getDueDate().getDayOfMonth();
                tasksByDate.computeIfAbsent(day, k -> new ArrayList<>()).add(task);
            }
        }

        // Get all users for displaying names
        List<Users> allUsers = userDAO.getAllUsers();

        // Calendar info
        YearMonth yearMonth = YearMonth.of(year, month);
        int daysInMonth = yearMonth.lengthOfMonth();
        LocalDate firstDay = yearMonth.atDay(1);
        int firstDayOfWeek = firstDay.getDayOfWeek().getValue(); // 1 = Monday, 7 = Sunday

        // Previous and next month
        YearMonth previousMonth = yearMonth.minusMonths(1);
        YearMonth nextMonth = yearMonth.plusMonths(1);

        request.setAttribute("tasksByDate", tasksByDate);
        request.setAttribute("allUsers", allUsers);
        request.setAttribute("viewType", viewType);
        request.setAttribute("year", year);
        request.setAttribute("month", month);
        request.setAttribute("daysInMonth", daysInMonth);
        request.setAttribute("firstDayOfWeek", firstDayOfWeek);
        request.setAttribute("previousYear", previousMonth.getYear());
        request.setAttribute("previousMonth", previousMonth.getMonthValue());
        request.setAttribute("nextYear", nextMonth.getYear());
        request.setAttribute("nextMonth", nextMonth.getMonthValue());
        request.setAttribute("monthName", yearMonth.getMonth().toString());

        request.setAttribute("ACTIVE_MENU", "TASK_CALENDAR");
        request.setAttribute("pageTitle", "Lịch Công việc");
        request.setAttribute("CONTENT_PAGE", "/view/manager/task/task-calendar.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }
}
