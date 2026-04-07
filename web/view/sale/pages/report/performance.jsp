<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div><h4 class="mb-1 fw-bold">Báo cáo Performance</h4><p class="text-muted mb-0">Hiệu suất bán hàng của bạn</p></div>
</div>

<!-- KPI Cards -->
<div class="row g-3 mb-4">
    <div class="col-md-3">
        <div class="card border-0 shadow-sm"><div class="card-body">
            <div class="d-flex align-items-center">
                <div class="bg-success bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-trophy text-success fs-4"></i></div>
                <div><small class="text-muted">Deals Won</small><h3 class="mb-0 fw-bold">${wonCount}</h3></div>
            </div>
        </div></div>
    </div>
    <div class="col-md-3">
        <div class="card border-0 shadow-sm"><div class="card-body">
            <div class="d-flex align-items-center">
                <div class="bg-primary bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-currency-dollar text-primary fs-4"></i></div>
                <div><small class="text-muted">Doanh thu</small><h3 class="mb-0 fw-bold"><fmt:formatNumber value="${wonRevenue}" type="number" groupingUsed="true" maxFractionDigits="0"/> <small class="fs-6 fw-normal">d</small></h3></div>
            </div>
        </div></div>
    </div>
    <div class="col-md-3">
        <div class="card border-0 shadow-sm"><div class="card-body">
            <div class="d-flex align-items-center">
                <div class="bg-warning bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-percent text-warning fs-4"></i></div>
                <div><small class="text-muted">Win Rate</small><h3 class="mb-0 fw-bold">${winRate}%</h3></div>
            </div>
        </div></div>
    </div>
    <div class="col-md-3">
        <div class="card border-0 shadow-sm"><div class="card-body">
            <div class="d-flex align-items-center">
                <div class="bg-info bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-activity text-info fs-4"></i></div>
                <div><small class="text-muted">Tổng hoạt động</small><h3 class="mb-0 fw-bold">${totalActivities}</h3></div>
            </div>
        </div></div>
    </div>
</div>

<!-- Activity Breakdown -->
<div class="card border-0 shadow-sm mb-4">
    <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Chỉ số chi tiết</h6></div>
    <div class="card-body pt-0">
        <div class="table-responsive"><table class="table table-hover align-middle mb-0">
            <thead class="table-light">
                <tr><th>Chỉ số</th><th class="text-center">Số lượng</th><th style="width:40%;">Biểu đồ</th></tr>
            </thead>
            <tbody>
                <tr>
                    <td><i class="bi bi-telephone text-success me-2"></i>Cuộc gọi</td>
                    <td class="text-center fw-bold">${calls}</td>
                    <td>
                        <div class="progress" style="height:10px;">
                            <div class="progress-bar bg-success" style="width:${totalActivities > 0 ? (calls * 100 / totalActivities) : 0}%;"></div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td><i class="bi bi-envelope text-primary me-2"></i>Email</td>
                    <td class="text-center fw-bold">${emails}</td>
                    <td>
                        <div class="progress" style="height:10px;">
                            <div class="progress-bar bg-primary" style="width:${totalActivities > 0 ? (emails * 100 / totalActivities) : 0}%;"></div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td><i class="bi bi-people text-warning me-2"></i>Cuộc họp</td>
                    <td class="text-center fw-bold">${meetings}</td>
                    <td>
                        <div class="progress" style="height:10px;">
                            <div class="progress-bar bg-warning" style="width:${totalActivities > 0 ? (meetings * 100 / totalActivities) : 0}%;"></div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td><i class="bi bi-file-earmark-text text-info me-2"></i>Báo giá gửi</td>
                    <td class="text-center fw-bold">${quotSent}</td>
                    <td></td>
                </tr>
                <tr>
                    <td><i class="bi bi-trophy text-success me-2"></i>Deals Won</td>
                    <td class="text-center fw-bold text-success">${wonCount}</td>
                    <td></td>
                </tr>
            </tbody>
        </table></div>
    </div>
</div>

<!-- Activity Chart -->
<div class="card border-0 shadow-sm">
    <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Hoạt động bán hàng</h6></div>
    <div class="card-body"><canvas id="actChart" height="80"></canvas></div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    new Chart(document.getElementById('actChart'), {
        type: 'bar',
        data: {
            labels: ['Cuộc gọi', 'Email', 'Cuộc họp'],
            datasets: [{
                label: 'Số lượng',
                data: [${calls}, ${emails}, ${meetings}],
                backgroundColor: ['#10b981', '#3b82f6', '#f59e0b'],
                borderRadius: 6
            }]
        },
        options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } } }
    });
});
</script>
