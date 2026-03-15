<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

                <div class="container-fluid px-4 py-3">
                    <!-- Header Section -->
                    <div class="d-flex align-items-center justify-content-between mb-4">
                        <div>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb mb-1">
                                    <li class="breadcrumb-item"><a
                                            href="${pageContext.request.contextPath}/admin/customer/list"
                                            class="text-decoration-none">Khách hàng</a></li>
                                    <li class="breadcrumb-item active">Customer 360</li>
                                </ol>
                            </nav>
                            <h2 class="fw-bold mb-0">Customer 360: ${fn:escapeXml(customer.fullName)}</h2>
                        </div>
                        <div class="d-flex gap-2">
                            <a class="btn btn-outline-secondary px-4 rounded-3"
                                href="${pageContext.request.contextPath}/admin/customer/list">
                                <i class="bi bi-arrow-left me-2"></i>Danh sách
                            </a>
                            <a class="btn btn-primary px-4 rounded-3 shadow-sm"
                                href="${pageContext.request.contextPath}/admin/customer/form?id=${customer.customerId}">
                                <i class="bi bi-pencil-square me-2"></i>Chỉnh sửa hồ sơ
                            </a>
                        </div>
                    </div>

                    <!-- 360 Navigation Tabs -->
                    <div class="card border-0 shadow-sm rounded-4 mb-4">
                        <div class="card-header bg-white border-0 pt-3 px-4">
                            <ul class="nav nav-pills nav-fill gap-2 p-1 bg-light rounded-3" id="pills-tab"
                                role="tablist">
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link active rounded-3 fw-semibold py-2" id="pills-profile-tab"
                                        data-bs-toggle="pill" data-bs-target="#pills-profile" type="button" role="tab">
                                        <i class="bi bi-person-badge me-2"></i>Hồ sơ chính
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link rounded-3 fw-semibold py-2" id="pills-history-tab"
                                        data-bs-toggle="pill" data-bs-target="#pills-history" type="button" role="tab">
                                        <i class="bi bi-chat-left-dots me-2"></i>Lịch sử chăm sóc
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link rounded-3 fw-semibold py-2" id="pills-enrollments-tab"
                                        data-bs-toggle="pill" data-bs-target="#pills-enrollments" type="button"
                                        role="tab">
                                        <i class="bi bi-book me-2"></i>Khóa học đã mua
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link rounded-3 fw-semibold py-2" id="pills-logs-tab"
                                        data-bs-toggle="pill" data-bs-target="#pills-logs" type="button" role="tab">
                                        <i class="bi bi-clock-history me-2"></i>Nhật ký hệ thống
                                    </button>
                                </li>
                            </ul>
                        </div>

                        <div class="card-body p-4">
                            <div class="tab-content" id="pills-tabContent">

                                <!-- Tab 1: Profile -->
                                <div class="tab-pane fade show active" id="pills-profile" role="tabpanel">
                                    <div class="row g-4">
                                        <div class="col-md-6">
                                            <h6 class="text-uppercase text-muted fw-bold mb-3 small"
                                                style="letter-spacing: 1px;">Thông tin cá nhân</h6>
                                            <div class="list-group list-group-flush border rounded-3 overflow-hidden">
                                                <div
                                                    class="list-group-item d-flex justify-content-between align-items-center py-3">
                                                    <span class="text-muted"><i
                                                            class="bi bi-envelope me-2"></i>Email</span>
                                                    <span class="fw-bold">${fn:escapeXml(customer.email)}</span>
                                                </div>
                                                <div
                                                    class="list-group-item d-flex justify-content-between align-items-center py-3">
                                                    <span class="text-muted"><i class="bi bi-phone me-2"></i>Điện
                                                        thoại</span>
                                                    <span class="fw-bold">${fn:escapeXml(customer.phone)}</span>
                                                </div>
                                                <div
                                                    class="list-group-item d-flex justify-content-between align-items-center py-3">
                                                    <span class="text-muted"><i class="bi bi-geo-alt me-2"></i>Thành
                                                        phố</span>
                                                    <span class="fw-bold">${not empty customer.city ? customer.city :
                                                        'N/A'}</span>
                                                </div>
                                                <div
                                                    class="list-group-item d-flex justify-content-between align-items-center py-3">
                                                    <span class="text-muted"><i
                                                            class="bi bi-calendar-event me-2"></i>Ngày sinh</span>
                                                    <span class="fw-bold">${customer.dob != null ? customer.dob :
                                                        'N/A'}</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <h6 class="text-uppercase text-muted fw-bold mb-3 small"
                                                style="letter-spacing: 1px;">Trạng thái & Phân loại</h6>
                                            <div class="list-group list-group-flush border rounded-3 overflow-hidden">
                                                <div
                                                    class="list-group-item d-flex justify-content-between align-items-center py-3">
                                                    <span class="text-muted"><i
                                                            class="bi bi-shield-check me-2"></i>Trạng thái</span>
                                                    <span
                                                        class="badge bg-success-subtle text-success border border-success px-3">${customer.status}</span>
                                                </div>
                                                <div
                                                    class="list-group-item d-flex justify-content-between align-items-center py-3">
                                                    <span class="text-muted"><i class="bi bi-tag me-2"></i>Từ khóa
                                                        (Tags)</span>
                                                    <div class="d-flex gap-1">
                                                        <c:forEach items="${tags}" var="t">
                                                            <span
                                                                class="badge bg-light text-dark border small">${t.tagName}</span>
                                                        </c:forEach>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Tab 2: Care History -->
                                <div class="tab-pane fade" id="pills-history" role="tabpanel">
                                    <div class="timeline p-3">
                                        <c:if test="${empty activities}">
                                            <div class="text-center py-5">
                                                <i class="bi bi-chat-square-text fs-1 text-muted opacity-25"></i>
                                                <p class="text-muted mt-3 italic">Chưa có lịch sử chăm sóc cho khách
                                                    hàng này.</p>
                                            </div>
                                        </c:if>
                                        <c:forEach items="${activities}" var="a">
                                            <div class="d-flex mb-4">
                                                <div class="flex-shrink-0 mt-1">
                                                    <div class="bg-indigo-subtle rounded-circle d-flex align-items-center justify-content-center shadow-sm"
                                                        style="width: 40px; height: 40px;">
                                                        <i class="bi bi-chat-fill text-indigo"></i>
                                                    </div>
                                                </div>
                                                <div class="flex-grow-1 ms-3 p-3 bg-light rounded-4 border-0">
                                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                                        <h6 class="fw-bold mb-0">${fn:escapeXml(a.subject)}</h6>
                                                        <small class="text-muted">
                                                            ${a.createdAt}
                                                        </small>
                                                    </div>
                                                    <p class="mb-2 text-dark small">${fn:escapeXml(a.description)}</p>
                                                    <div class="d-flex align-items-center gap-2">
                                                        <i class="bi bi-person-circle text-muted small"></i>
                                                        <span class="text-muted extra-small">Thực hiện bởi:
                                                            <strong>${a.performerName}</strong></span>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>

                                <!-- Tab 3: Enrollments -->
                                <div class="tab-pane fade" id="pills-enrollments" role="tabpanel">
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle border rounded-4 overflow-hidden">
                                            <thead class="bg-light shadow-sm">
                                                <tr>
                                                    <th class="border-0 ps-4">Khóa học</th>
                                                    <th class="border-0">Ngày mua</th>
                                                    <th class="border-0">Số tiền</th>
                                                    <th class="border-0">Thanh toán</th>
                                                    <th class="border-0">Học tập</th>
                                                    <th class="border-0 pe-4">Tiến độ</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:if test="${empty enrollments}">
                                                    <tr>
                                                        <td colspan="6" class="text-center py-5 text-muted italic">Khách
                                                            hàng chưa mua khóa học nào.</td>
                                                    </tr>
                                                </c:if>
                                                <c:forEach items="${enrollments}" var="e">
                                                    <tr>
                                                        <td class="ps-4 fw-bold">${e.courseName} <small
                                                                class="text-muted fs-xs d-block">Mã:
                                                                ${e.enrollmentCode}</small></td>
                                                        <td>${e.enrolledDate}</td>
                                                        <td class="fw-semibold">
                                                            <fmt:formatNumber value="${e.finalAmount}" type="currency"
                                                                currencySymbol="₫" />
                                                        </td>
                                                        <td><span
                                                                class="badge rounded-pill bg-success-subtle text-success border border-success px-3">${e.paymentStatus}</span>
                                                        </td>
                                                        <td><span
                                                                class="badge rounded-pill bg-info-subtle text-info border border-info px-3">${e.learningStatus}</span>
                                                        </td>
                                                        <td class="pe-4">
                                                            <div class="progress" style="height: 6px;">
                                                                <div class="progress-bar bg-indigo" role="progressbar"
                                                                    style="width: ${e.progressPercentage}%"></div>
                                                            </div>
                                                            <small
                                                                class="text-muted mt-1 d-block">${e.progressPercentage}%</small>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                                <!-- Tab 4: Audit Logs -->
                                <div class="tab-pane fade" id="pills-logs" role="tabpanel">
                                    <div class="list-group list-group-flush border rounded-3 overflow-hidden">
                                        <c:if test="${empty auditLogs}">
                                            <div class="text-center py-5 text-muted italic">Chưa ghi nhận nhật ký chỉnh
                                                sửa nào.</div>
                                        </c:if>
                                        <c:forEach items="${auditLogs}" var="log">
                                            <div class="list-group-item p-3 border-bottom border-light">
                                                <div class="d-flex justify-content-between align-items-start mb-2">
                                                    <div>
                                                        <span
                                                            class="badge bg-warning text-dark me-2">${log.action}</span>
                                                        <span class="fw-bold">Thực hiện bởi: ${log.performerName}</span>
                                                    </div>
                                                    <small class="text-muted">${log.createdAt}</small>
                                                </div>
                                                <div class="row g-2 mt-1">
                                                    <div class="col-md-6">
                                                        <div
                                                            class="p-2 bg-danger-subtle rounded border border-danger-subtle extra-small h-100">
                                                            <strong class="d-block mb-1"><i
                                                                    class="bi bi-arrow-left-circle me-1"></i>Giá trị
                                                                cũ:</strong>
                                                            <code class="text-danger">${log.oldValues}</code>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div
                                                            class="p-2 bg-success-subtle rounded border border-success-subtle extra-small h-100">
                                                            <strong class="d-block mb-1"><i
                                                                    class="bi bi-arrow-right-circle me-1"></i>Giá trị
                                                                mới:</strong>
                                                            <code class="text-success">${log.newValues}</code>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="mt-2 extra-small text-muted d-flex gap-3">
                                                    <span><i class="bi bi-pc-display me-1"></i> IP:
                                                        ${log.ipAddress}</span>
                                                    <span class="text-truncate" style="max-width: 300px;"><i
                                                            class="bi bi-browser-edge me-1"></i> ${log.userAgent}</span>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>

                <style>
                    .nav-pills .nav-link.active {
                        background-color: #4f46e5;
                        box-shadow: 0 4px 12px rgba(79, 70, 229, 0.2);
                    }

                    .nav-pills .nav-link:not(.active) {
                        color: #4b5563;
                    }

                    .text-indigo {
                        color: #4f46e5 !important;
                    }

                    .bg-indigo {
                        background-color: #4f46e5 !important;
                    }

                    .bg-indigo-subtle {
                        background-color: rgba(79, 70, 229, 0.1) !important;
                    }

                    .extra-small {
                        font-size: 0.75rem;
                    }

                    .fs-xs {
                        font-size: 0.65rem;
                    }
                </style>