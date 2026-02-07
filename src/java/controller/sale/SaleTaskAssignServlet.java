package controller.sale;

import dao.TaskDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Task;
import model.Users;

@WebServlet(name = "SaleTaskAssignServlet", urlPatterns = {"/sale/task/assign"})
public class SaleTaskAssignServlet extends HttpServlet {

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
        UserDAO userDAO = new UserDAO();
        List<Users> userList = userDAO.getAllUsers();
        request.setAttribute("userList", userList);

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

        request.getRequestDispatcher("/view/sale/pages/task/assign.jsp").forward(request, response);
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
        String assigneeIdParam = request.getParameter("assigneeId");
        if (taskIdParam == null || assigneeIdParam == null) {
            request.setAttribute("errorMessage", "Thiếu thông tin phân công.");
            request.getRequestDispatcher("/view/sale/pages/task/list.jsp").forward(request, response);
            return;
        }

        try {
            int taskId = Integer.parseInt(taskIdParam);
            int assigneeId = Integer.parseInt(assigneeIdParam);
            TaskDAO taskDAO = new TaskDAO();
            taskDAO.updateTaskAssignee(taskId, assigneeId);
            response.sendRedirect(request.getContextPath() + "/sale/task/detail?id=" + taskId);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Dữ liệu phân công không hợp lệ.");
            request.getRequestDispatcher("/view/sale/pages/task/list.jsp").forward(request, response);
        }
    }
}
