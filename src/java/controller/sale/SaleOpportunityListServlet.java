package controller.sale;

import dao.OpportunityDAO;
import dao.PipelineDAO;
import dao.PipelineStageDAO;
import model.Opportunity;
import model.Pipeline;
import model.PipelineStage;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.SessionHelper;

@WebServlet(name = "SaleOpportunityListServlet", urlPatterns = {"/sale/opportunity/list"})
public class SaleOpportunityListServlet extends HttpServlet {

    private OpportunityDAO opportunityDAO = new OpportunityDAO();
    private PipelineDAO pipelineDAO = new PipelineDAO();
    private PipelineStageDAO stageDAO = new PipelineStageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer currentUserId = SessionHelper.getLoggedInUserId(request);
        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get filter parameters
        String pipelineIdParam = request.getParameter("pipeline");
        String statusFilter = request.getParameter("status");
        String searchQuery = request.getParameter("search");

        Integer selectedPipelineId = null;
        if (pipelineIdParam != null && !pipelineIdParam.isEmpty()) {
            try {
                selectedPipelineId = Integer.parseInt(pipelineIdParam);
            } catch (NumberFormatException e) {
            }
        }

        // Load opportunities
        List<Opportunity> opportunityList;
        if (selectedPipelineId != null) {
            opportunityList = opportunityDAO.getOpportunitiesByPipelineAndUser(selectedPipelineId, currentUserId);
        } else {
            opportunityList = opportunityDAO.getOpportunitiesBySalesUser(currentUserId);
        }
        if (opportunityList == null) {
            opportunityList = new java.util.ArrayList<>();
        }

        // Statistics BEFORE filtering
        int totalOpportunities = opportunityList.size();
        BigDecimal totalValue = BigDecimal.ZERO;
        int openCount = 0, wonCount = 0, lostCount = 0;
        for (Opportunity opp : opportunityList) {
            if (opp.getEstimatedValue() != null) {
                totalValue = totalValue.add(opp.getEstimatedValue());
            }
            String st = opp.getStatus();
            if ("Open".equals(st) || "InProgress".equals(st)) openCount++;
            else if ("Won".equals(st)) wonCount++;
            else if ("Lost".equals(st)) lostCount++;
        }

        // Apply status filter
        if (statusFilter != null && !statusFilter.isEmpty()) {
            opportunityList = opportunityList.stream()
                    .filter(o -> statusFilter.equals(o.getStatus()))
                    .collect(Collectors.toList());
        }

        // Apply search filter
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            String query = searchQuery.trim().toLowerCase();
            opportunityList = opportunityList.stream()
                    .filter(o -> (o.getOpportunityName() != null && o.getOpportunityName().toLowerCase().contains(query))
                            || (o.getOpportunityCode() != null && o.getOpportunityCode().toLowerCase().contains(query)))
                    .collect(Collectors.toList());
        }

        // Load pipelines for filter dropdown
        List<Pipeline> pipelines = pipelineDAO.getAllActivePipelines();
        if (pipelines == null) pipelines = new java.util.ArrayList<>();

        // Build pipeline name map and stage name map
        Map<Integer, String> pipelineNameMap = new HashMap<>();
        for (Pipeline p : pipelines) {
            pipelineNameMap.put(p.getPipelineId(), p.getPipelineName());
        }

        List<PipelineStage> allStages = stageDAO.getAllStages();
        Map<Integer, String> stageNameMap = new HashMap<>();
        if (allStages != null) {
            for (PipelineStage s : allStages) {
                stageNameMap.put(s.getStageId(), s.getStageName());
            }
        }

        // Pagination
        int pageSize = 10;
        int totalItems = opportunityList.size();
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try { currentPage = Math.max(1, Integer.parseInt(pageParam)); } catch (NumberFormatException e) { }
        }
        if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;
        int fromIndex = (currentPage - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalItems);
        List<Opportunity> pagedList = totalItems > 0 ? opportunityList.subList(fromIndex, toIndex) : opportunityList;

        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);

        // Set attributes
        request.setAttribute("opportunities", pagedList);
        request.setAttribute("pipelines", pipelines);
        request.setAttribute("pipelineNameMap", pipelineNameMap);
        request.setAttribute("stageNameMap", stageNameMap);
        request.setAttribute("selectedPipelineId", selectedPipelineId);
        request.setAttribute("filterStatus", statusFilter);
        request.setAttribute("searchQuery", searchQuery);

        request.setAttribute("totalOpportunities", totalOpportunities);
        request.setAttribute("totalValue", totalValue);
        request.setAttribute("openCount", openCount);
        request.setAttribute("wonCount", wonCount);
        request.setAttribute("lostCount", lostCount);

        // Success messages
        String success = request.getParameter("success");
        if ("created".equals(success)) {
            request.setAttribute("successMessage", "Tao opportunity thanh cong!");
        } else if ("updated".equals(success)) {
            request.setAttribute("successMessage", "Cap nhat opportunity thanh cong!");
        } else if ("deleted".equals(success)) {
            request.setAttribute("successMessage", "Xoa opportunity thanh cong!");
        }

        request.setAttribute("ACTIVE_MENU", "OPP_LIST");
        request.setAttribute("pageTitle", "Opportunity Management");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/opportunity/list.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer currentUserId = SessionHelper.getLoggedInUserId(request);
        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String oppIdParam = request.getParameter("opportunityId");

        if ("delete".equals(action) && oppIdParam != null) {
            try {
                int oppId = Integer.parseInt(oppIdParam);
                Opportunity opp = opportunityDAO.getOpportunityById(oppId);

                if (opp == null) {
                    response.sendRedirect(request.getContextPath() + "/sale/opportunity/list?error=not_found");
                    return;
                }

                boolean hasPermission = (opp.getCreatedBy() != null && opp.getCreatedBy().equals(currentUserId))
                        || (opp.getOwnerId() != null && opp.getOwnerId().equals(currentUserId));

                if (!hasPermission) {
                    response.sendRedirect(request.getContextPath() + "/sale/opportunity/list?error=no_permission");
                    return;
                }

                boolean success = opportunityDAO.deleteOpportunity(oppId);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/sale/opportunity/list?success=deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/sale/opportunity/list?error=delete_failed");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/sale/opportunity/list?error=invalid_id");
            }
        } else {
            doGet(request, response);
        }
    }
}
