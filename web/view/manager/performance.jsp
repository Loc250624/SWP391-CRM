<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="container-fluid">
    <!-- Header -->
    <div class="mb-4">
        <h3 class="mb-1"><i class="bi bi-award me-2"></i>Hiệu suất KPI</h3>
        <p class="text-muted mb-0">Bảng xếp hạng và phân tích hiệu suất nhân viên theo SLA và tỷ lệ hoàn thành</p>
    </div>

    <!-- Summary Cards -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <p class="text-muted mb-1 small">Tổng công việc (SLA)</p>
                            <h4 class="mb-0">${slaStats['total']}</h4>
                        </div>
                        <div class="bg-primary bg-opacity-10 p-2 rounded">
                            <i class="bi bi-list-task text-primary fs-5"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <p class="text-muted mb-1 small">Tỷ lệ hoàn thành TB</p>
                            <h4 class="mb-0 text-success">
                                <fmt:formatNumber value="${avgCompletionRate}" pattern="#0.0"/>%
                            </h4>
                        </div>
                        <div class="bg-success bg-opacity-10 p-2 rounded">
                            <i class="bi bi-graph-up text-success fs-5"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <p class="text-muted mb-1 small">Vi phạm SLA</p>
                            <h4 class="mb-0 text-danger">${slaStats['breached']}</h4>
                        </div>
                        <div class="bg-danger bg-opacity-10 p-2 rounded">
                            <i class="bi bi-exclamation-triangle text-danger fs-5"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <p class="text-muted mb-1 small">KPI TB (0–100)</p>
                            <h4 class="mb-0 text-info">
                                <fmt:formatNumber value="${avgProductivity}" pattern="#0.0"/>
                            </h4>
                        </div>
                        <div class="bg-info bg-opacity-10 p-2 rounded">
                            <i class="bi bi-award text-info fs-5"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- SLA Overview -->
    <div class="card mb-4">
        <div class="card-header bg-white">
            <h5 class="mb-0"><i class="bi bi-shield-check me-2"></i>Tổng quan SLA Phòng ban</h5>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-4 mb-3">
                    <div class="d-flex justify-content-between mb-1">
                        <span class="text-success fw-bold"><i class="bi bi-check-circle me-1"></i>Đúng SLA</span>
                        <span>${slaStats['ok']}</span>
                    </div>
                    <div class="progress" style="height: 20px;">
                        <div class="progress-bar bg-success" role="progressbar"
                             style="width: ${slaStats['total'] > 0 ? (slaStats['ok'] * 100 / slaStats['total']) : 0}%">
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-3">
                    <div class="d-flex justify-content-between mb-1">
                        <span class="text-warning fw-bold"><i class="bi bi-exclamation-circle me-1"></i>Cảnh báo</span>
                        <span>${slaStats['warning']}</span>
                    </div>
                    <div class="progress" style="height: 20px;">
                        <div class="progress-bar bg-warning" role="progressbar"
                             style="width: ${slaStats['total'] > 0 ? (slaStats['warning'] * 100 / slaStats['total']) : 0}%">
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-3">
                    <div class="d-flex justify-content-between mb-1">
                        <span class="text-danger fw-bold"><i class="bi bi-x-circle me-1"></i>Vi phạm</span>
                        <span>${slaStats['breached']}</span>
                    </div>
                    <div class="progress" style="height: 20px;">
                        <div class="progress-bar bg-danger" role="progressbar"
                             style="width: ${slaStats['total'] > 0 ? (slaStats['breached'] * 100 / slaStats['total']) : 0}%">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Employee KPI Ranking Table -->
    <div class="card">
        <div class="card-header bg-white">
            <h5 class="mb-0"><i class="bi bi-trophy me-2"></i>Bảng xếp hạng nhân viên (KPI Score)</h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead class="table-light">
                        <tr>
                            <th style="width:50px;">#</th>
                            <th>Nhân viên</th>
                            <th class="text-center">Tổng</th>
                            <th class="text-center">Hoàn thành</th>
                            <th class="text-center">Tỷ lệ HT</th>
                            <th class="text-center">Đúng hạn</th>
                            <th class="text-center">Vi phạm SLA</th>
                            <th class="text-center">TB hoàn thành</th>
                            <th class="text-center" style="width:140px;">KPI Score</th>
                            <th class="text-center">Đánh giá</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="perf" items="${performanceList}" varStatus="st">
                            <c:set var="score" value="${perf['productivityScore']}"/>
                            <tr>
                                <td class="text-center fw-bold">
                                    <c:choose>
                                        <c:when test="${st.index == 0}">
                                            <span class="text-warning fs-5">🥇</span>
                                        </c:when>
                                        <c:when test="${st.index == 1}">
                                            <span class="text-secondary fs-5">🥈</span>
                                        </c:when>
                                        <c:when test="${st.index == 2}">
                                            <span class="fs-5">🥉</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">${st.index + 1}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="avatar-sm bg-primary rounded-circle d-flex align-items-center justify-content-center text-white me-2">
                                            ${fn:substring(perf['firstName'], 0, 1)}${fn:substring(perf['lastName'], 0, 1)}
                                        </div>
                                        <div>
                                            <div class="fw-medium">${perf['firstName']} ${perf['lastName']}</div>
                                            <small class="text-muted">${perf['email']}</small>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-center fw-bold">${perf['totalTasks']}</td>
                                <td class="text-center">
                                    <span class="badge bg-success">${perf['completedTasks']}</span>
                                </td>
                                <td class="text-center">
                                    <div class="progress" style="height: 16px; min-width: 80px;">
                                        <div class="progress-bar bg-success" role="progressbar"
                                             style="width: ${perf['completionRate']}%">
                                            <fmt:formatNumber value="${perf['completionRate']}" pattern="#0"/>%
                                        </div>
                                    </div>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-info">${perf['onTimeCount']}</span>
                                </td>
                                <td class="text-center">
                                    <span class="badge ${perf['slaBreachCount'] > 0 ? 'bg-danger' : 'bg-success'}">
                                        ${perf['slaBreachCount']}
                                    </span>
                                </td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${perf['avgCompletionHours'] > 0}">
                                            <small><fmt:formatNumber value="${perf['avgCompletionHours'] / 24}" pattern="#0.1"/> ngày</small>
                                        </c:when>
                                        <c:otherwise><small class="text-muted">—</small></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center">
                                    <div class="d-flex align-items-center gap-1 justify-content-center">
                                        <div class="progress flex-grow-1" style="height: 16px;">
                                            <div class="progress-bar ${score >= 80 ? 'bg-success' : score >= 60 ? 'bg-info' : score >= 40 ? 'bg-warning' : 'bg-danger'}"
                                                 role="progressbar"
                                                 style="width: ${score}%">
                                            </div>
                                        </div>
                                        <small class="fw-bold" style="min-width: 35px;">
                                            <fmt:formatNumber value="${score}" pattern="#0.0"/>
                                        </small>
                                    </div>
                                </td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${score >= 80}">
                                            <span class="badge bg-success">Xuất sắc</span>
                                        </c:when>
                                        <c:when test="${score >= 60}">
                                            <span class="badge bg-info">Tốt</span>
                                        </c:when>
                                        <c:when test="${score >= 40}">
                                            <span class="badge bg-warning text-dark">Trung bình</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger">Cần cải thiện</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <!-- Collapsible detail row -->
                            <tr>
                                <td colspan="10" class="p-0">
                                    <div class="collapse" id="detail-${perf['userId']}">
                                        <div class="bg-light p-3">
                                            <div class="row">
                                                <div class="col-md-4">
                                                    <small class="text-muted d-block mb-1">Tỷ lệ hoàn thành</small>
                                                    <div class="progress mb-1" style="height: 12px;">
                                                        <div class="progress-bar bg-success" style="width:${perf['completionRate']}%"></div>
                                                    </div>
                                                    <small><fmt:formatNumber value="${perf['completionRate']}" pattern="#0.1"/>%</small>
                                                </div>
                                                <div class="col-md-4">
                                                    <small class="text-muted d-block mb-1">Tỷ lệ đúng hạn</small>
                                                    <div class="progress mb-1" style="height: 12px;">
                                                        <div class="progress-bar bg-info" style="width:${perf['onTimeRate']}%"></div>
                                                    </div>
                                                    <small><fmt:formatNumber value="${perf['onTimeRate']}" pattern="#0.1"/>%</small>
                                                </div>
                                                <div class="col-md-4">
                                                    <small class="text-muted d-block mb-1">Tỷ lệ vi phạm SLA</small>
                                                    <div class="progress mb-1" style="height: 12px;">
                                                        <div class="progress-bar bg-danger" style="width:${perf['slaBreachRate']}%"></div>
                                                    </div>
                                                    <small><fmt:formatNumber value="${perf['slaBreachRate']}" pattern="#0.1"/>%</small>
                                                </div>
                                            </div>
                                            <div class="row mt-2">
                                                <div class="col-auto">
                                                    <small class="badge bg-secondary me-1">Chờ: ${perf['pendingTasks']}</small>
                                                    <small class="badge bg-info me-1">Đang làm: ${perf['inProgressTasks']}</small>
                                                    <small class="badge bg-dark me-1">Đã hủy: ${perf['cancelledTasks']}</small>
                                                    <small class="badge bg-danger">Quá hạn: ${perf['overdueTasks']}</small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty performanceList}">
                            <tr>
                                <td colspan="10" class="text-center py-5">
                                    <i class="bi bi-inbox text-muted" style="font-size:3rem;"></i>
                                    <p class="text-muted mt-3">Không có dữ liệu nhân viên</p>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- KPI Formula Note -->
    <div class="card bg-light border-0 mt-3">
        <div class="card-body py-2">
            <small class="text-muted">
                <i class="bi bi-info-circle me-1"></i>
                <strong>Công thức KPI Score:</strong>
                (Tỷ lệ hoàn thành × 0.4) + (Tỷ lệ đúng hạn × 0.4) + ((1 − Tỷ lệ vi phạm SLA) × 0.2) × 100
                | SLA: HIGH=24h, MEDIUM=72h, LOW=120h
            </small>
        </div>
    </div>
</div>

<style>
    .avatar-sm { width: 32px; height: 32px; font-size: 0.75rem; font-weight: 600; flex-shrink: 0; }
</style>

<script>
// Toggle detail rows on row click
document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('tbody tr').forEach(function(row) {
        row.style.cursor = 'pointer';
        row.addEventListener('click', function(e) {
            if (e.target.tagName === 'A' || e.target.closest('a')) return;
            var userId = row.querySelector('[id^="detail-"]');
            if (!userId) {
                // This is a detail row — handled by collapse
                return;
            }
            var collapseEl = document.getElementById(userId.id);
            if (collapseEl) {
                var bsCollapse = bootstrap.Collapse.getOrCreateInstance(collapseEl);
                bsCollapse.toggle();
            }
        });
    });
});
</script>
