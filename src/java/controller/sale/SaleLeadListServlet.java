package controller.sale;

import dao.LeadDAO;
import dao.LeadSourceDAO;
import enums.LeadStatus;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Lead;
import model.LeadSource;

@WebServlet(name = "SaleLeadListServlet", urlPatterns = {"/sale/lead/list"})
public class SaleLeadListServlet extends HttpServlet {

    private LeadDAO leadDAO = new LeadDAO();
    private LeadSourceDAO leadSourceDAO = new LeadSourceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get current user ID (default = 1 for now)
        Integer currentUserId = 1;
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            try {
                currentUserId = (Integer) session.getAttribute("userId");
            } catch (Exception e) {
                // Use default userId = 1
            }
        }

        // Get filter parameters
        String statusFilter = request.getParameter("status");
        String ratingFilter = request.getParameter("rating");
        String searchQuery = request.getParameter("search");

        // Load leads - only leads created by or assigned to current user
        List<Lead> leadList = leadDAO.getLeadsBySalesUser(currentUserId);
        if (leadList == null) {
            leadList = new java.util.ArrayList<>();
        }

        // Filter out deleted leads from display
        leadList = leadList.stream()
                .filter(l -> !LeadStatus.Delete.name().equals(l.getStatus()))
                .collect(Collectors.toList());

        // Calculate statistics BEFORE filtering (show total counts)
        int totalLeads = leadList.size();
        long assignedLeads = leadList.stream().filter(l -> LeadStatus.Assigned.name().equals(l.getStatus())).count();
        long hotLeads = leadList.stream().filter(l -> "Hot".equals(l.getRating())).count();
        long convertedLeads = leadList.stream().filter(l -> l.isIsConverted()).count();

        // Apply status filter
        if (statusFilter != null && !statusFilter.isEmpty()) {
            leadList = leadList.stream()
                    .filter(l -> statusFilter.equals(l.getStatus()))
                    .collect(Collectors.toList());
        }

        // Apply rating filter
        if (ratingFilter != null && !ratingFilter.isEmpty()) {
            leadList = leadList.stream()
                    .filter(l -> ratingFilter.equals(l.getRating()))
                    .collect(Collectors.toList());
        }

        // Apply search filter
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            String query = searchQuery.trim().toLowerCase();
            leadList = leadList.stream()
                    .filter(l -> (l.getFullName() != null && l.getFullName().toLowerCase().contains(query))
                            || (l.getEmail() != null && l.getEmail().toLowerCase().contains(query))
                            || (l.getPhone() != null && l.getPhone().contains(query))
                            || (l.getCompanyName() != null && l.getCompanyName().toLowerCase().contains(query))
                            || (l.getLeadCode() != null && l.getLeadCode().toLowerCase().contains(query)))
                    .collect(Collectors.toList());
        }

        // Load lead sources for filter dropdown and source name mapping
        List<LeadSource> sources = leadSourceDAO.getAllActiveSources();
        Map<Integer, String> sourceNameMap = new HashMap<>();
        if (sources != null) {
            for (LeadSource src : sources) {
                sourceNameMap.put(src.getSourceId(), src.getSourceName());
            }
        }

        // Pagination
        int pageSize = 10;
        int totalItems = leadList.size();
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try { currentPage = Math.max(1, Integer.parseInt(pageParam)); } catch (NumberFormatException e) { }
        }
        if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;
        int fromIndex = (currentPage - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalItems);
        List<Lead> pagedList = totalItems > 0 ? leadList.subList(fromIndex, toIndex) : leadList;

        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);

        // Pass data to JSP
        request.setAttribute("leadList", pagedList);
        request.setAttribute("totalLeads", totalLeads);
        request.setAttribute("assignedLeads", assignedLeads);
        request.setAttribute("hotLeads", hotLeads);
        request.setAttribute("convertedLeads", convertedLeads);
        request.setAttribute("leadSources", sources);
        request.setAttribute("sourceNameMap", sourceNameMap);

        // Keep filter values for form state
        request.setAttribute("filterStatus", statusFilter);
        request.setAttribute("filterRating", ratingFilter);
        request.setAttribute("searchQuery", searchQuery);

        // Success/error messages
        String success = request.getParameter("success");
        if ("created".equals(success)) {
            request.setAttribute("successMessage", "Tao lead thanh cong!");
        } else if ("updated".equals(success)) {
            request.setAttribute("successMessage", "Cap nhat lead thanh cong!");
        } else if ("deleted".equals(success)) {
            request.setAttribute("successMessage", "Xoa lead thanh cong!");
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
            doGet(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Lead List Servlet - Displays and manages list of leads";
    }
}
