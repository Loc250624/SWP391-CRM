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
            // ── individual → group ──
            // Task must currently be individual (groupTaskId == null)
            if (task.getGroupTaskId() != null) {
                session.setAttribute("errorMessage", "Công việc này đã là công việc nhóm");
                response.sendRedirect(redirectTo);
                return;
            }

            String[] newMemberStrs = request.getParameterValues("newMembers");
            if (newMemberStrs == null || newMemberStrs.length == 0) {
                session.setAttribute("errorMessage", "Vui lòng chọn ít nhất một thành viên mới");
                response.sendRedirect(redirectTo);
                return;
            }

            List<Integer> newMemberIds = new ArrayList<>();
            for (String s : newMemberStrs) {
                try {
                    int uid = Integer.parseInt(s.trim());
                    if (isInDept(uid, deptMembers) && !newMemberIds.contains(uid)
                            && uid != task.getAssignedTo()) {
                        newMemberIds.add(uid);
                    }
                } catch (NumberFormatException ignored) {}
            }

            if (newMemberIds.isEmpty()) {
                session.setAttribute("errorMessage", "Không có thành viên hợp lệ để thêm vào nhóm");
                response.sendRedirect(redirectTo);
                return;
            }

            // Make original task the group representative
            int groupTaskId = task.getTaskId();
            taskDAO.updateGroupTaskId(groupTaskId, groupTaskId); // rep links to itself

            // Create task row for each new member
            for (int memberId : newMemberIds) {
                Task newTask = new Task();
                newTask.setTitle(task.getTitle());
                newTask.setDescription(task.getDescription());
                newTask.setAssignedTo(memberId);
                newTask.setDueDate(task.getDueDate());
                newTask.setPriority(task.getPriority());
                newTask.setStatus(TaskStatus.IN_PROGRESS.ordinal());
                newTask.setRelatedType(task.getRelatedType());
                newTask.setRelatedId(task.getRelatedId());
                newTask.setCreatedBy(currentUser.getUserId());
                newTask.setReminderAt(task.getReminderAt());
                newTask.setGroupTaskId(groupTaskId);
                taskDAO.insertTask(newTask);
            }

            session.setAttribute("successMessage", "Đã chuyển thành công việc nhóm với "
                    + (newMemberIds.size() + 1) + " thành viên");
            response.sendRedirect(redirectTo);

        } else if ("FROM_GROUP".equals(mode)) {
            // ── group → individual (keep one, cancel rest) ──
            if (task.getGroupTaskId() == null) {
                session.setAttribute("errorMessage", "Công việc này không phải công việc nhóm");
                response.sendRedirect(redirectTo);
                return;
            }

            String keepTaskIdStr = request.getParameter("keepTaskId");
            if (keepTaskIdStr == null || keepTaskIdStr.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Vui lòng chọn thành viên cần giữ lại");
                response.sendRedirect(redirectTo);
                return;
            }

            int keepTaskId;
            try { keepTaskId = Integer.parseInt(keepTaskIdStr.trim()); }
            catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "ID không hợp lệ");
                response.sendRedirect(redirectTo);
                return;
            }

            // Cancel all other members in the group
            List<Task> members = taskDAO.getGroupTaskMembers(task.getGroupTaskId());
            for (Task m : members) {
                if (m.getTaskId() != keepTaskId) {
                    taskDAO.cancelTask(m.getTaskId());
                }
            }
            // Dissolve group membership for the kept task
            taskDAO.dissolveGroupMembership(keepTaskId);

            session.setAttribute("successMessage", "Đã tách nhóm, giữ lại 1 thành viên");
            response.sendRedirect(request.getContextPath() + "/manager/task/detail?id=" + keepTaskId);

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
