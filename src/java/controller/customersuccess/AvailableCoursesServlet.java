package controller.customersuccess;

import com.google.gson.Gson;
import dao.CourseDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Course;

@WebServlet(name = "AvailableCoursesServlet", urlPatterns = {"/support/available-courses"})
public class AvailableCoursesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String idStr = request.getParameter("id");
        String type = request.getParameter("type"); 
        
        CourseDAO courseDAO = new CourseDAO();
        List<Course> availableCourses = new ArrayList<>();

        try {
            int id = 0;
            if (idStr != null && !idStr.trim().isEmpty() && !idStr.equals("null")) {
                id = Integer.parseInt(idStr.trim());
            }
            
            if ("Lead".equalsIgnoreCase(type)) {
                availableCourses = courseDAO.getAllActiveCourses();
            } else if ("Customer".equalsIgnoreCase(type)) {
                availableCourses = courseDAO.getAvailableCoursesForCustomer(id);
            }

            // --- PHẦN FIX LỖI LOCALDATETIME ---
            // Tạo một danh sách mới chỉ chứa ID, Tên và Giá để né lỗi Gson không parse được ngày tháng
            List<Map<String, Object>> safeListForJson = new ArrayList<>();
            for (Course c : availableCourses) {
                Map<String, Object> courseMap = new HashMap<>();
                courseMap.put("courseId", c.getCourseId());
                courseMap.put("courseName", c.getCourseName());
                courseMap.put("price", c.getPrice());
                safeListForJson.add(courseMap);
            }

            // Đưa danh sách an toàn này cho Gson dịch
            Gson gson = new Gson();
            String json = gson.toJson(safeListForJson);
            
            PrintWriter out = response.getWriter();
            out.print(json);
            out.flush();
            
        } catch (Exception e) {
            System.out.println("========== LỖI TẠI SERVLET KHÓA HỌC ==========");
            e.printStackTrace(); 
            System.out.println("================================================");
            
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("[]"); 
        }
    }
}