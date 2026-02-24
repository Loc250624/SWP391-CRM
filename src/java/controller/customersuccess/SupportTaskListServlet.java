package controller.customersuccess;

import dao.TaskDAO;
import dao.UserDAO;
import enums.Priority;
import enums.TaskStatus;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Task;
import model.Users;

@WebServlet(name = "SupportTaskListServlet", urlPatterns = {"/support/task/list"})
public class SupportTaskListServlet extends HttpServlet {

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

        if (!"SUPPORT".equals(roleCode)) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        // Pagination params
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

        String statusFilter = request.getParameter("status");
        String priorityFilter = request.getParameter("priority");
        String keyword = request.getParameter("keyword");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");

        int offset = (page - 1) * pageSize;

        TaskDAO taskDAO = new TaskDAO();

        // Support: only personal assigned tasks
        List<Task> taskList = taskDAO.getTasksWithFilter(
                currentUser.getUserId(), statusFilter, priorityFilter,
                keyword, sortBy, sortOrder, offset, pageSize);
        int totalTasks = taskDAO.countTasksWithFilter(
                currentUser.getUserId(), statusFilter, priorityFilter, keyword);

        int totalPages = (int) Math.ceil((double) totalTasks / pageSize);

        request.setAttribute("taskList", taskList);
        request.setAttribute("totalTasks", totalTasks);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("priorityFilter", priorityFilter);
        request.setAttribute("keyword", keyword);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);
        request.setAttribute("taskStatusValues", TaskStatus.values());
        request.setAttribute("priorityValues", Priority.values());
        request.setAttribute("currentUser", currentUser);

        request.setAttribute("pageTitle", "Công việc của tôi");
        request.setAttribute("contentPage", "/view/support/task/task-list.jsp");
        request.getRequestDispatcher("/view/customersuccess/main_layout.jsp").forward(request, response);
    }
}
