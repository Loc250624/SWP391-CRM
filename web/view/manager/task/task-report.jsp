<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="container-fluid">
    <!-- Header -->
    <div class="mb-4">
        <h3 class="mb-1"><i class="bi bi-graph-up me-2"></i>Báo cáo Công việc</h3>
        <p class="text-muted mb-0">Thống kê và phân tích hiệu suất công việc của nhóm</p>
    </div>

    <!-- Overall Statistics -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <p class="text-muted mb-1">Tổng công việc</p>
                            <h3 class="mb-0">${overallStats.totalTasks}</h3>
                        </div>
                        <div class="bg-primary bg-opacity-10 p-3 rounded">
                            <i class="bi bi-list-task text-primary fs-4"></i>
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
                            <p class="text-muted mb-1">Hoàn thành</p>
                            <h3 class="mb-0 text-success">${overallStats.completedTasks}</h3>
                        </div>
                        <div class="bg-success bg-opacity-10 p-3 rounded">
                            <i class="bi bi-check-circle text-success fs-4"></i>
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
                            <p class="text-muted mb-1">Quá hạn</p>
                            <h3 class="mb-0 text-danger">${overallStats.overdueTasks}</h3>
                        </div>
                        <div class="bg-danger bg-opacity-10 p-3 rounded">
                            <i class="bi bi-exclamation-triangle text-danger fs-4"></i>
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
                            <p class="text-muted mb-1">Tỷ lệ hoàn thành</p>
                            <h3 class="mb-0 text-info">
                                <fmt:formatNumber value="${overallStats.completionRate}" pattern="#0.0"/>%
                            </h3>
                        </div>
                        <div class="bg-info bg-opacity-10 p-3 rounded">
                            <i class="bi bi-graph-up-arrow text-info fs-4"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Progress Overview -->
    <div class="row mb-4">
        <div class="col-lg-6">
            <div class="card">
                <div class="card-header bg-white">
                    <h5 class="mb-0"><i class="bi bi-pie-chart me-2"></i>Tổng quan công việc</h5>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <div class="d-flex justify-content-between mb-1">
                            <span>Hoàn thành</span>
                            <span class="text-success fw-bold">${overallStats.completedTasks}</span>
                        </div>
                        <div class="progress" style="height: 25px;">
                            <div class="progress-bar bg-success" role="progressbar"
                                 style="width: ${overallStats.totalTasks > 0 ? (overallStats.completedTasks * 100 / overallStats.totalTasks) : 0}%">
                                <fmt:formatNumber value="${overallStats.totalTasks > 0 ? (overallStats.completedTasks * 100 / overallStats.totalTasks) : 0}" pattern="#0.0"/>%
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <div class="d-flex justify-content-between mb-1">
                            <span>Đang thực hiện</span>
                            <span class="text-info fw-bold">${overallStats.inProgressTasks}</span>
                        </div>
                        <div class="progress" style="height: 25px;">
                            <div class="progress-bar bg-info" role="progressbar"
                                 style="width: ${overallStats.totalTasks > 0 ? (overallStats.inProgressTasks * 100 / overallStats.totalTasks) : 0}%">
                                <fmt:formatNumber value="${overallStats.totalTasks > 0 ? (overallStats.inProgressTasks * 100 / overallStats.totalTasks) : 0}" pattern="#0.0"/>%
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <div class="d-flex justify-content-between mb-1">
                            <span>Chờ xử lý</span>
                            <span class="text-warning fw-bold">${overallStats.pendingTasks}</span>
                        </div>
                        <div class="progress" style="height: 25px;">
                            <div class="progress-bar bg-warning" role="progressbar"
                                 style="width: ${overallStats.totalTasks > 0 ? (overallStats.pendingTasks * 100 / overallStats.totalTasks) : 0}%">
                                <fmt:formatNumber value="${overallStats.totalTasks > 0 ? (overallStats.pendingTasks * 100 / overallStats.totalTasks) : 0}" pattern="#0.0"/>%
                            </div>
                        </div>
                    </div>

                    <div>
                        <div class="d-flex justify-content-between mb-1">
                            <span>Quá hạn</span>
                            <span class="text-danger fw-bold">${overallStats.overdueTasks}</span>
                        </div>
                        <div class="progress" style="height: 25px;">
                            <div class="progress-bar bg-danger" role="progressbar"
                                 style="width: ${overallStats.totalTasks > 0 ? (overallStats.overdueTasks * 100 / overallStats.totalTasks) : 0}%">
                                <fmt:formatNumber value="${overallStats.totalTasks > 0 ? (overallStats.overdueTasks * 100 / overallStats.totalTasks) : 0}" pattern="#0.0"/>%
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-6">
            <div class="card">
                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="bi bi-exclamation-triangle me-2"></i>Công việc quá hạn</h5>
                    <div class="input-group input-group-sm" style="width: 200px;">
                        <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
                        <input type="text" id="overdueSearch" class="form-control" placeholder="Tìm công việc...">
                    </div>
                </div>
                <div class="card-body p-0" style="max-height: 400px; overflow-y: auto;">
                    <c:choose>
                        <c:when test="${empty overdueTasks}">
                            <div class="text-center py-4">
                                <i class="bi bi-check-circle text-success" style="font-size: 3rem;"></i>
                                <p class="text-muted mt-3">Không có công việc quá hạn</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="list-group list-group-flush" id="overdueList">
                                <c:forEach var="task" items="${overdueTasks}">
                                    <a href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}"
                                       class="list-group-item list-group-item-action overdue-item"
                                       data-search="${fn:toLowerCase(task.title)}">
                                        <div class="d-flex w-100 justify-content-between">
                                            <h6 class="mb-1">${task.title}</h6>
                                            <small class="text-danger">
                                                ${fn:substring(task.dueDate, 8, 10)}/${fn:substring(task.dueDate, 5, 7)}/${fn:substring(task.dueDate, 0, 4)}
                                            </small>
                                        </div>
                                        <c:forEach var="user" items="${teamMembers}">
                                            <c:if test="${user.userId == task.assignedTo}">
                                                <p class="mb-1 small text-muted">${user.firstName} ${user.lastName}</p>
                                            </c:if>
                                        </c:forEach>
                                    </a>
                                </c:forEach>
                            </div>
                            <div id="overdueNoResults" class="text-center py-3 d-none">
                                <small class="text-muted">Không tìm thấy</small>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- Employee Performance -->
    <div class="card">
        <div class="card-header bg-white">
            <div class="d-flex justify-content-between align-items-center">
                <h5 class="mb-0"><i class="bi bi-people me-2"></i>Hiệu suất của nhân viên</h5>
                <div class="input-group input-group-sm" style="width: 250px;">
                    <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
                    <input type="text" id="empSearch" class="form-control" placeholder="Tìm nhân viên...">
                </div>
            </div>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0" id="empTable">
                    <thead class="table-light">
                        <tr>
                            <th>Nhân viên</th>
                            <th class="text-center">Tổng số</th>
                            <th class="text-center">Hoàn thành</th>
                            <th class="text-center">Đang làm</th>
                            <th class="text-center">Chờ xử lý</th>
                            <th class="text-center">Bị quá hạn</th>
                            <th class="text-center">Tỷ lệ hoàn thành</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="member" items="${teamMembers}">
                            <c:set var="stats" value="${employeeStats[member.userId]}" />
                            <tr data-name="${fn:toLowerCase(member.firstName)} ${fn:toLowerCase(member.lastName)}"
                                data-email="${fn:toLowerCase(member.email)}">
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="avatar-sm bg-primary rounded-circle d-flex align-items-center justify-content-center text-white me-2">
                                            ${fn:substring(member.firstName, 0, 1)}${fn:substring(member.lastName, 0, 1)}
                                        </div>
                                        <div>
                                            <div class="fw-medium">${member.firstName} ${member.lastName}</div>
                                            <small class="text-muted">${member.email}</small>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-center fw-bold">${stats.totalTasks}</td>
                                <td class="text-center">
                                    <span class="badge bg-success">${stats.completedTasks}</span>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-info">${stats.inProgressTasks}</span>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-warning">${stats.pendingTasks}</span>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-danger">${stats.overdueTasks}</span>
                                </td>
                                <td class="text-center">
                                    <div class="progress" style="height: 20px; min-width: 100px;">
                                        <div class="progress-bar bg-success" role="progressbar"
                                             style="width: ${stats.completionRate}%">
                                            <fmt:formatNumber value="${stats.completionRate}" pattern="#0.0"/>%
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <div id="empNoResults" class="text-center py-4 d-none">
                <i class="bi bi-search text-muted" style="font-size:2rem;"></i>
                <p class="text-muted mt-2 mb-0">Không tìm thấy nhân viên phù hợp</p>
            </div>
        </div>
        <div class="card-footer bg-white">
            <nav><ul class="pagination justify-content-center mb-0" id="empPagination"></ul></nav>
            <p class="text-center text-muted small mb-0 mt-2" id="empPageInfo"></p>
        </div>
    </div>
</div>

<style>
    .avatar-sm {
        width: 32px;
        height: 32px;
        font-size: 0.75rem;
        font-weight: 600;
    }
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // ── Overdue search ──
    var overdueSearch = document.getElementById('overdueSearch');
    if (overdueSearch) {
        overdueSearch.addEventListener('input', function() {
            var kw = this.value.trim().toLowerCase();
            var items = document.querySelectorAll('.overdue-item');
            var found = 0;
            items.forEach(function(item) {
                var match = !kw || (item.getAttribute('data-search') || '').indexOf(kw) !== -1;
                item.style.display = match ? '' : 'none';
                if (match) found++;
            });
            var noRes = document.getElementById('overdueNoResults');
            if (noRes) noRes.classList.toggle('d-none', found > 0);
        });
    }

    // ── Employee table search + pagination ──
    var empSearch = document.getElementById('empSearch');
    var empTable = document.getElementById('empTable');
    if (!empTable) return;
    var empRows = Array.from(empTable.querySelectorAll('tbody tr'));
    var empPage = 1;
    var PAGE_SIZE = 10;

    function empFilter() {
        var kw = empSearch.value.trim().toLowerCase();
        var filtered = empRows.filter(function(r) {
            var name = r.getAttribute('data-name') || '';
            var email = r.getAttribute('data-email') || '';
            return !kw || name.indexOf(kw) !== -1 || email.indexOf(kw) !== -1;
        });
        var totalPages = Math.max(1, Math.ceil(filtered.length / PAGE_SIZE));
        if (empPage > totalPages) empPage = totalPages;
        var start = (empPage - 1) * PAGE_SIZE;

        empRows.forEach(function(r) { r.style.display = 'none'; });
        filtered.forEach(function(r, i) { r.style.display = (i >= start && i < start + PAGE_SIZE) ? '' : 'none'; });

        document.getElementById('empNoResults').classList.toggle('d-none', filtered.length > 0);
        renderPag('empPagination', 'empPageInfo', totalPages, filtered.length, empPage, function(p) { empPage = p; empFilter(); });
    }

    function renderPag(pagId, infoId, totalPages, total, curPage, onClick) {
        var pag = document.getElementById(pagId);
        var info = document.getElementById(infoId);
        pag.innerHTML = '';
        if (totalPages <= 1) { info.textContent = 'Tổng ' + total + ' nhân viên'; return; }
        pag.innerHTML += '<li class="page-item ' + (curPage === 1 ? 'disabled' : '') + '"><a class="page-link" href="#" data-p="' + (curPage-1) + '"><i class="bi bi-chevron-left"></i></a></li>';
        for (var i = 1; i <= totalPages; i++) {
            if (i === 1 || i === totalPages || (i >= curPage-2 && i <= curPage+2))
                pag.innerHTML += '<li class="page-item ' + (i===curPage?'active':'') + '"><a class="page-link" href="#" data-p="'+i+'">'+i+'</a></li>';
        }
        pag.innerHTML += '<li class="page-item ' + (curPage===totalPages?'disabled':'') + '"><a class="page-link" href="#" data-p="'+(curPage+1)+'"><i class="bi bi-chevron-right"></i></a></li>';
        info.textContent = 'Trang ' + curPage + ' / ' + totalPages + ' - Tổng ' + total + ' nhân viên';
        pag.querySelectorAll('a[data-p]').forEach(function(a) {
            a.addEventListener('click', function(e) {
                e.preventDefault();
                var p = parseInt(this.getAttribute('data-p'));
                if (p >= 1 && p <= totalPages) onClick(p);
            });
        });
    }

    empSearch.addEventListener('input', function() { empPage = 1; empFilter(); });
    empFilter();
});
</script>
