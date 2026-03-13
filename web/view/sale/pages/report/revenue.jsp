<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div><h4 class="mb-1 fw-bold">Bao cao Doanh thu</h4><p class="text-muted mb-0">Phan tich doanh thu ban hang theo thoi gian</p></div>
    <div class="d-flex gap-2">
        <form method="GET" class="d-flex gap-2">
            <select class="form-select form-select-sm" name="year" style="width: auto;" onchange="this.form.submit()">
                <option value="2026" ${selectedYear == 2026 ? 'selected' : ''}>Nam 2026</option>
                <option value="2025" ${selectedYear == 2025 ? 'selected' : ''}>Nam 2025</option>
            </select>
        </form>
    </div>
</div>

<div class="row g-3 mb-4">
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm"><div class="card-body">
            <div class="d-flex align-items-center">
                <div class="bg-success bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-currency-dollar text-success fs-4"></i></div>
                <div><small class="text-muted">Doanh thu thang</small><h3 class="mb-0 fw-bold"><fmt:formatNumber value="${monthRevenue}" type="number" groupingUsed="true" maxFractionDigits="0"/> <small class="fs-6 fw-normal">d</small></h3></div>
            </div>
            <c:if test="${monthGrowth != 0}">
                <span class="badge ${monthGrowth > 0 ? 'bg-success-subtle text-success' : 'bg-danger-subtle text-danger'} mt-2">
                    <i class="bi ${monthGrowth > 0 ? 'bi-arrow-up' : 'bi-arrow-down'}"></i>
                    <fmt:formatNumber value="${monthGrowth}" maxFractionDigits="1"/>% vs thang truoc
                </span>
            </c:if>
        </div></div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm"><div class="card-body">
            <div class="d-flex align-items-center">
                <div class="bg-primary bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-graph-up text-primary fs-4"></i></div>
                <div><small class="text-muted">Doanh thu luy ke (${selectedYear})</small><h3 class="mb-0 fw-bold"><fmt:formatNumber value="${yearRevenue}" type="number" groupingUsed="true" maxFractionDigits="0"/> <small class="fs-6 fw-normal">d</small></h3></div>
            </div>
            <span class="badge bg-primary-subtle text-primary mt-2">${wonCount} deals Won</span>
        </div></div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm"><div class="card-body">
            <div class="d-flex align-items-center">
                <div class="bg-warning bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-receipt text-warning fs-4"></i></div>
                <div><small class="text-muted">Gia tri TB/deal</small><h3 class="mb-0 fw-bold"><fmt:formatNumber value="${avgDealValue}" type="number" groupingUsed="true" maxFractionDigits="0"/> <small class="fs-6 fw-normal">d</small></h3></div>
            </div>
        </div></div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm"><div class="card-body">
            <div class="d-flex align-items-center">
                <div class="bg-info bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-clock text-info fs-4"></i></div>
                <div><small class="text-muted">Thoi gian TB dong deal</small><h3 class="mb-0 fw-bold">${avgDaysToClose} <small class="fs-6 fw-normal">ngay</small></h3></div>
            </div>
        </div></div>
    </div>
</div>

<div class="card border-0 shadow-sm">
    <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Doanh thu theo thang (${selectedYear})</h6></div>
    <div class="card-body"><canvas id="revenueChart" height="120"></canvas></div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    new Chart(document.getElementById('revenueChart'), {
        type: 'bar',
        data: {
            labels: [${monthLabels}],
            datasets: [{
                label: 'Doanh thu',
                data: [${monthData}],
                backgroundColor: '#10b981',
                borderRadius: 6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { position: 'bottom' } },
            scales: { y: { ticks: { callback: function(v) { return new Intl.NumberFormat('vi-VN').format(v) + ' d'; } } } }
        }
    });
});
</script>
