<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">Du bao Doanh thu</h4>
        <p class="text-muted mb-0">Phan tich va du bao co hoi kinh doanh</p>
    </div>
    <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/sale/opportunity/list" class="btn btn-outline-secondary btn-sm"><i class="bi bi-list me-1"></i>Danh sach</a>
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
                        <small class="text-muted">Pipeline dang mo</small>
                        <h4 class="mb-0 fw-bold"><fmt:formatNumber value="${totalPipeline}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</h4>
                        <small class="text-muted">${openCount} co hoi</small>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center">
                    <div class="bg-warning bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-graph-up-arrow text-warning fs-4"></i></div>
                    <div>
                        <small class="text-muted">Du bao (co trong so)</small>
                        <h4 class="mb-0 fw-bold"><fmt:formatNumber value="${weightedForecast}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</h4>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center">
                    <div class="bg-success bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-trophy text-success fs-4"></i></div>
                    <div>
                        <small class="text-muted">Da thang (Won)</small>
                        <h4 class="mb-0 fw-bold text-success"><fmt:formatNumber value="${wonValue}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</h4>
                        <small class="text-muted">${wonCount} deal</small>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center">
                    <div class="bg-danger bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-x-circle text-danger fs-4"></i></div>
                    <div>
                        <small class="text-muted">Da mat (Lost)</small>
                        <h4 class="mb-0 fw-bold text-danger"><fmt:formatNumber value="${lostValue}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</h4>
                        <small class="text-muted">${lostCount} deal | Win rate: ${winRate}%</small>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row g-4">
    <!-- Phan bo theo Stage -->
    <div class="col-lg-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-bar-chart me-2"></i>Phan bo gia tri theo Stage</h6>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty valueByStage}">
                        <c:forEach var="entry" items="${valueByStage}">
                            <div class="mb-3">
                                <div class="d-flex justify-content-between mb-1">
                                    <small class="fw-semibold">
                                        <c:choose>
                                            <c:when test="${not empty stageNameMap[entry.key]}">${stageNameMap[entry.key]}</c:when>
                                            <c:otherwise>Stage #${entry.key}</c:otherwise>
                                        </c:choose>
                                        <span class="text-muted fw-normal">(${countByStage[entry.key]})</span>
                                    </small>
                                    <small class="fw-bold text-success"><fmt:formatNumber value="${entry.value}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</small>
                                </div>
                                <div class="progress" style="height: 8px;">
                                    <c:set var="barWidth" value="${totalPipeline > 0 ? (entry.value * 100 / (totalPipeline.doubleValue() + wonValue.doubleValue() + 1)) : 0}" />
                                    <div class="progress-bar bg-primary" style="width: ${barWidth > 100 ? 100 : barWidth}%;"></div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center text-muted py-4">Chua co du lieu</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Tong quan -->
    <div class="col-lg-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold"><i class="bi bi-pie-chart me-2"></i>Tong quan Opportunity</h6>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-6">
                        <div class="text-center p-3 bg-light rounded-3">
                            <div class="fs-3 fw-bold text-primary">${totalCount}</div>
                            <small class="text-muted">Tong so deal</small>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="text-center p-3 bg-light rounded-3">
                            <div class="fs-3 fw-bold text-info">${openCount}</div>
                            <small class="text-muted">Dang mo</small>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="text-center p-3 bg-light rounded-3">
                            <div class="fs-3 fw-bold text-success">${wonCount}</div>
                            <small class="text-muted">Da thang</small>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="text-center p-3 bg-light rounded-3">
                            <div class="fs-3 fw-bold text-danger">${lostCount}</div>
                            <small class="text-muted">Da mat</small>
                        </div>
                    </div>
                </div>

                <hr>

                <!-- Win Rate Bar -->
                <div class="mb-2">
                    <div class="d-flex justify-content-between mb-1">
                        <small class="fw-semibold">Win Rate</small>
                        <small class="fw-bold">${winRate}%</small>
                    </div>
                    <div class="progress" style="height: 12px;">
                        <div class="progress-bar bg-success" style="width: ${winRate}%;">${winRate}%</div>
                        <c:if test="${winRate < 100}">
                            <div class="progress-bar bg-danger" style="width: ${100 - winRate}%;"></div>
                        </c:if>
                    </div>
                    <div class="d-flex justify-content-between mt-1">
                        <small class="text-success">Won: ${wonCount}</small>
                        <small class="text-danger">Lost: ${lostCount}</small>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Top Opportunities Table -->
<div class="card border-0 shadow-sm mt-4">
    <div class="card-header bg-transparent border-0">
        <h6 class="mb-0 fw-semibold"><i class="bi bi-star me-2"></i>Co hoi dang mo (sap xep theo gia tri)</h6>
    </div>
    <div class="card-body p-0">
        <c:set var="hasOpen" value="false" />
        <c:forEach var="opp" items="${opportunities}">
            <c:if test="${opp.status != 'Won' and opp.status != 'Lost' and opp.status != 'Cancelled'}">
                <c:set var="hasOpen" value="true" />
            </c:if>
        </c:forEach>

        <c:choose>
            <c:when test="${hasOpen}">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light">
                            <tr>
                                <th class="ps-3">Opportunity</th>
                                <th class="text-end">Gia tri</th>
                                <th class="text-center">Xac suat</th>
                                <th class="text-end">Du bao</th>
                                <th class="text-center">Ngay dong</th>
                                <th class="text-center">Thao tac</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="opp" items="${opportunities}">
                                <c:if test="${opp.status != 'Won' and opp.status != 'Lost' and opp.status != 'Cancelled'}">
                                    <tr>
                                        <td class="ps-3">
                                            <div class="fw-semibold">${opp.opportunityName}</div>
                                            <small class="text-muted">${opp.opportunityCode}</small>
                                        </td>
                                        <td class="text-end">
                                            <c:choose>
                                                <c:when test="${not empty opp.estimatedValue and opp.estimatedValue > 0}">
                                                    <span class="fw-semibold"><fmt:formatNumber value="${opp.estimatedValue}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</span>
                                                </c:when>
                                                <c:otherwise>0</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">${opp.probability}%</td>
                                        <td class="text-end">
                                            <c:choose>
                                                <c:when test="${not empty opp.estimatedValue and opp.estimatedValue > 0}">
                                                    <span class="fw-semibold text-warning"><fmt:formatNumber value="${opp.estimatedValue * opp.probability / 100}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</span>
                                                </c:when>
                                                <c:otherwise>0</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <small>
                                            <c:choose>
                                                <c:when test="${not empty opp.expectedCloseDate}">${opp.expectedCloseDate}</c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                            </small>
                                        </td>
                                        <td class="text-center">
                                            <a href="${pageContext.request.contextPath}/sale/opportunity/detail?id=${opp.opportunityId}" class="btn btn-outline-primary btn-sm"><i class="bi bi-eye"></i></a>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center text-muted py-4">Khong co co hoi dang mo</div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
