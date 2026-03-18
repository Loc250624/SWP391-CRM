<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<div class="container-fluid p-4">

    <!-- ===== HEADER ===== -->
    <div class="d-flex justify-content-between align-items-start mb-4">
        <div>
            <h4 class="fw-bold mb-0">Quản lý Tài khoản (User)</h4>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mt-2 mb-0">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="text-decoration-none">Dashboard</a>
                    </li>
                    <li class="breadcrumb-item active">Danh sách User</li>
                </ol>
            </nav>
        </div>
        <c:if test="${sessionScope.role == 'ADMIN'}">
            <button type="button" class="btn btn-primary d-flex align-items-center gap-2 px-4 shadow-sm rounded-3"
                data-bs-toggle="modal" data-bs-target="#createUserModal">
                <i class="bi bi-plus-lg"></i><span>Thêm User mới</span>
            </button>
        </c:if>
    </div>

    <!-- ===== INCLUDE CREATE MODAL ===== -->
    <jsp:include page="user_modal_form.jsp" />

    <!-- ===== DELETE / DEACTIVATE MODAL ===== -->
    <div class="modal fade" id="deleteUserModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold text-danger">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>Xác nhận thao tác
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body py-3">
                    <p class="mb-2 text-muted">Thao tác với tài khoản: <strong id="deleteUserName"></strong></p>
                    <div class="alert alert-warning border-0 rounded-3 small py-2">
                        <i class="bi bi-info-circle me-1"></i>
                        <strong>Vô hiệu hóa</strong>: khóa tài khoản, dữ liệu giữ nguyên.<br>
                        <strong>Xóa hẳn</strong>: xóa hoàn toàn (không thể hoàn tác).
                    </div>
                </div>
                <div class="modal-footer border-0 pt-0 gap-2">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                    <form action="${pageContext.request.contextPath}/admin/user/delete" method="POST" class="d-inline">
                        <input type="hidden" name="id"     id="deactivateUserId">
                        <input type="hidden" name="action" value="deactivate">
                        <button type="submit" class="btn btn-warning text-white">
                            <i class="bi bi-lock me-1"></i>Vô hiệu hóa
                        </button>
                    </form>
                    <form action="${pageContext.request.contextPath}/admin/user/delete" method="POST" class="d-inline">
                        <input type="hidden" name="id"     id="deleteUserId">
                        <input type="hidden" name="action" value="delete">
                        <button type="submit" class="btn btn-danger">
                            <i class="bi bi-trash me-1"></i>Xóa hẳn
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Hidden reactivate form -->
    <form id="reactivateForm" action="${pageContext.request.contextPath}/admin/user/delete" method="POST" class="d-none">
        <input type="hidden" name="id"     id="reactivateUserId">
        <input type="hidden" name="action" value="reactivate">
    </form>

    <!-- ===== FILTER BAR ===== -->
    <div class="card border-0 shadow-sm rounded-3 mb-3">
        <div class="card-body py-3 px-4">
            <form method="GET" action="${pageContext.request.contextPath}/admin/user/list"
                  class="row g-2 align-items-end" id="filterForm">
                <!-- Search -->
                <div class="col-12 col-md-5">
                    <label class="form-label small fw-semibold text-muted mb-1">Tìm kiếm</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0">
                            <i class="bi bi-search text-muted"></i>
                        </span>
                        <input type="text" name="search" class="form-control border-start-0 bg-light"
                            placeholder="Tên, email, mã NV..."
                            value="${search}">
                    </div>
                </div>
                <!-- Role filter -->
                <div class="col-6 col-md-3">
                    <label class="form-label small fw-semibold text-muted mb-1">Vai trò</label>
                    <select name="roleCode" class="form-select bg-light">
                        <option value="">-- Tất cả vai trò --</option>
                        <c:forEach var="r" items="${allRoles}">
                            <option value="${r.role_code}"
                                <c:if test="${filterRole == r.role_code}">selected</c:if>>
                                ${r.role_name}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <!-- Status filter -->
                <div class="col-6 col-md-2">
                    <label class="form-label small fw-semibold text-muted mb-1">Trạng thái</label>
                    <select name="status" class="form-select bg-light">
                        <option value="">-- Tất cả --</option>
                        <option value="Active"   <c:if test="${filterStatus == 'Active'}">selected</c:if>>Hoạt động</option>
                        <option value="Inactive" <c:if test="${filterStatus == 'Inactive'}">selected</c:if>>Bị khóa</option>
                    </select>
                </div>
                <!-- Buttons -->
                <div class="col-12 col-md-2 d-flex gap-2">
                    <button type="submit" class="btn btn-primary flex-grow-1">
                        <i class="bi bi-funnel me-1"></i>Lọc
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/user/list" class="btn btn-outline-secondary" title="Xóa bộ lọc">
                        <i class="bi bi-x-lg"></i>
                    </a>
                </div>
            </form>
        </div>
    </div>

    <!-- Result count -->
    <div class="d-flex justify-content-between align-items-center mb-2 px-1">
        <small class="text-muted">
            Hiển thị <strong>${fn:length(userList)}</strong> / <strong>${totalUsers}</strong> người dùng
        </small>
        <small class="text-muted">Trang ${currentPage} / ${totalPages}</small>
    </div>

    <!-- ===== TABLE ===== -->
    <div class="card border-0 shadow-sm rounded-3">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="bg-light text-muted">
                        <tr>
                            <th class="ps-4 py-3">ID</th>
                            <th class="py-3">Họ và Tên</th>
                            <th class="py-3">Email</th>
                            <th class="py-3">Mã NV</th>
                            <th class="py-3">Vai trò</th>
                            <th class="py-3">Trạng thái</th>
                            <th class="py-3 text-end pe-4">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${userList}">
                            <tr>
                                <td class="ps-4 text-muted small">${u.userId}</td>
                                <td>
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="rounded-circle bg-light d-flex align-items-center justify-content-center overflow-hidden"
                                            style="width:36px;height:36px;flex-shrink:0;">
                                            <c:choose>
                                                <c:when test="${not empty u.avatarUrl}">
                                                    <img src="${u.avatarUrl}" alt="Avatar" class="w-100 h-100 object-fit-cover">
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="bi bi-person text-secondary"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <span class="fw-semibold text-dark">${u.firstName} ${u.lastName}</span>
                                    </div>
                                </td>
                                <td class="text-muted small">${u.email}</td>
                                <td><span class="badge bg-light text-dark border fw-semibold">${u.employeeCode}</span></td>
                                <td>
                                    <span class="badge bg-info-subtle text-info px-2 border border-info-subtle">
                                        ${u.roleName != null ? u.roleName : 'N/A'}
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${u.status == 'Active'}">
                                            <span class="badge bg-success-subtle text-success px-3">Hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger-subtle text-danger px-3">Bị khóa</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-end pe-4">
                                    <div class="dropdown">
                                        <button class="btn btn-link link-secondary p-0" type="button"
                                            data-bs-toggle="dropdown" aria-expanded="false">
                                            <i class="bi bi-three-dots-vertical fs-5"></i>
                                        </button>
                                        <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 rounded-3">
                                            <li>
                                                <a class="dropdown-item py-2"
                                                    href="${pageContext.request.contextPath}/admin/user/form?id=${u.userId}">
                                                    <i class="bi bi-pencil-square me-2 text-primary"></i>Xem / Chỉnh sửa
                                                </a>
                                            </li>
                                            <c:if test="${sessionScope.role == 'ADMIN'}">
                                                <li><hr class="dropdown-divider my-1"></li>
                                                <c:choose>
                                                    <c:when test="${u.status == 'Active'}">
                                                        <li>
                                                            <a class="dropdown-item py-2 text-warning" href="#"
                                                                data-user-id="${u.userId}"
                                                                data-user-name="${u.firstName} ${u.lastName}"
                                                                onclick="openDeleteModal(this); return false;">
                                                                <i class="bi bi-lock me-2"></i>Vô hiệu hóa / Xóa
                                                            </a>
                                                        </li>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <li>
                                                            <a class="dropdown-item py-2 text-success" href="#"
                                                                data-user-id="${u.userId}"
                                                                onclick="reactivateUser(this); return false;">
                                                                <i class="bi bi-unlock me-2"></i>Kích hoạt lại
                                                            </a>
                                                        </li>
                                                        <li>
                                                            <a class="dropdown-item py-2 text-danger" href="#"
                                                                data-user-id="${u.userId}"
                                                                data-user-name="${u.firstName} ${u.lastName}"
                                                                onclick="openDeleteModal(this); return false;">
                                                                <i class="bi bi-trash me-2"></i>Xóa hẳn
                                                            </a>
                                                        </li>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:if>
                                        </ul>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty userList}">
                            <tr>
                                <td colspan="7" class="text-center py-5 text-muted">
                                    <i class="bi bi-people fs-2 d-block mb-2 opacity-50"></i>
                                    Không tìm thấy người dùng nào.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- ===== PAGINATION ===== -->
    <c:if test="${totalPages > 1}">
        <nav class="mt-4 d-flex justify-content-center" aria-label="Phân trang">
            <ul class="pagination pagination-sm mb-0" style="gap: 4px;">
                <!-- Prev -->
                <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                    <a class="page-link rounded-2 border-0 shadow-sm"
                        href="${pageContext.request.contextPath}/admin/user/list?page=${currentPage - 1}&search=${search}&roleCode=${filterRole}&status=${filterStatus}">
                        <i class="bi bi-chevron-left"></i>
                    </a>
                </li>

                <!-- Page numbers -->
                <c:forEach var="i" begin="1" end="${totalPages}">
                    <c:choose>
                        <c:when test="${i == currentPage}">
                            <li class="page-item active">
                                <span class="page-link rounded-2 border-0"
                                    style="background:#4f46e5;">${i}</span>
                            </li>
                        </c:when>
                        <c:when test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                            <li class="page-item">
                                <a class="page-link rounded-2 border-0 shadow-sm"
                                    href="${pageContext.request.contextPath}/admin/user/list?page=${i}&search=${search}&roleCode=${filterRole}&status=${filterStatus}">
                                    ${i}
                                </a>
                            </li>
                        </c:when>
                        <c:when test="${i == currentPage - 3 || i == currentPage + 3}">
                            <li class="page-item disabled">
                                <span class="page-link border-0 bg-transparent">...</span>
                            </li>
                        </c:when>
                    </c:choose>
                </c:forEach>

                <!-- Next -->
                <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                    <a class="page-link rounded-2 border-0 shadow-sm"
                        href="${pageContext.request.contextPath}/admin/user/list?page=${currentPage + 1}&search=${search}&roleCode=${filterRole}&status=${filterStatus}">
                        <i class="bi bi-chevron-right"></i>
                    </a>
                </li>
            </ul>
        </nav>
    </c:if>

</div>

<style>
    .pagination .page-link {
        color: #4f46e5;
        padding: 6px 12px;
        transition: all 0.2s;
    }
    .pagination .page-link:hover {
        background: #eef2ff;
    }
    .pagination .page-item.active .page-link {
        color: #fff;
    }
</style>

<script>
    function openDeleteModal(el) {
        document.getElementById('deleteUserName').textContent = el.getAttribute('data-user-name');
        document.getElementById('deactivateUserId').value    = el.getAttribute('data-user-id');
        document.getElementById('deleteUserId').value        = el.getAttribute('data-user-id');
        new bootstrap.Modal(document.getElementById('deleteUserModal')).show();
    }

    function reactivateUser(el) {
        if (confirm('Bạn có chắc muốn kích hoạt lại tài khoản này?')) {
            document.getElementById('reactivateUserId').value = el.getAttribute('data-user-id');
            document.getElementById('reactivateForm').submit();
        }
    }
</script>