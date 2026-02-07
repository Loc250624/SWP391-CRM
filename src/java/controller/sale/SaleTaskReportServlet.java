package controller.sale;

import dao.TaskDAO;
import enums.TaskStatus;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.EnumMap;
import java.util.List;
import java.util.Map;
import model.Task;
import model.Users;

@WebServlet(name = "SaleTaskReportServlet", urlPatterns = {"/sale/task/report"})
public class SaleTaskReportServlet extends HttpServlet {

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
        TaskDAO taskDAO = new TaskDAO();
        List<Task> danhSach;
        if ("team".equals(view)) {
            danhSach = taskDAO.getTasksByDepartment(user.getDepartmentId());
            request.setAttribute("viewType", "team");
        } else {
            danhSach = taskDAO.getTasksByAssignee(user.getUserId());
            request.setAttribute("viewType", "personal");
        }

        Map<TaskStatus, Integer> thongKe = new EnumMap<>(TaskStatus.class);
        for (TaskStatus s : TaskStatus.values()) {
            thongKe.put(s, 0);
        }
        for (Task t : danhSach) {
            TaskStatus s = t.getStatus();
            if (s == null) {
                s = TaskStatus.PENDING;
            }
            thongKe.put(s, thongKe.get(s) + 1);
        }

        int tong = danhSach.size();
        int hoanThanh = thongKe.get(TaskStatus.COMPLETED);
        double tyLeHoanThanh = tong == 0 ? 0 : (hoanThanh * 100.0 / tong);

        request.setAttribute("taskList", danhSach);
        request.setAttribute("summary", thongKe);
        request.setAttribute("total", tong);
        request.setAttribute("completed", hoanThanh);
        request.setAttribute("completionRate", tyLeHoanThanh);

        request.getRequestDispatcher("/view/sale/pages/task/report.jsp").forward(request, response);
    }
}
