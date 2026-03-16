<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="container-fluid">
    <!-- Header -->
    <div class="mb-4">
        <h3 class="mb-1"><i class="bi bi-award me-2"></i>Hieu suat KPI</h3>
        <p class="text-muted mb-0">Bang xep hang va phan tich hieu suat nhan vien theo ty le hoan thanh va dung han</p>
    </div>

    <!-- Summary Cards -->
    <div class="row mb-4">
        <div class="col-md-4">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <p class="text-muted mb-1 small">Tong thanh vien</p>
                            <h4 class="mb-0">${fn:length(deptMembers)}</h4>
                        </div>
                        <div class="bg-primary bg-opacity-10 p-2 rounded">
                            <i class="bi bi-people text-primary fs-5"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <p class="text-muted mb-1 small">Ty le hoan thanh TB</p>
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
        <div class="col-md-4">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <p class="text-muted mb-1 small">KPI TB (0-100)</p>
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

    <!-- Employee KPI Ranking Table -->
    <div class="card">
        <div class="card-header bg-white">
            <h5 class="mb-0"><i class="bi bi-trophy me-2"></i>Bang xep hang nhan vien (KPI Score)</h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead class="table-light">
                        <tr>
                            <th style="width:50px;">#</th>
                            <th>Nhan vien</th>
                            <th class="text-center">Tong</th>
                            <th class="text-center">Hoan thanh</th>
                            <th class="text-center">Ty le HT</th>
                            <th class="text-center">Dung han</th>
                            <th class="text-center">TB hoan thanh</th>
                            <th class="text-center" style="width:140px;">KPI Score</th>
                            <th class="text-center">Danh gia</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="perf" items="${performanceList}" varStatus="st">
                            <c:set var="score" value="${perf['productivityScore']}"/>
                            <tr>
                                <td class="text-center fw-bold">
                                    <c:choose>
                                        <c:when test="${st.index == 0}">
                                            <span class="text-warning fs-5">1</span>
                                        </c:when>
                                        <c:when test="${st.index == 1}">
                                            <span class="text-secondary fs-5">2</span>
                                        </c:when>
                                        <c:when test="${st.index == 2}">
                                            <span class="fs-5">3</span>
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
                                    <c:choose>
                                        <c:when test="${perf['avgCompletionHours'] > 0}">
                                            <small><fmt:formatNumber value="${perf['avgCompletionHours'] / 24}" pattern="#0.1"/> ngay</small>
                                        </c:when>
                                        <c:otherwise><small class="text-muted">-</small></c:otherwise>
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
                                            <span class="badge bg-success">Xuat sac</span>
                                        </c:when>
                                        <c:when test="${score >= 60}">
                                            <span class="badge bg-info">Tot</span>
                                        </c:when>
                                        <c:when test="${score >= 40}">
                                            <span class="badge bg-warning text-dark">Trung binh</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger">Can cai thien</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <!-- Collapsible detail row -->
                            <tr>
                                <td colspan="9" class="p-0">
                                    <div class="collapse" id="detail-${perf['userId']}">
                                        <div class="bg-light p-3">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <small class="text-muted d-block mb-1">Ty le hoan thanh</small>
                                                    <div class="progress mb-1" style="height: 12px;">
                                                        <div class="progress-bar bg-success" style="width:${perf['completionRate']}%"></div>
                                                    </div>
                                                    <small><fmt:formatNumber value="${perf['completionRate']}" pattern="#0.1"/>%</small>
                                                </div>
                                                <div class="col-md-6">
                                                    <small class="text-muted d-block mb-1">Ty le dung han</small>
                                                    <div class="progress mb-1" style="height: 12px;">
                                                        <div class="progress-bar bg-info" style="width:${perf['onTimeRate']}%"></div>
                                                    </div>
                                                    <small><fmt:formatNumber value="${perf['onTimeRate']}" pattern="#0.1"/>%</small>
                                                </div>
                                            </div>
                                            <div class="row mt-2">
                                                <div class="col-auto">
                                                    <small class="badge bg-secondary me-1">Cho: ${perf['pendingTasks']}</small>
                                                    <small class="badge bg-info me-1">Dang lam: ${perf['inProgressTasks']}</small>
                                                    <small class="badge bg-dark me-1">Da huy: ${perf['cancelledTasks']}</small>
                                                    <small class="badge bg-danger">Qua han: ${perf['overdueTasks']}</small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty performanceList}">
                            <tr>
                                <td colspan="9" class="text-center py-5">
                                    <i class="bi bi-inbox text-muted" style="font-size:3rem;"></i>
                                    <p class="text-muted mt-3">Khong co du lieu nhan vien</p>
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
                <strong>Cong thuc KPI Score:</strong>
                (Ty le hoan thanh x 0.6) + (Ty le dung han x 0.4) x 100
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
