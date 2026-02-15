package controller.manager;

import dao.TaskDAO;
import dao.UserDAO;
import dao.LeadDAO;
import dao.CustomerDAO;
import dao.OpportunityDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Task;
import model.Users;
import model.Lead;
import model.Customer;
import model.Opportunity;

@WebServlet(name = "ManagerTaskDetailServlet", urlPatterns = {"/manager/task/detail"})
public class ManagerTaskDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");

        // Role checking
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        UserDAO userDAO = new UserDAO();
        String roleCode = userDAO.getRoleCodeByUserId(currentUser.getUserId());

        if (!"MANAGER".equals(roleCode)) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        String taskIdStr = request.getParameter("id");
        if (taskIdStr == null || taskIdStr.isEmpty()) {
            session.setAttribute("errorMessage", "ID công việc không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/manager/task/list");
            return;
        }

        try {
            int taskId = Integer.parseInt(taskIdStr);
            TaskDAO taskDAO = new TaskDAO();
            Task task = taskDAO.getTaskById(taskId);

            if (task == null) {
                session.setAttribute("errorMessage", "Không tìm thấy công việc");
                response.sendRedirect(request.getContextPath() + "/manager/task/list");
                return;
            }

            // Get assigned user info
            Users assignedUser = null;
            if (task.getAssignedTo() != null) {
                assignedUser = userDAO.getUserById(task.getAssignedTo());
            }

            // Get creator info
            Users creator = null;
            if (task.getCreatedBy() != null) {
                creator = userDAO.getUserById(task.getCreatedBy());
            }

            // Get related object info
            Object relatedObject = null;
            String relatedObjectName = null;

            if (task.getRelatedType() != null && task.getRelatedId() != null) {
                if ("Lead".equals(task.getRelatedType())) {
                    LeadDAO leadDAO = new LeadDAO();
                    Lead lead = leadDAO.getLeadById(task.getRelatedId());
                    if (lead != null) {
                        relatedObject = lead;
                        relatedObjectName = lead.getFullName() + " (" + lead.getLeadCode() + ")";
                    }
                } else if ("Customer".equals(task.getRelatedType())) {
                    CustomerDAO customerDAO = new CustomerDAO();
                    Customer customer = customerDAO.getCustomerById(task.getRelatedId());
                    if (customer != null) {
                        relatedObject = customer;
                        relatedObjectName = customer.getFullName() + " (" + customer.getCustomerCode() + ")";
                    }
                } else if ("Opportunity".equals(task.getRelatedType())) {
                    OpportunityDAO opportunityDAO = new OpportunityDAO();
                    Opportunity opportunity = opportunityDAO.getOpportunityById(task.getRelatedId());
                    if (opportunity != null) {
                        relatedObject = opportunity;
                        relatedObjectName = opportunity.getOpportunityName() + " (" + opportunity.getOpportunityCode() + ")";
                    }
                }
            }

            request.setAttribute("task", task);
            request.setAttribute("assignedUser", assignedUser);
            request.setAttribute("creator", creator);
            request.setAttribute("relatedObject", relatedObject);
            request.setAttribute("relatedObjectName", relatedObjectName);

            request.setAttribute("ACTIVE_MENU", "TASK_LIST");
            request.setAttribute("pageTitle", "Chi tiết Công việc");
            request.setAttribute("CONTENT_PAGE", "/view/manager/task/task-detail.jsp");
            request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID công việc không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/manager/task/list");
        }
    }
}
