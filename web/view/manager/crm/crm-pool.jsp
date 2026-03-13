<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="container-fluid">

    <%-- Success / Error messages --%>
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle me-2"></i>${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle me-2"></i>${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <%-- Page header --%>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="mb-1"><i class="bi bi-inbox-fill me-2 text-success"></i>CRM Pool - Chưa được giao</h3>
            <p class="text-muted mb-0">Lead và Khách hàng chưa có người phụ trách. Giao việc để chuyển sang quản lý task.</p>
        </div>
        <div>
            <span class="badge bg-info fs-6 me-1">${totalLeads} Lead</span>
            <span class="badge bg-success fs-6">${totalCustomers} Khách hàng</span>
        </div>
    </div>

    <%-- Filters --%>
    <div class="card mb-4 shadow-sm">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/manager/crm/pool" class="row g-2 align-items-end">
                <div class="col-md-8">
                    <label class="form-label fw-semibold small">Tìm kiếm</label>
                    <input type="text" name="keyword" class="form-control"
                           placeholder="Tên, mã, SĐT..." value="${keyword}">
                </div>
                <div class="col-md-4 d-flex gap-2 align-items-end">
                    <button type="submit" class="btn btn-primary flex-fill">
                        <i class="bi bi-search me-1"></i>Lọc
                    </button>
                    <a href="${pageContext.request.contextPath}/manager/crm/pool"
                       class="btn btn-outline-secondary" title="Xóa bộ lọc">
                        <i class="bi bi-arrow-counterclockwise"></i>
                    </a>
                </div>
            </form>
        </div>
    </div>

    <%-- ═══════════════ LEAD TABLE ═══════════════ --%>
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-info bg-opacity-10 d-flex justify-content-between align-items-center">
            <h5 class="mb-0"><i class="bi bi-person-lines-fill me-2 text-info"></i>Lead chưa giao
                <span class="badge bg-info text-dark ms-1">${totalLeads}</span>
            </h5>
        </div>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th>Họ tên</th>
                        <th>Mã</th>
                        <th>SĐT</th>
                        <th>Nguồn</th>
                        <th>Ngày tạo</th>
                        <th class="text-center" style="width:130px">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty poolLeads}">
                            <tr>
                                <td colspan="6" class="text-center py-4 text-muted">
                                    <i class="bi bi-inbox fs-4 d-block mb-2"></i>
                                    Không có Lead nào chưa được giao
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="lead" items="${poolLeads}">
                                <c:set var="leadDate" value=""/>
                                <c:if test="${lead.createdAt != null}">
                                    <c:set var="leadDate"
                                           value="${fn:substring(lead.createdAt.toString(),8,10)}/${fn:substring(lead.createdAt.toString(),5,7)}/${fn:substring(lead.createdAt.toString(),0,4)}"/>
                                </c:if>
                                <tr>
                                    <td class="fw-semibold">${lead.fullName}</td>
                                    <td><small class="text-muted">${lead.leadCode}</small></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty lead.phone}">${lead.phone}</c:when>
                                            <c:otherwise><span class="text-muted">-</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${lead.sourceId != null && not empty sourceMap[lead.sourceId]}">
                                                <small class="text-muted">${sourceMap[lead.sourceId]}</small>
                                            </c:when>
                                            <c:otherwise><span class="text-muted">-</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><small>${leadDate}</small></td>
                                    <td class="text-center">
                                        <button type="button"
                                                class="btn btn-sm btn-success"
                                                title="Giao việc"
                                                onclick="openAssignModal(
                                                    'LEAD',
                                                    ${lead.leadId},
                                                    '${fn:escapeXml(lead.fullName)}',
                                                    '${fn:escapeXml(lead.phone)}',
                                                    '${lead.sourceId != null && not empty sourceMap[lead.sourceId] ? fn:escapeXml(sourceMap[lead.sourceId]) : ""}',
                                                    '${leadDate}'
                                                )">
                                            <i class="bi bi-plus-circle me-1"></i>Giao việc
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <%-- Lead Pagination --%>
    <c:if test="${totalLeadPages > 1}">
        <nav class="mb-4">
            <ul class="pagination justify-content-center pagination-sm">
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link" href="?page=${currentPage - 1}&keyword=${keyword}">
                        <i class="bi bi-chevron-left"></i>
                    </a>
                </li>
                <c:forEach begin="1" end="${totalLeadPages}" var="p">
                    <c:if test="${p >= currentPage - 2 && p <= currentPage + 2}">
                        <li class="page-item ${p == currentPage ? 'active' : ''}">
                            <a class="page-link" href="?page=${p}&keyword=${keyword}">${p}</a>
                        </li>
                    </c:if>
                </c:forEach>
                <li class="page-item ${currentPage == totalLeadPages ? 'disabled' : ''}">
                    <a class="page-link" href="?page=${currentPage + 1}&keyword=${keyword}">
                        <i class="bi bi-chevron-right"></i>
                    </a>
                </li>
            </ul>
        </nav>
    </c:if>

    <%-- ═══════════════ CUSTOMER TABLE ═══════════════ --%>
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-success bg-opacity-10 d-flex justify-content-between align-items-center">
            <h5 class="mb-0"><i class="bi bi-people-fill me-2 text-success"></i>Khách hàng chưa giao
                <span class="badge bg-success ms-1">${totalCustomers}</span>
            </h5>
        </div>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th>Họ tên</th>
                        <th>Mã</th>
                        <th>SĐT</th>
                        <th>Nguồn</th>
                        <th>Ngày tạo</th>
                        <th class="text-center" style="width:130px">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty poolCustomers}">
                            <tr>
                                <td colspan="6" class="text-center py-4 text-muted">
                                    <i class="bi bi-inbox fs-4 d-block mb-2"></i>
                                    Không có Khách hàng nào chưa được giao
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="cust" items="${poolCustomers}">
                                <c:set var="custDate" value=""/>
                                <c:if test="${cust.createdAt != null}">
                                    <c:set var="custDate"
                                           value="${fn:substring(cust.createdAt.toString(),8,10)}/${fn:substring(cust.createdAt.toString(),5,7)}/${fn:substring(cust.createdAt.toString(),0,4)}"/>
                                </c:if>
                                <tr>
                                    <td class="fw-semibold">${cust.fullName}</td>
                                    <td><small class="text-muted">${cust.customerCode}</small></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty cust.phone}">${cust.phone}</c:when>
                                            <c:otherwise><span class="text-muted">-</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${cust.sourceId != null && not empty sourceMap[cust.sourceId]}">
                                                <small class="text-muted">${sourceMap[cust.sourceId]}</small>
                                            </c:when>
                                            <c:otherwise><span class="text-muted">-</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><small>${custDate}</small></td>
                                    <td class="text-center">
                                        <button type="button"
                                                class="btn btn-sm btn-success"
                                                title="Giao việc"
                                                onclick="openAssignModal(
                                                    'CUSTOMER',
                                                    ${cust.customerId},
                                                    '${fn:escapeXml(cust.fullName)}',
                                                    '${fn:escapeXml(cust.phone)}',
                                                    '${cust.sourceId != null && not empty sourceMap[cust.sourceId] ? fn:escapeXml(sourceMap[cust.sourceId]) : ""}',
                                                    '${custDate}'
                                                )">
                                            <i class="bi bi-plus-circle me-1"></i>Giao việc
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <%-- Customer Pagination --%>
    <c:if test="${totalCustomerPages > 1}">
        <nav class="mb-4">
            <ul class="pagination justify-content-center pagination-sm">
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link" href="?page=${currentPage - 1}&keyword=${keyword}">
                        <i class="bi bi-chevron-left"></i>
                    </a>
                </li>
                <c:forEach begin="1" end="${totalCustomerPages}" var="p">
                    <c:if test="${p >= currentPage - 2 && p <= currentPage + 2}">
                        <li class="page-item ${p == currentPage ? 'active' : ''}">
                            <a class="page-link" href="?page=${p}&keyword=${keyword}">${p}</a>
                        </li>
                    </c:if>
                </c:forEach>
                <li class="page-item ${currentPage == totalCustomerPages ? 'disabled' : ''}">
                    <a class="page-link" href="?page=${currentPage + 1}&keyword=${keyword}">
                        <i class="bi bi-chevron-right"></i>
                    </a>
                </li>
            </ul>
        </nav>
    </c:if>
</div>

<%-- ═══════════════════════════════════════════════════════════════
     Assign Task Modal
     ══════════════════════════════════════════════════════════════ --%>
<div class="modal fade" id="assignTaskModal" tabindex="-1"
     aria-labelledby="assignTaskModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form method="post" action="${pageContext.request.contextPath}/manager/crm/assign-task"
                  id="assignTaskForm" novalidate>
                <input type="hidden" name="relatedType" id="modalRelatedType" value="">
                <input type="hidden" name="relatedId"   id="modalRelatedId"   value="">
                <input type="hidden" name="returnUrl"
                       value="${pageContext.request.contextPath}/manager/crm/pool?keyword=${keyword}&page=${currentPage}">

                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title" id="assignTaskModalLabel">
                        <i class="bi bi-plus-circle me-2"></i>Giao việc
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <c:if test="${empty salesForAssign}">
                        <div class="alert alert-warning">
                            <i class="bi bi-exclamation-triangle me-2"></i>
                            Không có nhân viên sales trong phòng ban để giao việc.
                        </div>
                    </c:if>

                    <%-- Object info card --%>
                    <div class="card border-success mb-3">
                        <div class="card-header bg-success bg-opacity-10 py-2 d-flex align-items-center gap-2">
                            <i class="bi bi-person-vcard-fill text-success"></i>
                            <span class="fw-semibold text-success">Thông tin đối tượng</span>
                            <span id="modalObjectBadge" class="ms-1"></span>
                        </div>
                        <div class="card-body py-2 px-3">
                            <div class="row g-2">
                                <div class="col-sm-6">
                                    <div class="d-flex align-items-center gap-2">
                                        <i class="bi bi-person text-muted" style="width:16px"></i>
                                        <div>
                                            <div class="text-muted" style="font-size:0.72rem">Họ tên</div>
                                            <div class="fw-semibold" id="modalObjectName"></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="d-flex align-items-center gap-2">
                                        <i class="bi bi-telephone text-muted" style="width:16px"></i>
                                        <div>
                                            <div class="text-muted" style="font-size:0.72rem">Số điện thoại</div>
                                            <div id="modalObjectPhone"></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="d-flex align-items-center gap-2">
                                        <i class="bi bi-funnel text-muted" style="width:16px"></i>
                                        <div>
                                            <div class="text-muted" style="font-size:0.72rem">Nguồn</div>
                                            <div id="modalObjectSource"></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="d-flex align-items-center gap-2">
                                        <i class="bi bi-calendar3 text-muted" style="width:16px"></i>
                                        <div>
                                            <div class="text-muted" style="font-size:0.72rem">Ngày tạo</div>
                                            <div id="modalObjectDate"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label fw-semibold">
                                Tiêu đề công việc <span class="text-danger">*</span>
                            </label>
                            <input type="text" name="title" id="modalTitle" class="form-control"
                                   placeholder="Nhập tiêu đề công việc..." required maxlength="255">
                            <div class="invalid-feedback">Vui lòng nhập tiêu đề</div>
                        </div>

                        <div class="col-12">
                            <label class="form-label fw-semibold">Mô tả</label>
                            <textarea name="description" class="form-control" rows="2"
                                      placeholder="Mô tả chi tiết công việc..."></textarea>
                        </div>

                        <div class="col-12">
                            <label class="form-label fw-semibold">Hình thức giao</label>
                            <div class="d-flex gap-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="assignType"
                                           id="assignIndividual" value="INDIVIDUAL" checked
                                           onchange="toggleAssignType(this.value)">
                                    <label class="form-check-label" for="assignIndividual">
                                        <i class="bi bi-person me-1"></i>Cá nhân
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="assignType"
                                           id="assignGroup" value="GROUP"
                                           onchange="toggleAssignType(this.value)">
                                    <label class="form-check-label" for="assignGroup">
                                        <i class="bi bi-people me-1"></i>Nhóm
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6" id="sectionIndividual">
                            <label class="form-label fw-semibold">
                                Giao cho Sales <span class="text-danger">*</span>
                            </label>
                            <select name="assignedTo" id="modalAssignedTo" class="form-select">
                                <option value="">-- Chọn nhân viên --</option>
                                <c:forEach var="u" items="${salesForAssign}">
                                    <option value="${u.userId}">${u.firstName} ${u.lastName}</option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">Vui lòng chọn nhân viên</div>
                        </div>

                        <div class="col-12 d-none" id="sectionGroup">
                            <label class="form-label fw-semibold">
                                Chọn nhóm nhân viên <span class="text-danger">*</span>
                            </label>
                            <div class="border rounded p-3" style="max-height: 200px; overflow-y: auto;">
                                <c:choose>
                                    <c:when test="${empty salesForAssign}">
                                        <span class="text-muted small">Không có nhân viên trong phòng ban</span>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="u" items="${salesForAssign}">
                                            <div class="form-check mb-1">
                                                <input class="form-check-input group-checkbox"
                                                       type="checkbox"
                                                       name="assignedToGroup"
                                                       value="${u.userId}"
                                                       id="chk_${u.userId}">
                                                <label class="form-check-label" for="chk_${u.userId}">
                                                    ${u.firstName} ${u.lastName}
                                                </label>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="text-danger small mt-1 d-none" id="groupError">
                                Vui lòng chọn ít nhất một nhân viên
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Độ ưu tiên</label>
                            <select name="priority" class="form-select">
                                <option value="LOW">Thấp</option>
                                <option value="MEDIUM" selected>Trung bình</option>
                                <option value="HIGH">Cao</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Hạn chót</label>
                            <input type="datetime-local" name="dueDate" class="form-control">
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-success" id="btnSubmitAssign">
                        <i class="bi bi-check-circle me-1"></i>Xác nhận giao việc
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function openAssignModal(relatedType, relatedId, objectName, phone, source, createdAt) {
    var form = document.getElementById('assignTaskForm');

    document.getElementById('modalRelatedType').value = relatedType;
    document.getElementById('modalRelatedId').value   = relatedId;

    var badge = document.getElementById('modalObjectBadge');
    if (relatedType === 'LEAD') {
        badge.innerHTML = '<span class="badge bg-info text-dark">Lead</span>';
    } else {
        badge.innerHTML = '<span class="badge bg-success">Khách hàng</span>';
    }

    document.getElementById('modalObjectName').textContent = objectName || '-';

    var phoneEl = document.getElementById('modalObjectPhone');
    if (phone) {
        phoneEl.innerHTML = '<a href="tel:' + phone + '" class="text-decoration-none">' + phone + '</a>';
    } else {
        phoneEl.innerHTML = '<span class="text-muted">-</span>';
    }

    var sourceEl = document.getElementById('modalObjectSource');
    sourceEl.textContent = source || '-';
    if (!source) sourceEl.classList.add('text-muted');
    else sourceEl.classList.remove('text-muted');

    var dateEl = document.getElementById('modalObjectDate');
    dateEl.textContent = createdAt || '-';
    if (!createdAt) dateEl.classList.add('text-muted');
    else dateEl.classList.remove('text-muted');

    document.getElementById('modalTitle').value = '';
    form.querySelector('[name="description"]').value = '';
    form.querySelector('[name="priority"]').value    = 'MEDIUM';
    form.querySelector('[name="dueDate"]').value     = '';

    document.getElementById('assignIndividual').checked = true;
    document.getElementById('modalAssignedTo').value = '';
    document.getElementById('sectionIndividual').classList.remove('d-none');
    document.getElementById('sectionGroup').classList.add('d-none');

    form.querySelectorAll('.group-checkbox').forEach(function(cb) { cb.checked = false; });
    document.getElementById('groupError').classList.add('d-none');

    form.classList.remove('was-validated');
    new bootstrap.Modal(document.getElementById('assignTaskModal')).show();
}

function toggleAssignType(type) {
    if (type === 'GROUP') {
        document.getElementById('sectionIndividual').classList.add('d-none');
        document.getElementById('sectionGroup').classList.remove('d-none');
        document.getElementById('modalAssignedTo').removeAttribute('required');
    } else {
        document.getElementById('sectionIndividual').classList.remove('d-none');
        document.getElementById('sectionGroup').classList.add('d-none');
        document.getElementById('modalAssignedTo').setAttribute('required', '');
        document.getElementById('groupError').classList.add('d-none');
    }
}

document.getElementById('assignTaskForm').addEventListener('submit', function(e) {
    var assignType = this.querySelector('[name="assignType"]:checked').value;

    if (assignType === 'GROUP') {
        var checked = this.querySelectorAll('.group-checkbox:checked');
        if (checked.length < 2) {
            e.preventDefault();
            e.stopPropagation();
            document.getElementById('groupError').textContent =
                checked.length === 0
                    ? 'Vui lòng chọn ít nhất 2 nhân viên'
                    : 'Giao việc nhóm cần ít nhất 2 người';
            document.getElementById('groupError').classList.remove('d-none');
            return;
        }
        document.getElementById('groupError').classList.add('d-none');
        document.getElementById('modalAssignedTo').removeAttribute('required');
    } else {
        document.getElementById('modalAssignedTo').setAttribute('required', '');
    }

    if (!this.checkValidity()) {
        e.preventDefault();
        e.stopPropagation();
    }
    this.classList.add('was-validated');
});
</script>
