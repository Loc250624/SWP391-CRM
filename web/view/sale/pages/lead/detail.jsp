<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">Chi tiết Lead</h4>
        <p class="text-muted mb-0">${lead.leadCode} - ${lead.fullName}</p>
    </div>
    <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/sale/lead/form?id=${lead.leadId}" class="btn btn-outline-primary btn-sm"><i class="bi bi-pencil me-1"></i>Chỉnh sửa</a>
        <c:if test="${!lead.isConverted}">
            <button class="btn btn-success btn-sm" data-bs-toggle="modal" data-bs-target="#convertModal"><i class="bi bi-arrow-repeat me-1"></i>Chuyển đổi</button>
        </c:if>
        <a href="${pageContext.request.contextPath}/sale/lead/list" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left me-1"></i>Quay lại</a>
    </div>
</div>

<div class="row g-4">
    <!-- Main Content -->
    <div class="col-lg-8">
        <!-- Thông tin cơ bản -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-person me-2"></i>Thông tin cơ bản</h6>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="text-muted small">Họ tên</label>
                        <div class="fw-medium">${lead.fullName}</div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Email</label>
                        <div class="fw-medium">
                            <c:choose>
                                <c:when test="${not empty lead.email}">
                                    <a href="mailto:${lead.email}" class="text-decoration-none"><i class="bi bi-envelope me-1"></i>${lead.email}</a>
                                </c:when>
                                <c:otherwise><span class="text-muted">--</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Số điện thoại</label>
                        <div class="fw-medium">
                            <c:choose>
                                <c:when test="${not empty lead.phone}">
                                    <a href="tel:${lead.phone}" class="text-decoration-none"><i class="bi bi-telephone me-1"></i>${lead.phone}</a>
                                </c:when>
                                <c:otherwise><span class="text-muted">--</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Công ty</label>
                        <div class="fw-medium">
                            <c:choose>
                                <c:when test="${not empty lead.companyName}"><i class="bi bi-building me-1 text-muted"></i>${lead.companyName}</c:when>
                                <c:otherwise><span class="text-muted">--</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Chức danh</label>
                        <div class="fw-medium">
                            <c:choose>
                                <c:when test="${not empty lead.jobTitle}">${lead.jobTitle}</c:when>
                                <c:otherwise><span class="text-muted">--</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Nguồn</label>
                        <div>
                            <c:choose>
                                <c:when test="${not empty sourceName}"><span class="badge bg-info-subtle text-info border border-info-subtle">${sourceName}</span></c:when>
                                <c:otherwise><span class="text-muted">--</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sở thích -->
        <c:if test="${not empty lead.interests}">
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-star me-2"></i>Sở thích / Quan tâm</h6>
                </div>
                <div class="card-body">
                    <c:forEach var="interest" items="${lead.interests.split(',')}">
                        <span class="badge bg-primary-subtle text-primary me-1 mb-1">${interest.trim()}</span>
                    </c:forEach>
                </div>
            </div>
        </c:if>

        <!-- Ghi chú -->
        <c:if test="${not empty lead.notes}">
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-journal-text me-2"></i>Ghi chú</h6>
                </div>
                <div class="card-body">
                    <p class="mb-0" style="white-space: pre-wrap;">${lead.notes}</p>
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
                            <c:when test="${lead.status == 'New'}"><span class="badge bg-info-subtle text-info">New</span></c:when>
                            <c:when test="${lead.status == 'Assigned'}"><span class="badge bg-secondary-subtle text-secondary">Assigned</span></c:when>
                            <c:when test="${lead.status == 'Contacted'}"><span class="badge bg-primary-subtle text-primary">Contacted</span></c:when>
                            <c:when test="${lead.status == 'Working'}"><span class="badge bg-warning-subtle text-warning">Working</span></c:when>
                            <c:when test="${lead.status == 'Qualified'}"><span class="badge bg-success-subtle text-success">Qualified</span></c:when>
                            <c:when test="${lead.status == 'Converted'}"><span class="badge bg-success">Converted</span></c:when>
                            <c:when test="${lead.status == 'Lost'}"><span class="badge bg-danger-subtle text-danger">Lost</span></c:when>
                            <c:otherwise><span class="badge bg-secondary">${lead.status}</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="text-muted small">Rating</label>
                    <div class="mt-1">
                        <c:choose>
                            <c:when test="${lead.rating == 'Hot'}"><span class="badge bg-danger">Hot</span></c:when>
                            <c:when test="${lead.rating == 'Warm'}"><span class="badge bg-warning text-dark">Warm</span></c:when>
                            <c:when test="${lead.rating == 'Cold'}"><span class="badge bg-secondary">Cold</span></c:when>
                            <c:otherwise><span class="text-muted">--</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="text-muted small">Lead Score</label>
                    <div class="d-flex align-items-center gap-2 mt-1">
                        <div class="progress flex-grow-1" style="height: 8px;">
                            <div class="progress-bar
                                <c:choose>
                                    <c:when test="${lead.leadScore >= 70}">bg-success</c:when>
                                    <c:when test="${lead.leadScore >= 40}">bg-warning</c:when>
                                    <c:otherwise>bg-danger</c:otherwise>
                                </c:choose>" style="width: ${lead.leadScore}%;"></div>
                        </div>
                        <span class="fw-bold">${lead.leadScore}</span>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="text-muted small">Chuyển đổi</label>
                    <div class="mt-1">
                        <c:choose>
                            <c:when test="${lead.isConverted}"><span class="badge bg-success"><i class="bi bi-check-lg me-1"></i>Đã chuyển đổi</span></c:when>
                            <c:otherwise><span class="text-muted">Chưa chuyển đổi</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <c:if test="${not empty campaignName}">
                    <div class="mb-3">
                        <label class="text-muted small">Chiến dịch</label>
                        <div class="fw-medium mt-1">${campaignName}</div>
                    </div>
                </c:if>
                <hr>
                <div class="mb-2">
                    <label class="text-muted small">Ngày tạo</label>
                    <div class="mt-1"><small>
                        <c:choose>
                            <c:when test="${not empty lead.createdAt}">${lead.createdAt.toString().substring(0, 19).replace('T', ' ')}</c:when>
                            <c:otherwise>--</c:otherwise>
                        </c:choose>
                    </small></div>
                </div>
                <div>
                    <label class="text-muted small">Cập nhật</label>
                    <div class="mt-1"><small>
                        <c:choose>
                            <c:when test="${not empty lead.updatedAt}">${lead.updatedAt.toString().substring(0, 19).replace('T', ' ')}</c:when>
                            <c:otherwise>--</c:otherwise>
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
                    <a href="${pageContext.request.contextPath}/sale/lead/form?id=${lead.leadId}" class="btn btn-outline-primary btn-sm text-start"><i class="bi bi-pencil me-2"></i>Chỉnh sửa</a>
                    <c:if test="${not empty lead.phone}">
                        <a href="tel:${lead.phone}" class="btn btn-outline-success btn-sm text-start"><i class="bi bi-telephone me-2"></i>Gọi điện</a>
                    </c:if>
                    <c:if test="${not empty lead.email}">
                        <a href="mailto:${lead.email}" class="btn btn-outline-info btn-sm text-start"><i class="bi bi-envelope me-2"></i>Gửi email</a>
                    </c:if>
                    <button onclick="deleteLead(${lead.leadId}, '${lead.fullName}')" class="btn btn-outline-danger btn-sm text-start"><i class="bi bi-trash me-2"></i>Xóa lead</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal chuyển đổi -->
<c:if test="${!lead.isConverted}">
    <div class="modal fade" id="convertModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header border-0">
                    <h5 class="modal-title fw-bold"><i class="bi bi-arrow-repeat me-2"></i>Chuyển đổi Lead</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-info d-flex align-items-start">
                        <i class="bi bi-info-circle-fill me-2 mt-1"></i>
                        <div>
                            <strong>Chuyển đổi lead thành Customer</strong><br>
                            <small>Lead sẽ được đánh dấu là "Converted" và tự động tạo Customer mới.</small>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-outline-secondary btn-sm" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-success btn-sm"><i class="bi bi-check-lg me-1"></i>Xác nhận chuyển đổi</button>
                </div>
            </div>
        </div>
    </div>
</c:if>

<!-- Modal ghi nhận nhanh -->
<div class="modal fade" id="quickLogModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <div class="modal-header border-0">
                <h5 class="modal-title fw-bold" id="quickLogTitle"><i class="bi bi-lightning me-2"></i>Ghi nhận nhanh</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="qlActivityType">
                <div class="mb-3">
                    <label class="form-label">Tiêu đề <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="qlSubject" placeholder="VD: Gọi tư vấn khóa học...">
                </div>
                <div class="mb-3">
                    <label class="form-label">Trạng thái</label>
                    <select class="form-select" id="qlStatus">
                        <option value="Completed">Hoàn thành</option>
                        <option value="Pending">Đang chờ (lịch hẹn)</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Mô tả</label>
                    <textarea class="form-control" id="qlDescription" rows="3" placeholder="Nội dung chi tiết..."></textarea>
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
    var typeName = type === 'Call' ? 'cuộc gọi' : type === 'Note' ? 'ghi chú' : 'lịch hẹn';
    document.getElementById('quickLogTitle').innerHTML = '<i class="bi bi-lightning me-2"></i>Ghi nhận ' + typeName;
    new bootstrap.Modal(document.getElementById('quickLogModal')).show();
}
function submitQuickLog() {
    var subject = document.getElementById('qlSubject').value.trim();
    if (!subject) { alert('Vui lòng nhập tiêu đề'); return; }
    var data = new URLSearchParams();
    data.append('activityType', document.getElementById('qlActivityType').value);
    data.append('relatedType', 'Lead');
    data.append('relatedId', '${lead.leadId}');
    data.append('subject', subject);
    data.append('description', document.getElementById('qlDescription').value);
    data.append('status', document.getElementById('qlStatus').value);
    fetch('${pageContext.request.contextPath}/sale/activity/quicklog', { method: 'POST', body: data })
        .then(function(r) { return r.json(); })
        .then(function(d) {
            if (d.success) {
                bootstrap.Modal.getInstance(document.getElementById('quickLogModal')).hide();
                if (typeof CRM !== 'undefined') CRM.showToast('Ghi nhận hoạt động thành công!', 'success');
                location.reload();
            } else { alert(d.message); }
        })
        .catch(function() { alert('Lỗi khi lưu hoạt động'); });
}
function deleteLead(leadId, leadName) {
    if (confirm('Bạn có chắc muốn xóa lead "' + leadName + '"?\nHành động này không thể hoàn tác.')) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/sale/lead/list';
        form.innerHTML = '<input type="hidden" name="action" value="delete"><input type="hidden" name="leadId" value="' + leadId + '">';
        document.body.appendChild(form);
        form.submit();
    }
}
</script>
