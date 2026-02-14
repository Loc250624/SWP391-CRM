<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">Danh sach Bao gia</h4>
        <p class="text-muted mb-0">Quan ly tat ca bao gia da tao</p>
    </div>
    <div class="d-flex gap-2">
        <button class="btn btn-outline-secondary btn-sm"><i class="bi bi-download me-1"></i>Xuat Excel</button>
        <a href="${pageContext.request.contextPath}/sale/quotation/form" class="btn btn-primary btn-sm"><i class="bi bi-plus-lg me-1"></i>Tao bao gia</a>
    </div>
</div>

<!-- Stats -->
<div class="row g-3 mb-4">
    <div class="col-md-3">
        <div class="card border-0 shadow-sm"><div class="card-body py-3 text-center">
            <div class="fs-3 fw-bold text-primary">38</div><small class="text-muted">Tong bao gia</small>
        </div></div>
    </div>
    <div class="col-md-3">
        <div class="card border-0 shadow-sm"><div class="card-body py-3 text-center">
            <div class="fs-3 fw-bold text-warning">12</div><small class="text-muted">Cho phan hoi</small>
        </div></div>
    </div>
    <div class="col-md-3">
        <div class="card border-0 shadow-sm"><div class="card-body py-3 text-center">
            <div class="fs-3 fw-bold text-success">18</div><small class="text-muted">Duoc chap nhan</small>
        </div></div>
    </div>
    <div class="col-md-3">
        <div class="card border-0 shadow-sm"><div class="card-body py-3 text-center">
            <div class="fs-3 fw-bold text-danger">8</div><small class="text-muted">Bi tu choi</small>
        </div></div>
    </div>
</div>

<!-- Filters -->
<div class="card border-0 shadow-sm mb-4">
    <div class="card-body py-3">
        <div class="d-flex gap-3 flex-wrap align-items-center">
            <div class="input-group" style="width: 300px;">
                <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-muted"></i></span>
                <input type="text" class="form-control bg-light border-start-0" placeholder="Tim kiem bao gia...">
            </div>
            <select class="form-select form-select-sm" style="width: auto;">
                <option selected>Tat ca trang thai</option>
                <option>Nhap</option><option>Da gui</option><option>Chap nhan</option><option>Tu choi</option><option>Het han</option>
            </select>
            <select class="form-select form-select-sm" style="width: auto;">
                <option selected>Thang nay</option><option>Thang truoc</option><option>Quy nay</option>
            </select>
        </div>
    </div>
</div>

<!-- Table -->
<div class="card border-0 shadow-sm">
    <div class="card-body pt-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr><th>Ma bao gia</th><th>Tieu de</th><th>Khach hang</th><th class="text-end">Gia tri</th><th>Trang thai</th><th>Hieu luc</th><th>Ngay tao</th><th></th></tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="fw-medium">QT-2026-0156</td>
                        <td>Bao gia goi ERP Premium</td>
                        <td><div class="d-flex align-items-center gap-2"><div class="bg-primary text-white rounded d-flex align-items-center justify-content-center" style="width:28px;height:28px;font-size:10px;">AC</div><span>ABC Corporation</span></div></td>
                        <td class="text-end fw-semibold">1,450,000,000 d</td>
                        <td><span class="badge bg-warning-subtle text-warning">Da gui</span></td>
                        <td><small class="text-muted">28/02/2026</small></td>
                        <td><small class="text-muted">12/02/2026</small></td>
                        <td><div class="dropdown"><button class="btn btn-sm btn-light" data-bs-toggle="dropdown"><i class="bi bi-three-dots-vertical"></i></button>
                            <ul class="dropdown-menu dropdown-menu-end"><li><a class="dropdown-item" href="#"><i class="bi bi-eye me-2"></i>Xem</a></li><li><a class="dropdown-item" href="#"><i class="bi bi-pencil me-2"></i>Sua</a></li><li><a class="dropdown-item" href="#"><i class="bi bi-send me-2"></i>Gui lai</a></li></ul></div></td>
                    </tr>
                    <tr>
                        <td class="fw-medium">QT-2026-0155</td>
                        <td>Bao gia dao tao AI/ML</td>
                        <td><div class="d-flex align-items-center gap-2"><div class="bg-success text-white rounded d-flex align-items-center justify-content-center" style="width:28px;height:28px;font-size:10px;">XY</div><span>XYZ Limited</span></div></td>
                        <td class="text-end fw-semibold">925,000,000 d</td>
                        <td><span class="badge bg-success-subtle text-success">Chap nhan</span></td>
                        <td><small class="text-muted">25/02/2026</small></td>
                        <td><small class="text-muted">10/02/2026</small></td>
                        <td><div class="dropdown"><button class="btn btn-sm btn-light" data-bs-toggle="dropdown"><i class="bi bi-three-dots-vertical"></i></button>
                            <ul class="dropdown-menu dropdown-menu-end"><li><a class="dropdown-item" href="#"><i class="bi bi-eye me-2"></i>Xem</a></li></ul></div></td>
                    </tr>
                    <tr>
                        <td class="fw-medium">QT-2026-0154</td>
                        <td>Bao gia Bootcamp Full-Stack</td>
                        <td><div class="d-flex align-items-center gap-2"><div class="bg-info text-white rounded d-flex align-items-center justify-content-center" style="width:28px;height:28px;font-size:10px;">DF</div><span>DEF Group</span></div></td>
                        <td class="text-end fw-semibold">350,000,000 d</td>
                        <td><span class="badge bg-danger-subtle text-danger">Tu choi</span></td>
                        <td><small class="text-muted text-decoration-line-through">20/02/2026</small></td>
                        <td><small class="text-muted">05/02/2026</small></td>
                        <td><div class="dropdown"><button class="btn btn-sm btn-light" data-bs-toggle="dropdown"><i class="bi bi-three-dots-vertical"></i></button>
                            <ul class="dropdown-menu dropdown-menu-end"><li><a class="dropdown-item" href="#"><i class="bi bi-eye me-2"></i>Xem</a></li><li><a class="dropdown-item" href="#"><i class="bi bi-copy me-2"></i>Nhan ban</a></li></ul></div></td>
                    </tr>
                    <tr>
                        <td class="fw-medium">QT-2026-0153</td>
                        <td>Bao gia Cloud Computing</td>
                        <td><div class="d-flex align-items-center gap-2"><div class="bg-secondary text-white rounded d-flex align-items-center justify-content-center" style="width:28px;height:28px;font-size:10px;">GH</div><span>GHI Technology</span></div></td>
                        <td class="text-end fw-semibold">750,000,000 d</td>
                        <td><span class="badge bg-secondary-subtle text-secondary">Nhap</span></td>
                        <td><small class="text-muted">-</small></td>
                        <td><small class="text-muted">01/02/2026</small></td>
                        <td><div class="dropdown"><button class="btn btn-sm btn-light" data-bs-toggle="dropdown"><i class="bi bi-three-dots-vertical"></i></button>
                            <ul class="dropdown-menu dropdown-menu-end"><li><a class="dropdown-item" href="#"><i class="bi bi-pencil me-2"></i>Sua</a></li><li><a class="dropdown-item" href="#"><i class="bi bi-send me-2"></i>Gui</a></li><li><hr class="dropdown-divider"></li><li><a class="dropdown-item text-danger" href="#"><i class="bi bi-trash me-2"></i>Xoa</a></li></ul></div></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>
