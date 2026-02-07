package controller.sale;

import dao.TaskDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Task;
import model.Users;

@WebServlet(name = "SaleTaskCalendarServlet", urlPatterns = {"/sale/task/calendar"})
public class SaleTaskCalendarServlet extends HttpServlet {

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

        int thang = LocalDate.now().getMonthValue();
        int nam = LocalDate.now().getYear();
        String thangParam = request.getParameter("month");
        String namParam = request.getParameter("year");
        String view = request.getParameter("view");

        try {
            if (thangParam != null) {
                thang = Integer.parseInt(thangParam);
            }
            if (namParam != null) {
                nam = Integer.parseInt(namParam);
            }
        } catch (NumberFormatException e) {
            thang = LocalDate.now().getMonthValue();
            nam = LocalDate.now().getYear();
        }

        YearMonth ym = YearMonth.of(nam, thang);
        LocalDate tuNgay = ym.atDay(1);
        LocalDate denNgay = ym.atEndOfMonth();

        TaskDAO taskDAO = new TaskDAO();
        List<Task> danhSachGoc;
        if ("team".equals(view)) {
            danhSachGoc = taskDAO.getTasksByDepartment(user.getDepartmentId());
            request.setAttribute("viewType", "team");
        } else {
            danhSachGoc = taskDAO.getTasksByAssignee(user.getUserId());
            request.setAttribute("viewType", "personal");
        }

        Map<LocalDate, List<Task>> mapTheoNgay = new HashMap<>();
        for (Task t : danhSachGoc) {
            if (t.getDueDate() == null) {
                continue;
            }
            LocalDate han = t.getDueDate().toLocalDate();
            if ((han.isEqual(tuNgay) || han.isAfter(tuNgay)) && (han.isEqual(denNgay) || han.isBefore(denNgay))) {
                mapTheoNgay.computeIfAbsent(han, k -> new ArrayList<>()).add(t);
            }
        }

        request.setAttribute("month", thang);
        request.setAttribute("year", nam);
        request.setAttribute("startDate", tuNgay);
        request.setAttribute("endDate", denNgay);
        request.setAttribute("taskByDate", mapTheoNgay);
        request.getRequestDispatcher("/view/sale/pages/task/calendar.jsp").forward(request, response);
    }
}
