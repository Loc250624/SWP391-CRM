<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div><h4 class="mb-1 fw-bold">Bao cao Performance</h4><p class="text-muted mb-0">Hieu suat cua doi ngu ban hang</p></div>
    <select class="form-select form-select-sm" style="width: auto;"><option selected>Thang 2/2026</option><option>Thang 1/2026</option></select>
</div>

<!-- Leaderboard -->
<div class="row g-3 mb-4">
    <div class="col-md-4">
        <div class="card border-0 shadow-sm text-center" style="background: linear-gradient(135deg, #fef3c7, #fde68a);">
            <div class="card-body py-4">
                <div class="fs-1 mb-2">🥇</div>
                <div class="bg-warning text-white rounded-circle d-flex align-items-center justify-content-center mx-auto mb-2" style="width:56px;height:56px;font-size:20px;font-weight:700;">NT</div>
                <h5 class="fw-bold mb-1">Nguyen Thanh</h5>
                <small class="text-muted">Senior Sales</small>
                <div class="mt-3"><div class="fs-4 fw-bold text-success">3.2 ty</div><small class="text-muted">12 deals | Win rate 85%</small></div>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card border-0 shadow-sm text-center bg-light">
            <div class="card-body py-4">
                <div class="fs-1 mb-2">🥈</div>
                <div class="bg-secondary text-white rounded-circle d-flex align-items-center justify-content-center mx-auto mb-2" style="width:56px;height:56px;font-size:20px;font-weight:700;">LM</div>
                <h5 class="fw-bold mb-1">Le Mai</h5>
                <small class="text-muted">Sales Executive</small>
                <div class="mt-3"><div class="fs-4 fw-bold text-success">2.8 ty</div><small class="text-muted">10 deals | Win rate 77%</small></div>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card border-0 shadow-sm text-center bg-light">
            <div class="card-body py-4">
                <div class="fs-1 mb-2">🥉</div>
                <div class="rounded-circle d-flex align-items-center justify-content-center mx-auto mb-2 text-white" style="width:56px;height:56px;font-size:20px;font-weight:700;background:#fb923c;">PH</div>
                <h5 class="fw-bold mb-1">Pham Huy</h5>
                <small class="text-muted">Sales Manager</small>
                <div class="mt-3"><div class="fs-4 fw-bold text-success">2.4 ty</div><small class="text-muted">9 deals | Win rate 69%</small></div>
            </div>
        </div>
    </div>
</div>

<!-- Detailed metrics -->
<div class="card border-0 shadow-sm mb-4">
    <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Chi so chi tiet</h6></div>
    <div class="card-body pt-0">
        <div class="table-responsive"><table class="table table-hover align-middle mb-0">
            <thead class="table-light"><tr><th>Nhan vien</th><th class="text-center">Cuoc goi</th><th class="text-center">Email</th><th class="text-center">Meeting</th><th class="text-center">Bao gia gui</th><th class="text-center">Deal Won</th><th class="text-end">Doanh thu</th><th>Muc tieu</th></tr></thead>
            <tbody>
                <tr><td class="fw-medium">Nguyen Thanh</td><td class="text-center">48</td><td class="text-center">35</td><td class="text-center">12</td><td class="text-center">14</td><td class="text-center"><span class="badge bg-success">12</span></td><td class="text-end fw-bold">3.2 ty</td><td><div class="d-flex align-items-center gap-2"><div class="progress flex-grow-1" style="height:6px;"><div class="progress-bar bg-success" style="width:85%;"></div></div><small>85%</small></div></td></tr>
                <tr><td class="fw-medium">Le Mai</td><td class="text-center">42</td><td class="text-center">40</td><td class="text-center">8</td><td class="text-center">12</td><td class="text-center"><span class="badge bg-success">10</span></td><td class="text-end fw-bold">2.8 ty</td><td><div class="d-flex align-items-center gap-2"><div class="progress flex-grow-1" style="height:6px;"><div class="progress-bar bg-primary" style="width:70%;"></div></div><small>70%</small></div></td></tr>
                <tr><td class="fw-medium">Pham Huy</td><td class="text-center">36</td><td class="text-center">28</td><td class="text-center">15</td><td class="text-center">12</td><td class="text-center"><span class="badge bg-success">9</span></td><td class="text-end fw-bold">2.4 ty</td><td><div class="d-flex align-items-center gap-2"><div class="progress flex-grow-1" style="height:6px;"><div class="progress-bar bg-warning" style="width:60%;"></div></div><small>60%</small></div></td></tr>
            </tbody>
        </table></div>
    </div>
</div>

<div class="card border-0 shadow-sm">
    <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Hoat dong ban hang</h6></div>
    <div class="card-body"><canvas id="actChart" height="100"></canvas></div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    new Chart(document.getElementById('actChart'), {
        type: 'bar', data: { labels: ['Nguyen Thanh','Le Mai','Pham Huy'],
            datasets: [
                { label: 'Cuoc goi', data: [48,42,36], backgroundColor: '#10b981' },
                { label: 'Email', data: [35,40,28], backgroundColor: '#3b82f6' },
                { label: 'Meeting', data: [12,8,15], backgroundColor: '#f59e0b' }
            ] },
        options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: 'bottom' } } }
    });
});
</script>
