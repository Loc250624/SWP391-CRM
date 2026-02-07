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
import model.Task;
import model.Users;

@WebServlet(name = "SaleTaskDeadlineServlet", urlPatterns = {"/sale/task/deadline"})
public class SaleTaskDeadlineServlet extends HttpServlet {

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

        String idParam = request.getParameter("id");
        TaskDAO taskDAO = new TaskDAO();
        try {
            int taskId = Integer.parseInt(idParam);
            Task task = taskDAO.getTaskById(taskId);
            if (task == null) {
                request.setAttribute("errorMessage", "Không tìm thấy công việc.");
                request.getRequestDispatcher("/view/sale/pages/task/list.jsp").forward(request, response);
                return;
            }
            request.setAttribute("task", task);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID công việc không hợp lệ.");
            request.getRequestDispatcher("/view/sale/pages/task/list.jsp").forward(request, response);
            return;
        }

        request.getRequestDispatcher("/view/sale/pages/task/deadline.jsp").forward(request, response);
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

        String taskIdParam = request.getParameter("taskId");
        String dueDateParam = request.getParameter("dueDate");
        if (taskIdParam == null || dueDateParam == null || dueDateParam.isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng chọn ngày hết hạn.");
            request.getRequestDispatcher("/view/sale/pages/task/list.jsp").forward(request, response);
            return;
        }

        try {
            int taskId = Integer.parseInt(taskIdParam);
            Date dueDate = Date.valueOf(dueDateParam);
            TaskDAO taskDAO = new TaskDAO();
            taskDAO.updateTaskDeadline(taskId, dueDate);
            response.sendRedirect(request.getContextPath() + "/sale/task/detail?id=" + taskId);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Ngày hết hạn không hợp lệ.");
            request.getRequestDispatcher("/view/sale/pages/task/list.jsp").forward(request, response);
        }
    }
}
