<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

            <div class="row justify-content-center">
                <div class="col-lg-8 col-xl-7">

                    <!-- Breadcrumb / Back Link -->
                    <div class="mb-4">
                        <a href="${pageContext.request.contextPath}/admin/category/list"
                            class="text-decoration-none text-muted small fw-medium">
                            <i class="bi bi-arrow-left me-1"></i> Quay lại danh sách
                        </a>
                    </div>

                    <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
                        <!-- Header Section -->
                        <div class="card-header border-0 p-4 py-5 text-white"
                            style="background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);">
                            <div class="d-flex align-items-center gap-3">
                                <div class="bg-white bg-opacity-20 p-3 rounded-4">
                                    <i class="bi bi-folder-plus fs-2"></i>
                                </div>
                                <div>
                                    <h3 class="fw-bold mb-1">${category == null ? 'Tạo Danh mục mới' : 'Cập nhật Danh
                                        mục'}</h3>
                                    <p class="mb-0 opacity-75 small">
                                        ${category != null ? 'Chỉnh sửa thông tin danh mục: ' : 'Vui lòng điền thông tin
                                        chi tiết cho danh mục khóa học mới'}
                                        <c:if test="${category != null}"><b
                                                class="text-white">${fn:escapeXml(category.categoryName)}</b></c:if>
                                    </p>
                                </div>
                            </div>
                        </div>

                        <div class="card-body p-4 p-md-5">

                            <!-- Error Alert Box -->
                            <c:if test="${not empty errors}">
                                <div
                                    class="alert alert-danger border-0 rounded-3 shadow-sm d-flex align-items-start gap-3 mb-4">
                                    <i class="bi bi-exclamation-octagon-fill fs-4"></i>
                                    <div>
                                        <div class="fw-bold">Vui lòng kiểm tra lại các lỗi sau:</div>
                                        <ul class="mb-0 mt-1 small">
                                            <c:forEach items="${errors}" var="e">
                                                <li>${fn:escapeXml(e)}</li>
                                            </c:forEach>
                                        </ul>
                                    </div>
                                </div>
                            </c:if>

                            <!-- Form Section -->
                            <form method="post" action="${pageContext.request.contextPath}/admin/category/form">
                                <c:if test="${category != null and category.categoryId != null}">
                                    <input type="hidden" name="id" value="${category.categoryId}" />
                                </c:if>

                                <div class="row g-4">
                                    <!-- Category Name -->
                                    <div class="col-12">
                                        <label class="form-label fw-bold text-muted small text-uppercase mb-2">Tên Danh
                                            mục <span class="text-danger">*</span></label>
                                        <input type="text" name="categoryName"
                                            class="form-control form-control-lg bg-light border-0 rounded-3 shadow-none px-4"
                                            placeholder="Ví dụ: Programming, Design, Marketing"
                                            value="${fn:escapeXml(category.categoryName)}" maxlength="200" required
                                            autofocus>
                                    </div>

                                    <!-- Category Code -->
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold text-muted small text-uppercase mb-2">Mã Danh
                                            mục <span class="text-danger">*</span></label>
                                        <input type="text" name="categoryCode"
                                            class="form-control form-control-lg bg-light border-0 rounded-3 shadow-none px-4"
                                            placeholder="Ví dụ: PROG, DESIGN"
                                            value="${fn:escapeXml(category.categoryCode)}" maxlength="50" required>
                                    </div>

                                    <!-- Status Switch -->
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold text-muted small text-uppercase mb-2">Trạng
                                            thái</label>
                                        <div
                                            class="form-control form-control-lg bg-light border-0 rounded-3 d-flex align-items-center justify-content-between px-4">
                                            <span class="small fw-medium">Công khai / Kích hoạt</span>
                                            <div class="form-check form-switch mb-0">
                                                <input class="form-check-input" type="checkbox" name="isActive"
                                                    value="1" style="width: 40px; height: 20px; cursor: pointer;" <c:if
                                                    test="${category == null or category.isActive == null or category.isActive}">checked
                                                </c:if>>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Description -->
                                    <div class="col-12">
                                        <label class="form-label fw-bold text-muted small text-uppercase mb-2">Mô tả chi
                                            tiết</label>
                                        <textarea name="description"
                                            class="form-control bg-light border-0 rounded-3 shadow-none px-4 py-3"
                                            placeholder="Mô tả tóm tắt về loại danh mục này..."
                                            style="min-height: 120px;">${fn:escapeXml(category.description)}</textarea>
                                    </div>

                                    <div class="col-12 mt-5">
                                        <div class="d-flex gap-3 pt-3 border-top">
                                            <button type="submit"
                                                class="btn btn-indigo px-5 py-3 rounded-3 shadow-sm text-white fw-bold flex-grow-1"
                                                style="background-color: #4f46e5;">
                                                <i class="bi bi-save2 me-2"></i> ${category == null ? 'Lưu Danh mục' :
                                                'Cập nhật thay đổi'}
                                            </button>
                                            <a href="${pageContext.request.contextPath}/admin/category/list"
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
                .form-control:focus {
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