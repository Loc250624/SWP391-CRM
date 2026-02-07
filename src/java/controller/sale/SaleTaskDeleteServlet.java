package controller.sale;

import dao.TaskDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;

@WebServlet(name = "SaleTaskDeleteServlet", urlPatterns = {"/sale/task/delete"})
public class SaleTaskDeleteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String idParam = request.getParameter("id");
        try {
            int taskId = Integer.parseInt(idParam);
            TaskDAO taskDAO = new TaskDAO();
            boolean deleted = taskDAO.deleteTask(taskId);

            if (!deleted) {
                // Optionally set an error message before redirecting
                session.setAttribute("errorMessage", "Không thể xóa công việc. Công việc không tồn tại hoặc có lỗi xảy ra.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID công việc không hợp lệ.");
        }
        
        response.sendRedirect(request.getContextPath() + "/sale/task/list");
    }

    @Override
    public String getServletInfo() {
        return "Servlet để xóa công việc.";
    }
}
