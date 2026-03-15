<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div><h4 class="mb-1 fw-bold">Chi tiết Proposal</h4><p class="text-muted mb-0">PROP-001 - Đề xuất giải pháp ERP toàn diện</p></div>
    <div class="d-flex gap-2">
        <button class="btn btn-outline-secondary btn-sm"><i class="bi bi-printer me-1"></i>In PDF</button>
        <a href="${pageContext.request.contextPath}/sale/proposal/form?id=1" class="btn btn-outline-primary btn-sm"><i class="bi bi-pencil me-1"></i>Chỉnh sửa</a>
    </div>
</div>

<div class="row g-4">
    <div class="col-lg-8">
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Thông tin chung</h6></div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-6"><label class="text-muted small">Khách hàng</label><div class="fw-medium">ABC Corporation</div></div>
                    <div class="col-md-6"><label class="text-muted small">Opportunity</label><div class="fw-medium">OPP-0025 - Hợp đồng ERP Enterprise</div></div>
                    <div class="col-md-6"><label class="text-muted small">Ngày tạo</label><div>12/02/2026</div></div>
                    <div class="col-md-6"><label class="text-muted small">Trạng thái</label><div><span class="badge bg-success-subtle text-success">Đã gửi</span></div></div>
                </div>
            </div>
        </div>
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Vấn đề khách hàng</h6></div>
            <div class="card-body"><p class="text-muted">ABC Corporation đang sử dụng hệ thống quản lý rời rạc, không đồng bộ dữ liệu giữa các phòng ban. Cần một giải pháp ERP toàn diện để thống nhất quy trình làm việc.</p></div>
        </div>
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Giải pháp đề xuất</h6></div>
            <div class="card-body"><p class="text-muted mb-3">Triển khai hệ thống ERP Enterprise bao gồm:</p>
                <ul class="text-muted">
                    <li>Module Quản lý Nhân sự (HRM)</li>
                    <li>Module Quản lý Tài chính - Kế toán</li>
                    <li>Module Quản lý Kho & Cung ứng</li>
                    <li>Module CRM tích hợp</li>
                    <li>Đào tạo sử dụng cho 20 nhân sự chủ chốt</li>
                </ul>
            </div>
        </div>
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Lợi ích mang lại</h6></div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-6"><div class="d-flex gap-2"><i class="bi bi-check-circle text-success"></i><span>Giảm 40% thời gian xử lý đơn hàng</span></div></div>
                    <div class="col-md-6"><div class="d-flex gap-2"><i class="bi bi-check-circle text-success"></i><span>Đồng bộ dữ liệu real-time</span></div></div>
                    <div class="col-md-6"><div class="d-flex gap-2"><i class="bi bi-check-circle text-success"></i><span>Báo cáo tự động, chính xác</span></div></div>
                    <div class="col-md-6"><div class="d-flex gap-2"><i class="bi bi-check-circle text-success"></i><span>Tiết kiệm 30% chi phí vận hành</span></div></div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-lg-4">
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Người tạo</h6></div>
            <div class="card-body">
                <div class="d-flex align-items-center gap-3">
                    <div class="bg-primary text-white rounded d-flex align-items-center justify-content-center" style="width:40px;height:40px;font-size:14px;">NT</div>
                    <div><div class="fw-semibold">Nguyen Thanh</div><small class="text-muted">Senior Sales</small></div>
                </div>
            </div>
        </div>
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">File đính kèm</h6></div>
            <div class="card-body">
                <div class="d-flex align-items-center gap-2 p-2 bg-light rounded mb-2">
                    <i class="bi bi-file-earmark-pdf text-danger fs-5"></i>
                    <div class="flex-grow-1"><div class="small fw-medium">Proposal_ABC_ERP.pdf</div><small class="text-muted">2.4 MB</small></div>
                    <button class="btn btn-sm btn-outline-secondary"><i class="bi bi-download"></i></button>
                </div>
                <div class="d-flex align-items-center gap-2 p-2 bg-light rounded">
                    <i class="bi bi-file-earmark-ppt text-warning fs-5"></i>
                    <div class="flex-grow-1"><div class="small fw-medium">Demo_Slides.pptx</div><small class="text-muted">5.1 MB</small></div>
                    <button class="btn btn-sm btn-outline-secondary"><i class="bi bi-download"></i></button>
                </div>
            </div>
        </div>
    </div>
</div>
