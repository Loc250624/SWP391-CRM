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

    // Bật/tắt bỏ qua đăng nhập khi test nhanh
    private static final boolean BO_QUA_DANG_NHAP = true;

    private void napDuLieuForm(HttpServletRequest request) {
        UserDAO userDAO = new UserDAO();
        request.setAttribute("userList", userDAO.getAllUsers());
        request.setAttribute("taskStatusValues", TaskStatus.values());
        request.setAttribute("priorityValues", Priority.values());

        LeadDAO leadDAO = new LeadDAO();
        CustomerDAO customerDAO = new CustomerDAO();
        OpportunityDAO opportunityDAO = new OpportunityDAO();

        request.setAttribute("leads", leadDAO.getAllLeads());
        request.setAttribute("customers", customerDAO.getAllCustomers());
        request.setAttribute("opportunities", opportunityDAO.getAllOpportunities());
    }

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

        String action = request.getParameter("action");
        TaskDAO taskDAO = new TaskDAO();
        UserDAO userDAO = new UserDAO();
        
        List<Users> userList = userDAO.getAllUsers();
        request.setAttribute("userList", userList);
        request.setAttribute("taskStatusValues", TaskStatus.values());
        request.setAttribute("priorityValues", Priority.values());

        LeadDAO leadDAO = new LeadDAO();
        CustomerDAO customerDAO = new CustomerDAO();
        OpportunityDAO opportunityDAO = new OpportunityDAO();
        request.setAttribute("leads", leadDAO.getAllLeads());
        request.setAttribute("customers", customerDAO.getAllCustomers());
        request.setAttribute("opportunities", opportunityDAO.getAllOpportunities());

        if ("edit".equals(action)) {
            String idParam = request.getParameter("id");
            try {
                int taskId = Integer.parseInt(idParam);
                Task task = taskDAO.getTaskById(taskId);
                if (task == null) {
                    request.setAttribute("errorMessage", "Không tìm thấy công việc với ID được cung cấp.");
                    request.getRequestDispatcher("/view/sale/pages/task/list.jsp").forward(request, response);
                    return;
                }
                request.setAttribute("task", task);
                request.setAttribute("formAction", "edit");
                request.setAttribute("pageTitle", "Chỉnh sửa công việc");
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "ID công việc không hợp lệ.");
                request.getRequestDispatcher("/view/sale/pages/task/list.jsp").forward(request, response);
                return;
            }
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
        // doPost logic remains the same
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
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

        String action = request.getParameter("formAction");
        TaskDAO taskDAO = new TaskDAO();

        if (action == null || action.isEmpty()) {
            action = "create";
        }

        String tieuDeParam = request.getParameter("title");
        String moTaParam = request.getParameter("description");
        String assigneeIdParam = request.getParameter("assigneeId");
        String dueDateParam = request.getParameter("dueDate");
        String priorityParam = request.getParameter("priority");
        String statusParam = request.getParameter("status");
        String relatedTypeParam = request.getParameter("relatedToEntityType");
        String relatedIdParam = request.getParameter("relatedToEntityId");

        java.util.List<String> danhSachLoi = new java.util.ArrayList<>();
        int assigneeIdHopLe = 0;
        Date ngayHetHanHopLe = null;
        Priority uuTienHopLe = Priority.MEDIUM;
        TaskStatus trangThaiHopLe = TaskStatus.PENDING;
        int lienKetIdHopLe = 0;

        if (tieuDeParam == null || tieuDeParam.trim().isEmpty()) {
            danhSachLoi.add("Tiêu đề không được để trống.");
        }

        if (assigneeIdParam == null || assigneeIdParam.trim().isEmpty()) {
            danhSachLoi.add("Vui lòng chọn người được giao.");
        } else {
            try {
                assigneeIdHopLe = Integer.parseInt(assigneeIdParam);
            } catch (NumberFormatException e) {
                danhSachLoi.add("Người được giao không hợp lệ.");
            }
        }

        if (dueDateParam == null || dueDateParam.trim().isEmpty()) {
            danhSachLoi.add("Vui lòng chọn ngày hết hạn.");
        } else {
            try {
                ngayHetHanHopLe = Date.valueOf(dueDateParam);
            } catch (Exception e) {
                danhSachLoi.add("Ngày hết hạn không hợp lệ.");
            }
        }

        if (priorityParam == null || priorityParam.trim().isEmpty()) {
            danhSachLoi.add("Vui lòng chọn mức độ ưu tiên.");
        } else {
            try {
                uuTienHopLe = Priority.valueOf(priorityParam);
            } catch (Exception e) {
                danhSachLoi.add("Mức độ ưu tiên không hợp lệ.");
            }
        }

        if (statusParam == null || statusParam.trim().isEmpty()) {
            danhSachLoi.add("Vui lòng chọn trạng thái.");
        } else {
            try {
                trangThaiHopLe = TaskStatus.valueOf(statusParam);
            } catch (Exception e) {
                danhSachLoi.add("Trạng thái không hợp lệ.");
            }
        }

        if (relatedTypeParam != null && !relatedTypeParam.isEmpty()) {
            if (relatedIdParam == null || relatedIdParam.trim().isEmpty()) {
                danhSachLoi.add("Vui lòng chọn đối tượng liên kết.");
            } else {
                try {
                    lienKetIdHopLe = Integer.parseInt(relatedIdParam);
                } catch (Exception e) {
                    danhSachLoi.add("Đối tượng liên kết không hợp lệ.");
                }
            }
        }

        if (!danhSachLoi.isEmpty()) {
            Task taskNhap = new Task();
            taskNhap.setTitle(tieuDeParam);
            taskNhap.setDescription(moTaParam);
            taskNhap.setAssigneeId(assigneeIdHopLe);
            taskNhap.setDueDate(ngayHetHanHopLe);
            taskNhap.setPriority(uuTienHopLe);
            taskNhap.setStatus(trangThaiHopLe);
            taskNhap.setRelatedToEntityType(relatedTypeParam != null && !relatedTypeParam.isEmpty() ? relatedTypeParam : null);
            taskNhap.setRelatedToEntityId(lienKetIdHopLe);

            request.setAttribute("task", taskNhap);
            request.setAttribute("formAction", action);
            request.setAttribute("pageTitle", "edit".equals(action) ? "Chỉnh sửa công việc" : "Tạo mới công việc");
            request.setAttribute("errorMessage", String.join("<br>", danhSachLoi));
            napDuLieuForm(request);

            request.getRequestDispatcher("/view/sale/pages/task/form.jsp").forward(request, response);
            return;
        }

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
