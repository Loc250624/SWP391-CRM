<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div><h4 class="mb-1 fw-bold">Bao cao Forecast</h4><p class="text-muted mb-0">Du bao doanh thu theo pipeline va xac suat</p></div>
</div>

<div class="row g-3 mb-4">
    <div class="col-md-4">
        <div class="card border-0 shadow-sm"><div class="card-body">
            <div class="d-flex align-items-center">
                <div class="bg-success bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-check-circle text-success fs-4"></i></div>
                <div><small class="text-muted">Da Won</small><h3 class="mb-0 fw-bold"><fmt:formatNumber value="${wonTotal}" type="number" groupingUsed="true" maxFractionDigits="0"/> <small class="fs-6 fw-normal">d</small></h3></div>
            </div>
        </div></div>
    </div>
    <div class="col-md-4">
        <div class="card border-0 shadow-sm"><div class="card-body">
            <div class="d-flex align-items-center">
                <div class="bg-primary bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-bullseye text-primary fs-4"></i></div>
                <div><small class="text-muted">Committed (>80%)</small><h3 class="mb-0 fw-bold"><fmt:formatNumber value="${commitW}" type="number" groupingUsed="true" maxFractionDigits="0"/> <small class="fs-6 fw-normal">d</small></h3></div>
            </div>
        </div></div>
    </div>
    <div class="col-md-4">
        <div class="card border-0 shadow-sm"><div class="card-body">
            <div class="d-flex align-items-center">
                <div class="bg-warning bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-question-circle text-warning fs-4"></i></div>
                <div><small class="text-muted">Tong Weighted Forecast</small><h3 class="mb-0 fw-bold"><fmt:formatNumber value="${totalW}" type="number" groupingUsed="true" maxFractionDigits="0"/> <small class="fs-6 fw-normal">d</small></h3></div>
            </div>
        </div></div>
    </div>
</div>

<div class="card border-0 shadow-sm mb-4">
    <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Forecast theo muc do</h6></div>
    <div class="card-body">
        <c:if test="${not empty tiers}">
            <canvas id="fcChart" height="80"></canvas>
        </c:if>
        <c:if test="${empty tiers}"><p class="text-muted text-center">Chua co du lieu</p></c:if>
    </div>
</div>

<div class="card border-0 shadow-sm">
    <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Chi tiet Forecast theo muc xac suat</h6></div>
    <div class="card-body pt-0">
        <div class="table-responsive"><table class="table table-hover align-middle mb-0">
            <thead class="table-light"><tr><th>Muc</th><th class="text-center">So deal</th><th class="text-end">Pipeline Value</th><th class="text-end">Weighted Value</th><th style="width:200px;">Ti trong</th></tr></thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty tiers}">
                        <c:forEach var="tier" items="${tiers}">
                            <tr>
                                <td><span class="badge ${tier.badgeClass}">${tier.label}</span></td>
                                <td class="text-center">${tier.count}</td>
                                <td class="text-end fw-semibold"><fmt:formatNumber value="${tier.pipelineValue}" type="number" groupingUsed="true" maxFractionDigits="0"/> d</td>
                                <td class="text-end fw-bold"><fmt:formatNumber value="${tier.weightedValue}" type="number" groupingUsed="true" maxFractionDigits="0"/> d</td>
                                <td><div class="progress" style="height:8px;"><div class="progress-bar ${tier.badgeClass}" style="width:${tier.percent}%;"></div></div></td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise><tr><td colspan="5" class="text-center text-muted py-3">Chua co du lieu</td></tr></c:otherwise>
                </c:choose>
            </tbody>
        </table></div>
    </div>
</div>

<c:if test="${not empty tiers}">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    var tiers = [
        <c:forEach var="tier" items="${tiers}" varStatus="s">
        {label: '${tier.label}', value: ${tier.weightedValue}}${!s.last ? ',' : ''}
        </c:forEach>
    ];
    new Chart(document.getElementById('fcChart'), {
        type: 'bar',
        data: {
            labels: tiers.map(function(t){ return t.label; }),
            datasets: [{
                label: 'Weighted Value',
                data: tiers.map(function(t){ return t.value; }),
                backgroundColor: ['#10b981','#3b82f6','#f59e0b','#6b7280'],
                borderRadius: 6
            }]
        },
        options: {
            responsive: true, indexAxis: 'y', maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: { x: { ticks: { callback: function(v) { return new Intl.NumberFormat('vi-VN').format(v) + ' d'; } } } }
        }
    });
});
</script>
</c:if>
