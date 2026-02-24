package controller.manager;

import dao.CustomerDAO;
import dao.LeadDAO;
import dao.OpportunityDAO;
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
import model.Customer;
import model.Lead;
import model.Opportunity;
import model.Task;
import model.Users;

@WebServlet(name = "ManagerTaskDetailServlet", urlPatterns = {"/manager/task/detail"})
public class ManagerTaskDetailServlet extends HttpServlet {

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

        String taskIdStr = request.getParameter("id");
        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "ID công việc không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/manager/task/list");
            return;
        }

        try {
            int taskId = Integer.parseInt(taskIdStr.trim());
            TaskDAO taskDAO = new TaskDAO();
            Task task = taskDAO.getTaskById(taskId);

            if (task == null) {
                session.setAttribute("errorMessage", "Không tìm thấy công việc");
                response.sendRedirect(request.getContextPath() + "/manager/task/list");
                return;
            }

            // Assigned user info
            Users assignedUser = null;
            if (task.getAssignedTo() != null) {
                assignedUser = userDAO.getUserById(task.getAssignedTo());
            }

            // Creator info
            Users creator = null;
            if (task.getCreatedBy() != null) {
                creator = userDAO.getUserById(task.getCreatedBy());
            }

            // Related object info
            Object relatedObject    = null;
            String relatedObjectName = null;

            if (task.getRelatedType() != null && task.getRelatedId() != null) {
                switch (task.getRelatedType()) {
                    case "Lead": {
                        Lead lead = new LeadDAO().getLeadById(task.getRelatedId());
                        if (lead != null) {
                            relatedObject     = lead;
                            relatedObjectName = lead.getFullName() + " (" + lead.getLeadCode() + ")";
                        }
                        break;
                    }
                    case "Customer": {
                        Customer customer = new CustomerDAO().getCustomerById(task.getRelatedId());
                        if (customer != null) {
                            relatedObject     = customer;
                            relatedObjectName = customer.getFullName() + " (" + customer.getCustomerCode() + ")";
                        }
                        break;
                    }
                    case "Opportunity": {
                        Opportunity opp = new OpportunityDAO().getOpportunityById(task.getRelatedId());
                        if (opp != null) {
                            relatedObject     = opp;
                            relatedObjectName = opp.getOpportunityName() + " (" + opp.getOpportunityCode() + ")";
                        }
                        break;
                    }
                    default:
                        break;
                }
            }

            // ── Subtask loading ──
            List<Task> subtasks = taskDAO.getSubtasksByParentId(taskId);
            int subtaskCount = subtasks.size();
            long completedSubtaskCount = subtasks.stream()
                    .filter(t -> "COMPLETED".equals(t.getStatus())).count();

            // ── Dependency loading ──
            List<Integer> depIds = TaskDAO.parseDependencyIds(task.getDescription());
            List<Task> dependencyTasks = depIds.isEmpty()
                    ? Collections.emptyList()
                    : taskDAO.getTasksByIds(depIds);
            boolean allDepsCompleted = dependencyTasks.stream()
                    .allMatch(t -> "COMPLETED".equals(t.getStatus()));
            String cleanDescription = TaskDAO.getCleanDescription(task.getDescription());

            // ── All users for subtask assignee dropdown ──
            List<Users> allUsers = userDAO.getAllUsers();

            request.setAttribute("task",                 task);
            request.setAttribute("assignedUser",         assignedUser);
            request.setAttribute("creator",              creator);
            request.setAttribute("relatedObject",        relatedObject);
            request.setAttribute("relatedObjectName",    relatedObjectName);
            request.setAttribute("subtasks",             subtasks);
            request.setAttribute("subtaskCount",         subtaskCount);
            request.setAttribute("completedSubtaskCount", completedSubtaskCount);
            request.setAttribute("dependencyTasks",      dependencyTasks);
            request.setAttribute("allDepsCompleted",     allDepsCompleted);
            request.setAttribute("cleanDescription",     cleanDescription);
            request.setAttribute("allUsers",             allUsers);

            request.setAttribute("ACTIVE_MENU",  "TASK_MY_LIST");
            request.setAttribute("pageTitle",    "Chi tiết Công việc");
            request.setAttribute("CONTENT_PAGE", "/view/manager/task/task-detail.jsp");
            request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID công việc không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/manager/task/list");
        }
    }
}
