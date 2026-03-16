package controller.sale;

import dao.CustomerDAO;
import dao.CustomerTagDAO;
import dao.EnrollmentDAO;
import dao.LeadSourceDAO;
import dao.QuotationDAO;
import enums.CustomerSegment;
import enums.CustomerStatus;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.SessionHelper;
import model.Customer;
import model.CustomerEnrollment;
import model.CustomerTag;
import model.LeadSource;
import util.AuditUtil;

@WebServlet(name = "SaleCustomerFormServlet", urlPatterns = {"/sale/customer/form"})
public class SaleCustomerFormServlet extends HttpServlet {

    private CustomerDAO customerDAO = new CustomerDAO();
    private LeadSourceDAO leadSourceDAO = new LeadSourceDAO();
    private CustomerTagDAO customerTagDAO = new CustomerTagDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer currentUserId = SessionHelper.getLoggedInUserId(request);
        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String customerIdParam = request.getParameter("id");
        Customer customer = null;

        if (customerIdParam != null && !customerIdParam.isEmpty()) {
            try {
                int customerId = Integer.parseInt(customerIdParam);
                customer = customerDAO.getCustomerById(customerId);

                if (customer == null) {
                    response.sendRedirect(request.getContextPath() + "/sale/customer/list");
                    return;
                }

                boolean hasPermission = (customer.getCreatedBy() != null && customer.getCreatedBy().equals(currentUserId))
                        || (customer.getOwnerId() != null && customer.getOwnerId().equals(currentUserId));

                if (!hasPermission) {
                    response.sendRedirect(request.getContextPath() + "/sale/customer/list?error=no_permission");
                    return;
                }

                request.setAttribute("mode", "edit");
                request.setAttribute("customer", customer);

                // Load assigned tags for this customer
                List<Integer> assignedTagIds = customerTagDAO.getTagIdsByCustomerId(customer.getCustomerId());
                request.setAttribute("assignedTagIds", assignedTagIds);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/sale/customer/list");
                return;
            }
        } else {
            request.setAttribute("mode", "create");
        }

        request.setAttribute("customerStatuses", CustomerStatus.values());
        request.setAttribute("customerSegments", CustomerSegment.values());

        List<LeadSource> sources = leadSourceDAO.getAllActiveSources();
        request.setAttribute("leadSources", sources);

        // Load all active tags
        List<CustomerTag> allTags = customerTagDAO.getAllActiveTags();
        request.setAttribute("allTags", allTags);

        // Load active courses for course picker
        QuotationDAO quotationDAO = new QuotationDAO();
        List<Map<String, Object>> courses = quotationDAO.getActiveCourses();
        request.setAttribute("courses", courses);

        request.setAttribute("ACTIVE_MENU", "CUSTOMER_FORM");
        request.setAttribute("pageTitle", customerIdParam != null ? "Edit Customer" : "Create New Customer");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/customer/form.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String customerIdParam = request.getParameter("customerId");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String dobStr = request.getParameter("dateOfBirth");
        String gender = request.getParameter("gender");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String sourceIdParam = request.getParameter("sourceId");
        String customerSegment = request.getParameter("customerSegment");
        String status = request.getParameter("status");
        String notes = request.getParameter("notes");
        String emailOptOutStr = request.getParameter("emailOptOut");
        String smsOptOutStr = request.getParameter("smsOptOut");
        String[] tagIdParams = request.getParameterValues("tagIds");
        String[] courseIdParams = request.getParameterValues("courseIds");

        // Validation
        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("error", "Ho ten la bat buoc!");
            doGet(request, response);
            return;
        }
        if (fullName.trim().length() > 150) {
            request.setAttribute("error", "Ho ten khong duoc vuot qua 150 ky tu!");
            doGet(request, response);
            return;
        }
        if (email != null && !email.trim().isEmpty()) {
            if (!email.trim().matches("^[\\w.%+-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
                request.setAttribute("error", "Email khong hop le!");
                doGet(request, response);
                return;
            }
            if (email.trim().length() > 255) {
                request.setAttribute("error", "Email khong duoc vuot qua 255 ky tu!");
                doGet(request, response);
                return;
            }
        }
        if (phone != null && !phone.trim().isEmpty()) {
            if (!phone.trim().matches("^[0-9+\\-()\\s]{7,20}$")) {
                request.setAttribute("error", "So dien thoai khong hop le!");
                doGet(request, response);
                return;
            }
        }
        if (dobStr != null && !dobStr.trim().isEmpty()) {
            try {
                LocalDate dob = LocalDate.parse(dobStr);
                if (dob.isAfter(LocalDate.now())) {
                    request.setAttribute("error", "Ngay sinh khong duoc o tuong lai!");
                    doGet(request, response);
                    return;
                }
            } catch (Exception e) {
                request.setAttribute("error", "Ngay sinh khong hop le!");
                doGet(request, response);
                return;
            }
        }
        if (status != null && !status.isEmpty()) {
            try {
                CustomerStatus.valueOf(status);
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", "Trang thai khong hop le!");
                doGet(request, response);
                return;
            }
        }
        if (customerSegment != null && !customerSegment.isEmpty()) {
            try {
                CustomerSegment.valueOf(customerSegment);
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", "Phan khuc khong hop le!");
                doGet(request, response);
                return;
            }
        }

        Customer customer = new Customer();
        boolean isEdit = false;

        if (customerIdParam != null && !customerIdParam.isEmpty()) {
            isEdit = true;
            try {
                customer.setCustomerId(Integer.parseInt(customerIdParam));
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid customer ID!");
                doGet(request, response);
                return;
            }
        }

        customer.setFullName(fullName.trim());
        customer.setEmail(email != null && !email.trim().isEmpty() ? email.trim() : null);
        customer.setPhone(phone != null && !phone.trim().isEmpty() ? phone.trim() : null);

        if (dobStr != null && !dobStr.trim().isEmpty()) {
            try {
                customer.setDateOfBirth(LocalDate.parse(dobStr));
            } catch (Exception e) {
                customer.setDateOfBirth(null);
            }
        }

        customer.setGender(gender != null && !gender.trim().isEmpty() ? gender.trim() : null);
        customer.setAddress(address != null && !address.trim().isEmpty() ? address.trim() : null);
        customer.setCity(city != null && !city.trim().isEmpty() ? city.trim() : null);
        customer.setCustomerSegment(customerSegment != null && !customerSegment.isEmpty() ? customerSegment : "New");
        customer.setStatus(status != null && !status.isEmpty() ? status : "Active");
        customer.setNotes(notes != null && !notes.trim().isEmpty() ? notes.trim() : null);
        customer.setEmailOptOut("on".equals(emailOptOutStr));
        customer.setSmsOptOut("on".equals(smsOptOutStr));
        customer.setTotalCourses(0);
        customer.setTotalSpent(BigDecimal.ZERO);

        if (sourceIdParam != null && !sourceIdParam.isEmpty()) {
            try {
                customer.setSourceId(Integer.parseInt(sourceIdParam));
            } catch (NumberFormatException e) {
                customer.setSourceId(null);
            }
        }

        Integer currentUserId = SessionHelper.getLoggedInUserId(request);
        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!isEdit) {
            customer.setCreatedBy(currentUserId);
            customer.setOwnerId(currentUserId);
        }

        // Capture old values for update audit
        Customer oldCustomer = null;
        if (isEdit) {
            oldCustomer = customerDAO.getCustomerById(customer.getCustomerId());
        }

        boolean success;
        if (isEdit) {
            success = customerDAO.updateCustomer(customer);
        } else {
            success = customerDAO.insertCustomer(customer);
        }

        if (success) {
            // Audit log
            String newVals = "fullName=" + customer.getFullName()
                    + ", email=" + customer.getEmail()
                    + ", phone=" + customer.getPhone()
                    + ", status=" + customer.getStatus()
                    + ", segment=" + customer.getCustomerSegment();
            if (isEdit) {
                String oldVals = oldCustomer != null
                        ? "fullName=" + oldCustomer.getFullName()
                        + ", email=" + oldCustomer.getEmail()
                        + ", phone=" + oldCustomer.getPhone()
                        + ", status=" + oldCustomer.getStatus()
                        + ", segment=" + oldCustomer.getCustomerSegment()
                        : null;
                AuditUtil.logUpdate(request, currentUserId, "Customer", customer.getCustomerId(), oldVals, newVals);
            } else {
                AuditUtil.logCreate(request, currentUserId, "Customer", customer.getCustomerId(), newVals);
            }
            // Save tag assignments
            List<Integer> tagIds = new ArrayList<>();
            if (tagIdParams != null) {
                for (String tid : tagIdParams) {
                    try {
                        tagIds.add(Integer.parseInt(tid));
                    } catch (NumberFormatException e) {
                    }
                }
            }
            customerTagDAO.assignTags(customer.getCustomerId(), tagIds, currentUserId);

            // Save course enrollments (only for new customer)
            if (!isEdit && courseIdParams != null && courseIdParams.length > 0) {
                EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
                QuotationDAO quotationDAO2 = new QuotationDAO();
                List<Map<String, Object>> allCourses = quotationDAO2.getActiveCourses();
                List<String> courseNames = new ArrayList<>();

                for (String cid : courseIdParams) {
                    try {
                        int courseId = Integer.parseInt(cid);
                        // Find course price from active courses list
                        BigDecimal coursePrice = BigDecimal.ZERO;
                        String cName = "";
                        for (Map<String, Object> c : allCourses) {
                            if (((Number) c.get("courseId")).intValue() == courseId) {
                                coursePrice = (BigDecimal) c.get("price");
                                cName = (String) c.get("courseName");
                                break;
                            }
                        }
                        CustomerEnrollment en = new CustomerEnrollment();
                        en.setCustomerId(customer.getCustomerId());
                        en.setCourseId(courseId);
                        en.setEnrolledDate(LocalDate.now());
                        en.setOriginalPrice(coursePrice);
                        en.setDiscountAmount(BigDecimal.ZERO);
                        en.setFinalAmount(coursePrice);
                        en.setPaymentStatus("Pending");
                        en.setLearningStatus("Not Started");
                        en.setProgressPercentage(0);
                        en.setLessonsCompleted(0);
                        en.setCreatedBy(currentUserId);
                        enrollmentDAO.insertEnrollment(en);
                        if (!cName.isEmpty()) courseNames.add(cName);
                    } catch (NumberFormatException ignored) {}
                }

                // Update totalCourses and purchasedCourses on customer
                if (!courseNames.isEmpty()) {
                    customer.setTotalCourses(courseNames.size());
                    customer.setPurchasedCourses(String.join(", ", courseNames));
                    customerDAO.updateCustomer(customer);
                }
            }

            // Notify customer created (only for new)
            if (!isEdit) {
                java.util.List<Integer> notifyIds = new java.util.ArrayList<>();
                dao.UserDAO userDAO = new dao.UserDAO();
                for (model.Users u : userDAO.getAllUsers()) {
                    String rc = userDAO.getRoleCodeByUserId(u.getUserId());
                    if ("MANAGER".equals(rc) && u.getUserId() != currentUserId) {
                        notifyIds.add(u.getUserId());
                    }
                }
                if (!notifyIds.isEmpty()) {
                    util.NotificationUtil.notifyCustomerCreated(
                            customer.getCustomerId(),
                            customer.getCustomerCode(),
                            customer.getFullName(),
                            currentUserId, notifyIds);
                }

                // Auto-send welcome email to new customer
                if (util.EmailSendUtil.isConfigured()
                        && customer.getEmail() != null && !customer.getEmail().isEmpty()) {
                    java.util.Map<String, String> vars = new java.util.HashMap<>();
                    vars.put("customer_name", customer.getFullName());
                    vars.put("customer_code", customer.getCustomerCode() != null ? customer.getCustomerCode() : "");
                    util.EmailSendUtil.sendWithTemplateAsync("CUSTOMER_WELCOME", vars,
                            customer.getEmail(), customer.getFullName(), currentUserId);
                }
            }

            response.sendRedirect(request.getContextPath() + "/sale/customer/list?success=" +
                    (isEdit ? "updated" : "created"));
        } else {
            request.setAttribute("error", "Luu customer that bai. Vui long thu lai.");
            request.setAttribute("customer", customer);
            doGet(request, response);
        }
    }
}
