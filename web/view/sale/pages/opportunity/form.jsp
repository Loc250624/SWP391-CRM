<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

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
                            <!-- Create mode: select lead or customer -->
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
                                <!-- Lead selector -->
                                <div class="col-12" id="leadSelectDiv">
                                    <label class="form-label small">Chon Lead <span class="text-danger">*</span></label>
                                    <select name="leadId" class="form-select form-select-sm" id="leadSelect">
                                        <option value="">-- Chon lead --</option>
                                        <c:forEach var="ld" items="${leads}">
                                            <c:if test="${!ld.isConverted}">
                                                <option value="${ld.leadId}">${ld.fullName} - ${not empty ld.companyName ? ld.companyName : 'N/A'} (${ld.leadCode})</option>
                                            </c:if>
                                        </c:forEach>
                                    </select>
                                </div>
                                <!-- Customer selector -->
                                <div class="col-12" id="customerSelectDiv" style="display:none;">
                                    <label class="form-label small">Chon Customer <span class="text-danger">*</span></label>
                                    <select name="customerId" class="form-select form-select-sm" id="customerSelect">
                                        <option value="">-- Chon customer --</option>
                                        <c:forEach var="cust" items="${customers}">
                                            <option value="${cust.customerId}">${cust.fullName}</option>
                                        </c:forEach>
                                    </select>
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
    // Load stages dynamically when pipeline changes
    function loadStages(pipelineId) {
        var stageSelect = document.getElementById('stageSelect');
        stageSelect.innerHTML = '<option value="">-- Dang tai... --</option>';

        if (!pipelineId) {
            stageSelect.innerHTML = '<option value="">-- Chon pipeline truoc --</option>';
            return;
        }

        // Redirect to reload form with selected pipeline stages
        var currentUrl = new URL(window.location.href);
        var form = document.getElementById('oppForm');
        // Simple: submit form to reload with pipeline context
        // For now, we just clear stage selection - stages will be loaded on next page load
        stageSelect.innerHTML = '<option value="">-- Luu de cap nhat stage --</option>';
    }

    document.getElementById('oppForm').addEventListener('submit', function () {
        var btn = document.getElementById('submitBtn');
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>Dang luu...';
    });

    // Toggle lead/customer selector (create mode only)
    var typeFromLead = document.getElementById('typeFromLead');
    var typeFromCustomer = document.getElementById('typeFromCustomer');
    var leadDiv = document.getElementById('leadSelectDiv');
    var customerDiv = document.getElementById('customerSelectDiv');
    var leadSel = document.getElementById('leadSelect');
    var customerSel = document.getElementById('customerSelect');

    function toggleContactType() {
        if (!typeFromLead || !typeFromCustomer)
            return;
        if (typeFromLead.checked) {
            if (leadDiv)
                leadDiv.style.display = '';
            if (customerDiv)
                customerDiv.style.display = 'none';
            if (customerSel)
                customerSel.value = '';
        } else {
            if (leadDiv)
                leadDiv.style.display = 'none';
            if (customerDiv)
                customerDiv.style.display = '';
            if (leadSel)
                leadSel.value = '';
        }
    }

    if (typeFromLead)
        typeFromLead.addEventListener('change', toggleContactType);
    if (typeFromCustomer)
        typeFromCustomer.addEventListener('change', toggleContactType);
    // Init on load
    toggleContactType();
</script>
