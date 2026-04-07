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

        // Build all user IDs (manager can view whole system)
        List<Users> allUsers = userDAO.getAllUsers();
        List<Users> deptMembersList = new ArrayList<>(allUsers);
        List<Integer> allMemberIds  = new ArrayList<>();
        for (Users user : allUsers) {
            allMemberIds.add(user.getUserId());
        }

        // Optional filters
        String employeeFilter = request.getParameter("employee");
        String keyword        = request.getParameter("keyword");
        String viewType       = request.getParameter("view");        // personal | group
        String relatedType    = request.getParameter("relatedType"); // LEAD | CUSTOMER
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
        List<Task> cancelledTasks  = new ArrayList<>();

        if (!allMemberIds.isEmpty()) {
            boolean isGroupView = "group".equalsIgnoreCase(viewType);
            if (isGroupView) {
                pendingTasks    = taskDAO.getGroupTaskSummaries(allMemberIds, selectedEmployee, "PENDING",     null, keyword, "priority", "DESC", 0, 500);
                inProgressTasks = taskDAO.getGroupTaskSummaries(allMemberIds, selectedEmployee, "IN_PROGRESS", null, keyword, "priority", "DESC", 0, 500);
                completedTasks  = taskDAO.getGroupTaskSummaries(allMemberIds, selectedEmployee, "COMPLETED",   null, keyword, "created_at", "DESC", 0, 100);
                cancelledTasks  = taskDAO.getGroupTaskSummaries(allMemberIds, selectedEmployee, "CANCELLED",   null, keyword, "created_at", "DESC", 0, 100);
            } else {
                pendingTasks    = taskDAO.getTasksWithFilterForTeam(allMemberIds, selectedEmployee, "PENDING",     null, keyword, false, "priority", "DESC", 0, 500);
                inProgressTasks = taskDAO.getTasksWithFilterForTeam(allMemberIds, selectedEmployee, "IN_PROGRESS", null, keyword, false, "priority", "DESC", 0, 500);
                completedTasks  = taskDAO.getTasksWithFilterForTeam(allMemberIds, selectedEmployee, "COMPLETED",   null, keyword, false, "created_at", "DESC", 0, 100);
                cancelledTasks  = taskDAO.getTasksWithFilterForTeam(allMemberIds, selectedEmployee, "CANCELLED",   null, keyword, false, "created_at", "DESC", 0, 100);
            }
        }

        // Merge PENDING into IN_PROGRESS column for 3-status Kanban
        if (pendingTasks != null && !pendingTasks.isEmpty()) {
            inProgressTasks.addAll(pendingTasks);
        }

        // Filter by related type if provided
        if (relatedType != null && !relatedType.trim().isEmpty()) {
            String rt = relatedType.trim().toUpperCase();
            inProgressTasks = filterByRelatedType(inProgressTasks, rt);
            completedTasks  = filterByRelatedType(completedTasks, rt);
            cancelledTasks  = filterByRelatedType(cancelledTasks, rt);
        }

        request.setAttribute("inProgressTasks",  inProgressTasks);
        request.setAttribute("completedTasks",   completedTasks);
        request.setAttribute("cancelledTasks",   cancelledTasks);
        request.setAttribute("allUsers",         allUsers);
        request.setAttribute("deptMembers",      deptMembersList);
        request.setAttribute("employeeFilter",   employeeFilter);
        request.setAttribute("keyword",          keyword);
        request.setAttribute("viewType",         viewType);
        request.setAttribute("relatedType",      relatedType);

        request.setAttribute("ACTIVE_MENU",  "TASK_KANBAN");
        request.setAttribute("pageTitle",    "Kanban Board");
        request.setAttribute("CONTENT_PAGE", "/view/manager/task/task-kanban.jsp");
        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp").forward(request, response);
    }

    private List<Task> filterByRelatedType(List<Task> tasks, String relatedType) {
        if (tasks == null || tasks.isEmpty()) return tasks;
        List<Task> filtered = new ArrayList<>();
        for (Task t : tasks) {
            if (t.getRelatedType() != null && t.getRelatedType().equalsIgnoreCase(relatedType)) {
                filtered.add(t);
            }
        }
        return filtered;
    }
}
