package controller.manager;

import dao.TaskDAO;
import dao.UserDAO;
import java.io.IOException;
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

/**
 * GET /manager/task/workload
 * Displays a workload grid: one row per employee, open task counts,
 * highlights overloaded employees (> 5 open tasks).
 */
@WebServlet(name = "ManagerTaskWorkloadServlet", urlPatterns = {"/manager/task/workload"})
public class ManagerTaskWorkloadServlet extends HttpServlet {

    private static final int OVERLOAD_THRESHOLD = 5;

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

        TaskDAO taskDAO = new TaskDAO();

        // Get all users (exclude current manager)
        List<Users> allUsers = userDAO.getAllUsers();
        List<Users> teamMembers = new ArrayList<>();
        List<Integer> teamMemberIds = new ArrayList<>();

        for (Users u : allUsers) {
            if (u.getUserId() != currentUser.getUserId()) {
                teamMembers.add(u);
                teamMemberIds.add(u.getUserId());
            }
        }

        // Open task count per employee
        Map<Integer, Integer> openTaskCount = new HashMap<>();
        Map<Integer, List<Task>> tasksByEmployee = new HashMap<>();

        if (!teamMemberIds.isEmpty()) {
            Map<Integer, List<Task>> grouped = taskDAO.getTasksGroupedByEmployee(teamMemberIds);
            for (Users u : teamMembers) {
                List<Task> userTasks = grouped.getOrDefault(u.getUserId(), new ArrayList<>());
                long openCount = userTasks.stream()
                        .filter(t -> !"COMPLETED".equals(t.getStatusName())
                                  && !"CANCELLED".equals(t.getStatusName()))
                        .count();
                openTaskCount.put(u.getUserId(), (int) openCount);
                tasksByEmployee.put(u.getUserId(), userTasks);
            }
        }

        // Dept-wide stats
        Map<String, Object> deptStats = taskDAO.getTaskStatistics(null, teamMemberIds);

        request.setAttribute("teamMembers",       teamMembers);
        request.setAttribute("openTaskCount",     openTaskCount);
        request.setAttribute("tasksByEmployee",   tasksByEmployee);
        request.setAttribute("overloadThreshold", OVERLOAD_THRESHOLD);
        request.setAttribute("deptStats",         deptStats);

        request.setAttribute("ACTIVE_MENU",  "TASK_WORKLOAD");
        request.setAttribute("pageTitle",    "Workload Nhân viên");
        request.setAttribute("CONTENT_PAGE", "/view/manager/task/task-workload.jsp");
        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp").forward(request, response);
    }
}
