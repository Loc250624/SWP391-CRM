<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h4 class="mb-0 fw-bold">Mẫu Email Marketing</h4>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a
                                href="${pageContext.request.contextPath}/marketing/dashboard">Marketing</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Email Templates</li>
                    </ol>
                </nav>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/marketing/email/template/form" class="btn btn-primary">
                    <i class="bi bi-plus-circle me-2"></i>Tạo mẫu mới
                </a>
            </div>
        </div>

        <c:if test="${param.msg == 'success'}">
            <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                <i class="bi bi-check-circle me-2"></i>Lưu mẫu Email thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'deleted'}">
            <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                <i class="bi bi-check-circle me-2"></i>Đã xóa mẫu Email thành công.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="row g-4 mb-5">
            <c:forEach var="template" items="${templates}">
                <div class="col-md-6 col-lg-4">
                    <div class="card h-100 border-0 shadow-sm">
                        <div
                            class="card-header bg-white py-3 border-0 d-flex justify-content-between align-items-center">
                            <span
                                class="badge bg-light text-primary border border-primary-subtle px-2 py-1">${template.category}</span>
                            <div class="dropdown">
                                <button class="btn btn-light btn-sm rounded-circle" type="button"
                                    data-bs-toggle="dropdown">
                                    <i class="bi bi-three-dots"></i>
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0">
                                    <li><a class="dropdown-item py-2"
                                            href="${pageContext.request.contextPath}/marketing/email/template/form?id=${template.templateId}"><i
                                                class="bi bi-pencil me-2"></i>Sửa</a></li>
                                    <li><a class="dropdown-item py-2" href="#"><i class="bi bi-copy me-2"></i>Nhân
                                            bản</a></li>
                                    <li>
                                        <hr class="dropdown-divider">
                                    </li>
                                    <li><a class="dropdown-item py-2 text-danger"
                                            href="javascript:CRM.confirm('Bạn có chắc chắn muốn xóa mẫu email này?', () => { window.location.href='${pageContext.request.contextPath}/marketing/email/template/delete?id=${template.templateId}' })"><i
                                                class="bi bi-trash me-2"></i>Xóa</a></li>
                                </ul>
                            </div>
                        </div>
                        <div class="card-body">
                            <h6 class="fw-bold mb-2">${template.templateName}</h6>
                            <p class="text-muted small mb-3 text-truncate-2">${template.description}</p>
                            <div class="bg-light rounded p-3 mb-3"
                                style="font-size: 11px; height: 100px; overflow: hidden; opacity: 0.7;">
                                <div class="fw-bold mb-1">Subject: ${template.subject}</div>
                                <div>${template.bodyText}</div>
                            </div>
                        </div>
                        <div class="card-footer bg-white border-top-0 pb-3">
                            <div class="d-flex justify-content-between align-items-center">
                                <div class="form-check form-switch p-0 m-0">
                                    <input class="form-check-input ms-0 me-2" type="checkbox" ${template.isActive
                                        ? 'checked' : '' } disabled>
                                    <label class="form-check-label small text-muted">Hoạt động</label>
                                </div>
                                <button class="btn btn-outline-primary btn-sm px-3">Sử dụng</button>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty templates}">
                <div class="col-12">
                    <div class="card border-0 shadow-sm p-5 text-center">
                        <div class="text-muted mb-3"><i class="bi bi-envelope-paper" style="font-size: 3rem;"></i></div>
                        <h5>Chưa có mẫu email nào</h5>
                        <p class="text-muted">Tạo các mẫu email chuyên nghiệp để gửi hàng loạt cho Leads/Customers.</p>
                        <div>
                            <a href="${pageContext.request.contextPath}/marketing/email/template/form"
                                class="btn btn-primary px-4">Tạo mẫu ngay</a>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>

        <style>
            .text-truncate-2 {
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
            }
        </style>