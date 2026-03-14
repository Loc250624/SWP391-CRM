package controller.sale;

import dao.CustomerDAO;
import dao.LeadDAO;
import dao.OpportunityDAO;
import dao.TaskDAO;
import dao.UserDAO;
import java.io.IOException;
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

@WebServlet(name = "SaleTaskDetailServlet", urlPatterns = {"/sale/task/detail"})
public class SaleTaskDetailServlet extends HttpServlet {

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

        String taskIdStr = request.getParameter("id");
        if (taskIdStr == null || taskIdStr.isEmpty()) {
            session.setAttribute("errorMessage", "ID công việc không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/sale/task/list");
            return;
        }

        try {
            int taskId = Integer.parseInt(taskIdStr);
            TaskDAO taskDAO = new TaskDAO();
            Task task = taskDAO.getTaskById(taskId);

            if (task == null) {
                session.setAttribute("errorMessage", "Không tìm thấy công việc");
                response.sendRedirect(request.getContextPath() + "/sale/task/list");
                return;
            }

            // Sales/Support can only view tasks assigned to them
            if (task.getAssignedTo() == null || task.getAssignedTo() != currentUser.getUserId()) {
                session.setAttribute("errorMessage", "Bạn không có quyền xem công việc này");
                response.sendRedirect(request.getContextPath() + "/sale/task/list");
                return;
            }

            // Get creator info
            Users creator = null;
            if (task.getCreatedBy() != null) {
                creator = userDAO.getUserById(task.getCreatedBy());
            }

            // Get related object info
            String relatedObjectName = null;
            if (task.getRelatedType() != null && task.getRelatedId() != null) {
                if ("Lead".equals(task.getRelatedType())) {
                    LeadDAO leadDAO = new LeadDAO();
                    Lead lead = leadDAO.getLeadById(task.getRelatedId());
                    if (lead != null) {
                        relatedObjectName = lead.getFullName() + " (" + lead.getLeadCode() + ")";
                    }
                } else if ("Customer".equals(task.getRelatedType())) {
                    CustomerDAO customerDAO = new CustomerDAO();
                    Customer customer = customerDAO.getCustomerById(task.getRelatedId());
                    if (customer != null) {
                        relatedObjectName = customer.getFullName() + " (" + customer.getCustomerCode() + ")";
                    }
                } else if ("Opportunity".equals(task.getRelatedType())) {
                    OpportunityDAO opportunityDAO = new OpportunityDAO();
                    Opportunity opportunity = opportunityDAO.getOpportunityById(task.getRelatedId());
                    if (opportunity != null) {
                        relatedObjectName = opportunity.getOpportunityName() + " (" + opportunity.getOpportunityCode() + ")";
                    }
                }
            }

            request.setAttribute("task", task);
            request.setAttribute("creator", creator);
            request.setAttribute("relatedObjectName", relatedObjectName);
            request.setAttribute("ACTIVE_MENU", "TASK_LIST");
            request.setAttribute("pageTitle", "Chi tiết Công việc");
            request.setAttribute("CONTENT_PAGE", "/view/sale/pages/task/detail.jsp");
            request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID công việc không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/sale/task/list");
        }
    }
}
