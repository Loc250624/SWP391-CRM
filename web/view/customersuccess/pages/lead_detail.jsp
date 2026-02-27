<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    /* Giữ style đồng bộ với hệ thống CRM */
    .detail-label { font-weight: 600; color: #64748b; font-size: 12px; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 4px; }
    .detail-value { color: #1e293b; font-weight: 500; font-size: 15px; margin-bottom: 20px; word-break: break-word; }
    .info-section-title { font-size: 14px; font-weight: 700; color: #3b82f6; border-bottom: 2px solid #eff6ff; padding-bottom: 8px; margin-bottom: 20px; }
</style>

<div class="container-fluid py-3">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/support/leads" class="text-decoration-none">Quản lý Leads</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Chi tiết</li>
                </ol>
            </nav>
            <h4 class="fw-bold mb-0 text-dark">Hồ sơ Lead: ${l.fullName}</h4>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/support/leads" class="btn btn-outline-secondary btn-sm rounded-pill px-4 shadow-sm">
                <i class="bi bi-arrow-left me-1"></i> Quay lại
            </a>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-md-4">
            <div class="card border-0 shadow-sm p-4 text-center h-100" style="border-radius: 15px;">
                <div class="bg-primary bg-opacity-10 p-4 rounded-circle d-inline-block mb-3 mx-auto" style="width: 100px; height: 100px;">
                    <i class="bi bi-person-vcard fs-1 text-primary"></i>
                </div>
                <h4 class="fw-bold text-dark mb-1">${l.fullName}</h4>
                <p class="text-muted small mb-3">${l.leadCode}</p>
                
                <div class="d-flex justify-content-center gap-2 mb-3">
                    <span class="badge ${l.leadScore >= 70 ? 'bg-danger' : 'bg-warning'} rounded-pill px-3 py-2">
                        Score: ${l.leadScore}
                    </span>
                    <span class="badge bg-info text-white rounded-pill px-3 py-2">
                        Rating: ${l.rating != null ? l.rating : 'N/A'}
                    </span>
                </div>
                
                <div class="alert alert-primary py-2 px-3 small border-0 shadow-sm" style="background-color: #f0f7ff;">
                    Trạng thái: <strong>${l.status}</strong>
                </div>
            </div>
        </div>

        <div class="col-md-8">
            <div class="card border-0 shadow-sm p-4 h-100" style="border-radius: 15px;">
                <h6 class="info-section-title text-uppercase"><i class="bi bi-briefcase me-2"></i>Thông tin chi tiết</h6>
                <div class="row">
                    <div class="col-md-6">
                        <div class="detail-label">Chức danh</div>
                        <div class="detail-value text-dark">${l.jobTitle != null ? l.jobTitle : 'N/A'}</div>
                    </div>
                    <div class="col-md-6">
                        <div class="detail-label">Tên công ty</div>
                        <div class="detail-value text-dark">${l.companyName != null ? l.companyName : 'N/A'}</div>
                    </div>
                    <div class="col-md-6">
                        <div class="detail-label">Email</div>
                        <div class="detail-value text-primary fw-bold">${l.email}</div>
                    </div>
                    <div class="col-md-6">
                        <div class="detail-label">Số điện thoại</div>
                        <div class="detail-value fw-bold text-dark">${l.phone}</div>
                    </div>
                    <div class="col-12">
                        <div class="detail-label">Ghi chú (Notes)</div>
                        <div class="detail-value bg-light p-3 rounded-3 border-start border-4 border-info">
                            <p class="mb-0 text-muted" style="font-style: italic;">"${l.notes != null ? l.notes : 'Không có ghi chú.'}"</p>
                        </div>
                    </div>
                </div>

                <h6 class="info-section-title text-uppercase mt-4"><i class="bi bi-clock-history me-2"></i>Hệ thống</h6>
                <div class="row row-cols-2 g-3 small text-muted">
                    <span><strong>Ngày tạo:</strong> ${l.createdAt.toLocalDate()}</span>
                    <span><strong>Cập nhật cuối:</strong> ${l.updatedAt.toLocalDate()}</span>
                </div>
            </div>
        </div>
    </div>
</div>