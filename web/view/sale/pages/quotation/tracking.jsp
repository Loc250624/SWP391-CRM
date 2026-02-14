<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">Theo doi Bao gia</h4>
        <p class="text-muted mb-0">Theo doi trang thai va tuong tac cua khach hang voi bao gia</p>
    </div>
</div>

<!-- Overview Stats -->
<div class="row g-3 mb-4">
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body py-3"><div class="d-flex align-items-center"><div class="bg-primary bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-send text-primary fs-5"></i></div><div><small class="text-muted">Da gui</small><h4 class="mb-0 fw-bold">15</h4></div></div></div></div></div>
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body py-3"><div class="d-flex align-items-center"><div class="bg-info bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-eye text-info fs-5"></i></div><div><small class="text-muted">Da xem</small><h4 class="mb-0 fw-bold">12</h4></div></div></div></div></div>
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body py-3"><div class="d-flex align-items-center"><div class="bg-success bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-check-circle text-success fs-5"></i></div><div><small class="text-muted">Chap nhan</small><h4 class="mb-0 fw-bold">8</h4></div></div></div></div></div>
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body py-3"><div class="d-flex align-items-center"><div class="bg-warning bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-clock text-warning fs-5"></i></div><div><small class="text-muted">Sap het han</small><h4 class="mb-0 fw-bold">3</h4></div></div></div></div></div>
</div>

<!-- Tracking Table -->
<div class="card border-0 shadow-sm">
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light"><tr><th>Bao gia</th><th>Khach hang</th><th>Gia tri</th><th>Trang thai</th><th>Luot xem</th><th>Lan xem cuoi</th><th>Thoi gian xem</th><th>Het han</th></tr></thead>
                <tbody>
                    <tr>
                        <td class="fw-medium">QT-2026-0156</td>
                        <td>ABC Corporation</td>
                        <td class="fw-semibold">1,450,000,000 d</td>
                        <td><span class="badge bg-info-subtle text-info">Dang xem</span></td>
                        <td><span class="badge bg-primary-subtle text-primary">5 lan</span></td>
                        <td><small>Hom nay, 14:30</small></td>
                        <td><small>12 phut</small></td>
                        <td><span class="badge bg-danger-subtle text-danger">Con 14 ngay</span></td>
                    </tr>
                    <tr>
                        <td class="fw-medium">QT-2026-0155</td>
                        <td>XYZ Limited</td>
                        <td class="fw-semibold">925,000,000 d</td>
                        <td><span class="badge bg-success-subtle text-success">Da chap nhan</span></td>
                        <td><span class="badge bg-primary-subtle text-primary">8 lan</span></td>
                        <td><small>13/02, 10:00</small></td>
                        <td><small>25 phut</small></td>
                        <td><span class="text-success"><i class="bi bi-check-circle"></i></span></td>
                    </tr>
                    <tr>
                        <td class="fw-medium">QT-2026-0152</td>
                        <td>MNO Partners</td>
                        <td class="fw-semibold">480,000,000 d</td>
                        <td><span class="badge bg-warning-subtle text-warning">Chua xem</span></td>
                        <td><span class="badge bg-secondary-subtle text-secondary">0 lan</span></td>
                        <td><small class="text-muted">-</small></td>
                        <td><small class="text-muted">-</small></td>
                        <td><span class="badge bg-danger-subtle text-danger">Con 5 ngay</span></td>
                    </tr>
                    <tr>
                        <td class="fw-medium">QT-2026-0150</td>
                        <td>PQR Academy</td>
                        <td class="fw-semibold">620,000,000 d</td>
                        <td><span class="badge bg-danger-subtle text-danger">Het han</span></td>
                        <td><span class="badge bg-primary-subtle text-primary">2 lan</span></td>
                        <td><small>01/02, 09:15</small></td>
                        <td><small>3 phut</small></td>
                        <td><span class="text-danger"><i class="bi bi-x-circle"></i> Het han</span></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>
