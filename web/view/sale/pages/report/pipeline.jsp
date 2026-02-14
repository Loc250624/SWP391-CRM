<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div><h4 class="mb-1 fw-bold">Pipeline Statistics</h4><p class="text-muted mb-0">Phan tich chi tiet pipeline ban hang</p></div>
    <div class="d-flex gap-2">
        <select class="form-select form-select-sm" style="width: auto;"><option selected>Chuyen doi Lead</option><option>Ban them (Upsell)</option></select>
        <button class="btn btn-outline-secondary btn-sm"><i class="bi bi-download me-1"></i>Xuat</button>
    </div>
</div>

<div class="row g-3 mb-4">
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body"><div class="d-flex align-items-center"><div class="bg-primary bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-funnel text-primary fs-4"></i></div><div><small class="text-muted">Tong trong pipeline</small><h3 class="mb-0 fw-bold">47</h3></div></div></div></div></div>
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body"><div class="d-flex align-items-center"><div class="bg-success bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-currency-dollar text-success fs-4"></i></div><div><small class="text-muted">Tong gia tri</small><h3 class="mb-0 fw-bold">18.7 ty</h3></div></div></div></div></div>
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body"><div class="d-flex align-items-center"><div class="bg-warning bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-arrow-repeat text-warning fs-4"></i></div><div><small class="text-muted">Ty le chuyen doi</small><h3 class="mb-0 fw-bold">68%</h3></div></div></div></div></div>
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body"><div class="d-flex align-items-center"><div class="bg-info bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-speedometer2 text-info fs-4"></i></div><div><small class="text-muted">Velocity (ngay)</small><h3 class="mb-0 fw-bold">28</h3></div></div></div></div></div>
</div>

<!-- Funnel -->
<div class="card border-0 shadow-sm mb-4">
    <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Pipeline Funnel</h6></div>
    <div class="card-body">
        <div class="d-flex flex-column gap-2">
            <div class="d-flex align-items-center gap-3">
                <div style="width: 140px;" class="fw-medium">Moi tiep nhan</div>
                <div class="flex-grow-1"><div class="progress" style="height: 32px;"><div class="progress-bar" style="width:100%;background:#94a3b8;font-size:13px;" class="d-flex align-items-center justify-content-center">8 deals - 3.2 ty</div></div></div>
            </div>
            <div class="d-flex align-items-center gap-3">
                <div style="width: 140px;" class="fw-medium">Da lien he</div>
                <div class="flex-grow-1"><div class="progress" style="height: 32px;"><div class="progress-bar" style="width:75%;background:#06b6d4;font-size:13px;" class="d-flex align-items-center justify-content-center">6 deals - 2.8 ty</div></div></div>
            </div>
            <div class="d-flex align-items-center gap-3">
                <div style="width: 140px;" class="fw-medium">Du dieu kien</div>
                <div class="flex-grow-1"><div class="progress" style="height: 32px;"><div class="progress-bar" style="width:62%;background:#8b5cf6;font-size:13px;" class="d-flex align-items-center justify-content-center">10 deals - 4.8 ty</div></div></div>
            </div>
            <div class="d-flex align-items-center gap-3">
                <div style="width: 140px;" class="fw-medium">Demo / Tu van</div>
                <div class="flex-grow-1"><div class="progress" style="height: 32px;"><div class="progress-bar" style="width:50%;background:#f59e0b;font-size:13px;" class="d-flex align-items-center justify-content-center">5 deals - 3.9 ty</div></div></div>
            </div>
            <div class="d-flex align-items-center gap-3">
                <div style="width: 140px;" class="fw-medium">Dam phan</div>
                <div class="flex-grow-1"><div class="progress" style="height: 32px;"><div class="progress-bar" style="width:38%;background:#3b82f6;font-size:13px;" class="d-flex align-items-center justify-content-center">7 deals - 4.2 ty</div></div></div>
            </div>
            <div class="d-flex align-items-center gap-3">
                <div style="width: 140px;" class="fw-medium text-success">Thanh cong</div>
                <div class="flex-grow-1"><div class="progress" style="height: 32px;"><div class="progress-bar bg-success" style="width:25%;font-size:13px;" class="d-flex align-items-center justify-content-center">9 deals - 2.6 ty</div></div></div>
            </div>
        </div>
    </div>
</div>

<!-- Stage Details -->
<div class="card border-0 shadow-sm">
    <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Chi tiet theo giai doan</h6></div>
    <div class="card-body pt-0">
        <div class="table-responsive"><table class="table table-hover align-middle mb-0">
            <thead class="table-light"><tr><th>Giai doan</th><th class="text-center">So deal</th><th class="text-end">Gia tri</th><th class="text-end">TB/deal</th><th class="text-center">TB ngay o giai doan</th><th>Ty le chuyen doi</th></tr></thead>
            <tbody>
                <tr><td><div class="d-flex align-items-center gap-2"><span class="rounded-circle" style="width:10px;height:10px;background:#94a3b8;display:inline-block;"></span><span>Moi tiep nhan</span></div></td><td class="text-center">8</td><td class="text-end fw-semibold">3.2 ty</td><td class="text-end">400 tr</td><td class="text-center">5 ngay</td><td><div class="d-flex align-items-center gap-2"><div class="progress flex-grow-1" style="height:6px;"><div class="progress-bar" style="width:75%;background:#94a3b8;"></div></div><small>75%</small></div></td></tr>
                <tr><td><div class="d-flex align-items-center gap-2"><span class="rounded-circle" style="width:10px;height:10px;background:#06b6d4;display:inline-block;"></span><span>Da lien he</span></div></td><td class="text-center">6</td><td class="text-end fw-semibold">2.8 ty</td><td class="text-end">467 tr</td><td class="text-center">7 ngay</td><td><div class="d-flex align-items-center gap-2"><div class="progress flex-grow-1" style="height:6px;"><div class="progress-bar" style="width:83%;background:#06b6d4;"></div></div><small>83%</small></div></td></tr>
                <tr><td><div class="d-flex align-items-center gap-2"><span class="rounded-circle" style="width:10px;height:10px;background:#8b5cf6;display:inline-block;"></span><span>Du dieu kien</span></div></td><td class="text-center">10</td><td class="text-end fw-semibold">4.8 ty</td><td class="text-end">480 tr</td><td class="text-center">10 ngay</td><td><div class="d-flex align-items-center gap-2"><div class="progress flex-grow-1" style="height:6px;"><div class="progress-bar" style="width:70%;background:#8b5cf6;"></div></div><small>70%</small></div></td></tr>
                <tr><td><div class="d-flex align-items-center gap-2"><span class="rounded-circle" style="width:10px;height:10px;background:#f59e0b;display:inline-block;"></span><span>Demo / Tu van</span></div></td><td class="text-center">5</td><td class="text-end fw-semibold">3.9 ty</td><td class="text-end">780 tr</td><td class="text-center">8 ngay</td><td><div class="d-flex align-items-center gap-2"><div class="progress flex-grow-1" style="height:6px;"><div class="progress-bar bg-warning" style="width:80%;"></div></div><small>80%</small></div></td></tr>
                <tr><td><div class="d-flex align-items-center gap-2"><span class="rounded-circle" style="width:10px;height:10px;background:#3b82f6;display:inline-block;"></span><span>Dam phan</span></div></td><td class="text-center">7</td><td class="text-end fw-semibold">4.2 ty</td><td class="text-end">600 tr</td><td class="text-center">12 ngay</td><td><div class="d-flex align-items-center gap-2"><div class="progress flex-grow-1" style="height:6px;"><div class="progress-bar bg-primary" style="width:85%;"></div></div><small>85%</small></div></td></tr>
            </tbody>
        </table></div>
    </div>
</div>
