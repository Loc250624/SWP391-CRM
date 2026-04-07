package controller.manager;

import dao.CustomerDAO;
import dao.LeadDAO;
import dao.TaskDAO;
import dao.UserDAO;
import enums.Priority;
import enums.TaskStatus;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
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

        // ── Workload mode: show all tasks assigned to a specific employee ──
        String source = request.getParameter("source");
        if ("workload".equals(source)) {
            handleWorkloadView(request, response, currentUser, taskDAO, userDAO);
            return;
        }

        // ── Task type: "personal" (default) or "team" ────────────────────────
        String taskType = request.getParameter("taskType");
        if (taskType == null || taskType.isEmpty()) {
            taskType = "personal";
        }

        // ── View type: "lead" (default) or "customer" ───────────────────────
        String viewType = request.getParameter("view");
        if (viewType == null || viewType.isEmpty()) {
            viewType = "lead";
        }
        String filterRelatedType = "customer".equals(viewType) ? "CUSTOMER" : "LEAD";

        // Filters
        String statusFilter = request.getParameter("status");
        String priorityFilter = request.getParameter("priority");
        String employeeFilter = request.getParameter("employee");
        String keyword = request.getParameter("keyword");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");

        // Pagination
        int page = 1, pageSize = 10;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        // ── Build team member list (SALES + SUPPORT roles) ──────────────────
        List<Users> salesUsers = userDAO.getUsersByRoleCode("SALES");
        List<Users> supportUsers = userDAO.getUsersByRoleCode("SUPPORT");
        List<Users> teamMembersList = new ArrayList<>();
        List<Integer> teamMemberIds = new ArrayList<>();

        for (Users u : salesUsers) {
            if (u.getUserId() != currentUser.getUserId()) {
                if (!teamMemberIds.contains(u.getUserId())) {
                    teamMembersList.add(u);
                    teamMemberIds.add(u.getUserId());
                }
            }
        }
        for (Users u : supportUsers) {
            if (u.getUserId() != currentUser.getUserId()) {
                if (!teamMemberIds.contains(u.getUserId())) {
                    teamMembersList.add(u);
                    teamMemberIds.add(u.getUserId());
                }
            }
        }

        // ── Fetch ALL tasks created by this manager (no assignee-count restriction) ──
        List<Task> managerTasks = taskDAO.getAllTasksByCreator(
                currentUser.getUserId(),
                statusFilter, priorityFilter, keyword,
                sortBy, sortOrder);

        // ── Split into personal (assignee <= 1) and team (assignee > 1) ─────
        List<Task> allTasks = new ArrayList<>();
        Map<Integer, List<Task>> groupMembersMap = new HashMap<>();

        if ("team".equals(taskType)) {
            for (Task t : managerTasks) {
                int assigneeCount = taskDAO.countAssignees(t.getTaskId());
                if (assigneeCount > 1) {
                    t.setGroupTaskId(t.getTaskId());
                    allTasks.add(t);
                    groupMembersMap.put(t.getTaskId(), taskDAO.getGroupTaskMembers(t.getTaskId()));
                }
            }
            // Employee filter for team tasks
            if (employeeFilter != null && !employeeFilter.isEmpty()) {
                try {
                    int empId = Integer.parseInt(employeeFilter);
                    List<Task> filtered = new ArrayList<>();
                    for (Task t : allTasks) {
                        List<Task> members = groupMembersMap.get(t.getTaskId());
                        if (members != null) {
                            for (Task m : members) {
                                if (m.getAssignedTo() != null && m.getAssignedTo() == empId) {
                                    filtered.add(t);
                                    break;
                                }
                            }
                        }
                    }
                    allTasks = filtered;
                } catch (NumberFormatException ignored) {
                    employeeFilter = null;
                }
            }
        } else {
            for (Task t : managerTasks) {
                int assigneeCount = taskDAO.countAssignees(t.getTaskId());
                if (assigneeCount <= 1) {
                    allTasks.add(t);
                }
            }
        }

        // ── Filter by relatedType (LEAD or CUSTOMER) ────────────────────────
        List<Task> filteredTasks = new ArrayList<>();
        for (Task t : allTasks) {
            if (filterRelatedType.equals(t.getRelatedType())) {
                filteredTasks.add(t);
            }
        }

        // ── Java-side pagination ─────────────────────────────────────────────
        int totalTasks = filteredTasks.size();
        int offset = (page - 1) * pageSize;
        int fromIndex = Math.min(offset, totalTasks);
        int toIndex = Math.min(offset + pageSize, totalTasks);
        List<Task> taskList = filteredTasks.subList(fromIndex, toIndex);

        int totalPages = (totalTasks == 0) ? 1 : (int) Math.ceil((double) totalTasks / pageSize);

        // ── allUsers for JSP member lookup ──────────────────────────────────
        List<Users> allUsersList = new ArrayList<>();
        allUsersList.addAll(salesUsers);
        for (Users su : supportUsers) {
            boolean exists = false;
            for (Users au : allUsersList) {
                if (au.getUserId() == su.getUserId()) { exists = true; break; }
            }
            if (!exists) allUsersList.add(su);
        }

        // ── Batch load related object names ─────────────────────────────────
        List<Integer> leadIds = new ArrayList<>();
        List<Integer> customerIds = new ArrayList<>();
        for (Task t : taskList) {
            if ("LEAD".equals(t.getRelatedType()) && t.getRelatedId() != null) {
                leadIds.add(t.getRelatedId());
            }
            if ("CUSTOMER".equals(t.getRelatedType()) && t.getRelatedId() != null) {
                customerIds.add(t.getRelatedId());
            }
        }

        Map<Integer, String> leadNameMap = new LeadDAO().getLeadNameMap(leadIds);
        Map<Integer, String> customerNameMap = new CustomerDAO().getCustomerNameMap(customerIds);

        Map<String, String> relatedObjectMap = new HashMap<>();
        for (Map.Entry<Integer, String> e : leadNameMap.entrySet()) {
            relatedObjectMap.put("LEAD:" + e.getKey(), e.getValue());
        }
        for (Map.Entry<Integer, String> e : customerNameMap.entrySet()) {
            relatedObjectMap.put("CUSTOMER:" + e.getKey(), e.getValue());
        }

        // ── Overdue count ───────────────────────────────────────────────────
        int overdueCount = 0;
        java.time.LocalDate today = java.time.LocalDate.now();
        for (Task t : taskList) {
            if (t.getDueDate() != null
                    && t.getDueDate().toLocalDate().isBefore(today)
                    && !"COMPLETED".equals(t.getStatusName())
                    && !"CANCELLED".equals(t.getStatusName())) {
                overdueCount++;
            }
        }

        // ── Count tasks per type (for tab badges) ───────────────────────────
        int leadCount = 0, customerCount = 0;
        for (Task t : allTasks) {
            if ("LEAD".equals(t.getRelatedType())) leadCount++;
            else if ("CUSTOMER".equals(t.getRelatedType())) customerCount++;
        }

        request.setAttribute("relatedObjectMap", relatedObjectMap);
        request.setAttribute("groupMembersMap", groupMembersMap);
        request.setAttribute("taskList", taskList);
        request.setAttribute("allUsers", allUsersList);
        request.setAttribute("teamMembers", teamMembersList);
        request.setAttribute("taskType", taskType);
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
        request.setAttribute("overdueCount", overdueCount);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("leadCount", leadCount);
        request.setAttribute("customerCount", customerCount);
        request.setAttribute("taskStatusValues", TaskStatus.values());
        request.setAttribute("priorityValues", Priority.values());

        request.setAttribute("ACTIVE_MENU", "customer".equals(viewType) ? "TASK_CUSTOMER_LIST" : "TASK_LEAD_LIST");
        request.setAttribute("pageTitle", "Quản lý Công việc");
        request.setAttribute("CONTENT_PAGE", "/view/manager/task/task-list.jsp");
        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp")
                .forward(request, response);
    }

    /**
     * Handles workload view: shows ALL tasks assigned to a specific employee.
     */
    private void handleWorkloadView(HttpServletRequest request, HttpServletResponse response,
            Users currentUser, TaskDAO taskDAO, UserDAO userDAO)
            throws ServletException, IOException {

        String employeeParam = request.getParameter("employee");
        if (employeeParam == null || employeeParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/manager/task/workload");
            return;
        }

        int employeeId;
        try {
            employeeId = Integer.parseInt(employeeParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manager/task/workload");
            return;
        }

        // Get employee info
        Users employee = userDAO.getUserById(employeeId);
        if (employee == null) {
            response.sendRedirect(request.getContextPath() + "/manager/task/workload");
            return;
        }
        String employeeName = ((employee.getFirstName() != null ? employee.getFirstName() : "")
                + " " + (employee.getLastName() != null ? employee.getLastName() : "")).trim();

        // Get ALL tasks assigned to this employee
        List<Task> allEmployeeTasks = taskDAO.getTasksByUser(employeeId);

        // Apply filters
        String statusFilter = request.getParameter("status");
        String priorityFilter = request.getParameter("priority");
        String keyword = request.getParameter("keyword");

        List<Task> filteredTasks = new ArrayList<>();
        for (Task t : allEmployeeTasks) {
            if (statusFilter != null && !statusFilter.isEmpty()) {
                if (!statusFilter.equalsIgnoreCase(t.getStatusName())) continue;
            }
            if (priorityFilter != null && !priorityFilter.isEmpty()) {
                if (!priorityFilter.equalsIgnoreCase(t.getPriorityName())) continue;
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = keyword.trim().toLowerCase();
                if (t.getTitle() == null || !t.getTitle().toLowerCase().contains(kw)) continue;
            }
            filteredTasks.add(t);
        }

        // Pagination
        int page = 1, pageSize = 10;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            }
        } catch (NumberFormatException e) { page = 1; }

        int totalTasks = filteredTasks.size();
        int offset = (page - 1) * pageSize;
        int fromIndex = Math.min(offset, totalTasks);
        int toIndex = Math.min(offset + pageSize, totalTasks);
        List<Task> taskList = filteredTasks.subList(fromIndex, toIndex);
        int totalPages = (totalTasks == 0) ? 1 : (int) Math.ceil((double) totalTasks / pageSize);

        // Batch load related object names
        List<Integer> leadIds = new ArrayList<>();
        List<Integer> customerIds = new ArrayList<>();
        for (Task t : taskList) {
            if ("LEAD".equals(t.getRelatedType()) && t.getRelatedId() != null) leadIds.add(t.getRelatedId());
            if ("CUSTOMER".equals(t.getRelatedType()) && t.getRelatedId() != null) customerIds.add(t.getRelatedId());
        }
        Map<Integer, String> leadNameMap = new LeadDAO().getLeadNameMap(leadIds);
        Map<Integer, String> customerNameMap = new CustomerDAO().getCustomerNameMap(customerIds);
        Map<String, String> relatedObjectMap = new HashMap<>();
        for (Map.Entry<Integer, String> e : leadNameMap.entrySet()) {
            relatedObjectMap.put("LEAD:" + e.getKey(), e.getValue());
        }
        for (Map.Entry<Integer, String> e : customerNameMap.entrySet()) {
            relatedObjectMap.put("CUSTOMER:" + e.getKey(), e.getValue());
        }

        // Overdue count
        int overdueCount = 0;
        java.time.LocalDate today = java.time.LocalDate.now();
        for (Task t : taskList) {
            if (t.getDueDate() != null
                    && t.getDueDate().toLocalDate().isBefore(today)
                    && !"COMPLETED".equals(t.getStatusName())
                    && !"CANCELLED".equals(t.getStatusName())) {
                overdueCount++;
            }
        }

        // All users for display
        List<Users> allUsersList = userDAO.getAllUsers();

        request.setAttribute("relatedObjectMap", relatedObjectMap);
        request.setAttribute("groupMembersMap", new HashMap<>());
        request.setAttribute("taskList", taskList);
        request.setAttribute("allUsers", allUsersList);
        request.setAttribute("teamMembers", new ArrayList<>());
        request.setAttribute("taskType", "workload");
        request.setAttribute("viewType", "all");
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("priorityFilter", priorityFilter);
        request.setAttribute("employeeFilter", employeeParam);
        request.setAttribute("keyword", keyword);
        request.setAttribute("sortBy", request.getParameter("sortBy"));
        request.setAttribute("sortOrder", request.getParameter("sortOrder"));
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalTasks", totalTasks);
        request.setAttribute("overdueCount", overdueCount);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("leadCount", 0);
        request.setAttribute("customerCount", 0);
        request.setAttribute("taskStatusValues", enums.TaskStatus.values());
        request.setAttribute("priorityValues", enums.Priority.values());
        request.setAttribute("workloadEmployee", employeeName);
        request.setAttribute("workloadEmployeeId", employeeId);

        request.setAttribute("ACTIVE_MENU", "TASK_WORKLOAD");
        request.setAttribute("pageTitle", "Công việc của " + employeeName);
        request.setAttribute("CONTENT_PAGE", "/view/manager/task/task-list.jsp");
        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp")
                .forward(request, response);
    }
}
