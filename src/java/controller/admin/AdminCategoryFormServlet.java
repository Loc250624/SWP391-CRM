package controller.admin;

import dao.CategoryDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Category;

/**
 * Admin – Category Course Form (Create / Edit)
 * GET  /admin/category/form          → hiện form rỗng (tạo mới)
 * GET  /admin/category/form?id=X     → hiện form điền sẵn (sửa)
 * POST /admin/category/form          → lưu (insert hoặc update)
 */
@WebServlet(name = "AdminCategoryFormServlet", urlPatterns = {"/admin/category/form"})
public class AdminCategoryFormServlet extends HttpServlet {

    private CategoryDAO dao = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        Category category = null;

        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                category = dao.getById(Integer.parseInt(idStr.trim()));
            } catch (NumberFormatException ignored) {}
        }

        request.setAttribute("category", category);
        request.setAttribute("CONTENT_PAGE", "/view/admin/category/form.jsp");
        request.setAttribute("pageTitle", (category != null ? "Sửa Danh mục" : "Thêm Danh mục"));
        request.setAttribute("ACTIVE_MENU", "CATEGORY_LIST");
        request.getRequestDispatcher("/view/admin/layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String idStr       = request.getParameter("id");
        String code        = request.getParameter("categoryCode");
        String name        = request.getParameter("categoryName");
        String description = request.getParameter("description");
        String activeStr   = request.getParameter("isActive");

        boolean isActive = "1".equals(activeStr) || "true".equals(activeStr) || "on".equals(activeStr);

        // ── Validation ──────────────────────────────────────────
        List<String> errors = new ArrayList<>();
        if (name == null || name.trim().isEmpty()) {
            errors.add("Category name is required.");
        }
        if (code == null || code.trim().isEmpty()) {
            errors.add("Category code is required.");
        }

        Integer editId = null;
        if (idStr != null && !idStr.trim().isEmpty()) {
            try { editId = Integer.parseInt(idStr.trim()); }
            catch (NumberFormatException ignored) {}
        }

        if (!errors.isEmpty() 
            || (name != null && !name.trim().isEmpty() && dao.isNameDuplicate(name.trim(), editId))
            || (code != null && !code.trim().isEmpty() && dao.isCodeDuplicate(code.trim(), editId))) {
            
            if (name != null && !name.trim().isEmpty() && dao.isNameDuplicate(name.trim(), editId)) {
                errors.add("Tên danh mục \"" + name.trim() + "\" đã tồn tại.");
            }
            if (code != null && !code.trim().isEmpty() && dao.isCodeDuplicate(code.trim(), editId)) {
                errors.add("Mã danh mục \"" + code.trim() + "\" đã tồn tại.");
            }
            Category c = new Category();
            c.setCategoryId(editId);
            c.setCategoryCode(code);
            c.setCategoryName(name);
            c.setDescription(description);
            c.setIsActive(isActive);
            request.setAttribute("category", c);
            request.setAttribute("errors",   errors);
            request.setAttribute("CONTENT_PAGE", "/view/admin/category/form.jsp");
            request.setAttribute("pageTitle", (editId != null ? "Sửa Danh mục" : "Thêm Danh mục"));
            request.setAttribute("ACTIVE_MENU", "CATEGORY_LIST");
            request.getRequestDispatcher("/view/admin/layout.jsp").forward(request, response);
            return;
        }

        // ── Save ────────────────────────────────────────────────
        Category c = new Category();
        c.setCategoryCode(code != null ? code.trim() : "");
        c.setCategoryName(name.trim());
        c.setDescription(description != null ? description.trim() : null);
        c.setIsActive(isActive);

        if (editId != null) {
            c.setCategoryId(editId);
            dao.update(c);
        } else {
            dao.insert(c);
        }

        response.sendRedirect(request.getContextPath() + "/admin/category/list?msg=saved");
    }
}
