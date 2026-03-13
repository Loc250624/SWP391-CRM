<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ page contentType="text/html;charset=UTF-8" %>
        <div class="container-fluid p-4">
            <div class="mb-4">
                <h4 class="fw-bold mb-0">${user != null ? 'Chỉnh sửa' : 'Thêm'} Tài khoản User</h4>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mt-2 mb-0">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard"
                                class="text-decoration-none">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/user/list"
                                class="text-decoration-none">Danh sách User</a></li>
                        <li class="breadcrumb-item active">${user != null ? 'Chỉnh sửa' : 'Thêm mới'}</li>
                    </ol>
                </nav>
            </div>

            <div class="row">
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm rounded-3">
                        <div class="card-body p-4">
                            <form action="${pageContext.request.contextPath}/admin/user/form" method="POST">
                                <c:if test="${user != null}">
                                    <input type="hidden" name="id" value="${user.userId}">
                                </c:if>

                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Họ (First Name)</label>
                                        <input type="text" name="firstName" class="form-control"
                                            value="${user.firstName}" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Tên (Last Name)</label>
                                        <input type="text" name="lastName" class="form-control" value="${user.lastName}"
                                            required>
                                    </div>
                                    <div class="col-md-12">
                                        <label class="form-label fw-semibold">Email</label>
                                        <input type="email" name="email" class="form-control" value="${user.email}"
                                            required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Mã nhân viên</label>
                                        <input type="text" name="employeeCode" class="form-control"
                                            value="${user.employeeCode}" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Số điện thoại</label>
                                        <input type="text" name="phone" class="form-control" value="${user.phone}">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Trạng thái</label>
                                        <select name="status" class="form-select">
                                            <option value="Active" ${user.status=='Active' ? 'selected' : '' }>Hoạt động
                                            </option>
                                            <option value="Inactive" ${user.status=='Inactive' ? 'selected' : '' }>Khóa
                                            </option>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Vai trò hệ thống (Role)</label>
                                        <select name="roleId" class="form-select" required>
                                            <option value="">-- Chọn vai trò --</option>
                                            <c:forEach var="role" items="${allRoles}">
                                                <option value="${role.role_id}" ${currentRoleId==role.role_id
                                                    ? 'selected' : '' }>
                                                    ${role.role_name} (${role.role_code})
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>

                                <div class="mt-4 pt-3 border-top d-flex gap-2">
                                    <button type="submit" class="btn btn-primary px-4">Lưu thay đổi</button>
                                    <a href="${pageContext.request.contextPath}/admin/user/list"
                                        class="btn btn-outline-secondary px-4">Hủy</a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm rounded-3 bg-light">
                        <div class="card-body p-4">
                            <h6 class="fw-bold mb-3">Thông tin phân quyền</h6>
                            <p class="small text-muted mb-0">
                                Việc gán vai trò (Role) xác định các chức năng mà người dùng này có thể truy cập trong
                                hệ thống CRM.
                                Mỗi vai trò được định nghĩa sẵn các quyền hạn cụ thể.
                            </p>
                            <hr>
                            <div class="d-flex align-items-center gap-2 mb-2">
                                <i class="bi bi-info-circle text-primary"></i>
                                <span class="small fw-bold">Lưu ý bảo mật:</span>
                            </div>
                            <p class="small text-muted mb-0">
                                Chỉ Admin mới có quyền gán vai trò cao cấp (Admin, Manager).
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>