<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
    .selected-contact-preview {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 8px 12px;
        background: #f0f7ff;
        border: 1px solid #b6d4fe;
        border-radius: 6px;
    }
    .selected-contact-preview .avatar {
        width: 36px; height: 36px;
        border-radius: 50%;
        display: flex; align-items: center; justify-content: center;
        font-weight: 700; font-size: .75rem; color: #fff; flex-shrink: 0;
    }
    .selected-contact-preview .info { flex: 1; min-width: 0; }
    .selected-contact-preview .name { font-weight: 600; font-size: .85rem; }
    .selected-contact-preview .meta { font-size: .72rem; color: #6b778c; }
</style>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">
            <c:choose>
                <c:when test="${mode == 'edit'}">Chinh sua Opportunity</c:when>
                <c:otherwise>Tao Opportunity moi</c:otherwise>
            </c:choose>
        </h4>
        <p class="text-muted mb-0">
            <c:choose>
                <c:when test="${mode == 'edit'}">${opportunity.opportunityCode} - ${opportunity.opportunityName}</c:when>
                <c:when test="${convertFromLead}">Chuyen doi tu Lead: ${lead.leadCode} - ${lead.fullName}</c:when>
                <c:otherwise>Nhap thong tin co hoi kinh doanh</c:otherwise>
            </c:choose>
        </p>
    </div>
    <a href="${pageContext.request.contextPath}/sale/opportunity/list" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left me-1"></i>Quay lai</a>
</div>

<!-- Toast Messages -->
<c:if test="${not empty error}">
    <script>document.addEventListener('DOMContentLoaded', function(){ CRM.showToast('${error}', 'error'); });</script>
</c:if>
<c:if test="${convertFromLead}">
    <script>document.addEventListener('DOMContentLoaded', function(){ CRM.showToast('Dang tao opportunity tu Lead ${lead.leadCode} - ${lead.fullName}', 'info'); });</script>
</c:if>

<form method="POST" action="${pageContext.request.contextPath}/sale/opportunity/form" id="oppForm">
    <c:if test="${mode == 'edit'}">
        <input type="hidden" name="opportunityId" value="${opportunity.opportunityId}">
    </c:if>

    <!-- Hidden inputs for selected lead/customer -->
    <input type="hidden" name="leadId" id="hiddenLeadId"
           value="${not empty opportunity ? opportunity.leadId : ''}">
    <input type="hidden" name="customerId" id="hiddenCustomerId"
           value="${not empty opportunity ? opportunity.customerId : ''}">

    <div class="row g-4">
        <!-- Main -->
        <div class="col-lg-8">
            <!-- Lead / Customer -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-person-lines-fill me-2"></i>Lead / Customer <c:if test="${mode != 'edit'}"><span class="text-danger">*</span></c:if></h6>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${mode == 'edit'}">
                            <!-- Edit mode: read-only display -->
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label small text-muted">Lead</label>
                                    <c:choose>
                                        <c:when test="${not empty linkedLead}">
                                            <div class="form-control form-control-sm bg-light">
                                                <i class="bi bi-person me-1 text-primary"></i>${linkedLead.fullName}
                                                <small class="text-muted">(${linkedLead.leadCode})</small>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="form-control form-control-sm bg-light text-muted">-- Khong co --</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small text-muted">Customer</label>
                                    <c:choose>
                                        <c:when test="${not empty linkedCustomer}">
                                            <div class="form-control form-control-sm bg-light">
                                                <i class="bi bi-building me-1 text-success"></i>${linkedCustomer.fullName}
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="form-control form-control-sm bg-light text-muted">-- Khong co --</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <small class="text-muted mt-2 d-block"><i class="bi bi-info-circle me-1"></i>Khong the thay doi Lead/Customer sau khi tao. Chi co the cap nhat Customer khi convert tu Lead.</small>
                        </c:when>
                        <c:otherwise>
                            <!-- Create mode: popup modal selection -->
                            <div class="row g-3">
                                <div class="col-12">
                                    <div class="btn-group btn-group-sm w-100 mb-3" role="group">
                                        <c:set var="leadChecked" value="checked"/>
                                        <c:set var="custChecked" value=""/>
                                        <c:if test="${not empty opportunity && not empty opportunity.customerId && empty opportunity.leadId && !convertFromLead}">
                                            <c:set var="leadChecked" value=""/>
                                            <c:set var="custChecked" value="checked"/>
                                        </c:if>
                                        <input type="radio" class="btn-check" name="contactType" id="typeFromLead" value="lead" autocomplete="off" ${leadChecked}>
                                        <label class="btn btn-outline-primary" for="typeFromLead"><i class="bi bi-person me-1"></i>Tu Lead</label>
                                        <input type="radio" class="btn-check" name="contactType" id="typeFromCustomer" value="customer" autocomplete="off" ${custChecked}>
                                        <label class="btn btn-outline-success" for="typeFromCustomer"><i class="bi bi-building me-1"></i>Tu Customer</label>
                                    </div>
                                </div>

                                <!-- Selected preview -->
                                <div class="col-12" id="selectedPreview" style="display:none;">
                                    <div class="selected-contact-preview">
                                        <div class="avatar" id="previewAvatar">?</div>
                                        <div class="info">
                                            <div class="name" id="previewName"></div>
                                            <div class="meta" id="previewMeta"></div>
                                        </div>
                                        <button type="button" class="btn btn-outline-danger btn-sm" onclick="clearSelection()" title="Bo chon">
                                            <i class="bi bi-x-lg"></i>
                                        </button>
                                    </div>
                                </div>

                                <!-- Buttons to open modals -->
                                <div class="col-12" id="leadPickerBtn">
                                    <button type="button" class="btn btn-outline-primary btn-sm w-100" onclick="openLeadPicker()">
                                        <i class="bi bi-person-plus me-1"></i>Chon Lead <span class="text-danger">*</span>
                                    </button>
                                </div>
                                <div class="col-12" id="customerPickerBtn" style="display:none;">
                                    <button type="button" class="btn btn-outline-success btn-sm w-100" onclick="openCustomerPicker()">
                                        <i class="bi bi-building-add me-1"></i>Chon Customer <span class="text-danger">*</span>
                                    </button>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Thong tin co ban -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-briefcase me-2"></i>Thong tin co ban</h6>
                </div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label small">Ten Opportunity <span class="text-danger">*</span></label>
                            <input type="text" name="opportunityName" class="form-control form-control-sm" required
                                   value="${empty opportunity ? '' : opportunity.opportunityName}" placeholder="VD: Goi khoa hoc Enterprise - Cong ty ABC">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small">Pipeline <span class="text-danger">*</span></label>
                            <c:choose>
                                <c:when test="${mode == 'edit'}">
                                    <input type="hidden" name="pipelineId" value="${opportunity.pipelineId}">
                                    <select class="form-select form-select-sm" disabled>
                                        <c:forEach var="p" items="${pipelines}">
                                            <c:if test="${opportunity.pipelineId == p.pipelineId}">
                                                <option selected>${p.pipelineName}</option>
                                            </c:if>
                                        </c:forEach>
                                    </select>
                                    <small class="text-muted"><i class="bi bi-info-circle me-1"></i>Khong the thay doi Pipeline sau khi tao.</small>
                                </c:when>
                                <c:otherwise>
                                    <select name="pipelineId" class="form-select form-select-sm" id="pipelineSelect" required onchange="loadStages(this.value)">
                                        <option value="">-- Chon pipeline --</option>
                                        <c:forEach var="p" items="${pipelines}">
                                            <c:set var="pSel" value=""/>
                                            <c:if test="${preSelectedPipelineId == p.pipelineId}"><c:set var="pSel" value="selected"/></c:if>
                                            <option value="${p.pipelineId}" ${pSel}>${p.pipelineName}</option>
                                        </c:forEach>
                                    </select>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small">Stage</label>
                            <c:choose>
                                <c:when test="${mode == 'edit'}">
                                    <select class="form-select form-select-sm" disabled>
                                        <c:forEach var="s" items="${stages}">
                                            <c:if test="${opportunity.stageId == s.stageId}">
                                                <option selected>${s.stageName} (${s.probability}%)</option>
                                            </c:if>
                                        </c:forEach>
                                    </select>
                                    <small class="text-muted"><i class="bi bi-info-circle me-1"></i>Stage chi thay doi qua Kanban board.</small>
                                </c:when>
                                <c:otherwise>
                                    <select class="form-select form-select-sm" id="stageSelect" disabled>
                                        <option value="">-- Tu dong chon stage dau --</option>
                                    </select>
                                    <small class="text-muted"><i class="bi bi-info-circle me-1"></i>Stage mac dinh la stage dau tien cua pipeline.</small>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small">Gia tri uoc tinh (VND)</label>
                            <c:set var="estVal" value="${empty opportunity ? '' : opportunity.estimatedValue}"/>
                            <input type="number" name="estimatedValue" class="form-control form-control-sm" min="0" step="100000"
                                   value="${estVal}" placeholder="0">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small">Xac suat thanh cong (%)</label>
                            <c:set var="probVal" value="${empty opportunity ? '' : opportunity.probability}"/>
                            <input type="number" name="probability" class="form-control form-control-sm" min="0" max="100"
                                   value="${probVal}" placeholder="0">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small">Ngay dong du kien</label>
                            <c:set var="closeDateVal" value="${empty opportunity ? '' : opportunity.expectedCloseDate}"/>
                            <input type="date" name="expectedCloseDate" class="form-control form-control-sm"
                                   value="${closeDateVal}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small">Trang thai</label>
                            <c:choose>
                                <c:when test="${mode == 'edit'}">
                                    <input type="text" class="form-control form-control-sm bg-light" value="${opportunity.status}" disabled>
                                    <small class="text-muted"><i class="bi bi-info-circle me-1"></i>Trang thai tu dong thay doi theo Stage.</small>
                                </c:when>
                                <c:otherwise>
                                    <input type="text" class="form-control form-control-sm bg-light" value="Open" disabled>
                                    <small class="text-muted"><i class="bi bi-info-circle me-1"></i>Trang thai mac dinh la Open.</small>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Ghi chu -->
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-journal-text me-2"></i>Ghi chu</h6>
                </div>
                <div class="card-body">
                    <textarea name="notes" class="form-control form-control-sm" rows="4"
                              placeholder="Ghi chu ve co hoi kinh doanh...">${empty opportunity ? '' : opportunity.notes}</textarea>
                </div>
            </div>
        </div>

        <!-- Sidebar -->
        <div class="col-lg-4">
            <!-- Nguon -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-diagram-3 me-2"></i>Nguon & Chien dich</h6>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <label class="form-label small">Nguon</label>
                        <select name="sourceId" class="form-select form-select-sm">
                            <option value="">-- Chon nguon --</option>
                            <c:forEach var="src" items="${sources}">
                                <c:set var="srcSel" value=""/>
                                <c:if test="${not empty opportunity && opportunity.sourceId == src.sourceId}"><c:set var="srcSel" value="selected"/></c:if>
                                <option value="${src.sourceId}" ${srcSel}>${src.sourceName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small">Chien dich</label>
                        <select name="campaignId" class="form-select form-select-sm">
                            <option value="">-- Chon chien dich --</option>
                            <c:forEach var="camp" items="${campaigns}">
                                <c:set var="campSel" value=""/>
                                <c:if test="${not empty opportunity && opportunity.campaignId == camp.campaignId}"><c:set var="campSel" value="selected"/></c:if>
                                <option value="${camp.campaignId}" ${campSel}>${camp.campaignName}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary btn-sm" id="submitBtn">
                            <i class="bi bi-check-lg me-1"></i>
                            <c:choose>
                                <c:when test="${mode == 'edit'}">Cap nhat</c:when>
                                <c:otherwise>Tao Opportunity</c:otherwise>
                            </c:choose>
                        </button>
                        <a href="${pageContext.request.contextPath}/sale/opportunity/list" class="btn btn-outline-secondary btn-sm">
                            <i class="bi bi-x-lg me-1"></i>Huy
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>

<!-- ==================== Lead Picker Modal ==================== -->
<div class="modal fade" id="leadPickerModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content border-0 shadow">
            <div class="modal-header py-2" style="border-bottom: 3px solid #0d6efd;">
                <div>
                    <h6 class="modal-title fw-bold mb-0"><i class="bi bi-person me-2"></i>Chon Lead</h6>
                    <small class="text-muted">Chon mot lead de tao opportunity</small>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-0">
                <div class="p-3 border-bottom bg-light">
                    <div class="input-group input-group-sm">
                        <span class="input-group-text bg-white"><i class="bi bi-search text-muted"></i></span>
                        <input type="text" class="form-control" id="leadSearchInput" placeholder="Tim theo ten, email, SDT, cong ty, ma lead..." oninput="filterRows('leadSearchInput','lead-row','leadPickerEmpty')">
                    </div>
                    <small class="text-muted mt-1 d-block"><span id="leadCountText">${leads != null ? leads.size() : 0}</span> ban ghi</small>
                </div>
                <div class="table-responsive" style="max-height: 400px;">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light sticky-top">
                            <tr><th>Ho ten</th><th>Lien he</th><th>Cong ty</th><th>Trang thai</th></tr>
                        </thead>
                        <tbody id="leadPickerBody">
                            <c:forEach var="ld" items="${leads}">
                                <tr class="lead-row" style="cursor:pointer;"
                                    data-id="${ld.leadId}" data-name="${ld.fullName}" data-email="${ld.email}"
                                    data-phone="${ld.phone}" data-company="${ld.companyName}" data-code="${ld.leadCode}"
                                    onclick="confirmLeadSelection(this)">
                                    <td>
                                        <div class="fw-medium">${ld.fullName}</div>
                                        <small class="text-muted">${ld.leadCode}</small>
                                    </td>
                                    <td>
                                        <c:if test="${not empty ld.email}"><small class="d-block text-truncate" style="max-width:150px;"><i class="bi bi-envelope me-1"></i>${ld.email}</small></c:if>
                                        <c:if test="${not empty ld.phone}"><small class="d-block"><i class="bi bi-telephone me-1"></i>${ld.phone}</small></c:if>
                                    </td>
                                    <td><small>${not empty ld.companyName ? ld.companyName : '-'}</small></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${ld.status == 'Assigned'}"><span class="badge bg-primary-subtle text-primary" style="font-size:.65rem;">Assigned</span></c:when>
                                            <c:when test="${ld.status == 'Working'}"><span class="badge bg-warning-subtle text-warning" style="font-size:.65rem;">Working</span></c:when>
                                            <c:when test="${ld.status == 'Unqualified'}"><span class="badge bg-danger-subtle text-danger" style="font-size:.65rem;">Unqualified</span></c:when>
                                            <c:when test="${ld.status == 'Nurturing'}"><span class="badge bg-info-subtle text-info" style="font-size:.65rem;">Nurturing</span></c:when>
                                            <c:otherwise><span class="badge bg-secondary-subtle text-secondary" style="font-size:.65rem;">${ld.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div id="leadPickerEmpty" class="text-center text-muted py-4" style="display:none;"><i class="bi bi-inbox me-1"></i>Khong tim thay lead nao</div>
            </div>
        </div>
    </div>
</div>

<!-- ==================== Customer Picker Modal ==================== -->
<div class="modal fade" id="customerPickerModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content border-0 shadow">
            <div class="modal-header py-2" style="border-bottom: 3px solid #198754;">
                <div>
                    <h6 class="modal-title fw-bold mb-0"><i class="bi bi-building me-2"></i>Chon Customer</h6>
                    <small class="text-muted">Chon mot customer de tao opportunity</small>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-0">
                <div class="p-3 border-bottom bg-light">
                    <div class="input-group input-group-sm">
                        <span class="input-group-text bg-white"><i class="bi bi-search text-muted"></i></span>
                        <input type="text" class="form-control" id="customerSearchInput" placeholder="Tim theo ten, email, SDT, ma customer..." oninput="filterRows('customerSearchInput','customer-row','customerPickerEmpty')">
                    </div>
                    <small class="text-muted mt-1 d-block"><span id="customerCountText">${customers != null ? customers.size() : 0}</span> ban ghi</small>
                </div>
                <div class="table-responsive" style="max-height: 400px;">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light sticky-top">
                            <tr><th>Ho ten</th><th>Lien he</th><th>Phan khuc</th><th>Trang thai</th></tr>
                        </thead>
                        <tbody id="customerPickerBody">
                            <c:forEach var="cust" items="${customers}">
                                <tr class="customer-row" style="cursor:pointer;"
                                    data-id="${cust.customerId}" data-name="${cust.fullName}" data-email="${cust.email}"
                                    data-phone="${cust.phone}" data-code="${cust.customerCode}" data-segment="${cust.customerSegment}"
                                    onclick="confirmCustomerSelection(this)">
                                    <td>
                                        <div class="fw-medium">${cust.fullName}</div>
                                        <small class="text-muted">${cust.customerCode}</small>
                                    </td>
                                    <td>
                                        <c:if test="${not empty cust.email}"><small class="d-block text-truncate" style="max-width:150px;"><i class="bi bi-envelope me-1"></i>${cust.email}</small></c:if>
                                        <c:if test="${not empty cust.phone}"><small class="d-block"><i class="bi bi-telephone me-1"></i>${cust.phone}</small></c:if>
                                    </td>
                                    <td><small>${not empty cust.customerSegment ? cust.customerSegment : '-'}</small></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${cust.status == 'Active'}"><span class="badge bg-success-subtle text-success" style="font-size:.65rem;">Active</span></c:when>
                                            <c:otherwise><span class="badge bg-secondary-subtle text-secondary" style="font-size:.65rem;">${cust.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div id="customerPickerEmpty" class="text-center text-muted py-4" style="display:none;"><i class="bi bi-inbox me-1"></i>Khong tim thay customer nao</div>
            </div>
        </div>
    </div>
</div>

<script>
    // ===== Load stages dynamically =====
    function loadStages(pipelineId) {
        var stageSelect = document.getElementById('stageSelect');
        stageSelect.innerHTML = '<option value="">-- Dang tai... --</option>';
        if (!pipelineId) {
            stageSelect.innerHTML = '<option value="">-- Chon pipeline truoc --</option>';
            return;
        }
        fetch('${pageContext.request.contextPath}/sale/api/stages?pipelineId=' + pipelineId)
            .then(function(res) { return res.json(); })
            .then(function(stages) {
                stageSelect.innerHTML = '<option value="">-- Tu dong chon stage dau --</option>';
                stages.forEach(function(s) {
                    var opt = document.createElement('option');
                    opt.value = s.stageId;
                    opt.textContent = s.stageName + ' (' + s.probability + '%)';
                    stageSelect.appendChild(opt);
                });
            })
            .catch(function() {
                stageSelect.innerHTML = '<option value="">-- Loi tai stages --</option>';
            });
    }

    // ===== Contact selection logic =====
    var typeFromLead = document.getElementById('typeFromLead');
    var typeFromCustomer = document.getElementById('typeFromCustomer');
    var hiddenLeadId = document.getElementById('hiddenLeadId');
    var hiddenCustomerId = document.getElementById('hiddenCustomerId');
    var selectedPreview = document.getElementById('selectedPreview');
    var leadPickerBtn = document.getElementById('leadPickerBtn');
    var customerPickerBtn = document.getElementById('customerPickerBtn');
    var leadModal = null, customerModal = null;

    function getLeadModal() {
        if (!leadModal) leadModal = new bootstrap.Modal(document.getElementById('leadPickerModal'));
        return leadModal;
    }
    function getCustomerModal() {
        if (!customerModal) customerModal = new bootstrap.Modal(document.getElementById('customerPickerModal'));
        return customerModal;
    }

    function toggleContactType() {
        if (!typeFromLead || !typeFromCustomer) return;
        clearSelection();
        if (typeFromLead.checked) {
            if (leadPickerBtn) leadPickerBtn.style.display = '';
            if (customerPickerBtn) customerPickerBtn.style.display = 'none';
        } else {
            if (leadPickerBtn) leadPickerBtn.style.display = 'none';
            if (customerPickerBtn) customerPickerBtn.style.display = '';
        }
    }

    function openLeadPicker() {
        document.getElementById('leadSearchInput').value = '';
        filterRows('leadSearchInput', 'lead-row', 'leadPickerEmpty');
        getLeadModal().show();
    }

    function openCustomerPicker() {
        document.getElementById('customerSearchInput').value = '';
        filterRows('customerSearchInput', 'customer-row', 'customerPickerEmpty');
        getCustomerModal().show();
    }

    function confirmLeadSelection(row) {
        var id = row.getAttribute('data-id');
        var name = row.getAttribute('data-name') || '';
        var email = row.getAttribute('data-email') || '';
        var phone = row.getAttribute('data-phone') || '';
        var company = row.getAttribute('data-company') || '';
        var code = row.getAttribute('data-code') || '';

        hiddenLeadId.value = id;
        hiddenCustomerId.value = '';
        showPreview(name, code, email, phone, company, 'bg-primary');
        getLeadModal().hide();
    }

    function confirmCustomerSelection(row) {
        var id = row.getAttribute('data-id');
        var name = row.getAttribute('data-name') || '';
        var email = row.getAttribute('data-email') || '';
        var phone = row.getAttribute('data-phone') || '';
        var code = row.getAttribute('data-code') || '';
        var segment = row.getAttribute('data-segment') || '';

        hiddenCustomerId.value = id;
        hiddenLeadId.value = '';
        showPreview(name, code, email, phone, segment ? (segment) : '', 'bg-success');
        getCustomerModal().hide();
    }

    function showPreview(name, code, email, phone, extra, avatarClass) {
        if (!selectedPreview) return;
        var initial = name ? name.charAt(0).toUpperCase() : '?';
        document.getElementById('previewAvatar').className = 'avatar ' + avatarClass;
        document.getElementById('previewAvatar').textContent = initial;
        document.getElementById('previewName').textContent = name;

        var metaParts = [code];
        if (email) metaParts.push(email);
        if (phone) metaParts.push(phone);
        if (extra) metaParts.push(extra);
        document.getElementById('previewMeta').textContent = metaParts.join(' | ');

        selectedPreview.style.display = '';
    }

    function clearSelection() {
        if (hiddenLeadId) hiddenLeadId.value = '';
        if (hiddenCustomerId) hiddenCustomerId.value = '';
        if (selectedPreview) selectedPreview.style.display = 'none';
    }

    // ===== Search / Filter (shared) =====
    function filterRows(inputId, rowClass, emptyId) {
        var query = document.getElementById(inputId).value.toLowerCase().trim();
        var rows = document.querySelectorAll('.' + rowClass);
        var visible = 0;
        rows.forEach(function(row) {
            var text = (row.getAttribute('data-name') || '') + ' ' + (row.getAttribute('data-email') || '') + ' ' +
                       (row.getAttribute('data-phone') || '') + ' ' + (row.getAttribute('data-company') || '') + ' ' +
                       (row.getAttribute('data-code') || '') + ' ' + (row.getAttribute('data-segment') || '');
            var match = !query || text.toLowerCase().indexOf(query) >= 0;
            row.style.display = match ? '' : 'none';
            if (match) visible++;
        });
        var emptyEl = document.getElementById(emptyId);
        if (emptyEl) emptyEl.style.display = visible === 0 ? '' : 'none';
    }

    // ===== Toggle listeners =====
    if (typeFromLead) typeFromLead.addEventListener('change', toggleContactType);
    if (typeFromCustomer) typeFromCustomer.addEventListener('change', toggleContactType);

    // ===== Init on load =====
    (function() {
        var preLeadId = (hiddenLeadId ? hiddenLeadId.value : '') || '';
        var preCustId = (hiddenCustomerId ? hiddenCustomerId.value : '') || '';

        if (preLeadId) {
            // Find lead data from modal rows
            var row = document.querySelector('.lead-row[data-id="' + preLeadId + '"]');
            if (row) {
                showPreview(row.getAttribute('data-name'), row.getAttribute('data-code'),
                    row.getAttribute('data-email'), row.getAttribute('data-phone'),
                    row.getAttribute('data-company'), 'bg-primary');
            }
        } else if (preCustId) {
            if (typeFromCustomer) typeFromCustomer.checked = true;
            toggleContactType();
            var row = document.querySelector('.customer-row[data-id="' + preCustId + '"]');
            if (row) {
                showPreview(row.getAttribute('data-name'), row.getAttribute('data-code'),
                    row.getAttribute('data-email'), row.getAttribute('data-phone'),
                    row.getAttribute('data-segment'), 'bg-success');
            }
        } else {
            toggleContactType();
        }
    })();

    // ===== Form submit =====
    document.getElementById('oppForm').addEventListener('submit', function(e) {
        var mode = '${mode}';
        if (mode !== 'edit') {
            var leadId = hiddenLeadId ? hiddenLeadId.value : '';
            var custId = hiddenCustomerId ? hiddenCustomerId.value : '';
            if (!leadId && !custId) {
                e.preventDefault();
                CRM.showToast('Vui long chon mot Lead hoac Customer!', 'warning');
                return;
            }
        }
        var btn = document.getElementById('submitBtn');
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>Dang luu...';
    });
</script>
