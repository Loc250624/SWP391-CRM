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

        // Get view type: personal or team
        String viewType = request.getParameter("view");
        if (viewType == null || viewType.isEmpty()) {
            viewType = "personal";
        }

        // Get filter parameters
        String statusFilter = request.getParameter("status");
        String priorityFilter = request.getParameter("priority");
        String employeeFilter = request.getParameter("employee");
        String keyword = request.getParameter("keyword");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");

        // Pagination
        int page = 1;
        int pageSize = 20;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        int offset = (page - 1) * pageSize;

        List<Task> taskList = new ArrayList<>();
        int totalTasks = 0;

        if ("personal".equals(viewType)) {
            // Personal tasks - assigned to current manager
            Integer assignedTo = currentUser.getUserId();
            taskList = taskDAO.getTasksWithFilter(assignedTo, statusFilter, priorityFilter,
                    keyword, sortBy, sortOrder, offset, pageSize);
            totalTasks = taskDAO.countTasksWithFilter(assignedTo, statusFilter, priorityFilter, keyword);

        } else if ("team".equals(viewType)) {
            // Team tasks - get all users in manager's department
            List<Users> teamMembers = userDAO.getAllUsers();
            List<Integer> teamMemberIds = new ArrayList<>();

            for (Users user : teamMembers) {
                if (user.getDepartmentId() == currentUser.getDepartmentId()
                        && user.getUserId() != currentUser.getUserId()) {
                    teamMemberIds.add(user.getUserId());
                }
            }

            // Filter by specific employee if selected
            Integer selectedEmployee = null;
            if (employeeFilter != null && !employeeFilter.isEmpty()) {
                try {
                    selectedEmployee = Integer.parseInt(employeeFilter);
                } catch (NumberFormatException e) {
                    // Ignore
                }
            }

            if (selectedEmployee != null) {
                taskList = taskDAO.getTasksWithFilter(selectedEmployee, statusFilter, priorityFilter,
                        keyword, sortBy, sortOrder, offset, pageSize);
                totalTasks = taskDAO.countTasksWithFilter(selectedEmployee, statusFilter, priorityFilter, keyword);
            } else {
                // Get all team tasks
                if (!teamMemberIds.isEmpty()) {
                    taskList = taskDAO.getTasksByTeam(teamMemberIds);

                    // Apply filters manually for team view
                    taskList = applyFilters(taskList, statusFilter, priorityFilter, keyword);
                    totalTasks = taskList.size();

                    // Apply pagination
                    int fromIndex = Math.min(offset, taskList.size());
                    int toIndex = Math.min(offset + pageSize, taskList.size());
                    taskList = taskList.subList(fromIndex, toIndex);
                }
            }

            // Get team members for dropdown
            List<Users> teamMembersList = new ArrayList<>();
            for (Users user : teamMembers) {
                if (user.getDepartmentId() == currentUser.getDepartmentId()
                        && user.getUserId() != currentUser.getUserId()) {
                    teamMembersList.add(user);
                }
            }
            request.setAttribute("teamMembers", teamMembersList);
        }

        // Get all users for assignee names
        List<Users> allUsers = userDAO.getAllUsers();

        // Calculate pagination info
        int totalPages = (int) Math.ceil((double) totalTasks / pageSize);

        // Set attributes
        request.setAttribute("taskList", taskList);
        request.setAttribute("allUsers", allUsers);
        request.setAttribute("viewType", viewType);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("priorityFilter", priorityFilter);
        request.setAttribute("employeeFilter", employeeFilter);
        request.setAttribute("keyword", keyword);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalTasks", totalTasks);
        request.setAttribute("pageSize", pageSize);

        // Enum values for filters
        request.setAttribute("taskStatusValues", TaskStatus.values());
        request.setAttribute("priorityValues", Priority.values());

        request.setAttribute("ACTIVE_MENU", "TASK_LIST");
        request.setAttribute("pageTitle", "Quản lý Công việc");
        request.setAttribute("CONTENT_PAGE", "/view/manager/task/task-list.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }

    private List<Task> applyFilters(List<Task> tasks, String status, String priority, String keyword) {
        List<Task> filtered = new ArrayList<>();

        for (Task task : tasks) {
            boolean matches = true;

            if (status != null && !status.isEmpty() && !status.equals(task.getStatus())) {
                matches = false;
            }

            if (priority != null && !priority.isEmpty() && !priority.equals(task.getPriority())) {
                matches = false;
            }

            if (keyword != null && !keyword.isEmpty()) {
                String lowerKeyword = keyword.toLowerCase();
                boolean keywordMatch = (task.getTitle() != null && task.getTitle().toLowerCase().contains(lowerKeyword))
                        || (task.getDescription() != null && task.getDescription().toLowerCase().contains(lowerKeyword));
                if (!keywordMatch) {
                    matches = false;
                }
            }

            if (matches) {
                filtered.add(task);
            }
        }

        return filtered;
    }
}
