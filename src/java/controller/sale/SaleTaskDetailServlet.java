package controller.sale;

import dao.CustomerDAO;
import dao.LeadDAO;
import dao.OpportunityDAO;
import dao.TaskDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Customer;
import model.Lead;
import model.Opportunity;
import model.Task;
import model.Users;

@WebServlet(name = "SaleTaskDetailServlet", urlPatterns = {"/sale/task/detail"})
public class SaleTaskDetailServlet extends HttpServlet {

    // Bật/tắt bỏ qua đăng nhập khi test nhanh
    private static final boolean BO_QUA_DANG_NHAP = true;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        // Tạm thời bỏ qua đăng nhập để test nhanh
        if (BO_QUA_DANG_NHAP && user == null) {
            Users nguoiDungTam = new Users();
            nguoiDungTam.setUserId(1);
            nguoiDungTam.setDepartmentId(2);
            session.setAttribute("user", nguoiDungTam);
            user = nguoiDungTam;
        }

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String idParam = request.getParameter("id");
        Task task;
        try {
            int taskId = Integer.parseInt(idParam);
            TaskDAO taskDAO = new TaskDAO();
            task = taskDAO.getTaskById(taskId);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID công việc không hợp lệ.");
            request.getRequestDispatcher("/view/sale/pages/task/list.jsp").forward(request, response);
            return;
        }
        
        if (task == null) {
            request.setAttribute("errorMessage", "Không tìm thấy công việc với ID được cung cấp.");
            request.getRequestDispatcher("/view/sale/pages/task/list.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        Users assignee = userDAO.getUserById(task.getAssigneeId());
        Users createdBy = userDAO.getUserById(task.getCreatedBy());

        request.setAttribute("task", task);
        request.setAttribute("assignee", assignee);
        request.setAttribute("createdBy", createdBy);
        
        if (task.getRelatedToEntityType() != null && !task.getRelatedToEntityType().isEmpty()) {
            String entityName = "";
            String entityUrl = "#";
            int entityId = task.getRelatedToEntityId();

            switch (task.getRelatedToEntityType()) {
                case "LEAD":
                    LeadDAO leadDAO = new LeadDAO();
                    Lead lead = leadDAO.getLeadById(entityId);
                    if (lead != null) {
                        entityName = lead.getName();
                        entityUrl = request.getContextPath() + "/sale/lead/detail?id=" + entityId; // Corrected URL assumption
                    }
                    break;
                case "CUSTOMER":
                    CustomerDAO customerDAO = new CustomerDAO();
                    Customer customer = customerDAO.getCustomerById(entityId);
                    if (customer != null) {
                        entityName = customer.getName();
                        entityUrl = request.getContextPath() + "/sale/customer/detail?id=" + entityId; // Corrected URL assumption
                    }
                    break;
                case "OPPORTUNITY":
                    OpportunityDAO opportunityDAO = new OpportunityDAO();
                    Opportunity opportunity = opportunityDAO.getOpportunityById(entityId);
                    if (opportunity != null) {
                        entityName = opportunity.getOpportunityName();
                        entityUrl = request.getContextPath() + "/sale/opportunity/detail?id=" + entityId; // Corrected URL assumption
                    }
                    break;
            }
            request.setAttribute("relatedEntityName", entityName);
            request.setAttribute("relatedEntityUrl", entityUrl);
        }

        request.getRequestDispatcher("/view/sale/pages/task/detail.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet để hiển thị chi tiết công việc.";
    }
}
