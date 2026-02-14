<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div><h4 class="mb-1 fw-bold">Bao cao Doanh thu</h4><p class="text-muted mb-0">Phan tich doanh thu ban hang theo thoi gian</p></div>
    <div class="d-flex gap-2">
        <select class="form-select form-select-sm" style="width: auto;"><option selected>Nam 2026</option><option>Nam 2025</option></select>
        <button class="btn btn-outline-secondary btn-sm"><i class="bi bi-download me-1"></i>Xuat bao cao</button>
    </div>
</div>

<div class="row g-3 mb-4">
    <div class="col-xl-3 col-md-6"><div class="card border-0 shadow-sm"><div class="card-body"><div class="d-flex align-items-center"><div class="bg-success bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-currency-dollar text-success fs-4"></i></div><div><small class="text-muted">Doanh thu thang</small><h3 class="mb-0 fw-bold">3.8<small class="fs-6 fw-normal"> ty</small></h3></div></div><span class="badge bg-success-subtle text-success mt-2"><i class="bi bi-arrow-up"></i> 15.3% vs thang truoc</span></div></div></div>
    <div class="col-xl-3 col-md-6"><div class="card border-0 shadow-sm"><div class="card-body"><div class="d-flex align-items-center"><div class="bg-primary bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-graph-up text-primary fs-4"></i></div><div><small class="text-muted">Doanh thu luy ke</small><h3 class="mb-0 fw-bold">6.8<small class="fs-6 fw-normal"> ty</small></h3></div></div><span class="badge bg-primary-subtle text-primary mt-2">57% muc tieu nam</span></div></div></div>
    <div class="col-xl-3 col-md-6"><div class="card border-0 shadow-sm"><div class="card-body"><div class="d-flex align-items-center"><div class="bg-warning bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-receipt text-warning fs-4"></i></div><div><small class="text-muted">Gia tri TB/deal</small><h3 class="mb-0 fw-bold">425<small class="fs-6 fw-normal"> trieu</small></h3></div></div><span class="badge bg-warning-subtle text-warning mt-2"><i class="bi bi-arrow-up"></i> 8% cai thien</span></div></div></div>
    <div class="col-xl-3 col-md-6"><div class="card border-0 shadow-sm"><div class="card-body"><div class="d-flex align-items-center"><div class="bg-info bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-clock text-info fs-4"></i></div><div><small class="text-muted">Thoi gian TB dong deal</small><h3 class="mb-0 fw-bold">28<small class="fs-6 fw-normal"> ngay</small></h3></div></div><span class="badge bg-success-subtle text-success mt-2"><i class="bi bi-arrow-down"></i> Giam 5 ngay</span></div></div></div>
</div>

<div class="row g-3 mb-4">
    <div class="col-lg-8">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Doanh thu theo thang</h6></div>
            <div class="card-body"><canvas id="revenueChart" height="120"></canvas></div>
        </div>
    </div>
    <div class="col-lg-4">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Doanh thu theo nguon</h6></div>
            <div class="card-body"><canvas id="sourceChart" style="max-width:200px;max-height:200px;margin:0 auto;"></canvas>
                <div class="mt-3">
                    <div class="d-flex justify-content-between mb-2"><small><span class="rounded-1" style="width:10px;height:10px;background:#3b82f6;display:inline-block;"></span> Website</small><small class="fw-semibold">35%</small></div>
                    <div class="d-flex justify-content-between mb-2"><small><span class="rounded-1" style="width:10px;height:10px;background:#10b981;display:inline-block;"></span> Referral</small><small class="fw-semibold">28%</small></div>
                    <div class="d-flex justify-content-between mb-2"><small><span class="rounded-1" style="width:10px;height:10px;background:#f59e0b;display:inline-block;"></span> Facebook</small><small class="fw-semibold">22%</small></div>
                    <div class="d-flex justify-content-between"><small><span class="rounded-1" style="width:10px;height:10px;background:#8b5cf6;display:inline-block;"></span> Khac</small><small class="fw-semibold">15%</small></div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="card border-0 shadow-sm">
    <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Doanh thu theo nhan vien</h6></div>
    <div class="card-body pt-0">
        <div class="table-responsive"><table class="table table-hover align-middle mb-0">
            <thead class="table-light"><tr><th>Nhan vien</th><th class="text-center">Deals Won</th><th class="text-end">Doanh thu</th><th class="text-end">TB/deal</th><th style="width:200px;">% Muc tieu</th></tr></thead>
            <tbody>
                <tr><td><div class="d-flex align-items-center gap-2"><div class="bg-primary text-white rounded d-flex align-items-center justify-content-center" style="width:32px;height:32px;font-size:12px;">NT</div><div><div class="fw-medium">Nguyen Thanh</div></div></div></td><td class="text-center">12</td><td class="text-end fw-bold">3.2 ty</td><td class="text-end">267 trieu</td><td><div class="d-flex align-items-center gap-2"><div class="progress flex-grow-1" style="height:6px;"><div class="progress-bar bg-success" style="width:85%;"></div></div><small>85%</small></div></td></tr>
                <tr><td><div class="d-flex align-items-center gap-2"><div class="bg-success text-white rounded d-flex align-items-center justify-content-center" style="width:32px;height:32px;font-size:12px;">LM</div><div><div class="fw-medium">Le Mai</div></div></div></td><td class="text-center">10</td><td class="text-end fw-bold">2.8 ty</td><td class="text-end">280 trieu</td><td><div class="d-flex align-items-center gap-2"><div class="progress flex-grow-1" style="height:6px;"><div class="progress-bar bg-primary" style="width:70%;"></div></div><small>70%</small></div></td></tr>
                <tr><td><div class="d-flex align-items-center gap-2"><div class="rounded d-flex align-items-center justify-content-center text-white" style="width:32px;height:32px;font-size:12px;background:#fb923c;">PH</div><div><div class="fw-medium">Pham Huy</div></div></div></td><td class="text-center">9</td><td class="text-end fw-bold">2.4 ty</td><td class="text-end">267 trieu</td><td><div class="d-flex align-items-center gap-2"><div class="progress flex-grow-1" style="height:6px;"><div class="progress-bar bg-warning" style="width:60%;"></div></div><small>60%</small></div></td></tr>
            </tbody>
        </table></div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    new Chart(document.getElementById('revenueChart'), {
        type: 'bar', data: { labels: ['T1','T2'], datasets: [{ label: 'Doanh thu', data: [2.8,3.8], backgroundColor: '#10b981', borderRadius: 6 },{ label: 'Muc tieu', data: [4,4], type: 'line', borderColor: '#f59e0b', borderDash:[5,5], pointRadius: 4, fill: false }] },
        options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: 'bottom' } }, scales: { y: { ticks: { callback: v => v+' ty' } } } }
    });
    new Chart(document.getElementById('sourceChart'), {
        type: 'doughnut', data: { labels: ['Website','Referral','Facebook','Khac'], datasets: [{ data: [35,28,22,15], backgroundColor: ['#3b82f6','#10b981','#f59e0b','#8b5cf6'], borderWidth: 0 }] },
        options: { responsive: true, cutout: '65%', plugins: { legend: { display: false } } }
    });
});
</script>
