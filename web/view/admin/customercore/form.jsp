<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

            <div class="row justify-content-center">
                <div class="col-lg-10 col-xl-8">

                    <!-- Action Header -->
                    <div class="d-flex align-items-center justify-content-between mb-4">
                        <div>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb mb-1">
                                    <li class="breadcrumb-item"><a
                                            href="${pageContext.request.contextPath}/admin/customer/list"
                                            class="text-decoration-none text-muted small">Khách hàng</a></li>
                                    <li class="breadcrumb-item active small text-muted">${customer == null ? 'Thêm mới'
                                        : 'Chỉnh sửa'}</li>
                                </ol>
                            </nav>
                            <h2 class="fw-bold mb-0">${customer == null ? 'Thêm Khách hàng mới' : 'Cập nhật thông tin'}
                            </h2>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/customer/list"
                            class="btn btn-light border px-4 rounded-3 shadow-sm bg-white fw-medium">
                            <i class="bi bi-arrow-left me-2"></i>Quay lại
                        </a>
                    </div>

                    <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
                        <div class="card-body p-4 p-md-5">

                            <!-- Error Alert Box -->
                            <c:if test="${not empty errors}">
                                <div
                                    class="alert alert-danger border-0 rounded-3 shadow-sm d-flex align-items-start gap-3 mb-4">
                                    <i class="bi bi-exclamation-octagon-fill fs-4"></i>
                                    <div>
                                        <div class="fw-bold">Vui lòng kiểm tra lại:</div>
                                        <ul class="mb-0 mt-1 small">
                                            <c:forEach items="${errors}" var="e">
                                                <li>${fn:escapeXml(e)}</li>
                                            </c:forEach>
                                        </ul>
                                    </div>
                                </div>
                            </c:if>

                            <form method="post" action="${pageContext.request.contextPath}/admin/customer/form">
                                <c:if test="${customer != null and customer.customerId != null}">
                                    <input type="hidden" name="id" value="${customer.customerId}" />
                                </c:if>

                                <div class="row g-4">
                                    <!-- Full Name -->
                                    <div class="col-md-12">
                                        <label class="form-label fw-bold text-muted small text-uppercase mb-2">Họ và tên
                                            <span class="text-danger">*</span></label>
                                        <input type="text" name="fullName"
                                            class="form-control form-control-lg bg-light border-0 rounded-3 shadow-none px-4"
                                            placeholder="Nguyễn Văn A" value="${fn:escapeXml(customer.fullName)}"
                                            required>
                                    </div>

                                    <!-- Email & Phone -->
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold text-muted small text-uppercase mb-2">Email
                                            <span class="text-danger">*</span></label>
                                        <input type="email" name="email"
                                            class="form-control form-control-lg bg-light border-0 rounded-3 shadow-none px-4"
                                            placeholder="example@email.com" value="${fn:escapeXml(customer.email)}"
                                            required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold text-muted small text-uppercase mb-2">Số điện
                                            thoại <span class="text-danger">*</span></label>
                                        <input type="text" name="phone"
                                            class="form-control form-control-lg bg-light border-0 rounded-3 shadow-none px-4"
                                            placeholder="0123 456 789" value="${fn:escapeXml(customer.phone)}" required>
                                    </div>

                                    <!-- Status & Segment -->
                                    <div class="col-md-12">
                                        <label class="form-label fw-bold text-muted small text-uppercase mb-2">Trạng
                                            thái</label>
                                        <select name="status"
                                            class="form-select form-select-lg bg-light border-0 rounded-3 shadow-none px-4">
                                            <option value="Active" ${customer.status=='Active' ? 'selected' : '' }>Kích
                                                hoạt (Active)</option>
                                            <option value="Inactive" ${customer.status=='Inactive' ? 'selected' : '' }>
                                                Vô hiệu (Inactive)</option>
                                        </select>
                                    </div>

                                    <!-- City -->
                                    <div class="col-md-12">
                                        <label class="form-label fw-bold text-muted small text-uppercase mb-2">Thành phố
                                            / Địa chỉ</label>
                                        <input type="text" name="city"
                                            class="form-control form-control-lg bg-light border-0 rounded-3 shadow-none px-4"
                                            placeholder="Hà Nội, TP.HCM..." value="${fn:escapeXml(customer.city)}">
                                    </div>

                                    <div class="col-12 mt-5">
                                        <div class="d-flex gap-3 pt-4 border-top">
                                            <button type="submit"
                                                class="btn btn-indigo px-5 py-3 rounded-3 shadow-sm text-white fw-bold flex-grow-1"
                                                style="background-color: #4f46e5; border-color: #4f46e5;">
                                                <i class="bi bi-cloud-arrow-up-fill me-2"></i> ${customer == null ? 'Tạo
                                                tài khoản' : 'Lưu thông tin hồ sơ'}
                                            </button>
                                            <a href="${pageContext.request.contextPath}/admin/customer/list"
                                                class="btn btn-light px-5 py-3 rounded-3 border fw-semibold text-muted">
                                                Hủy bỏ
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </form>

                        </div>
                    </div>
                </div>
            </div>

            <style>
                .form-control:focus,
                .form-select:focus {
                    background-color: #fff !important;
                    box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1) !important;
                    border: 1.5px solid #4f46e5 !important;
                }

                .btn-indigo:hover {
                    opacity: 0.9;
                    transform: translateY(-1px);
                }

                .form-check-input:checked {
                    background-color: #4f46e5;
                    border-color: #4f46e5;
                }
            </style>