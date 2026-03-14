package controller.sale;

import dao.ActivityDAO;
import dao.OpportunityDAO;
import dao.LeadDAO;
import dao.CustomerDAO;
import model.Activity;
import model.Opportunity;
import model.Lead;
import model.Customer;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.SessionHelper;

@WebServlet(name = "SaleActivityFormServlet", urlPatterns = {"/sale/activity/form"})
public class SaleActivityFormServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer currentUserId = SessionHelper.getLoggedInUserId(request);
        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Load related entities for dropdowns
        OpportunityDAO oppDAO = new OpportunityDAO();
        LeadDAO leadDAO = new LeadDAO();
        CustomerDAO customerDAO = new CustomerDAO();

        List<Opportunity> opportunities = oppDAO.getOpportunitiesBySalesUser(currentUserId);
        request.setAttribute("opportunities", opportunities);

        List<Lead> leads = leadDAO.getLeadsBySalesUser(currentUserId);
        request.setAttribute("leads", leads);

        List<Customer> customers = customerDAO.getCustomersBySalesUser(currentUserId);
        request.setAttribute("customers", customers);

        // Edit mode
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int actId = Integer.parseInt(idParam);
                ActivityDAO actDAO = new ActivityDAO();
                Activity existing = actDAO.getActivityById(actId);
                if (existing != null) {
                    request.setAttribute("activity", existing);
                    request.setAttribute("pageTitle", "Chinh sua Hoat dong");
                }
            } catch (NumberFormatException e) {
            }
        }

        if (request.getAttribute("pageTitle") == null) {
            request.setAttribute("pageTitle", "Ghi nhan Hoat dong");
        }

        request.setAttribute("ACTIVE_MENU", "ACT_FORM");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/activity/form.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        Integer currentUserId = SessionHelper.getLoggedInUserId(request);
        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String activityType = request.getParameter("activityType");
        String relatedType = request.getParameter("relatedType");
        String relatedIdStr = request.getParameter("relatedId");
        String subject = request.getParameter("subject");
        String description = request.getParameter("description");
        String activityDateStr = request.getParameter("activityDate");
        String durationStr = request.getParameter("durationMinutes");
        String callDirection = request.getParameter("callDirection");
        String callResult = request.getParameter("callResult");
        String idParam = request.getParameter("activityId");

        if (subject == null || subject.trim().isEmpty() || activityType == null || activityType.isEmpty()) {
            request.setAttribute("error", "Vui long dien day du cac truong bat buoc.");
            doGet(request, response);
            return;
        }

        Integer relatedId = null;
        if (relatedIdStr != null && !relatedIdStr.isEmpty()) {
            try { relatedId = Integer.parseInt(relatedIdStr); } catch (NumberFormatException e) {}
        }

        Timestamp activityDate = null;
        if (activityDateStr != null && !activityDateStr.isEmpty()) {
            try { activityDate = Timestamp.valueOf(LocalDateTime.parse(activityDateStr)); } catch (Exception e) {}
        }

        Integer durationMinutes = null;
        if (durationStr != null && !durationStr.isEmpty()) {
            try { durationMinutes = Integer.parseInt(durationStr); } catch (NumberFormatException e) {}
        }

        ActivityDAO actDAO = new ActivityDAO();

        if (idParam != null && !idParam.trim().isEmpty()) {
            int activityId = Integer.parseInt(idParam);
            actDAO.updateActivity(activityId, activityType, relatedType, relatedId,
                    subject.trim(), description, activityDate, durationMinutes, callDirection, callResult, "Completed");
        } else {
            actDAO.insertSaleActivity(activityType, relatedType, relatedId,
                    subject.trim(), description, activityDate, durationMinutes, callDirection, callResult,
                    currentUserId, "Completed");
        }

        response.sendRedirect(request.getContextPath() + "/sale/activity/list?success=1");
    }
}
