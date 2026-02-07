package controller.sale;

import dao.LeadDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Lead;

@WebServlet(name = "SaleLeadListServlet", urlPatterns = {"/sale/lead/list"})
public class SaleLeadListServlet extends HttpServlet {

    private LeadDAO leadDAO = new LeadDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get current user ID (default = 1 for now)
        // TODO: Get from session after implementing authentication
        Integer currentUserId = 1;

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            try {
                currentUserId = (Integer) session.getAttribute("userId");
            } catch (Exception e) {
                // Use default userId = 1
            }
        }

        // Get filter parameters (optional)
        String statusFilter = request.getParameter("status");
        String searchQuery = request.getParameter("search");

        // Load leads from database
        // Sales can only see leads created by them OR assigned to them
        List<Lead> leadList = leadDAO.getLeadsBySalesUser(currentUserId);

        // Ensure leadList is not null
        if (leadList == null) {
            leadList = new java.util.ArrayList<>();
        }

        // Apply additional filters if needed
        if (statusFilter != null && !statusFilter.isEmpty()) {
            // Filter by status from the already filtered list
            leadList = leadList.stream()
                    .filter(l -> statusFilter.equals(l.getStatus()))
                    .collect(java.util.stream.Collectors.toList());
        }

        // Calculate statistics
        int totalLeads = leadList.size();
        long newLeads = leadList.stream().filter(l -> "New".equals(l.getStatus())).count();
        long hotLeads = leadList.stream().filter(l -> "Hot".equals(l.getRating())).count();
        long convertedLeads = leadList.stream().filter(l -> l.isIsConverted()).count();

        // Pass data to JSP
        request.setAttribute("leadList", leadList);
        request.setAttribute("totalLeads", totalLeads);
        request.setAttribute("newLeads", newLeads);
        request.setAttribute("hotLeads", hotLeads);
        request.setAttribute("convertedLeads", convertedLeads);

        // Success/error messages
        String success = request.getParameter("success");
        if ("created".equals(success)) {
            request.setAttribute("successMessage", "Lead created successfully!");
        } else if ("updated".equals(success)) {
            request.setAttribute("successMessage", "Lead updated successfully!");
        } else if ("deleted".equals(success)) {
            request.setAttribute("successMessage", "Lead deleted successfully!");
        }

        // Set page metadata
        request.setAttribute("ACTIVE_MENU", "LEAD_LIST");
        request.setAttribute("pageTitle", "Lead Management");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/lead/list.jsp");

        // Forward to layout
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get current user ID
        Integer currentUserId = 1;
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            try {
                currentUserId = (Integer) session.getAttribute("userId");
            } catch (Exception e) {
                // Use default
            }
        }

        // Handle delete action
        String action = request.getParameter("action");
        String leadIdParam = request.getParameter("leadId");

        if ("delete".equals(action) && leadIdParam != null) {
            try {
                int leadId = Integer.parseInt(leadIdParam);

                // Check permission: user can only delete leads they created or are assigned to
                Lead lead = leadDAO.getLeadById(leadId);
                if (lead == null) {
                    response.sendRedirect(request.getContextPath() + "/sale/lead/list?error=not_found");
                    return;
                }

                boolean hasPermission = (lead.getCreatedBy() != null && lead.getCreatedBy().equals(currentUserId))
                        || (lead.getAssignedTo() != null && lead.getAssignedTo().equals(currentUserId));

                if (!hasPermission) {
                    response.sendRedirect(request.getContextPath() + "/sale/lead/list?error=no_permission");
                    return;
                }

                // Delete lead
                boolean success = leadDAO.deleteLead(leadId);

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/sale/lead/list?success=deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/sale/lead/list?error=delete_failed");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/sale/lead/list?error=invalid_id");
            }
        } else {
            // Default: redirect to GET
            doGet(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Lead List Servlet - Displays and manages list of leads";
    }
}
