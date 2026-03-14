package controller.sale;

import dao.CustomerDAO;
import dao.LeadDAO;
import dao.OpportunityDAO;
import dao.PipelineStageDAO;
import dao.QuotationDAO;
import model.Customer;
import model.Lead;
import model.Opportunity;
import model.PipelineStage;
import model.Quotation;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.SessionHelper;

@WebServlet(name = "SaleQuotationFormServlet", urlPatterns = {"/sale/quotation/form"})
public class SaleQuotationFormServlet extends HttpServlet {

    private static final Set<String> ALLOWED_STAGE_CODES = new HashSet<>(Arrays.asList("DEMO", "NEGOTIATION", "PROPOSED"));

    private Integer getCurrentUserId(HttpServletRequest request) {
        return SessionHelper.getLoggedInUserId(request);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int currentUserId = getCurrentUserId(request);
        OpportunityDAO oppDAO = new OpportunityDAO();
        PipelineStageDAO stageDAO = new PipelineStageDAO();
        QuotationDAO quotDAO = new QuotationDAO();
        LeadDAO leadDAO = new LeadDAO();
        CustomerDAO customerDAO = new CustomerDAO();

        // Load all active courses (for lead-based opps)
        List<Map<String, Object>> courses = quotDAO.getActiveCourses();
        request.setAttribute("courses", courses);

        // Track if we need enrolled courses for customer
        boolean isCustomerOpp = false;

        // Edit mode
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int qId = Integer.parseInt(idParam);
                Quotation existing = quotDAO.getQuotationById(qId);
                if (existing != null) {
                    request.setAttribute("quotation", existing);
                    request.setAttribute("pageTitle", "Chi tiet De xuat / Bao gia");

                    // Load items, versions, tracking logs
                    request.setAttribute("quotationItems", quotDAO.getItemsByQuotationId(qId));
                    request.setAttribute("quotationVersions", quotDAO.getVersionsByQuotationId(qId));
                    request.setAttribute("trackingLogs", quotDAO.getTrackingLogsByQuotationId(qId));

                    // Load linked lead/customer names
                    if (existing.getLeadId() != null) {
                        Lead linkedLead = leadDAO.getLeadById(existing.getLeadId());
                        if (linkedLead != null) {
                            request.setAttribute("linkedLead", linkedLead);
                        }
                    }
                    if (existing.getCustomerId() != null) {
                        Customer linkedCust = customerDAO.getCustomerById(existing.getCustomerId());
                        if (linkedCust != null) {
                            request.setAttribute("linkedCustomer", linkedCust);
                        }
                    }
                    // Load linked opp
                    if (existing.getOpportunityId() != null) {
                        Opportunity linkedOpp = oppDAO.getOpportunityById(existing.getOpportunityId());
                        if (linkedOpp != null) {
                            request.setAttribute("linkedOpp", linkedOpp);
                        }
                    }
                }
            } catch (NumberFormatException e) {
            }
        }

        // Pre-select opportunity if oppId passed (from kanban)
        String oppIdParam = request.getParameter("oppId");
        Opportunity selectedOpp = null;
        if (oppIdParam != null && !oppIdParam.isEmpty()) {
            try {
                selectedOpp = oppDAO.getOpportunityById(Integer.parseInt(oppIdParam));
                if (selectedOpp != null) {
                    PipelineStage stage = stageDAO.getStageById(selectedOpp.getStageId());
                    if (stage == null || !ALLOWED_STAGE_CODES.contains(stage.getStageCode())) {
                        request.setAttribute("error", "Chi co the tao de xuat o giai doan Demo/Tu van, Dam phan hoac De xuat.");
                        selectedOpp = null;
                    }
                }
            } catch (NumberFormatException e) {
            }
        }
        request.setAttribute("selectedOpp", selectedOpp);

        // Load lead/customer from selectedOpp for read-only display
        if (selectedOpp != null) {
            if (selectedOpp.getLeadId() != null) {
                Lead oppLead = leadDAO.getLeadById(selectedOpp.getLeadId());
                if (oppLead != null) request.setAttribute("selectedOppLead", oppLead);
            }
            if (selectedOpp.getCustomerId() != null) {
                isCustomerOpp = true;
                Customer oppCustomer = customerDAO.getCustomerById(selectedOpp.getCustomerId());
                if (oppCustomer != null) request.setAttribute("selectedOppCustomer", oppCustomer);
                // Load enrolled courses for this customer
                List<Map<String, Object>> enrolledCourses = quotDAO.getEnrolledCoursesByCustomerId(selectedOpp.getCustomerId());
                request.setAttribute("enrolledCourses", enrolledCourses);
            }
        }

        // For edit mode: load enrolled courses if quotation is for a customer
        if (!isCustomerOpp) {
            Quotation editQ = (Quotation) request.getAttribute("quotation");
            if (editQ != null && editQ.getCustomerId() != null) {
                isCustomerOpp = true;
                List<Map<String, Object>> enrolledCourses = quotDAO.getEnrolledCoursesByCustomerId(editQ.getCustomerId());
                request.setAttribute("enrolledCourses", enrolledCourses);
            }
        }
        request.setAttribute("isCustomerOpp", isCustomerOpp);

        // Build user's opportunities at allowed stages for dropdown
        List<Opportunity> userOpps = oppDAO.getOpportunitiesBySalesUser(currentUserId);
        List<Opportunity> allowedOpps = new ArrayList<>();
        for (Opportunity opp : userOpps) {
            PipelineStage stage = stageDAO.getStageById(opp.getStageId());
            if (stage != null && ALLOWED_STAGE_CODES.contains(stage.getStageCode())) {
                allowedOpps.add(opp);
            }
        }
        // Build lead/customer name maps for allowed opps (for JSP data attributes)
        Map<Integer, String> oppLeadNameMap = new java.util.HashMap<>();
        Map<Integer, String> oppCustomerNameMap = new java.util.HashMap<>();
        for (Opportunity opp : allowedOpps) {
            if (opp.getLeadId() != null) {
                Lead ld = leadDAO.getLeadById(opp.getLeadId());
                if (ld != null) oppLeadNameMap.put(opp.getOpportunityId(), ld.getFullName());
            }
            if (opp.getCustomerId() != null) {
                Customer ct = customerDAO.getCustomerById(opp.getCustomerId());
                if (ct != null) oppCustomerNameMap.put(opp.getOpportunityId(), ct.getFullName());
            }
        }
        request.setAttribute("oppLeadNameMap", oppLeadNameMap);
        request.setAttribute("oppCustomerNameMap", oppCustomerNameMap);
        request.setAttribute("allowedOpps", allowedOpps);

        if (request.getAttribute("pageTitle") == null) {
            request.setAttribute("pageTitle", "Tao De xuat moi");
        }
        request.setAttribute("ACTIVE_MENU", "QUOT_FORM");
        request.setAttribute("CONTENT_PAGE", "/view/sale/pages/quotation/form.jsp");
        request.getRequestDispatcher("/view/sale/layout/layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        int currentUserId = getCurrentUserId(request);
        OpportunityDAO oppDAO = new OpportunityDAO();
        QuotationDAO quotDAO = new QuotationDAO();

        // Basic fields
        String title = request.getParameter("title");
        String validUntilStr = request.getParameter("validUntil");
        String description = request.getParameter("description");
        String paymentTerms = request.getParameter("paymentTerms");
        String deliveryTerms = request.getParameter("deliveryTerms");
        String termsConditions = request.getParameter("termsConditions");
        String notes = request.getParameter("notes");
        String internalNotes = request.getParameter("internalNotes");
        String idParam = request.getParameter("quotationId");

        // Opportunity (required - quotation is always for an opp)
        String oppIdStr = request.getParameter("opportunityId");

        // Tax/discount
        String discountTypeStr = request.getParameter("discountType");
        String discountPercentStr = request.getParameter("discountPercent");
        String taxPercentStr = request.getParameter("taxPercent");

        // Validate required
        if (title == null || title.trim().isEmpty() || validUntilStr == null || validUntilStr.trim().isEmpty()) {
            request.setAttribute("error", "Vui long dien day du cac truong bat buoc (Tieu de, Hieu luc den).");
            doGet(request, response);
            return;
        }

        // Parse opportunity (required)
        Integer oppId = null;
        if (oppIdStr != null && !oppIdStr.isEmpty()) {
            try {
                oppId = Integer.parseInt(oppIdStr);
            } catch (NumberFormatException e) {
            }
        }

        if (oppId == null) {
            request.setAttribute("error", "Phai chon Opportunity!");
            doGet(request, response);
            return;
        }

        // Auto-fill lead/customer from opp
        Integer leadId = null;
        Integer customerId = null;
        Opportunity opp = oppDAO.getOpportunityById(oppId);
        if (opp != null) {
            leadId = opp.getLeadId();
            customerId = opp.getCustomerId();
        }

        // Must have either lead or customer from opp
        if (leadId == null && customerId == null) {
            request.setAttribute("error", "Opportunity khong co Lead hoac Customer!");
            doGet(request, response);
            return;
        }

        // Parse discount/tax
        Integer discountPercent = null;
        if (discountPercentStr != null && !discountPercentStr.trim().isEmpty()) {
            try {
                discountPercent = Integer.parseInt(discountPercentStr.trim());
            } catch (NumberFormatException e) {
            }
        }
        Integer taxPercent = null;
        if (taxPercentStr != null && !taxPercentStr.trim().isEmpty()) {
            try {
                taxPercent = Integer.parseInt(taxPercentStr.trim());
            } catch (NumberFormatException e) {
            }
        }

        int quotationId;

        // Edit or create
        if (idParam != null && !idParam.trim().isEmpty()) {
            quotationId = Integer.parseInt(idParam);
            Quotation q = quotDAO.getQuotationById(quotationId);
            if (q != null && "Draft".equals(q.getStatus())) {
                q.setTitle(title.trim());
                q.setDescription(description);
                q.setOpportunityId(oppId);
                q.setLeadId(leadId);
                q.setCustomerId(customerId);
                q.setValidUntil(LocalDate.parse(validUntilStr));
                q.setDiscountType(discountTypeStr);
                q.setDiscountPercent(discountPercent);
                q.setTaxPercent(taxPercent);
                q.setTermsConditions(termsConditions);
                q.setPaymentTerms(paymentTerms);
                q.setDeliveryTerms(deliveryTerms);
                q.setNotes(notes);
                q.setInternalNotes(internalNotes);
                q.setUpdatedBy(currentUserId);
                quotDAO.updateQuotation(q);
            } else {
                response.sendRedirect(request.getContextPath() + "/sale/quotation/list?error=readonly");
                return;
            }
        } else {
            Quotation q = new Quotation();
            q.setQuotationCode(quotDAO.generateQuotationCode());
            q.setTitle(title.trim());
            q.setDescription(description);
            q.setOpportunityId(oppId);
            q.setLeadId(leadId);
            q.setCustomerId(customerId);
            q.setQuoteDate(LocalDate.now());
            q.setValidUntil(LocalDate.parse(validUntilStr));
            q.setStatus("Draft");
            q.setRequiresApproval(true);
            q.setCurrency("VND");
            q.setSubtotal(BigDecimal.ZERO);
            q.setDiscountType(discountTypeStr);
            q.setDiscountPercent(discountPercent);
            q.setDiscountAmount(BigDecimal.ZERO);
            q.setTaxPercent(taxPercent);
            q.setTaxAmount(BigDecimal.ZERO);
            q.setTotalAmount(BigDecimal.ZERO);
            q.setTermsConditions(termsConditions);
            q.setPaymentTerms(paymentTerms);
            q.setDeliveryTerms(deliveryTerms);
            q.setNotes(notes);
            q.setInternalNotes(internalNotes);
            q.setCreatedBy(currentUserId);
            quotationId = quotDAO.insertQuotation(q);
        }

        // Save items
        if (quotationId > 0) {
            quotDAO.deleteItemsByQuotationId(quotationId);

            String[] itemDescs = request.getParameterValues("itemDescription");
            String[] itemQtys = request.getParameterValues("itemQuantity");
            String[] itemPrices = request.getParameterValues("itemUnitPrice");
            String[] itemDiscounts = request.getParameterValues("itemDiscount");
            String[] itemCourseIds = request.getParameterValues("itemCourseId");
            String[] itemTypes = request.getParameterValues("itemType");

            if (itemDescs != null) {
                for (int i = 0; i < itemDescs.length; i++) {
                    if (itemDescs[i] == null || itemDescs[i].trim().isEmpty()) {
                        continue;
                    }

                    int qty = 1;
                    try {
                        qty = Integer.parseInt(itemQtys[i]);
                    } catch (Exception e) {
                    }

                    BigDecimal unitPrice = BigDecimal.ZERO;
                    try {
                        unitPrice = new BigDecimal(itemPrices[i].trim().replace(",", ""));
                    } catch (Exception e) {
                    }

                    int disc = 0;
                    try {
                        disc = Integer.parseInt(itemDiscounts[i].replace("%", "").trim());
                    } catch (Exception e) {
                    }

                    BigDecimal grossTotal = unitPrice.multiply(BigDecimal.valueOf(qty));
                    BigDecimal discAmt = disc > 0 ? grossTotal.multiply(BigDecimal.valueOf(disc)).divide(BigDecimal.valueOf(100)) : BigDecimal.ZERO;
                    BigDecimal lineTotal = grossTotal.subtract(discAmt);

                    Integer courseId = null;
                    if (itemCourseIds != null && i < itemCourseIds.length && !itemCourseIds[i].isEmpty()) {
                        try {
                            courseId = Integer.parseInt(itemCourseIds[i]);
                        } catch (Exception e) {
                        }
                    }

                    String itemType = (itemTypes != null && i < itemTypes.length) ? itemTypes[i] : "Course";

                    quotDAO.insertItem(quotationId, courseId, itemType, itemDescs[i].trim(),
                            qty, unitPrice, disc, discAmt, lineTotal, i + 1, false);
                }
            }

            // Recalculate subtotal, then apply discount/tax for total
            quotDAO.updateSubtotalAndTotal(quotationId);

            // Now apply overall discount & tax
            Quotation saved = quotDAO.getQuotationById(quotationId);
            if (saved != null) {
                BigDecimal subtotal = saved.getSubtotal() != null ? saved.getSubtotal() : BigDecimal.ZERO;
                BigDecimal overallDisc = BigDecimal.ZERO;
                if (discountPercent != null && discountPercent > 0) {
                    overallDisc = subtotal.multiply(BigDecimal.valueOf(discountPercent)).divide(BigDecimal.valueOf(100));
                }
                BigDecimal afterDiscount = subtotal.subtract(overallDisc);
                BigDecimal taxAmt = BigDecimal.ZERO;
                if (taxPercent != null && taxPercent > 0) {
                    taxAmt = afterDiscount.multiply(BigDecimal.valueOf(taxPercent)).divide(BigDecimal.valueOf(100));
                }
                BigDecimal total = afterDiscount.add(taxAmt);

                saved.setDiscountAmount(overallDisc);
                saved.setTaxAmount(taxAmt);
                saved.setTotalAmount(total);
                saved.setUpdatedBy(currentUserId);
                quotDAO.updateQuotation(saved);
            }
        }

        // Insert tracking log and version
        if (quotationId > 0) {
            String ip = request.getRemoteAddr();
            String ua = request.getHeader("User-Agent");
            String deviceType = parseDeviceType(ua);
            String browser = parseBrowser(ua);

            Quotation saved2 = quotDAO.getQuotationById(quotationId);
            BigDecimal totalAmt = saved2 != null && saved2.getTotalAmount() != null ? saved2.getTotalAmount() : BigDecimal.ZERO;

            if (idParam != null && !idParam.trim().isEmpty()) {
                // Edit: tracking + new version
                quotDAO.insertTrackingLog(quotationId, "UPDATED", ip, ua, deviceType, browser);
                int currentVer = saved2 != null && saved2.getVersion() != null ? saved2.getVersion() : 1;
                int newVer = currentVer + 1;
                quotDAO.insertVersion(quotationId, newVer, null, totalAmt, "Cap nhat", "Cap nhat bao gia", currentUserId);
            } else {
                // Create: tracking + version 1
                quotDAO.insertTrackingLog(quotationId, "CREATED", ip, ua, deviceType, browser);
                quotDAO.insertVersion(quotationId, 1, null, totalAmt, "Tao moi", "Phien ban dau tien", currentUserId);
            }
        }

        response.sendRedirect(request.getContextPath() + "/sale/quotation/list?success=1");
    }

    private String parseDeviceType(String ua) {
        if (ua == null) return "Unknown";
        String lower = ua.toLowerCase();
        if (lower.contains("mobile") || lower.contains("android") || lower.contains("iphone")) return "Mobile";
        if (lower.contains("tablet") || lower.contains("ipad")) return "Tablet";
        return "Desktop";
    }

    private String parseBrowser(String ua) {
        if (ua == null) return "Unknown";
        if (ua.contains("Edg/")) return "Edge";
        if (ua.contains("Chrome/")) return "Chrome";
        if (ua.contains("Firefox/")) return "Firefox";
        if (ua.contains("Safari/") && !ua.contains("Chrome")) return "Safari";
        return "Other";
    }
}
