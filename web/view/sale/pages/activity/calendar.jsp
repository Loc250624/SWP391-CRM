<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div><h4 class="mb-1 fw-bold">Lich hen</h4><p class="text-muted mb-0">Quan ly lich hen va cuoc hop</p></div>
    <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/sale/activity/form" class="btn btn-primary btn-sm"><i class="bi bi-plus-lg me-1"></i>Them lich hen</a>
    </div>
</div>

<!-- Week View -->
<div class="card border-0 shadow-sm mb-4">
    <div class="card-header bg-transparent border-0 d-flex justify-content-between align-items-center">
        <div class="d-flex align-items-center gap-3">
            <button class="btn btn-sm btn-outline-secondary"><i class="bi bi-chevron-left"></i></button>
            <h6 class="mb-0 fw-semibold">Tuan 10 - 16 Thang 2, 2026</h6>
            <button class="btn btn-sm btn-outline-secondary"><i class="bi bi-chevron-right"></i></button>
        </div>
        <div class="btn-group btn-group-sm">
            <button class="btn btn-outline-secondary">Ngay</button>
            <button class="btn btn-primary">Tuan</button>
            <button class="btn btn-outline-secondary">Thang</button>
        </div>
    </div>
    <div class="card-body pt-0">
        <div class="table-responsive">
            <table class="table table-bordered mb-0" style="table-layout: fixed;">
                <thead class="table-light">
                    <tr>
                        <th style="width: 60px;"></th>
                        <th class="text-center small">T2<br>10/02</th>
                        <th class="text-center small">T3<br>11/02</th>
                        <th class="text-center small">T4<br>12/02</th>
                        <th class="text-center small">T5<br>13/02</th>
                        <th class="text-center small bg-primary-subtle">T6<br>14/02</th>
                        <th class="text-center small">T7<br>15/02</th>
                        <th class="text-center small">CN<br>16/02</th>
                    </tr>
                </thead>
                <tbody>
                    <tr style="height: 80px;">
                        <td class="text-muted small text-center align-middle">09:00</td>
                        <td class="align-top p-1">
                            <div class="bg-success-subtle text-success rounded p-1 small" style="font-size: 11px;">
                                <i class="bi bi-telephone me-1"></i>Goi ABC Corp<br><small>09:00 - 09:30</small>
                            </div>
                        </td>
                        <td></td><td></td><td></td>
                        <td class="align-top p-1 bg-primary-subtle bg-opacity-25">
                            <div class="bg-warning-subtle text-warning rounded p-1 small" style="font-size: 11px;">
                                <i class="bi bi-people me-1"></i>Demo XYZ Ltd<br><small>09:00 - 10:30</small>
                            </div>
                        </td>
                        <td></td><td></td>
                    </tr>
                    <tr style="height: 80px;">
                        <td class="text-muted small text-center align-middle">10:00</td>
                        <td></td>
                        <td class="align-top p-1">
                            <div class="bg-primary-subtle text-primary rounded p-1 small" style="font-size: 11px;">
                                <i class="bi bi-people me-1"></i>Hop team Sales<br><small>10:00 - 11:00</small>
                            </div>
                        </td>
                        <td></td><td></td>
                        <td class="bg-primary-subtle bg-opacity-25"></td>
                        <td></td><td></td>
                    </tr>
                    <tr style="height: 80px;">
                        <td class="text-muted small text-center align-middle">14:00</td>
                        <td></td><td></td>
                        <td class="align-top p-1">
                            <div class="bg-info-subtle text-info rounded p-1 small" style="font-size: 11px;">
                                <i class="bi bi-envelope me-1"></i>Follow-up DEF<br><small>14:00 - 14:30</small>
                            </div>
                        </td>
                        <td class="align-top p-1">
                            <div class="bg-danger-subtle text-danger rounded p-1 small" style="font-size: 11px;">
                                <i class="bi bi-camera-video me-1"></i>Meeting GHI<br><small>14:00 - 15:00</small>
                            </div>
                        </td>
                        <td class="align-top p-1 bg-primary-subtle bg-opacity-25">
                            <div class="bg-success-subtle text-success rounded p-1 small" style="font-size: 11px;">
                                <i class="bi bi-telephone me-1"></i>Goi MNO<br><small>14:30 - 15:00</small>
                            </div>
                        </td>
                        <td></td><td></td>
                    </tr>
                    <tr style="height: 80px;">
                        <td class="text-muted small text-center align-middle">16:00</td>
                        <td></td><td></td><td></td>
                        <td></td>
                        <td class="bg-primary-subtle bg-opacity-25"></td>
                        <td></td><td></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Upcoming -->
<div class="card border-0 shadow-sm">
    <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Sap toi</h6></div>
    <div class="card-body">
        <div class="d-flex flex-column gap-2">
            <div class="d-flex align-items-center gap-3 p-2 bg-warning-subtle rounded">
                <div class="text-center" style="width: 50px;"><div class="fw-bold">14</div><small class="text-muted">T2</small></div>
                <div class="flex-grow-1"><div class="fw-medium">Demo XYZ Ltd - Giai phap dao tao</div><small class="text-muted">09:00 - 10:30 | Nguyen Thanh</small></div>
                <span class="badge bg-warning-subtle text-warning">Meeting</span>
            </div>
            <div class="d-flex align-items-center gap-3 p-2 bg-light rounded">
                <div class="text-center" style="width: 50px;"><div class="fw-bold">14</div><small class="text-muted">T2</small></div>
                <div class="flex-grow-1"><div class="fw-medium">Goi follow-up MNO Partners</div><small class="text-muted">14:30 - 15:00 | Le Mai</small></div>
                <span class="badge bg-success-subtle text-success">Call</span>
            </div>
            <div class="d-flex align-items-center gap-3 p-2 bg-light rounded">
                <div class="text-center" style="width: 50px;"><div class="fw-bold">17</div><small class="text-muted">T2</small></div>
                <div class="flex-grow-1"><div class="fw-medium">Hop review pipeline hang tuan</div><small class="text-muted">10:00 - 11:00 | Team Sales</small></div>
                <span class="badge bg-primary-subtle text-primary">Meeting</span>
            </div>
        </div>
    </div>
</div>
