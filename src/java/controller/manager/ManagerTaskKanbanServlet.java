package controller.manager;

import dao.TaskDAO;
import dao.UserDAO;
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

@WebServlet(name = "ManagerTaskKanbanServlet", urlPatterns = {"/manager/task/kanban"})
public class ManagerTaskKanbanServlet extends HttpServlet {

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

        // Build all dept member IDs (include manager)
        List<Users> allUsers = userDAO.getAllUsers();
        List<Users> deptMembersList = new ArrayList<>();
        List<Integer> allMemberIds  = new ArrayList<>();

        for (Users user : allUsers) {
            if (user.getDepartmentId() == currentUser.getDepartmentId()) {
                deptMembersList.add(user);
                allMemberIds.add(user.getUserId());
            }
        }

        // Optional employee filter
        String employeeFilter = request.getParameter("employee");
        String keyword        = request.getParameter("keyword");
        Integer selectedEmployee = null;
        if (employeeFilter != null && !employeeFilter.trim().isEmpty()) {
            try {
                int parsed = Integer.parseInt(employeeFilter.trim());
                if (allMemberIds.contains(parsed)) selectedEmployee = parsed;
            } catch (NumberFormatException ignored) { }
        }

        TaskDAO taskDAO = new TaskDAO();
        List<Task> pendingTasks    = new ArrayList<>();
        List<Task> inProgressTasks = new ArrayList<>();
        List<Task> completedTasks  = new ArrayList<>();

        if (!allMemberIds.isEmpty()) {
            pendingTasks    = taskDAO.getTasksWithFilterForTeam(allMemberIds, selectedEmployee, "PENDING",     null, keyword, false, "priority", "DESC", 0, 500);
            inProgressTasks = taskDAO.getTasksWithFilterForTeam(allMemberIds, selectedEmployee, "IN_PROGRESS", null, keyword, false, "priority", "DESC", 0, 500);
            completedTasks  = taskDAO.getTasksWithFilterForTeam(allMemberIds, selectedEmployee, "COMPLETED",   null, keyword, false, "created_at", "DESC", 0, 100);
        }

        request.setAttribute("pendingTasks",     pendingTasks);
        request.setAttribute("inProgressTasks",  inProgressTasks);
        request.setAttribute("completedTasks",   completedTasks);
        request.setAttribute("allUsers",         allUsers);
        request.setAttribute("deptMembers",      deptMembersList);
        request.setAttribute("employeeFilter",   employeeFilter);
        request.setAttribute("keyword",          keyword);

        request.setAttribute("ACTIVE_MENU",  "TASK_KANBAN");
        request.setAttribute("pageTitle",    "Kanban Board");
        request.setAttribute("CONTENT_PAGE", "/view/manager/task/task-kanban.jsp");
        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp").forward(request, response);
    }
}
