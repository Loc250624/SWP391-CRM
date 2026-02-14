<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div><h4 class="mb-1 fw-bold">Bao cao Bao gia</h4><p class="text-muted mb-0">Phan tich hieu qua bao gia</p></div>
    <select class="form-select form-select-sm" style="width: auto;"><option selected>Thang 2/2026</option><option>Thang 1/2026</option></select>
</div>

<div class="row g-3 mb-4">
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body py-3 text-center"><div class="fs-2 fw-bold text-primary">38</div><small class="text-muted">Tong bao gia</small></div></div></div>
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body py-3 text-center"><div class="fs-2 fw-bold text-success">66.7%</div><small class="text-muted">Ty le chap nhan</small></div></div></div>
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body py-3 text-center"><div class="fs-2 fw-bold text-warning">3.5</div><small class="text-muted">Ngay TB phan hoi</small></div></div></div>
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body py-3 text-center"><div class="fs-2 fw-bold text-info">680<small class="fs-6 fw-normal"> tr</small></div><small class="text-muted">Gia tri TB</small></div></div></div>
</div>

<div class="row g-3 mb-4">
    <div class="col-lg-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Trang thai bao gia</h6></div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-6"><div class="border rounded p-3 text-center"><div class="fs-3 fw-bold text-primary">15</div><small class="text-muted">Da gui</small></div></div>
                    <div class="col-6"><div class="border rounded p-3 text-center"><div class="fs-3 fw-bold text-warning">8</div><small class="text-muted">Cho duyet</small></div></div>
                    <div class="col-6"><div class="border rounded p-3 text-center"><div class="fs-3 fw-bold text-success">10</div><small class="text-muted">Chap nhan</small></div></div>
                    <div class="col-6"><div class="border rounded p-3 text-center"><div class="fs-3 fw-bold text-danger">5</div><small class="text-muted">Tu choi</small></div></div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-lg-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Xu huong bao gia</h6></div>
            <div class="card-body"><canvas id="quotChart" height="140"></canvas></div>
        </div>
    </div>
</div>

<div class="card border-0 shadow-sm">
    <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Bao gia theo nhan vien</h6></div>
    <div class="card-body pt-0">
        <div class="table-responsive"><table class="table table-hover align-middle mb-0">
            <thead class="table-light"><tr><th>Nhan vien</th><th class="text-center">Tong gui</th><th class="text-center">Chap nhan</th><th class="text-center">Tu choi</th><th class="text-end">Gia tri TB</th><th>Ty le chap nhan</th></tr></thead>
            <tbody>
                <tr><td><div class="d-flex align-items-center gap-2"><div class="bg-primary text-white rounded" style="width:28px;height:28px;font-size:10px;display:flex;align-items:center;justify-content:center;">NT</div><span class="fw-medium">Nguyen Thanh</span></div></td><td class="text-center">14</td><td class="text-center text-success">10</td><td class="text-center text-danger">2</td><td class="text-end fw-semibold">820 trieu</td><td><div class="d-flex align-items-center gap-2"><div class="progress flex-grow-1" style="height:6px;"><div class="progress-bar bg-success" style="width:71%;"></div></div><small>71%</small></div></td></tr>
                <tr><td><div class="d-flex align-items-center gap-2"><div class="bg-success text-white rounded" style="width:28px;height:28px;font-size:10px;display:flex;align-items:center;justify-content:center;">LM</div><span class="fw-medium">Le Mai</span></div></td><td class="text-center">12</td><td class="text-center text-success">8</td><td class="text-center text-danger">3</td><td class="text-end fw-semibold">650 trieu</td><td><div class="d-flex align-items-center gap-2"><div class="progress flex-grow-1" style="height:6px;"><div class="progress-bar bg-success" style="width:67%;"></div></div><small>67%</small></div></td></tr>
                <tr><td><div class="d-flex align-items-center gap-2"><div class="rounded text-white" style="width:28px;height:28px;font-size:10px;display:flex;align-items:center;justify-content:center;background:#fb923c;">PH</div><span class="fw-medium">Pham Huy</span></div></td><td class="text-center">12</td><td class="text-center text-success">7</td><td class="text-center text-danger">3</td><td class="text-end fw-semibold">580 trieu</td><td><div class="d-flex align-items-center gap-2"><div class="progress flex-grow-1" style="height:6px;"><div class="progress-bar bg-warning" style="width:58%;"></div></div><small>58%</small></div></td></tr>
            </tbody>
        </table></div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    new Chart(document.getElementById('quotChart'), {
        type: 'line', data: { labels: ['T1/1','T1/2','T1/3','T1/4','T2/1','T2/2'],
            datasets: [{ label: 'Gui', data: [5,8,6,9,7,8], borderColor: '#3b82f6', tension: 0.4 },{ label: 'Chap nhan', data: [3,5,4,6,5,5], borderColor: '#10b981', tension: 0.4 }] },
        options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: 'bottom' } } }
    });
});
</script>
