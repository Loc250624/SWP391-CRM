<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div><h4 class="mb-1 fw-bold">Bao cao Win / Loss</h4><p class="text-muted mb-0">Phan tich ty le thang thua va ly do</p></div>
    <select class="form-select form-select-sm" style="width: auto;"><option selected>Quy 1/2026</option><option>Nam 2026</option></select>
</div>

<div class="row g-3 mb-4">
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body text-center"><div class="fs-2 fw-bold text-success">28</div><small class="text-muted">Won</small></div></div></div>
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body text-center"><div class="fs-2 fw-bold text-danger">11</div><small class="text-muted">Lost</small></div></div></div>
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body text-center"><div class="fs-2 fw-bold text-primary">72%</div><small class="text-muted">Win Rate</small></div></div></div>
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body text-center"><div class="fs-2 fw-bold text-warning">33</div><small class="text-muted">Ngay TB dong deal</small></div></div></div>
</div>

<div class="row g-3 mb-4">
    <div class="col-lg-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Ty le Won/Lost</h6></div>
            <div class="card-body text-center"><canvas id="winLossChart" style="max-width:220px;max-height:220px;margin:0 auto;"></canvas></div>
        </div>
    </div>
    <div class="col-lg-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Ly do thua deal</h6></div>
            <div class="card-body">
                <div class="mb-3"><div class="d-flex justify-content-between mb-1"><small>Gia ca qua cao</small><small class="fw-semibold">36%</small></div><div class="progress" style="height:8px;"><div class="progress-bar bg-danger" style="width:36%;"></div></div></div>
                <div class="mb-3"><div class="d-flex justify-content-between mb-1"><small>Chon doi thu canh tranh</small><small class="fw-semibold">27%</small></div><div class="progress" style="height:8px;"><div class="progress-bar bg-warning" style="width:27%;"></div></div></div>
                <div class="mb-3"><div class="d-flex justify-content-between mb-1"><small>Ngan sach bi cat giam</small><small class="fw-semibold">18%</small></div><div class="progress" style="height:8px;"><div class="progress-bar bg-info" style="width:18%;"></div></div></div>
                <div class="mb-3"><div class="d-flex justify-content-between mb-1"><small>Khong phu hop nhu cau</small><small class="fw-semibold">12%</small></div><div class="progress" style="height:8px;"><div class="progress-bar bg-secondary" style="width:12%;"></div></div></div>
                <div><div class="d-flex justify-content-between mb-1"><small>Khac</small><small class="fw-semibold">7%</small></div><div class="progress" style="height:8px;"><div class="progress-bar bg-light" style="width:7%;"></div></div></div>
            </div>
        </div>
    </div>
</div>

<div class="card border-0 shadow-sm">
    <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Deals gan day</h6></div>
    <div class="card-body pt-0">
        <div class="table-responsive"><table class="table table-hover align-middle mb-0">
            <thead class="table-light"><tr><th>Opportunity</th><th>Khach hang</th><th class="text-end">Gia tri</th><th>Ket qua</th><th>Ly do</th><th>Ngay dong</th></tr></thead>
            <tbody>
                <tr><td class="fw-medium">OPP-0020</td><td>GHI Technology</td><td class="text-end fw-semibold">980 trieu</td><td><span class="badge bg-success">Won</span></td><td><small class="text-muted">Gia tot, dich vu tot</small></td><td><small>10/02/2026</small></td></tr>
                <tr><td class="fw-medium">OPP-0021</td><td>JKL Academy</td><td class="text-end fw-semibold">750 trieu</td><td><span class="badge bg-success">Won</span></td><td><small class="text-muted">Demo an tuong</small></td><td><small>08/02/2026</small></td></tr>
                <tr><td class="fw-medium">OPP-0018</td><td>JKL Inc</td><td class="text-end fw-semibold">650 trieu</td><td><span class="badge bg-danger">Lost</span></td><td><small class="text-muted">Ngan sach han che</small></td><td><small>05/02/2026</small></td></tr>
                <tr><td class="fw-medium">OPP-0016</td><td>STU Partners</td><td class="text-end fw-semibold">420 trieu</td><td><span class="badge bg-danger">Lost</span></td><td><small class="text-muted">Chon doi thu</small></td><td><small>02/02/2026</small></td></tr>
            </tbody>
        </table></div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    new Chart(document.getElementById('winLossChart'), {
        type: 'doughnut', data: { labels: ['Won','Lost'], datasets: [{ data: [28,11], backgroundColor: ['#198754','#dc3545'], borderWidth: 0, hoverOffset: 10 }] },
        options: { responsive: true, cutout: '70%', plugins: { legend: { position: 'bottom' } } }
    });
});
</script>
