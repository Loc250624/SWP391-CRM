<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div><h4 class="mb-1 fw-bold">Báo cáo Win / Loss</h4><p class="text-muted mb-0">Phân tích tỷ lệ thắng thua và lý do</p></div>
</div>

<div class="row g-3 mb-4">
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body text-center"><div class="fs-2 fw-bold text-success">${wonCount}</div><small class="text-muted">Won</small></div></div></div>
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body text-center"><div class="fs-2 fw-bold text-danger">${lostCount}</div><small class="text-muted">Lost</small></div></div></div>
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body text-center"><div class="fs-2 fw-bold text-primary">${winRate}%</div><small class="text-muted">Win Rate</small></div></div></div>
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body text-center"><div class="fs-2 fw-bold text-warning">${avgDays}</div><small class="text-muted">Ngày TB đóng deal</small></div></div></div>
</div>

<div class="row g-3 mb-4">
    <div class="col-lg-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Tỷ lệ Won/Lost</h6></div>
            <div class="card-body text-center">
                <c:choose>
                    <c:when test="${wonCount > 0 || lostCount > 0}">
                        <canvas id="winLossChart" style="max-width:220px;max-height:220px;margin:0 auto;"></canvas>
                    </c:when>
                    <c:otherwise><p class="text-muted">Chưa có dữ liệu</p></c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    <div class="col-lg-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Lý do thua deal</h6></div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty lossReasonList}">
                        <c:forEach var="lr" items="${lossReasonList}">
                            <div class="mb-3">
                                <div class="d-flex justify-content-between mb-1">
                                    <small>${lr.reason}</small>
                                    <small class="fw-semibold">${lr.percent}%</small>
                                </div>
                                <div class="progress" style="height:8px;">
                                    <div class="progress-bar bg-danger" style="width:${lr.percent}%;"></div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise><p class="text-muted">Chưa có dữ liệu</p></c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<div class="card border-0 shadow-sm">
    <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Deals gần đây</h6></div>
    <div class="card-body pt-0">
        <div class="table-responsive"><table class="table table-hover align-middle mb-0">
            <thead class="table-light"><tr><th>Opportunity</th><th>Khách hàng</th><th class="text-end">Giá trị</th><th>Kết quả</th><th>Lý do</th><th>Ngày đóng</th></tr></thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty recentDeals}">
                        <c:forEach var="deal" items="${recentDeals}">
                            <tr>
                                <td class="fw-medium">${deal.code}</td>
                                <td>${deal.contactName}</td>
                                <td class="text-end fw-semibold"><fmt:formatNumber value="${deal.value}" type="number" groupingUsed="true" maxFractionDigits="0"/> d</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${deal.status == 'Won'}"><span class="badge bg-success">Won</span></c:when>
                                        <c:when test="${deal.status == 'Lost'}"><span class="badge bg-danger">Lost</span></c:when>
                                    </c:choose>
                                </td>
                                <td><small class="text-muted">${deal.reason}</small></td>
                                <td><small>${deal.closeDate}</small></td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise><tr><td colspan="6" class="text-center text-muted py-3">Chưa có deal nào đóng</td></tr></c:otherwise>
                </c:choose>
            </tbody>
        </table></div>
    </div>
</div>

<c:if test="${wonCount > 0 || lostCount > 0}">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    new Chart(document.getElementById('winLossChart'), {
        type: 'doughnut',
        data: { labels: ['Won','Lost'], datasets: [{ data: [${wonCount},${lostCount}], backgroundColor: ['#198754','#dc3545'], borderWidth: 0, hoverOffset: 10 }] },
        options: { responsive: true, cutout: '70%', plugins: { legend: { position: 'bottom' } } }
    });
});
</script>
</c:if>
