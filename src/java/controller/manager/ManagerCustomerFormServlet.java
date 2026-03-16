package controller.manager;

import dao.CustomerDAO;
import dao.CustomerTagDAO;
import dao.EnrollmentDAO;
import dao.LeadSourceDAO;
import dao.QuotationDAO;
import dao.UserDAO;
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
import jakarta.servlet.http.HttpSession;
import model.Customer;
import model.CustomerEnrollment;
import model.CustomerTag;
import model.LeadSource;
import model.Users;
import util.AuditUtil;

@WebServlet(name = "ManagerCustomerFormServlet", urlPatterns = {"/manager/crm/customer/form"})
public class ManagerCustomerFormServlet extends HttpServlet {

    private CustomerDAO customerDAO = new CustomerDAO();
    private LeadSourceDAO leadSourceDAO = new LeadSourceDAO();
    private CustomerTagDAO customerTagDAO = new CustomerTagDAO();

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
        if (!"MANAGER".equals(userDAO.getRoleCodeByUserId(currentUser.getUserId()))) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        String customerIdParam = request.getParameter("id");
        Customer customer = null;

        if (customerIdParam != null && !customerIdParam.isEmpty()) {
            try {
                int customerId = Integer.parseInt(customerIdParam);
                customer = customerDAO.getCustomerById(customerId);
                if (customer == null) {
                    response.sendRedirect(request.getContextPath() + "/manager/crm/customers");
                    return;
                }
                request.setAttribute("mode", "edit");
                request.setAttribute("customer", customer);

                List<Integer> assignedTagIds = customerTagDAO.getTagIdsByCustomerId(customer.getCustomerId());
                request.setAttribute("assignedTagIds", assignedTagIds);

                // Load existing enrollments for edit
                EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
                List<CustomerEnrollment> enrollments = enrollmentDAO.getEnrollmentsByCustomerId(customer.getCustomerId());
                request.setAttribute("enrollments", enrollments);

                // Load current owner name for display
                if (customer.getOwnerId() != null) {
                    Users owner = userDAO.getUserById(customer.getOwnerId());
                    if (owner != null) {
                        String ownerName = ((owner.getFirstName() != null ? owner.getFirstName() : "")
                                + " " + (owner.getLastName() != null ? owner.getLastName() : "")).trim();
                        request.setAttribute("ownerName", ownerName);
                    }
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/manager/crm/customers");
                return;
            }
        } else {
            request.setAttribute("mode", "create");
        }

        request.setAttribute("customerStatuses", CustomerStatus.values());
        request.setAttribute("customerSegments", CustomerSegment.values());

        List<LeadSource> sources = leadSourceDAO.getAllActiveSources();
        request.setAttribute("leadSources", sources);

        List<CustomerTag> allTags = customerTagDAO.getAllActiveTags();
        request.setAttribute("allTags", allTags);

        // Load active courses for course picker
        QuotationDAO quotationDAO = new QuotationDAO();
        List<Map<String, Object>> courses = quotationDAO.getActiveCourses();
        request.setAttribute("courses", courses);

        // Load Customer Success (SUPPORT) users for owner assignment
        List<Users> supportUsers = userDAO.getUsersByRoleCode("SUPPORT");
        request.setAttribute("supportUsers", supportUsers);

        request.setAttribute("ACTIVE_MENU", "CRM_CUSTOMERS");
        request.setAttribute("pageTitle", customerIdParam != null ? "Chỉnh sửa Customer" : "Tạo Customer mới");
        request.setAttribute("CONTENT_PAGE", "/view/manager/crm/customer-form.jsp");
        request.getRequestDispatcher("/view/manager/layout/layout-manager.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Users currentUser = (Users) session.getAttribute("user");
        UserDAO userDAO = new UserDAO();
        if (!"MANAGER".equals(userDAO.getRoleCodeByUserId(currentUser.getUserId()))) {
            response.sendRedirect(request.getContextPath() + "/error/403.jsp");
            return;
        }

        int currentUserId = currentUser.getUserId();

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
        String ownerIdParam = request.getParameter("ownerId");

        // Validation
        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("error", "Họ tên là bắt buộc!");
            doGet(request, response);
            return;
        }
        if (fullName.trim().length() > 150) {
            request.setAttribute("error", "Họ tên không được vượt quá 150 ký tự!");
            doGet(request, response);
            return;
        }
        if (dobStr == null || dobStr.trim().isEmpty()) {
            request.setAttribute("error", "Ngày sinh là bắt buộc!");
            doGet(request, response);
            return;
        }
        if (gender == null || gender.trim().isEmpty()) {
            request.setAttribute("error", "Giới tính là bắt buộc!");
            doGet(request, response);
            return;
        }
        if (email != null && !email.trim().isEmpty()) {
            if (!email.trim().matches("^[\\w.%+-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
                request.setAttribute("error", "Email không hợp lệ!");
                doGet(request, response);
                return;
            }
        }
        if (phone != null && !phone.trim().isEmpty()) {
            if (!phone.trim().matches("^[0-9+\\-()\\s]{7,20}$")) {
                request.setAttribute("error", "Số điện thoại không hợp lệ!");
                doGet(request, response);
                return;
            }
        }
        if (dobStr != null && !dobStr.trim().isEmpty()) {
            try {
                LocalDate dob = LocalDate.parse(dobStr);
                if (dob.isAfter(LocalDate.now())) {
                    request.setAttribute("error", "Ngày sinh không được ở tương lai!");
                    doGet(request, response);
                    return;
                }
            } catch (Exception e) {
                request.setAttribute("error", "Ngày sinh không hợp lệ!");
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
                request.setAttribute("error", "ID customer không hợp lệ!");
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

        // Owner assignment (manager can assign to a sales user)
        if (ownerIdParam != null && !ownerIdParam.isEmpty()) {
            try {
                customer.setOwnerId(Integer.parseInt(ownerIdParam));
            } catch (NumberFormatException e) {
                customer.setOwnerId(null);
            }
        }

        if (!isEdit) {
            customer.setCreatedBy(currentUserId);
        }

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
                    try { tagIds.add(Integer.parseInt(tid)); } catch (NumberFormatException ignored) {}
                }
            }
            customerTagDAO.assignTags(customer.getCustomerId(), tagIds, currentUserId);

            // Save course enrollments (create and edit)
            if (courseIdParams != null && courseIdParams.length > 0) {
                EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
                QuotationDAO quotationDAO = new QuotationDAO();
                List<Map<String, Object>> allCourses = quotationDAO.getActiveCourses();
                List<String> courseNames = new ArrayList<>();

                // In edit mode, remove old enrollments and re-insert
                if (isEdit) {
                    enrollmentDAO.deleteEnrollmentsByCustomerId(customer.getCustomerId());
                }

                for (String cid : courseIdParams) {
                    try {
                        int courseId = Integer.parseInt(cid);
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

                if (!courseNames.isEmpty()) {
                    customer.setTotalCourses(courseNames.size());
                    customer.setPurchasedCourses(String.join(", ", courseNames));
                    customerDAO.updateCustomer(customer);
                }
            } else if (isEdit) {
                // No courses selected in edit mode - remove all enrollments
                EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
                enrollmentDAO.deleteEnrollmentsByCustomerId(customer.getCustomerId());
                customer.setTotalCourses(0);
                customer.setPurchasedCourses(null);
                customerDAO.updateCustomer(customer);
            }

            // Send welcome email for new customer
            if (!isEdit && util.EmailSendUtil.isConfigured()
                    && customer.getEmail() != null && !customer.getEmail().isEmpty()) {
                java.util.Map<String, String> vars = new java.util.HashMap<>();
                vars.put("customer_name", customer.getFullName());
                vars.put("customer_code", customer.getCustomerCode() != null ? customer.getCustomerCode() : "");
                util.EmailSendUtil.sendWithTemplateAsync("CUSTOMER_WELCOME", vars,
                        customer.getEmail(), customer.getFullName(), currentUserId);
            }

            response.sendRedirect(request.getContextPath() + "/manager/crm/customers?success=" +
                    (isEdit ? "updated" : "created"));
        } else {
            request.setAttribute("error", "Lưu customer thất bại. Vui lòng thử lại.");
            request.setAttribute("customer", customer);
            doGet(request, response);
        }
    }
}
