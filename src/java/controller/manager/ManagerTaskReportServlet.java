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

@WebServlet(name = "ManagerTaskReportServlet", urlPatterns = {"/manager/task/report"})
public class ManagerTaskReportServlet extends HttpServlet {

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

        TaskDAO taskDAO = new TaskDAO();

        // Get team members
        List<Users> teamMembers = userDAO.getAllUsers();
        List<Integer> teamMemberIds = new ArrayList<>();
        List<Users> teamMembersList = new ArrayList<>();

        for (Users user : teamMembers) {
            if (user.getDepartmentId() == currentUser.getDepartmentId()
                    && user.getUserId() != currentUser.getUserId()) {
                teamMemberIds.add(user.getUserId());
                teamMembersList.add(user);
            }
        }

        // Get overall statistics
        Map<String, Object> overallStats = taskDAO.getTaskStatistics(null, teamMemberIds);

        // Get statistics per employee
        Map<Integer, Map<String, Object>> employeeStats = new HashMap<>();
        for (Users member : teamMembersList) {
            List<Integer> singleMember = new ArrayList<>();
            singleMember.add(member.getUserId());
            Map<String, Object> stats = taskDAO.getTaskStatistics(null, singleMember);
            employeeStats.put(member.getUserId(), stats);
        }

        // Get tasks grouped by employee
        Map<Integer, List<Task>> tasksGroupedByEmployee = taskDAO.getTasksGroupedByEmployee(teamMemberIds);

        // Get overdue tasks
        List<Task> overdueTasks = taskDAO.getOverdueTasks(null, teamMemberIds);

        request.setAttribute("overallStats", overallStats);
        request.setAttribute("employeeStats", employeeStats);
        request.setAttribute("teamMembers", teamMembersList);
        request.setAttribute("tasksGroupedByEmployee", tasksGroupedByEmployee);
        request.setAttribute("overdueTasks", overdueTasks);

        request.setAttribute("ACTIVE_MENU", "TASK_REPORT");
        request.setAttribute("pageTitle", "Báo cáo Công việc");
        request.setAttribute("CONTENT_PAGE", "/view/manager/task/task-report.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }
}
