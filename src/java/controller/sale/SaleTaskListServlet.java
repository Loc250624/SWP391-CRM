package controller.sale;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "SaleTaskListServlet", urlPatterns = {"/sale/task/list"})
public class SaleTaskListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("ACTIVE_MENU", "TASK_LIST");
        request.setAttribute("pageTitle", "Task List");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/task/list.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }
}
