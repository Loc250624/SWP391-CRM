<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!-- Select2 CSS -->
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet"/>
<link href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" rel="stylesheet"/>

<div class="container-fluid">

    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/manager/task/list">Công việc</a>
            </li>
            <li class="breadcrumb-item active">
                ${formAction == 'edit' ? 'Chỉnh sửa' : 'Tạo mới'}
            </li>
        </ol>
    </nav>

    <!-- Messages -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show">
            <i class="bi bi-check-circle me-2"></i>${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show">
            <i class="bi bi-exclamation-triangle me-2"></i>${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="mb-0">
            <i class="bi bi-${formAction == 'edit' ? 'pencil-square' : 'plus-circle'} me-2"></i>
            ${formAction == 'edit' ? 'Chỉnh sửa Công việc' : 'Tạo Công việc mới'}
        </h3>
    </div>

    <div class="row">
        <!-- Main Form -->
        <div class="col-lg-8">
            <div class="card shadow-sm">
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/manager/task/form" method="post" id="taskForm">
                        <input type="hidden" name="formAction" value="${formAction}">
                        <c:if test="${formAction == 'edit'}">
                            <input type="hidden" name="taskId" value="${task.taskId}">
                        </c:if>

                        <!-- Title -->
                        <div class="mb-3">
                            <label for="title" class="form-label fw-bold">
                                Tiêu đề <span class="text-danger">*</span>
                            </label>
                            <%-- Strip [R-*] prefix from display value --%>
                            <c:set var="displayTitle" value="${task.title}"/>
                            <c:if test="${fn:startsWith(displayTitle, '[R-')}">
                                <c:set var="displayTitle" value="${fn:substringAfter(displayTitle, '] ')}"/>
                            </c:if>
                            <input type="text" class="form-control" id="title" name="title"
                                   value="${fn:escapeXml(displayTitle)}"
                                   placeholder="Nhập tiêu đề công việc..." required maxlength="255">
                        </div>

                        <!-- Description -->
                        <div class="mb-3">
                            <label for="description" class="form-label fw-bold">Mô tả</label>
                            <%-- Use cleanDescription so [DEPS:...] prefix is hidden from user --%>
                            <textarea class="form-control" id="description" name="description"
                                      rows="4" placeholder="Nhập mô tả chi tiết...">${fn:escapeXml(not empty cleanDescription ? cleanDescription : '')}</textarea>
                        </div>

                        <!-- Assign + Priority row -->
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label for="assignedTo" class="form-label fw-bold">
                                    Người thực hiện <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="assignedTo" name="assignedTo" required>
                                    <option value="">-- Chọn người thực hiện --</option>
                                    <c:forEach var="user" items="${allUsers}">
                                        <option value="${user.userId}"
                                                ${task.assignedTo == user.userId ? 'selected' : ''}>
                                            ${user.firstName} ${user.lastName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="priority" class="form-label fw-bold">
                                    Ưu tiên <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="priority" name="priority" required>
                                    <c:forEach var="p" items="${priorityValues}">
                                        <option value="${p.name()}"
                                                ${task.priority == p.name() ? 'selected' : ''}
                                                ${empty task.priority && p.name() == 'MEDIUM' ? 'selected' : ''}>
                                            ${p.vietnamese}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <!-- Status + Due Date row -->
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label for="status" class="form-label fw-bold">
                                    Trạng thái <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="status" name="status" required>
                                    <c:forEach var="s" items="${taskStatusValues}">
                                        <option value="${s.name()}"
                                                ${task.status == s.name() ? 'selected' : ''}
                                                ${empty task.status && s.name() == 'PENDING' ? 'selected' : ''}>
                                            ${s.vietnamese}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="dueDate" class="form-label fw-bold">
                                    Hạn chót <span class="text-danger">*</span>
                                </label>
                                <input type="date" class="form-control" id="dueDate" name="dueDate"
                                       value="${fn:substring(task.dueDate, 0, 10)}"
                                       required>
                                <small class="text-muted">Nhắc nhở tự động 24 giờ trước hạn chót</small>
                            </div>
                        </div>

                        <!-- Related Object (combined single dropdown) -->
                        <div class="card bg-light border-0 mb-4">
                            <div class="card-body">
                                <h6 class="mb-3"><i class="bi bi-link-45deg me-1"></i>Liên kết đối tượng (tùy chọn)</h6>

                                <%-- Hidden field — JS keeps it in sync; servlet derives type from relatedId value --%>
                                <input type="hidden" name="relatedType" id="relatedType">

                                <%-- Build the initial composite value for pre-selection in edit mode --%>
                                <c:set var="initRelatedValue" value=""/>
                                <c:if test="${task.relatedType == 'Lead'        && task.relatedId != null}"><c:set var="initRelatedValue" value="LEAD_${task.relatedId}"/></c:if>
                                <c:if test="${task.relatedType == 'Customer'    && task.relatedId != null}"><c:set var="initRelatedValue" value="CUSTOMER_${task.relatedId}"/></c:if>
                                <c:if test="${task.relatedType == 'Opportunity' && task.relatedId != null}"><c:set var="initRelatedValue" value="OPPORTUNITY_${task.relatedId}"/></c:if>

                                <div class="row g-3">
                                    <div class="col-12">
                                        <label for="relatedObject" class="form-label">Đối tượng liên kết</label>
                                        <%-- Value format: LEAD_123 | CUSTOMER_45 | OPPORTUNITY_67 | "" --%>
                                        <select class="form-select" id="relatedObject" name="relatedId">
                                            <option value="">-- Không liên kết --</option>
                                            <optgroup label="Lead">
                                                <c:forEach var="l" items="${leads}">
                                                    <option value="LEAD_${l.leadId}"
                                                            ${initRelatedValue == 'LEAD_'.concat(l.leadId) ? 'selected' : ''}>
                                                        ${fn:escapeXml(l.fullName)} (${l.leadCode})
                                                    </option>
                                                </c:forEach>
                                            </optgroup>
                                            <optgroup label="Khách hàng">
                                                <c:forEach var="c" items="${customers}">
                                                    <option value="CUSTOMER_${c.customerId}"
                                                            ${initRelatedValue == 'CUSTOMER_'.concat(c.customerId) ? 'selected' : ''}>
                                                        ${fn:escapeXml(c.fullName)} (${c.customerCode})
                                                    </option>
                                                </c:forEach>
                                            </optgroup>
                                            <optgroup label="Cơ hội">
                                                <c:forEach var="o" items="${opportunities}">
                                                    <option value="OPPORTUNITY_${o.opportunityId}"
                                                            ${initRelatedValue == 'OPPORTUNITY_'.concat(o.opportunityId) ? 'selected' : ''}>
                                                        ${fn:escapeXml(o.opportunityName)} (${o.opportunityCode})
                                                    </option>
                                                </c:forEach>
                                            </optgroup>
                                        </select>
                                    </div>
                                </div>

                                <%-- Customer Category auto-fill row (visible only when a Customer is selected) --%>
                                <div class="row g-3 mt-1" id="customerCategoryRow" style="display:none !important;">
                                    <div class="col-md-6">
                                        <label for="customerCategory" class="form-label">
                                            <i class="bi bi-tag me-1 text-primary"></i>Phân loại khách hàng
                                        </label>
                                        <div class="input-group">
                                            <input type="text" class="form-control" id="customerCategory"
                                                   readonly placeholder="Tự động điền khi chọn khách hàng"
                                                   style="background-color:#f8f9fa;">
                                            <span class="input-group-text" title="Giá trị được lấy tự động từ hệ thống">
                                                <i class="bi bi-lock-fill text-secondary"></i>
                                            </span>
                                        </div>
                                        <small class="text-muted">Phân loại được tự động lấy từ hồ sơ khách hàng.</small>
                                    </div>
                                    <div class="col-md-6" id="customerExtraInfo" style="display:none;">
                                        <label class="form-label text-muted small">Thông tin liên hệ</label>
                                        <div class="d-flex flex-column gap-1 small text-muted">
                                            <span id="customerPhone"><i class="bi bi-telephone me-1"></i><span class="val">—</span></span>
                                            <span id="customerEmail"><i class="bi bi-envelope me-1"></i><span class="val">—</span></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Recurring Task (create mode only) -->
                        <c:if test="${formAction != 'edit'}">
                            <div class="card border-primary border-opacity-25 mb-4">
                                <div class="card-header bg-primary bg-opacity-10">
                                    <div class="form-check form-switch mb-0">
                                        <input class="form-check-input" type="checkbox" id="enableRecurring" name="enableRecurring">
                                        <label class="form-check-label fw-bold" for="enableRecurring">
                                            <i class="bi bi-arrow-repeat me-1"></i>Bật lặp lại tự động
                                        </label>
                                    </div>
                                </div>
                                <div class="card-body" id="recurringPanel" style="display:none;">
                                    <div class="row g-3">
                                        <div class="col-md-4">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="recurrencePattern"
                                                       id="pat_daily" value="DAILY">
                                                <label class="form-check-label" for="pat_daily">
                                                    <i class="bi bi-calendar-day me-1 text-primary"></i>Hàng ngày
                                                </label>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="recurrencePattern"
                                                       id="pat_weekly" value="WEEKLY" checked>
                                                <label class="form-check-label" for="pat_weekly">
                                                    <i class="bi bi-calendar-week me-1 text-primary"></i>Hàng tuần
                                                </label>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="recurrencePattern"
                                                       id="pat_monthly" value="MONTHLY">
                                                <label class="form-check-label" for="pat_monthly">
                                                    <i class="bi bi-calendar-month me-1 text-primary"></i>Hàng tháng
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                    <small class="text-muted d-block mt-2">
                                        <i class="bi bi-info-circle me-1"></i>
                                        Công việc mới sẽ tự động được tạo khi công việc hiện tại hoàn thành.
                                    </small>
                                </div>
                            </div>
                        </c:if>

                        <!-- Recurring info for edit mode -->
                        <c:if test="${formAction == 'edit' && fn:contains(task.title, '[R-')}">
                            <div class="alert alert-info">
                                <i class="bi bi-arrow-repeat me-2"></i>
                                Công việc này có cài đặt lặp lại.
                                <a href="${pageContext.request.contextPath}/manager/task/recurring?id=${task.taskId}" class="alert-link">
                                    Chỉnh sửa cài đặt lặp lại
                                </a>
                            </div>
                        </c:if>

                        <!-- Task Dependencies (edit mode only) -->
                        <c:if test="${formAction == 'edit'}">
                            <div class="card border-warning border-opacity-50 mb-4">
                                <div class="card-header bg-warning bg-opacity-10">
                                    <h6 class="mb-0"><i class="bi bi-lock me-2"></i>Công việc phụ thuộc (tùy chọn)</h6>
                                </div>
                                <div class="card-body">
                                    <p class="text-muted small mb-2">
                                        Công việc này sẽ bị chặn cho đến khi tất cả công việc phụ thuộc hoàn thành.
                                    </p>
                                    <%-- Current dependencies --%>
                                    <c:if test="${not empty existingDepTasks}">
                                        <div class="mb-2">
                                            <small class="text-muted">Hiện tại phụ thuộc vào:</small>
                                            <div class="d-flex flex-wrap gap-1 mt-1">
                                                <c:forEach var="dep" items="${existingDepTasks}">
                                                    <span class="badge ${dep.status == 'COMPLETED' ? 'bg-success' : 'bg-secondary'}">
                                                        #${dep.taskId} ${dep.taskCode}
                                                        <c:if test="${dep.status != 'COMPLETED'}"> ⚠</c:if>
                                                    </span>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </c:if>
                                    <label for="dependencyIds" class="form-label small fw-bold">
                                        ID công việc phụ thuộc (cách nhau bởi dấu phẩy):
                                    </label>
                                    <%-- Build comma-separated string of existing dep IDs --%>
                                    <c:set var="depIdsStr" value=""/>
                                    <c:forEach var="depId" items="${existingDepIds}" varStatus="st">
                                        <c:set var="depIdsStr" value="${depIdsStr}${st.first ? '' : ','}${depId}"/>
                                    </c:forEach>
                                    <input type="text" class="form-control" id="dependencyIds" name="dependencyIds"
                                           value="${depIdsStr}"
                                           placeholder="Ví dụ: 5,12,23 — để trống nếu không phụ thuộc">
                                    <small class="text-muted">Nhập task_id của các công việc phải hoàn thành trước.</small>
                                </div>
                            </div>
                        </c:if>

                        <!-- Buttons -->
                        <div class="d-flex gap-2 pt-2">
                            <button type="submit" class="btn btn-success">
                                <i class="bi bi-check-circle me-2"></i>
                                ${formAction == 'edit' ? 'Lưu thay đổi' : 'Tạo công việc'}
                            </button>
                            <a href="${formAction == 'edit'
                                       ? pageContext.request.contextPath.concat('/manager/task/detail?id=').concat(task.taskId)
                                       : pageContext.request.contextPath.concat('/manager/task/list')}"
                               class="btn btn-outline-secondary">
                                <i class="bi bi-x-circle me-2"></i>Hủy
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Sidebar -->
        <div class="col-lg-4">
            <div class="card bg-light border-0 mb-3">
                <div class="card-body">
                    <h6 class="mb-2"><i class="bi bi-info-circle me-1 text-success"></i>Hướng dẫn</h6>
                    <ul class="list-unstyled small mb-0">
                        <li class="mb-1"><i class="bi bi-check2 text-success me-1"></i>Tiêu đề, người thực hiện, ưu tiên, hạn chót là bắt buộc</li>
                        <li class="mb-1"><i class="bi bi-check2 text-success me-1"></i>Nhắc nhở sẽ tự động đặt 24 giờ trước hạn chót</li>
                        <li class="mb-1"><i class="bi bi-check2 text-success me-1"></i>Có thể liên kết với Lead, Khách hàng hoặc Cơ hội</li>
                        <li><i class="bi bi-check2 text-success me-1"></i>Công việc lặp lại tự tạo phiên bản mới khi hoàn thành</li>
                    </ul>
                </div>
            </div>

            <!-- Edit-mode sidebar info -->
            <c:if test="${formAction == 'edit' && task.createdAt != null}">
                <div class="card shadow-sm">
                    <div class="card-header bg-white">
                        <h6 class="mb-0">Thông tin tạo</h6>
                    </div>
                    <div class="card-body small">
                        <div class="mb-2">
                            <span class="text-muted d-block">Tạo lúc</span>
                            <strong>${fn:substring(task.createdAt, 8, 10)}/${fn:substring(task.createdAt, 5, 7)}/${fn:substring(task.createdAt, 0, 4)}</strong>
                        </div>
                        <c:if test="${task.updatedAt != null}">
                            <div>
                                <span class="text-muted d-block">Cập nhật lúc</span>
                                <strong>${fn:substring(task.updatedAt, 8, 10)}/${fn:substring(task.updatedAt, 5, 7)}/${fn:substring(task.updatedAt, 0, 4)}</strong>
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</div>

<!-- Select2 JS -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

<script>
$(document).ready(function () {

    // ── Due-date minimum (create mode only) ──────────────────────────────
    var dueDateInput = document.getElementById('dueDate');
    if (dueDateInput && '${formAction}' !== 'edit') {
        var today = new Date();
        dueDateInput.min = today.getFullYear() + '-'
            + String(today.getMonth() + 1).padStart(2, '0') + '-'
            + String(today.getDate()).padStart(2, '0');
    }

    // ── Related-object elements ───────────────────────────────────────────
    var relTypeHidden = document.getElementById('relatedType');   // hidden input
    var categoryRow   = document.getElementById('customerCategoryRow');
    var categoryInput = document.getElementById('customerCategory');
    var extraInfoEl   = document.getElementById('customerExtraInfo');

    // Maps the value prefix to the Task relatedType string expected by the backend
    var TYPE_MAP = { 'LEAD': 'Lead', 'CUSTOMER': 'Customer', 'OPPORTUNITY': 'Opportunity' };

    // ── Select2: init on the combined dropdown ────────────────────────────
    $('#relatedObject').select2({
        theme: 'bootstrap-5',
        placeholder: '-- Không liên kết --',
        allowClear: true,
        width: '100%'
    });

    // ── Parse composite value (e.g. "CUSTOMER_45") → { type, id } ─────────
    function parseRelatedValue(val) {
        if (!val) return { type: '', id: '' };
        var idx = val.indexOf('_');
        if (idx <= 0 || idx === val.length - 1) return { type: '', id: '' };
        var prefix = val.substring(0, idx);
        var id     = val.substring(idx + 1);
        return { type: TYPE_MAP[prefix] || '', id: id };
    }

    // ── Show / hide customer category row ────────────────────────────────
    function toggleCategoryRow(type) {
        if (type === 'Customer') {
            categoryRow.style.removeProperty('display');
            categoryRow.style.display = 'flex';
        } else {
            categoryRow.style.setProperty('display', 'none', 'important');
            clearCategoryField();
        }
    }

    function clearCategoryField() {
        if (categoryInput) categoryInput.value = '';
        if (extraInfoEl)   extraInfoEl.style.display = 'none';
        document.querySelector('#customerPhone .val').textContent = '—';
        document.querySelector('#customerEmail .val').textContent = '—';
    }

    // ── AJAX: fetch customer info and auto-fill category ──────────────────
    function fetchCustomerCategory(customerId) {
        if (!customerId) { clearCategoryField(); return; }

        fetch('${pageContext.request.contextPath}/manager/task/customer-info?id=' + encodeURIComponent(customerId),
              { credentials: 'same-origin' })
            .then(function(resp) {
                if (!resp.ok) throw new Error('HTTP ' + resp.status);
                return resp.json();
            })
            .then(function(data) {
                if (data.error) { clearCategoryField(); return; }
                categoryInput.value = data.category || '(Chưa phân loại)';
                document.querySelector('#customerPhone .val').textContent = data.phone || '—';
                document.querySelector('#customerEmail .val').textContent = data.email || '—';
                extraInfoEl.style.display = 'block';
            })
            .catch(function() {
                clearCategoryField();
                categoryInput.placeholder = 'Không thể tải phân loại';
            });
    }

    // ── Central handler for combined dropdown change ──────────────────────
    function onRelatedChange(val) {
        var parsed = parseRelatedValue(val);
        // Keep the hidden relatedType in sync (servlet derives it from relatedId anyway)
        relTypeHidden.value = parsed.type;
        toggleCategoryRow(parsed.type);
        if (parsed.type === 'Customer' && parsed.id) {
            fetchCustomerCategory(parsed.id);
        }
    }

    // Wire up Select2 change event
    $('#relatedObject').on('change', function() {
        onRelatedChange(this.value);
    });

    // On page load: restore hidden field + category for edit mode
    onRelatedChange($('#relatedObject').val() || '');

    // ── Recurring toggle ──────────────────────────────────────────────────
    var enableCheck = document.getElementById('enableRecurring');
    var recurPanel  = document.getElementById('recurringPanel');
    if (enableCheck && recurPanel) {
        enableCheck.addEventListener('change', function() {
            recurPanel.style.display = this.checked ? 'block' : 'none';
        });
    }
});
</script>
