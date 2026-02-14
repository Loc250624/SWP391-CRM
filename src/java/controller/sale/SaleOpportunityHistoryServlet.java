package controller.sale;

import dao.OpportunityDAO;
import dao.OpportunityHistoryDAO;
import dao.PipelineDAO;
import dao.PipelineStageDAO;
import model.Opportunity;
import model.OpportunityHistory;
import model.Pipeline;
import model.PipelineStage;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "SaleOpportunityHistoryServlet", urlPatterns = {"/sale/opportunity/history"})
public class SaleOpportunityHistoryServlet extends HttpServlet {

    private OpportunityDAO opportunityDAO = new OpportunityDAO();
    private OpportunityHistoryDAO historyDAO = new OpportunityHistoryDAO();
    private PipelineDAO pipelineDAO = new PipelineDAO();
    private PipelineStageDAO stageDAO = new PipelineStageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer currentUserId = 1;
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            try {
                currentUserId = (Integer) session.getAttribute("userId");
            } catch (Exception e) {
            }
        }

        // Check if viewing history for a specific opportunity
        String oppIdParam = request.getParameter("oppId");

        // Build name maps for display
        List<Pipeline> pipelines = pipelineDAO.getAllActivePipelines();
        Map<Integer, String> pipelineNameMap = new HashMap<>();
        if (pipelines != null) {
            for (Pipeline p : pipelines) pipelineNameMap.put(p.getPipelineId(), p.getPipelineName());
        }

        List<PipelineStage> allStages = stageDAO.getAllStages();
        Map<Integer, String> stageNameMap = new HashMap<>();
        Map<String, String> stageIdNameMap = new HashMap<>();
        if (allStages != null) {
            for (PipelineStage s : allStages) {
                stageNameMap.put(s.getStageId(), s.getStageName());
                stageIdNameMap.put(String.valueOf(s.getStageId()), s.getStageName());
            }
        }

        Map<String, String> pipelineIdNameMap = new HashMap<>();
        if (pipelines != null) {
            for (Pipeline p : pipelines) pipelineIdNameMap.put(String.valueOf(p.getPipelineId()), p.getPipelineName());
        }

        List<OpportunityHistory> historyList;
        Opportunity selectedOpp = null;

        if (oppIdParam != null && !oppIdParam.isEmpty()) {
            // View history for a specific opportunity
            try {
                int oppId = Integer.parseInt(oppIdParam);
                selectedOpp = opportunityDAO.getOpportunityById(oppId);
                historyList = historyDAO.getHistoryByOpportunityId(oppId);
            } catch (NumberFormatException e) {
                historyList = new ArrayList<>();
            }
        } else {
            // View all history for user's opportunities
            historyList = historyDAO.getHistoryByUserId(currentUserId);
        }

        if (historyList == null) historyList = new ArrayList<>();

        // Build opportunity name map for the history entries
        Map<Integer, String> oppNameMap = new HashMap<>();
        List<Opportunity> userOpps = opportunityDAO.getOpportunitiesBySalesUser(currentUserId);
        if (userOpps != null) {
            for (Opportunity o : userOpps) {
                oppNameMap.put(o.getOpportunityId(), o.getOpportunityName());
            }
        }

        // Filter by field name
        String fieldFilter = request.getParameter("field");
        if (fieldFilter != null && !fieldFilter.isEmpty()) {
            List<OpportunityHistory> filtered = new ArrayList<>();
            for (OpportunityHistory h : historyList) {
                if (fieldFilter.equals(h.getFieldName())) filtered.add(h);
            }
            historyList = filtered;
        }

        // Filter by search keyword (matches opp name, old/new value)
        String search = request.getParameter("search");
        if (search != null && !search.trim().isEmpty()) {
            String kw = search.trim().toLowerCase();
            List<OpportunityHistory> filtered = new ArrayList<>();
            for (OpportunityHistory h : historyList) {
                String oppName = oppNameMap.getOrDefault(h.getOpportunityId(), "");
                if (oppName.toLowerCase().contains(kw)
                        || (h.getOldValue() != null && h.getOldValue().toLowerCase().contains(kw))
                        || (h.getNewValue() != null && h.getNewValue().toLowerCase().contains(kw))
                        || h.getFieldName().toLowerCase().contains(kw)) {
                    filtered.add(h);
                }
            }
            historyList = filtered;
        }

        // Pagination
        int pageSize = 20;
        int totalItems = historyList.size();
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try { currentPage = Math.max(1, Integer.parseInt(pageParam)); } catch (NumberFormatException e) { }
        }
        if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;
        int fromIndex = (currentPage - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalItems);
        List<OpportunityHistory> pagedList = totalItems > 0 ? historyList.subList(fromIndex, toIndex) : historyList;

        request.setAttribute("historyList", pagedList);
        request.setAttribute("oppNameMap", oppNameMap);
        request.setAttribute("stageNameMap", stageNameMap);
        request.setAttribute("pipelineNameMap", pipelineNameMap);
        request.setAttribute("stageIdNameMap", stageIdNameMap);
        request.setAttribute("pipelineIdNameMap", pipelineIdNameMap);
        request.setAttribute("selectedOpp", selectedOpp);
        request.setAttribute("filterField", fieldFilter);
        request.setAttribute("filterOppId", oppIdParam);
        request.setAttribute("filterSearch", search);
        request.setAttribute("userOpps", userOpps);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);

        request.setAttribute("ACTIVE_MENU", "OPP_HISTORY");
        request.setAttribute("pageTitle", "Opportunity History");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/opportunity/history.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }
}
