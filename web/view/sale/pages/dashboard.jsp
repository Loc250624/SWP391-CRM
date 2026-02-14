<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">Sales Dashboard</h4>
        <p class="text-muted mb-0">Tong quan hoat dong ban hang cua ban</p>
    </div>
    <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/sale/opportunity/kanban" class="btn btn-outline-primary btn-sm"><i class="bi bi-kanban me-1"></i>Kanban</a>
        <a href="${pageContext.request.contextPath}/sale/opportunity/forecast" class="btn btn-outline-secondary btn-sm"><i class="bi bi-graph-up-arrow me-1"></i>Forecast</a>
    </div>
</div>

<!-- === KPI CARDS === -->
<div class="row g-3 mb-4">
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center mb-2">
                    <div class="bg-primary bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-funnel text-primary fs-4"></i></div>
                    <div>
                        <small class="text-muted">Pipeline dang mo</small>
                        <h4 class="mb-0 fw-bold"><fmt:formatNumber value="${totalPipelineValue}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</h4>
                    </div>
                </div>
                <small class="text-muted">${openCount} co hoi dang mo</small>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center mb-2">
                    <div class="bg-success bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-trophy text-success fs-4"></i></div>
                    <div>
                        <small class="text-muted">Da thang (Won)</small>
                        <h4 class="mb-0 fw-bold text-success"><fmt:formatNumber value="${wonValue}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</h4>
                    </div>
                </div>
                <small class="text-muted">${wonCount} deal | Win rate: ${winRate}%</small>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center mb-2">
                    <div class="bg-warning bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-graph-up-arrow text-warning fs-4"></i></div>
                    <div>
                        <small class="text-muted">Du bao (co trong so)</small>
                        <h4 class="mb-0 fw-bold"><fmt:formatNumber value="${weightedForecast}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</h4>
                    </div>
                </div>
                <small class="text-muted">${totalOpps} tong opportunity</small>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center mb-2">
                    <div class="bg-info bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-cash-stack text-info fs-4"></i></div>
                    <div>
                        <small class="text-muted">Doanh thu (tu Customer)</small>
                        <h4 class="mb-0 fw-bold"><fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</h4>
                    </div>
                </div>
                <small class="text-muted">${totalCoursesSold} khoa hoc da ban</small>
            </div>
        </div>
    </div>
</div>

<!-- === ROW 2: Win/Loss + Lead Overview === -->
<div class="row g-3 mb-4">

    <!-- Win Rate & Deal Stats -->
    <div class="col-lg-4">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-pie-chart me-2"></i>Ty le Won / Lost</h6>
            </div>
            <div class="card-body">
                <!-- Win Rate Visual -->
                <div class="text-center mb-3">
                    <div class="position-relative d-inline-block">
                        <canvas id="winLossChart" style="max-width: 160px; max-height: 160px;"></canvas>
                        <div class="position-absolute top-50 start-50 translate-middle text-center">
                            <div class="fs-3 fw-bold">${winRate}%</div>
                            <small class="text-muted">Win rate</small>
                        </div>
                    </div>
                </div>
                <div class="d-flex justify-content-around">
                    <div class="text-center">
                        <div class="fs-5 fw-bold text-success">${wonCount}</div>
                        <small class="text-muted">Won</small>
                        <div class="small text-success fw-semibold"><fmt:formatNumber value="${wonValue}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</div>
                    </div>
                    <div class="text-center">
                        <div class="fs-5 fw-bold text-danger">${lostCount}</div>
                        <small class="text-muted">Lost</small>
                        <div class="small text-danger fw-semibold"><fmt:formatNumber value="${lostValue}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</div>
                    </div>
                    <div class="text-center">
                        <div class="fs-5 fw-bold text-primary">${openCount}</div>
                        <small class="text-muted">Open</small>
                        <div class="small text-primary fw-semibold"><fmt:formatNumber value="${totalPipelineValue}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Lead Stats -->
    <div class="col-lg-4">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0 d-flex justify-content-between align-items-center">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-people me-2"></i>Lead</h6>
                <a href="${pageContext.request.contextPath}/sale/lead/list" class="btn btn-sm btn-link text-decoration-none p-0">Xem tat ca</a>
            </div>
            <div class="card-body">
                <div class="row g-2 mb-3">
                    <div class="col-6">
                        <div class="text-center p-2 bg-light rounded-3">
                            <div class="fs-4 fw-bold text-primary">${totalLeads}</div>
                            <small class="text-muted">Tong Lead</small>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="text-center p-2 bg-light rounded-3">
                            <div class="fs-4 fw-bold text-info">${newLeads}</div>
                            <small class="text-muted">Moi (New)</small>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="text-center p-2 bg-light rounded-3">
                            <div class="fs-4 fw-bold text-success">${convertedLeads}</div>
                            <small class="text-muted">Da chuyen doi</small>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="text-center p-2 bg-light rounded-3">
                            <div class="fs-4 fw-bold text-danger">${hotLeads}</div>
                            <small class="text-muted">Hot</small>
                        </div>
                    </div>
                </div>
                <!-- Conversion Rate -->
                <div>
                    <div class="d-flex justify-content-between mb-1">
                        <small class="fw-semibold">Ty le chuyen doi</small>
                        <small class="fw-bold">${leadConversionRate}%</small>
                    </div>
                    <div class="progress" style="height: 8px;">
                        <div class="progress-bar bg-success" style="width: ${leadConversionRate}%;"></div>
                    </div>
                </div>
                <!-- Rating breakdown -->
                <div class="mt-3 d-flex gap-2">
                    <span class="badge bg-danger-subtle text-danger">Hot: ${hotLeads}</span>
                    <span class="badge bg-warning-subtle text-warning">Warm: ${warmLeads}</span>
                    <span class="badge bg-secondary-subtle text-secondary">Cold: ${coldLeads}</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Customer Stats -->
    <div class="col-lg-4">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0 d-flex justify-content-between align-items-center">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-building me-2"></i>Customer</h6>
                <a href="${pageContext.request.contextPath}/sale/customer/list" class="btn btn-sm btn-link text-decoration-none p-0">Xem tat ca</a>
            </div>
            <div class="card-body">
                <div class="row g-2 mb-3">
                    <div class="col-6">
                        <div class="text-center p-2 bg-light rounded-3">
                            <div class="fs-4 fw-bold text-primary">${totalCustomers}</div>
                            <small class="text-muted">Tong KH</small>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="text-center p-2 bg-light rounded-3">
                            <div class="fs-4 fw-bold text-success">${activeCustomers}</div>
                            <small class="text-muted">Active</small>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="text-center p-2 bg-light rounded-3">
                            <div class="fs-4 fw-bold text-warning">${vipCustomers}</div>
                            <small class="text-muted">VIP</small>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="text-center p-2 bg-light rounded-3">
                            <div class="fs-4 fw-bold text-danger">${riskCustomers}</div>
                            <small class="text-muted">Risk</small>
                        </div>
                    </div>
                </div>
                <div>
                    <div class="d-flex justify-content-between mb-1">
                        <small class="fw-semibold">Tong doanh thu</small>
                        <small class="fw-bold text-success"><fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</small>
                    </div>
                    <small class="text-muted">${totalCoursesSold} khoa hoc da ban</small>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- === ROW 3: Pipeline Stages + Quick Actions === -->
<div class="row g-3 mb-4">

    <!-- Pipeline Stages -->
    <div class="col-lg-8">
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-transparent border-0 d-flex justify-content-between align-items-center">
                <div>
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-bar-chart me-2"></i>Pipeline theo Stage</h6>
                    <c:if test="${not empty defaultPipeline}">
                        <small class="text-muted">${defaultPipeline.pipelineName}</small>
                    </c:if>
                </div>
                <a href="${pageContext.request.contextPath}/sale/opportunity/kanban" class="btn btn-sm btn-outline-primary"><i class="bi bi-kanban me-1"></i>Kanban</a>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty stages}">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Stage</th>
                                        <th class="text-center">So luong</th>
                                        <th class="text-end">Gia tri</th>
                                        <th style="width: 200px;">Phan bo</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="stage" items="${stages}">
                                        <c:set var="sc" value="${countByStage[stage.stageId] != null ? countByStage[stage.stageId] : 0}" />
                                        <c:set var="sv" value="${valueByStage[stage.stageId] != null ? valueByStage[stage.stageId] : 0}" />
                                        <c:set var="barPct" value="${totalPipelineValue > 0 ? (sv * 100 / totalPipelineValue) : 0}" />
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <span class="rounded-1" style="width: 4px; height: 28px; background: ${not empty stage.colorCode ? stage.colorCode : '#6b778c'};"></span>
                                                    <div>
                                                        <div class="fw-medium">${stage.stageName}</div>
                                                        <small class="text-muted">${stage.probability}% xac suat</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="text-center">
                                                <span class="badge bg-primary-subtle text-primary">${sc} deal</span>
                                            </td>
                                            <td class="text-end fw-semibold">
                                                <c:choose>
                                                    <c:when test="${sv > 0}"><fmt:formatNumber value="${sv}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</c:when>
                                                    <c:otherwise><span class="text-muted">0</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="progress flex-grow-1" style="height: 6px;">
                                                        <div class="progress-bar" style="width: ${barPct > 100 ? 100 : barPct}%; background: ${not empty stage.colorCode ? stage.colorCode : '#0d6efd'};"></div>
                                                    </div>
                                                    <small class="text-muted" style="width: 35px;"><fmt:formatNumber value="${barPct}" maxFractionDigits="0"/>%</small>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center text-muted py-4">Chua co pipeline/stage nao</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="col-lg-4">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-lightning me-2"></i>Thao tac nhanh</h6>
            </div>
            <div class="card-body pt-0">
                <div class="d-grid gap-2 mb-3">
                    <a href="${pageContext.request.contextPath}/sale/lead/form" class="btn btn-outline-info btn-sm text-start"><i class="bi bi-person-plus me-2"></i>Tao Lead moi</a>
                    <a href="${pageContext.request.contextPath}/sale/opportunity/form" class="btn btn-primary btn-sm text-start"><i class="bi bi-plus-lg me-2"></i>Tao Opportunity</a>
                    <a href="${pageContext.request.contextPath}/sale/customer/form" class="btn btn-outline-success btn-sm text-start"><i class="bi bi-building me-2"></i>Tao Customer</a>
                </div>
                <hr>
                <div class="d-flex flex-column gap-2">
                    <a href="${pageContext.request.contextPath}/sale/lead/list" class="text-decoration-none d-flex align-items-center gap-2 text-body-secondary small">
                        <i class="bi bi-people"></i><span>Danh sach Lead</span><i class="bi bi-chevron-right ms-auto"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/sale/opportunity/list" class="text-decoration-none d-flex align-items-center gap-2 text-body-secondary small">
                        <i class="bi bi-briefcase"></i><span>Danh sach Opportunity</span><i class="bi bi-chevron-right ms-auto"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/sale/customer/list" class="text-decoration-none d-flex align-items-center gap-2 text-body-secondary small">
                        <i class="bi bi-building"></i><span>Danh sach Customer</span><i class="bi bi-chevron-right ms-auto"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/sale/opportunity/kanban" class="text-decoration-none d-flex align-items-center gap-2 text-body-secondary small">
                        <i class="bi bi-kanban"></i><span>Pipeline Kanban</span><i class="bi bi-chevron-right ms-auto"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/sale/opportunity/forecast" class="text-decoration-none d-flex align-items-center gap-2 text-body-secondary small">
                        <i class="bi bi-graph-up-arrow"></i><span>Sales Forecast</span><i class="bi bi-chevron-right ms-auto"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/sale/opportunity/history" class="text-decoration-none d-flex align-items-center gap-2 text-body-secondary small">
                        <i class="bi bi-clock-history"></i><span>Lich su Opportunity</span><i class="bi bi-chevron-right ms-auto"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- === ROW 4: Recent Opportunities === -->
<div class="card border-0 shadow-sm">
    <div class="card-header bg-transparent border-0 d-flex justify-content-between align-items-center">
        <div>
            <h6 class="mb-0 fw-semibold"><i class="bi bi-clock-history me-2"></i>Opportunity gan day</h6>
            <small class="text-muted">5 opportunity cap nhat gan nhat</small>
        </div>
        <a href="${pageContext.request.contextPath}/sale/opportunity/list" class="btn btn-sm btn-link text-decoration-none">Xem tat ca <i class="bi bi-chevron-right"></i></a>
    </div>
    <div class="card-body p-0">
        <c:choose>
            <c:when test="${not empty recentOpps}">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-3">Opportunity</th>
                                <th>Pipeline / Stage</th>
                                <th class="text-end">Gia tri</th>
                                <th class="text-center">Xac suat</th>
                                <th class="text-center">Trang thai</th>
                                <th class="text-center">Cap nhat</th>
                                <th class="text-center">Thao tac</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="opp" items="${recentOpps}">
                                <tr>
                                    <td class="ps-3">
                                        <div class="fw-semibold">${opp.opportunityName}</div>
                                        <small class="text-muted">${opp.opportunityCode}</small>
                                    </td>
                                    <td>
                                        <div><small class="text-muted">${pipelineNameMap[opp.pipelineId]}</small></div>
                                        <span class="badge bg-primary-subtle text-primary">${stageNameMap[opp.stageId]}</span>
                                    </td>
                                    <td class="text-end">
                                        <c:choose>
                                            <c:when test="${not empty opp.estimatedValue and opp.estimatedValue > 0}">
                                                <span class="fw-semibold text-success"><fmt:formatNumber value="${opp.estimatedValue}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</span>
                                            </c:when>
                                            <c:otherwise><span class="text-muted">0</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <div class="d-flex align-items-center justify-content-center gap-1">
                                            <div class="progress" style="width: 40px; height: 5px;">
                                                <div class="progress-bar <c:choose><c:when test='${opp.probability >= 70}'>bg-success</c:when><c:when test='${opp.probability >= 40}'>bg-warning</c:when><c:otherwise>bg-danger</c:otherwise></c:choose>" style="width: ${opp.probability}%;"></div>
                                            </div>
                                            <small class="fw-bold">${opp.probability}%</small>
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${opp.status == 'Open'}"><span class="badge bg-info-subtle text-info">Open</span></c:when>
                                            <c:when test="${opp.status == 'InProgress'}"><span class="badge bg-primary-subtle text-primary">In Progress</span></c:when>
                                            <c:when test="${opp.status == 'Won'}"><span class="badge bg-success">Won</span></c:when>
                                            <c:when test="${opp.status == 'Lost'}"><span class="badge bg-danger">Lost</span></c:when>
                                            <c:when test="${opp.status == 'OnHold'}"><span class="badge bg-warning-subtle text-warning">On Hold</span></c:when>
                                            <c:otherwise><span class="badge bg-secondary">${opp.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <small class="text-muted">
                                            <c:choose>
                                                <c:when test="${not empty opp.updatedAt}">${opp.updatedAt.toString().substring(0, 10)}</c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </small>
                                    </td>
                                    <td class="text-center">
                                        <div class="btn-group btn-group-sm">
                                            <a href="${pageContext.request.contextPath}/sale/opportunity/detail?id=${opp.opportunityId}" class="btn btn-outline-primary btn-sm" title="Xem"><i class="bi bi-eye"></i></a>
                                            <a href="${pageContext.request.contextPath}/sale/opportunity/form?id=${opp.opportunityId}" class="btn btn-outline-secondary btn-sm" title="Sua"><i class="bi bi-pencil"></i></a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center text-muted py-4">Chua co opportunity nao</div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        var winLossCtx = document.getElementById('winLossChart');
        if (winLossCtx) {
            new Chart(winLossCtx, {
                type: 'doughnut',
                data: {
                    labels: ['Won', 'Lost', 'Open'],
                    datasets: [{
                        data: [${wonCount}, ${lostCount}, ${openCount}],
                        backgroundColor: ['#198754', '#dc3545', '#0d6efd'],
                        borderWidth: 0,
                        hoverOffset: 8
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    cutout: '72%',
                    plugins: {
                        legend: { display: false }
                    }
                }
            });
        }
    });
</script>
