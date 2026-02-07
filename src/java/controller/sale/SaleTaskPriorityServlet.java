package controller.sale;

import dao.TaskDAO;
import enums.Priority;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Task;
import model.Users;

@WebServlet(name = "SaleTaskPriorityServlet", urlPatterns = {"/sale/task/priority"})
public class SaleTaskPriorityServlet extends HttpServlet {

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
            request.setAttribute("priorityValues", Priority.values());
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID công việc không hợp lệ.");
            request.getRequestDispatcher("/view/sale/pages/task/list.jsp").forward(request, response);
            return;
        }

        request.getRequestDispatcher("/view/sale/pages/task/priority.jsp").forward(request, response);
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
        String priorityParam = request.getParameter("priority");
        if (taskIdParam == null || priorityParam == null) {
            request.setAttribute("errorMessage", "Thiếu thông tin cập nhật ưu tiên.");
            request.getRequestDispatcher("/view/sale/pages/task/list.jsp").forward(request, response);
            return;
        }

        try {
            int taskId = Integer.parseInt(taskIdParam);
            Priority priority = Priority.valueOf(priorityParam);
            TaskDAO taskDAO = new TaskDAO();
            taskDAO.updateTaskPriority(taskId, priority);
            response.sendRedirect(request.getContextPath() + "/sale/task/detail?id=" + taskId);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Mức độ ưu tiên không hợp lệ.");
            request.getRequestDispatcher("/view/sale/pages/task/list.jsp").forward(request, response);
        }
    }
}
