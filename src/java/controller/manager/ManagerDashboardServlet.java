package controller.manager;

import dao.CustomerDAO;
import dao.LeadDAO;
import dao.TaskDAO;
import dao.UserDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Lead;
import model.Task;
import model.Users;

@WebServlet(name = "ManagerDashboardServlet", urlPatterns = {"/manager/dashboard"})
public class ManagerDashboardServlet extends HttpServlet {

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

        int departmentId = currentUser.getDepartmentId();
        int managerId    = currentUser.getUserId();

        // ── Department members ──
        List<Users> allUsers = userDAO.getAllUsers();
        List<Users> deptMembers = new ArrayList<>();
        List<Integer> memberIds = new ArrayList<>();
        for (Users u : allUsers) {
            if (u.getDepartmentId() == departmentId) {
                deptMembers.add(u);
                memberIds.add(u.getUserId());
            }
        }

        TaskDAO taskDAO = new TaskDAO();
        LeadDAO leadDAO = new LeadDAO();
        CustomerDAO customerDAO = new CustomerDAO();

        // ── 1. KPI Cards: Task stats for department ──
        int totalTasks     = 0;
        int completedTasks = 0;
        int inProgressTasks = 0;
        int pendingTasks   = 0;
        int overdueTasks   = 0;
        int cancelledTasks = 0;

        // Per-employee stats for charts
        List<String> empNames = new ArrayList<>();
        List<Integer> empCompleted = new ArrayList<>();
        List<Integer> empInProgress = new ArrayList<>();
        List<Integer> empPending = new ArrayList<>();
        List<Integer> empOverdue = new ArrayList<>();
        List<Double> empProductivity = new ArrayList<>();

        for (Users member : deptMembers) {
            Map<String, Object> stats = taskDAO.getEmployeePerformanceStats(member.getUserId());
            int total = ((Number) stats.getOrDefault("totalTasks", 0)).intValue();
            int completed = ((Number) stats.getOrDefault("completedTasks", 0)).intValue();
            int inProg = ((Number) stats.getOrDefault("inProgressTasks", 0)).intValue();
            int pending = ((Number) stats.getOrDefault("pendingTasks", 0)).intValue();
            int overdue = ((Number) stats.getOrDefault("overdueTasks", 0)).intValue();
            int cancelled = ((Number) stats.getOrDefault("cancelledTasks", 0)).intValue();
            double productivity = ((Number) stats.getOrDefault("productivityScore", 0.0)).doubleValue();

            totalTasks += total;
            completedTasks += completed;
            inProgressTasks += inProg;
            pendingTasks += pending;
            overdueTasks += overdue;
            cancelledTasks += cancelled;

            String name = (member.getFirstName() != null ? member.getFirstName() : "")
                        + " " + (member.getLastName() != null ? member.getLastName() : "");
            empNames.add(name.trim());
            empCompleted.add(completed);
            empInProgress.add(inProg);
            empPending.add(pending);
            empOverdue.add(overdue);
            empProductivity.add(Math.round(productivity * 10.0) / 10.0);
        }

        // ── 2. Lead stats ──
        int unassignedLeads = leadDAO.countUnassignedLeadsForManager(null, null, null, null);
        int assignedLeads   = leadDAO.countAssignedLeadsByManager(managerId, null, null, null, null, null);

        // ── 3. SLA stats ──
        Map<String, Integer> slaStats = taskDAO.getSLAStatsByMemberIds(memberIds);

        // ── 4. Overdue tasks ──
        List<Task> overdueTaskList = taskDAO.getOverdueTasks(null, memberIds);
        int overdueCount = overdueTaskList.size();
        // Limit to 5 for display
        List<Task> recentOverdue = overdueTaskList.size() > 5
                ? overdueTaskList.subList(0, 5) : overdueTaskList;

        // Build assignee name map for overdue tasks
        java.util.Map<Integer, String> userNameMap = new java.util.HashMap<>();
        for (Users u : deptMembers) {
            String n = (u.getFirstName() != null ? u.getFirstName() : "")
                     + " " + (u.getLastName() != null ? u.getLastName() : "");
            userNameMap.put(u.getUserId(), n.trim());
        }

        // ── Completion rate ──
        int activeTasks = totalTasks - cancelledTasks;
        double completionRate = activeTasks > 0 ? (completedTasks * 100.0 / activeTasks) : 0;

        // ── Set attributes ──
        // KPI cards
        request.setAttribute("totalTasks",      totalTasks);
        request.setAttribute("completedTasks",  completedTasks);
        request.setAttribute("inProgressTasks", inProgressTasks);
        request.setAttribute("pendingTasks",    pendingTasks);
        request.setAttribute("overdueTasks",    overdueTasks);
        request.setAttribute("completionRate",  Math.round(completionRate * 10.0) / 10.0);

        // Lead stats
        request.setAttribute("unassignedLeads", unassignedLeads);
        request.setAttribute("assignedLeads",   assignedLeads);

        // SLA
        request.setAttribute("slaTotal",    slaStats.getOrDefault("total", 0));
        request.setAttribute("slaOk",       slaStats.getOrDefault("ok", 0));
        request.setAttribute("slaBreached", slaStats.getOrDefault("breached", 0));

        // Overdue
        request.setAttribute("overdueCount",   overdueCount);
        request.setAttribute("recentOverdue",  recentOverdue);
        request.setAttribute("userNameMap",    userNameMap);

        // Chart data (JSON arrays)
        request.setAttribute("empNamesJson",        toJsonStringArray(empNames));
        request.setAttribute("empCompletedJson",    empCompleted.toString());
        request.setAttribute("empInProgressJson",   empInProgress.toString());
        request.setAttribute("empPendingJson",      empPending.toString());
        request.setAttribute("empOverdueJson",      empOverdue.toString());
        request.setAttribute("empProductivityJson", empProductivity.toString());

        // Pie chart data
        request.setAttribute("chartCompleted",  completedTasks);
        request.setAttribute("chartInProgress", inProgressTasks);
        request.setAttribute("chartPending",    pendingTasks);
        request.setAttribute("chartOverdue",    overdueTasks);
        request.setAttribute("chartCancelled",  cancelledTasks);

        // Team size
        request.setAttribute("teamSize", deptMembers.size());

        request.setAttribute("ACTIVE_MENU",  "DASHBOARD");
        request.setAttribute("pageTitle",    "Dashboard");
        request.setAttribute("CONTENT_PAGE", "/view/manager/dashboard.jsp");
        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp").forward(request, response);
    }

    private String toJsonStringArray(List<String> list) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append("\"").append(list.get(i).replace("\"", "\\\"")).append("\"");
        }
        sb.append("]");
        return sb.toString();
    }
}
