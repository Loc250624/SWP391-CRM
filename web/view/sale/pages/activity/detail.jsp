<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div><h4 class="mb-1 fw-bold">Chi tiet Hoat dong</h4><p class="text-muted mb-0">Cuoc goi dam phan hop dong ABC Corp</p></div>
    <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/sale/activity/form?id=1" class="btn btn-outline-primary btn-sm"><i class="bi bi-pencil me-1"></i>Chinh sua</a>
        <a href="${pageContext.request.contextPath}/sale/activity/list" class="btn btn-outline-secondary btn-sm">Quay lai</a>
    </div>
</div>

<div class="row g-4">
    <div class="col-lg-8">
        <div class="card border-0 shadow-sm">
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-6"><label class="text-muted small">Loai</label><div><span class="badge bg-success-subtle text-success"><i class="bi bi-telephone me-1"></i>Cuoc goi</span></div></div>
                    <div class="col-md-6"><label class="text-muted small">Lien quan</label><div class="fw-medium">OPP-0025 - Hop dong ERP Enterprise</div></div>
                    <div class="col-md-6"><label class="text-muted small">Ngay gio</label><div>14/02/2026 - 14:30</div></div>
                    <div class="col-md-6"><label class="text-muted small">Thoi luong</label><div>25 phut</div></div>
                    <div class="col-md-6"><label class="text-muted small">Huong</label><div>Goi di (Outbound)</div></div>
                    <div class="col-md-6"><label class="text-muted small">Ket qua</label><div><span class="badge bg-success">Thanh cong</span></div></div>
                    <div class="col-12"><label class="text-muted small">Mo ta</label><div class="text-muted mt-1">Da thao luan chi tiet ve cac dieu khoan hop dong. Khach hang dong y voi gia tri 1.45 ty nhung yeu cau them 3 thang bao hanh. Can xin duyet tu quan ly.</div></div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-lg-4">
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Nguoi thuc hien</h6></div>
            <div class="card-body">
                <div class="d-flex align-items-center gap-3">
                    <div class="bg-primary text-white rounded d-flex align-items-center justify-content-center" style="width:40px;height:40px;font-size:14px;">NT</div>
                    <div><div class="fw-semibold">Nguyen Thanh</div><small class="text-muted">Senior Sales</small></div>
                </div>
            </div>
        </div>
    </div>
</div>
