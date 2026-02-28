package controller.manager;

import dao.TaskDAO;
import dao.UserDAO;
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

/**
 * POST /manager/task/bulk-action
 * Params: taskIds[] (selected task IDs), action (STATUS | REASSIGN),
 *         newStatus or newAssignee
 */
@WebServlet(name = "ManagerTaskBulkActionServlet", urlPatterns = {"/manager/task/bulk-action"})
public class ManagerTaskBulkActionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

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

        String[] taskIdStrs = request.getParameterValues("taskIds");
        String action = request.getParameter("action");

        String redirectBack = request.getContextPath() + "/manager/task/list?view=team";

        if (taskIdStrs == null || taskIdStrs.length == 0) {
            session.setAttribute("errorMessage", "Chưa chọn công việc nào");
            response.sendRedirect(redirectBack);
            return;
        }

        // Resolve valid task IDs belonging to manager's department
        TaskDAO taskDAO = new TaskDAO();
        List<Users> deptMembers = userDAO.getUsersByDepartment(currentUser.getDepartmentId());
        List<Integer> deptMemberIds = new ArrayList<>();
        for (Users u : deptMembers) deptMemberIds.add(u.getUserId());

        List<Task> validTasks = new ArrayList<>();
        for (String idStr : taskIdStrs) {
            try {
                int tid = Integer.parseInt(idStr.trim());
                Task t = taskDAO.getTaskById(tid);
                if (t != null && t.getAssignedTo() != null
                        && deptMemberIds.contains(t.getAssignedTo())) {
                    validTasks.add(t);
                }
            } catch (NumberFormatException ignored) {}
        }

        if (validTasks.isEmpty()) {
            session.setAttribute("errorMessage", "Không có công việc hợp lệ để xử lý");
            response.sendRedirect(redirectBack);
            return;
        }

        if ("STATUS".equals(action)) {
            String newStatus = request.getParameter("newStatus");
            try { TaskStatus.valueOf(newStatus); }
            catch (IllegalArgumentException | NullPointerException e) {
                session.setAttribute("errorMessage", "Trạng thái không hợp lệ");
                response.sendRedirect(redirectBack);
                return;
            }
            int updated = 0;
            for (Task t : validTasks) {
                if (!"COMPLETED".equals(t.getStatusName()) && !"CANCELLED".equals(t.getStatusName())) {
                    t.setStatus(TaskStatus.valueOf(newStatus).ordinal());
                    if (taskDAO.updateTask(t)) updated++;
                }
            }
            session.setAttribute("successMessage", "Đã cập nhật trạng thái cho " + updated + " công việc");

        } else if ("REASSIGN".equals(action)) {
            String newAssigneeStr = request.getParameter("newAssignee");
            int newAssigneeId;
            try { newAssigneeId = Integer.parseInt(newAssigneeStr.trim()); }
            catch (NumberFormatException | NullPointerException e) {
                session.setAttribute("errorMessage", "Người thực hiện không hợp lệ");
                response.sendRedirect(redirectBack);
                return;
            }
            if (!deptMemberIds.contains(newAssigneeId)) {
                session.setAttribute("errorMessage", "Nhân viên không thuộc phòng ban của bạn");
                response.sendRedirect(redirectBack);
                return;
            }
            int updated = 0;
            for (Task t : validTasks) {
                if (taskDAO.updateTaskAssignedTo(t.getTaskId(), newAssigneeId)) updated++;
            }
            session.setAttribute("successMessage", "Đã giao lại " + updated + " công việc");

        } else {
            session.setAttribute("errorMessage", "Hành động không hợp lệ");
        }

        response.sendRedirect(redirectBack);
    }
}
