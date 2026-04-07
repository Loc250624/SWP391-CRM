package controller.manager;

import dao.CustomerDAO;
import dao.LeadDAO;
import dao.OpportunityDAO;
import dao.TaskAssigneeDAO;
import dao.TaskDAO;
import dao.TaskRelationDAO;
import dao.UserDAO;
import enums.Priority;
import enums.TaskStatus;
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
import model.Customer;
import model.Lead;
import model.Opportunity;
import model.Task;
import model.TaskAssignee;
import model.TaskRelation;
import model.Users;
import util.AuditUtil;

@WebServlet(name = "ManagerTaskFormServlet", urlPatterns = {"/manager/task/form"})
public class ManagerTaskFormServlet extends HttpServlet {

    // ─────────────────────────────────────────────────────────────────── GET ──
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
        if (!"MANAGER".equals(userDAO.getRoleCodeByUserId(currentUser.getUserId()))) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        TaskDAO taskDAO = new TaskDAO();
        Task task       = new Task();
        request.setAttribute("pageTitle",  "Tạo Công việc mới");
        request.setAttribute("formAction", "create");

        // Handle leadId param (from lead-list page redirect)
        LeadDAO leadDAO = new LeadDAO();
        String leadIdStr = request.getParameter("leadId");
        if (leadIdStr != null && !leadIdStr.trim().isEmpty()) {
            try {
                int leadId = Integer.parseInt(leadIdStr.trim());
                Lead linkedLead = leadDAO.getLeadById(leadId);
                if (linkedLead != null) {
                    request.setAttribute("linkedLead", linkedLead);
                }
            } catch (NumberFormatException ignored) {}
        }

        // Handle customerId param (from customer-list page redirect)
        CustomerDAO customerDAO = new CustomerDAO();
        String customerIdStr = request.getParameter("customerId");
        if (customerIdStr != null && !customerIdStr.trim().isEmpty()) {
            try {
                int customerId = Integer.parseInt(customerIdStr.trim());
                Customer linkedCustomer = customerDAO.getCustomerById(customerId);
                if (linkedCustomer != null) {
                    request.setAttribute("linkedCustomer", linkedCustomer);
                }
            } catch (NumberFormatException ignored) {}
        }

        // Unassigned leads/customers for picker modal (create mode)
        request.setAttribute("pickerLeads", leadDAO.getUnassignedLeadsForPicker());
        request.setAttribute("pickerCustomers", customerDAO.getUnassignedCustomersForPicker());

        // Users by role for assignee picker
        List<Users> salesUsers = userDAO.getUsersByRoleCode("SALES");
        List<Users> supportUsers = userDAO.getUsersByRoleCode("SUPPORT");

        request.setAttribute("task",             task);
        request.setAttribute("allUsers",         salesUsers);
        request.setAttribute("supportUsers",     supportUsers);
        request.setAttribute("leads",            leadDAO.getAllLeads());
        request.setAttribute("customers",        customerDAO.getAllCustomers());
        request.setAttribute("opportunities",    new OpportunityDAO().getAllOpportunities());
        request.setAttribute("taskStatusValues", TaskStatus.values());
        request.setAttribute("priorityValues",   Priority.values());

        request.setAttribute("ACTIVE_MENU",  "TASK_FORM");
        request.setAttribute("CONTENT_PAGE", "/view/manager/task/task-form.jsp");
        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp")
               .forward(request, response);
    }

    // ────────────────────────────────────────────────────────────────── POST ──
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
        UserDAO userDAO   = new UserDAO();
        if (!"MANAGER".equals(userDAO.getRoleCodeByUserId(currentUser.getUserId()))) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        String formAction = request.getParameter("formAction");
        String errorBase = request.getContextPath() + "/manager/task/form?action=create";

        try {
            String title       = request.getParameter("title");
            String description = request.getParameter("description");
            String dueDateStr  = request.getParameter("dueDate");
            String priorityStr = request.getParameter("priority");

            // ── Validate title ──────────────────────────────────────────────
            if (title == null || title.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Tiêu đề không được để trống");
                response.sendRedirect(errorBase); return;
            }

            // ── Parse priority ──────────────────────────────────────────────
            int priority = Priority.MEDIUM.ordinal();
            if (priorityStr != null && !priorityStr.trim().isEmpty()) {
                try { priority = Priority.valueOf(priorityStr.trim().toUpperCase()).ordinal(); }
                catch (IllegalArgumentException ignored) {}
            }

            // ── Validate due date ───────────────────────────────────────────
            if (dueDateStr == null || dueDateStr.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Hạn chót không được để trống");
                response.sendRedirect(errorBase); return;
            }
            LocalDateTime dueDate;
            try { dueDate = LocalDateTime.parse(dueDateStr.trim() + "T23:59:59"); }
            catch (Exception e) {
                session.setAttribute("errorMessage", "Định dạng ngày không hợp lệ");
                response.sendRedirect(errorBase); return;
            }
            if ("create".equals(formAction) && dueDate.isBefore(LocalDateTime.now())) {
                session.setAttribute("errorMessage", "Hạn chót không được ở quá khứ");
                response.sendRedirect(errorBase); return;
            }

            // ── Parse related object ────────────────────────────────────────
            String  relatedType = null;
            Integer relatedId   = null;
            List<Integer> extraLeadIds = new ArrayList<>();
            List<Integer> extraCustomerIds = new ArrayList<>();

            // Check for selected leads from lead picker (multiple)
            String[] selectedLeads = request.getParameterValues("selectedLeads");
            if (selectedLeads != null && selectedLeads.length > 0) {
                relatedType = "LEAD";
                for (int i = 0; i < selectedLeads.length; i++) {
                    try {
                        int lid = Integer.parseInt(selectedLeads[i].trim());
                        if (lid > 0) {
                            if (relatedId == null) {
                                relatedId = lid; // first one is primary
                            } else {
                                extraLeadIds.add(lid);
                            }
                        }
                    } catch (NumberFormatException ignored) {}
                }
            }

            // Check for selected customers from customer picker (multiple)
            String[] selectedCustomers = request.getParameterValues("selectedCustomers");
            if (selectedCustomers != null && selectedCustomers.length > 0) {
                // If no leads were selected, first customer becomes primary related object
                if (relatedId == null) {
                    relatedType = "CUSTOMER";
                }
                for (int i = 0; i < selectedCustomers.length; i++) {
                    try {
                        int cid = Integer.parseInt(selectedCustomers[i].trim());
                        if (cid > 0) {
                            if (relatedId == null) {
                                relatedId = cid; // first one is primary
                            } else {
                                extraCustomerIds.add(cid);
                            }
                        }
                    } catch (NumberFormatException ignored) {}
                }
            }

            // Fallback: old composite relatedId format (for edit mode or other cases)
            if (relatedId == null) {
                String rawRelated = request.getParameter("relatedId");
                if (rawRelated != null && !rawRelated.trim().isEmpty()) {
                    String raw = rawRelated.trim();
                    int us = raw.indexOf('_');
                    if (us > 0 && us < raw.length() - 1) {
                        String typeToken = raw.substring(0, us);
                        switch (typeToken) {
                            case "LEAD":        relatedType = "LEAD";        break;
                            case "CUSTOMER":    relatedType = "CUSTOMER";    break;
                            case "OPPORTUNITY": relatedType = "OPPORTUNITY"; break;
                        }
                        try {
                            relatedId = Integer.parseInt(raw.substring(us + 1));
                            if (relatedId <= 0) relatedId = null;
                        } catch (NumberFormatException e) { relatedId = null; }
                    }
                }
            }

            TaskDAO taskDAO = new TaskDAO();


            if ("create".equals(formAction)) {

                String assignType   = request.getParameter("assignType");
                List<Integer> mainIds    = new ArrayList<>();
                List<Integer> supportIds = new ArrayList<>();

                if ("GROUP".equals(assignType)) {
                    String[] groupArr = request.getParameterValues("assignedToGroup");
                    if (groupArr == null || groupArr.length == 0) {
                        session.setAttribute("errorMessage", "Chọn ít nhất một nhân viên cho nhóm");
                        response.sendRedirect(errorBase); return;
                    }
                    for (String s : groupArr) {
                        try {
                            int gId = Integer.parseInt(s.trim());
                            if (userDAO.getUserById(gId) != null && !mainIds.contains(gId))
                                mainIds.add(gId);
                        } catch (NumberFormatException ignored) {}
                    }
                    if (mainIds.size() < 2) {
                        session.setAttribute("errorMessage", "Nhóm cần ít nhất 2 người");
                        response.sendRedirect(errorBase); return;
                    }
                } else {
                    String aStr = request.getParameter("assignedTo");
                    if (aStr == null || aStr.trim().isEmpty()) {
                        session.setAttribute("errorMessage", "Chọn người được giao việc");
                        response.sendRedirect(errorBase); return;
                    }
                    try {
                        int aId = Integer.parseInt(aStr.trim());
                        if (userDAO.getUserById(aId) == null) throw new Exception();
                        mainIds.add(aId);
                    } catch (Exception e) {
                        session.setAttribute("errorMessage", "Người được giao không hợp lệ");
                        response.sendRedirect(errorBase); return;
                    }
                }

                String cleanDesc = description != null ? description.trim() : null;
                boolean success;
                Task createdTask = new Task();
                createdTask.setTitle(title.trim());
                createdTask.setDescription(cleanDesc);
                createdTask.setAssignedTo(mainIds.get(0));
                createdTask.setDueDate(dueDate);
                createdTask.setPriority(priority);
                createdTask.setStatus(TaskStatus.IN_PROGRESS.ordinal());
                createdTask.setRelatedType(relatedType);
                createdTask.setRelatedId(relatedId);
                createdTask.setCreatedBy(currentUser.getUserId());
                createdTask.setReminderAt(dueDate.minusHours(24));
                success = taskDAO.insertTask(createdTask);

                if (success && createdTask.getTaskId() != null) {
                    AuditUtil.logCreate(request, currentUser.getUserId(), "Task", createdTask.getTaskId(),
                            "title=" + title.trim() + ", priority=" + priorityStr + ", assignedTo=" + mainIds.get(0)
                            + ", relatedType=" + relatedType + ", relatedId=" + relatedId);

                    // Fix: insertTask() hardcodes first assignee taskStatus=0 (PENDING)
                    // Update to IN_PROGRESS to match the task status
                    TaskAssigneeDAO taDao = new TaskAssigneeDAO();
                    taDao.updateTaskStatus(createdTask.getTaskId(), mainIds.get(0), TaskStatus.IN_PROGRESS.ordinal());
                }

                if ("GROUP".equals(assignType) && success && createdTask.getTaskId() != null) {
                    TaskAssigneeDAO taDao = new TaskAssigneeDAO();
                    for (int i = 1; i < mainIds.size(); i++) {
                        TaskAssignee ta = new TaskAssignee();
                        ta.setTaskId(createdTask.getTaskId());
                        ta.setUserId(mainIds.get(i));
                        ta.setRole("ASSIGNEE");
                        ta.setTaskStatus(TaskStatus.IN_PROGRESS.ordinal());
                        ta.setProgress(0);
                        ta.setAssignedBy(currentUser.getUserId());
                        ta.setAssignedAt(LocalDateTime.now());
                        taDao.insert(ta);
                    }
                    for (int sId : supportIds) {
                        TaskAssignee ta = new TaskAssignee();
                        ta.setTaskId(createdTask.getTaskId());
                        ta.setUserId(sId);
                        ta.setRole("SUPPORT");
                        ta.setTaskStatus(TaskStatus.IN_PROGRESS.ordinal());
                        ta.setProgress(0);
                        ta.setAssignedBy(currentUser.getUserId());
                        ta.setAssignedAt(LocalDateTime.now());
                        taDao.insert(ta);
                    }
                }

                if (!success) {
                    session.setAttribute("errorMessage", "Tạo công việc thất bại");
                    response.sendRedirect(errorBase); return;
                }

                // ── Insert extra lead relations (if multiple leads selected) ──
                if (!extraLeadIds.isEmpty() && createdTask.getTaskId() != null) {
                    TaskRelationDAO trDao = new TaskRelationDAO();
                    for (int extraLid : extraLeadIds) {
                        TaskRelation tr = new TaskRelation();
                        tr.setTaskId(createdTask.getTaskId());
                        tr.setRelatedType("LEAD");
                        tr.setRelatedId(extraLid);
                        tr.setCreatedAt(LocalDateTime.now());
                        tr.setCreatedBy(currentUser.getUserId());
                        trDao.insert(tr);
                    }
                }

                // ── Insert extra customer relations (if multiple customers selected) ──
                if (!extraCustomerIds.isEmpty() && createdTask.getTaskId() != null) {
                    TaskRelationDAO trDao = new TaskRelationDAO();
                    for (int extraCid : extraCustomerIds) {
                        TaskRelation tr = new TaskRelation();
                        tr.setTaskId(createdTask.getTaskId());
                        tr.setRelatedType("CUSTOMER");
                        tr.setRelatedId(extraCid);
                        tr.setCreatedAt(LocalDateTime.now());
                        tr.setCreatedBy(currentUser.getUserId());
                        trDao.insert(tr);
                    }
                }

                // ── Auto-assign Lead/Customer nếu chưa có người phụ trách ──
                if (!mainIds.isEmpty()) {
                    int primary = mainIds.get(0);
                    LeadDAO ldDao = new LeadDAO();
                    CustomerDAO cdDao = new CustomerDAO();

                    // Auto-assign primary related object
                    if (relatedId != null) {
                        if ("LEAD".equals(relatedType)) {
                            Lead lead = ldDao.getLeadById(relatedId);
                            if (lead != null && lead.getAssignedTo() == null) {
                                ldDao.updateLeadAssignedTo(relatedId, primary);
                                ldDao.updateLeadStatus(relatedId, "Assigned");
                            }
                        } else if ("CUSTOMER".equals(relatedType)) {
                            Customer c = cdDao.getCustomerById(relatedId);
                            if (c != null && c.getOwnerId() == null)
                                cdDao.updateCustomerOwnerId(relatedId, primary);
                        }
                    }

                    // Auto-assign extra leads + update status to Assigned
                    for (int extraLid : extraLeadIds) {
                        Lead lead = ldDao.getLeadById(extraLid);
                        if (lead != null && lead.getAssignedTo() == null) {
                            ldDao.updateLeadAssignedTo(extraLid, primary);
                            ldDao.updateLeadStatus(extraLid, "Assigned");
                        }
                    }

                    // Auto-assign extra customers
                    for (int extraCid : extraCustomerIds) {
                        Customer c = cdDao.getCustomerById(extraCid);
                        if (c != null && c.getOwnerId() == null)
                            cdDao.updateCustomerOwnerId(extraCid, primary);
                    }
                }

                // ── Gui thong bao cho tat ca assignees ──────────────────────
                List<Integer> allAssignees = new ArrayList<>();
                allAssignees.addAll(mainIds);
                allAssignees.addAll(supportIds);
                util.NotificationUtil.notifyTaskAssigned(
                        createdTask.getTaskId(), createdTask.getTaskCode(), title.trim(),
                        priorityStr, allAssignees, currentUser.getUserId());

                String who = (mainIds.size() + supportIds.size()) > 1
                        ? (mainIds.size() + supportIds.size()) + " nhân viên" : "1 nhân viên";
                session.setAttribute("successMessage",
                    "Đã tạo và giao công việc cho " + who + ". Trạng thái: Đang thực hiện.");
                String redirectView = "CUSTOMER".equals(relatedType) ? "customer" : "lead";
                String redirectTaskType = (mainIds.size() + supportIds.size()) > 1 ? "team" : "personal";
                response.sendRedirect(request.getContextPath() + "/manager/task/list?taskType=" + redirectTaskType + "&view=" + redirectView);


            } else {
                session.setAttribute("errorMessage", "Thao tác không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/manager/task/list");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            response.sendRedirect(errorBase);
        }
    }

}