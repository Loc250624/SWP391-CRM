<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">Chi tiet Opportunity</h4>
        <p class="text-muted mb-0">${opportunity.opportunityCode} - ${opportunity.opportunityName}</p>
    </div>
    <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/sale/opportunity/form?id=${opportunity.opportunityId}" class="btn btn-outline-primary btn-sm"><i class="bi bi-pencil me-1"></i>Chinh sua</a>
        <a href="${pageContext.request.contextPath}/sale/opportunity/list" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left me-1"></i>Quay lai</a>
    </div>
</div>

<!-- Stage Progress Bar -->
<c:if test="${not empty allStages}">
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-body py-3">
            <div class="d-flex align-items-center gap-1">
                <c:forEach var="stage" items="${allStages}" varStatus="loop">
                    <c:set var="isActive" value="${stage.stageId == opportunity.stageId}" />
                    <c:set var="isPassed" value="${stage.stageOrder <= currentStage.stageOrder}" />
                    <div class="flex-fill text-center py-2 rounded-2 small fw-semibold
                        <c:choose>
                            <c:when test="${isActive}">bg-primary text-white</c:when>
                            <c:when test="${isPassed}">bg-success bg-opacity-25 text-success</c:when>
                            <c:otherwise>bg-light text-muted</c:otherwise>
                        </c:choose>">${stage.stageName}</div>
                    <c:if test="${!loop.last}">
                        <i class="bi bi-chevron-right text-muted small"></i>
                    </c:if>
                </c:forEach>
            </div>
        </div>
    </div>
</c:if>

<div class="row g-4">
    <!-- Main Content -->
    <div class="col-lg-8">
        <!-- Thong tin co hoi -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-briefcase me-2"></i>Thong tin co hoi</h6>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="text-muted small">Ten Opportunity</label>
                        <div class="fw-medium">${opportunity.opportunityName}</div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Ma</label>
                        <div class="fw-medium text-primary">${opportunity.opportunityCode}</div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Pipeline</label>
                        <div class="fw-medium">
                            <c:choose>
                                <c:when test="${not empty pipeline}">${pipeline.pipelineName}</c:when>
                                <c:otherwise><span class="text-muted">-</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Stage hien tai</label>
                        <div>
                            <c:choose>
                                <c:when test="${not empty currentStage}"><span class="badge bg-primary-subtle text-primary">${currentStage.stageName}</span></c:when>
                                <c:otherwise><span class="text-muted">-</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Nguon</label>
                        <div>
                            <c:choose>
                                <c:when test="${not empty sourceName}"><span class="badge bg-info-subtle text-info">${sourceName}</span></c:when>
                                <c:otherwise><span class="text-muted">-</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Chien dich</label>
                        <div>
                            <c:choose>
                                <c:when test="${not empty campaignName}">${campaignName}</c:when>
                                <c:otherwise><span class="text-muted">-</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Gia tri & Xac suat -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-graph-up me-2"></i>Gia tri & Du bao</h6>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-4">
                        <div class="text-center p-3 bg-success bg-opacity-10 rounded-3">
                            <div class="fs-4 fw-bold text-success">
                                <c:choose>
                                    <c:when test="${not empty opportunity.estimatedValue and opportunity.estimatedValue > 0}">
                                        <fmt:formatNumber value="${opportunity.estimatedValue}" type="number" groupingUsed="true" maxFractionDigits="0"/>d
                                    </c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </div>
                            <small class="text-muted">Gia tri uoc tinh</small>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="text-center p-3 bg-primary bg-opacity-10 rounded-3">
                            <div class="fs-4 fw-bold text-primary">${opportunity.probability}%</div>
                            <small class="text-muted">Xac suat</small>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="text-center p-3 bg-warning bg-opacity-10 rounded-3">
                            <div class="fs-4 fw-bold text-warning">
                                <c:choose>
                                    <c:when test="${not empty opportunity.estimatedValue and opportunity.estimatedValue > 0}">
                                        <fmt:formatNumber value="${opportunity.estimatedValue * opportunity.probability / 100}" type="number" groupingUsed="true" maxFractionDigits="0"/>d
                                    </c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </div>
                            <small class="text-muted">Gia tri du bao</small>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Ngay dong du kien</label>
                        <div class="fw-medium">
                            <c:choose>
                                <c:when test="${not empty opportunity.expectedCloseDate}">${opportunity.expectedCloseDate}</c:when>
                                <c:otherwise><span class="text-muted">-</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Ngay dong thuc te</label>
                        <div class="fw-medium">
                            <c:choose>
                                <c:when test="${not empty opportunity.actualCloseDate}">${opportunity.actualCloseDate}</c:when>
                                <c:otherwise><span class="text-muted">-</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Lien ket Lead / Customer -->
        <c:if test="${not empty lead or not empty customer}">
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-people me-2"></i>Lien ket</h6>
                </div>
                <div class="card-body">
                    <div class="row g-3">
                        <c:if test="${not empty lead}">
                            <div class="col-md-6">
                                <label class="text-muted small">Lead</label>
                                <div class="fw-medium">
                                    <a href="${pageContext.request.contextPath}/sale/lead/detail?id=${lead.leadId}" class="text-decoration-none">
                                        <i class="bi bi-person me-1"></i>${lead.fullName}
                                    </a>
                                    <div><small class="text-muted">${lead.leadCode}</small></div>
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${not empty customer}">
                            <div class="col-md-6">
                                <label class="text-muted small">Customer</label>
                                <div class="fw-medium">
                                    <a href="${pageContext.request.contextPath}/sale/customer/detail?id=${customer.customerId}" class="text-decoration-none">
                                        <i class="bi bi-building me-1"></i>${customer.fullName}
                                    </a>
                                    <div><small class="text-muted">${customer.customerCode}</small></div>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Ghi chu -->
        <c:if test="${not empty opportunity.notes}">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-journal-text me-2"></i>Ghi chu</h6>
                </div>
                <div class="card-body">
                    <p class="mb-0" style="white-space: pre-wrap;">${opportunity.notes}</p>
                </div>
            </div>
        </c:if>
    </div>

    <!-- Sidebar -->
    <div class="col-lg-4">
        <!-- Trang thai -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold">Trang thai</h6>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <label class="text-muted small">Trang thai</label>
                    <div class="mt-1">
                        <c:choose>
                            <c:when test="${opportunity.status == 'Open'}"><span class="badge bg-info-subtle text-info">Open</span></c:when>
                            <c:when test="${opportunity.status == 'InProgress'}"><span class="badge bg-primary-subtle text-primary">In Progress</span></c:when>
                            <c:when test="${opportunity.status == 'Won'}"><span class="badge bg-success">Won</span></c:when>
                            <c:when test="${opportunity.status == 'Lost'}"><span class="badge bg-danger">Lost</span></c:when>
                            <c:when test="${opportunity.status == 'OnHold'}"><span class="badge bg-warning-subtle text-warning">On Hold</span></c:when>
                            <c:when test="${opportunity.status == 'Cancelled'}"><span class="badge bg-secondary">Cancelled</span></c:when>
                            <c:otherwise><span class="badge bg-secondary">${opportunity.status}</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <c:if test="${not empty opportunity.wonLostReason}">
                    <div class="mb-3">
                        <label class="text-muted small">Ly do Won/Lost</label>
                        <div class="mt-1 fw-medium">${opportunity.wonLostReason}</div>
                    </div>
                </c:if>
                <hr>
                <div class="mb-2">
                    <label class="text-muted small">Ngay tao</label>
                    <div class="mt-1"><small>
                        <c:choose>
                            <c:when test="${not empty opportunity.createdAt}">${opportunity.createdAt.toString().substring(0, 19).replace('T', ' ')}</c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </small></div>
                </div>
                <div>
                    <label class="text-muted small">Cap nhat</label>
                    <div class="mt-1"><small>
                        <c:choose>
                            <c:when test="${not empty opportunity.updatedAt}">${opportunity.updatedAt.toString().substring(0, 19).replace('T', ' ')}</c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </small></div>
                </div>
            </div>
        </div>

        <!-- Hanh dong nhanh -->
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-lightning me-2"></i>Hanh dong nhanh</h6>
            </div>
            <div class="card-body">
                <div class="d-grid gap-2">
                    <a href="${pageContext.request.contextPath}/sale/opportunity/form?id=${opportunity.opportunityId}" class="btn btn-outline-primary btn-sm text-start"><i class="bi bi-pencil me-2"></i>Chinh sua</a>
                    <a href="${pageContext.request.contextPath}/sale/opportunity/kanban?pipeline=${opportunity.pipelineId}" class="btn btn-outline-info btn-sm text-start"><i class="bi bi-kanban me-2"></i>Xem tren Kanban</a>
                    <button onclick="deleteOpp(${opportunity.opportunityId}, '${opportunity.opportunityName}')" class="btn btn-outline-danger btn-sm text-start"><i class="bi bi-trash me-2"></i>Xoa opportunity</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function deleteOpp(oppId, oppName) {
    if (confirm('Ban co chac muon xoa opportunity "' + oppName + '"?\nHanh dong nay khong the hoan tac.')) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/sale/opportunity/list';
        form.innerHTML = '<input type="hidden" name="action" value="delete"><input type="hidden" name="opportunityId" value="' + oppId + '">';
        document.body.appendChild(form);
        form.submit();
    }
}
</script>
