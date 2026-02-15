package controller.sale;

import dao.CustomerDAO;
import dao.LeadDAO;
import dao.OpportunityDAO;
import dao.PipelineDAO;
import dao.PipelineStageDAO;
import model.Customer;
import model.Lead;
import model.Opportunity;
import model.Pipeline;
import model.PipelineStage;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
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

@WebServlet(name = "SaleDashboardServlet", urlPatterns = {"/sale/dashboard"})
public class SaleDashboardServlet extends HttpServlet {

    private OpportunityDAO opportunityDAO = new OpportunityDAO();
    private LeadDAO leadDAO = new LeadDAO();
    private CustomerDAO customerDAO = new CustomerDAO();
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
        // === LEADS ===
        List<Lead> allLeads = leadDAO.getLeadsBySalesUser(currentUserId);
        if (allLeads == null) {
            allLeads = new ArrayList<>();
        }

        int totalLeads = allLeads.size();
        long newLeads = allLeads.stream().filter(l -> "New".equals(l.getStatus())).count();
        long contactedLeads = allLeads.stream().filter(l -> "Contacted".equals(l.getStatus()) || "Working".equals(l.getStatus())).count();
        long qualifiedLeads = allLeads.stream().filter(l -> "Qualified".equals(l.getStatus())).count();
        long convertedLeads = allLeads.stream().filter(l -> l.isIsConverted()).count();
        long hotLeads = allLeads.stream().filter(l -> "Hot".equals(l.getRating())).count();
        long warmLeads = allLeads.stream().filter(l -> "Warm".equals(l.getRating())).count();
        long coldLeads = allLeads.stream().filter(l -> "Cold".equals(l.getRating())).count();
        int leadConversionRate = totalLeads > 0 ? (int) (convertedLeads * 100 / totalLeads) : 0;

        // === CUSTOMERS ===
        List<Customer> allCustomers = customerDAO.getCustomersBySalesUser(currentUserId);
        if (allCustomers == null) {
            allCustomers = new ArrayList<>();
        }

        int totalCustomers = allCustomers.size();
        long activeCustomers = allCustomers.stream().filter(c -> "Active".equals(c.getStatus())).count();
        long vipCustomers = allCustomers.stream().filter(c -> "VIP".equals(c.getCustomerSegment())).count();
        long riskCustomers = allCustomers.stream().filter(c -> "Risk".equals(c.getCustomerSegment())).count();

        BigDecimal totalRevenue = BigDecimal.ZERO;
        int totalCoursesSold = 0;
        for (Customer c : allCustomers) {
            if (c.getTotalSpent() != null) {
                totalRevenue = totalRevenue.add(c.getTotalSpent());
            }
            totalCoursesSold += c.getTotalCourses();
        }

        // === OPPORTUNITIES ===
        List<Opportunity> allOpps = opportunityDAO.getOpportunitiesBySalesUser(currentUserId);
        if (allOpps == null) {
            allOpps = new ArrayList<>();
        }

        // Build stage type map for accurate Won/Lost counting
        List<PipelineStage> allStagesForType = stageDAO.getAllStages();
        Map<Integer, String> stageTypeMap = new HashMap<>();
        if (allStagesForType != null) {
            for (PipelineStage s : allStagesForType) {
                stageTypeMap.put(s.getStageId(), s.getStageType() != null ? s.getStageType() : "open");
            }
        }

        int totalOpps = allOpps.size();
        BigDecimal totalPipelineValue = BigDecimal.ZERO;
        BigDecimal wonValue = BigDecimal.ZERO;
        BigDecimal lostValue = BigDecimal.ZERO;
        BigDecimal weightedForecast = BigDecimal.ZERO;
        int openCount = 0, wonCount = 0, lostCount = 0;

        List<Opportunity> recentOpps = new ArrayList<>();

        for (Opportunity opp : allOpps) {
            BigDecimal val = opp.getEstimatedValue() != null ? opp.getEstimatedValue() : BigDecimal.ZERO;
            String st = opp.getStatus();
            String sType = stageTypeMap.getOrDefault(opp.getStageId(), "open");

            // Count by status OR stage type (whichever indicates Won/Lost)
            if ("Won".equals(st) || "won".equals(sType)) {
                wonValue = wonValue.add(val);
                wonCount++;
            } else if ("Lost".equals(st) || "lost".equals(sType)) {
                lostValue = lostValue.add(val);
                lostCount++;
            } else if (!"Cancelled".equals(st)) {
                totalPipelineValue = totalPipelineValue.add(val);
                weightedForecast = weightedForecast.add(
                        val.multiply(BigDecimal.valueOf(opp.getProbability()))
                                .divide(BigDecimal.valueOf(100), 0, BigDecimal.ROUND_HALF_UP));
                openCount++;
            }
        }

        int winRate = (wonCount + lostCount) > 0 ? (wonCount * 100 / (wonCount + lostCount)) : 0;

        // Recent opportunities (last 5, sorted by updatedAt desc)
        recentOpps = allOpps.stream()
                .sorted((a, b) -> {
                    if (b.getUpdatedAt() == null) {
                        return -1;
                    }
                    if (a.getUpdatedAt() == null) {
                        return 1;
                    }
                    return b.getUpdatedAt().compareTo(a.getUpdatedAt());
                })
                .limit(5)
                .collect(Collectors.toList());

        // === PIPELINE STAGES ===
        List<Pipeline> pipelines = pipelineDAO.getAllActivePipelines();
        Pipeline defaultPipeline = null;
        if (pipelines != null && !pipelines.isEmpty()) {
            for (Pipeline p : pipelines) {
                if (p.isIsDefault()) {
                    defaultPipeline = p;
                    break;
                }
            }
            if (defaultPipeline == null) {
                defaultPipeline = pipelines.get(0);
            }
        }

        List<PipelineStage> stages = new ArrayList<>();
        Map<Integer, Integer> countByStage = new HashMap<>();
        Map<Integer, BigDecimal> valueByStage = new HashMap<>();

        if (defaultPipeline != null) {
            stages = stageDAO.getStagesByPipelineId(defaultPipeline.getPipelineId());
            if (stages == null) {
                stages = new ArrayList<>();
            }

            for (Opportunity opp : allOpps) {
                if (opp.getPipelineId() == defaultPipeline.getPipelineId()
                        && !"Won".equals(opp.getStatus()) && !"Lost".equals(opp.getStatus()) && !"Cancelled".equals(opp.getStatus())) {
                    int sid = opp.getStageId();
                    countByStage.merge(sid, 1, Integer::sum);
                    BigDecimal val = opp.getEstimatedValue() != null ? opp.getEstimatedValue() : BigDecimal.ZERO;
                    valueByStage.merge(sid, val, BigDecimal::add);
                }
            }
        }

        // Stage name map for recent opps
        List<PipelineStage> allStages = stageDAO.getAllStages();
        Map<Integer, String> stageNameMap = new HashMap<>();
        if (allStages != null) {
            for (PipelineStage s : allStages) {
                stageNameMap.put(s.getStageId(), s.getStageName());
            }
        }
        Map<Integer, String> pipelineNameMap = new HashMap<>();
        if (pipelines != null) {
            for (Pipeline p : pipelines) {
                pipelineNameMap.put(p.getPipelineId(), p.getPipelineName());
            }
        }

        // === SET ATTRIBUTES ===
        // Lead stats
        request.setAttribute("totalLeads", totalLeads);
        request.setAttribute("newLeads", newLeads);
        request.setAttribute("contactedLeads", contactedLeads);
        request.setAttribute("qualifiedLeads", qualifiedLeads);
        request.setAttribute("convertedLeads", convertedLeads);
        request.setAttribute("hotLeads", hotLeads);
        request.setAttribute("warmLeads", warmLeads);
        request.setAttribute("coldLeads", coldLeads);
        request.setAttribute("leadConversionRate", leadConversionRate);

        // Customer stats
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("activeCustomers", activeCustomers);
        request.setAttribute("vipCustomers", vipCustomers);
        request.setAttribute("riskCustomers", riskCustomers);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalCoursesSold", totalCoursesSold);

        // Opportunity stats
        request.setAttribute("totalOpps", totalOpps);
        request.setAttribute("openCount", openCount);
        request.setAttribute("wonCount", wonCount);
        request.setAttribute("lostCount", lostCount);
        request.setAttribute("totalPipelineValue", totalPipelineValue);
        request.setAttribute("wonValue", wonValue);
        request.setAttribute("lostValue", lostValue);
        request.setAttribute("weightedForecast", weightedForecast);
        request.setAttribute("winRate", winRate);

        // Pipeline stages
        request.setAttribute("defaultPipeline", defaultPipeline);
        request.setAttribute("stages", stages);
        request.setAttribute("countByStage", countByStage);
        request.setAttribute("valueByStage", valueByStage);

        // Recent opps
        request.setAttribute("recentOpps", recentOpps);
        request.setAttribute("stageNameMap", stageNameMap);
        request.setAttribute("pipelineNameMap", pipelineNameMap);

        request.setAttribute("ACTIVE_MENU", "DASHBOARD");
        request.setAttribute("pageTitle", "Sales Dashboard");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/dashboard.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }
}
