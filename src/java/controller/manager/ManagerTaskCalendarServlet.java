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

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Users currentUser = (Users) session.getAttribute("user");
        UserDAO userDAO = new UserDAO();
        String roleCode = userDAO.getRoleCodeByUserId(currentUser.getUserId());

        if (!"MANAGER".equals(roleCode)) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        // Validate year/month range
        LocalDate today = LocalDate.now();
        int year  = today.getYear();
        int month = today.getMonthValue();

        try {
            String yearParam  = request.getParameter("year");
            String monthParam = request.getParameter("month");

            if (yearParam != null && !yearParam.trim().isEmpty()) {
                int parsedYear = Integer.parseInt(yearParam.trim());
                if (parsedYear >= 2000 && parsedYear <= 2100) year = parsedYear;
            }
            if (monthParam != null && !monthParam.trim().isEmpty()) {
                int parsedMonth = Integer.parseInt(monthParam.trim());
                if (parsedMonth >= 1 && parsedMonth <= 12) month = parsedMonth;
            }
        } catch (NumberFormatException e) {
            // Keep defaults
        }

        // View type — now supports personal | team | all
        String viewType = request.getParameter("view");
        if (!"personal".equals(viewType) && !"team".equals(viewType) && !"all".equals(viewType)) {
            viewType = "personal";
        }

        // Build dept member lists
        List<Users> allUsers = userDAO.getAllUsers();
        List<Users> deptMembers = new ArrayList<>();
        List<Integer> allDeptIds = new ArrayList<>();
        List<Integer> teamMemberIds = new ArrayList<>();

        for (Users u : allUsers) {
            if (u.getDepartmentId() == currentUser.getDepartmentId()) {
                deptMembers.add(u);
                allDeptIds.add(u.getUserId());
                if (u.getUserId() != currentUser.getUserId()) {
                    teamMemberIds.add(u.getUserId());
                }
            }
        }

        TaskDAO taskDAO = new TaskDAO();
        List<Task> tasks = new ArrayList<>();

        if ("personal".equals(viewType)) {
            tasks = taskDAO.getTasksForCalendar(year, month, currentUser.getUserId(), null);

        } else if ("team".equals(viewType)) {
            if (!teamMemberIds.isEmpty()) {
                tasks = taskDAO.getTasksForCalendar(year, month, null, teamMemberIds);
            }
        } else if ("all".equals(viewType)) {
            if (!allDeptIds.isEmpty()) {
                tasks = taskDAO.getTasksForCalendar(year, month, null, allDeptIds);
            }
        }

        // Group tasks by day of month (kept for backward-compat, not used by new FullCalendar view)
        Map<Integer, List<Task>> tasksByDate = new HashMap<>();
        for (Task task : tasks) {
            if (task.getDueDate() != null) {
                int day = task.getDueDate().getDayOfMonth();
                tasksByDate.computeIfAbsent(day, k -> new ArrayList<>()).add(task);
            }
        }

        // Overdue count for sidebar badge
        int overdueCount = 0;
        if (!allDeptIds.isEmpty()) {
            List<Task> overdueTasks = taskDAO.getOverdueTasks(null, allDeptIds);
            overdueCount = overdueTasks.size();
        }

        YearMonth yearMonth     = YearMonth.of(year, month);
        int daysInMonth         = yearMonth.lengthOfMonth();
        LocalDate firstDay      = yearMonth.atDay(1);
        int firstDayOfWeek      = firstDay.getDayOfWeek().getValue(); // 1=Mon, 7=Sun
        YearMonth previousMonth = yearMonth.minusMonths(1);
        YearMonth nextMonth     = yearMonth.plusMonths(1);

        request.setAttribute("tasksByDate",    tasksByDate);
        request.setAttribute("allUsers",       allUsers);
        request.setAttribute("deptMembers",    deptMembers);
        request.setAttribute("viewType",       viewType);
        request.setAttribute("year",           year);
        request.setAttribute("month",          month);
        request.setAttribute("daysInMonth",    daysInMonth);
        request.setAttribute("firstDayOfWeek", firstDayOfWeek);
        request.setAttribute("previousYear",   previousMonth.getYear());
        request.setAttribute("previousMonth",  previousMonth.getMonthValue());
        request.setAttribute("nextYear",       nextMonth.getYear());
        request.setAttribute("nextMonth",      nextMonth.getMonthValue());
        request.setAttribute("monthName",      yearMonth.getMonth().toString());
        request.setAttribute("overdueCount",   overdueCount);

        request.setAttribute("ACTIVE_MENU",  "TASK_CALENDAR");
        request.setAttribute("pageTitle",    "Lịch Công việc");
        request.setAttribute("CONTENT_PAGE", "/view/manager/task/task-calendar.jsp");
        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp").forward(request, response);
    }
}
