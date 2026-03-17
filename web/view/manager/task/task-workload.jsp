<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="container-fluid">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="mb-1"><i class="bi bi-bar-chart me-2"></i>Workload Nhân viên</h3>
            <p class="text-muted mb-0">Phân bổ công việc theo từng nhân viên trong phòng ban</p>
        </div>
        <a href="${pageContext.request.contextPath}/manager/task/list?view=team" class="btn btn-outline-secondary btn-sm">
            <i class="bi bi-arrow-left me-1"></i>Danh sách công việc
        </a>
    </div>

    <!-- Dept Quick Stats -->
    <c:if test="${not empty deptStats}">
        <div class="row g-3 mb-4">
            <div class="col-6 col-md-3">
                <div class="card border-0 bg-primary bg-opacity-10 text-center py-3">
                    <div class="fs-3 fw-bold text-primary">${deptStats.totalTasks}</div>
                    <small class="text-muted">Tổng công việc</small>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="card border-0 bg-info bg-opacity-10 text-center py-3">
                    <div class="fs-3 fw-bold text-info">${deptStats.inProgressTasks}</div>
                    <small class="text-muted">Đang thực hiện</small>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="card border-0 bg-danger bg-opacity-10 text-center py-3">
                    <div class="fs-3 fw-bold text-danger">${deptStats.overdueTasks}</div>
                    <small class="text-muted">Quá hạn</small>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="card border-0 bg-success bg-opacity-10 text-center py-3">
                    <div class="fs-3 fw-bold text-success">${deptStats.completedTasks}</div>
                    <small class="text-muted">Đã hoàn thành</small>
                </div>
            </div>
        </div>
    </c:if>

    <!-- Search -->
    <div class="card mb-3">
        <div class="card-body py-2">
            <div class="row g-2 align-items-center">
                <div class="col-md-4">
                    <div class="input-group input-group-sm">
                        <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
                        <input type="text" id="searchInput" class="form-control" placeholder="Tìm theo tên, email nhân viên...">
                    </div>
                </div>
                <div class="col-md-3">
                    <select id="statusFilter" class="form-select form-select-sm">
                        <option value="">Tất cả trạng thái</option>
                        <option value="overload">Quá tải</option>
                        <option value="busy">Bận</option>
                        <option value="normal">Bình thường</option>
                        <option value="free">Rảnh</option>
                    </select>
                </div>
                <div class="col-md-5 text-end">
                    <small class="text-muted">Tìm thấy <strong id="resultCount">0</strong> nhân viên</small>
                </div>
            </div>
        </div>
    </div>

    <!-- Workload Grid -->
    <div class="card">
        <div class="card-header bg-white">
            <h5 class="mb-0">
                <i class="bi bi-grid me-2"></i>
                Phân bổ công việc (mở = chưa Hoàn thành / Hủy)
                <span class="badge bg-danger ms-2" title="Quá tải: > ${overloadThreshold} công việc mở">
                    <i class="bi bi-exclamation-triangle me-1"></i>Quá tải > ${overloadThreshold}
                </span>
            </h5>
        </div>
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${empty teamMembers}">
                    <div class="text-center py-5">
                        <i class="bi bi-people text-muted" style="font-size:3rem;"></i>
                        <p class="text-muted mt-3">Không có nhân viên trong nhóm</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-hover mb-0" id="workloadTable">
                            <thead class="table-light">
                                <tr>
                                    <th style="min-width:200px;">Nhân viên</th>
                                    <th style="width:100px;" class="text-center">Công việc mở</th>
                                    <th>Phân bổ tải</th>
                                    <th class="text-center">Trạng thái</th>
                                    <th class="text-end">Xem</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="member" items="${teamMembers}">
                                    <c:set var="openCount" value="${openTaskCount[member.userId]}"/>
                                    <c:set var="isOverloaded" value="${openCount > overloadThreshold}"/>
                                    <tr class="${isOverloaded ? 'table-danger' : ''}"
                                        data-name="${fn:toLowerCase(member.firstName)} ${fn:toLowerCase(member.lastName)}"
                                        data-email="${fn:toLowerCase(member.email)}"
                                        data-status="${isOverloaded ? 'overload' : openCount > 3 ? 'busy' : openCount == 0 ? 'free' : 'normal'}">
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="avatar-sm ${isOverloaded ? 'bg-danger' : 'bg-primary'} rounded-circle d-flex align-items-center justify-content-center text-white">
                                                    ${fn:substring(member.firstName,0,1)}${fn:substring(member.lastName,0,1)}
                                                </div>
                                                <div>
                                                    <div class="fw-medium">${member.firstName} ${member.lastName}</div>
                                                    <small class="text-muted">${member.email}</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge ${isOverloaded ? 'bg-danger' : openCount > 3 ? 'bg-warning text-dark' : 'bg-success'} fs-6">
                                                ${openCount}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="progress flex-grow-1" style="height:12px;">
                                                    <div class="progress-bar ${isOverloaded ? 'bg-danger' : openCount > 3 ? 'bg-warning' : 'bg-success'}"
                                                         role="progressbar"
                                                         style="width:${openCount > 10 ? 100 : openCount * 10}%"
                                                         aria-valuenow="${openCount}" aria-valuemin="0" aria-valuemax="10">
                                                    </div>
                                                </div>
                                                <small class="text-muted text-nowrap">${openCount}/10</small>
                                            </div>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${isOverloaded}">
                                                    <span class="badge bg-danger">
                                                        <i class="bi bi-exclamation-triangle me-1"></i>Quá tải
                                                    </span>
                                                </c:when>
                                                <c:when test="${openCount > 3}">
                                                    <span class="badge bg-warning text-dark">Bận</span>
                                                </c:when>
                                                <c:when test="${openCount == 0}">
                                                    <span class="badge bg-secondary">Rảnh</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-success">Bình thường</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <a href="${pageContext.request.contextPath}/manager/task/list?source=workload&employee=${member.userId}"
                                               class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-eye me-1"></i>Xem việc
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <!-- No results message -->
                    <div id="noResults" class="text-center py-4 d-none">
                        <i class="bi bi-search text-muted" style="font-size:2rem;"></i>
                        <p class="text-muted mt-2 mb-0">Không tìm thấy nhân viên phù hợp</p>
                    </div>
                    <!-- Pagination -->
                    <div class="card-footer bg-white">
                        <nav>
                            <ul class="pagination justify-content-center mb-0" id="pagination"></ul>
                        </nav>
                        <p class="text-center text-muted small mb-0 mt-2" id="pageInfo"></p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<style>
    .avatar-sm {
        width: 36px;
        height: 36px;
        font-size: 0.8rem;
        font-weight: 600;
        flex-shrink: 0;
    }
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    var searchInput = document.getElementById('searchInput');
    var statusFilter = document.getElementById('statusFilter');
    var table = document.getElementById('workloadTable');
    if (!table) return;
    var allRows = Array.from(table.querySelectorAll('tbody tr'));
    var currentPage = 1;
    var PAGE_SIZE = 10;

    function filterAndPaginate() {
        var keyword = searchInput.value.trim().toLowerCase();
        var status = statusFilter.value;
        var filtered = allRows.filter(function(row) {
            var name = row.getAttribute('data-name') || '';
            var email = row.getAttribute('data-email') || '';
            var rowStatus = row.getAttribute('data-status') || '';
            var matchKeyword = !keyword || name.indexOf(keyword) !== -1 || email.indexOf(keyword) !== -1;
            var matchStatus = !status || rowStatus === status;
            return matchKeyword && matchStatus;
        });

        var totalPages = Math.max(1, Math.ceil(filtered.length / PAGE_SIZE));
        if (currentPage > totalPages) currentPage = totalPages;
        var start = (currentPage - 1) * PAGE_SIZE;

        allRows.forEach(function(r) { r.style.display = 'none'; });
        filtered.forEach(function(r, i) {
            r.style.display = (i >= start && i < start + PAGE_SIZE) ? '' : 'none';
        });

        document.getElementById('resultCount').textContent = filtered.length;
        document.getElementById('noResults').classList.toggle('d-none', filtered.length > 0);
        renderPagination(totalPages, filtered.length);
    }

    function renderPagination(totalPages, totalItems) {
        var pag = document.getElementById('pagination');
        var info = document.getElementById('pageInfo');
        pag.innerHTML = '';
        if (totalPages <= 1) { info.textContent = 'Tổng ' + totalItems + ' nhân viên'; return; }

        pag.innerHTML += '<li class="page-item ' + (currentPage === 1 ? 'disabled' : '') + '"><a class="page-link" href="#" data-page="' + (currentPage - 1) + '"><i class="bi bi-chevron-left"></i></a></li>';
        for (var i = 1; i <= totalPages; i++) {
            if (i === 1 || i === totalPages || (i >= currentPage - 2 && i <= currentPage + 2)) {
                pag.innerHTML += '<li class="page-item ' + (i === currentPage ? 'active' : '') + '"><a class="page-link" href="#" data-page="' + i + '">' + i + '</a></li>';
            }
        }
        pag.innerHTML += '<li class="page-item ' + (currentPage === totalPages ? 'disabled' : '') + '"><a class="page-link" href="#" data-page="' + (currentPage + 1) + '"><i class="bi bi-chevron-right"></i></a></li>';
        info.textContent = 'Trang ' + currentPage + ' / ' + totalPages + ' - Tổng ' + totalItems + ' nhân viên';

        pag.querySelectorAll('a[data-page]').forEach(function(a) {
            a.addEventListener('click', function(e) {
                e.preventDefault();
                var p = parseInt(this.getAttribute('data-page'));
                if (p >= 1 && p <= totalPages) { currentPage = p; filterAndPaginate(); }
            });
        });
    }

    searchInput.addEventListener('input', function() { currentPage = 1; filterAndPaginate(); });
    statusFilter.addEventListener('change', function() { currentPage = 1; filterAndPaginate(); });
    filterAndPaginate();
});
</script>
