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
        <c:if test="${formAction != 'edit'}">
            <span class="badge bg-success fs-6">
                <i class="bi bi-play-circle me-1"></i>Trạng thái: Đang thực hiện (tự động)
            </span>
        </c:if>
    </div>

    <div class="row">
        <!-- ═══════════════════ Main Form ═══════════════════ -->
        <div class="col-lg-8">
            <div class="card shadow-sm">
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/manager/task/form"
                          method="post" id="taskForm" novalidate>
                        <input type="hidden" name="formAction" value="${formAction}">
                        <c:if test="${formAction == 'edit'}">
                            <input type="hidden" name="taskId" value="${task.taskId}">
                        </c:if>
                        <%-- Status: editable for edit; always IN_PROGRESS for create --%>
                        <c:if test="${formAction != 'edit'}">
                            <input type="hidden" name="status" value="IN_PROGRESS">
                        </c:if>

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
                            <div class="col-md-${formAction == 'edit' ? '4' : '6'}">
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

                            <%-- Status: only shown in edit mode --%>
                            <c:if test="${formAction == 'edit'}">
                                <div class="col-md-4">
                                    <label for="status" class="form-label fw-bold">
                                        Trạng thái <span class="text-danger">*</span>
                                    </label>
                                    <select class="form-select" id="status" name="status" required>
                                        <c:forEach var="s" items="${taskStatusValues}">
                                            <option value="${s.name()}"
                                                    ${task.statusName == s.name() ? 'selected' : ''}
                                                    ${empty task.statusName && s.name() == 'IN_PROGRESS' ? 'selected' : ''}>
                                                ${s.vietnamese}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </c:if>

                            <div class="col-md-${formAction == 'edit' ? '4' : '6'}">
                                <label for="dueDate" class="form-label fw-bold">
                                    Hạn chót <span class="text-danger">*</span>
                                </label>
                                <input type="date" class="form-control" id="dueDate" name="dueDate"
                                       value="${fn:substring(task.dueDate, 0, 10)}"
                                       required>
                                <small class="text-muted">Nhắc nhở tự động 24 giờ trước hạn chót</small>
                            </div>
                        </div>

                        <%-- ════════════════════════════════════════════════════
                             ASSIGN SECTION
                             Create: Individual / Group — popup picker for assignee
                             Edit:   Single assignee dropdown
                             ════════════════════════════════════════════════════ --%>
                        <div class="card border-primary border-opacity-25 mb-4">
                            <div class="card-header bg-primary bg-opacity-10">
                                <h6 class="mb-0"><i class="bi bi-person-check me-2"></i>Phân công</h6>
                            </div>
                            <div class="card-body">

                                <c:choose>
                                    <c:when test="${formAction != 'edit'}">
                                        <%-- Assign type radio --%>
                                        <div class="mb-3">
                                            <label class="form-label fw-semibold">Hình thức giao <span class="text-danger">*</span></label>
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
                                            <label class="form-label fw-semibold">
                                                Người thực hiện <span class="text-danger">*</span>
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
                                            <label class="form-label fw-semibold">
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
                                    </c:when>

                                    <c:otherwise>
                                        <%-- Edit mode: single assignee dropdown --%>
                                        <label for="assignedTo" class="form-label fw-semibold">
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
                                        <div class="invalid-feedback">Vui lòng chọn người thực hiện</div>
                                    </c:otherwise>
                                </c:choose>

                            </div><%-- /card-body assign --%>
                        </div>

                        <%-- ════════════════════════════════════════════════════
                             RELATED OBJECT (edit mode only — keeps old dropdown)
                             Create mode uses sidebar lead picker or linkedLead
                             ════════════════════════════════════════════════════ --%>
                        <c:if test="${formAction == 'edit'}">
                            <div class="card bg-light border-0 mb-4">
                                <div class="card-body">
                                    <h6 class="mb-3">
                                        <i class="bi bi-link-45deg me-1"></i>Liên kết đối tượng (tùy chọn)
                                    </h6>
                                    <input type="hidden" name="relatedType" id="relatedType">
                                    <c:set var="initRelatedValue" value=""/>
                                    <c:if test="${(task.relatedType == 'LEAD' || task.relatedType == 'Lead') && task.relatedId != null}">
                                        <c:set var="initRelatedValue" value="LEAD_${task.relatedId}"/>
                                    </c:if>
                                    <c:if test="${(task.relatedType == 'CUSTOMER' || task.relatedType == 'Customer') && task.relatedId != null}">
                                        <c:set var="initRelatedValue" value="CUSTOMER_${task.relatedId}"/>
                                    </c:if>
                                    <c:if test="${(task.relatedType == 'OPPORTUNITY' || task.relatedType == 'Opportunity') && task.relatedId != null}">
                                        <c:set var="initRelatedValue" value="OPPORTUNITY_${task.relatedId}"/>
                                    </c:if>
                                    <select class="form-select mb-3" id="relatedObject" name="relatedId">
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
                        </c:if>

                        <%-- Hidden field for linked lead from lead-list page --%>
                        <c:if test="${formAction != 'edit' && not empty linkedLead}">
                            <input type="hidden" name="selectedLeads" value="${linkedLead.leadId}">
                        </c:if>

                        <%-- Hidden field for linked customer from customer-list page --%>
                        <c:if test="${formAction != 'edit' && not empty linkedCustomer}">
                            <input type="hidden" name="selectedCustomers" value="${linkedCustomer.customerId}">
                        </c:if>

                        <%-- ── Task Dependencies (edit mode only) ──────────── --%>
                        <c:if test="${formAction == 'edit'}">
                            <div class="card border-warning border-opacity-50 mb-4">
                                <div class="card-header bg-warning bg-opacity-10">
                                    <h6 class="mb-0"><i class="bi bi-lock me-2"></i>Công việc phụ thuộc (tùy chọn)</h6>
                                </div>
                                <div class="card-body">
                                    <p class="text-muted small mb-2">
                                        Công việc này sẽ bị chặn cho đến khi tất cả công việc phụ thuộc hoàn thành.
                                    </p>
                                    <c:if test="${not empty existingDepTasks}">
                                        <div class="mb-2">
                                            <small class="text-muted">Hiện tại phụ thuộc vào:</small>
                                            <div class="d-flex flex-wrap gap-1 mt-1">
                                                <c:forEach var="dep" items="${existingDepTasks}">
                                                    <span class="badge ${dep.statusName == 'COMPLETED' ? 'bg-success' : 'bg-secondary'}">
                                                        #${dep.taskId} ${dep.taskCode}
                                                        <c:if test="${dep.statusName != 'COMPLETED'}"> ⚠</c:if>
                                                    </span>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </c:if>
                                    <label for="dependencyIds" class="form-label small fw-bold">
                                        ID công việc phụ thuộc (cách nhau bởi dấu phẩy):
                                    </label>
                                    <c:set var="depIdsStr" value=""/>
                                    <c:forEach var="depId" items="${existingDepIds}" varStatus="st">
                                        <c:set var="depIdsStr" value="${depIdsStr}${st.first ? '' : ','}${depId}"/>
                                    </c:forEach>
                                    <input type="text" class="form-control" id="dependencyIds"
                                           name="dependencyIds" value="${depIdsStr}"
                                           placeholder="Ví dụ: 5,12,23 — để trống nếu không phụ thuộc">
                                    <small class="text-muted">Nhập task_id của các công việc phải hoàn thành trước.</small>
                                </div>
                            </div>
                        </c:if>

                        <%-- ── Submit buttons ─────────────────────────────── --%>
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

        <!-- ═══════════════════ Sidebar ═══════════════════ -->
        <div class="col-lg-4">

            <c:choose>
                <%-- Case 1: Coming from lead page — show linked lead info --%>
                <c:when test="${formAction != 'edit' && not empty linkedLead}">
                    <div class="card border-primary mb-3">
                        <div class="card-header bg-primary bg-opacity-10 py-2 d-flex align-items-center gap-2">
                            <i class="bi bi-person-vcard-fill text-primary"></i>
                            <span class="fw-semibold text-primary">Lead liên kết</span>
                            <span class="badge bg-info text-dark ms-1">${linkedLead.leadCode}</span>
                        </div>
                        <div class="card-body py-2 px-3" id="linkedLeadInfo">
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
                                <div class="row g-2">
                                    <div class="col-6">
                                        <small class="text-muted d-block">Trạng thái</small>
                                        <span class="badge bg-secondary">${linkedLead.status}</span>
                                    </div>
                                    <div class="col-6">
                                        <small class="text-muted d-block">Đánh giá</small>
                                        <span>${not empty linkedLead.rating ? linkedLead.rating : '—'}</span>
                                    </div>
                                </div>
                                <c:if test="${not empty linkedLead.interests}">
                                    <div>
                                        <small class="text-muted d-block">Quan tâm</small>
                                        <span class="small">${fn:escapeXml(linkedLead.interests)}</span>
                                    </div>
                                </c:if>
                                <c:if test="${not empty linkedLead.notes}">
                                    <div>
                                        <small class="text-muted d-block">Ghi chú</small>
                                        <span class="small text-muted fst-italic">${fn:escapeXml(linkedLead.notes)}</span>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:when>

                <%-- Case 1b: Coming from customer page — show linked customer info --%>
                <c:when test="${formAction != 'edit' && not empty linkedCustomer}">
                    <div class="card border-success mb-3">
                        <div class="card-header bg-success bg-opacity-10 py-2 d-flex align-items-center gap-2">
                            <i class="bi bi-people-fill text-success"></i>
                            <span class="fw-semibold text-success">Khách hàng liên kết</span>
                            <span class="badge bg-info text-dark ms-1">${linkedCustomer.customerCode}</span>
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
                                <div class="row g-2">
                                    <div class="col-6">
                                        <small class="text-muted d-block">Trạng thái</small>
                                        <span class="badge bg-success">${linkedCustomer.status}</span>
                                    </div>
                                    <div class="col-6">
                                        <small class="text-muted d-block">Phân khúc</small>
                                        <span>${not empty linkedCustomer.customerSegment ? linkedCustomer.customerSegment : '—'}</span>
                                    </div>
                                </div>
                                <c:if test="${not empty linkedCustomer.city}">
                                    <div>
                                        <small class="text-muted d-block">Thành phố</small>
                                        <span class="small">${fn:escapeXml(linkedCustomer.city)}</span>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:when>

                <%-- Case 2: Normal create — show lead/customer picker --%>
                <c:when test="${formAction != 'edit'}">
                    <div class="card border-success mb-3">
                        <div class="card-header bg-success bg-opacity-10 py-2 d-flex justify-content-between align-items-center">
                            <span class="fw-semibold text-success">
                                <i class="bi bi-link-45deg me-1"></i>Liên kết đối tượng
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
                </c:when>
            </c:choose>

            <%-- Edit mode: creation info card --%>
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

<%-- ═══════════════════ Assignee Picker Modal ═══════════════════ --%>
<c:if test="${formAction != 'edit'}">
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
                                <tr class="assignee-picker-row"
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
</c:if>

<%-- ═══════════════════ Object Picker Modal (Lead + Customer tabs) ═══════════════════ --%>
<c:if test="${formAction != 'edit' && empty linkedLead && empty linkedCustomer}">
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
</c:if>

<!-- Select2 JS (for edit mode) -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

<script>
$(document).ready(function () {

    var CTX     = '${pageContext.request.contextPath}';
    var IS_EDIT = '${formAction}' === 'edit';

    // ── Due-date minimum (create mode) ───────────────────────────────────
    var dueDateInput = document.getElementById('dueDate');
    if (dueDateInput && !IS_EDIT) {
        var today = new Date();
        dueDateInput.min = today.getFullYear() + '-'
            + String(today.getMonth() + 1).padStart(2, '0') + '-'
            + String(today.getDate()).padStart(2, '0');
    }

    // ── Select2 on related-object dropdown (edit mode only) ──────────────
    if (IS_EDIT && document.getElementById('relatedObject')) {
        $('#relatedObject').select2({
            theme: 'bootstrap-5',
            placeholder: '-- Không liên kết --',
            allowClear: true,
            width: '100%'
        });

        var relTypeInput = document.getElementById('relatedType');
        var TYPE_MAP = { 'LEAD': 'LEAD', 'CUSTOMER': 'CUSTOMER', 'OPPORTUNITY': 'OPPORTUNITY' };

        function parseRelatedValue(val) {
            if (!val) return { prefix: '', id: '' };
            var idx = val.indexOf('_');
            if (idx <= 0 || idx === val.length - 1) return { prefix: '', id: '' };
            return { prefix: val.substring(0, idx), id: val.substring(idx + 1) };
        }

        function onRelatedChange(val) {
            var parsed = parseRelatedValue(val);
            if (relTypeInput) relTypeInput.value = TYPE_MAP[parsed.prefix] || '';
        }

        $('#relatedObject').on('change', function() { onRelatedChange(this.value); });
        onRelatedChange($('#relatedObject').val() || '');
    }

    // ── Assign-type toggle (create mode only) ────────────────────────────
    window.toggleAssignType = function(type) {
        var indiv = document.getElementById('sectionIndividual');
        var group = document.getElementById('sectionGroup');

        if (type === 'GROUP') {
            if (indiv) indiv.classList.add('d-none');
            if (group) group.classList.remove('d-none');
        } else {
            if (indiv) indiv.classList.remove('d-none');
            if (group) group.classList.add('d-none');
            var mainErr = document.getElementById('groupMainError');
            if (mainErr) mainErr.classList.add('d-none');
        }
    };

    // ── Form submit validation ────────────────────────────────────────────
    document.getElementById('taskForm').addEventListener('submit', function(e) {
        if (IS_EDIT) {
            if (!this.checkValidity()) { e.preventDefault(); e.stopPropagation(); }
            this.classList.add('was-validated');
            return;
        }

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
                // For object picker, also check active tab
                var data = row.getAttribute('data-search') || '';
                row.style.display = (!kw || data.indexOf(kw) !== -1) ? '' : 'none';
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
});

// ═══════════════════════════════════════════════════════════════════════════
// ASSIGNEE PICKER
// ═══════════════════════════════════════════════════════════════════════════
var _assigneePickerMode = 'INDIVIDUAL'; // or 'GROUP'

function openAssigneePickerModal(mode) {
    _assigneePickerMode = mode;
    var modeLabel = document.getElementById('assigneePickerMode');
    if (modeLabel) modeLabel.textContent = mode === 'GROUP' ? 'Nhóm' : 'Cá nhân';

    // Pre-check current selection
    document.querySelectorAll('.assignee-picker-cb').forEach(function(cb) { cb.checked = false; });

    if (mode === 'INDIVIDUAL') {
        var current = document.getElementById('assignedTo').value;
        if (current) {
            var cb = document.querySelector('.assignee-picker-cb[value="' + current + '"]');
            if (cb) cb.checked = true;
        }
    } else {
        document.querySelectorAll('input[name="assignedToGroup"]').forEach(function(inp) {
            var cb = document.querySelector('.assignee-picker-cb[value="' + inp.value + '"]');
            if (cb) cb.checked = true;
        });
    }

    updateAssigneePickerCount();
    var searchInp = document.getElementById('assigneePickerSearch');
    if (searchInp) { searchInp.value = ''; }
    document.querySelectorAll('.assignee-picker-row').forEach(function(r) { r.style.display = ''; });

    new bootstrap.Modal(document.getElementById('assigneePickerModal')).show();
}

function updateAssigneePickerCount() {
    var count = document.querySelectorAll('.assignee-picker-cb:checked').length;
    var el = document.getElementById('assigneePickerCount');
    if (el) el.textContent = count;

    // Individual mode: only allow 1 selection
    if (_assigneePickerMode === 'INDIVIDUAL' && count >= 1) {
        document.querySelectorAll('.assignee-picker-cb:not(:checked)').forEach(function(cb) {
            cb.disabled = true;
        });
    } else {
        document.querySelectorAll('.assignee-picker-cb').forEach(function(cb) { cb.disabled = false; });
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
    var count = document.querySelectorAll('.obj-picker-cb:checked').length;
    var el = document.getElementById('objectPickerSelectedCount');
    if (el) el.textContent = count;
}

function objectPickerSelectAll() {
    document.querySelectorAll('.obj-picker-row:not([style*="display: none"]) .obj-picker-cb').forEach(function(cb) { cb.checked = true; });
    updateObjectPickerCount();
}
function objectPickerDeselectAll() {
    document.querySelectorAll('.obj-picker-cb').forEach(function(cb) { cb.checked = false; });
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
