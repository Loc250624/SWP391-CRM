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
            <h3 class="mb-1"><i class="bi bi-people-fill me-2 text-success"></i>Khách hàng chưa được giao (CRM)</h3>
            <p class="text-muted mb-0">Danh sách Khách hàng chưa có Sales phụ trách. Sau khi giao việc, KH sẽ chuyển sang quản lý task.</p>
        </div>
        <a href="${pageContext.request.contextPath}/manager/crm/leads" class="btn btn-outline-secondary">
            <i class="bi bi-person-lines-fill me-1"></i>Xem Lead
        </a>
    </div>

    <%-- Filters --%>
    <div class="card mb-4 shadow-sm">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/manager/crm/customers" class="row g-2 align-items-end">
                <div class="col-md-5">
                    <label class="form-label fw-semibold small">Tìm kiếm</label>
                    <input type="text" name="keyword" class="form-control" placeholder="Tên, mã, SĐT, email..." value="${keyword}">
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-semibold small">Trạng thái KH</label>
                    <select name="status" class="form-select">
                        <option value="">-- Tất cả --</option>
                        <option value="Active"    ${statusFilter == 'Active'    ? 'selected' : ''}>Active</option>
                        <option value="Inactive"  ${statusFilter == 'Inactive'  ? 'selected' : ''}>Inactive</option>
                        <option value="Churned"   ${statusFilter == 'Churned'   ? 'selected' : ''}>Churned</option>
                        <option value="Suspended" ${statusFilter == 'Suspended' ? 'selected' : ''}>Suspended</option>
                    </select>
                </div>
                <div class="col-md-4 d-flex gap-2 align-items-end">
                    <button type="submit" class="btn btn-primary flex-fill"><i class="bi bi-search me-1"></i>Lọc</button>
                    <a href="${pageContext.request.contextPath}/manager/crm/customers" class="btn btn-outline-secondary" title="Xóa bộ lọc">
                        <i class="bi bi-arrow-counterclockwise"></i>
                    </a>
                </div>
            </form>
        </div>
    </div>

    <%-- Summary --%>
    <div class="d-flex justify-content-between align-items-center mb-3">
        <span class="text-muted small">Tìm thấy <strong>${totalCustomers}</strong> khách hàng chưa được giao</span>
        <span class="text-muted small">Trang ${currentPage}/${totalPages}</span>
    </div>

    <%-- Table --%>
    <div class="card shadow-sm">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th>Mã KH</th>
                        <th>Họ tên</th>
                        <th>SĐT</th>
                        <th>Email</th>
                        <th>Phân khúc</th>
                        <th>Trạng thái</th>
                        <th>Ngày tạo</th>
                        <th class="text-center">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty customers}">
                            <tr>
                                <td colspan="8" class="text-center py-5 text-muted">
                                    <i class="bi bi-inbox fs-3 d-block mb-2"></i>Không có Khách hàng nào chưa được giao
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="cust" items="${customers}">
                                <tr>
                                    <td><span class="badge bg-light text-dark border">${cust.customerCode}</span></td>
                                    <td>
                                        <div class="fw-semibold">${cust.fullName}</div>
                                        <c:if test="${not empty cust.city}">
                                            <small class="text-muted"><i class="bi bi-geo-alt"></i> ${cust.city}</small>
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty cust.phone}">${cust.phone}</c:when>
                                            <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty cust.email}"><small>${cust.email}</small></c:when>
                                            <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty cust.customerSegment}">
                                                <span class="badge
                                                    ${cust.customerSegment == 'VIP'      ? 'bg-warning text-dark' :
                                                      cust.customerSegment == 'Premium'  ? 'bg-primary' :
                                                      cust.customerSegment == 'Standard' ? 'bg-info text-dark' :
                                                      'bg-secondary'}">
                                                    ${cust.customerSegment}
                                                </span>
                                            </c:when>
                                            <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty cust.status}">
                                                <span class="badge
                                                    ${cust.status == 'Active'    ? 'bg-success' :
                                                      cust.status == 'Inactive'  ? 'bg-secondary' :
                                                      cust.status == 'Churned'   ? 'bg-danger' :
                                                      'bg-warning text-dark'}">
                                                    ${cust.status}
                                                </span>
                                            </c:when>
                                            <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:if test="${cust.createdAt != null}">
                                            <small>${fn:substring(cust.createdAt.toString(), 8, 10)}/${fn:substring(cust.createdAt.toString(), 5, 7)}/${fn:substring(cust.createdAt.toString(), 0, 4)}</small>
                                        </c:if>
                                    </td>
                                    <td class="text-center">
                                        <div class="d-flex gap-1 justify-content-center">
                                            <a href="${pageContext.request.contextPath}/customersuccess/customer/detail?id=${cust.customerId}"
                                               class="btn btn-sm btn-outline-secondary" title="Xem chi tiết" target="_blank">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                            <button type="button"
                                                    class="btn btn-sm btn-success"
                                                    title="Giao việc cho Khách hàng này"
                                                    onclick="openAssignModal('CUSTOMER', ${cust.customerId}, '${fn:escapeXml(cust.fullName)}')">
                                                <i class="bi bi-plus-circle me-1"></i>Giao việc
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <%-- Pagination --%>
    <c:if test="${totalPages > 1}">
        <nav class="mt-4">
            <ul class="pagination justify-content-center">
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link" href="?page=${currentPage - 1}&keyword=${keyword}&status=${statusFilter}">
                        <i class="bi bi-chevron-left"></i>
                    </a>
                </li>
                <c:forEach begin="1" end="${totalPages}" var="p">
                    <c:if test="${p >= currentPage - 2 && p <= currentPage + 2}">
                        <li class="page-item ${p == currentPage ? 'active' : ''}">
                            <a class="page-link" href="?page=${p}&keyword=${keyword}&status=${statusFilter}">${p}</a>
                        </li>
                    </c:if>
                </c:forEach>
                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="?page=${currentPage + 1}&keyword=${keyword}&status=${statusFilter}">
                        <i class="bi bi-chevron-right"></i>
                    </a>
                </li>
            </ul>
        </nav>
    </c:if>
</div>

<%-- Assign Task Modal --%>
<div class="modal fade" id="assignTaskModal" tabindex="-1" aria-labelledby="assignTaskModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form method="post" action="${pageContext.request.contextPath}/manager/crm/assign-task"
                  id="assignTaskForm" novalidate>
                <input type="hidden" name="relatedType" id="modalRelatedType" value="">
                <input type="hidden" name="relatedId"   id="modalRelatedId"   value="">
                <input type="hidden" name="returnUrl"
                       value="${pageContext.request.contextPath}/manager/crm/customers?keyword=${keyword}&status=${statusFilter}&page=${currentPage}">

                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title" id="assignTaskModalLabel">
                        <i class="bi bi-plus-circle me-2"></i>Giao việc cho Khách hàng
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <div class="alert alert-success d-flex align-items-center gap-2 py-2 mb-3">
                        <i class="bi bi-person-check-fill"></i>
                        <span>Khách hàng: <strong id="modalObjectName"></strong></span>
                    </div>

                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label fw-semibold">Tiêu đề công việc <span class="text-danger">*</span></label>
                            <input type="text" name="title" id="modalTitle" class="form-control"
                                   placeholder="Nhập tiêu đề công việc..." required maxlength="255">
                            <div class="invalid-feedback">Vui lòng nhập tiêu đề</div>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">Mô tả</label>
                            <textarea name="description" class="form-control" rows="3"
                                      placeholder="Mô tả chi tiết công việc..."></textarea>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Giao cho Sales <span class="text-danger">*</span></label>
                            <select name="assignedTo" id="modalAssignedTo" class="form-select" required>
                                <option value="">-- Chọn nhân viên --</option>
                                <c:forEach var="u" items="${salesForAssign}">
                                    <option value="${u.userId}">${u.firstName} ${u.lastName}</option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">Vui lòng chọn nhân viên</div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold">Độ ưu tiên</label>
                            <select name="priority" class="form-select">
                                <option value="LOW">Thấp</option>
                                <option value="MEDIUM" selected>Trung bình</option>
                                <option value="HIGH">Cao</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold">Hạn chót</label>
                            <input type="datetime-local" name="dueDate" class="form-control">
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-success">
                        <i class="bi bi-check-circle me-1"></i>Xác nhận giao việc
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function openAssignModal(relatedType, relatedId, objectName) {
    var form = document.getElementById('assignTaskForm');
    document.getElementById('modalRelatedType').value = relatedType;
    document.getElementById('modalRelatedId').value   = relatedId;
    document.getElementById('modalObjectName').textContent = objectName;
    document.getElementById('modalTitle').value       = '';
    form.querySelector('[name="description"]').value  = '';
    document.getElementById('modalAssignedTo').value  = '';
    form.querySelector('[name="priority"]').value     = 'MEDIUM';
    form.querySelector('[name="dueDate"]').value      = '';
    form.classList.remove('was-validated');
    new bootstrap.Modal(document.getElementById('assignTaskModal')).show();
}

document.getElementById('assignTaskForm').addEventListener('submit', function(e) {
    if (!this.checkValidity()) {
        e.preventDefault();
        e.stopPropagation();
    }
    this.classList.add('was-validated');
});
</script>
