<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ page contentType="text/html;charset=UTF-8" %>
        <div class="container-fluid p-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h4 class="fw-bold mb-0">Quản lý Tài khoản (User)</h4>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mt-2 mb-0">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard"
                                    class="text-decoration-none">Dashboard</a></li>
                            <li class="breadcrumb-item active">Danh sách User</li>
                        </ol>
                    </nav>
                </div>
                <c:if test="${sessionScope.role == 'ADMIN'}">
                    <button type="button"
                        class="btn btn-primary d-flex align-items-center gap-2 px-4 shadow-sm rounded-3"
                        data-bs-toggle="modal" data-bs-target="#createUserModal">
                        <i class="bi bi-plus-lg"></i>
                        <span>Thêm User mới</span>
                    </button>
                </c:if>
            </div>

            <!-- Include User Creation Modal -->
            <jsp:include page="user_modal_form.jsp" />

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
                                        <td class="ps-4">${u.userId}</td>
                                        <td>
                                            <div class="d-flex align-items-center gap-3">
                                                <div class="rounded-circle bg-light d-flex align-items-center justify-content-center overflow-hidden"
                                                    style="width: 35px; height: 35px;">
                                                    <c:if test="${not empty u.avatarUrl}">
                                                        <img src="${u.avatarUrl}" alt="Avatar"
                                                            class="w-100 h-100 object-fit-cover">
                                                    </c:if>
                                                    <c:if test="${empty u.avatarUrl}">
                                                        <i class="bi bi-person text-secondary"></i>
                                                    </c:if>
                                                </div>
                                                <span class="fw-semibold text-dark">${u.firstName} ${u.lastName}</span>
                                            </div>
                                        </td>
                                        <td>${u.email}</td>
                                        <td><span class="badge bg-light text-dark border">${u.employeeCode}</span></td>
                                        <td>
                                            <span class="badge bg-info-subtle text-info px-2 border border-info-subtle">
                                                ${u.roleName != null ? u.roleName : 'N/A'}
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${u.status == 'Active'}">
                                                    <span class="badge bg-success-subtle text-success px-3">Hoạt
                                                        động</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger-subtle text-danger px-3">Bị khóa</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end pe-4">
                                            <div class="dropdown">
                                                <button class="btn btn-link link-secondary p-0" type="button"
                                                    data-bs-toggle="dropdown">
                                                    <i class="bi bi-three-dots-vertical fs-5"></i>
                                                </button>
                                                <ul class="dropdown-menu dropdown-menu-end shadow-sm">
                                                    <li><a class="dropdown-item py-2"
                                                            href="${pageContext.request.contextPath}/admin/user/detail?id=${u.userId}"><i
                                                                class="bi bi-eye me-2"></i>Xem chi tiết</a></li>
                                                    <c:if test="${sessionScope.role == 'ADMIN'}">
                                                        <li><a class="dropdown-item py-2"
                                                                href="${pageContext.request.contextPath}/admin/user/form?id=${u.userId}"><i
                                                                    class="bi bi-pencil me-2"></i>Chỉnh sửa</a></li>
                                                        <li>
                                                            <hr class="dropdown-divider">
                                                        </li>
                                                        <li><a class="dropdown-item py-2 text-danger" href="#"
                                                                onclick="confirmDelete('${u.userId}')"><i
                                                                    class="bi bi-trash me-2"></i>Xóa / Vô hiệu hóa</a>
                                                        </li>
                                                    </c:if>
                                                </ul>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function confirmDelete(id) {
                if (confirm('Bạn có chắc chắn muốn vô hiệu hóa người dùng này?')) {
                    // Handle delete
                }
            }
        </script>