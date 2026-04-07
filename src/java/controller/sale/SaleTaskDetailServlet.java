package controller.sale;

import dao.CustomerDAO;
import dao.LeadDAO;
import dao.OpportunityDAO;
import dao.TaskAssigneeDAO;
import dao.TaskCommentDAO;
import dao.TaskDAO;
import dao.TaskRelationDAO;
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
import model.Comment;
import model.Customer;
import model.Lead;
import model.Opportunity;
import model.Task;
import model.TaskAssignee;
import model.TaskRelation;
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

            // Check access: user must be an assignee of this task
            TaskAssigneeDAO taskAssigneeDAO = new TaskAssigneeDAO();
            List<TaskAssignee> assigneeList = taskAssigneeDAO.getByTaskId(taskId);
            boolean isAssignee = false;
            for (TaskAssignee ta : assigneeList) {
                if (ta.getUserId() == currentUser.getUserId()) {
                    isAssignee = true;
                    break;
                }
            }
            // Also check task.assignedTo for backward compat
            if (!isAssignee && task.getAssignedTo() != null
                    && task.getAssignedTo() == currentUser.getUserId()) {
                isAssignee = true;
            }

            if (!isAssignee) {
                session.setAttribute("errorMessage", "Bạn không có quyền xem công việc này");
                response.sendRedirect(request.getContextPath() + "/sale/task/list");
                return;
            }

            // Group task members
            boolean isGroupTask = assigneeList.size() > 1;
            List<Users> groupMembers = new ArrayList<>();
            if (isGroupTask) {
                for (TaskAssignee ta : assigneeList) {
                    Users member = userDAO.getUserById(ta.getUserId());
                    if (member != null) {
                        groupMembers.add(member);
                    }
                }
            }

            // Creator info
            Users creator = null;
            if (task.getCreatedBy() != null) {
                creator = userDAO.getUserById(task.getCreatedBy());
            }

            // Load ALL related objects from task_relations
            TaskRelationDAO taskRelationDAO = new TaskRelationDAO();
            List<TaskRelation> allRelations = taskRelationDAO.getByTaskId(taskId);

            List<TaskRelation> objectRelations = new ArrayList<>();
            for (TaskRelation tr : allRelations) {
                if (tr.getRelatedType() != null && !"SUBTASK".equals(tr.getRelatedType())) {
                    objectRelations.add(tr);
                }
            }

            LeadDAO leadDAO = new LeadDAO();
            CustomerDAO customerDAO = new CustomerDAO();
            List<Lead> relatedLeads = new ArrayList<>();
            List<Customer> relatedCustomers = new ArrayList<>();

            for (TaskRelation tr : objectRelations) {
                if ("LEAD".equals(tr.getRelatedType()) && tr.getRelatedId() != null) {
                    Lead ld = leadDAO.getLeadById(tr.getRelatedId());
                    if (ld != null) relatedLeads.add(ld);
                } else if ("CUSTOMER".equals(tr.getRelatedType()) && tr.getRelatedId() != null) {
                    Customer cust = customerDAO.getCustomerById(tr.getRelatedId());
                    if (cust != null) relatedCustomers.add(cust);
                }
            }

            // Fallback: single related object from task itself
            String relatedObjectName = null;
            Lead relatedLead = null;
            Customer relatedCustomer = null;
            if (relatedLeads.isEmpty() && relatedCustomers.isEmpty()
                    && task.getRelatedType() != null && task.getRelatedId() != null) {
                switch (task.getRelatedType().toUpperCase()) {
                    case "LEAD": {
                        relatedLead = leadDAO.getLeadById(task.getRelatedId());
                        if (relatedLead != null) {
                            relatedObjectName = relatedLead.getFullName() + " (" + relatedLead.getLeadCode() + ")";
                        }
                        break;
                    }
                    case "CUSTOMER": {
                        relatedCustomer = customerDAO.getCustomerById(task.getRelatedId());
                        if (relatedCustomer != null) {
                            relatedObjectName = relatedCustomer.getFullName() + " (" + relatedCustomer.getCustomerCode() + ")";
                        }
                        break;
                    }
                    case "OPPORTUNITY": {
                        Opportunity opp = new OpportunityDAO().getOpportunityById(task.getRelatedId());
                        if (opp != null) {
                            relatedObjectName = opp.getOpportunityName() + " (" + opp.getOpportunityCode() + ")";
                        }
                        break;
                    }
                    default:
                        break;
                }
            }

            // Clean description (remove [DEPS:...] tag)
            String cleanDescription = TaskDAO.getCleanDescription(task.getDescription());

            // All users (for comment author display)
            List<Users> allUsers = userDAO.getAllUsers();

            // Comments
            List<Comment> comments = new TaskCommentDAO().getCommentsByTaskId(taskId);

            request.setAttribute("task", task);
            request.setAttribute("creator", creator);
            request.setAttribute("isGroupTask", isGroupTask);
            request.setAttribute("groupMembers", groupMembers);
            request.setAttribute("assigneeList", assigneeList);
            request.setAttribute("relatedObjectName", relatedObjectName);
            request.setAttribute("relatedLead", relatedLead);
            request.setAttribute("relatedCustomer", relatedCustomer);
            request.setAttribute("relatedLeads", relatedLeads);
            request.setAttribute("relatedCustomers", relatedCustomers);
            request.setAttribute("cleanDescription", cleanDescription);
            request.setAttribute("allUsers", allUsers);
            request.setAttribute("comments", comments);
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
