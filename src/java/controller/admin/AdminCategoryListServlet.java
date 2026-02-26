package controller.admin;

import dao.CategoryDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Category;

/**
 * Admin – Category Course List
 * GET  /admin/category/list          → danh sách, tìm kiếm, lọc
 * POST /admin/category/list          → xóa hoặc toggle active
 */
@WebServlet(name = "AdminCategoryListServlet", urlPatterns = {"/admin/category/list"})
public class AdminCategoryListServlet extends HttpServlet {

    private CategoryDAO dao = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String q            = request.getParameter("q");
        String activeFilter = request.getParameter("active"); // "active" | "inactive" | ""
        String msg          = request.getParameter("msg");

        List<Category> list = dao.search(q, activeFilter);

        // đếm số courses cho mỗi category
        java.util.Map<Integer, Integer> courseCount = new java.util.HashMap<>();
        for (Category c : list) {
            courseCount.put(c.getCategoryId(), dao.countCourses(c.getCategoryId()));
        }

        request.setAttribute("categories",  list);
        request.setAttribute("courseCount", courseCount);
        request.setAttribute("q",           q);
        request.setAttribute("active",      activeFilter);
        request.setAttribute("msg",         msg);

        request.setAttribute("CONTENT_PAGE", "/view/admin/category/list.jsp");
        request.setAttribute("pageTitle", "Quản lý Danh mục");
        request.setAttribute("ACTIVE_MENU", "CATEGORY_LIST");
        request.getRequestDispatcher("/view/admin/layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idStr  = request.getParameter("id");

        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/category/list");
            return;
        }

        try {
            int id = Integer.parseInt(idStr.trim());

            if ("delete".equals(action)) {
                // Kiểm tra còn khoá học không
                int count = dao.countCourses(id);
                if (count > 0) {
                    response.sendRedirect(request.getContextPath()
                            + "/admin/category/list?msg=cannot_delete&count=" + count);
                    return;
                }
                dao.delete(id);
                response.sendRedirect(request.getContextPath() + "/admin/category/list?msg=deleted");
            } else if ("toggle".equals(action)) {
                dao.toggleActive(id);
                response.sendRedirect(request.getContextPath() + "/admin/category/list?msg=toggled");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/category/list");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/category/list");
        }
    }
}
