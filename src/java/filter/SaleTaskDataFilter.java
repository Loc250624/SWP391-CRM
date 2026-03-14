package filter;

import dao.TaskDAO;
import dao.UserDAO;
import enums.Priority;
import enums.TaskStatus;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import model.Task;
import model.Users;

@WebFilter(urlPatterns = {"/sale/task/list"})
public class SaleTaskDataFilter implements Filter {

    // Whitelist prevents sortBy from being injected into SQL ORDER BY
    private static final Set<String> ALLOWED_SORT_COLUMNS = new HashSet<>(
            Arrays.asList("due_date", "priority", "created_at", "title", "status"));

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        // Auth check
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Users currentUser = (Users) session.getAttribute("user");
        UserDAO userDAO = new UserDAO();
        String roleCode = userDAO.getRoleCodeByUserId(currentUser.getUserId());

        if (!"SALES".equals(roleCode)) {
            resp.sendRedirect(req.getContextPath() + "/error/403.jsp");
            return;
        }

        // Pagination params
        int page = 1;
        int pageSize = 20;
        try {
            String pageParam = req.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        String statusFilter = req.getParameter("status");
        String priorityFilter = req.getParameter("priority");
        String keyword = req.getParameter("keyword");

        // Whitelist sortBy — if not in allowed set, fall back to default
        String sortBy = req.getParameter("sortBy");
        if (sortBy != null && !ALLOWED_SORT_COLUMNS.contains(sortBy)) {
            sortBy = "due_date";
        }

        String sortOrder = req.getParameter("sortOrder");
        if (!"DESC".equalsIgnoreCase(sortOrder)) {
            sortOrder = "ASC";
        }

        int offset = (page - 1) * pageSize;

        TaskDAO taskDAO = new TaskDAO();

        // Sales/Support: only personal assigned tasks
        List<Task> taskList = taskDAO.getTasksWithFilter(
                currentUser.getUserId(), statusFilter, priorityFilter,
                keyword, sortBy, sortOrder, offset, pageSize);
        int totalTasks = taskDAO.countTasksWithFilter(
                currentUser.getUserId(), statusFilter, priorityFilter, keyword);

        int totalPages = (int) Math.ceil((double) totalTasks / pageSize);

        req.setAttribute("taskList", taskList);
        req.setAttribute("totalTasks", totalTasks);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("currentPage", page);
        req.setAttribute("pageSize", pageSize);
        req.setAttribute("statusFilter", statusFilter);
        req.setAttribute("priorityFilter", priorityFilter);
        req.setAttribute("keyword", keyword);
        req.setAttribute("sortBy", sortBy);
        req.setAttribute("sortOrder", sortOrder);
        req.setAttribute("taskStatusValues", TaskStatus.values());
        req.setAttribute("priorityValues", Priority.values());
        req.setAttribute("currentUser", currentUser);
        req.setAttribute("roleCode", roleCode);

        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void destroy() {
    }
}
