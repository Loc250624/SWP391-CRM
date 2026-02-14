<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">
            <c:choose>
                <c:when test="${mode == 'edit'}">Chinh sua Customer</c:when>
                <c:otherwise>Them Customer moi</c:otherwise>
            </c:choose>
        </h4>
        <p class="text-muted mb-0">
            <c:choose>
                <c:when test="${mode == 'edit'}">${customer.customerCode} - ${customer.fullName}</c:when>
                <c:otherwise>Nhap thong tin khach hang</c:otherwise>
            </c:choose>
        </p>
    </div>
    <a href="${pageContext.request.contextPath}/sale/customer/list" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left me-1"></i>Quay lai</a>
</div>

<!-- Error Message -->
<c:if test="${not empty error}">
    <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<form method="POST" action="${pageContext.request.contextPath}/sale/customer/form" id="customerForm">
    <c:if test="${mode == 'edit'}">
        <input type="hidden" name="customerId" value="${customer.customerId}">
    </c:if>

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
                            <label class="form-label small">Ho ten <span class="text-danger">*</span></label>
                            <input type="text" name="fullName" class="form-control form-control-sm" required
                                   value="${customer.fullName}" placeholder="Nhap ho ten">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small">Email</label>
                            <input type="email" name="email" class="form-control form-control-sm"
                                   value="${customer.email}" placeholder="example@email.com">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small">So dien thoai</label>
                            <input type="text" name="phone" class="form-control form-control-sm"
                                   value="${customer.phone}" placeholder="0xxx xxx xxx">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small">Ngay sinh</label>
                            <input type="date" name="dateOfBirth" class="form-control form-control-sm"
                                   value="${customer.dateOfBirth}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small">Gioi tinh</label>
                            <select name="gender" class="form-select form-select-sm">
                                <option value="">-- Chon --</option>
                                <option value="Male" ${customer.gender == 'Male' ? 'selected' : ''}>Nam</option>
                                <option value="Female" ${customer.gender == 'Female' ? 'selected' : ''}>Nu</option>
                                <option value="Other" ${customer.gender == 'Other' ? 'selected' : ''}>Khac</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small">Thanh pho</label>
                            <input type="text" name="city" class="form-control form-control-sm"
                                   value="${customer.city}" placeholder="Thanh pho">
                        </div>
                        <div class="col-12">
                            <label class="form-label small">Dia chi</label>
                            <input type="text" name="address" class="form-control form-control-sm"
                                   value="${customer.address}" placeholder="Dia chi cu the">
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
                              placeholder="Ghi chu ve khach hang...">${customer.notes}</textarea>
                </div>
            </div>
        </div>

        <!-- Sidebar -->
        <div class="col-lg-4">
            <!-- Phan loai -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-tags me-2"></i>Phan loai</h6>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <label class="form-label small">Trang thai</label>
                        <select name="status" class="form-select form-select-sm">
                            <c:forEach var="s" items="${customerStatuses}">
                                <option value="${s}" ${customer.status == s.toString() ? 'selected' : ''}>${s}</option>
                            </c:forEach>
                            <c:if test="${empty customerStatuses}">
                                <option value="Active" ${customer.status == 'Active' || empty customer.status ? 'selected' : ''}>Active</option>
                                <option value="Inactive" ${customer.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                                <option value="Churned" ${customer.status == 'Churned' ? 'selected' : ''}>Churned</option>
                                <option value="Blocked" ${customer.status == 'Blocked' ? 'selected' : ''}>Blocked</option>
                            </c:if>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small">Phan khuc</label>
                        <select name="customerSegment" class="form-select form-select-sm">
                            <c:forEach var="seg" items="${customerSegments}">
                                <option value="${seg}" ${customer.customerSegment == seg.toString() ? 'selected' : ''}>${seg}</option>
                            </c:forEach>
                            <c:if test="${empty customerSegments}">
                                <option value="New" ${customer.customerSegment == 'New' || empty customer.customerSegment ? 'selected' : ''}>New</option>
                                <option value="Returning" ${customer.customerSegment == 'Returning' ? 'selected' : ''}>Returning</option>
                                <option value="VIP" ${customer.customerSegment == 'VIP' ? 'selected' : ''}>VIP</option>
                                <option value="Champion" ${customer.customerSegment == 'Champion' ? 'selected' : ''}>Champion</option>
                                <option value="Risk" ${customer.customerSegment == 'Risk' ? 'selected' : ''}>Risk</option>
                            </c:if>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Nguon -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-diagram-3 me-2"></i>Nguon khach hang</h6>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <label class="form-label small">Nguon</label>
                        <select name="sourceId" class="form-select form-select-sm">
                            <option value="">-- Chon nguon --</option>
                            <c:forEach var="src" items="${leadSources}">
                                <option value="${src.sourceId}" ${customer.sourceId == src.sourceId ? 'selected' : ''}>${src.sourceName}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Tuy chon lien lac -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-bell me-2"></i>Tuy chon lien lac</h6>
                </div>
                <div class="card-body">
                    <div class="form-check form-switch mb-2">
                        <input class="form-check-input" type="checkbox" name="emailOptOut" id="emailOptOut"
                               ${customer.emailOptOut ? 'checked' : ''}>
                        <label class="form-check-label small" for="emailOptOut">Tu choi nhan email</label>
                    </div>
                    <div class="form-check form-switch">
                        <input class="form-check-input" type="checkbox" name="smsOptOut" id="smsOptOut"
                               ${customer.smsOptOut ? 'checked' : ''}>
                        <label class="form-check-label small" for="smsOptOut">Tu choi nhan SMS</label>
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
                                <c:otherwise>Tao Customer</c:otherwise>
                            </c:choose>
                        </button>
                        <a href="${pageContext.request.contextPath}/sale/customer/list" class="btn btn-outline-secondary btn-sm">
                            <i class="bi bi-x-lg me-1"></i>Huy
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>

<script>
    document.getElementById('customerForm').addEventListener('submit', function () {
        var btn = document.getElementById('submitBtn');
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>Dang luu...';
    });
</script>
