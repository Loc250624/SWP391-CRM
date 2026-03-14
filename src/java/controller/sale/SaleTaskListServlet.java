package controller.sale;

import dao.TaskDAO;
import dao.UserDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Task;
import model.Users;

@WebServlet(name = "SaleTaskListServlet", urlPatterns = {"/sale/task/list"})
public class SaleTaskListServlet extends HttpServlet {

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

        if (!"SALES".equals(roleCode)) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        String viewType    = request.getParameter("view");        // personal | group
        String keyword     = request.getParameter("keyword");
        String relatedType = request.getParameter("relatedType"); // LEAD | CUSTOMER

        TaskDAO taskDAO = new TaskDAO();
        List<Integer> memberIds = Collections.singletonList(currentUser.getUserId());

        List<Task> pendingTasks    = new ArrayList<>();
        List<Task> inProgressTasks = new ArrayList<>();
        List<Task> completedTasks  = new ArrayList<>();
        List<Task> cancelledTasks  = new ArrayList<>();

        boolean isGroupView = "group".equalsIgnoreCase(viewType);
        if (isGroupView) {
            pendingTasks    = taskDAO.getGroupTaskSummaries(memberIds, currentUser.getUserId(), "PENDING",     null, keyword, "priority", "DESC", 0, 500);
            inProgressTasks = taskDAO.getGroupTaskSummaries(memberIds, currentUser.getUserId(), "IN_PROGRESS", null, keyword, "priority", "DESC", 0, 500);
            completedTasks  = taskDAO.getGroupTaskSummaries(memberIds, currentUser.getUserId(), "COMPLETED",   null, keyword, "created_at", "DESC", 0, 200);
            cancelledTasks  = taskDAO.getGroupTaskSummaries(memberIds, currentUser.getUserId(), "CANCELLED",   null, keyword, "created_at", "DESC", 0, 200);
        } else {
            pendingTasks    = taskDAO.getTasksWithFilterForTeam(memberIds, currentUser.getUserId(), "PENDING",     null, keyword, false, "priority", "DESC", 0, 500);
            inProgressTasks = taskDAO.getTasksWithFilterForTeam(memberIds, currentUser.getUserId(), "IN_PROGRESS", null, keyword, false, "priority", "DESC", 0, 500);
            completedTasks  = taskDAO.getTasksWithFilterForTeam(memberIds, currentUser.getUserId(), "COMPLETED",   null, keyword, false, "created_at", "DESC", 0, 200);
            cancelledTasks  = taskDAO.getTasksWithFilterForTeam(memberIds, currentUser.getUserId(), "CANCELLED",   null, keyword, false, "created_at", "DESC", 0, 200);
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

        request.setAttribute("inProgressTasks", inProgressTasks);
        request.setAttribute("completedTasks",  completedTasks);
        request.setAttribute("cancelledTasks",  cancelledTasks);
        request.setAttribute("viewType",        viewType);
        request.setAttribute("keyword",         keyword);
        request.setAttribute("relatedType",     relatedType);
        request.setAttribute("currentUser",     currentUser);

        request.setAttribute("ACTIVE_MENU", "TASK_LIST");
        request.setAttribute("pageTitle", "Kanban Tasks");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/task/list.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
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
