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

    <!-- Search & Filter -->
    <div class="card mb-3">
        <div class="card-body py-2">
            <div class="row g-2 align-items-center">
                <div class="col-md-4">
                    <div class="input-group input-group-sm">
                        <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
                        <input type="text" id="kpiSearch" class="form-control" placeholder="Tìm theo tên, email nhân viên...">
                    </div>
                </div>
                <div class="col-md-3">
                    <select id="ratingFilter" class="form-select form-select-sm">
                        <option value="">Tất cả đánh giá</option>
                        <option value="excellent">Xuat sac (>= 80)</option>
                        <option value="good">Tot (60-79)</option>
                        <option value="average">Trung binh (40-59)</option>
                        <option value="poor">Can cai thien (< 40)</option>
                    </select>
                </div>
                <div class="col-md-5 text-end">
                    <small class="text-muted">Tìm thấy <strong id="kpiResultCount">0</strong> nhân viên</small>
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
                <table class="table table-hover mb-0" id="kpiTable">
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
                            <c:set var="rating" value="${score >= 80 ? 'excellent' : score >= 60 ? 'good' : score >= 40 ? 'average' : 'poor'}"/>
                            <tr class="kpi-data-row"
                                data-name="${fn:toLowerCase(perf['firstName'])} ${fn:toLowerCase(perf['lastName'])}"
                                data-email="${fn:toLowerCase(perf['email'])}"
                                data-rating="${rating}"
                                data-rank="${st.index + 1}">
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
                            <tr class="kpi-detail-row">
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
            <div id="kpiNoResults" class="text-center py-4 d-none">
                <i class="bi bi-search text-muted" style="font-size:2rem;"></i>
                <p class="text-muted mt-2 mb-0">Không tìm thấy nhân viên phù hợp</p>
            </div>
        </div>
        <div class="card-footer bg-white">
            <nav><ul class="pagination justify-content-center mb-0" id="kpiPagination"></ul></nav>
            <p class="text-center text-muted small mb-0 mt-2" id="kpiPageInfo"></p>
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
document.addEventListener('DOMContentLoaded', function() {
    var searchInput = document.getElementById('kpiSearch');
    var ratingFilter = document.getElementById('ratingFilter');
    var table = document.getElementById('kpiTable');
    if (!table) return;

    // Collect data-row / detail-row pairs
    var dataRows = Array.from(table.querySelectorAll('tr.kpi-data-row'));
    var currentPage = 1;
    var PAGE_SIZE = 10;

    function getDetailRow(dataRow) {
        return dataRow.nextElementSibling && dataRow.nextElementSibling.classList.contains('kpi-detail-row')
            ? dataRow.nextElementSibling : null;
    }

    function filterAndPaginate() {
        var kw = searchInput.value.trim().toLowerCase();
        var rating = ratingFilter.value;
        var pageSize = PAGE_SIZE;

        var filtered = dataRows.filter(function(row) {
            var name = row.getAttribute('data-name') || '';
            var email = row.getAttribute('data-email') || '';
            var rowRating = row.getAttribute('data-rating') || '';
            var matchKw = !kw || name.indexOf(kw) !== -1 || email.indexOf(kw) !== -1;
            var matchRating = !rating || rowRating === rating;
            return matchKw && matchRating;
        });

        var totalPages = Math.max(1, Math.ceil(filtered.length / pageSize));
        if (currentPage > totalPages) currentPage = totalPages;
        var start = (currentPage - 1) * pageSize;

        // Hide all
        dataRows.forEach(function(r) {
            r.style.display = 'none';
            var d = getDetailRow(r);
            if (d) d.style.display = 'none';
        });

        // Show filtered page
        filtered.forEach(function(r, i) {
            var visible = (i >= start && i < start + pageSize);
            r.style.display = visible ? '' : 'none';
            var d = getDetailRow(r);
            if (d) d.style.display = visible ? '' : 'none';
        });

        document.getElementById('kpiResultCount').textContent = filtered.length;
        document.getElementById('kpiNoResults').classList.toggle('d-none', filtered.length > 0);
        renderPagination(totalPages, filtered.length);
    }

    function renderPagination(totalPages, total) {
        var pag = document.getElementById('kpiPagination');
        var info = document.getElementById('kpiPageInfo');
        pag.innerHTML = '';
        if (totalPages <= 1) { info.textContent = 'Tổng ' + total + ' nhân viên'; return; }

        pag.innerHTML += '<li class="page-item '+(currentPage===1?'disabled':'')+'"><a class="page-link" href="#" data-p="'+(currentPage-1)+'"><i class="bi bi-chevron-left"></i></a></li>';
        for (var i = 1; i <= totalPages; i++) {
            if (i === 1 || i === totalPages || (i >= currentPage-2 && i <= currentPage+2))
                pag.innerHTML += '<li class="page-item '+(i===currentPage?'active':'')+'"><a class="page-link" href="#" data-p="'+i+'">'+i+'</a></li>';
        }
        pag.innerHTML += '<li class="page-item '+(currentPage===totalPages?'disabled':'')+'"><a class="page-link" href="#" data-p="'+(currentPage+1)+'"><i class="bi bi-chevron-right"></i></a></li>';
        info.textContent = 'Trang ' + currentPage + ' / ' + totalPages + ' - Tổng ' + total + ' nhân viên';

        pag.querySelectorAll('a[data-p]').forEach(function(a) {
            a.addEventListener('click', function(e) {
                e.preventDefault();
                var p = parseInt(this.getAttribute('data-p'));
                if (p >= 1 && p <= totalPages) { currentPage = p; filterAndPaginate(); }
            });
        });
    }

    searchInput.addEventListener('input', function() { currentPage = 1; filterAndPaginate(); });
    ratingFilter.addEventListener('change', function() { currentPage = 1; filterAndPaginate(); });
    filterAndPaginate();

    // Toggle detail rows on data row click
    dataRows.forEach(function(row) {
        row.style.cursor = 'pointer';
        row.addEventListener('click', function(e) {
            if (e.target.tagName === 'A' || e.target.closest('a')) return;
            var detail = getDetailRow(row);
            if (detail) {
                var collapseEl = detail.querySelector('.collapse');
                if (collapseEl) {
                    var bsCollapse = bootstrap.Collapse.getOrCreateInstance(collapseEl);
                    bsCollapse.toggle();
                }
            }
        });
    });
});
</script>
