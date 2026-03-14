<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">Manager Dashboard</h4>
        <p class="text-muted mb-0">Tổng quan hiệu suất phòng ban</p>
    </div>
    <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/manager/task/kanban" class="btn btn-outline-success btn-sm"><i class="bi bi-kanban me-1"></i>Kanban</a>
        <a href="${pageContext.request.contextPath}/manager/task/report" class="btn btn-outline-secondary btn-sm"><i class="bi bi-bar-chart-line me-1"></i>Báo cáo</a>
    </div>
</div>

<!-- === KPI CARDS === -->
<div class="row g-3 mb-4">
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center mb-2">
                    <div class="bg-primary bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-list-task text-primary fs-4"></i></div>
                    <div>
                        <small class="text-muted">Tổng công việc</small>
                        <h4 class="mb-0 fw-bold">${totalTasks}</h4>
                    </div>
                </div>
                <small class="text-muted"><i class="bi bi-people me-1"></i>${teamSize} thành viên</small>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center mb-2">
                    <div class="bg-success bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-check-circle text-success fs-4"></i></div>
                    <div>
                        <small class="text-muted">Hoàn thành</small>
                        <h4 class="mb-0 fw-bold text-success">${completedTasks}</h4>
                    </div>
                </div>
                <small class="text-muted">Tỷ lệ: <span class="fw-bold text-success">${completionRate}%</span></small>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center mb-2">
                    <div class="bg-warning bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-clock text-warning fs-4"></i></div>
                    <div>
                        <small class="text-muted">Đang thực hiện</small>
                        <h4 class="mb-0 fw-bold text-warning">${inProgressTasks}</h4>
                    </div>
                </div>
                <small class="text-muted">Chờ xử lý: <span class="fw-bold">${pendingTasks}</span></small>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center mb-2">
                    <div class="bg-danger bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-exclamation-triangle text-danger fs-4"></i></div>
                    <div>
                        <small class="text-muted">Quá hạn</small>
                        <h4 class="mb-0 fw-bold text-danger">${overdueTasks}</h4>
                    </div>
                </div>
                <small class="text-muted">Cần xử lý ngay</small>
            </div>
        </div>
    </div>
</div>

<!-- === ROW 2: Lead & SLA Overview === -->
<div class="row g-3 mb-4">
    <div class="col-lg-4">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0 d-flex justify-content-between align-items-center">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-person-lines-fill me-2"></i>Lead</h6>
                <a href="${pageContext.request.contextPath}/manager/crm/leads" class="btn btn-sm btn-link text-decoration-none p-0">Xem tất cả</a>
            </div>
            <div class="card-body">
                <div class="row g-2 mb-3">
                    <div class="col-6">
                        <div class="text-center p-3 bg-light rounded-3">
                            <div class="fs-3 fw-bold text-info">${unassignedLeads}</div>
                            <small class="text-muted">Chưa giao</small>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="text-center p-3 bg-light rounded-3">
                            <div class="fs-3 fw-bold text-success">${assignedLeads}</div>
                            <small class="text-muted">Đã giao</small>
                        </div>
                    </div>
                </div>
                <div>
                    <div class="d-flex justify-content-between mb-1">
                        <small class="fw-semibold">Tỷ lệ phân công</small>
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

    <div class="col-lg-4">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-shield-check me-2"></i>SLA</h6>
            </div>
            <div class="card-body">
                <div class="row g-2 mb-3">
                    <div class="col-4">
                        <div class="text-center p-3 bg-light rounded-3">
                            <div class="fs-3 fw-bold text-primary">${slaTotal}</div>
                            <small class="text-muted">Tổng</small>
                        </div>
                    </div>
                    <div class="col-4">
                        <div class="text-center p-3 bg-light rounded-3">
                            <div class="fs-3 fw-bold text-success">${slaOk}</div>
                            <small class="text-muted">Đạt</small>
                        </div>
                    </div>
                    <div class="col-4">
                        <div class="text-center p-3 bg-light rounded-3">
                            <div class="fs-3 fw-bold text-danger">${slaBreached}</div>
                            <small class="text-muted">Vi phạm</small>
                        </div>
                    </div>
                </div>
                <div>
                    <div class="d-flex justify-content-between mb-1">
                        <small class="fw-semibold">Tỷ lệ SLA đạt</small>
                        <c:set var="slaRate" value="${slaTotal > 0 ? Math.round(slaOk * 1000.0 / slaTotal) / 10.0 : 0}" />
                        <small class="fw-bold text-success">${slaRate}%</small>
                    </div>
                    <div class="progress" style="height: 8px;">
                        <div class="progress-bar bg-success" style="width: ${slaRate}%;"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Task Status Pie Chart -->
    <div class="col-lg-4">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-pie-chart me-2"></i>Phân bố trạng thái</h6>
            </div>
            <div class="card-body d-flex align-items-center justify-content-center">
                <div class="position-relative">
                    <canvas id="taskStatusPieChart" style="max-width: 200px; max-height: 200px;"></canvas>
                    <div class="position-absolute top-50 start-50 translate-middle text-center">
                        <div class="fs-4 fw-bold">${completionRate}%</div>
                        <small class="text-muted" style="font-size: 11px;">Hoàn thành</small>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- === ROW 3: Bar Chart + Line Chart === -->
<div class="row g-3 mb-4">
    <!-- Bar Chart: Per-employee task breakdown -->
    <div class="col-lg-8">
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-bar-chart me-2"></i>Công việc theo nhân viên</h6>
                <small class="text-muted">Phân bổ trạng thái công việc của từng thành viên</small>
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
                <h6 class="mb-0 fw-semibold"><i class="bi bi-graph-up me-2"></i>Điểm hiệu suất</h6>
                <small class="text-muted">Productivity score theo nhân viên</small>
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
            <h6 class="mb-0 fw-semibold"><i class="bi bi-exclamation-triangle me-2 text-danger"></i>Công việc quá hạn</h6>
            <small class="text-muted">${overdueCount} công việc cần xử lý</small>
        </div>
        <a href="${pageContext.request.contextPath}/manager/task/list?status=overdue" class="btn btn-sm btn-outline-danger">Xem tất cả <i class="bi bi-chevron-right"></i></a>
    </div>
    <div class="card-body p-0">
        <c:choose>
            <c:when test="${not empty recentOverdue}">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-3">Mã công việc</th>
                                <th>Tiêu đề</th>
                                <th>Người thực hiện</th>
                                <th class="text-center">Độ ưu tiên</th>
                                <th class="text-center">Hạn chót</th>
                                <th class="text-center">Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="task" items="${recentOverdue}">
                                <tr>
                                    <td class="ps-3">
                                        <span class="fw-semibold text-primary">${task.taskCode}</span>
                                    </td>
                                    <td>
                                        <div class="fw-medium">${task.title}</div>
                                    </td>
                                    <td>
                                        <c:set var="assigneeName" value="${userNameMap[task.assigneeId]}" />
                                        <c:choose>
                                            <c:when test="${not empty assigneeName}">
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="bg-secondary bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center" style="width: 28px; height: 28px;">
                                                        <small class="fw-bold text-secondary">${assigneeName.substring(0,1)}</small>
                                                    </div>
                                                    <span>${assigneeName}</span>
                                                </div>
                                            </c:when>
                                            <c:otherwise><span class="text-muted">Chưa giao</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${task.priority == 0}"><span class="badge bg-secondary">Thấp</span></c:when>
                                            <c:when test="${task.priority == 1}"><span class="badge bg-info">Bình thường</span></c:when>
                                            <c:when test="${task.priority == 2}"><span class="badge bg-warning text-dark">Cao</span></c:when>
                                            <c:when test="${task.priority == 3}"><span class="badge bg-danger">Khẩn cấp</span></c:when>
                                            <c:otherwise><span class="badge bg-secondary">-</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <small class="text-danger fw-semibold">
                                            <c:choose>
                                                <c:when test="${not empty task.dueDate}">${task.dueDate.toString().substring(0, 10)}</c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </small>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${task.status == 0}"><span class="badge bg-secondary">Chờ xử lý</span></c:when>
                                            <c:when test="${task.status == 1}"><span class="badge bg-primary">Đang làm</span></c:when>
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
                    <p class="mt-2 mb-0">Không có công việc quá hạn</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- === ROW 5: Quick Actions === -->
<div class="row g-3 mb-4">
    <div class="col-lg-6">
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-lightning me-2"></i>Thao tác nhanh</h6>
            </div>
            <div class="card-body pt-0">
                <div class="d-grid gap-2">
                    <a href="${pageContext.request.contextPath}/manager/task/form?action=create" class="btn btn-success btn-sm text-start"><i class="bi bi-plus-lg me-2"></i>Tạo công việc mới</a>
                    <a href="${pageContext.request.contextPath}/manager/crm/leads" class="btn btn-outline-info btn-sm text-start"><i class="bi bi-person-lines-fill me-2"></i>Quản lý Lead</a>
                    <a href="${pageContext.request.contextPath}/manager/crm/customers" class="btn btn-outline-primary btn-sm text-start"><i class="bi bi-people me-2"></i>Quản lý Customer</a>
                    <a href="${pageContext.request.contextPath}/manager/performance" class="btn btn-outline-warning btn-sm text-start"><i class="bi bi-award me-2"></i>Hiệu suất KPI</a>
                </div>
            </div>
        </div>
    </div>
    <div class="col-lg-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-info-circle me-2"></i>Tóm tắt</h6>
            </div>
            <div class="card-body pt-0">
                <div class="d-flex flex-column gap-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="text-muted">Tổng thành viên</span>
                        <span class="fw-bold">${teamSize}</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="text-muted">Tổng công việc</span>
                        <span class="fw-bold">${totalTasks}</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="text-muted">Hoàn thành</span>
                        <span class="fw-bold text-success">${completedTasks}</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="text-muted">Đang thực hiện</span>
                        <span class="fw-bold text-warning">${inProgressTasks}</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="text-muted">Quá hạn</span>
                        <span class="fw-bold text-danger">${overdueTasks}</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="text-muted">Tỷ lệ hoàn thành</span>
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

    // ── 1. Pie/Doughnut Chart: Task Status Distribution ──
    var pieCtx = document.getElementById('taskStatusPieChart');
    if (pieCtx) {
        new Chart(pieCtx, {
            type: 'doughnut',
            data: {
                labels: ['Hoàn thành', 'Đang làm', 'Chờ xử lý', 'Quá hạn', 'Đã hủy'],
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
                        labels: { boxWidth: 12, padding: 8, font: { size: 11 } }
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
                        label: 'Hoàn thành',
                        data: ${empCompletedJson},
                        backgroundColor: '#198754',
                        borderRadius: 2
                    },
                    {
                        label: 'Đang làm',
                        data: ${empInProgressJson},
                        backgroundColor: '#0d6efd',
                        borderRadius: 2
                    },
                    {
                        label: 'Chờ xử lý',
                        data: ${empPendingJson},
                        backgroundColor: '#6c757d',
                        borderRadius: 2
                    },
                    {
                        label: 'Quá hạn',
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
                                return 'Tổng: ' + total;
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
                    label: 'Điểm hiệu suất',
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
                                return 'Điểm: ' + ctx.parsed.y;
                            }
                        }
                    }
                }
            }
        });
    }

});
</script>
