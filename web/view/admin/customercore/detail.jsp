<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

            <div class="row justify-content-center">
                <div class="col-lg-10 col-xl-8">

                    <!-- Action Header -->
                    <div class="d-flex align-items-center justify-content-between mb-4 mt-2">
                        <div>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb mb-1">
                                    <li class="breadcrumb-item"><a
                                            href="${pageContext.request.contextPath}/admin/customer/list"
                                            class="text-decoration-none text-muted">Khách hàng</a></li>
                                    <li class="breadcrumb-item active">Chi tiết</li>
                                </ol>
                            </nav>
                            <h2 class="fw-bold mb-0">Hồ sơ khách hàng</h2>
                        </div>
                        <div class="d-flex gap-2">
                            <a class="btn btn-light border px-4 rounded-3 shadow-sm bg-white"
                                href="${pageContext.request.contextPath}/admin/customer/list">
                                <i class="bi bi-arrow-left me-2"></i>Quay lại
                            </a>
                            <a class="btn btn-indigo px-4 rounded-3 shadow-sm text-white"
                                style="background-color: #4f46e5; border-color: #4f46e5;"
                                href="${pageContext.request.contextPath}/admin/customer/form?id=${customer.customerId}">
                                <i class="bi bi-pencil-square me-2"></i>Chỉnh sửa
                            </a>
                        </div>
                    </div>

                    <!-- Main Info Card -->
                    <div class="card border-0 shadow-lg rounded-4 overflow-hidden mb-4">
                        <div class="card-header border-0 bg-indigo bg-opacity-10 p-4"
                            style="border-bottom: 1px solid rgba(79, 70, 229, 0.1) !important;">
                            <div class="d-flex align-items-center gap-4">
                                <div class="bg-indigo text-white rounded-circle d-flex align-items-center justify-content-center fs-2 fw-bold shadow-sm"
                                    style="width: 80px; height: 80px; background-color: #4f46e5 !important;">
                                    ${fn:substring(customer.fullName, 0, 1)}
                                </div>
                                <div>
                                    <h3 class="fw-bold text-dark mb-1">${fn:escapeXml(customer.fullName)}</h3>
                                    <div class="d-flex align-items-center gap-3">
                                        <span
                                            class="badge rounded-pill bg-success-subtle text-success border border-success px-3 py-2">
                                            <i class="bi bi-shield-check me-1"></i> ${customer.status}
                                        </span>
                                        <span class="text-muted small"><i class="bi bi-geo-alt me-1"></i> ${not empty
                                            customer.city ? customer.city : 'Chưa cập nhật địa chỉ'}</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="card-body p-4 p-md-5">
                            <div class="row g-5">
                                <!-- Left Column: Personal Data -->
                                <div class="col-md-6">
                                    <h5 class="fw-bold text-indigo mb-4" style="color: #4f46e5;"><i
                                            class="bi bi-person-lines-fill me-2"></i>Thông tin liên hệ</h5>

                                    <div class="mb-4">
                                        <label class="text-uppercase small fw-bold text-muted mb-1 d-block"
                                            style="letter-spacing: 0.5px;">Email</label>
                                        <div class="bg-light p-3 rounded-3 border-0 d-flex align-items-center gap-3">
                                            <i class="bi bi-envelope text-indigo"></i>
                                            <span class="fw-medium">${fn:escapeXml(customer.email)}</span>
                                        </div>
                                    </div>

                                    <div class="mb-4">
                                        <label class="text-uppercase small fw-bold text-muted mb-1 d-block"
                                            style="letter-spacing: 0.5px;">Số điện thoại</label>
                                        <div class="bg-light p-3 rounded-3 border-0 d-flex align-items-center gap-3">
                                            <i class="bi bi-phone text-indigo"></i>
                                            <span class="fw-medium">${fn:escapeXml(customer.phone)}</span>
                                        </div>
                                    </div>
                                </div>

                                <!-- Right Column: System Data -->
                                <div class="col-md-6">
                                    <h5 class="fw-bold text-indigo mb-4" style="color: #4f46e5;"><i
                                            class="bi bi-database-fill-gear me-2"></i>Phân loại & Thẻ</h5>

                                    <div class="mb-4">
                                        <label class="text-uppercase small fw-bold text-muted mb-1 d-block"
                                            style="letter-spacing: 0.5px;">Phân khúc khách hàng</label>
                                        <div class="bg-light p-3 rounded-3 border-0 d-flex align-items-center gap-3">
                                            <i class="bi bi-bar-chart-steps text-indigo"></i>
                                            <span
                                                class="badge bg-white text-dark shadow-sm px-3 py-2 border rounded-pill">${not
                                                empty customer.customerSegment ? customer.customerSegment :
                                                'GUEST'}</span>
                                        </div>
                                    </div>

                                    <div class="mb-4">
                                        <label class="text-uppercase small fw-bold text-muted mb-1 d-block"
                                            style="letter-spacing: 0.5px;">Danh sách thẻ (Tags)</label>
                                        <div class="d-flex flex-wrap gap-2 mt-2">
                                            <c:if test="${empty tags}">
                                                <span class="text-muted italic small">Chưa có thẻ nào được gắn</span>
                                            </c:if>
                                            <c:forEach items="${tags}" var="t">
                                                <span
                                                    class="badge rounded-pill bg-white text-dark shadow-sm px-3 py-2 border">
                                                    <i class="bi bi-tag-fill text-indigo me-1"></i>
                                                    ${fn:escapeXml(t.tagName)}
                                                </span>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="card-footer bg-light p-4 text-center border-0">
                            <span class="text-muted small">Hồ sơ này được cập nhật vào lúc ${customer.createdAt != null
                                ? customer.createdAt : '---'}</span>
                        </div>
                    </div>
                </div>
            </div>

            <style>
                .text-indigo {
                    color: #4f46e5 !important;
                }

                .bg-indigo {
                    background-color: #4f46e5 !important;
                }
            </style>