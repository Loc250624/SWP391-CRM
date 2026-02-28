package controller.manager;

import dao.CustomerDAO;
import dao.LeadDAO;
import dao.TaskDAO;
import dao.UserDAO;
import enums.Priority;
import enums.TaskStatus;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
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

@WebServlet(name = "ManagerTaskListServlet", urlPatterns = { "/manager/task/list" })
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

        // ── View type: mặc định "team" (manager xem toàn bộ nhóm) ──────────
        String viewType = request.getParameter("view");
        if (viewType == null || viewType.isEmpty()) {
            viewType = "team"; // ← ĐỔI: default = team, không phải personal
        }

        // Filters
        String statusFilter   = request.getParameter("status");
        String priorityFilter = request.getParameter("priority");
        String employeeFilter = request.getParameter("employee");
        String keyword        = request.getParameter("keyword");
        String sortBy         = request.getParameter("sortBy");
        String sortOrder      = request.getParameter("sortOrder");

        // Pagination
        int page = 1, pageSize = 10;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            }
        } catch (NumberFormatException e) { page = 1; }
        int offset = (page - 1) * pageSize;

        // ── Build team member list ──────────────────────────────────────────
        List<Users> allUsers         = userDAO.getAllUsers();
        List<Users> teamMembersList  = new ArrayList<>();
        List<Integer> teamMemberIds  = new ArrayList<>(); // thành viên team (trừ manager)
        List<Integer> allDeptIds     = new ArrayList<>(); // toàn bộ dept kể cả manager

        for (Users u : allUsers) {
            if (u.getDepartmentId() == currentUser.getDepartmentId()) {
                allDeptIds.add(u.getUserId());
                if (u.getUserId() != currentUser.getUserId()) {
                    teamMembersList.add(u);
                    teamMemberIds.add(u.getUserId());
                }
            }
        }

        List<Task> taskList = new ArrayList<>();
        int totalTasks = 0;
        Map<Integer, List<Task>> groupMembersMap = new HashMap<>();

        if ("personal".equals(viewType)) {
            // ── Personal: chỉ task do manager tự tạo ────────────────────────
            taskList = taskDAO.getTasksByManager(
                    currentUser.getUserId(),
                    statusFilter, priorityFilter, keyword,
                    sortBy, sortOrder, offset, pageSize);
            totalTasks = taskDAO.countTasksByManager(
                    currentUser.getUserId(),
                    statusFilter, priorityFilter, keyword);

        } else {
            // ── Team view: task giao cho bất kỳ ai trong dept ───────────────
            // FIX: scope dựa trên assigned_to (ai đang cầm task),
            //      KHÔNG dựa vào created_by (ai tạo task).
            //      Marketing có thể tạo lead rồi chuyển cho Sale → Sale là assigned_to.

            Integer selectedEmployee = null;
            if (employeeFilter != null && !employeeFilter.isEmpty()) {
                try {
                    int parsed = Integer.parseInt(employeeFilter);
                    // Validate: nhân viên phải thuộc team manager
                    if (teamMemberIds.contains(parsed)) {
                        selectedEmployee = parsed;
                    } else {
                        session.setAttribute("errorMessage", "Nhân viên không thuộc nhóm của bạn");
                        employeeFilter = null;
                    }
                } catch (NumberFormatException e) { employeeFilter = null; }
            }

            if (!teamMemberIds.isEmpty()) {
                // Dùng allDeptIds (includes manager) cho scope team view
                // hoặc teamMemberIds tùy business rule — ở đây dùng teamMemberIds
                // để manager không thấy task của chính mình trong team view
                int groupCount = taskDAO.countGroupTaskSummaries(
                        teamMemberIds, selectedEmployee, statusFilter, priorityFilter, keyword);
                int indivCount = taskDAO.countTasksWithFilterForTeam(
                        teamMemberIds, selectedEmployee, statusFilter, priorityFilter, keyword, false);

                List<Task> allGroupSummaries = groupCount > 0
                        ? taskDAO.getGroupTaskSummaries(teamMemberIds, selectedEmployee,
                                statusFilter, priorityFilter, keyword, sortBy, sortOrder, 0, groupCount)
                        : new ArrayList<>();
                List<Task> allIndividual = indivCount > 0
                        ? taskDAO.getTasksWithFilterForTeam(teamMemberIds, selectedEmployee,
                                statusFilter, priorityFilter, keyword, false, sortBy, sortOrder, 0, indivCount)
                        : new ArrayList<>();

                for (Task g : allGroupSummaries) {
                    groupMembersMap.put(g.getTaskId(), taskDAO.getGroupTaskMembers(g.getTaskId()));
                }

                List<Task> merged = new ArrayList<>(allGroupSummaries);
                merged.addAll(allIndividual);
                merged.sort(Comparator.comparing(Task::getDueDate,
                        Comparator.nullsLast(Comparator.naturalOrder())));

                totalTasks = merged.size();
                int fromIdx = Math.min(offset, merged.size());
                int toIdx   = Math.min(fromIdx + pageSize, merged.size());
                taskList = new ArrayList<>(merged.subList(fromIdx, toIdx));
            }

            request.setAttribute("teamMembers", teamMembersList);
        }

        // ── Batch load related object names (tránh N+1) ─────────────────────
        // FIX: query bằng assigned_to — không cần filter created_by nữa
        List<Integer> leadIds     = new ArrayList<>();
        List<Integer> customerIds = new ArrayList<>();
        for (Task t : taskList) {
            if ("LEAD".equals(t.getRelatedType()) && t.getRelatedId() != null)
                leadIds.add(t.getRelatedId());
            if ("CUSTOMER".equals(t.getRelatedType()) && t.getRelatedId() != null)
                customerIds.add(t.getRelatedId());
        }

        Map<Integer, String> leadNameMap     = new LeadDAO().getLeadNameMap(leadIds);
        Map<Integer, String> customerNameMap = new CustomerDAO().getCustomerNameMap(customerIds);

        Map<String, String> relatedObjectMap = new HashMap<>();
        for (Map.Entry<Integer, String> e : leadNameMap.entrySet())
            relatedObjectMap.put("LEAD:" + e.getKey(), e.getValue());
        for (Map.Entry<Integer, String> e : customerNameMap.entrySet())
            relatedObjectMap.put("CUSTOMER:" + e.getKey(), e.getValue());

        // ── Statistics (overdue, in-progress, completed today) ───────────────
        // Đếm task quá hạn trong team để hiển thị banner cảnh báo
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

        int totalPages = (totalTasks == 0) ? 1 : (int) Math.ceil((double) totalTasks / pageSize);

        request.setAttribute("relatedObjectMap",  relatedObjectMap);
        request.setAttribute("groupMembersMap",   groupMembersMap);
        request.setAttribute("taskList",          taskList);
        request.setAttribute("allUsers",          allUsers);
        request.setAttribute("viewType",          viewType);
        request.setAttribute("statusFilter",      statusFilter);
        request.setAttribute("priorityFilter",    priorityFilter);
        request.setAttribute("employeeFilter",    employeeFilter);
        request.setAttribute("keyword",           keyword);
        request.setAttribute("sortBy",            sortBy);
        request.setAttribute("sortOrder",         sortOrder);
        request.setAttribute("currentPage",       page);
        request.setAttribute("totalPages",        totalPages);
        request.setAttribute("totalTasks",        totalTasks);
        request.setAttribute("overdueCount",      overdueCount);
        request.setAttribute("pageSize",          pageSize);
        request.setAttribute("taskStatusValues",  TaskStatus.values());
        request.setAttribute("priorityValues",    Priority.values());

        request.setAttribute("ACTIVE_MENU",  "team".equals(viewType) ? "TASK_TEAM_LIST" : "TASK_MY_LIST");
        request.setAttribute("pageTitle",    "Quản lý Công việc");
        request.setAttribute("CONTENT_PAGE", "/view/manager/task/task-list.jsp");
        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp")
               .forward(request, response);
    }
}