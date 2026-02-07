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
import java.time.LocalDate;
import java.util.List;
import model.Task;
import model.Users;

@WebServlet(name = "SaleTaskRecurringServlet", urlPatterns = {"/sale/task/recurring"})
public class SaleTaskRecurringServlet extends HttpServlet {

    // Bật/tắt bỏ qua đăng nhập khi test nhanh
    private static final boolean BO_QUA_DANG_NHAP = true;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

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

        request.getRequestDispatcher("/view/sale/pages/task/recurring.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

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

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String assigneeIdParam = request.getParameter("assigneeId");
        String startDateParam = request.getParameter("startDate");
        String intervalType = request.getParameter("intervalType");
        String intervalValueParam = request.getParameter("intervalValue");
        String repeatCountParam = request.getParameter("repeatCount");
        String priorityParam = request.getParameter("priority");
        String statusParam = request.getParameter("status");
        String relatedTypeParam = request.getParameter("relatedToEntityType");
        String relatedIdParam = request.getParameter("relatedToEntityId");

        java.util.List<String> danhSachLoi = new java.util.ArrayList<>();
        int assigneeId = 0;
        int intervalValue = 1;
        int repeatCount = 1;
        int relatedId = 0;
        Date startDate = null;
        Priority priority = Priority.MEDIUM;
        TaskStatus status = TaskStatus.PENDING;

        if (title == null || title.trim().isEmpty()) {
            danhSachLoi.add("Tiêu đề không được để trống.");
        }

        try {
            assigneeId = Integer.parseInt(assigneeIdParam);
        } catch (Exception e) {
            danhSachLoi.add("Người được giao không hợp lệ.");
        }

        try {
            startDate = Date.valueOf(startDateParam);
        } catch (Exception e) {
            danhSachLoi.add("Ngày bắt đầu không hợp lệ.");
        }

        try {
            intervalValue = Integer.parseInt(intervalValueParam);
            if (intervalValue <= 0) {
                intervalValue = 1;
            }
        } catch (Exception e) {
            intervalValue = 1;
        }

        try {
            repeatCount = Integer.parseInt(repeatCountParam);
            if (repeatCount <= 0) {
                repeatCount = 1;
            }
        } catch (Exception e) {
            repeatCount = 1;
        }

        try {
            priority = Priority.valueOf(priorityParam);
        } catch (Exception e) {
            danhSachLoi.add("Mức độ ưu tiên không hợp lệ.");
        }

        try {
            status = TaskStatus.valueOf(statusParam);
        } catch (Exception e) {
            danhSachLoi.add("Trạng thái không hợp lệ.");
        }

        if (relatedTypeParam != null && !relatedTypeParam.isEmpty()) {
            try {
                relatedId = Integer.parseInt(relatedIdParam);
            } catch (Exception e) {
                danhSachLoi.add("Đối tượng liên kết không hợp lệ.");
            }
        }

        if (!danhSachLoi.isEmpty()) {
            request.setAttribute("errorMessage", String.join("<br>", danhSachLoi));
            doGet(request, response);
            return;
        }

        TaskDAO taskDAO = new TaskDAO();
        LocalDate batDau = startDate.toLocalDate();
        for (int i = 0; i < repeatCount; i++) {
            LocalDate ngayHan = tinhNgayTheoChuKy(batDau, intervalType, intervalValue, i);
            Date dueDate = Date.valueOf(ngayHan);
            Task task = new Task(0, title, description, assigneeId, dueDate, priority, status, user.getUserId(), null,
                    relatedTypeParam != null && !relatedTypeParam.isEmpty() ? relatedTypeParam : null, relatedId);
            taskDAO.addTask(task);
        }

        response.sendRedirect(request.getContextPath() + "/sale/task/list");
    }

    private LocalDate tinhNgayTheoChuKy(LocalDate ngayBatDau, String loai, int buoc, int lan) {
        if (loai == null) {
            loai = "DAILY";
        }
        switch (loai) {
            case "WEEKLY":
                return ngayBatDau.plusWeeks((long) buoc * lan);
            case "MONTHLY":
                return ngayBatDau.plusMonths((long) buoc * lan);
            default:
                return ngayBatDau.plusDays((long) buoc * lan);
        }
    }
}
