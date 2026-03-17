<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">Manager Dashboard</h4>
        <p class="text-muted mb-0">Tong quan hieu suat phong ban</p>
    </div>
    <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/manager/task/kanban" class="btn btn-outline-success btn-sm"><i class="bi bi-kanban me-1"></i>Kanban</a>
        <a href="${pageContext.request.contextPath}/manager/task/report" class="btn btn-outline-secondary btn-sm"><i class="bi bi-bar-chart-line me-1"></i>Bao cao</a>
    </div>
</div>

<!-- === KPI CARDS ROW 1: Task Overview === -->
<div class="row g-3 mb-4">
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100" style="border-left: 4px solid #0d6efd !important;">
            <div class="card-body py-3">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <small class="text-muted text-uppercase fw-semibold" style="font-size: 11px;">Tong cong viec</small>
                        <h3 class="mb-0 fw-bold">${totalTasks}</h3>
                        <small class="text-muted"><i class="bi bi-people me-1"></i>${teamSize} thanh vien</small>
                    </div>
                    <div class="bg-primary bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center" style="width: 48px; height: 48px;">
                        <i class="bi bi-list-task text-primary fs-4"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100" style="border-left: 4px solid #198754 !important;">
            <div class="card-body py-3">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <small class="text-muted text-uppercase fw-semibold" style="font-size: 11px;">Hoan thanh</small>
                        <h3 class="mb-0 fw-bold text-success">${completedTasks}</h3>
                        <small class="text-muted">Ty le: <span class="fw-bold text-success">${completionRate}%</span></small>
                    </div>
                    <div class="bg-success bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center" style="width: 48px; height: 48px;">
                        <i class="bi bi-check-circle text-success fs-4"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100" style="border-left: 4px solid #ffc107 !important;">
            <div class="card-body py-3">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <small class="text-muted text-uppercase fw-semibold" style="font-size: 11px;">Dang thuc hien</small>
                        <h3 class="mb-0 fw-bold text-warning">${inProgressTasks}</h3>
                        <small class="text-muted">Cho xu ly: <span class="fw-bold">${pendingTasks}</span></small>
                    </div>
                    <div class="bg-warning bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center" style="width: 48px; height: 48px;">
                        <i class="bi bi-clock text-warning fs-4"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100" style="border-left: 4px solid #dc3545 !important;">
            <div class="card-body py-3">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <small class="text-muted text-uppercase fw-semibold" style="font-size: 11px;">Qua han</small>
                        <h3 class="mb-0 fw-bold text-danger">${overdueTasks}</h3>
                        <small class="text-danger fw-semibold">Can xu ly ngay</small>
                    </div>
                    <div class="bg-danger bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center" style="width: 48px; height: 48px;">
                        <i class="bi bi-exclamation-triangle text-danger fs-4"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- === ROW 2: Lead & Customer Overview + Pie Chart === -->
<div class="row g-3 mb-4">
    <!-- Lead Overview -->
    <div class="col-lg-4">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0 d-flex justify-content-between align-items-center">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-person-lines-fill me-2 text-info"></i>Lead</h6>
                <a href="${pageContext.request.contextPath}/manager/crm/leads" class="btn btn-sm btn-link text-decoration-none p-0">Xem tat ca <i class="bi bi-chevron-right"></i></a>
            </div>
            <div class="card-body pt-0">
                <div class="row g-2 mb-3">
                    <div class="col-6">
                        <div class="text-center p-3 rounded-3" style="background: #f0f9ff;">
                            <div class="fs-3 fw-bold text-info">${unassignedLeads}</div>
                            <small class="text-muted">Chua giao</small>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="text-center p-3 rounded-3" style="background: #f0fdf4;">
                            <div class="fs-3 fw-bold text-success">${assignedLeads}</div>
                            <small class="text-muted">Da giao</small>
                        </div>
                    </div>
                </div>
                <div>
                    <div class="d-flex justify-content-between mb-1">
                        <small class="fw-semibold">Ty le phan cong</small>
                        <c:set var="totalLeadSum" value="${unassignedLeads + assignedLeads}" />
                        <c:set var="assignRate" value="${totalLeadSum > 0 ? Math.round(assignedLeads * 1000.0 / totalLeadSum) / 10.0 : 0}" />
                        <small class="fw-bold">${assignRate}%</small>
                    </div>
                    <div class="progress" style="height: 8px;">
                        <div class="progress-bar bg-success" style="width: ${assignRate}%;"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Customer Overview -->
    <div class="col-lg-4">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0 d-flex justify-content-between align-items-center">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-people me-2 text-primary"></i>Customer</h6>
                <a href="${pageContext.request.contextPath}/manager/crm/customers" class="btn btn-sm btn-link text-decoration-none p-0">Xem tat ca <i class="bi bi-chevron-right"></i></a>
            </div>
            <div class="card-body pt-0">
                <div class="row g-2 mb-3">
                    <div class="col-6">
                        <div class="text-center p-3 rounded-3" style="background: #f0f9ff;">
                            <div class="fs-3 fw-bold text-info">${unassignedCustomers}</div>
                            <small class="text-muted">Chua giao</small>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="text-center p-3 rounded-3" style="background: #f0fdf4;">
                            <div class="fs-3 fw-bold text-success">${assignedCustomers}</div>
                            <small class="text-muted">Da giao</small>
                        </div>
                    </div>
                </div>
                <div>
                    <div class="d-flex justify-content-between mb-1">
                        <small class="fw-semibold">Ty le phan cong</small>
                        <c:set var="custAssignRate" value="${totalCustomers > 0 ? Math.round(assignedCustomers * 1000.0 / totalCustomers) / 10.0 : 0}" />
                        <small class="fw-bold text-success">${custAssignRate}%</small>
                    </div>
                    <div class="progress" style="height: 8px;">
                        <div class="progress-bar bg-primary" style="width: ${custAssignRate}%;"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Task Status Pie Chart -->
    <div class="col-lg-4">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-pie-chart me-2 text-secondary"></i>Phan bo trang thai</h6>
            </div>
            <div class="card-body d-flex align-items-center justify-content-center">
                <div class="position-relative">
                    <canvas id="taskStatusPieChart" style="max-width: 200px; max-height: 200px;"></canvas>
                    <div class="position-absolute top-50 start-50 translate-middle text-center">
                        <div class="fs-4 fw-bold">${completionRate}%</div>
                        <small class="text-muted" style="font-size: 11px;">Hoan thanh</small>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- === ROW 3: Bar Chart + Productivity Chart === -->
<div class="row g-3 mb-4">
    <!-- Bar Chart: Per-employee task breakdown -->
    <div class="col-lg-8">
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-bar-chart me-2"></i>Cong viec theo nhan vien</h6>
                <small class="text-muted">Phan bo trang thai cong viec cua tung thanh vien</small>
            </div>
            <div class="card-body">
                <canvas id="employeeTaskBarChart" height="300"></canvas>
            </div>
        </div>
    </div>

    <!-- Line Chart: Productivity -->
    <div class="col-lg-4">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-graph-up me-2"></i>Diem hieu suat</h6>
                <small class="text-muted">Productivity score theo nhan vien</small>
            </div>
            <div class="card-body">
                <canvas id="productivityLineChart" height="280"></canvas>
            </div>
        </div>
    </div>
</div>

<!-- === ROW 4: Overdue Tasks Table === -->
<div class="card border-0 shadow-sm mb-4">
    <div class="card-header bg-transparent border-0 d-flex justify-content-between align-items-center">
        <div>
            <h6 class="mb-0 fw-semibold"><i class="bi bi-exclamation-triangle me-2 text-danger"></i>Cong viec qua han</h6>
            <small class="text-muted">${overdueCount} cong viec can xu ly</small>
        </div>
        <a href="${pageContext.request.contextPath}/manager/task/list?status=overdue" class="btn btn-sm btn-outline-danger">Xem tat ca <i class="bi bi-chevron-right"></i></a>
    </div>
    <div class="card-body p-0">
        <c:choose>
            <c:when test="${not empty recentOverdue}">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-3">Ma cong viec</th>
                                <th>Tieu de</th>
                                <th>Nguoi thuc hien</th>
                                <th class="text-center">Do uu tien</th>
                                <th class="text-center">Han chot</th>
                                <th class="text-center">Trang thai</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="task" items="${recentOverdue}">
                                <tr>
                                    <td class="ps-3">
                                        <span class="fw-semibold text-primary">${task.taskCode}</span>
                                    </td>
                                    <td>
                                        <div class="fw-medium text-truncate" style="max-width: 250px;" title="${task.title}">${task.title}</div>
                                    </td>
                                    <td>
                                        <c:set var="assigneeName" value="${userNameMap[task.assignedTo]}" />
                                        <c:choose>
                                            <c:when test="${not empty assigneeName}">
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="bg-primary bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center" style="width: 28px; height: 28px;">
                                                        <small class="fw-bold text-primary">${assigneeName.substring(0,1)}</small>
                                                    </div>
                                                    <span>${assigneeName}</span>
                                                </div>
                                            </c:when>
                                            <c:otherwise><span class="text-muted fst-italic">Chua giao</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${task.priority == 0}"><span class="badge bg-secondary">Thap</span></c:when>
                                            <c:when test="${task.priority == 1}"><span class="badge bg-info">Binh thuong</span></c:when>
                                            <c:when test="${task.priority == 2}"><span class="badge bg-warning text-dark">Cao</span></c:when>
                                            <c:when test="${task.priority == 3}"><span class="badge bg-danger">Khan cap</span></c:when>
                                            <c:otherwise><span class="badge bg-secondary">-</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <small class="text-danger fw-semibold">
                                            <c:choose>
                                                <c:when test="${not empty task.dueDate}">
                                                    <i class="bi bi-calendar-x me-1"></i>${task.dueDate.toString().substring(0, 10)}
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </small>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${task.status == 0}"><span class="badge bg-secondary">Cho xu ly</span></c:when>
                                            <c:when test="${task.status == 1}"><span class="badge bg-primary">Dang lam</span></c:when>
                                            <c:otherwise><span class="badge bg-secondary">${task.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center text-muted py-4">
                    <i class="bi bi-check-circle fs-1 text-success"></i>
                    <p class="mt-2 mb-0">Khong co cong viec qua han</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- === ROW 5: Quick Actions + Summary === -->
<div class="row g-3 mb-4">
    <div class="col-lg-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-lightning me-2 text-warning"></i>Thao tac nhanh</h6>
            </div>
            <div class="card-body pt-0">
                <div class="row g-2">
                    <div class="col-6">
                        <a href="${pageContext.request.contextPath}/manager/task/form?action=create" class="btn btn-success btn-sm w-100 text-start py-2">
                            <i class="bi bi-plus-lg me-2"></i>Tao cong viec
                        </a>
                    </div>
                    <div class="col-6">
                        <a href="${pageContext.request.contextPath}/manager/crm/leads" class="btn btn-outline-info btn-sm w-100 text-start py-2">
                            <i class="bi bi-person-lines-fill me-2"></i>Quan ly Lead
                        </a>
                    </div>
                    <div class="col-6">
                        <a href="${pageContext.request.contextPath}/manager/crm/customers" class="btn btn-outline-primary btn-sm w-100 text-start py-2">
                            <i class="bi bi-people me-2"></i>Quan ly Customer
                        </a>
                    </div>
                    <div class="col-6">
                        <a href="${pageContext.request.contextPath}/manager/performance" class="btn btn-outline-warning btn-sm w-100 text-start py-2">
                            <i class="bi bi-award me-2"></i>Hieu suat KPI
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-lg-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-clipboard-data me-2 text-primary"></i>Tom tat phong ban</h6>
            </div>
            <div class="card-body pt-0">
                <div class="d-flex flex-column gap-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="text-muted"><i class="bi bi-people-fill me-2"></i>Tong thanh vien</span>
                        <span class="fw-bold">${teamSize}</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="text-muted"><i class="bi bi-list-task me-2"></i>Tong cong viec</span>
                        <span class="fw-bold">${totalTasks}</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="text-muted"><i class="bi bi-check-circle me-2"></i>Hoan thanh</span>
                        <span class="fw-bold text-success">${completedTasks}</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="text-muted"><i class="bi bi-arrow-repeat me-2"></i>Dang thuc hien</span>
                        <span class="fw-bold text-warning">${inProgressTasks}</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="text-muted"><i class="bi bi-exclamation-circle me-2"></i>Qua han</span>
                        <span class="fw-bold text-danger">${overdueTasks}</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="text-muted"><i class="bi bi-graph-up-arrow me-2"></i>Ty le hoan thanh</span>
                        <div class="d-flex align-items-center gap-2">
                            <div class="progress" style="width: 80px; height: 6px;">
                                <div class="progress-bar bg-success" style="width: ${completionRate}%;"></div>
                            </div>
                            <span class="fw-bold text-success">${completionRate}%</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {

    // ── 1. Doughnut Chart: Task Status Distribution ──
    var pieCtx = document.getElementById('taskStatusPieChart');
    if (pieCtx) {
        new Chart(pieCtx, {
            type: 'doughnut',
            data: {
                labels: ['Hoan thanh', 'Dang lam', 'Cho xu ly', 'Qua han', 'Da huy'],
                datasets: [{
                    data: [${chartCompleted}, ${chartInProgress}, ${chartPending}, ${chartOverdue}, ${chartCancelled}],
                    backgroundColor: ['#198754', '#0d6efd', '#6c757d', '#dc3545', '#adb5bd'],
                    borderWidth: 2,
                    borderColor: '#fff',
                    hoverOffset: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                cutout: '65%',
                plugins: {
                    legend: {
                        display: true,
                        position: 'bottom',
                        labels: { boxWidth: 10, padding: 6, font: { size: 10 } }
                    }
                }
            }
        });
    }

    // ── 2. Bar Chart: Per-employee Task Breakdown (Stacked) ──
    var barCtx = document.getElementById('employeeTaskBarChart');
    if (barCtx) {
        var empNames = ${empNamesJson};
        new Chart(barCtx, {
            type: 'bar',
            data: {
                labels: empNames,
                datasets: [
                    {
                        label: 'Hoan thanh',
                        data: ${empCompletedJson},
                        backgroundColor: '#198754',
                        borderRadius: 2
                    },
                    {
                        label: 'Dang lam',
                        data: ${empInProgressJson},
                        backgroundColor: '#0d6efd',
                        borderRadius: 2
                    },
                    {
                        label: 'Cho xu ly',
                        data: ${empPendingJson},
                        backgroundColor: '#6c757d',
                        borderRadius: 2
                    },
                    {
                        label: 'Qua han',
                        data: ${empOverdueJson},
                        backgroundColor: '#dc3545',
                        borderRadius: 2
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    x: {
                        stacked: true,
                        grid: { display: false },
                        ticks: { font: { size: 11 } }
                    },
                    y: {
                        stacked: true,
                        beginAtZero: true,
                        ticks: { stepSize: 1, font: { size: 11 } },
                        grid: { color: 'rgba(0,0,0,0.05)' }
                    }
                },
                plugins: {
                    legend: {
                        position: 'top',
                        labels: { boxWidth: 12, padding: 12, font: { size: 11 } }
                    },
                    tooltip: {
                        callbacks: {
                            footer: function(items) {
                                var total = 0;
                                items.forEach(function(item) { total += item.parsed.y; });
                                return 'Tong: ' + total;
                            }
                        }
                    }
                }
            }
        });
    }

    // ── 3. Line Chart: Productivity Score ──
    var lineCtx = document.getElementById('productivityLineChart');
    if (lineCtx) {
        var empNames = ${empNamesJson};
        var productivityData = ${empProductivityJson};
        new Chart(lineCtx, {
            type: 'line',
            data: {
                labels: empNames,
                datasets: [{
                    label: 'Diem hieu suat',
                    data: productivityData,
                    borderColor: '#198754',
                    backgroundColor: 'rgba(25, 135, 84, 0.1)',
                    borderWidth: 2,
                    pointBackgroundColor: '#198754',
                    pointBorderColor: '#fff',
                    pointBorderWidth: 2,
                    pointRadius: 5,
                    pointHoverRadius: 7,
                    fill: true,
                    tension: 0.3
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    x: {
                        grid: { display: false },
                        ticks: { font: { size: 10 }, maxRotation: 45 }
                    },
                    y: {
                        beginAtZero: true,
                        max: 100,
                        ticks: { stepSize: 20, font: { size: 11 } },
                        grid: { color: 'rgba(0,0,0,0.05)' }
                    }
                },
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: function(ctx) {
                                return 'Diem: ' + ctx.parsed.y;
                            }
                        }
                    }
                }
            }
        });
    }

});
</script>
