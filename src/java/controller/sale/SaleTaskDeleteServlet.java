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

        int taskId = Integer.parseInt(request.getParameter("id"));
        TaskDAO taskDAO = new TaskDAO();
        boolean deleted = taskDAO.deleteTask(taskId);

        if (!deleted) {
            response.sendRedirect(request.getContextPath() + "/error.jsp?message=Không thể xóa công việc.");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/sale/task/list");
    }

    @Override
    public String getServletInfo() {
        return "Servlet để xóa công việc.";
    }
}