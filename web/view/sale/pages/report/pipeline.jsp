<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">Pipeline Statistics</h4>
        <p class="text-muted mb-0">Phan tich chi tiet pipeline ban hang</p>
    </div>
    <div class="d-flex gap-2">
        <form method="GET" action="${pageContext.request.contextPath}/sale/report/pipeline">
            <select name="pipeline" class="form-select form-select-sm" onchange="this.form.submit()" style="width: 200px;">
                <c:forEach var="p" items="${allPipelines}">
                    <option value="${p.pipelineId}" ${selectedPipeline != null && selectedPipeline.pipelineId == p.pipelineId ? 'selected' : ''}>${p.pipelineName}</option>
                </c:forEach>
            </select>
        </form>
        <a href="${pageContext.request.contextPath}/sale/opportunity/kanban" class="btn btn-outline-primary btn-sm"><i class="bi bi-kanban me-1"></i>Kanban</a>
    </div>
</div>

<!-- KPI Cards -->
<div class="row g-3 mb-4">
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center">
                    <div class="bg-primary bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-funnel text-primary fs-4"></i></div>
                    <div>
                        <small class="text-muted">Deal dang mo</small>
                        <h4 class="mb-0 fw-bold">${totalInPipeline}</h4>
                        <small class="text-muted">${totalDeals} tong (ca Won/Lost)</small>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center">
                    <div class="bg-success bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-cash-stack text-success fs-4"></i></div>
                    <div>
                        <small class="text-muted">Tong gia tri pipeline</small>
                        <h4 class="mb-0 fw-bold"><fmt:formatNumber value="${totalPipelineValue}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</h4>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center">
                    <div class="bg-warning bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-trophy text-warning fs-4"></i></div>
                    <div>
                        <small class="text-muted">Win Rate</small>
                        <h4 class="mb-0 fw-bold">${winRate}%</h4>
                        <small class="text-muted">${wonCount} won / ${lostCount} lost</small>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center">
                    <div class="bg-info bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-calculator text-info fs-4"></i></div>
                    <div>
                        <small class="text-muted">TB gia tri / deal</small>
                        <h4 class="mb-0 fw-bold"><fmt:formatNumber value="${avgDealSize}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</h4>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row g-4 mb-4">
    <!-- Funnel Chart -->
    <div class="col-lg-7">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-filter me-2"></i>Pipeline Funnel</h6>
                <c:if test="${not empty selectedPipeline}">
                    <small class="text-muted">${selectedPipeline.pipelineName}</small>
                </c:if>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty stages}">
                        <div class="d-flex flex-column gap-3">
                            <c:forEach var="stage" items="${stages}" varStatus="loop">
                                <c:set var="sc" value="${countByStage[stage.stageId] != null ? countByStage[stage.stageId] : 0}" />
                                <c:set var="sv" value="${valueByStage[stage.stageId] != null ? valueByStage[stage.stageId] : 0}" />
                                <c:set var="barPct" value="${maxStageValue > 0 ? (sv * 100 / maxStageValue) : 0}" />
                                <c:set var="barWidth" value="${barPct < 8 && sc > 0 ? 8 : barPct}" />
                                <c:set var="stageColor" value="${not empty stage.colorCode ? stage.colorCode : '#6b778c'}" />
                                <div class="d-flex align-items-center gap-3">
                                    <div style="width: 130px;" class="d-flex align-items-center gap-2">
                                        <span class="rounded-circle flex-shrink-0" style="width: 10px; height: 10px; background: ${stageColor}; display: inline-block;"></span>
                                        <small class="fw-medium">${stage.stageName}</small>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="progress" style="height: 32px; background: #f0f1f3;">
                                            <div class="progress-bar d-flex align-items-center justify-content-start ps-2" style="width: ${barWidth}%; background: ${stageColor}; font-size: 12px; min-width: 0;">
                                                <c:if test="${sc > 0}">
                                                    <span class="text-white fw-semibold">${sc} deal - <fmt:formatNumber value="${sv}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</span>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                    <div style="width: 50px;" class="text-end">
                                        <small class="fw-bold">${sc}</small>
                                    </div>
                                </div>
                            </c:forEach>

                            <!-- Won row -->
                            <div class="d-flex align-items-center gap-3 pt-2 border-top">
                                <div style="width: 130px;" class="d-flex align-items-center gap-2">
                                    <span class="rounded-circle flex-shrink-0" style="width: 10px; height: 10px; background: #198754; display: inline-block;"></span>
                                    <small class="fw-medium text-success">Won</small>
                                </div>
                                <div class="flex-grow-1">
                                    <div class="progress" style="height: 32px; background: #f0f1f3;">
                                        <c:set var="wonPct" value="${maxStageValue > 0 ? (wonValue * 100 / maxStageValue) : 0}" />
                                        <div class="progress-bar bg-success d-flex align-items-center justify-content-start ps-2" style="width: ${wonPct < 8 && wonCount > 0 ? 8 : wonPct}%; font-size: 12px;">
                                            <c:if test="${wonCount > 0}">
                                                <span class="text-white fw-semibold">${wonCount} deal - <fmt:formatNumber value="${wonValue}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</span>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                                <div style="width: 50px;" class="text-end">
                                    <small class="fw-bold text-success">${wonCount}</small>
                                </div>
                            </div>

                            <!-- Lost row -->
                            <div class="d-flex align-items-center gap-3">
                                <div style="width: 130px;" class="d-flex align-items-center gap-2">
                                    <span class="rounded-circle flex-shrink-0" style="width: 10px; height: 10px; background: #dc3545; display: inline-block;"></span>
                                    <small class="fw-medium text-danger">Lost</small>
                                </div>
                                <div class="flex-grow-1">
                                    <div class="progress" style="height: 32px; background: #f0f1f3;">
                                        <c:set var="lostPct" value="${maxStageValue > 0 ? (lostValue * 100 / maxStageValue) : 0}" />
                                        <div class="progress-bar bg-danger d-flex align-items-center justify-content-start ps-2" style="width: ${lostPct < 8 && lostCount > 0 ? 8 : lostPct}%; font-size: 12px;">
                                            <c:if test="${lostCount > 0}">
                                                <span class="text-white fw-semibold">${lostCount} deal - <fmt:formatNumber value="${lostValue}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</span>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                                <div style="width: 50px;" class="text-end">
                                    <small class="fw-bold text-danger">${lostCount}</small>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center text-muted py-4">Chua co stage nao</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Doughnut + Summary -->
    <div class="col-lg-5">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-pie-chart me-2"></i>Phan bo deal</h6>
            </div>
            <div class="card-body">
                <div class="text-center mb-3">
                    <canvas id="pipelineDonut" style="max-width: 200px; max-height: 200px; margin: 0 auto;"></canvas>
                </div>

                <!-- Win Rate Bar -->
                <div class="mb-3">
                    <div class="d-flex justify-content-between mb-1">
                        <small class="fw-semibold">Win Rate</small>
                        <small class="fw-bold">${winRate}%</small>
                    </div>
                    <div class="progress" style="height: 10px;">
                        <div class="progress-bar bg-success" style="width: ${winRate}%;">${winRate}%</div>
                        <c:if test="${winRate < 100 && (wonCount + lostCount) > 0}">
                            <div class="progress-bar bg-danger" style="width: ${100 - winRate}%;"></div>
                        </c:if>
                    </div>
                    <div class="d-flex justify-content-between mt-1">
                        <small class="text-success">Won: ${wonCount} (<fmt:formatNumber value="${wonValue}" type="number" groupingUsed="true" maxFractionDigits="0"/>d)</small>
                        <small class="text-danger">Lost: ${lostCount} (<fmt:formatNumber value="${lostValue}" type="number" groupingUsed="true" maxFractionDigits="0"/>d)</small>
                    </div>
                </div>

                <hr>

                <!-- Summary stats -->
                <div class="row g-2">
                    <div class="col-6">
                        <div class="text-center p-2 bg-light rounded">
                            <div class="fs-5 fw-bold text-primary">${totalInPipeline}</div>
                            <small class="text-muted">Dang mo</small>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="text-center p-2 bg-light rounded">
                            <div class="fs-5 fw-bold">${totalDeals}</div>
                            <small class="text-muted">Tong deal</small>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="text-center p-2 bg-light rounded">
                            <div class="fs-5 fw-bold text-success">${wonCount}</div>
                            <small class="text-muted">Won</small>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="text-center p-2 bg-light rounded">
                            <div class="fs-5 fw-bold text-danger">${lostCount}</div>
                            <small class="text-muted">Lost</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Stage Details Table -->
<div class="card border-0 shadow-sm">
    <div class="card-header bg-transparent border-0">
        <h6 class="mb-0 fw-semibold"><i class="bi bi-table me-2"></i>Chi tiet theo Stage</h6>
    </div>
    <div class="card-body p-0">
        <c:choose>
            <c:when test="${not empty stages}">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-3">Stage</th>
                                <th class="text-center">So deal</th>
                                <th class="text-end">Tong gia tri</th>
                                <th class="text-end">TB / deal</th>
                                <th class="text-center">Xac suat</th>
                                <th style="width: 180px;">Phan bo gia tri</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="stage" items="${stages}">
                                <c:set var="sc" value="${countByStage[stage.stageId] != null ? countByStage[stage.stageId] : 0}" />
                                <c:set var="sv" value="${valueByStage[stage.stageId] != null ? valueByStage[stage.stageId] : 0}" />
                                <c:set var="avgVal" value="${sc > 0 ? sv / sc : 0}" />
                                <c:set var="pct" value="${totalPipelineValue > 0 ? (sv * 100 / totalPipelineValue) : 0}" />
                                <c:set var="stageColor" value="${not empty stage.colorCode ? stage.colorCode : '#6b778c'}" />
                                <tr>
                                    <td class="ps-3">
                                        <div class="d-flex align-items-center gap-2">
                                            <span class="rounded-circle flex-shrink-0" style="width: 10px; height: 10px; background: ${stageColor}; display: inline-block;"></span>
                                            <div>
                                                <div class="fw-medium">${stage.stageName}</div>
                                                <small class="text-muted">Order: ${stage.stageOrder}</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <span class="badge bg-primary-subtle text-primary">${sc}</span>
                                    </td>
                                    <td class="text-end fw-semibold">
                                        <c:choose>
                                            <c:when test="${sv > 0}"><fmt:formatNumber value="${sv}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</c:when>
                                            <c:otherwise><span class="text-muted">0</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end">
                                        <c:choose>
                                            <c:when test="${sc > 0}"><fmt:formatNumber value="${avgVal}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</c:when>
                                            <c:otherwise><span class="text-muted">-</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <span class="fw-semibold">${stage.probability}%</span>
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <div class="progress flex-grow-1" style="height: 6px;">
                                                <div class="progress-bar" style="width: ${pct > 100 ? 100 : pct}%; background: ${stageColor};"></div>
                                            </div>
                                            <small class="text-muted" style="width: 35px;"><fmt:formatNumber value="${pct}" maxFractionDigits="0"/>%</small>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <!-- Won/Lost summary rows -->
                            <tr class="table-success">
                                <td class="ps-3">
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="rounded-circle flex-shrink-0" style="width: 10px; height: 10px; background: #198754; display: inline-block;"></span>
                                        <div class="fw-semibold text-success">Won (Closed)</div>
                                    </div>
                                </td>
                                <td class="text-center"><span class="badge bg-success">${wonCount}</span></td>
                                <td class="text-end fw-bold text-success"><fmt:formatNumber value="${wonValue}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</td>
                                <td class="text-end">
                                    <c:choose>
                                        <c:when test="${wonCount > 0}"><fmt:formatNumber value="${wonValue / wonCount}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center"><span class="fw-semibold text-success">100%</span></td>
                                <td></td>
                            </tr>
                            <tr class="table-danger">
                                <td class="ps-3">
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="rounded-circle flex-shrink-0" style="width: 10px; height: 10px; background: #dc3545; display: inline-block;"></span>
                                        <div class="fw-semibold text-danger">Lost (Closed)</div>
                                    </div>
                                </td>
                                <td class="text-center"><span class="badge bg-danger">${lostCount}</span></td>
                                <td class="text-end fw-bold text-danger"><fmt:formatNumber value="${lostValue}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</td>
                                <td class="text-end">
                                    <c:choose>
                                        <c:when test="${lostCount > 0}"><fmt:formatNumber value="${lostValue / lostCount}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center"><span class="fw-semibold text-danger">0%</span></td>
                                <td></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center text-muted py-4">Chua co stage nao trong pipeline nay</div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        var ctx = document.getElementById('pipelineDonut');
        if (ctx) {
            var labels = [];
            var data = [];
            var colors = [];
            <c:forEach var="stage" items="${stages}">
                labels.push('${stage.stageName}');
                data.push(${countByStage[stage.stageId] != null ? countByStage[stage.stageId] : 0});
                colors.push('${not empty stage.colorCode ? stage.colorCode : "#6b778c"}');
            </c:forEach>
            labels.push('Won');
            data.push(${wonCount});
            colors.push('#198754');
            labels.push('Lost');
            data.push(${lostCount});
            colors.push('#dc3545');

            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: labels,
                    datasets: [{
                        data: data,
                        backgroundColor: colors,
                        borderWidth: 1,
                        hoverOffset: 8
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    cutout: '60%',
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: { font: { size: 11 }, padding: 12 }
                        }
                    }
                }
            });
        }
    });
</script>
