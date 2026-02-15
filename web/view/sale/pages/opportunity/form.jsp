<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
    .contact-table-wrap {
        max-height: 280px;
        overflow-y: auto;
        border: 1px solid #dee2e6;
        border-radius: 6px;
    }
    .contact-table-wrap::-webkit-scrollbar { width: 5px; }
    .contact-table-wrap::-webkit-scrollbar-thumb { background: #c1c7d0; border-radius: 3px; }
    .contact-table {
        margin-bottom: 0;
        font-size: .8rem;
    }
    .contact-table thead { position: sticky; top: 0; z-index: 1; }
    .contact-table tbody tr {
        cursor: pointer;
        transition: background .1s;
    }
    .contact-table tbody tr:hover { background: #e9ecef !important; }
    .contact-table tbody tr.selected-row {
        background: #d0e8ff !important;
        border-left: 3px solid #0d6efd;
    }
    .contact-table tbody tr.selected-row td:first-child { padding-left: 9px; }
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
    .contact-search-box {
        position: relative;
    }
    .contact-search-box i {
        position: absolute; left: 10px; top: 50%; transform: translateY(-50%);
        color: #8993a4; font-size: .8rem;
    }
    .contact-search-box input {
        padding-left: 32px;
        font-size: .8rem;
    }
    .empty-table-msg {
        text-align: center; padding: 24px 12px; color: #8993a4; font-size: .8rem;
    }
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

<!-- Error -->
<c:if test="${not empty error}">
    <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<!-- Convert from Lead info -->
<c:if test="${convertFromLead}">
    <div class="alert alert-info d-flex align-items-center mb-4">
        <i class="bi bi-info-circle-fill me-2"></i>
        Dang tao opportunity tu Lead <strong class="ms-1">${lead.leadCode} - ${lead.fullName}</strong>
    </div>
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
                            <!-- Create mode: searchable table -->
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

                                <!-- Lead table -->
                                <div class="col-12" id="leadTableDiv">
                                    <label class="form-label small fw-medium">Chon Lead <span class="text-danger">*</span></label>
                                    <div class="contact-search-box mb-2">
                                        <i class="bi bi-search"></i>
                                        <input type="text" class="form-control form-control-sm" id="leadSearchInput"
                                               placeholder="Tim theo ten, email, SDT, cong ty, ma lead...">
                                    </div>
                                    <div class="contact-table-wrap">
                                        <table class="table table-hover contact-table">
                                            <thead class="table-light">
                                                <tr>
                                                    <th style="width:35px;"></th>
                                                    <th>Ho ten</th>
                                                    <th>Lien he</th>
                                                    <th>Cong ty</th>
                                                    <th>Trang thai</th>
                                                </tr>
                                            </thead>
                                            <tbody id="leadTableBody">
                                                <c:set var="hasLeads" value="false"/>
                                                <c:forEach var="ld" items="${leads}">
                                                    <c:if test="${!ld.isConverted}">
                                                        <c:set var="hasLeads" value="true"/>
                                                        <tr class="lead-row"
                                                            data-id="${ld.leadId}"
                                                            data-name="${ld.fullName}"
                                                            data-email="${ld.email}"
                                                            data-phone="${ld.phone}"
                                                            data-company="${ld.companyName}"
                                                            data-code="${ld.leadCode}"
                                                            data-status="${ld.status}"
                                                            onclick="selectLead(this)">
                                                            <td class="text-center"><i class="bi bi-circle text-muted" style="font-size:.6rem;"></i></td>
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
                                                                    <c:when test="${ld.status == 'Qualified'}"><span class="badge bg-success-subtle text-success" style="font-size:.65rem;">Qualified</span></c:when>
                                                                    <c:when test="${ld.status == 'Contacted'}"><span class="badge bg-info-subtle text-info" style="font-size:.65rem;">Contacted</span></c:when>
                                                                    <c:when test="${ld.status == 'Working'}"><span class="badge bg-warning-subtle text-warning" style="font-size:.65rem;">Working</span></c:when>
                                                                    <c:otherwise><span class="badge bg-secondary-subtle text-secondary" style="font-size:.65rem;">${ld.status}</span></c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                        </tr>
                                                    </c:if>
                                                </c:forEach>
                                                <c:if test="${!hasLeads}">
                                                    <tr><td colspan="5" class="empty-table-msg"><i class="bi bi-inbox me-1"></i>Chua co lead nao</td></tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                    <small class="text-muted mt-1 d-block" id="leadCountText"></small>
                                </div>

                                <!-- Customer table -->
                                <div class="col-12" id="customerTableDiv" style="display:none;">
                                    <label class="form-label small fw-medium">Chon Customer <span class="text-danger">*</span></label>
                                    <div class="contact-search-box mb-2">
                                        <i class="bi bi-search"></i>
                                        <input type="text" class="form-control form-control-sm" id="customerSearchInput"
                                               placeholder="Tim theo ten, email, SDT, ma customer...">
                                    </div>
                                    <div class="contact-table-wrap">
                                        <table class="table table-hover contact-table">
                                            <thead class="table-light">
                                                <tr>
                                                    <th style="width:35px;"></th>
                                                    <th>Ho ten</th>
                                                    <th>Lien he</th>
                                                    <th>Phan khuc</th>
                                                    <th>Trang thai</th>
                                                </tr>
                                            </thead>
                                            <tbody id="customerTableBody">
                                                <c:choose>
                                                    <c:when test="${not empty customers}">
                                                        <c:forEach var="cust" items="${customers}">
                                                            <tr class="customer-row"
                                                                data-id="${cust.customerId}"
                                                                data-name="${cust.fullName}"
                                                                data-email="${cust.email}"
                                                                data-phone="${cust.phone}"
                                                                data-code="${cust.customerCode}"
                                                                data-segment="${cust.customerSegment}"
                                                                data-status="${cust.status}"
                                                                onclick="selectCustomer(this)">
                                                                <td class="text-center"><i class="bi bi-circle text-muted" style="font-size:.6rem;"></i></td>
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
                                                    </c:when>
                                                    <c:otherwise>
                                                        <tr><td colspan="5" class="empty-table-msg"><i class="bi bi-inbox me-1"></i>Chua co customer nao</td></tr>
                                                    </c:otherwise>
                                                </c:choose>
                                            </tbody>
                                        </table>
                                    </div>
                                    <small class="text-muted mt-1 d-block" id="customerCountText"></small>
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
                            <select name="pipelineId" class="form-select form-select-sm" id="pipelineSelect" required onchange="loadStages(this.value)">
                                <option value="">-- Chon pipeline --</option>
                                <c:forEach var="p" items="${pipelines}">
                                    <c:set var="pSel" value=""/>
                                    <c:if test="${(not empty opportunity && opportunity.pipelineId == p.pipelineId) || preSelectedPipelineId == p.pipelineId}"><c:set var="pSel" value="selected"/></c:if>
                                    <option value="${p.pipelineId}" ${pSel}>${p.pipelineName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small">Stage</label>
                            <select name="stageId" class="form-select form-select-sm" id="stageSelect">
                                <option value="">-- Tu dong chon stage dau --</option>
                                <c:if test="${not empty stages}">
                                    <c:forEach var="s" items="${stages}">
                                        <c:set var="sSel" value=""/>
                                        <c:if test="${(not empty opportunity && opportunity.stageId == s.stageId) || preSelectedStageId == s.stageId}"><c:set var="sSel" value="selected"/></c:if>
                                        <option value="${s.stageId}" ${sSel}>${s.stageName} (${s.probability}%)</option>
                                    </c:forEach>
                                </c:if>
                            </select>
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
                            <select name="status" class="form-select form-select-sm">
                                <c:set var="oppStatus" value="${empty opportunity ? 'Open' : opportunity.status}"/>
                                <option value="Open" ${oppStatus == 'Open' || empty oppStatus ? 'selected' : ''}>Open</option>
                                <option value="InProgress" ${oppStatus == 'InProgress' ? 'selected' : ''}>In Progress</option>
                                <option value="Won" ${oppStatus == 'Won' ? 'selected' : ''}>Won</option>
                                <option value="Lost" ${oppStatus == 'Lost' ? 'selected' : ''}>Lost</option>
                                <option value="OnHold" ${oppStatus == 'OnHold' ? 'selected' : ''}>On Hold</option>
                                <option value="Cancelled" ${oppStatus == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                            </select>
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
    var leadTableDiv = document.getElementById('leadTableDiv');
    var customerTableDiv = document.getElementById('customerTableDiv');
    var hiddenLeadId = document.getElementById('hiddenLeadId');
    var hiddenCustomerId = document.getElementById('hiddenCustomerId');
    var selectedPreview = document.getElementById('selectedPreview');

    function toggleContactType() {
        if (!typeFromLead || !typeFromCustomer) return;
        clearSelection();
        if (typeFromLead.checked) {
            if (leadTableDiv) leadTableDiv.style.display = '';
            if (customerTableDiv) customerTableDiv.style.display = 'none';
        } else {
            if (leadTableDiv) leadTableDiv.style.display = 'none';
            if (customerTableDiv) customerTableDiv.style.display = '';
        }
    }

    function selectLead(row) {
        var id = row.getAttribute('data-id');
        var name = row.getAttribute('data-name') || '';
        var email = row.getAttribute('data-email') || '';
        var phone = row.getAttribute('data-phone') || '';
        var company = row.getAttribute('data-company') || '';
        var code = row.getAttribute('data-code') || '';

        // Set hidden value
        hiddenLeadId.value = id;
        hiddenCustomerId.value = '';

        // Highlight row
        document.querySelectorAll('.lead-row').forEach(function(r) {
            r.classList.remove('selected-row');
            r.querySelector('td:first-child i').className = 'bi bi-circle text-muted';
            r.querySelector('td:first-child i').style.fontSize = '.6rem';
        });
        row.classList.add('selected-row');
        row.querySelector('td:first-child i').className = 'bi bi-check-circle-fill text-primary';
        row.querySelector('td:first-child i').style.fontSize = '.8rem';

        // Show preview
        showPreview(name, code, email, phone, company, 'bg-primary');
    }

    function selectCustomer(row) {
        var id = row.getAttribute('data-id');
        var name = row.getAttribute('data-name') || '';
        var email = row.getAttribute('data-email') || '';
        var phone = row.getAttribute('data-phone') || '';
        var code = row.getAttribute('data-code') || '';
        var segment = row.getAttribute('data-segment') || '';

        // Set hidden value
        hiddenCustomerId.value = id;
        hiddenLeadId.value = '';

        // Highlight row
        document.querySelectorAll('.customer-row').forEach(function(r) {
            r.classList.remove('selected-row');
            r.querySelector('td:first-child i').className = 'bi bi-circle text-muted';
            r.querySelector('td:first-child i').style.fontSize = '.6rem';
        });
        row.classList.add('selected-row');
        row.querySelector('td:first-child i').className = 'bi bi-check-circle-fill text-success';
        row.querySelector('td:first-child i').style.fontSize = '.8rem';

        // Show preview
        var meta = code;
        if (segment) meta += ' | ' + segment;
        showPreview(name, code, email, phone, '', 'bg-success');
    }

    function showPreview(name, code, email, phone, company, avatarClass) {
        if (!selectedPreview) return;
        var initial = name ? name.charAt(0).toUpperCase() : '?';
        document.getElementById('previewAvatar').className = 'avatar ' + avatarClass;
        document.getElementById('previewAvatar').textContent = initial;
        document.getElementById('previewName').textContent = name;

        var metaParts = [code];
        if (email) metaParts.push(email);
        if (phone) metaParts.push(phone);
        if (company) metaParts.push(company);
        document.getElementById('previewMeta').textContent = metaParts.join(' | ');

        selectedPreview.style.display = '';
    }

    function clearSelection() {
        if (hiddenLeadId) hiddenLeadId.value = '';
        if (hiddenCustomerId) hiddenCustomerId.value = '';
        if (selectedPreview) selectedPreview.style.display = 'none';

        document.querySelectorAll('.lead-row, .customer-row').forEach(function(r) {
            r.classList.remove('selected-row');
            r.querySelector('td:first-child i').className = 'bi bi-circle text-muted';
            r.querySelector('td:first-child i').style.fontSize = '.6rem';
        });
    }

    // ===== Search / Filter =====
    function setupSearch(inputId, rowClass, countTextId) {
        var input = document.getElementById(inputId);
        if (!input) return;
        input.addEventListener('input', function() {
            var query = this.value.trim().toLowerCase();
            var rows = document.querySelectorAll('.' + rowClass);
            var visible = 0;
            rows.forEach(function(row) {
                var name = (row.getAttribute('data-name') || '').toLowerCase();
                var email = (row.getAttribute('data-email') || '').toLowerCase();
                var phone = (row.getAttribute('data-phone') || '').toLowerCase();
                var company = (row.getAttribute('data-company') || '').toLowerCase();
                var code = (row.getAttribute('data-code') || '').toLowerCase();
                var segment = (row.getAttribute('data-segment') || '').toLowerCase();
                var match = !query
                    || name.indexOf(query) !== -1
                    || email.indexOf(query) !== -1
                    || phone.indexOf(query) !== -1
                    || company.indexOf(query) !== -1
                    || code.indexOf(query) !== -1
                    || segment.indexOf(query) !== -1;
                row.style.display = match ? '' : 'none';
                if (match) visible++;
            });
            var countEl = document.getElementById(countTextId);
            if (countEl) {
                countEl.textContent = query ? ('Hien thi ' + visible + ' / ' + rows.length + ' ket qua') : (rows.length + ' ban ghi');
            }
        });
        // Init count
        var rows = document.querySelectorAll('.' + rowClass);
        var countEl = document.getElementById(countTextId);
        if (countEl && rows.length > 0) {
            countEl.textContent = rows.length + ' ban ghi';
        }
    }

    setupSearch('leadSearchInput', 'lead-row', 'leadCountText');
    setupSearch('customerSearchInput', 'customer-row', 'customerCountText');

    // ===== Toggle listeners =====
    if (typeFromLead) typeFromLead.addEventListener('change', toggleContactType);
    if (typeFromCustomer) typeFromCustomer.addEventListener('change', toggleContactType);

    // ===== Init on load =====
    (function() {
        // If convertFromLead, pre-select the lead row
        var preLeadId = (hiddenLeadId ? hiddenLeadId.value : '') || '';
        var preCustId = (hiddenCustomerId ? hiddenCustomerId.value : '') || '';

        if (preLeadId) {
            var row = document.querySelector('.lead-row[data-id="' + preLeadId + '"]');
            if (row) selectLead(row);
        } else if (preCustId) {
            if (typeFromCustomer) typeFromCustomer.checked = true;
            toggleContactType();
            var row = document.querySelector('.customer-row[data-id="' + preCustId + '"]');
            if (row) selectCustomer(row);
        } else {
            toggleContactType();
        }
    })();

    // ===== Form submit =====
    document.getElementById('oppForm').addEventListener('submit', function(e) {
        // Validate contact selection in create mode
        var mode = '${mode}';
        if (mode !== 'edit') {
            var leadId = hiddenLeadId ? hiddenLeadId.value : '';
            var custId = hiddenCustomerId ? hiddenCustomerId.value : '';
            if (!leadId && !custId) {
                e.preventDefault();
                alert('Vui long chon mot Lead hoac Customer!');
                return;
            }
        }
        var btn = document.getElementById('submitBtn');
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>Dang luu...';
    });
</script>
