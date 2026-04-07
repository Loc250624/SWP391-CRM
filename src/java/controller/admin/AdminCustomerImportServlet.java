package controller.admin;

import dao.CustomerCoreDAO;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Customer;

@MultipartConfig
@WebServlet(name = "AdminCustomerImportServlet", urlPatterns = {"/admin/customer/import"})
public class AdminCustomerImportServlet extends HttpServlet {

    private CustomerCoreDAO dao = new CustomerCoreDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/admin/customercore/import.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Part filePart = request.getPart("file");
        List<String> errors = new ArrayList<>();
        int imported = 0;

        if (filePart == null || filePart.getSize() == 0) {
            errors.add("No file uploaded.");
        } else {
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(filePart.getInputStream(), "UTF-8"))) {
                String line;
                boolean firstLine = true;
                while ((line = reader.readLine()) != null) {
                    if (firstLine) { firstLine = false; continue; }
                    line = line.trim();
                    if (line.isEmpty()) continue;

                    String[] cols = line.split(",", -1);
                    if (cols.length < 6) {
                        errors.add("Invalid row (expected 6 columns): " + line);
                        continue;
                    }

                    Customer c = new Customer();
                    c.setFullName(cols[0].trim());
                    c.setEmail(cols[1].trim());
                    c.setPhone(cols[2].trim());
                    c.setStatus(cols[3].trim().isEmpty() ? "Active" : cols[3].trim());
                    c.setCustomerSegment(cols[4].trim());
                    c.setCity(cols[5].trim());

                    if (c.getFullName().isEmpty()) {
                        errors.add("Row skipped (missing name): " + line);
                        continue;
                    }

                    int id = dao.createCustomer(c);
                    if (id > 0) {
                        imported++;
                    } else {
                        errors.add("Failed to insert: " + c.getFullName());
                    }
                }
            } catch (Exception e) {
                errors.add("Error reading file: " + e.getMessage());
            }
        }

        request.setAttribute("imported", imported);
        request.setAttribute("errors", errors);
        request.getRequestDispatcher("/view/admin/customercore/import.jsp").forward(request, response);
    }
}
