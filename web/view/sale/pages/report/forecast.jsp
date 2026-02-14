<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div><h4 class="mb-1 fw-bold">Bao cao Forecast</h4><p class="text-muted mb-0">Du bao doanh thu theo pipeline va xac suat</p></div>
    <select class="form-select form-select-sm" style="width: auto;"><option selected>Quy 1/2026</option><option>Quy 2/2026</option></select>
</div>

<div class="row g-3 mb-4">
    <div class="col-md-4"><div class="card border-0 shadow-sm"><div class="card-body"><div class="d-flex align-items-center"><div class="bg-primary bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-bullseye text-primary fs-4"></i></div><div><small class="text-muted">Muc tieu</small><h3 class="mb-0 fw-bold">12 ty</h3></div></div></div></div></div>
    <div class="col-md-4"><div class="card border-0 shadow-sm"><div class="card-body"><div class="d-flex align-items-center"><div class="bg-success bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-check-circle text-success fs-4"></i></div><div><small class="text-muted">Committed (>80%)</small><h3 class="mb-0 fw-bold">8.2 ty</h3></div></div></div></div></div>
    <div class="col-md-4"><div class="card border-0 shadow-sm"><div class="card-body"><div class="d-flex align-items-center"><div class="bg-warning bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-question-circle text-warning fs-4"></i></div><div><small class="text-muted">Best Case (>50%)</small><h3 class="mb-0 fw-bold">13.5 ty</h3></div></div></div></div></div>
</div>

<div class="card border-0 shadow-sm mb-4">
    <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Du bao theo thang</h6></div>
    <div class="card-body"><canvas id="fcChart" height="100"></canvas></div>
</div>

<div class="card border-0 shadow-sm">
    <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Chi tiet Forecast theo muc xac suat</h6></div>
    <div class="card-body pt-0">
        <div class="table-responsive"><table class="table table-hover align-middle mb-0">
            <thead class="table-light"><tr><th>Muc</th><th class="text-center">So deal</th><th class="text-end">Pipeline Value</th><th class="text-end">Weighted Value</th><th style="width:200px;">Ti trong</th></tr></thead>
            <tbody>
                <tr><td><span class="badge bg-success">Commit (>80%)</span></td><td class="text-center">9</td><td class="text-end fw-semibold">8.5 ty</td><td class="text-end fw-bold text-success">8.2 ty</td><td><div class="progress" style="height:8px;"><div class="progress-bar bg-success" style="width:47%;"></div></div></td></tr>
                <tr><td><span class="badge bg-primary">Upside (50-80%)</span></td><td class="text-center">12</td><td class="text-end fw-semibold">6.8 ty</td><td class="text-end fw-bold">5.3 ty</td><td><div class="progress" style="height:8px;"><div class="progress-bar bg-primary" style="width:30%;"></div></div></td></tr>
                <tr><td><span class="badge bg-warning text-dark">Pipeline (20-50%)</span></td><td class="text-center">15</td><td class="text-end fw-semibold">5.2 ty</td><td class="text-end fw-bold">2.1 ty</td><td><div class="progress" style="height:8px;"><div class="progress-bar bg-warning" style="width:16%;"></div></div></td></tr>
                <tr><td><span class="badge bg-secondary">Early (<20%)</span></td><td class="text-center">8</td><td class="text-end fw-semibold">3.2 ty</td><td class="text-end fw-bold">0.5 ty</td><td><div class="progress" style="height:8px;"><div class="progress-bar bg-secondary" style="width:7%;"></div></div></td></tr>
            </tbody>
        </table></div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    new Chart(document.getElementById('fcChart'), {
        type: 'bar', data: { labels: ['T1','T2','T3 (Du bao)'], datasets: [
            { label: 'Committed', data: [2.5,3.5,2.2], backgroundColor: '#10b981', stack: 'a' },
            { label: 'Upside', data: [0.3,0.5,4.5], backgroundColor: '#93c5fd', stack: 'a' },
            { label: 'Muc tieu', data: [4,4,4], type: 'line', borderColor: '#f59e0b', borderDash:[5,5], fill: false, pointRadius: 4 }
        ] },
        options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: 'bottom' } }, scales: { y: { stacked: true, ticks: { callback: v => v+' ty' } }, x: { stacked: true } } }
    });
});
</script>
