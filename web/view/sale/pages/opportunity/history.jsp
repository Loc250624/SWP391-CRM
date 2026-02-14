<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">Lich su Opportunity</h4>
        <p class="text-muted mb-0">Theo doi toan bo co hoi kinh doanh</p>
    </div>
    <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/sale/opportunity/list" class="btn btn-outline-secondary btn-sm"><i class="bi bi-list me-1"></i>Danh sach</a>
    </div>
</div>

<!-- Filter -->
<div class="card border-0 shadow-sm mb-4">
    <div class="card-body py-3">
        <form method="GET" action="${pageContext.request.contextPath}/sale/opportunity/history" class="row g-2 align-items-end">
            <div class="col-md-3">
                <label class="form-label small text-muted mb-1">Trang thai</label>
                <select name="status" class="form-select form-select-sm" onchange="this.form.submit()">
                    <option value="">Tat ca</option>
                    <option value="Open" ${filterStatus == 'Open' ? 'selected' : ''}>Open</option>
                    <option value="InProgress" ${filterStatus == 'InProgress' ? 'selected' : ''}>In Progress</option>
                    <option value="Won" ${filterStatus == 'Won' ? 'selected' : ''}>Won</option>
                    <option value="Lost" ${filterStatus == 'Lost' ? 'selected' : ''}>Lost</option>
                    <option value="OnHold" ${filterStatus == 'OnHold' ? 'selected' : ''}>On Hold</option>
                    <option value="Cancelled" ${filterStatus == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                </select>
            </div>
            <div class="col-md-2">
                <a href="${pageContext.request.contextPath}/sale/opportunity/history" class="btn btn-outline-secondary btn-sm w-100"><i class="bi bi-arrow-counterclockwise me-1"></i>Xoa loc</a>
            </div>
        </form>
    </div>
</div>

<!-- Timeline -->
<c:choose>
    <c:when test="${not empty opportunities}">
        <div class="card border-0 shadow-sm">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light">
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
                            <c:forEach var="opp" items="${opportunities}">
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
                                    <td class="text-center"><small>${opp.probability}%</small></td>
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
                                        <small>
                                        <c:choose>
                                            <c:when test="${not empty opp.updatedAt}">${opp.updatedAt.toString().substring(0, 16).replace('T', ' ')}</c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                        </small>
                                    </td>
                                    <td class="text-center">
                                        <a href="${pageContext.request.contextPath}/sale/opportunity/detail?id=${opp.opportunityId}" class="btn btn-outline-primary btn-sm"><i class="bi bi-eye"></i></a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="text-center py-5">
            <i class="bi bi-clock-history text-muted" style="font-size: 3rem;"></i>
            <p class="text-muted mt-3">Chua co lich su opportunity nao</p>
        </div>
    </c:otherwise>
</c:choose>
