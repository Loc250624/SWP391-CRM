package controller.manager;

import dao.TaskDAO;
import dao.UserDAO;
import enums.Priority;
import enums.TaskStatus;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Task;
import model.Users;

@WebServlet(name = "ManagerTaskTeamServlet", urlPatterns = {"/manager/task/team"})
public class ManagerTaskTeamServlet extends HttpServlet {

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

        // Build team member list (same department, excluding manager)
        List<Users> allUsers = userDAO.getAllUsers();
        List<Users> teamMembersList = new ArrayList<>();
        List<Integer> teamMemberIds = new ArrayList<>();

        for (Users user : allUsers) {
            if (user.getDepartmentId() == currentUser.getDepartmentId()
                    && user.getUserId() != currentUser.getUserId()) {
                teamMembersList.add(user);
                teamMemberIds.add(user.getUserId());
            }
        }

        // Filter parameters
        String statusFilter   = request.getParameter("status");
        String priorityFilter = request.getParameter("priority");
        String employeeFilter = request.getParameter("employee");
        String keyword        = request.getParameter("keyword");
        String sortBy         = request.getParameter("sortBy");
        String sortOrder      = request.getParameter("sortOrder");
        String overdueParam   = request.getParameter("overdue");
        boolean overdueOnly   = "1".equals(overdueParam) || "true".equals(overdueParam);

        // Pagination
        int page = 1;
        int pageSize = 10;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                int p = Integer.parseInt(pageParam);
                if (p > 0) page = p;
            }
        } catch (NumberFormatException ignored) { }

        int offset = (page - 1) * pageSize;

        // Validate and resolve employee filter (must be in this manager's team)
        Integer selectedEmployee = null;
        if (employeeFilter != null && !employeeFilter.trim().isEmpty()) {
            try {
                int parsed = Integer.parseInt(employeeFilter.trim());
                if (teamMemberIds.contains(parsed)) {
                    selectedEmployee = parsed;
                } else {
                    session.setAttribute("errorMessage", "Nhân viên không thuộc nhóm của bạn");
                    employeeFilter = null;
                }
            } catch (NumberFormatException e) {
                employeeFilter = null;
            }
        }

        TaskDAO taskDAO = new TaskDAO();
        List<Task> taskList = new ArrayList<>();
        int totalTasks = 0;

        if (!teamMemberIds.isEmpty()) {
            taskList = taskDAO.getTasksWithFilterForTeam(
                    teamMemberIds, selectedEmployee,
                    statusFilter, priorityFilter, keyword,
                    overdueOnly, sortBy, sortOrder, offset, pageSize);
            totalTasks = taskDAO.countTasksWithFilterForTeam(
                    teamMemberIds, selectedEmployee,
                    statusFilter, priorityFilter, keyword, overdueOnly);
        }

        int totalPages = (totalTasks == 0) ? 1 : (int) Math.ceil((double) totalTasks / pageSize);

        request.setAttribute("taskList",        taskList);
        request.setAttribute("allUsers",        allUsers);
        request.setAttribute("teamMembers",     teamMembersList);
        request.setAttribute("viewType",        "team");
        request.setAttribute("statusFilter",    statusFilter);
        request.setAttribute("priorityFilter",  priorityFilter);
        request.setAttribute("employeeFilter",  employeeFilter);
        request.setAttribute("keyword",         keyword);
        request.setAttribute("sortBy",          sortBy);
        request.setAttribute("sortOrder",       sortOrder);
        request.setAttribute("overdueOnly",     overdueOnly);
        request.setAttribute("currentPage",     page);
        request.setAttribute("totalPages",      totalPages);
        request.setAttribute("totalTasks",      totalTasks);
        request.setAttribute("pageSize",        pageSize);
        request.setAttribute("taskStatusValues", TaskStatus.values());
        request.setAttribute("priorityValues",   Priority.values());

        request.setAttribute("ACTIVE_MENU",  "TASK_TEAM_LIST");
        request.setAttribute("pageTitle",    "Công việc Nhóm");
        request.setAttribute("CONTENT_PAGE", "/view/manager/task/task-team-list.jsp");
        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp").forward(request, response);
    }
}
