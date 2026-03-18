<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ page contentType="text/html;charset=UTF-8" %>

        <!-- Reusable User Creation Modal Component -->
        <div class="modal fade" id="createUserModal" tabindex="-1" aria-labelledby="createUserModalLabel"
            aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg rounded-4">
                    <div class="modal-header border-0 pb-0 px-4 pt-4">
                        <h5 class="modal-title fw-bold fs-4" id="createUserModalLabel" style="color: #4f46e5;">
                            <i class="bi bi-person-plus-fill me-2"></i>Thêm nhân viên mới
                        </h5>
                        <button type="button" class="btn-close shadow-none" data-bs-dismiss="modal"
                            aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4">
                        <form id="createUserForm" action="${pageContext.request.contextPath}/admin/user/form"
                            method="POST">
                            <div class="row g-4">
                                <!-- Full Name -->
                                <div class="col-md-6">
                                    <label class="form-label fw-bold text-muted small text-uppercase mb-2">Họ (First
                                        Name) <span class="text-danger">*</span></label>
                                    <input type="text" name="firstName"
                                        class="form-control form-control-lg bg-light border-0 rounded-3 shadow-none px-4"
                                        placeholder="Nguyễn" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold text-muted small text-uppercase mb-2">Tên (Last
                                        Name) <span class="text-danger">*</span></label>
                                    <input type="text" name="lastName"
                                        class="form-control form-control-lg bg-light border-0 rounded-3 shadow-none px-4"
                                        placeholder="Văn A" required>
                                </div>

                                <!-- Email -->
                                <div class="col-md-12">
                                    <label class="form-label fw-bold text-muted small text-uppercase mb-2">Email Công
                                        việc <span class="text-danger">*</span></label>
                                    <input type="email" name="email"
                                        class="form-control form-control-lg bg-light border-0 rounded-3 shadow-none px-4"
                                        placeholder="nv-a@company.com" required>
                                </div>

                                <!-- Phone -->
                                <div class="col-md-12">
                                    <label class="form-label fw-bold text-muted small text-uppercase mb-2">Số điện thoại</label>
                                    <input type="text" name="phone"
                                        class="form-control form-control-lg bg-light border-0 rounded-3 shadow-none px-4"
                                        placeholder="0123 456 789">
                                </div>
                                <!-- Auto-generated employee code info -->
                                <div class="col-md-12">
                                    <div class="alert alert-info border-0 rounded-3 py-2 px-3 mb-0 d-flex align-items-center gap-2" style="background:#eef2ff;">
                                        <i class="bi bi-info-circle-fill text-primary"></i>
                                        <span class="small">Mã nhân viên sẽ được <strong>tự động sinh</strong> theo vai trò được chọn (VD: MKT001, SAL002...)</span>
                                    </div>
                                </div>

                                <!-- Role & Status -->
                                <div class="col-md-6">
                                    <label class="form-label fw-bold text-muted small text-uppercase mb-2">Vai trò
                                        (Role) <span class="text-danger">*</span></label>
                                    <select name="roleId"
                                        class="form-select form-select-lg bg-light border-0 rounded-3 shadow-none px-4"
                                        required>
                                        <option value="">-- Chọn vai trò --</option>
                                        <c:forEach var="role" items="${allRoles}">
                                            <option value="${role.role_id}">${role.role_name} (${role.role_code})
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold text-muted small text-uppercase mb-2">Trạng thái
                                        ban đầu</label>
                                    <select name="status"
                                        class="form-select form-select-lg bg-light border-0 rounded-3 shadow-none px-4">
                                        <option value="Active">Hoạt động (Active)</option>
                                        <option value="Inactive">Bị khóa (Inactive)</option>
                                    </select>
                                </div>
                            </div>

                            <div class="mt-5 d-flex gap-3">
                                <button type="submit"
                                    class="btn px-4 py-3 rounded-3 shadow-sm text-white fw-bold flex-grow-1"
                                    style="background-color: #4f46e5; border-color: #4f46e5;">
                                    <i class="bi bi-check2-circle me-2"></i> Xác nhận tạo tài khoản
                                </button>
                                <button type="button"
                                    class="btn btn-light px-4 py-3 rounded-3 border fw-semibold text-muted"
                                    data-bs-dismiss="modal">
                                    Hủy bỏ
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <style>
            #createUserForm .form-control:focus,
            #createUserForm .form-select:focus {
                background-color: #fff !important;
                box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1) !important;
                border: 1.5px solid #4f46e5 !important;
            }

            #createUserModal .modal-content {
                transition: transform 0.3s ease-out;
            }
        </style>