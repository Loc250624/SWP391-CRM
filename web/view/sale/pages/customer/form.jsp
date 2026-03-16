<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

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

            <!-- Khóa học đăng ký -->
            <c:if test="${mode != 'edit'}">
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-header bg-transparent border-0 d-flex justify-content-between align-items-center">
                        <h6 class="mb-0 fw-semibold"><i class="bi bi-mortarboard me-2"></i>Khóa học đăng ký</h6>
                        <button type="button" class="btn btn-sm btn-primary" onclick="openCoursePicker()">
                            <i class="bi bi-plus-lg me-1"></i>Chọn khóa học
                        </button>
                    </div>
                    <div class="card-body pt-0">
                        <div id="selectedCoursesContainer">
                            <div id="coursesEmpty" class="text-center text-muted py-3">
                                <i class="bi bi-inbox" style="font-size:1.5rem;"></i>
                                <p class="mb-0 mt-2 small">Chưa chọn khóa học nào</p>
                            </div>
                            <div class="table-responsive" id="coursesTableWrap" style="display:none;">
                                <table class="table table-sm align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Mã</th>
                                            <th>Tên khóa học</th>
                                            <th class="text-end">Giá</th>
                                            <th style="width:40px;"></th>
                                        </tr>
                                    </thead>
                                    <tbody id="selectedCoursesBody"></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

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
                    <input type="hidden" name="status" value="Active">
                    <div class="mb-3">
                        <label class="form-label small">Trạng thái</label>
                        <input type="text" class="form-control form-control-sm" value="Active" disabled>
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

<!-- Course Picker Modal -->
<c:if test="${mode != 'edit'}">
<div class="modal fade" id="coursePickerModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content border-0 shadow">
            <div class="modal-header py-2" style="border-bottom: 3px solid #0d6efd;">
                <div>
                    <h6 class="modal-title fw-bold mb-0"><i class="bi bi-mortarboard me-2"></i>Chọn khóa học</h6>
                    <small class="text-muted">Tick chọn các khóa học muốn đăng ký cho customer</small>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-0">
                <div class="p-3 border-bottom bg-light">
                    <div class="input-group input-group-sm">
                        <span class="input-group-text bg-white"><i class="bi bi-search text-muted"></i></span>
                        <input type="text" class="form-control" id="courseSearchInput" placeholder="Tìm kiếm khóa học..." oninput="filterCourses()">
                    </div>
                    <div class="d-flex justify-content-between align-items-center mt-2">
                        <small class="text-muted"><span id="courseSelectedCount">0</span> khóa học đã chọn</small>
                        <div class="d-flex gap-2">
                            <button type="button" class="btn btn-outline-secondary btn-sm py-0 px-2" style="font-size:.75rem;" onclick="toggleAllCourses(true)">Chọn tất cả</button>
                            <button type="button" class="btn btn-outline-secondary btn-sm py-0 px-2" style="font-size:.75rem;" onclick="toggleAllCourses(false)">Bỏ chọn</button>
                        </div>
                    </div>
                </div>
                <div class="table-responsive" style="max-height: 400px;">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light sticky-top">
                            <tr>
                                <th style="width:40px;" class="text-center"><input type="checkbox" class="form-check-input" id="courseCheckAll" onchange="toggleAllCourses(this.checked)"></th>
                                <th>Mã</th>
                                <th>Tên khóa học</th>
                                <th class="text-end">Giá</th>
                            </tr>
                        </thead>
                        <tbody id="coursePickerBody">
                            <c:forEach var="course" items="${courses}">
                                <tr class="course-picker-row" data-name="${course.courseName}" data-code="${course.courseCode}">
                                    <td class="text-center">
                                        <input type="checkbox" class="form-check-input course-check"
                                               value="${course.courseId}"
                                               data-name="${course.courseName}"
                                               data-code="${course.courseCode}"
                                               data-price="${course.price}"
                                               onchange="updateSelectedCount()">
                                    </td>
                                    <td><small class="text-muted">${course.courseCode}</small></td>
                                    <td class="fw-medium">${course.courseName}</td>
                                    <td class="text-end fw-semibold text-success">
                                        <fmt:formatNumber value="${course.price}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div id="coursePickerEmpty" class="text-center text-muted py-4" style="display:none;">
                    <i class="bi bi-search"></i> Không tìm thấy khóa học nào
                </div>
            </div>
            <div class="modal-footer py-2">
                <button type="button" class="btn btn-light btn-sm" data-bs-dismiss="modal">Hủy</button>
                <button type="button" class="btn btn-primary btn-sm" onclick="confirmCourseSelection()">
                    <i class="bi bi-check-lg me-1"></i>Thêm <span id="confirmCount">0</span> khóa học
                </button>
            </div>
        </div>
    </div>
</div>
</c:if>

<script>
    document.getElementById('customerForm').addEventListener('submit', function () {
        var btn = document.getElementById('submitBtn');
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>Đang lưu...';
    });

    // ==================== Course Picker ====================
    var courseModal = null;
    function getCourseModal() {
        var el = document.getElementById('coursePickerModal');
        if (!el) return null;
        if (!courseModal) courseModal = new bootstrap.Modal(el);
        return courseModal;
    }

    function openCoursePicker() {
        // Reset checkboxes - pre-check already selected
        var existingIds = [];
        document.querySelectorAll('#selectedCoursesBody input[name="courseIds"]').forEach(function(inp) {
            existingIds.push(inp.value);
        });
        document.querySelectorAll('.course-check').forEach(function(cb) {
            cb.checked = existingIds.indexOf(cb.value) >= 0;
        });
        var checkAll = document.getElementById('courseCheckAll');
        if (checkAll) checkAll.checked = false;
        var searchInput = document.getElementById('courseSearchInput');
        if (searchInput) searchInput.value = '';
        filterCourses();
        updateSelectedCount();
        getCourseModal().show();
    }

    function filterCourses() {
        var query = (document.getElementById('courseSearchInput').value || '').toLowerCase().trim();
        var rows = document.querySelectorAll('.course-picker-row');
        var visible = 0;
        rows.forEach(function(row) {
            var name = (row.getAttribute('data-name') || '').toLowerCase();
            var code = (row.getAttribute('data-code') || '').toLowerCase();
            var match = !query || name.indexOf(query) >= 0 || code.indexOf(query) >= 0;
            row.style.display = match ? '' : 'none';
            if (match) visible++;
        });
        var empty = document.getElementById('coursePickerEmpty');
        if (empty) empty.style.display = visible === 0 ? '' : 'none';
    }

    function toggleAllCourses(checked) {
        document.querySelectorAll('.course-picker-row').forEach(function(row) {
            if (row.style.display !== 'none') {
                var cb = row.querySelector('.course-check');
                if (cb) cb.checked = checked;
            }
        });
        var checkAll = document.getElementById('courseCheckAll');
        if (checkAll) checkAll.checked = checked;
        updateSelectedCount();
    }

    function updateSelectedCount() {
        var count = document.querySelectorAll('.course-check:checked').length;
        var el1 = document.getElementById('courseSelectedCount');
        var el2 = document.getElementById('confirmCount');
        if (el1) el1.textContent = count;
        if (el2) el2.textContent = count;
    }

    function formatNumber(num) {
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    }

    function confirmCourseSelection() {
        var checked = document.querySelectorAll('.course-check:checked');
        var tbody = document.getElementById('selectedCoursesBody');
        if (!tbody) { getCourseModal().hide(); return; }

        // Clear current selection
        tbody.innerHTML = '';

        if (checked.length === 0) {
            document.getElementById('coursesEmpty').style.display = '';
            document.getElementById('coursesTableWrap').style.display = 'none';
            getCourseModal().hide();
            return;
        }

        checked.forEach(function(cb) {
            var code = cb.getAttribute('data-code') || '';
            var name = cb.getAttribute('data-name') || '';
            var price = cb.getAttribute('data-price') || '0';
            var tr = document.createElement('tr');
            tr.innerHTML =
                '<td><small class="text-muted">' + code + '</small>' +
                    '<input type="hidden" name="courseIds" value="' + cb.value + '">' +
                '</td>' +
                '<td class="fw-medium">' + name + '</td>' +
                '<td class="text-end fw-semibold text-success">' + formatNumber(Math.round(parseFloat(price))) + ' đ</td>' +
                '<td><button type="button" class="btn btn-sm btn-outline-danger py-0 px-1" onclick="removeCourse(this)"><i class="bi bi-x"></i></button></td>';
            tbody.appendChild(tr);
        });

        document.getElementById('coursesEmpty').style.display = 'none';
        document.getElementById('coursesTableWrap').style.display = '';
        getCourseModal().hide();
    }

    function removeCourse(btn) {
        var tr = btn.closest('tr');
        tr.remove();
        var tbody = document.getElementById('selectedCoursesBody');
        if (tbody && tbody.children.length === 0) {
            document.getElementById('coursesEmpty').style.display = '';
            document.getElementById('coursesTableWrap').style.display = 'none';
        }
    }
</script>
