<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">Chi tiết Customer</h4>
        <p class="text-muted mb-0">${customer.customerCode} - ${customer.fullName}</p>
    </div>
    <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/sale/customer/form?id=${customer.customerId}" class="btn btn-outline-primary btn-sm"><i class="bi bi-pencil me-1"></i>Chỉnh sửa</a>
        <a href="${pageContext.request.contextPath}/sale/customer/list" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left me-1"></i>Quay lại</a>
    </div>
</div>

<div class="row g-4">
    <!-- Main Content -->
    <div class="col-lg-8">
        <!-- Thông tin cá nhân -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-person me-2"></i>Thông tin cá nhân</h6>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="text-muted small">Họ tên</label>
                        <div class="fw-medium">${customer.fullName}</div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Email</label>
                        <div class="fw-medium">
                            <c:choose>
                                <c:when test="${not empty customer.email}">
                                    <a href="mailto:${customer.email}" class="text-decoration-none"><i class="bi bi-envelope me-1"></i>${customer.email}</a>
                                </c:when>
                                <c:otherwise><span class="text-muted">--</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Số điện thoại</label>
                        <div class="fw-medium">
                            <c:choose>
                                <c:when test="${not empty customer.phone}">
                                    <a href="tel:${customer.phone}" class="text-decoration-none"><i class="bi bi-telephone me-1"></i>${customer.phone}</a>
                                </c:when>
                                <c:otherwise><span class="text-muted">--</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Ngày sinh</label>
                        <div class="fw-medium">
                            <c:choose>
                                <c:when test="${not empty customer.dateOfBirth}">${customer.dateOfBirth}</c:when>
                                <c:otherwise><span class="text-muted">--</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Giới tính</label>
                        <div class="fw-medium">
                            <c:choose>
                                <c:when test="${customer.gender == 'Male'}">Nam</c:when>
                                <c:when test="${customer.gender == 'Female'}">Nữ</c:when>
                                <c:when test="${customer.gender == 'Other'}">Khác</c:when>
                                <c:otherwise><span class="text-muted">--</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Thành phố</label>
                        <div class="fw-medium">
                            <c:choose>
                                <c:when test="${not empty customer.city}">${customer.city}</c:when>
                                <c:otherwise><span class="text-muted">--</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-12">
                        <label class="text-muted small">Địa chỉ</label>
                        <div class="fw-medium">
                            <c:choose>
                                <c:when test="${not empty customer.address}">${customer.address}</c:when>
                                <c:otherwise><span class="text-muted">--</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Khóa học & Chi tiêu -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-mortarboard me-2"></i>Khóa học & Chi tiêu</h6>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-4">
                        <div class="text-center p-3 bg-primary bg-opacity-10 rounded-3">
                            <div class="fs-3 fw-bold text-primary">${customer.totalCourses}</div>
                            <small class="text-muted">Tổng khóa học</small>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="text-center p-3 bg-success bg-opacity-10 rounded-3">
                            <div class="fs-3 fw-bold text-success">
                                <c:choose>
                                    <c:when test="${not empty customer.totalSpent and customer.totalSpent > 0}">
                                        <fmt:formatNumber value="${customer.totalSpent}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ
                                    </c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </div>
                            <small class="text-muted">Tổng chi tiêu</small>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="text-center p-3 bg-info bg-opacity-10 rounded-3">
                            <div class="fs-3 fw-bold text-info">
                                <c:choose>
                                    <c:when test="${not empty customer.healthScore}">${customer.healthScore}</c:when>
                                    <c:otherwise>--</c:otherwise>
                                </c:choose>
                            </div>
                            <small class="text-muted">Health Score</small>
                        </div>
                    </div>
                    <c:if test="${not empty customer.firstPurchaseDate}">
                        <div class="col-md-6">
                            <label class="text-muted small">Mua hàng lần đầu</label>
                            <div class="fw-medium">${customer.firstPurchaseDate}</div>
                        </div>
                    </c:if>
                    <c:if test="${not empty customer.lastPurchaseDate}">
                        <div class="col-md-6">
                            <label class="text-muted small">Mua hàng gần nhất</label>
                            <div class="fw-medium">${customer.lastPurchaseDate}</div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Danh sách khóa học đã đăng ký -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-book me-2"></i>Khóa học đã đăng ký</h6>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty enrollments}">
                        <div class="table-responsive">
                            <table class="table table-sm align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Khóa học</th>
                                        <th>Ngày đăng ký</th>
                                        <th class="text-end">Số tiền</th>
                                        <th>Thanh toán</th>
                                        <th>Học tập</th>
                                        <th>Tiến độ</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="en" items="${enrollments}">
                                        <tr>
                                            <td>
                                                <div class="fw-medium">${en.courseName}</div>
                                                <small class="text-muted">${en.enrollmentCode}</small>
                                            </td>
                                            <td><small>${en.enrolledDate}</small></td>
                                            <td class="text-end fw-semibold">
                                                <c:if test="${not empty en.finalAmount}">
                                                    <fmt:formatNumber value="${en.finalAmount}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${en.paymentStatus == 'Paid'}"><span class="badge bg-success-subtle text-success">Đã TT</span></c:when>
                                                    <c:when test="${en.paymentStatus == 'Pending'}"><span class="badge bg-warning-subtle text-warning">Chờ TT</span></c:when>
                                                    <c:when test="${en.paymentStatus == 'Failed'}"><span class="badge bg-danger-subtle text-danger">Thất bại</span></c:when>
                                                    <c:otherwise><span class="badge bg-secondary-subtle text-secondary">${en.paymentStatus}</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${en.learningStatus == 'Completed'}"><span class="badge bg-success-subtle text-success">Hoàn thành</span></c:when>
                                                    <c:when test="${en.learningStatus == 'In Progress'}"><span class="badge bg-primary-subtle text-primary">Đang học</span></c:when>
                                                    <c:when test="${en.learningStatus == 'Not Started'}"><span class="badge bg-secondary-subtle text-secondary">Chưa bắt đầu</span></c:when>
                                                    <c:otherwise><span class="badge bg-secondary-subtle text-secondary">${en.learningStatus}</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="progress flex-grow-1" style="height: 6px; min-width: 60px;">
                                                        <div class="progress-bar bg-primary" style="width: ${en.progressPercentage}%;"></div>
                                                    </div>
                                                    <small class="text-muted">${en.progressPercentage}%</small>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center text-muted py-3">
                            <i class="bi bi-inbox" style="font-size:1.5rem;"></i>
                            <p class="mb-0 mt-2 small">Chưa đăng ký khóa học nào</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Ghi chú -->
        <c:if test="${not empty customer.notes}">
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-journal-text me-2"></i>Ghi chú</h6>
                </div>
                <div class="card-body">
                    <p class="mb-0" style="white-space: pre-wrap;">${customer.notes}</p>
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
        <!-- Trạng thái & Phân loại -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold">Trạng thái & Phân loại</h6>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <label class="text-muted small">Trạng thái</label>
                    <div class="mt-1">
                        <c:choose>
                            <c:when test="${customer.status == 'Active'}"><span class="badge bg-success-subtle text-success">Active</span></c:when>
                            <c:when test="${customer.status == 'Inactive'}"><span class="badge bg-secondary-subtle text-secondary">Inactive</span></c:when>
                            <c:when test="${customer.status == 'Churned'}"><span class="badge bg-danger-subtle text-danger">Churned</span></c:when>
                            <c:when test="${customer.status == 'Blocked'}"><span class="badge bg-dark">Blocked</span></c:when>
                            <c:otherwise><span class="badge bg-secondary">${customer.status}</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="text-muted small">Phân khúc</label>
                    <div class="mt-1">
                        <c:choose>
                            <c:when test="${customer.customerSegment == 'VIP'}"><span class="badge bg-warning-subtle text-warning">VIP</span></c:when>
                            <c:when test="${customer.customerSegment == 'Champion'}"><span class="badge bg-success-subtle text-success">Champion</span></c:when>
                            <c:when test="${customer.customerSegment == 'New'}"><span class="badge bg-info-subtle text-info">New</span></c:when>
                            <c:when test="${customer.customerSegment == 'Returning'}"><span class="badge bg-primary-subtle text-primary">Returning</span></c:when>
                            <c:when test="${customer.customerSegment == 'Risk'}"><span class="badge bg-danger-subtle text-danger">Risk</span></c:when>
                            <c:otherwise><span class="text-muted">--</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="text-muted small">Nguồn</label>
                    <div class="mt-1">
                        <c:choose>
                            <c:when test="${not empty sourceName}"><span class="badge bg-info-subtle text-info border border-info-subtle">${sourceName}</span></c:when>
                            <c:otherwise><span class="text-muted">--</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="text-muted small">Satisfaction Score</label>
                    <div class="d-flex align-items-center gap-2 mt-1">
                        <c:choose>
                            <c:when test="${not empty customer.satisfactionScore}">
                                <div class="progress flex-grow-1" style="height: 8px;">
                                    <div class="progress-bar
                                        <c:choose>
                                            <c:when test="${customer.satisfactionScore >= 70}">bg-success</c:when>
                                            <c:when test="${customer.satisfactionScore >= 40}">bg-warning</c:when>
                                            <c:otherwise>bg-danger</c:otherwise>
                                        </c:choose>" style="width: ${customer.satisfactionScore}%;"></div>
                                </div>
                                <span class="fw-bold">${customer.satisfactionScore}</span>
                            </c:when>
                            <c:otherwise><span class="text-muted">--</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="text-muted small">Liên lạc</label>
                    <div class="mt-1">
                        <c:if test="${customer.emailOptOut}"><span class="badge bg-secondary-subtle text-secondary me-1">Email Opt-out</span></c:if>
                        <c:if test="${customer.smsOptOut}"><span class="badge bg-secondary-subtle text-secondary me-1">SMS Opt-out</span></c:if>
                        <c:if test="${!customer.emailOptOut and !customer.smsOptOut}"><span class="text-muted">Nhận tất cả</span></c:if>
                    </div>
                </div>
                <hr>
                <div class="mb-2">
                    <label class="text-muted small">Ngày tạo</label>
                    <div class="mt-1"><small>
                        <c:choose>
                            <c:when test="${not empty customer.createdAt}">${customer.createdAt.toString().substring(0, 19).replace('T', ' ')}</c:when>
                            <c:otherwise>--</c:otherwise>
                        </c:choose>
                    </small></div>
                </div>
                <div>
                    <label class="text-muted small">Cập nhật</label>
                    <div class="mt-1"><small>
                        <c:choose>
                            <c:when test="${not empty customer.updatedAt}">${customer.updatedAt.toString().substring(0, 19).replace('T', ' ')}</c:when>
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
                    <a href="${pageContext.request.contextPath}/sale/customer/form?id=${customer.customerId}" class="btn btn-outline-primary btn-sm text-start"><i class="bi bi-pencil me-2"></i>Chỉnh sửa</a>
                    <c:if test="${not empty customer.phone}">
                        <a href="tel:${customer.phone}" class="btn btn-outline-success btn-sm text-start"><i class="bi bi-telephone me-2"></i>Gọi điện</a>
                    </c:if>
                    <c:if test="${not empty customer.email}">
                        <a href="mailto:${customer.email}" class="btn btn-outline-info btn-sm text-start"><i class="bi bi-envelope me-2"></i>Gửi email</a>
                    </c:if>
                    <button onclick="deleteCustomer(${customer.customerId}, '${customer.fullName}')" class="btn btn-outline-danger btn-sm text-start"><i class="bi bi-trash me-2"></i>Xóa customer</button>
                </div>
            </div>
        </div>
    </div>
</div>

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
    data.append('relatedType', 'Customer');
    data.append('relatedId', '${customer.customerId}');
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
function deleteCustomer(customerId, customerName) {
    if (confirm('Bạn có chắc muốn xóa customer "' + customerName + '"?\nHành động này không thể hoàn tác.')) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/sale/customer/list';
        form.innerHTML = '<input type="hidden" name="action" value="delete"><input type="hidden" name="customerId" value="' + customerId + '">';
        document.body.appendChild(form);
        form.submit();
    }
}
</script>
