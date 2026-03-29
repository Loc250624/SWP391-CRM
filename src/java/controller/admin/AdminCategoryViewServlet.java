package controller.admin;

import dao.CategoryDAO;
import dao.CourseDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Category;
import model.Course;

/**
 * Admin – Category View (show category details + courses)
 * GET  /admin/category/view?id=X  → hiển thị chi tiết danh mục và danh sách khóa học
 */
@WebServlet(name = "AdminCategoryViewServlet", urlPatterns = {"/admin/category/view"})
public class AdminCategoryViewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");

        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/category/list");
            return;
        }

        try {
            int categoryId = Integer.parseInt(idStr.trim());

            CategoryDAO categoryDAO = new CategoryDAO();
            Category category = categoryDAO.getById(categoryId);

            if (category == null) {
                response.sendRedirect(request.getContextPath() + "/admin/category/list?msg=not_found");
                return;
            }

            CourseDAO courseDAO = new CourseDAO();
            List<Course> courses = courseDAO.getCoursesByCategoryId(categoryId);

            request.setAttribute("category", category);
            request.setAttribute("courses", courses);
            request.setAttribute("CONTENT_PAGE", "/view/admin/category/view.jsp");
            request.setAttribute("pageTitle", "Chi tiết Danh mục: " + category.getCategoryName());
            request.setAttribute("ACTIVE_MENU", "CATEGORY_LIST");
            request.getRequestDispatcher("/view/admin/layout.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/category/list");
        }
    }
}
