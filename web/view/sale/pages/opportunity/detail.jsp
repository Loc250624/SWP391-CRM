<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">Chi tiết Opportunity</h4>
        <p class="text-muted mb-0">${opportunity.opportunityCode} - ${opportunity.opportunityName}</p>
    </div>
    <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/sale/opportunity/form?id=${opportunity.opportunityId}" class="btn btn-outline-primary btn-sm"><i class="bi bi-pencil me-1"></i>Chỉnh sửa</a>
        <a href="${pageContext.request.contextPath}/sale/opportunity/list" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left me-1"></i>Quay lại</a>
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
        <!-- Thông tin cơ hội -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-briefcase me-2"></i>Thông tin cơ hội</h6>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="text-muted small">Tên Opportunity</label>
                        <div class="fw-medium">${opportunity.opportunityName}</div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Mã</label>
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
                        <label class="text-muted small">Stage hiện tại</label>
                        <div>
                            <c:choose>
                                <c:when test="${not empty currentStage}"><span class="badge bg-primary-subtle text-primary">${currentStage.stageName}</span></c:when>
                                <c:otherwise><span class="text-muted">-</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Nguồn</label>
                        <div>
                            <c:choose>
                                <c:when test="${not empty sourceName}"><span class="badge bg-info-subtle text-info">${sourceName}</span></c:when>
                                <c:otherwise><span class="text-muted">-</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Chiến dịch</label>
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

        <!-- Giá trị & Xác suất -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-graph-up me-2"></i>Giá trị & Dự báo</h6>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-4">
                        <div class="text-center p-3 bg-success bg-opacity-10 rounded-3">
                            <div class="fs-4 fw-bold text-success">
                                <c:choose>
                                    <c:when test="${not empty opportunity.estimatedValue and opportunity.estimatedValue > 0}">
                                        <fmt:formatNumber value="${opportunity.estimatedValue}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ
                                    </c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </div>
                            <small class="text-muted">Giá trị ước tính</small>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="text-center p-3 bg-primary bg-opacity-10 rounded-3">
                            <div class="fs-4 fw-bold text-primary">${opportunity.probability}%</div>
                            <small class="text-muted">Xác suất</small>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="text-center p-3 bg-warning bg-opacity-10 rounded-3">
                            <div class="fs-4 fw-bold text-warning">
                                <c:choose>
                                    <c:when test="${not empty opportunity.estimatedValue and opportunity.estimatedValue > 0}">
                                        <fmt:formatNumber value="${opportunity.estimatedValue * opportunity.probability / 100}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ
                                    </c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </div>
                            <small class="text-muted">Giá trị dự báo</small>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Ngày đóng dự kiến</label>
                        <div class="fw-medium">
                            <c:choose>
                                <c:when test="${not empty opportunity.expectedCloseDate}">${opportunity.expectedCloseDate}</c:when>
                                <c:otherwise><span class="text-muted">-</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Ngày đóng thực tế</label>
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

        <!-- Liên kết Lead / Customer -->
        <c:if test="${not empty lead or not empty customer}">
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-people me-2"></i>Liên kết</h6>
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

        <!-- Báo giá liên quan -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-transparent border-0 d-flex justify-content-between align-items-center">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-file-earmark-text me-2"></i>Báo giá liên quan</h6>
                <a href="${pageContext.request.contextPath}/sale/quotation/form?oppId=${opportunity.opportunityId}" class="btn btn-sm btn-outline-primary"><i class="bi bi-plus-lg me-1"></i>Tạo báo giá</a>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty quotations}">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Mã</th>
                                        <th>Tiêu đề</th>
                                        <th>Trạng thái</th>
                                        <th class="text-end">Giá trị</th>
                                        <th>Ngày tạo</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="q" items="${quotations}">
                                        <tr>
                                            <td><a href="${pageContext.request.contextPath}/sale/quotation/detail?id=${q.quotationId}" class="text-decoration-none fw-medium">${q.quotationCode}</a></td>
                                            <td>${q.title}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${q.status == 'Draft'}"><span class="badge bg-secondary-subtle text-secondary">Đề xuất</span></c:when>
                                                    <c:when test="${q.status == 'Approved'}"><span class="badge bg-success-subtle text-success">Đã duyệt</span></c:when>
                                                    <c:when test="${q.status == 'Sent'}"><span class="badge bg-warning-subtle text-warning">Báo giá</span></c:when>
                                                    <c:when test="${q.status == 'Accepted'}"><span class="badge bg-primary-subtle text-primary">Chấp nhận</span></c:when>
                                                    <c:when test="${q.status == 'Rejected'}"><span class="badge bg-danger-subtle text-danger">Từ chối</span></c:when>
                                                    <c:otherwise><span class="badge bg-secondary">${q.status}</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end fw-semibold">
                                                <c:if test="${not empty q.totalAmount && q.totalAmount > 0}">
                                                    <fmt:formatNumber value="${q.totalAmount}" type="number" groupingUsed="true" maxFractionDigits="0"/> d
                                                </c:if>
                                                <c:if test="${empty q.totalAmount || q.totalAmount == 0}">-</c:if>
                                            </td>
                                            <td><small class="text-muted">${q.createdAt != null ? q.createdAt.toLocalDate() : '-'}</small></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center text-muted py-3">
                            <i class="bi bi-inbox me-1"></i>Chưa có báo giá nào cho opportunity này
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Ghi chú -->
        <c:if test="${not empty opportunity.notes}">
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-journal-text me-2"></i>Ghi chú</h6>
                </div>
                <div class="card-body">
                    <p class="mb-0" style="white-space: pre-wrap;">${opportunity.notes}</p>
                </div>
            </div>
        </c:if>

        <!-- Lịch sử hoạt động -->
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-transparent border-0 d-flex justify-content-between align-items-center">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-clock-history me-2"></i>Lịch sử hoạt động</h6>
                <div class="d-flex gap-1">
                    <button class="btn btn-sm btn-outline-success" onclick="openQuickLog('Call')"><i class="bi bi-telephone me-1"></i>Gọi điện</button>
                    <button class="btn btn-sm btn-outline-warning" onclick="openQuickLog('Note')"><i class="bi bi-sticky me-1"></i>Ghi chú</button>
                    <button class="btn btn-sm btn-outline-primary" onclick="openQuickLog('Meeting')"><i class="bi bi-people me-1"></i>Lịch hẹn</button>
                </div>
            </div>
            <div class="card-body" id="activityTimeline">
                <c:choose>
                    <c:when test="${not empty activities}">
                        <c:forEach var="act" items="${activities}">
                            <div class="d-flex gap-3 mb-3 pb-3 border-bottom">
                                <div>
                                    <c:choose>
                                        <c:when test="${act.activityType == 'Call'}"><span class="badge bg-success-subtle text-success border border-success-subtle p-2"><i class="bi bi-telephone"></i></span></c:when>
                                        <c:when test="${act.activityType == 'Email'}"><span class="badge bg-info-subtle text-info border border-info-subtle p-2"><i class="bi bi-envelope"></i></span></c:when>
                                        <c:when test="${act.activityType == 'Meeting'}"><span class="badge bg-primary-subtle text-primary border border-primary-subtle p-2"><i class="bi bi-people"></i></span></c:when>
                                        <c:when test="${act.activityType == 'Note'}"><span class="badge bg-warning-subtle text-warning border border-warning-subtle p-2"><i class="bi bi-sticky"></i></span></c:when>
                                        <c:otherwise><span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle p-2"><i class="bi bi-activity"></i></span></c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="flex-grow-1">
                                    <div class="d-flex justify-content-between">
                                        <div class="fw-semibold">${act.subject}</div>
                                        <div>
                                            <c:choose>
                                                <c:when test="${act.status == 'Completed'}"><span class="badge bg-success-subtle text-success border border-success-subtle">Hoàn thành</span></c:when>
                                                <c:when test="${act.status == 'Pending'}"><span class="badge bg-warning-subtle text-warning border border-warning-subtle">Đang chờ</span></c:when>
                                                <c:otherwise><span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle">${act.status}</span></c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <c:if test="${not empty act.description}"><div class="text-muted small text-truncate" style="max-width:500px;">${act.description}</div></c:if>
                                    <small class="text-muted">
                                        <c:if test="${not empty act.performerName}">${act.performerName} &middot; </c:if>
                                        <c:if test="${not empty act.activityDate}">${act.activityDate.toString().substring(0, 16).replace('T', ' ')}</c:if>
                                    </small>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center text-muted py-3">Chưa có hoạt động nào</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Sidebar -->
    <div class="col-lg-4">
        <!-- Trạng thái -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold">Trạng thái</h6>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <label class="text-muted small">Trạng thái</label>
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
                        <label class="text-muted small">Lý do Won/Lost</label>
                        <div class="mt-1 fw-medium">${opportunity.wonLostReason}</div>
                    </div>
                </c:if>
                <hr>
                <div class="mb-2">
                    <label class="text-muted small">Ngày tạo</label>
                    <div class="mt-1"><small>
                        <c:choose>
                            <c:when test="${not empty opportunity.createdAt}">${opportunity.createdAt.toString().substring(0, 19).replace('T', ' ')}</c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </small></div>
                </div>
                <div>
                    <label class="text-muted small">Cập nhật</label>
                    <div class="mt-1"><small>
                        <c:choose>
                            <c:when test="${not empty opportunity.updatedAt}">${opportunity.updatedAt.toString().substring(0, 19).replace('T', ' ')}</c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </small></div>
                </div>
            </div>
        </div>

        <!-- Hành động nhanh -->
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-lightning me-2"></i>Hành động nhanh</h6>
            </div>
            <div class="card-body">
                <div class="d-grid gap-2">
                    <a href="${pageContext.request.contextPath}/sale/opportunity/form?id=${opportunity.opportunityId}" class="btn btn-outline-primary btn-sm text-start"><i class="bi bi-pencil me-2"></i>Chỉnh sửa</a>
                    <a href="${pageContext.request.contextPath}/sale/opportunity/kanban?pipeline=${opportunity.pipelineId}" class="btn btn-outline-info btn-sm text-start"><i class="bi bi-kanban me-2"></i>Xem trên Kanban</a>
                    <a href="${pageContext.request.contextPath}/sale/opportunity/history?oppId=${opportunity.opportunityId}" class="btn btn-outline-secondary btn-sm text-start"><i class="bi bi-clock-history me-2"></i>Lịch sử thay đổi</a>
                    <button onclick="deleteOpp(${opportunity.opportunityId}, '${opportunity.opportunityName}')" class="btn btn-outline-danger btn-sm text-start"><i class="bi bi-trash me-2"></i>Xóa opportunity</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Quick Log Modal -->
<div class="modal fade" id="quickLogModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <div class="modal-header border-0">
                <h5 class="modal-title fw-bold"><i class="bi bi-lightning me-2"></i>Ghi nhận nhanh</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="qlActivityType">
                <div class="mb-3">
                    <label class="form-label">Tiêu đề <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="qlSubject" placeholder="VD: Gọi tư vấn khóa học...">
                </div>
                <div class="mb-3">
                    <label class="form-label">Mô tả</label>
                    <textarea class="form-control" id="qlDescription" rows="3" placeholder="Nội dung chi tiết..."></textarea>
                </div>
                <div class="mb-3">
                    <label class="form-label">Trạng thái</label>
                    <select class="form-select" id="qlStatus">
                        <option value="Completed">Hoàn thành</option>
                        <option value="Pending">Đang chờ (lịch hẹn)</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer border-0">
                <button type="button" class="btn btn-outline-secondary btn-sm" data-bs-dismiss="modal">Hủy</button>
                <button type="button" class="btn btn-primary btn-sm" onclick="submitQuickLog()"><i class="bi bi-check-lg me-1"></i>Lưu</button>
            </div>
        </div>
    </div>
</div>

<script>
function openQuickLog(type) {
    document.getElementById('qlActivityType').value = type;
    document.getElementById('qlSubject').value = '';
    document.getElementById('qlDescription').value = '';
    document.getElementById('qlStatus').value = 'Completed';
    var typeName = type === 'Call' ? 'Cuộc gọi' : type === 'Note' ? 'Ghi chú' : 'Cuộc họp';
    document.querySelector('#quickLogModal .modal-title').innerHTML = '<i class="bi bi-lightning me-2"></i>Ghi nhận ' + typeName;
    new bootstrap.Modal(document.getElementById('quickLogModal')).show();
}
function submitQuickLog() {
    var subject = document.getElementById('qlSubject').value.trim();
    if (!subject) { alert('Vui lòng nhập tiêu đề'); return; }
    var data = new URLSearchParams();
    data.append('activityType', document.getElementById('qlActivityType').value);
    data.append('relatedType', 'Opportunity');
    data.append('relatedId', '${opportunity.opportunityId}');
    data.append('subject', subject);
    data.append('description', document.getElementById('qlDescription').value);
    data.append('status', document.getElementById('qlStatus').value);
    fetch('${pageContext.request.contextPath}/sale/activity/quicklog', { method: 'POST', body: data })
        .then(function(r) { return r.json(); })
        .then(function(d) {
            if (d.success) {
                bootstrap.Modal.getInstance(document.getElementById('quickLogModal')).hide();
                location.reload();
            } else { alert(d.message); }
        })
        .catch(function() { alert('Lỗi khi lưu hoạt động'); });
}
function deleteOpp(oppId, oppName) {
    if (confirm('Bạn có chắc muốn xóa opportunity "' + oppName + '"?\nHành động này không thể hoàn tác.')) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/sale/opportunity/list';
        form.innerHTML = '<input type="hidden" name="action" value="delete"><input type="hidden" name="opportunityId" value="' + oppId + '">';
        document.body.appendChild(form);
        form.submit();
    }
}
</script>
