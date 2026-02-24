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

@WebServlet(name = "ManagerTaskListServlet", urlPatterns = {"/manager/task/list"})
public class ManagerTaskListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // FIX: Use getSession(false) — do not create a new session
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

        // Get view type: personal or team
        String viewType = request.getParameter("view");
        if (viewType == null || viewType.isEmpty()) {
            viewType = "personal";
        }

        // Get filter parameters
        String statusFilter   = request.getParameter("status");
        String priorityFilter = request.getParameter("priority");
        String employeeFilter = request.getParameter("employee");
        String keyword        = request.getParameter("keyword");
        String sortBy         = request.getParameter("sortBy");
        String sortOrder      = request.getParameter("sortOrder");

        // Pagination
        int page = 1;
        int pageSize = 20;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        int offset = (page - 1) * pageSize;

        List<Task> taskList = new ArrayList<>();
        int totalTasks = 0;

        // Build team member list (always needed for both views)
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

        if ("personal".equals(viewType)) {
            // Show tasks CREATED BY the manager (personal task list)
            taskList = taskDAO.getTasksByManager(
                    currentUser.getUserId(), statusFilter, priorityFilter,
                    keyword, sortBy, sortOrder, offset, pageSize);
            totalTasks = taskDAO.countTasksByManager(
                    currentUser.getUserId(), statusFilter, priorityFilter, keyword);

        } else if ("team".equals(viewType)) {

            // Parse and VALIDATE selected employee
            Integer selectedEmployee = null;
            if (employeeFilter != null && !employeeFilter.isEmpty()) {
                try {
                    int parsed = Integer.parseInt(employeeFilter);
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

            if (!teamMemberIds.isEmpty()) {
                taskList = taskDAO.getTasksWithFilterForTeam(
                        teamMemberIds, selectedEmployee,
                        statusFilter, priorityFilter, keyword,
                        false, sortBy, sortOrder, offset, pageSize);
                totalTasks = taskDAO.countTasksWithFilterForTeam(
                        teamMemberIds, selectedEmployee,
                        statusFilter, priorityFilter, keyword, false);
            }

            request.setAttribute("teamMembers", teamMembersList);
        }

        int totalPages = (totalTasks == 0) ? 1 : (int) Math.ceil((double) totalTasks / pageSize);

        request.setAttribute("taskList",        taskList);
        request.setAttribute("allUsers",        allUsers);
        request.setAttribute("viewType",        viewType);
        request.setAttribute("statusFilter",    statusFilter);
        request.setAttribute("priorityFilter",  priorityFilter);
        request.setAttribute("employeeFilter",  employeeFilter);
        request.setAttribute("keyword",         keyword);
        request.setAttribute("sortBy",          sortBy);
        request.setAttribute("sortOrder",       sortOrder);
        request.setAttribute("currentPage",     page);
        request.setAttribute("totalPages",      totalPages);
        request.setAttribute("totalTasks",      totalTasks);
        request.setAttribute("pageSize",        pageSize);
        request.setAttribute("taskStatusValues", TaskStatus.values());
        request.setAttribute("priorityValues",   Priority.values());

        request.setAttribute("ACTIVE_MENU",  "TASK_MY_LIST");
        request.setAttribute("pageTitle",    "Quản lý Công việc");
        request.setAttribute("CONTENT_PAGE", "/view/manager/task/task-list.jsp");
        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp").forward(request, response);
    }

}
