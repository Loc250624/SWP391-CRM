package controller.sale;

import dao.CustomerDAO;
import dao.LeadDAO;
import dao.OpportunityDAO;
import dao.TaskDAO;
import dao.UserDAO;
import enums.Priority;
import enums.TaskStatus;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import model.Task;
import model.Users;

@WebServlet(name = "SaleTaskFormServlet", urlPatterns = {"/sale/task/form"})
public class SaleTaskFormServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        TaskDAO taskDAO = new TaskDAO();
        UserDAO userDAO = new UserDAO();
        
        List<Users> userList = userDAO.getAllUsers();
        request.setAttribute("userList", userList);
        request.setAttribute("taskStatusValues", TaskStatus.values());
        request.setAttribute("priorityValues", Priority.values());

        // Fetch related entities for linking
        LeadDAO leadDAO = new LeadDAO();
        CustomerDAO customerDAO = new CustomerDAO();
        OpportunityDAO opportunityDAO = new OpportunityDAO();
        request.setAttribute("leads", leadDAO.getAllLeads());
        request.setAttribute("customers", customerDAO.getAllCustomers());
        request.setAttribute("opportunities", opportunityDAO.getAllOpportunities());

        if ("edit".equals(action)) {
            int taskId = Integer.parseInt(request.getParameter("id"));
            Task task = taskDAO.getTaskById(taskId);
            request.setAttribute("task", task);
            request.setAttribute("formAction", "edit");
            request.setAttribute("pageTitle", "Chỉnh sửa công việc");
        } else {
            request.setAttribute("task", new Task());
            request.setAttribute("formAction", "create");
            request.setAttribute("pageTitle", "Tạo mới công việc");
        }

        request.getRequestDispatcher("/view/sale/pages/task/form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("formAction");
        TaskDAO taskDAO = new TaskDAO();

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        int assigneeId = Integer.parseInt(request.getParameter("assigneeId"));
        Date dueDate = Date.valueOf(request.getParameter("dueDate"));
        Priority priority = Priority.valueOf(request.getParameter("priority"));
        TaskStatus status = TaskStatus.valueOf(request.getParameter("status"));
        String relatedToEntityType = request.getParameter("relatedToEntityType");
        int relatedToEntityId = 0;
        if (request.getParameter("relatedToEntityId") != null && !request.getParameter("relatedToEntityId").isEmpty()) {
            relatedToEntityId = Integer.parseInt(request.getParameter("relatedToEntityId"));
        }
        
        if (relatedToEntityType != null && relatedToEntityType.isEmpty()) {
            relatedToEntityType = null;
        }

        if ("edit".equals(action)) {
            int taskId = Integer.parseInt(request.getParameter("taskId"));
            Task existingTask = taskDAO.getTaskById(taskId);
            Task task = new Task(taskId, title, description, assigneeId, dueDate, priority, status, existingTask.getCreatedBy(), existingTask.getCreatedAt(), relatedToEntityType, relatedToEntityId);
            taskDAO.updateTask(task);
        } else {
            Task task = new Task(0, title, description, assigneeId, dueDate, priority, status, user.getUserId(), null, relatedToEntityType, relatedToEntityId);
            taskDAO.addTask(task);
        }

        response.sendRedirect(request.getContextPath() + "/sale/task/list");
    }

    @Override
    public String getServletInfo() {
        return "Servlet để xử lý biểu mẫu tạo và chỉnh sửa công việc.";
    }
}