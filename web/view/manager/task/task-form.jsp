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
            <li class="breadcrumb-item active">Tạo mới</li>
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

    <div class="d-flex justify-content-between align-items-center mb-2">
        <h3 class="mb-0">
            <i class="bi bi-plus-circle me-2"></i>Tạo Công việc mới
        </h3>
        <span class="badge bg-success fs-6">
            <i class="bi bi-play-circle me-1"></i>Trạng thái: Đang thực hiện (tự động)
        </span>
    </div>

    <%-- ══════ Task Type Tabs ══════ --%>
    <ul class="nav nav-tabs mb-4" role="tablist">
        <li class="nav-item">
            <a class="nav-link active" href="javascript:void(0)" id="tabLead" onclick="toggleTaskType('LEAD')">
                <i class="bi bi-person-lines-fill me-1"></i>Lead
                <span class="badge bg-primary ms-1" id="tabLeadBadge">Sales</span>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="javascript:void(0)" id="tabCustomer" onclick="toggleTaskType('CUSTOMER')">
                <i class="bi bi-people-fill me-1"></i>Customer
                <span class="badge bg-secondary ms-1" id="tabCustomerBadge">Support</span>
            </a>
        </li>
    </ul>

    <form action="${pageContext.request.contextPath}/manager/task/form"
          method="post" id="taskForm" novalidate>
        <input type="hidden" name="formAction" value="create">
        <input type="hidden" name="status" value="IN_PROGRESS">

    <div class="row">
        <!-- ═══════════════════ Main Form ═══════════════════ -->
        <div class="col-lg-8">
            <div class="card shadow-sm">
                <div class="card-body">

                        <%-- ── Title ─────────────────────────────────────────── --%>
                        <div class="mb-3">
                            <label for="title" class="form-label fw-bold">
                                Tiêu đề <span class="text-danger">*</span>
                            </label>
                            <c:set var="displayTitle" value="${task.title}"/>
                            <c:if test="${fn:startsWith(displayTitle, '[R-')}">
                                <c:set var="displayTitle" value="${fn:substringAfter(displayTitle, '] ')}"/>
                            </c:if>
                            <input type="text" class="form-control" id="title" name="title"
                                   value="${fn:escapeXml(displayTitle)}"
                                   placeholder="Nhập tiêu đề công việc..." required maxlength="255">
                            <div class="invalid-feedback">Vui lòng nhập tiêu đề</div>
                        </div>

                        <%-- ── Description ───────────────────────────────────── --%>
                        <div class="mb-3">
                            <label for="description" class="form-label fw-bold">Mô tả</label>
                            <textarea class="form-control" id="description" name="description"
                                      rows="3" placeholder="Nhập mô tả chi tiết...">${fn:escapeXml(not empty cleanDescription ? cleanDescription : '')}</textarea>
                        </div>

                        <%-- ── Priority + Due Date row ───────────────────────── --%>
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label for="priority" class="form-label fw-bold">
                                    Ưu tiên <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="priority" name="priority" required>
                                    <c:forEach var="p" items="${priorityValues}">
                                        <option value="${p.name()}"
                                                ${task.priorityName == p.name() ? 'selected' : ''}
                                                ${empty task.priorityName && p.name() == 'MEDIUM' ? 'selected' : ''}>
                                            ${p.vietnamese}
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


                        <%-- Hidden field for linked lead from lead-list page --%>
                        <c:if test="${not empty linkedLead}">
                            <input type="hidden" name="selectedLeads" value="${linkedLead.leadId}">
                        </c:if>

                        <%-- Hidden field for linked customer from customer-list page --%>
                        <c:if test="${not empty linkedCustomer}">
                            <input type="hidden" name="selectedCustomers" value="${linkedCustomer.customerId}">
                        </c:if>

                        <%-- ── Submit buttons ─────────────────────────────── --%>
                        <div class="d-flex gap-2 pt-2">
                            <button type="submit" class="btn btn-success">
                                <i class="bi bi-check-circle me-2"></i>Tạo công việc
                            </button>
                            <a href="${pageContext.request.contextPath}/manager/task/list"
                               class="btn btn-outline-secondary">
                                <i class="bi bi-x-circle me-2"></i>Hủy
                            </a>
                        </div>

                </div>
            </div>
        </div>

        <!-- ═══════════════════ Sidebar ═══════════════════ -->
        <div class="col-lg-4">

                <%-- ══════ 1. Phân công ══════ --%>
                <div class="card border-primary border-opacity-25 mb-3">
                    <div class="card-header bg-primary bg-opacity-10 py-2">
                        <h6 class="mb-0"><i class="bi bi-person-check me-2"></i>Phân công</h6>
                    </div>
                    <div class="card-body py-3 px-3">
                        <%-- Assign type radio --%>
                        <div class="mb-3">
                            <label class="form-label fw-semibold mb-1">Hình thức giao <span class="text-danger">*</span></label>
                            <div class="d-flex gap-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio"
                                           name="assignType" id="assignIndividual"
                                           value="INDIVIDUAL" checked
                                           onchange="toggleAssignType('INDIVIDUAL')">
                                    <label class="form-check-label" for="assignIndividual">
                                        <i class="bi bi-person me-1"></i>Cá nhân
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio"
                                           name="assignType" id="assignGroup"
                                           value="GROUP"
                                           onchange="toggleAssignType('GROUP')">
                                    <label class="form-check-label" for="assignGroup">
                                        <i class="bi bi-people me-1"></i>Nhóm
                                    </label>
                                </div>
                            </div>
                        </div>

                        <%-- Individual: popup picker --%>
                        <div id="sectionIndividual">
                            <label class="form-label fw-semibold mb-1">
                                <span id="assigneeRoleLabel">Nhân viên Sales</span> <span class="text-danger">*</span>
                            </label>
                            <div class="d-flex align-items-center gap-2">
                                <input type="hidden" name="assignedTo" id="assignedTo" value="">
                                <div class="border rounded p-2 flex-grow-1 bg-white" id="assigneeDisplay">
                                    <span class="text-muted small">-- Chưa chọn --</span>
                                </div>
                                <button type="button" class="btn btn-sm btn-outline-primary" onclick="openAssigneePickerModal('INDIVIDUAL')">
                                    <i class="bi bi-search me-1"></i>Chọn
                                </button>
                            </div>
                            <div class="text-danger small d-none mt-1" id="assigneeError">Vui lòng chọn người thực hiện</div>
                        </div>

                        <%-- Group: popup picker for multiple --%>
                        <div id="sectionGroup" class="d-none">
                            <label class="form-label fw-semibold mb-1">
                                Thành viên nhóm — chọn ít nhất 2 người <span class="text-danger">*</span>
                            </label>
                            <div class="d-flex align-items-start gap-2 mb-2">
                                <div class="border rounded p-2 flex-grow-1 bg-white" id="groupMembersDisplay" style="min-height:40px;">
                                    <span class="text-muted small">-- Chưa chọn --</span>
                                </div>
                                <button type="button" class="btn btn-sm btn-outline-primary" onclick="openAssigneePickerModal('GROUP')">
                                    <i class="bi bi-search me-1"></i>Chọn
                                </button>
                            </div>
                            <div class="text-danger small d-none" id="groupMainError">
                                Vui lòng chọn ít nhất 2 thành viên
                            </div>
                        </div>
                    </div>
                </div>

                <%-- ══════ 2. Linked Lead card (from lead page redirect) ══════ --%>
                <c:if test="${not empty linkedLead}">
                    <div class="card border-primary mb-3" id="linkedLeadCard">
                        <div class="card-header bg-primary bg-opacity-10 py-2 d-flex align-items-center gap-2">
                            <i class="bi bi-person-vcard-fill text-primary"></i>
                            <span class="fw-semibold text-primary">Lead liên kết</span>
                            <span class="badge bg-info text-dark ms-1">${linkedLead.leadCode}</span>
                            <button type="button" class="btn btn-sm btn-outline-danger border-0 ms-auto"
                                    onclick="removeLinkedObject('lead')" title="Bỏ liên kết">
                                <i class="bi bi-x-lg"></i>
                            </button>
                        </div>
                        <div class="card-body py-2 px-3">
                            <div class="d-flex flex-column gap-2">
                                <div>
                                    <small class="text-muted d-block">Họ tên</small>
                                    <strong>${fn:escapeXml(linkedLead.fullName)}</strong>
                                </div>
                                <div class="row g-2">
                                    <div class="col-6">
                                        <small class="text-muted d-block">SĐT</small>
                                        <span>${not empty linkedLead.phone ? linkedLead.phone : '—'}</span>
                                    </div>
                                    <div class="col-6">
                                        <small class="text-muted d-block">Email</small>
                                        <span class="small">${not empty linkedLead.email ? linkedLead.email : '—'}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>

                <%-- Linked Customer card (from customer page redirect) --%>
                <c:if test="${not empty linkedCustomer}">
                    <div class="card border-success mb-3" id="linkedCustomerCard">
                        <div class="card-header bg-success bg-opacity-10 py-2 d-flex align-items-center gap-2">
                            <i class="bi bi-people-fill text-success"></i>
                            <span class="fw-semibold text-success">Khách hàng liên kết</span>
                            <span class="badge bg-info text-dark ms-1">${linkedCustomer.customerCode}</span>
                            <button type="button" class="btn btn-sm btn-outline-danger border-0 ms-auto"
                                    onclick="removeLinkedObject('customer')" title="Bỏ liên kết">
                                <i class="bi bi-x-lg"></i>
                            </button>
                        </div>
                        <div class="card-body py-2 px-3">
                            <div class="d-flex flex-column gap-2">
                                <div>
                                    <small class="text-muted d-block">Họ tên</small>
                                    <strong>${fn:escapeXml(linkedCustomer.fullName)}</strong>
                                </div>
                                <div class="row g-2">
                                    <div class="col-6">
                                        <small class="text-muted d-block">SĐT</small>
                                        <span>${not empty linkedCustomer.phone ? linkedCustomer.phone : '—'}</span>
                                    </div>
                                    <div class="col-6">
                                        <small class="text-muted d-block">Email</small>
                                        <span class="small">${not empty linkedCustomer.email ? linkedCustomer.email : '—'}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>

                <%-- ══════ 3. Object picker (Lead/Customer) ══════ --%>
                <div class="card border-success mb-3" id="objectPickerSidebar"
                     style="${not empty linkedLead || not empty linkedCustomer ? 'display:none;' : ''}">
                    <div class="card-header bg-success bg-opacity-10 py-2 d-flex justify-content-between align-items-center">
                        <span class="fw-semibold text-success" id="objectPickerTitle">
                            <i class="bi bi-link-45deg me-1"></i>Chọn Lead
                        </span>
                        <button type="button" class="btn btn-sm btn-outline-success" onclick="openObjectPickerModal()">
                            <i class="bi bi-plus-circle me-1"></i>Chọn
                        </button>
                    </div>
                    <div class="card-body py-2 px-3">
                        <div id="selectedObjectsContainer">
                            <div class="text-muted small text-center py-2" id="noObjectSelected">
                                <i class="bi bi-inbox me-1"></i>Chưa chọn đối tượng nào
                            </div>
                        </div>
                    </div>
                </div>

                <%-- ══════ 4. Hướng dẫn ══════ --%>
                <div class="card border-0 bg-light mb-3">
                    <div class="card-body py-3 px-3">
                        <h6 class="mb-2"><i class="bi bi-info-circle me-1 text-info"></i>Hướng dẫn</h6>
                        <ul class="small text-muted mb-0 ps-3">
                            <li class="mb-1"><strong>Tab Lead:</strong> Tạo task giao cho nhân viên <span class="text-primary fw-semibold">Sales</span>. Chọn 1 hoặc nhiều Lead cần xử lý.</li>
                            <li class="mb-1"><strong>Tab Customer:</strong> Tạo task giao cho nhân viên <span class="text-success fw-semibold">Support</span>. Chọn 1 hoặc nhiều Customer cần chăm sóc.</li>
                            <li class="mb-1">Khi tạo task thành công, Lead sẽ tự động chuyển trạng thái sang <span class="badge bg-warning text-dark" style="font-size:0.7rem">Assigned</span>.</li>
                            <li class="mb-1">Task được tạo với trạng thái <span class="badge bg-success" style="font-size:0.7rem">Đang thực hiện</span> (không cần Sale xác nhận).</li>
                            <li>Nhấn nút <i class="bi bi-x-lg text-danger"></i> trên đối tượng đã chọn để bỏ liên kết.</li>
                        </ul>
                    </div>
                </div>

        </div>
    </div>
    </form>
</div>

<%-- ═══════════════════ Assignee Picker Modal ═══════════════════ --%>
<div class="modal fade" id="assigneePickerModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title"><i class="bi bi-person-check me-2"></i>Chọn nhân viên</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="input-group mb-3">
                    <span class="input-group-text"><i class="bi bi-search"></i></span>
                    <input type="text" class="form-control" id="assigneePickerSearch" placeholder="Tìm theo tên, mã, email...">
                </div>
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <small class="text-muted">Đã chọn: <strong id="assigneePickerCount">0</strong></small>
                    <span class="badge bg-info" id="assigneePickerMode">Cá nhân</span>
                </div>
                <div class="table-responsive" style="max-height:400px; overflow-y:auto;">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light sticky-top">
                            <tr><th style="width:40px"></th><th>Mã NV</th><th>Họ tên</th><th>Email</th><th>SĐT</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${allUsers}">
                                <tr class="assignee-picker-row" data-role="SALES"
                                    data-search="${fn:toLowerCase(u.employeeCode)} ${fn:toLowerCase(u.firstName)} ${fn:toLowerCase(u.lastName)} ${fn:toLowerCase(u.email)}">
                                    <td>
                                        <input type="checkbox" class="form-check-input assignee-picker-cb"
                                               value="${u.userId}"
                                               data-name="${fn:escapeXml(u.firstName)} ${fn:escapeXml(u.lastName)}"
                                               data-code="${fn:escapeXml(u.employeeCode)}"
                                               data-email="${fn:escapeXml(u.email)}">
                                    </td>
                                    <td><span class="badge bg-light text-dark border">${u.employeeCode}</span></td>
                                    <td class="fw-semibold">${u.firstName} ${u.lastName}</td>
                                    <td><small>${u.email}</small></td>
                                    <td><small>${u.phone}</small></td>
                                </tr>
                            </c:forEach>
                            <c:forEach var="u" items="${supportUsers}">
                                <tr class="assignee-picker-row" data-role="SUPPORT" style="display:none;"
                                    data-search="${fn:toLowerCase(u.employeeCode)} ${fn:toLowerCase(u.firstName)} ${fn:toLowerCase(u.lastName)} ${fn:toLowerCase(u.email)}">
                                    <td>
                                        <input type="checkbox" class="form-check-input assignee-picker-cb"
                                               value="${u.userId}"
                                               data-name="${fn:escapeXml(u.firstName)} ${fn:escapeXml(u.lastName)}"
                                               data-code="${fn:escapeXml(u.employeeCode)}"
                                               data-email="${fn:escapeXml(u.email)}">
                                    </td>
                                    <td><span class="badge bg-light text-dark border">${u.employeeCode}</span></td>
                                    <td class="fw-semibold">${u.firstName} ${u.lastName}</td>
                                    <td><small>${u.email}</small></td>
                                    <td><small>${u.phone}</small></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                <button type="button" class="btn btn-primary" onclick="confirmAssigneePicker()">
                    <i class="bi bi-check-circle me-1"></i>Xác nhận
                </button>
            </div>
        </div>
    </div>
</div>

<%-- ══════════════��════ Object Picker Modal (Lead + Customer tabs) ═══════════════════ --%>
<div class="modal fade" id="objectPickerModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title"><i class="bi bi-link-45deg me-2"></i>Chọn đối tượng liên kết</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <%-- Tabs: Lead / Customer --%>
                <ul class="nav nav-tabs mb-3" role="tablist">
                    <li class="nav-item">
                        <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tabPickerLead" type="button">
                            <i class="bi bi-person-lines-fill me-1"></i>Lead <span class="badge bg-secondary ms-1" id="pickerLeadCount">${fn:length(pickerLeads)}</span>
                        </button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tabPickerCustomer" type="button">
                            <i class="bi bi-people me-1"></i>Customer <span class="badge bg-secondary ms-1" id="pickerCustomerCount">${fn:length(pickerCustomers)}</span>
                        </button>
                    </li>
                </ul>

                <div class="input-group mb-3">
                    <span class="input-group-text"><i class="bi bi-search"></i></span>
                    <input type="text" class="form-control" id="objectPickerSearch" placeholder="Tìm theo tên, mã, SĐT, email...">
                </div>
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <small class="text-muted">Đã chọn: <strong id="objectPickerSelectedCount">0</strong></small>
                    <div class="d-flex gap-2">
                        <button type="button" class="btn btn-sm btn-outline-secondary" onclick="objectPickerSelectAll()">Chọn tất cả</button>
                        <button type="button" class="btn btn-sm btn-outline-secondary" onclick="objectPickerDeselectAll()">Bỏ chọn</button>
                    </div>
                </div>

                <div class="tab-content">
                    <%-- Lead Tab --%>
                    <div class="tab-pane fade show active" id="tabPickerLead">
                        <div class="table-responsive" style="max-height:350px; overflow-y:auto;">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light sticky-top">
                                    <tr><th style="width:40px"></th><th>Mã</th><th>Họ tên</th><th>SĐT</th><th>Email</th></tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="l" items="${pickerLeads}">
                                        <tr class="obj-picker-row" data-tab="lead"
                                            data-search="${fn:toLowerCase(l.leadCode)} ${fn:toLowerCase(l.fullName)} ${fn:toLowerCase(l.phone)} ${fn:toLowerCase(l.email)}">
                                            <td>
                                                <input type="checkbox" class="form-check-input obj-picker-cb"
                                                       value="${l.leadId}" data-type="LEAD"
                                                       data-code="${fn:escapeXml(l.leadCode)}"
                                                       data-name="${fn:escapeXml(l.fullName)}"
                                                       data-phone="${fn:escapeXml(l.phone)}"
                                                       data-email="${fn:escapeXml(l.email)}">
                                            </td>
                                            <td><span class="badge bg-light text-dark border">${l.leadCode}</span></td>
                                            <td class="fw-semibold">${fn:escapeXml(l.fullName)}</td>
                                            <td><small>${l.phone}</small></td>
                                            <td><small>${l.email}</small></td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty pickerLeads}">
                                        <tr><td colspan="5" class="text-center text-muted py-3">Không có Lead chưa giao</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <%-- Customer Tab --%>
                    <div class="tab-pane fade" id="tabPickerCustomer">
                        <div class="table-responsive" style="max-height:350px; overflow-y:auto;">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light sticky-top">
                                    <tr><th style="width:40px"></th><th>Mã</th><th>Họ tên</th><th>SĐT</th><th>Email</th></tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="c" items="${pickerCustomers}">
                                        <tr class="obj-picker-row" data-tab="customer"
                                            data-search="${fn:toLowerCase(c.customerCode)} ${fn:toLowerCase(c.fullName)} ${fn:toLowerCase(c.phone)} ${fn:toLowerCase(c.email)}">
                                            <td>
                                                <input type="checkbox" class="form-check-input obj-picker-cb"
                                                       value="${c.customerId}" data-type="CUSTOMER"
                                                       data-code="${fn:escapeXml(c.customerCode)}"
                                                       data-name="${fn:escapeXml(c.fullName)}"
                                                       data-phone="${fn:escapeXml(c.phone)}"
                                                       data-email="${fn:escapeXml(c.email)}">
                                            </td>
                                            <td><span class="badge bg-light text-dark border">${c.customerCode}</span></td>
                                            <td class="fw-semibold">${fn:escapeXml(c.fullName)}</td>
                                            <td><small>${c.phone}</small></td>
                                            <td><small>${c.email}</small></td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty pickerCustomers}">
                                        <tr><td colspan="5" class="text-center text-muted py-3">Không có Customer chưa giao</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                <button type="button" class="btn btn-success" onclick="confirmObjectPicker()">
                    <i class="bi bi-check-circle me-1"></i>Xác nhận
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Select2 JS -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

<script>
// ── Global state ────────────────────────────────────────────────────────
var _currentTaskType = '${not empty linkedCustomer ? "CUSTOMER" : "LEAD"}';

$(document).ready(function () {

    var CTX     = '${pageContext.request.contextPath}';

    // ── Due-date minimum ─────────────────────────────────────────────────
    var dueDateInput = document.getElementById('dueDate');
    if (dueDateInput) {
        var today = new Date();
        dueDateInput.min = today.getFullYear() + '-'
            + String(today.getMonth() + 1).padStart(2, '0') + '-'
            + String(today.getDate()).padStart(2, '0');
    }

    // ── Task type toggle (create mode only) ────────────────────────────
    window.toggleTaskType = function(type) {
        _currentTaskType = type;

        // Toggle tab active state
        var tabLead = document.getElementById('tabLead');
        var tabCustomer = document.getElementById('tabCustomer');
        var badgeLead = document.getElementById('tabLeadBadge');
        var badgeCustomer = document.getElementById('tabCustomerBadge');
        if (type === 'LEAD') {
            if (tabLead) tabLead.classList.add('active');
            if (tabCustomer) tabCustomer.classList.remove('active');
            if (badgeLead) { badgeLead.className = 'badge bg-primary ms-1'; }
            if (badgeCustomer) { badgeCustomer.className = 'badge bg-secondary ms-1'; }
        } else {
            if (tabLead) tabLead.classList.remove('active');
            if (tabCustomer) tabCustomer.classList.add('active');
            if (badgeLead) { badgeLead.className = 'badge bg-secondary ms-1'; }
            if (badgeCustomer) { badgeCustomer.className = 'badge bg-success ms-1'; }
        }

        // Update assignee role label
        var roleLabel = document.getElementById('assigneeRoleLabel');
        if (roleLabel) roleLabel.textContent = type === 'LEAD' ? 'Nhân viên Sales' : 'Nhân viên Support';

        // Clear current assignee selections
        var assignedTo = document.getElementById('assignedTo');
        if (assignedTo) assignedTo.value = '';
        var assigneeDisplay = document.getElementById('assigneeDisplay');
        if (assigneeDisplay) assigneeDisplay.innerHTML = '<span class="text-muted small">-- Chưa chọn --</span>';
        document.querySelectorAll('input[name="assignedToGroup"]').forEach(function(el) { el.remove(); });
        var groupDisp = document.getElementById('groupMembersDisplay');
        if (groupDisp) groupDisp.innerHTML = '<span class="text-muted small">-- Chưa chọn --</span>';

        // Clear current object selections
        var objContainer = document.getElementById('selectedObjectsContainer');
        if (objContainer) {
            objContainer.querySelectorAll('.selected-obj-item').forEach(function(el) { el.remove(); });
            var noObj = document.getElementById('noObjectSelected');
            if (noObj) noObj.style.display = '';
        }
        // Remove hidden selectedLeads/selectedCustomers
        document.querySelectorAll('input[name="selectedLeads"], input[name="selectedCustomers"]').forEach(function(el) { el.remove(); });
        // Also remove linked cards if switching type
        var linkedLead = document.getElementById('linkedLeadCard');
        var linkedCust = document.getElementById('linkedCustomerCard');
        if (type === 'CUSTOMER' && linkedLead) linkedLead.remove();
        if (type === 'LEAD' && linkedCust) linkedCust.remove();

        // Update object picker sidebar title
        var sidebarTitle = document.getElementById('objectPickerTitle');
        if (sidebarTitle) {
            sidebarTitle.innerHTML = type === 'LEAD'
                ? '<i class="bi bi-link-45deg me-1"></i>Chọn Lead'
                : '<i class="bi bi-link-45deg me-1"></i>Chọn Customer';
        }
        // Show object picker sidebar
        var picker = document.getElementById('objectPickerSidebar');
        if (picker) picker.style.display = '';
    };

    // ── Assign-type toggle (create mode only) ────────────────────────────
    window.toggleAssignType = function(type) {
        var indiv = document.getElementById('sectionIndividual');
        var group = document.getElementById('sectionGroup');

        if (type === 'GROUP') {
            if (indiv) indiv.classList.add('d-none');
            if (group) group.classList.remove('d-none');
            // Clear individual selection
            var assignedTo = document.getElementById('assignedTo');
            if (assignedTo) assignedTo.value = '';
            var display = document.getElementById('assigneeDisplay');
            if (display) display.innerHTML = '<span class="text-muted small">-- Chưa chọn --</span>';
        } else {
            if (indiv) indiv.classList.remove('d-none');
            if (group) group.classList.add('d-none');
            // Clear group selection
            document.querySelectorAll('input[name="assignedToGroup"]').forEach(function(el) { el.remove(); });
            var groupDisp = document.getElementById('groupMembersDisplay');
            if (groupDisp) groupDisp.innerHTML = '<span class="text-muted small">-- Chưa chọn --</span>';
            var mainErr = document.getElementById('groupMainError');
            if (mainErr) mainErr.classList.add('d-none');
        }
    };

    // ── Remove linked lead/customer (X button) ────────────────────────
    window.removeLinkedObject = function(type) {
        if (type === 'lead') {
            var card = document.getElementById('linkedLeadCard');
            if (card) card.remove();
            document.querySelectorAll('input[name="selectedLeads"]').forEach(function(el) { el.remove(); });
        } else {
            var card = document.getElementById('linkedCustomerCard');
            if (card) card.remove();
            document.querySelectorAll('input[name="selectedCustomers"]').forEach(function(el) { el.remove(); });
        }
        // Show object picker sidebar
        var picker = document.getElementById('objectPickerSidebar');
        if (picker) picker.style.display = '';
    };

    // ── Form submit validation ────────────────────────────────────────────
    document.getElementById('taskForm').addEventListener('submit', function(e) {
        var assignType = document.querySelector('[name="assignType"]:checked')
                         ? document.querySelector('[name="assignType"]:checked').value : 'INDIVIDUAL';

        if (assignType === 'GROUP') {
            var groupInputs = this.querySelectorAll('input[name="assignedToGroup"]');
            var mainErr = document.getElementById('groupMainError');
            if (groupInputs.length < 2) {
                e.preventDefault(); e.stopPropagation();
                if (mainErr) { mainErr.textContent = 'Vui lòng chọn ít nhất 2 thành viên'; mainErr.classList.remove('d-none'); }
                return;
            }
            if (mainErr) mainErr.classList.add('d-none');
        } else {
            var assignedTo = document.getElementById('assignedTo');
            var assigneeErr = document.getElementById('assigneeError');
            if (assignedTo && !assignedTo.value) {
                e.preventDefault(); e.stopPropagation();
                if (assigneeErr) assigneeErr.classList.remove('d-none');
                return;
            }
            if (assigneeErr) assigneeErr.classList.add('d-none');
        }

        if (!this.checkValidity()) { e.preventDefault(); e.stopPropagation(); }
        this.classList.add('was-validated');
    });

    // ── Search filters ──────────────────────────────────────────────────
    bindSearch('assigneePickerSearch', '.assignee-picker-row');
    bindSearch('objectPickerSearch', '.obj-picker-row');

    function bindSearch(inputId, rowSelector) {
        var inp = document.getElementById(inputId);
        if (!inp) return;
        inp.addEventListener('input', function() {
            var kw = this.value.toLowerCase().trim();
            document.querySelectorAll(rowSelector).forEach(function(row) {
                var data = row.getAttribute('data-search') || '';
                var matchesSearch = !kw || data.indexOf(kw) !== -1;

                // For assignee picker: respect role filter
                var role = row.getAttribute('data-role');
                if (role) {
                    var showRole = _currentTaskType === 'CUSTOMER' ? 'SUPPORT' : 'SALES';
                    row.style.display = (matchesSearch && role === showRole) ? '' : 'none';
                } else {
                    row.style.display = matchesSearch ? '' : 'none';
                }
            });
        });
    }

    // ── Checkbox count listeners ──────────────────────────────────────────
    document.querySelectorAll('.assignee-picker-cb').forEach(function(cb) {
        cb.addEventListener('change', updateAssigneePickerCount);
    });
    document.querySelectorAll('.obj-picker-cb').forEach(function(cb) {
        cb.addEventListener('change', updateObjectPickerCount);
    });

    // ── Init UI based on linked object type ──────────────────────────────
    if (_currentTaskType === 'CUSTOMER') {
        // Sync tab active state
        var tabLead = document.getElementById('tabLead');
        var tabCustomer = document.getElementById('tabCustomer');
        var badgeLead = document.getElementById('tabLeadBadge');
        var badgeCustomer = document.getElementById('tabCustomerBadge');
        if (tabLead) tabLead.classList.remove('active');
        if (tabCustomer) tabCustomer.classList.add('active');
        if (badgeLead) badgeLead.className = 'badge bg-secondary ms-1';
        if (badgeCustomer) badgeCustomer.className = 'badge bg-success ms-1';

        // Sync assignee role label
        var roleLabel = document.getElementById('assigneeRoleLabel');
        if (roleLabel) roleLabel.textContent = 'Nhân viên Support';

        // Sync object picker sidebar title
        var sidebarTitle = document.getElementById('objectPickerTitle');
        if (sidebarTitle) sidebarTitle.innerHTML = '<i class="bi bi-link-45deg me-1"></i>Chọn Customer';
    }
});

// ═══════════════════════════════════════════════════════════════════════════
// ASSIGNEE PICKER
// ═══════════════════════════════════════════════════════════════════════════
var _assigneePickerMode = 'INDIVIDUAL'; // or 'GROUP'

function openAssigneePickerModal(mode) {
    _assigneePickerMode = mode;
    var modeLabel = document.getElementById('assigneePickerMode');
    if (modeLabel) modeLabel.textContent = mode === 'GROUP' ? 'Nhóm' : 'Cá nhân';

    // Filter rows by task type: LEAD → SALES, CUSTOMER → SUPPORT
    var showRole = _currentTaskType === 'CUSTOMER' ? 'SUPPORT' : 'SALES';
    document.querySelectorAll('.assignee-picker-row').forEach(function(r) {
        var role = r.getAttribute('data-role');
        r.style.display = (role === showRole) ? '' : 'none';
        // Uncheck hidden rows
        if (role !== showRole) {
            var cb = r.querySelector('.assignee-picker-cb');
            if (cb) { cb.checked = false; cb.disabled = false; }
        }
    });

    // Pre-check current selection
    document.querySelectorAll('.assignee-picker-row[data-role="' + showRole + '"] .assignee-picker-cb').forEach(function(cb) { cb.checked = false; });

    if (mode === 'INDIVIDUAL') {
        var current = document.getElementById('assignedTo').value;
        if (current) {
            var cb = document.querySelector('.assignee-picker-row[data-role="' + showRole + '"] .assignee-picker-cb[value="' + current + '"]');
            if (cb) cb.checked = true;
        }
    } else {
        document.querySelectorAll('input[name="assignedToGroup"]').forEach(function(inp) {
            var cb = document.querySelector('.assignee-picker-row[data-role="' + showRole + '"] .assignee-picker-cb[value="' + inp.value + '"]');
            if (cb) cb.checked = true;
        });
    }

    updateAssigneePickerCount();
    var searchInp = document.getElementById('assigneePickerSearch');
    if (searchInp) { searchInp.value = ''; }

    new bootstrap.Modal(document.getElementById('assigneePickerModal')).show();
}

function updateAssigneePickerCount() {
    var showRole = _currentTaskType === 'CUSTOMER' ? 'SUPPORT' : 'SALES';
    var visibleChecked = document.querySelectorAll('.assignee-picker-row[data-role="' + showRole + '"] .assignee-picker-cb:checked');
    var count = visibleChecked.length;
    var el = document.getElementById('assigneePickerCount');
    if (el) el.textContent = count;

    // Individual mode: only allow 1 selection
    var visibleCbs = document.querySelectorAll('.assignee-picker-row[data-role="' + showRole + '"] .assignee-picker-cb');
    if (_assigneePickerMode === 'INDIVIDUAL' && count >= 1) {
        visibleCbs.forEach(function(cb) {
            if (!cb.checked) cb.disabled = true;
        });
    } else {
        visibleCbs.forEach(function(cb) { cb.disabled = false; });
    }
}

function confirmAssigneePicker() {
    var checked = document.querySelectorAll('.assignee-picker-cb:checked');

    if (_assigneePickerMode === 'INDIVIDUAL') {
        if (checked.length === 0) return;
        var cb = checked[0];
        document.getElementById('assignedTo').value = cb.value;
        var display = document.getElementById('assigneeDisplay');
        display.innerHTML = '<div class="d-flex align-items-center gap-2">'
            + '<i class="bi bi-person-fill text-primary"></i>'
            + '<span class="fw-semibold small">' + escapeHtml(cb.getAttribute('data-name')) + '</span>'
            + '<small class="text-muted">(' + escapeHtml(cb.getAttribute('data-code')) + ')</small>'
            + '</div>';
        var err = document.getElementById('assigneeError');
        if (err) err.classList.add('d-none');
    } else {
        // GROUP mode
        var container = document.getElementById('groupMembersDisplay');
        // Remove old hidden inputs
        document.querySelectorAll('input[name="assignedToGroup"]').forEach(function(el) { el.remove(); });
        container.innerHTML = '';

        if (checked.length === 0) {
            container.innerHTML = '<span class="text-muted small">-- Chưa chọn --</span>';
        } else {
            var form = document.getElementById('taskForm');
            checked.forEach(function(cb) {
                // Hidden input inside the form
                var hidden = document.createElement('input');
                hidden.type = 'hidden'; hidden.name = 'assignedToGroup'; hidden.value = cb.value;
                form.appendChild(hidden);

                // Badge in display
                var badge = document.createElement('span');
                badge.className = 'badge bg-primary-subtle text-primary me-1 mb-1';
                badge.innerHTML = '<i class="bi bi-person me-1"></i>' + escapeHtml(cb.getAttribute('data-name'));
                container.appendChild(badge);
            });
        }

        var err = document.getElementById('groupMainError');
        if (err) { if (checked.length < 2) { err.textContent = 'Cần chọn ít nhất 2 người'; err.classList.remove('d-none'); } else { err.classList.add('d-none'); } }
    }

    bootstrap.Modal.getInstance(document.getElementById('assigneePickerModal')).hide();
}

// ═══════════════════════════════════════════════════════════════════════════
// OBJECT PICKER (Lead + Customer)
// ═══════════════════════════════════════════════════════════════════════════
function openObjectPickerModal() {
    // Show/hide tabs based on task type
    var leadTab = document.querySelector('[data-bs-target="#tabPickerLead"]');
    var customerTab = document.querySelector('[data-bs-target="#tabPickerCustomer"]');
    var leadPane = document.getElementById('tabPickerLead');
    var customerPane = document.getElementById('tabPickerCustomer');

    if (_currentTaskType === 'CUSTOMER') {
        // Show only Customer tab
        if (leadTab) { leadTab.classList.remove('active'); leadTab.parentElement.style.display = 'none'; }
        if (customerTab) { customerTab.classList.add('active'); customerTab.parentElement.style.display = ''; }
        if (leadPane) { leadPane.classList.remove('show', 'active'); }
        if (customerPane) { customerPane.classList.add('show', 'active'); }
        // Uncheck all leads
        document.querySelectorAll('.obj-picker-cb[data-type="LEAD"]').forEach(function(cb) { cb.checked = false; });
    } else {
        // Show only Lead tab
        if (leadTab) { leadTab.classList.add('active'); leadTab.parentElement.style.display = ''; }
        if (customerTab) { customerTab.classList.remove('active'); customerTab.parentElement.style.display = 'none'; }
        if (leadPane) { leadPane.classList.add('show', 'active'); }
        if (customerPane) { customerPane.classList.remove('show', 'active'); }
        // Uncheck all customers
        document.querySelectorAll('.obj-picker-cb[data-type="CUSTOMER"]').forEach(function(cb) { cb.checked = false; });
    }

    // Pre-check current selections
    document.querySelectorAll('.obj-picker-cb').forEach(function(cb) { cb.checked = false; });
    document.querySelectorAll('input[name="selectedLeads"]').forEach(function(inp) {
        var cb = document.querySelector('.obj-picker-cb[data-type="LEAD"][value="' + inp.value + '"]');
        if (cb) cb.checked = true;
    });
    document.querySelectorAll('input[name="selectedCustomers"]').forEach(function(inp) {
        var cb = document.querySelector('.obj-picker-cb[data-type="CUSTOMER"][value="' + inp.value + '"]');
        if (cb) cb.checked = true;
    });

    updateObjectPickerCount();
    var searchInp = document.getElementById('objectPickerSearch');
    if (searchInp) searchInp.value = '';
    document.querySelectorAll('.obj-picker-row').forEach(function(r) { r.style.display = ''; });

    new bootstrap.Modal(document.getElementById('objectPickerModal')).show();
}

function updateObjectPickerCount() {
    // Only count items matching current task type
    var type = _currentTaskType;
    var count = document.querySelectorAll('.obj-picker-cb[data-type="' + type + '"]:checked').length;
    var el = document.getElementById('objectPickerSelectedCount');
    if (el) el.textContent = count;
}

function objectPickerSelectAll() {
    // Only select items matching current task type (LEAD or CUSTOMER)
    var type = _currentTaskType;
    document.querySelectorAll('.obj-picker-cb[data-type="' + type + '"]').forEach(function(cb) {
        var row = cb.closest('.obj-picker-row');
        if (row && row.style.display !== 'none') cb.checked = true;
    });
    updateObjectPickerCount();
}
function objectPickerDeselectAll() {
    // Only deselect items matching current task type
    var type = _currentTaskType;
    document.querySelectorAll('.obj-picker-cb[data-type="' + type + '"]').forEach(function(cb) { cb.checked = false; });
    updateObjectPickerCount();
}

function confirmObjectPicker() {
    var container = document.getElementById('selectedObjectsContainer');
    var noObj = document.getElementById('noObjectSelected');

    // Clear old
    container.querySelectorAll('.selected-obj-item').forEach(function(el) { el.remove(); });

    var checked = document.querySelectorAll('.obj-picker-cb:checked');
    if (checked.length === 0) {
        if (noObj) noObj.style.display = '';
        bootstrap.Modal.getInstance(document.getElementById('objectPickerModal')).hide();
        return;
    }
    if (noObj) noObj.style.display = 'none';

    checked.forEach(function(cb) {
        var objType = cb.getAttribute('data-type');
        var objId   = cb.value;
        var code    = cb.getAttribute('data-code');
        var name    = cb.getAttribute('data-name');
        var phone   = cb.getAttribute('data-phone');

        var inputName = objType === 'LEAD' ? 'selectedLeads' : 'selectedCustomers';
        var icon = objType === 'LEAD' ? 'bi-person-fill text-primary' : 'bi-building text-success';
        var typeBadge = objType === 'LEAD'
            ? '<span class="badge bg-info-subtle text-info ms-1" style="font-size:0.65rem">Lead</span>'
            : '<span class="badge bg-success-subtle text-success ms-1" style="font-size:0.65rem">Customer</span>';

        var hidden = document.createElement('input');
        hidden.type = 'hidden'; hidden.name = inputName; hidden.value = objId;
        hidden.className = 'selected-obj-item';

        var badge = document.createElement('div');
        badge.className = 'selected-obj-item d-flex align-items-center justify-content-between border rounded p-2 mb-1 bg-white';
        badge.setAttribute('data-type', objType);
        badge.setAttribute('data-id', objId);
        badge.innerHTML = '<div class="d-flex align-items-center gap-2">'
            + '<i class="bi ' + icon + '"></i>'
            + '<div><div class="fw-semibold small">' + escapeHtml(name) + typeBadge + '</div>'
            + '<small class="text-muted">' + escapeHtml(code) + (phone ? ' · ' + escapeHtml(phone) : '') + '</small></div>'
            + '</div>'
            + '<button type="button" class="btn btn-sm btn-outline-danger border-0" '
            + 'onclick="removeSelectedObject(this)" title="Xóa"><i class="bi bi-x-lg"></i></button>';

        container.appendChild(hidden);
        container.appendChild(badge);
    });

    bootstrap.Modal.getInstance(document.getElementById('objectPickerModal')).hide();
}

function removeSelectedObject(btn) {
    var item = btn.closest('.selected-obj-item');
    var objType = item.getAttribute('data-type');
    var objId = item.getAttribute('data-id');
    var inputName = objType === 'LEAD' ? 'selectedLeads' : 'selectedCustomers';

    // Remove hidden input
    var container = document.getElementById('selectedObjectsContainer');
    container.querySelectorAll('input[name="' + inputName + '"][value="' + objId + '"]').forEach(function(el) { el.remove(); });
    item.remove();

    if (container.querySelectorAll('.selected-obj-item').length === 0) {
        var noObj = document.getElementById('noObjectSelected');
        if (noObj) noObj.style.display = '';
    }
}

// ═══════════════════════════════════════════════════════════════════════════
// HELPERS
// ═══════════════════════════════════════════════════════════════════════════
function escapeHtml(text) {
    if (!text) return '';
    var div = document.createElement('div');
    div.appendChild(document.createTextNode(text));
    return div.innerHTML;
}
</script>
