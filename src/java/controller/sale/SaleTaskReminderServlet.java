package controller.sale;

import dao.TaskDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import model.Task;
import model.Users;

@WebServlet(name = "SaleTaskReminderServlet", urlPatterns = {"/sale/task/reminder"})
public class SaleTaskReminderServlet extends HttpServlet {

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

        String view = request.getParameter("view");
        String daysParam = request.getParameter("days");
        int soNgay = 7;
        try {
            if (daysParam != null && !daysParam.isEmpty()) {
                soNgay = Integer.parseInt(daysParam);
            }
        } catch (NumberFormatException e) {
            soNgay = 7;
        }

        TaskDAO taskDAO = new TaskDAO();
        List<Task> danhSachGoc;
        if ("team".equals(view)) {
            danhSachGoc = taskDAO.getTasksByDepartment(user.getDepartmentId());
            request.setAttribute("viewType", "team");
        } else {
            danhSachGoc = taskDAO.getTasksByAssignee(user.getUserId());
            request.setAttribute("viewType", "personal");
        }

        LocalDate homNay = LocalDate.now();
        LocalDate denNgay = homNay.plusDays(soNgay);
        List<Task> danhSachNhac = new ArrayList<>();
        for (Task t : danhSachGoc) {
            if (t.getDueDate() == null) {
                continue;
            }
            LocalDate han = t.getDueDate().toLocalDate();
            if ((han.isEqual(homNay) || han.isAfter(homNay)) && (han.isEqual(denNgay) || han.isBefore(denNgay))) {
                danhSachNhac.add(t);
            }
        }

        request.setAttribute("days", soNgay);
        request.setAttribute("fromDate", Date.valueOf(homNay));
        request.setAttribute("toDate", Date.valueOf(denNgay));
        request.setAttribute("taskList", danhSachNhac);
        request.getRequestDispatcher("/view/sale/pages/task/reminder.jsp").forward(request, response);
    }
}
