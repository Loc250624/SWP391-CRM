package controller.manager;

import dao.TaskAssigneeDAO;
import dao.TaskDAO;
import dao.UserDAO;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Task;
import model.TaskAssignee;
import model.Users;

/**
 * POST /manager/task/reassign
 * Handles 3 reassignment modes:
 *   mode=INDIVIDUAL  — 1→1 reassign with optional audit note
 *   mode=TO_GROUP    — individual→group: keep original + add new members
 *   mode=FROM_GROUP  — group→individual: keep one member, cancel the rest
 */
@WebServlet(name = "ManagerTaskReassignServlet", urlPatterns = {"/manager/task/reassign"})
public class ManagerTaskReassignServlet extends HttpServlet {

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

        String taskIdStr = request.getParameter("taskId");
        String mode      = request.getParameter("mode"); // INDIVIDUAL | TO_GROUP | FROM_GROUP
        String reason    = request.getParameter("reason");

        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "ID công việc không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/manager/task/list");
            return;
        }

        int taskId;
        try {
            taskId = Integer.parseInt(taskIdStr.trim());
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID công việc không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/manager/task/list");
            return;
        }

        TaskDAO taskDAO = new TaskDAO();
        Task task = taskDAO.getTaskById(taskId);
        if (task == null) {
            session.setAttribute("errorMessage", "Không tìm thấy công việc");
            response.sendRedirect(request.getContextPath() + "/manager/task/list");
            return;
        }

        // Build dept member list for validation
        List<Users> deptMembers = userDAO.getUsersByDepartment(currentUser.getDepartmentId());
        String redirectTo = request.getContextPath() + "/manager/task/detail?id=" + taskId;

        if ("INDIVIDUAL".equals(mode)) {
            // ── 1→1 reassign ──
            String newAssigneeStr = request.getParameter("newAssignee");
            if (newAssigneeStr == null || newAssigneeStr.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Vui lòng chọn người thực hiện mới");
                response.sendRedirect(redirectTo);
                return;
            }
            int newAssigneeId;
            try { newAssigneeId = Integer.parseInt(newAssigneeStr.trim()); }
            catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Người thực hiện không hợp lệ");
                response.sendRedirect(redirectTo);
                return;
            }

            if (!isInDept(newAssigneeId, deptMembers)) {
                session.setAttribute("errorMessage", "Nhân viên không thuộc phòng ban của bạn");
                response.sendRedirect(redirectTo);
                return;
            }

            // Append audit note to description
            if (reason != null && !reason.trim().isEmpty()) {
                String oldDesc = task.getDescription() != null ? task.getDescription() : "";
                task.setDescription(oldDesc + "\n[Giao lại: " + reason.trim() + "]");
            }
            task.setAssignedTo(newAssigneeId);
            boolean ok = taskDAO.updateTask(task);
            if (ok) {
                session.setAttribute("successMessage", "Giao lại công việc thành công");
            } else {
                session.setAttribute("errorMessage", "Giao lại thất bại");
            }
            response.sendRedirect(redirectTo);

        } else if ("TO_GROUP".equals(mode)) {
            // ── individual → group: add new assignees to task_assignees ──
            TaskAssigneeDAO taDao = new TaskAssigneeDAO();
            List<TaskAssignee> existingAssignees = taDao.getByTaskId(taskId);

            String[] newMemberStrs = request.getParameterValues("newMembers");
            if (newMemberStrs == null || newMemberStrs.length == 0) {
                session.setAttribute("errorMessage", "Vui lòng chọn ít nhất một thành viên mới");
                response.sendRedirect(redirectTo);
                return;
            }

            // Collect existing assignee user IDs
            List<Integer> existingUserIds = new ArrayList<>();
            for (TaskAssignee ea : existingAssignees) existingUserIds.add(ea.getUserId());

            List<Integer> newMemberIds = new ArrayList<>();
            for (String s : newMemberStrs) {
                try {
                    int uid = Integer.parseInt(s.trim());
                    if (isInDept(uid, deptMembers) && !newMemberIds.contains(uid)
                            && !existingUserIds.contains(uid)) {
                        newMemberIds.add(uid);
                    }
                } catch (NumberFormatException ignored) {}
            }

            if (newMemberIds.isEmpty()) {
                session.setAttribute("errorMessage", "Không có thành viên hợp lệ để thêm vào nhóm");
                response.sendRedirect(redirectTo);
                return;
            }

            // Add new assignees to task_assignees table
            for (int memberId : newMemberIds) {
                TaskAssignee ta = new TaskAssignee();
                ta.setTaskId(taskId);
                ta.setUserId(memberId);
                ta.setRole("ASSIGNEE");
                ta.setTaskStatus(task.getStatus() != null ? task.getStatus() : 0);
                ta.setProgress(0);
                ta.setAssignedBy(currentUser.getUserId());
                ta.setAssignedAt(LocalDateTime.now());
                taDao.insert(ta);
            }

            session.setAttribute("successMessage", "Đã chuyển thành công việc nhóm với "
                    + (existingUserIds.size() + newMemberIds.size()) + " thành viên");
            response.sendRedirect(redirectTo);

        } else if ("FROM_GROUP".equals(mode)) {
            // ── group → individual: keep one assignee, remove the rest ──
            TaskAssigneeDAO taDao = new TaskAssigneeDAO();
            List<TaskAssignee> assignees = taDao.getByTaskId(taskId);

            if (assignees.size() <= 1) {
                session.setAttribute("errorMessage", "Công việc này không phải công việc nhóm");
                response.sendRedirect(redirectTo);
                return;
            }

            String keepUserIdStr = request.getParameter("keepTaskId"); // reuse param name for userId
            if (keepUserIdStr == null || keepUserIdStr.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Vui lòng chọn thành viên cần giữ lại");
                response.sendRedirect(redirectTo);
                return;
            }

            int keepUserId;
            try { keepUserId = Integer.parseInt(keepUserIdStr.trim()); }
            catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "ID không hợp lệ");
                response.sendRedirect(redirectTo);
                return;
            }

            // Delete all assignees then re-insert only the kept one
            TaskAssignee keptAssignee = null;
            for (TaskAssignee a : assignees) {
                if (a.getUserId() == keepUserId) { keptAssignee = a; break; }
            }
            if (keptAssignee == null) {
                session.setAttribute("errorMessage", "Thành viên không tồn tại trong nhóm");
                response.sendRedirect(redirectTo);
                return;
            }

            taDao.deleteByTaskId(taskId);
            taDao.insert(keptAssignee);

            // Update task's primary assignee
            task.setAssignedTo(keepUserId);
            taskDAO.updateTask(task);

            session.setAttribute("successMessage", "Đã tách nhóm, giữ lại 1 thành viên");
            response.sendRedirect(redirectTo);

        } else {
            session.setAttribute("errorMessage", "Chế độ giao việc không hợp lệ");
            response.sendRedirect(redirectTo);
        }
    }

    private boolean isInDept(int userId, List<Users> deptMembers) {
        for (Users u : deptMembers) {
            if (u.getUserId() == userId) return true;
        }
        return false;
    }
}
