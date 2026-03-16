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

@WebServlet(name = "ManagerAllTaskServlet", urlPatterns = {"/manager/task/all"})
public class ManagerAllTaskServlet extends HttpServlet {

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

        // Build ALL dept member list (including manager themselves)
        List<Users> allUsers = userDAO.getAllUsers();
        List<Users> deptMembersList = new ArrayList<>();
        List<Integer> allMemberIds  = new ArrayList<>();

        for (Users user : allUsers) {
            if (user.getDepartmentId() == currentUser.getDepartmentId()) {
                deptMembersList.add(user);
                allMemberIds.add(user.getUserId());
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
        int page     = 1;
        int pageSize = 20;
        try {
            String p = request.getParameter("page");
            if (p != null && !p.isEmpty()) {
                int pv = Integer.parseInt(p);
                if (pv > 0) page = pv;
            }
        } catch (NumberFormatException ignored) { }

        int offset = (page - 1) * pageSize;

        // Validate employee filter (must belong to same dept)
        Integer selectedEmployee = null;
        if (employeeFilter != null && !employeeFilter.trim().isEmpty()) {
            try {
                int parsed = Integer.parseInt(employeeFilter.trim());
                if (allMemberIds.contains(parsed)) {
                    selectedEmployee = parsed;
                } else {
                    session.setAttribute("errorMessage", "Nhân viên không thuộc phòng ban của bạn");
                    employeeFilter = null;
                }
            } catch (NumberFormatException e) {
                employeeFilter = null;
            }
        }

        TaskDAO taskDAO = new TaskDAO();
        List<Task> taskList = new ArrayList<>();
        int totalTasks = 0;

        if (!allMemberIds.isEmpty()) {
            taskList = taskDAO.getAllDeptTasks(
                    allMemberIds, selectedEmployee,
                    statusFilter, priorityFilter, keyword,
                    overdueOnly, null,
                    sortBy, sortOrder, offset, pageSize,
                    false);
            totalTasks = taskDAO.countAllDeptTasks(
                    allMemberIds, selectedEmployee,
                    statusFilter, priorityFilter, keyword,
                    overdueOnly, null,
                    false);
        }

        int totalPages = (totalTasks == 0) ? 1 : (int) Math.ceil((double) totalTasks / pageSize);

        request.setAttribute("taskList",         taskList);
        request.setAttribute("allUsers",         allUsers);
        request.setAttribute("deptMembers",      deptMembersList);
        request.setAttribute("statusFilter",     statusFilter);
        request.setAttribute("priorityFilter",   priorityFilter);
        request.setAttribute("employeeFilter",   employeeFilter);
        request.setAttribute("keyword",          keyword);
        request.setAttribute("sortBy",           sortBy);
        request.setAttribute("sortOrder",        sortOrder);
        request.setAttribute("overdueOnly",      overdueOnly);
        request.setAttribute("currentPage",      page);
        request.setAttribute("totalPages",       totalPages);
        request.setAttribute("totalTasks",       totalTasks);
        request.setAttribute("taskStatusValues", TaskStatus.values());
        request.setAttribute("priorityValues",   Priority.values());

        request.setAttribute("ACTIVE_MENU",  "TASK_ALL");
        request.setAttribute("pageTitle",    "Tất cả Công việc");
        request.setAttribute("CONTENT_PAGE", "/view/manager/task/task-all.jsp");
        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp").forward(request, response);
    }
}
