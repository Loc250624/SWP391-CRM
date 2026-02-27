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
                                                ${task.priority == p.name() ? 'selected' : ''}
                                                ${empty task.priority && p.name() == 'MEDIUM' ? 'selected' : ''}>
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
                                                    ${task.status == s.name() ? 'selected' : ''}
                                                    ${empty task.status && s.name() == 'IN_PROGRESS' ? 'selected' : ''}>
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
                             Create: Individual / Group with Support Members
                             Edit:   Single assignee only
                             ════════════════════════════════════════════════════ --%>
                        <div class="card border-primary border-opacity-25 mb-4">
                            <div class="card-header bg-primary bg-opacity-10">
                                <h6 class="mb-0"><i class="bi bi-person-check me-2"></i>Phân công</h6>
                            </div>
                            <div class="card-body">

                                <c:choose>
                                    <c:when test="${formAction != 'edit'}">
                                        <%-- Assign type radio: create mode only --%>
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

                                        <%-- Individual: single select (all users) --%>
                                        <div id="sectionIndividual">
                                            <label for="assignedTo" class="form-label fw-semibold">
                                                Người thực hiện <span class="text-danger">*</span>
                                            </label>
                                            <select class="form-select" id="assignedTo" name="assignedTo">
                                                <option value="">-- Chọn người thực hiện --</option>
                                                <c:forEach var="user" items="${allUsers}">
                                                    <option value="${user.userId}">
                                                        ${user.firstName} ${user.lastName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                            <div class="invalid-feedback">Vui lòng chọn người thực hiện</div>
                                        </div>

                                        <%-- Group: checkboxes (team members) --%>
                                        <div id="sectionGroup" class="d-none">
                                            <label class="form-label fw-semibold">
                                                Thành viên nhóm (chính) <span class="text-danger">*</span>
                                            </label>
                                            <div class="border rounded p-3 mb-2"
                                                 style="max-height:180px; overflow-y:auto;" id="groupMemberBox">
                                                <c:choose>
                                                    <c:when test="${empty salesForAssign}">
                                                        <span class="text-muted small">Không có nhân viên trong phòng ban</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="u" items="${salesForAssign}">
                                                            <div class="form-check mb-1">
                                                                <input class="form-check-input group-main-cb"
                                                                       type="checkbox"
                                                                       name="assignedToGroup"
                                                                       value="${u.userId}"
                                                                       id="grpMain_${u.userId}">
                                                                <label class="form-check-label" for="grpMain_${u.userId}">
                                                                    ${u.firstName} ${u.lastName}
                                                                </label>
                                                            </div>
                                                        </c:forEach>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="text-danger small d-none" id="groupMainError">
                                                Vui lòng chọn ít nhất một thành viên
                                            </div>

                                            <%-- Support members (optional) --%>
                                            <c:if test="${not empty salesForAssign}">
                                                <div class="mt-3">
                                                    <label class="form-label fw-semibold text-secondary">
                                                        <i class="bi bi-person-plus me-1"></i>
                                                        Thành viên hỗ trợ (tùy chọn)
                                                    </label>
                                                    <div class="border rounded p-3"
                                                         style="max-height:150px; overflow-y:auto;">
                                                        <c:forEach var="u" items="${salesForAssign}">
                                                            <div class="form-check mb-1">
                                                                <input class="form-check-input group-support-cb"
                                                                       type="checkbox"
                                                                       name="supportMembers"
                                                                       value="${u.userId}"
                                                                       id="grpSupport_${u.userId}">
                                                                <label class="form-check-label text-muted" for="grpSupport_${u.userId}">
                                                                    ${u.firstName} ${u.lastName}
                                                                    <small class="badge bg-secondary ms-1">Hỗ trợ</small>
                                                                </label>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                    <small class="text-muted">
                                                        <i class="bi bi-info-circle me-1"></i>
                                                        Thành viên hỗ trợ cũng nhận bản sao công việc với ghi chú vai trò hỗ trợ.
                                                    </small>
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:when>

                                    <c:otherwise>
                                        <%-- Edit mode: single assignee --%>
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
                             RELATED OBJECT + OBJECT INFO PANEL
                             ════════════════════════════════════════════════════ --%>
                        <div class="card bg-light border-0 mb-4">
                            <div class="card-body">
                                <h6 class="mb-3">
                                    <i class="bi bi-link-45deg me-1"></i>Liên kết đối tượng (tùy chọn)
                                </h6>

                                <%-- Hidden field: servlet derives type from composite relatedId anyway --%>
                                <input type="hidden" name="relatedType" id="relatedType">

                                <%-- Build initial composite value for edit-mode preselection.
                                     Handle both old title-case ("Lead") and new uppercase ("LEAD"). --%>
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

                                <%-- Object info panel: shown when Lead or Customer is selected --%>
                                <div id="objectInfoPanel" class="d-none">
                                    <div class="alert alert-info py-2 mb-2 d-flex align-items-center gap-2" id="objectInfoLoading">
                                        <span class="spinner-border spinner-border-sm"></span>
                                        <span>Đang tải thông tin...</span>
                                    </div>

                                    <div id="objectInfoContent" class="d-none">
                                        <div class="border rounded p-3 bg-white">
                                            <div class="row g-2 mb-2">
                                                <div class="col-sm-6">
                                                    <small class="text-muted d-block">Họ tên</small>
                                                    <strong id="infoFullName">—</strong>
                                                </div>
                                                <div class="col-sm-3">
                                                    <small class="text-muted d-block">SĐT</small>
                                                    <span id="infoPhone">—</span>
                                                </div>
                                                <div class="col-sm-3">
                                                    <small class="text-muted d-block">Email</small>
                                                    <span id="infoEmail" class="small">—</span>
                                                </div>
                                            </div>
                                            <div class="row g-2 mb-2">
                                                <div class="col-sm-4">
                                                    <small class="text-muted d-block">Nguồn</small>
                                                    <span id="infoSource">—</span>
                                                </div>
                                                <div class="col-sm-4">
                                                    <small class="text-muted d-block">Sales phụ trách</small>
                                                    <span id="infoAssignedUser">—</span>
                                                </div>
                                                <div class="col-sm-4" id="infoExtraLabelRow">
                                                    <small class="text-muted d-block" id="infoExtraLabel">—</small>
                                                    <span id="infoExtraValue">—</span>
                                                </div>
                                            </div>
                                            <div id="infoNotesRow" class="d-none">
                                                <small class="text-muted d-block">Ghi chú / Lịch sử tương tác</small>
                                                <div id="infoNotes" class="small text-muted fst-italic"
                                                     style="max-height:60px;overflow-y:auto;"></div>
                                            </div>
                                        </div>
                                    </div>

                                    <div id="objectInfoError" class="alert alert-warning py-2 d-none">
                                        <i class="bi bi-exclamation-triangle me-1"></i>
                                        Không thể tải thông tin đối tượng
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%-- ── Recurring Task (create mode only) ────────────── --%>
                        <c:if test="${formAction != 'edit'}">
                            <div class="card border-primary border-opacity-25 mb-4">
                                <div class="card-header bg-primary bg-opacity-10">
                                    <div class="form-check form-switch mb-0">
                                        <input class="form-check-input" type="checkbox"
                                               id="enableRecurring" name="enableRecurring">
                                        <label class="form-check-label fw-bold" for="enableRecurring">
                                            <i class="bi bi-arrow-repeat me-1"></i>Bật lặp lại tự động
                                        </label>
                                    </div>
                                </div>
                                <div class="card-body" id="recurringPanel" style="display:none;">
                                    <div class="row g-3">
                                        <div class="col-md-4">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio"
                                                       name="recurrencePattern" id="pat_daily" value="DAILY">
                                                <label class="form-check-label" for="pat_daily">
                                                    <i class="bi bi-calendar-day me-1 text-primary"></i>Hàng ngày
                                                </label>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio"
                                                       name="recurrencePattern" id="pat_weekly" value="WEEKLY" checked>
                                                <label class="form-check-label" for="pat_weekly">
                                                    <i class="bi bi-calendar-week me-1 text-primary"></i>Hàng tuần
                                                </label>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio"
                                                       name="recurrencePattern" id="pat_monthly" value="MONTHLY">
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

                        <%-- Recurring info for edit mode --%>
                        <c:if test="${formAction == 'edit' && fn:contains(task.title, '[R-')}">
                            <div class="alert alert-info mb-3">
                                <i class="bi bi-arrow-repeat me-2"></i>
                                Công việc này có cài đặt lặp lại.
                                <a href="${pageContext.request.contextPath}/manager/task/recurring?id=${task.taskId}"
                                   class="alert-link">Chỉnh sửa cài đặt lặp lại</a>
                            </div>
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
            <div class="card bg-light border-0 mb-3">
                <div class="card-body">
                    <h6 class="mb-2"><i class="bi bi-info-circle me-1 text-success"></i>Hướng dẫn</h6>
                    <ul class="list-unstyled small mb-0">
                        <c:if test="${formAction != 'edit'}">
                            <li class="mb-1">
                                <i class="bi bi-play-circle-fill text-success me-1"></i>
                                Trạng thái mặc định: <strong>Đang thực hiện</strong>
                            </li>
                        </c:if>
                        <li class="mb-1"><i class="bi bi-check2 text-success me-1"></i>Tiêu đề, ưu tiên, hạn chót là bắt buộc</li>
                        <li class="mb-1"><i class="bi bi-check2 text-success me-1"></i>Nhắc nhở tự động 24 giờ trước hạn chót</li>
                        <li class="mb-1"><i class="bi bi-check2 text-success me-1"></i>Liên kết với Lead, Khách hàng hoặc Cơ hội để tự động hiển thị thông tin</li>
                        <c:if test="${formAction != 'edit'}">
                            <li><i class="bi bi-check2 text-success me-1"></i>Chế độ nhóm: mỗi người nhận bản sao riêng</li>
                        </c:if>
                    </ul>
                </div>
            </div>

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

    // ── Select2 on related-object dropdown ───────────────────────────────
    $('#relatedObject').select2({
        theme: 'bootstrap-5',
        placeholder: '-- Không liên kết --',
        allowClear: true,
        width: '100%'
    });

    // ── Assign-type toggle (create mode only) ────────────────────────────
    window.toggleAssignType = function(type) {
        var indiv = document.getElementById('sectionIndividual');
        var group = document.getElementById('sectionGroup');
        var assignedTo = document.getElementById('assignedTo');

        if (type === 'GROUP') {
            if (indiv) indiv.classList.add('d-none');
            if (group) group.classList.remove('d-none');
            if (assignedTo) assignedTo.removeAttribute('required');
        } else {
            if (indiv) indiv.classList.remove('d-none');
            if (group) group.classList.add('d-none');
            if (assignedTo) assignedTo.setAttribute('required', '');
            var mainErr = document.getElementById('groupMainError');
            if (mainErr) mainErr.classList.add('d-none');
        }
    };

    // ── Object info panel ────────────────────────────────────────────────
    var panel        = document.getElementById('objectInfoPanel');
    var loadingEl    = document.getElementById('objectInfoLoading');
    var contentEl    = document.getElementById('objectInfoContent');
    var errorEl      = document.getElementById('objectInfoError');
    var relTypeInput = document.getElementById('relatedType');

    function showPanel()  { panel.classList.remove('d-none'); }
    function hidePanel()  { panel.classList.add('d-none'); }
    function showLoading(){ loadingEl.classList.remove('d-none'); contentEl.classList.add('d-none'); errorEl.classList.add('d-none'); }
    function showContent(){ loadingEl.classList.add('d-none'); contentEl.classList.remove('d-none'); errorEl.classList.add('d-none'); }
    function showError()  { loadingEl.classList.add('d-none'); contentEl.classList.add('d-none'); errorEl.classList.remove('d-none'); }

    function setText(id, val) {
        var el = document.getElementById(id);
        if (el) el.textContent = val || '—';
    }

    function renderObjectInfo(data) {
        setText('infoFullName',     data.fullName);
        setText('infoPhone',        data.phone);
        setText('infoEmail',        data.email);
        setText('infoSource',       data.sourceName);
        setText('infoAssignedUser', data.assignedUserName || 'Chưa phụ trách');

        var extraLabel = document.getElementById('infoExtraLabel');
        var extraValue = document.getElementById('infoExtraValue');
        var notesRow   = document.getElementById('infoNotesRow');
        var notesEl    = document.getElementById('infoNotes');

        if (data.type === 'LEAD') {
            if (extraLabel) extraLabel.textContent = 'Đánh giá / Sở thích';
            var extra = [data.rating, data.interests].filter(function(v){ return v && v.trim(); }).join(' · ');
            if (extraValue) extraValue.textContent = extra || '—';
        } else {
            if (extraLabel) extraLabel.textContent = 'Phân khúc';
            if (extraValue) extraValue.textContent = data.customerSegment || '—';
        }

        var notes = (data.notes || '').trim() || (data.purchasedCourses ? 'Khóa học: ' + data.purchasedCourses : '');
        if (notes && notesEl && notesRow) {
            notesEl.textContent = notes;
            notesRow.classList.remove('d-none');
        } else if (notesRow) {
            notesRow.classList.add('d-none');
        }

        showContent();
    }

    function fetchObjectInfo(type, id) {
        if (!type || !id) { hidePanel(); return; }
        showPanel();
        showLoading();

        fetch(CTX + '/manager/task/object-info?type=' + encodeURIComponent(type) + '&id=' + encodeURIComponent(id),
              { credentials: 'same-origin' })
            .then(function(resp) {
                if (!resp.ok) throw new Error('HTTP ' + resp.status);
                return resp.json();
            })
            .then(function(data) {
                if (data.error) { showError(); return; }
                renderObjectInfo(data);
            })
            .catch(function() { showError(); });
    }

    // ── Parse composite value (e.g. "CUSTOMER_45") ───────────────────────
    function parseRelatedValue(val) {
        if (!val) return { prefix: '', id: '' };
        var idx = val.indexOf('_');
        if (idx <= 0 || idx === val.length - 1) return { prefix: '', id: '' };
        return { prefix: val.substring(0, idx), id: val.substring(idx + 1) };
    }

    // ── Central handler for related-object change ─────────────────────────
    var TYPE_MAP = { 'LEAD': 'LEAD', 'CUSTOMER': 'CUSTOMER', 'OPPORTUNITY': 'OPPORTUNITY' };

    function onRelatedChange(val) {
        var parsed = parseRelatedValue(val);
        var typeStr = TYPE_MAP[parsed.prefix] || '';
        if (relTypeInput) relTypeInput.value = typeStr;

        if (typeStr === 'LEAD' || typeStr === 'CUSTOMER') {
            fetchObjectInfo(typeStr, parsed.id);
        } else {
            hidePanel();
        }
    }

    // Wire up Select2 change event
    $('#relatedObject').on('change', function() {
        onRelatedChange(this.value);
    });

    // On page load: init for edit mode
    onRelatedChange($('#relatedObject').val() || '');

    // ── Form submit validation ────────────────────────────────────────────
    document.getElementById('taskForm').addEventListener('submit', function(e) {
        var assignType = !IS_EDIT && document.querySelector('[name="assignType"]:checked')
                         ? document.querySelector('[name="assignType"]:checked').value
                         : 'INDIVIDUAL';

        if (assignType === 'GROUP') {
            var checked = document.querySelectorAll('.group-main-cb:checked');
            var mainErr = document.getElementById('groupMainError');
            if (checked.length === 0) {
                e.preventDefault();
                e.stopPropagation();
                if (mainErr) mainErr.classList.remove('d-none');
                return;
            }
            if (mainErr) mainErr.classList.add('d-none');
            // Remove required from individual select to avoid false HTML5 validation
            var assignedTo = document.getElementById('assignedTo');
            if (assignedTo) assignedTo.removeAttribute('required');
        }

        if (!this.checkValidity()) {
            e.preventDefault();
            e.stopPropagation();
        }
        this.classList.add('was-validated');
    });

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
