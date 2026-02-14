<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div><h4 class="mb-1 fw-bold">Chi tiet Proposal</h4><p class="text-muted mb-0">PROP-001 - De xuat giai phap ERP toan dien</p></div>
    <div class="d-flex gap-2">
        <button class="btn btn-outline-secondary btn-sm"><i class="bi bi-printer me-1"></i>In PDF</button>
        <a href="${pageContext.request.contextPath}/sale/proposal/form?id=1" class="btn btn-outline-primary btn-sm"><i class="bi bi-pencil me-1"></i>Chinh sua</a>
    </div>
</div>

<div class="row g-4">
    <div class="col-lg-8">
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Thong tin chung</h6></div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-6"><label class="text-muted small">Khach hang</label><div class="fw-medium">ABC Corporation</div></div>
                    <div class="col-md-6"><label class="text-muted small">Opportunity</label><div class="fw-medium">OPP-0025 - Hop dong ERP Enterprise</div></div>
                    <div class="col-md-6"><label class="text-muted small">Ngay tao</label><div>12/02/2026</div></div>
                    <div class="col-md-6"><label class="text-muted small">Trang thai</label><div><span class="badge bg-success-subtle text-success">Da gui</span></div></div>
                </div>
            </div>
        </div>
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Van de khach hang</h6></div>
            <div class="card-body"><p class="text-muted">ABC Corporation dang su dung he thong quan ly roi rac, khong dong bo du lieu giua cac phong ban. Can mot giai phap ERP toan dien de thong nhat quy trinh lam viec.</p></div>
        </div>
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Giai phap de xuat</h6></div>
            <div class="card-body"><p class="text-muted mb-3">Trien khai he thong ERP Enterprise bao gom:</p>
                <ul class="text-muted">
                    <li>Module Quan ly Nhan su (HRM)</li>
                    <li>Module Quan ly Tai chinh - Ke toan</li>
                    <li>Module Quan ly Kho & Cung ung</li>
                    <li>Module CRM tich hop</li>
                    <li>Dao tao su dung cho 20 nhan su chu chot</li>
                </ul>
            </div>
        </div>
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Loi ich mang lai</h6></div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-6"><div class="d-flex gap-2"><i class="bi bi-check-circle text-success"></i><span>Giam 40% thoi gian xu ly don hang</span></div></div>
                    <div class="col-md-6"><div class="d-flex gap-2"><i class="bi bi-check-circle text-success"></i><span>Dong bo du lieu real-time</span></div></div>
                    <div class="col-md-6"><div class="d-flex gap-2"><i class="bi bi-check-circle text-success"></i><span>Bao cao tu dong, chinh xac</span></div></div>
                    <div class="col-md-6"><div class="d-flex gap-2"><i class="bi bi-check-circle text-success"></i><span>Tiet kiem 30% chi phi van hanh</span></div></div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-lg-4">
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Nguoi tao</h6></div>
            <div class="card-body">
                <div class="d-flex align-items-center gap-3">
                    <div class="bg-primary text-white rounded d-flex align-items-center justify-content-center" style="width:40px;height:40px;font-size:14px;">NT</div>
                    <div><div class="fw-semibold">Nguyen Thanh</div><small class="text-muted">Senior Sales</small></div>
                </div>
            </div>
        </div>
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">File dinh kem</h6></div>
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
