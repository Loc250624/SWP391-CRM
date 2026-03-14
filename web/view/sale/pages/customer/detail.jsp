<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">Chi tiet Customer</h4>
        <p class="text-muted mb-0">${customer.customerCode} - ${customer.fullName}</p>
    </div>
    <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/sale/customer/form?id=${customer.customerId}" class="btn btn-outline-primary btn-sm"><i class="bi bi-pencil me-1"></i>Chinh sua</a>
        <a href="${pageContext.request.contextPath}/sale/customer/list" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left me-1"></i>Quay lai</a>
    </div>
</div>

<div class="row g-4">
    <!-- Main Content -->
    <div class="col-lg-8">
        <!-- Thong tin ca nhan -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-person me-2"></i>Thong tin ca nhan</h6>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="text-muted small">Ho ten</label>
                        <div class="fw-medium">${customer.fullName}</div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Email</label>
                        <div class="fw-medium">
                            <c:choose>
                                <c:when test="${not empty customer.email}">
                                    <a href="mailto:${customer.email}" class="text-decoration-none"><i class="bi bi-envelope me-1"></i>${customer.email}</a>
                                </c:when>
                                <c:otherwise><span class="text-muted">-</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">So dien thoai</label>
                        <div class="fw-medium">
                            <c:choose>
                                <c:when test="${not empty customer.phone}">
                                    <a href="tel:${customer.phone}" class="text-decoration-none"><i class="bi bi-telephone me-1"></i>${customer.phone}</a>
                                </c:when>
                                <c:otherwise><span class="text-muted">-</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Ngay sinh</label>
                        <div class="fw-medium">
                            <c:choose>
                                <c:when test="${not empty customer.dateOfBirth}">${customer.dateOfBirth}</c:when>
                                <c:otherwise><span class="text-muted">-</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Gioi tinh</label>
                        <div class="fw-medium">
                            <c:choose>
                                <c:when test="${customer.gender == 'Male'}">Nam</c:when>
                                <c:when test="${customer.gender == 'Female'}">Nu</c:when>
                                <c:when test="${customer.gender == 'Other'}">Khac</c:when>
                                <c:otherwise><span class="text-muted">-</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Thanh pho</label>
                        <div class="fw-medium">
                            <c:choose>
                                <c:when test="${not empty customer.city}">${customer.city}</c:when>
                                <c:otherwise><span class="text-muted">-</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-12">
                        <label class="text-muted small">Dia chi</label>
                        <div class="fw-medium">
                            <c:choose>
                                <c:when test="${not empty customer.address}">${customer.address}</c:when>
                                <c:otherwise><span class="text-muted">-</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Thong tin khoa hoc & chi tieu -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-mortarboard me-2"></i>Khoa hoc & Chi tieu</h6>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-4">
                        <div class="text-center p-3 bg-primary bg-opacity-10 rounded-3">
                            <div class="fs-3 fw-bold text-primary">${customer.totalCourses}</div>
                            <small class="text-muted">Tong khoa hoc</small>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="text-center p-3 bg-success bg-opacity-10 rounded-3">
                            <div class="fs-3 fw-bold text-success">
                                <c:choose>
                                    <c:when test="${not empty customer.totalSpent and customer.totalSpent > 0}">
                                        <fmt:formatNumber value="${customer.totalSpent}" type="number" groupingUsed="true" maxFractionDigits="0"/>d
                                    </c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </div>
                            <small class="text-muted">Tong chi tieu</small>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="text-center p-3 bg-info bg-opacity-10 rounded-3">
                            <div class="fs-3 fw-bold text-info">
                                <c:choose>
                                    <c:when test="${not empty customer.healthScore}">${customer.healthScore}</c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </div>
                            <small class="text-muted">Health Score</small>
                        </div>
                    </div>
                    <c:if test="${not empty customer.firstPurchaseDate}">
                        <div class="col-md-6">
                            <label class="text-muted small">Mua hang lan dau</label>
                            <div class="fw-medium">${customer.firstPurchaseDate}</div>
                        </div>
                    </c:if>
                    <c:if test="${not empty customer.lastPurchaseDate}">
                        <div class="col-md-6">
                            <label class="text-muted small">Mua hang gan nhat</label>
                            <div class="fw-medium">${customer.lastPurchaseDate}</div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Ghi chu -->
        <c:if test="${not empty customer.notes}">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-journal-text me-2"></i>Ghi chu</h6>
                </div>
                <div class="card-body">
                    <p class="mb-0" style="white-space: pre-wrap;">${customer.notes}</p>
                </div>
            </div>
        </c:if>
    </div>

    <!-- Sidebar -->
    <div class="col-lg-4">
        <!-- Trang thai & Phan loai -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold">Trang thai & Phan loai</h6>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <label class="text-muted small">Trang thai</label>
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
                    <label class="text-muted small">Phan khuc</label>
                    <div class="mt-1">
                        <c:choose>
                            <c:when test="${customer.customerSegment == 'VIP'}"><span class="badge bg-warning-subtle text-warning">VIP</span></c:when>
                            <c:when test="${customer.customerSegment == 'Champion'}"><span class="badge bg-success-subtle text-success">Champion</span></c:when>
                            <c:when test="${customer.customerSegment == 'New'}"><span class="badge bg-info-subtle text-info">New</span></c:when>
                            <c:when test="${customer.customerSegment == 'Returning'}"><span class="badge bg-primary-subtle text-primary">Returning</span></c:when>
                            <c:when test="${customer.customerSegment == 'Risk'}"><span class="badge bg-danger-subtle text-danger">Risk</span></c:when>
                            <c:otherwise><span class="text-muted">-</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="text-muted small">Nguon</label>
                    <div class="mt-1">
                        <c:choose>
                            <c:when test="${not empty sourceName}"><span class="badge bg-info-subtle text-info">${sourceName}</span></c:when>
                            <c:otherwise><span class="text-muted">-</span></c:otherwise>
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
                            <c:otherwise><span class="text-muted">-</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="text-muted small">Lien lac</label>
                    <div class="mt-1">
                        <c:if test="${customer.emailOptOut}"><span class="badge bg-secondary-subtle text-secondary me-1">Email Opt-out</span></c:if>
                        <c:if test="${customer.smsOptOut}"><span class="badge bg-secondary-subtle text-secondary me-1">SMS Opt-out</span></c:if>
                        <c:if test="${!customer.emailOptOut and !customer.smsOptOut}"><span class="text-muted">Nhan tat ca</span></c:if>
                    </div>
                </div>
                <hr>
                <div class="mb-2">
                    <label class="text-muted small">Ngay tao</label>
                    <div class="mt-1"><small>
                        <c:choose>
                            <c:when test="${not empty customer.createdAt}">${customer.createdAt.toString().substring(0, 19).replace('T', ' ')}</c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </small></div>
                </div>
                <div>
                    <label class="text-muted small">Cap nhat</label>
                    <div class="mt-1"><small>
                        <c:choose>
                            <c:when test="${not empty customer.updatedAt}">${customer.updatedAt.toString().substring(0, 19).replace('T', ' ')}</c:when>
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
                    <a href="${pageContext.request.contextPath}/sale/customer/form?id=${customer.customerId}" class="btn btn-outline-primary btn-sm text-start"><i class="bi bi-pencil me-2"></i>Chinh sua</a>
                    <c:if test="${not empty customer.phone}">
                        <a href="tel:${customer.phone}" class="btn btn-outline-success btn-sm text-start"><i class="bi bi-telephone me-2"></i>Goi dien</a>
                    </c:if>
                    <c:if test="${not empty customer.email}">
                        <a href="mailto:${customer.email}" class="btn btn-outline-info btn-sm text-start"><i class="bi bi-envelope me-2"></i>Gui email</a>
                    </c:if>
                    <button onclick="deleteCustomer(${customer.customerId}, '${customer.fullName}')" class="btn btn-outline-danger btn-sm text-start"><i class="bi bi-trash me-2"></i>Xoa customer</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function deleteCustomer(customerId, customerName) {
    if (confirm('Ban co chac muon xoa customer "' + customerName + '"?\nHanh dong nay khong the hoan tac.')) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/sale/customer/list';
        form.innerHTML = '<input type="hidden" name="action" value="delete"><input type="hidden" name="customerId" value="' + customerId + '">';
        document.body.appendChild(form);
        form.submit();
    }
}
</script>
