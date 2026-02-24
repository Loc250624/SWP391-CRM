package controller.manager;

import dao.TaskDAO;
import dao.UserDAO;
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

@WebServlet(name = "ManagerTaskAssignServlet", urlPatterns = {"/manager/task/assign"})
public class ManagerTaskAssignServlet extends HttpServlet {

    // ------------------------------------------------------------------ GET --
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

        String taskIdStr = request.getParameter("id");
        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
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

            List<Users> allUsers = userDAO.getAllUsers();
            List<Users> teamMembersList = new ArrayList<>();

            for (Users user : allUsers) {
                if (user.getDepartmentId() == currentUser.getDepartmentId()
                        && user.getUserId() != currentUser.getUserId()) {
                    teamMembersList.add(user);
                }
            }

            // Resolve current assignee
            Users currentAssignee = null;
            if (task.getAssignedTo() != null) {
                currentAssignee = userDAO.getUserById(task.getAssignedTo());
            }

            request.setAttribute("task",            task);
            request.setAttribute("allUsers",         teamMembersList);   // Only show team members
            request.setAttribute("currentAssignee", currentAssignee);
            request.setAttribute("pageTitle",        "Gán Công việc");
            request.setAttribute("ACTIVE_MENU",      "TASK_MY_LIST");
            request.setAttribute("CONTENT_PAGE",     "/view/manager/task/task-assign.jsp");
            request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manager/task/list");
        }
    }

    // ----------------------------------------------------------------- POST --
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

        String taskIdStr     = request.getParameter("taskId");
        String assignedToStr = request.getParameter("assignedTo");

        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
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

            if (assignedToStr == null || assignedToStr.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Vui lòng chọn người thực hiện");
                response.sendRedirect(request.getContextPath() + "/manager/task/assign?id=" + taskId);
                return;
            }

            int newAssigneeId;
            try {
                newAssigneeId = Integer.parseInt(assignedToStr.trim());
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Người thực hiện không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/manager/task/assign?id=" + taskId);
                return;
            }

            // Security: new assignee must be in manager's team
            List<Users> allUsers = userDAO.getAllUsers();
            boolean validAssignee = false;
            for (Users user : allUsers) {
                if (user.getUserId() == newAssigneeId
                        && user.getDepartmentId() == currentUser.getDepartmentId()
                        && user.getUserId() != currentUser.getUserId()) {
                    validAssignee = true;
                    break;
                }
            }

            if (!validAssignee) {
                session.setAttribute("errorMessage", "Nhân viên không thuộc nhóm của bạn");
                response.sendRedirect(request.getContextPath() + "/manager/task/assign?id=" + taskId);
                return;
            }

            task.setAssignedTo(newAssigneeId);
            boolean success = taskDAO.updateTask(task);

            if (success) {
                session.setAttribute("successMessage", "Gán công việc thành công");
                response.sendRedirect(request.getContextPath() + "/manager/task/detail?id=" + taskId);
            } else {
                session.setAttribute("errorMessage", "Gán công việc thất bại");
                response.sendRedirect(request.getContextPath() + "/manager/task/assign?id=" + taskId);
            }

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID công việc không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/manager/task/list");
        }
    }
}
