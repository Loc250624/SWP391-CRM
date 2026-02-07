package controller.sale;

import dao.TaskDAO;
import dao.UserDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Task;
import model.Users;

@WebServlet(name = "SaleTaskListServlet", urlPatterns = {"/sale/task/list"})
public class SaleTaskListServlet extends HttpServlet {

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

        TaskDAO taskDAO = new TaskDAO();
        UserDAO userDAO = new UserDAO();
        List<Task> taskList;
        String view = request.getParameter("view");

        if ("team".equals(view)) {
            taskList = taskDAO.getTasksByDepartment(user.getDepartmentId());
            request.setAttribute("viewType", "team");
        } else {
            taskList = taskDAO.getTasksByAssignee(user.getUserId());
            request.setAttribute("viewType", "personal");
        }
        
        List<Users> userList = userDAO.getAllUsers();

        request.setAttribute("taskList", taskList);
        request.setAttribute("userList", userList);
        request.getRequestDispatcher("/view/sale/pages/task/list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet để hiển thị danh sách công việc.";
    }
}