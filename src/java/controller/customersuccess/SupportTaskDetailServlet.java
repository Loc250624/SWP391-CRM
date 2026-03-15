package controller.customersuccess;

import dao.CustomerDAO;
import dao.TaskCommentDAO;
import dao.TaskDAO;
import dao.UserDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Comment;
import model.Customer;
import model.Task;
import model.Users;

@WebServlet(name = "SupportTaskDetailServlet", urlPatterns = {"/support/task/detail"})
public class SupportTaskDetailServlet extends HttpServlet {

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

        String taskIdStr = request.getParameter("id");
        if (taskIdStr == null || taskIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/support/task/list");
            return;
        }

        try {
            int taskId = Integer.parseInt(taskIdStr);
            TaskDAO taskDAO = new TaskDAO();
            Task task = taskDAO.getTaskById(taskId);

            if (task == null) {
                session.setAttribute("errorMessage", "Không tìm thấy công việc");
                response.sendRedirect(request.getContextPath() + "/support/task/list");
                return;
            }

            // Support can only view tasks assigned to them
            if (task.getAssignedTo() == null || task.getAssignedTo() != currentUser.getUserId()) {
                session.setAttribute("errorMessage", "Bạn không có quyền xem công việc này");
                response.sendRedirect(request.getContextPath() + "/support/task/list");
                return;
            }

            // Get creator info
            Users creator = null;
            if (task.getCreatedBy() != null) {
                creator = userDAO.getUserById(task.getCreatedBy());
            }

            // Get related object info (CS only links to Customer)
            String relatedObjectName = null;
            Customer relatedCustomer = null;
            if (task.getRelatedType() != null && task.getRelatedId() != null) {
                String rt = task.getRelatedType().toUpperCase();
                if ("CUSTOMER".equals(rt)) {
                    relatedCustomer = new CustomerDAO().getCustomerById(task.getRelatedId());
                    if (relatedCustomer != null) {
                        relatedObjectName = relatedCustomer.getFullName() + " (" + relatedCustomer.getCustomerCode() + ")";
                    }
                }
            }

            // Comments
            List<Comment> comments = new TaskCommentDAO().getCommentsByTaskId(taskId);
            List<Users> allUsers = userDAO.getAllUsers();

            request.setAttribute("task", task);
            request.setAttribute("creator", creator);
            request.setAttribute("relatedObjectName", relatedObjectName);
            request.setAttribute("relatedCustomer", relatedCustomer);
            request.setAttribute("comments", comments);
            request.setAttribute("allUsers", allUsers);

            request.setAttribute("pageTitle", "Chi tiết Công việc");
            request.setAttribute("contentPage", "/view/customersuccess/pages/task/task-detail.jsp");
            request.getRequestDispatcher("/view/customersuccess/pages/main_layout.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/support/task/list");
        }
    }
}
