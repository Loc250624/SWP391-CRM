<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div><h4 class="mb-1 fw-bold">Báo cáo Báo giá</h4><p class="text-muted mb-0">Phân tích hiệu quả báo giá</p></div>
</div>

<div class="row g-3 mb-4">
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body py-3 text-center"><div class="fs-2 fw-bold text-primary">${total}</div><small class="text-muted">Tổng báo giá</small></div></div></div>
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body py-3 text-center"><div class="fs-2 fw-bold text-success">${acceptanceRate}%</div><small class="text-muted">Tỷ lệ chấp nhận</small></div></div></div>
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body py-3 text-center"><div class="fs-2 fw-bold text-info"><fmt:formatNumber value="${avgValue}" type="number" groupingUsed="true" maxFractionDigits="0"/></div><small class="text-muted">Giá trị TB (d)</small></div></div></div>
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body py-3 text-center"><div class="fs-2 fw-bold text-warning">${sentCount}</div><small class="text-muted">Đã gửi</small></div></div></div>
</div>

<div class="card border-0 shadow-sm mb-4">
    <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Trạng thái báo giá</h6></div>
    <div class="card-body">
        <div class="row g-3">
            <div class="col-md-3">
                <div class="border rounded p-3 text-center">
                    <div class="fs-3 fw-bold text-secondary">${draftCount}</div>
                    <small class="text-muted">Đề xuất (Draft)</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="border rounded p-3 text-center">
                    <div class="fs-3 fw-bold text-primary">${sentCount}</div>
                    <small class="text-muted">Đã gửi (Sent)</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="border rounded p-3 text-center">
                    <div class="fs-3 fw-bold text-success">${acceptedCount}</div>
                    <small class="text-muted">Chấp nhận</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="border rounded p-3 text-center">
                    <div class="fs-3 fw-bold text-danger">${rejectedCount}</div>
                    <small class="text-muted">Từ chối</small>
                </div>
            </div>
        </div>
    </div>
</div>

<c:if test="${total > 0}">
<div class="card border-0 shadow-sm">
    <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Phân bổ trạng thái</h6></div>
    <div class="card-body text-center">
        <canvas id="quotChart" style="max-width:300px;max-height:300px;margin:0 auto;"></canvas>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    new Chart(document.getElementById('quotChart'), {
        type: 'doughnut',
        data: {
            labels: ['Draft','Sent','Accepted','Rejected'],
            datasets: [{
                data: [${draftCount}, ${sentCount}, ${acceptedCount}, ${rejectedCount}],
                backgroundColor: ['#6c757d','#0d6efd','#198754','#dc3545'],
                borderWidth: 0
            }]
        },
        options: { responsive: true, cutout: '60%', plugins: { legend: { position: 'bottom' } } }
    });
});
</script>
</c:if>
