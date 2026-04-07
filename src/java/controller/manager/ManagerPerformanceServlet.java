package controller.manager;

import dao.TaskDAO;
import dao.UserDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Map;
import model.Users;

@WebServlet(name = "ManagerPerformanceServlet", urlPatterns = {"/manager/performance"})
public class ManagerPerformanceServlet extends HttpServlet {

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
        String roleCode = userDAO.getRoleCodeByUserId(currentUser.getUserId());

        if (!"MANAGER".equals(roleCode)) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        // All members (all users in system)
        List<Users> allUsers = userDAO.getAllUsers();
        List<Users> deptMembersList = new ArrayList<>();
        List<Integer> allMemberIds  = new ArrayList<>();

        for (Users user : allUsers) {
            deptMembersList.add(user);
            allMemberIds.add(user.getUserId());
        }

        TaskDAO taskDAO = new TaskDAO();

        // Per-employee KPI stats
        List<Map<String, Object>> performanceList = new ArrayList<>();
        for (Users member : deptMembersList) {
            Map<String, Object> stats = taskDAO.getEmployeePerformanceStats(member.getUserId());
            stats.put("userId",    member.getUserId());
            stats.put("firstName", member.getFirstName());
            stats.put("lastName",  member.getLastName());
            stats.put("email",     member.getEmail());
            performanceList.add(stats);
        }

        // Sort by productivityScore descending
        performanceList.sort(Comparator.comparingDouble(
                m -> -((Number) m.getOrDefault("productivityScore", 0.0)).doubleValue()
        ));

        // Dept-wide averages
        double avgCompletionRate = performanceList.stream()
                .mapToDouble(m -> ((Number) m.getOrDefault("completionRate", 0.0)).doubleValue())
                .average().orElse(0.0);
        double avgProductivity = performanceList.stream()
                .mapToDouble(m -> ((Number) m.getOrDefault("productivityScore", 0.0)).doubleValue())
                .average().orElse(0.0);

        request.setAttribute("performanceList",    performanceList);
        request.setAttribute("avgCompletionRate",  avgCompletionRate);
        request.setAttribute("avgProductivity",    avgProductivity);
        request.setAttribute("deptMembers",        deptMembersList);

        request.setAttribute("ACTIVE_MENU",  "PERFORMANCE");
        request.setAttribute("pageTitle",    "Hiệu suất KPI");
        request.setAttribute("CONTENT_PAGE", "/view/manager/performance.jsp");
        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp").forward(request, response);
    }
}
