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
    <c:if test="${not empty opportunity.leadId}">
        <input type="hidden" name="leadId" value="${opportunity.leadId}">
    </c:if>

    <div class="row g-4">
        <!-- Main -->
        <div class="col-lg-8">
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
                                   value="${opportunity.opportunityName}" placeholder="VD: Goi khoa hoc Enterprise - Cong ty ABC">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small">Pipeline <span class="text-danger">*</span></label>
                            <select name="pipelineId" class="form-select form-select-sm" id="pipelineSelect" required onchange="loadStages(this.value)">
                                <option value="">-- Chon pipeline --</option>
                                <c:forEach var="p" items="${pipelines}">
                                    <option value="${p.pipelineId}" ${(opportunity.pipelineId == p.pipelineId || preSelectedPipelineId == p.pipelineId) ? 'selected' : ''}>${p.pipelineName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small">Stage</label>
                            <select name="stageId" class="form-select form-select-sm" id="stageSelect">
                                <option value="">-- Tu dong chon stage dau --</option>
                                <c:if test="${not empty stages}">
                                    <c:forEach var="s" items="${stages}">
                                        <option value="${s.stageId}" ${(opportunity.stageId == s.stageId || preSelectedStageId == s.stageId) ? 'selected' : ''}>${s.stageName} (${s.probability}%)</option>
                                    </c:forEach>
                                </c:if>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small">Gia tri uoc tinh (VND)</label>
                            <input type="number" name="estimatedValue" class="form-control form-control-sm" min="0" step="100000"
                                   value="${opportunity.estimatedValue}" placeholder="0">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small">Xac suat thanh cong (%)</label>
                            <input type="number" name="probability" class="form-control form-control-sm" min="0" max="100"
                                   value="${opportunity.probability}" placeholder="0">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small">Ngay dong du kien</label>
                            <input type="date" name="expectedCloseDate" class="form-control form-control-sm"
                                   value="${opportunity.expectedCloseDate}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small">Trang thai</label>
                            <select name="status" class="form-select form-select-sm">
                                <option value="Open" ${opportunity.status == 'Open' || empty opportunity.status ? 'selected' : ''}>Open</option>
                                <option value="InProgress" ${opportunity.status == 'InProgress' ? 'selected' : ''}>In Progress</option>
                                <option value="Won" ${opportunity.status == 'Won' ? 'selected' : ''}>Won</option>
                                <option value="Lost" ${opportunity.status == 'Lost' ? 'selected' : ''}>Lost</option>
                                <option value="OnHold" ${opportunity.status == 'OnHold' ? 'selected' : ''}>On Hold</option>
                                <option value="Cancelled" ${opportunity.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
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
                              placeholder="Ghi chu ve co hoi kinh doanh...">${opportunity.notes}</textarea>
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
                                <option value="${src.sourceId}" ${opportunity.sourceId == src.sourceId ? 'selected' : ''}>${src.sourceName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small">Chien dich</label>
                        <select name="campaignId" class="form-select form-select-sm">
                            <option value="">-- Chon chien dich --</option>
                            <c:forEach var="camp" items="${campaigns}">
                                <option value="${camp.campaignId}" ${opportunity.campaignId == camp.campaignId ? 'selected' : ''}>${camp.campaignName}</option>
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
</script>
