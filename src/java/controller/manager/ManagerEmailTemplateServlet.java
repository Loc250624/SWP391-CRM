package controller.manager;

import dao.EmailTemplateDAO;
import dao.UserDAO;
import model.EmailTemplate;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;
import util.AuditUtil;

@WebServlet(name = "ManagerEmailTemplateServlet", urlPatterns = {"/manager/email/template"})
public class ManagerEmailTemplateServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Users currentUser = (Users) session.getAttribute("user");
        UserDAO userDAO = new UserDAO();
        if (!"MANAGER".equals(userDAO.getRoleCodeByUserId(currentUser.getUserId()))) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                EmailTemplate template = new EmailTemplateDAO().getById(id);
                if (template != null) {
                    request.setAttribute("template", template);
                    request.setAttribute("isEdit", true);
                }
            } catch (NumberFormatException ignored) {}
        }

        request.setAttribute("ACTIVE_MENU", "EMAIL_MANAGE");
        request.setAttribute("pageTitle", request.getAttribute("isEdit") != null ? "Sửa mẫu Email" : "Tạo mẫu Email");
        request.setAttribute("CONTENT_PAGE", "/view/manager/email/email-template-form.jsp");
        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Users currentUser = (Users) session.getAttribute("user");
        UserDAO userDAO = new UserDAO();
        if (!"MANAGER".equals(userDAO.getRoleCodeByUserId(currentUser.getUserId()))) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        String action = request.getParameter("action");

        // Toggle active
        if ("toggleActive".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean active = "true".equals(request.getParameter("active"));
            new EmailTemplateDAO().toggleActive(id, active, currentUser.getUserId());
            AuditUtil.logUpdate(request, currentUser.getUserId(), "EmailTemplate", id,
                    "isActive=" + !active, "isActive=" + active);
            session.setAttribute("successMessage", active ? "Đã bật mẫu email" : "Đã tắt mẫu email");
            response.sendRedirect(request.getContextPath() + "/manager/email#tab-templates");
            return;
        }

        // Delete
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            EmailTemplate delTemplate = new EmailTemplateDAO().getById(id);
            new EmailTemplateDAO().delete(id);
            AuditUtil.logDelete(request, currentUser.getUserId(), "EmailTemplate", id,
                    delTemplate != null ? "code=" + delTemplate.getTemplateCode() + ", name=" + delTemplate.getTemplateName() : null);
            session.setAttribute("successMessage", "Đã xóa mẫu email");
            response.sendRedirect(request.getContextPath() + "/manager/email#tab-templates");
            return;
        }

        // Create / Update
        String idStr = request.getParameter("templateId");
        boolean isEdit = idStr != null && !idStr.isEmpty();

        String templateCode = request.getParameter("templateCode");
        String templateName = request.getParameter("templateName");
        String category = request.getParameter("category");
        String subject = request.getParameter("subject");
        String bodyHtml = request.getParameter("bodyHtml");
        String bodyText = request.getParameter("bodyText");
        String description = request.getParameter("description");
        String availableVariables = request.getParameter("availableVariables");
        boolean isActive = request.getParameter("isActive") != null;
        boolean isDefault = request.getParameter("isDefault") != null;
        String[] allowedRolesArr = request.getParameterValues("allowedRoles");
        String allowedRoles = allowedRolesArr != null ? String.join(",", allowedRolesArr) : null;

        // Validate
        if (templateCode == null || templateCode.trim().isEmpty()
                || templateName == null || templateName.trim().isEmpty()
                || subject == null || subject.trim().isEmpty()
                || bodyHtml == null || bodyHtml.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin bắt buộc");
            response.sendRedirect(request.getContextPath() + "/manager/email/template"
                    + (isEdit ? "?id=" + idStr : ""));
            return;
        }

        EmailTemplateDAO dao = new EmailTemplateDAO();

        // Check unique code
        Integer excludeId = isEdit ? Integer.parseInt(idStr) : null;
        if (dao.isCodeExists(templateCode.trim(), excludeId)) {
            session.setAttribute("errorMessage", "Mã template đã tồn tại: " + templateCode);
            response.sendRedirect(request.getContextPath() + "/manager/email/template"
                    + (isEdit ? "?id=" + idStr : ""));
            return;
        }

        EmailTemplate template = new EmailTemplate();
        if (isEdit) template.setTemplateId(Integer.parseInt(idStr));
        template.setTemplateCode(templateCode.trim().toUpperCase());
        template.setTemplateName(templateName.trim());
        template.setCategory(category != null ? category.trim() : "General");
        template.setSubject(subject.trim());
        template.setBodyHtml(bodyHtml);
        template.setBodyText(bodyText);
        template.setDescription(description != null ? description.trim() : null);
        template.setAvailableVariables(availableVariables != null ? availableVariables.trim() : null);
        template.setIsActive(isActive);
        template.setIsDefault(isDefault);
        template.setAllowedRoles(allowedRoles);

        boolean success;
        if (isEdit) {
            template.setUpdatedBy(currentUser.getUserId());
            success = dao.update(template);
        } else {
            template.setCreatedBy(currentUser.getUserId());
            success = dao.insert(template);
        }

        if (success) {
            String vals = "code=" + template.getTemplateCode() + ", name=" + template.getTemplateName()
                    + ", category=" + template.getCategory() + ", subject=" + template.getSubject();
            if (isEdit) {
                AuditUtil.logUpdate(request, currentUser.getUserId(), "EmailTemplate", template.getTemplateId(), null, vals);
            } else {
                AuditUtil.logCreate(request, currentUser.getUserId(), "EmailTemplate", template.getTemplateId(), vals);
            }
            session.setAttribute("successMessage", isEdit ? "Đã cập nhật mẫu email" : "Đã tạo mẫu email mới");
        } else {
            session.setAttribute("errorMessage", "Lưu mẫu email thất bại");
        }

        response.sendRedirect(request.getContextPath() + "/manager/email");
    }
}
