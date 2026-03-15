<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">
            <c:choose>
                <c:when test="${mode == 'edit'}">Chỉnh sửa Customer</c:when>
                <c:otherwise>Thêm Customer mới</c:otherwise>
            </c:choose>
        </h4>
        <p class="text-muted mb-0">
            <c:choose>
                <c:when test="${mode == 'edit'}">${customer.customerCode} - ${customer.fullName}</c:when>
                <c:otherwise>Nhập thông tin khách hàng</c:otherwise>
            </c:choose>
        </p>
    </div>
    <a href="${pageContext.request.contextPath}/sale/customer/list" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left me-1"></i>Quay lại</a>
</div>

<!-- Toast Messages -->
<c:if test="${not empty error}">
    <script>document.addEventListener('DOMContentLoaded', function(){ CRM.showToast('${error}', 'error'); });</script>
</c:if>

<form method="POST" action="${pageContext.request.contextPath}/sale/customer/form" id="customerForm">
    <c:if test="${mode == 'edit'}">
        <input type="hidden" name="customerId" value="${customer.customerId}">
    </c:if>

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
                            <label class="form-label small">Họ tên <span class="text-danger">*</span></label>
                            <input type="text" name="fullName" class="form-control form-control-sm" required
                                   value="${customer.fullName}" placeholder="Nhập họ tên">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small">Email</label>
                            <input type="email" name="email" class="form-control form-control-sm"
                                   value="${customer.email}" placeholder="example@email.com">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small">Số điện thoại</label>
                            <input type="text" name="phone" class="form-control form-control-sm"
                                   value="${customer.phone}" placeholder="0xxx xxx xxx">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small">Ngày sinh</label>
                            <input type="date" name="dateOfBirth" class="form-control form-control-sm"
                                   value="${customer.dateOfBirth}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small">Giới tính</label>
                            <select name="gender" class="form-select form-select-sm">
                                <option value="">-- Chọn --</option>
                                <option value="Male" ${customer.gender == 'Male' ? 'selected' : ''}>Nam</option>
                                <option value="Female" ${customer.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                                <option value="Other" ${customer.gender == 'Other' ? 'selected' : ''}>Khác</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small">Thành phố</label>
                            <input type="text" name="city" class="form-control form-control-sm"
                                   value="${customer.city}" placeholder="Thành phố">
                        </div>
                        <div class="col-12">
                            <label class="form-label small">Địa chỉ</label>
                            <input type="text" name="address" class="form-control form-control-sm"
                                   value="${customer.address}" placeholder="Địa chỉ cụ thể">
                        </div>
                    </div>
                </div>
            </div>

            <!-- Ghi chú -->
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-journal-text me-2"></i>Ghi chú</h6>
                </div>
                <div class="card-body">
                    <textarea name="notes" class="form-control form-control-sm" rows="4"
                              placeholder="Ghi chú về khách hàng...">${customer.notes}</textarea>
                </div>
            </div>
        </div>

        <!-- Sidebar -->
        <div class="col-lg-4">
            <!-- Phân loại -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-tags me-2"></i>Phân loại</h6>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <label class="form-label small">Trạng thái</label>
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
                        <label class="form-label small">Phân khúc</label>
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

            <!-- Nguồn -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-diagram-3 me-2"></i>Nguồn khách hàng</h6>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <label class="form-label small">Nguồn</label>
                        <select name="sourceId" class="form-select form-select-sm">
                            <option value="">-- Chọn nguồn --</option>
                            <c:forEach var="src" items="${leadSources}">
                                <option value="${src.sourceId}" ${customer.sourceId == src.sourceId ? 'selected' : ''}>${src.sourceName}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Tùy chọn liên lạc -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-bell me-2"></i>Tùy chọn liên lạc</h6>
                </div>
                <div class="card-body">
                    <div class="form-check form-switch mb-2">
                        <input class="form-check-input" type="checkbox" name="emailOptOut" id="emailOptOut"
                               ${customer.emailOptOut ? 'checked' : ''}>
                        <label class="form-check-label small" for="emailOptOut">Từ chối nhận email</label>
                    </div>
                    <div class="form-check form-switch">
                        <input class="form-check-input" type="checkbox" name="smsOptOut" id="smsOptOut"
                               ${customer.smsOptOut ? 'checked' : ''}>
                        <label class="form-check-label small" for="smsOptOut">Từ chối nhận SMS</label>
                    </div>
                </div>
            </div>

            <!-- Tags -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-bookmark-star me-2"></i>Tags</h6>
                </div>
                <div class="card-body">
                    <c:if test="${not empty allTags}">
                        <div class="d-flex flex-wrap gap-2">
                            <c:forEach var="tag" items="${allTags}">
                                <c:set var="tagChecked" value=""/>
                                <c:if test="${not empty assignedTagIds}">
                                    <c:forEach var="aid" items="${assignedTagIds}">
                                        <c:if test="${aid == tag.tagId}"><c:set var="tagChecked" value="checked"/></c:if>
                                    </c:forEach>
                                </c:if>
                                <label class="tag-checkbox-label" style="cursor:pointer;">
                                    <input type="checkbox" name="tagIds" value="${tag.tagId}" class="d-none tag-cb" ${tagChecked}>
                                    <span class="badge rounded-pill px-3 py-2 tag-badge"
                                          style="background-color: ${tag.tagColor}20; color: ${tag.tagColor}; border: 1.5px solid ${tag.tagColor};">
                                        <i class="bi bi-bookmark-fill me-1"></i>${tag.tagName}
                                    </span>
                                </label>
                            </c:forEach>
                        </div>
                    </c:if>
                    <c:if test="${empty allTags}">
                        <p class="text-muted small mb-0">Chưa có tag nào.</p>
                    </c:if>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary btn-sm" id="submitBtn">
                            <i class="bi bi-check-lg me-1"></i>
                            <c:choose>
                                <c:when test="${mode == 'edit'}">Cập nhật</c:when>
                                <c:otherwise>Tạo Customer</c:otherwise>
                            </c:choose>
                        </button>
                        <a href="${pageContext.request.contextPath}/sale/customer/list" class="btn btn-outline-secondary btn-sm">
                            <i class="bi bi-x-lg me-1"></i>Hủy
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
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>Đang lưu...';
    });

    // Tag checkbox toggle styling
    document.querySelectorAll('.tag-cb').forEach(function (cb) {
        function updateStyle() {
            var badge = cb.nextElementSibling;
            var color = badge.style.color;
            if (cb.checked) {
                badge.style.backgroundColor = color;
                badge.style.color = '#fff';
            } else {
                badge.style.backgroundColor = color + '20';
                badge.style.color = color;
            }
        }
        cb.addEventListener('change', updateStyle);
        updateStyle();
    });
</script>
