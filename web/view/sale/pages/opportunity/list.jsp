<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">Quan ly Opportunity</h4>
        <p class="text-muted mb-0">Danh sach co hoi kinh doanh</p>
    </div>
    <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/sale/opportunity/kanban" class="btn btn-outline-primary btn-sm"><i class="bi bi-kanban me-1"></i>Kanban</a>
        <a href="${pageContext.request.contextPath}/sale/opportunity/form" class="btn btn-primary btn-sm"><i class="bi bi-plus-lg me-1"></i>Them Opportunity</a>
    </div>
</div>

<!-- Messages -->
<c:if test="${not empty successMessage}">
    <div class="alert alert-success alert-dismissible fade show d-flex align-items-center" role="alert">
        <i class="bi bi-check-circle-fill me-2"></i>${successMessage}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${param.error == 'no_permission'}">
    <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i>Ban khong co quyen truy cap opportunity nay!
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<!-- KPI Cards -->
<div class="row g-3 mb-4">
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center mb-3">
                    <div class="bg-primary bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-briefcase text-primary fs-4"></i></div>
                    <div class="flex-grow-1">
                        <small class="text-muted">Tong Opportunity</small>
                        <h4 class="mb-0 fw-bold">${totalOpportunities}</h4>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center mb-3">
                    <div class="bg-success bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-cash-stack text-success fs-4"></i></div>
                    <div class="flex-grow-1">
                        <small class="text-muted">Tong gia tri</small>
                        <h4 class="mb-0 fw-bold"><fmt:formatNumber value="${totalValue}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</h4>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center mb-3">
                    <div class="bg-info bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-hourglass-split text-info fs-4"></i></div>
                    <div class="flex-grow-1">
                        <small class="text-muted">Dang mo</small>
                        <h4 class="mb-0 fw-bold">${openCount}</h4>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center mb-3">
                    <div class="bg-warning bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-trophy text-warning fs-4"></i></div>
                    <div class="flex-grow-1">
                        <small class="text-muted">Won / Lost</small>
                        <h4 class="mb-0 fw-bold"><span class="text-success">${wonCount}</span> / <span class="text-danger">${lostCount}</span></h4>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Filter -->
<div class="card border-0 shadow-sm mb-4">
    <div class="card-body py-3">
        <form method="GET" action="${pageContext.request.contextPath}/sale/opportunity/list" class="row g-2 align-items-end">
            <div class="col-md-3">
                <label class="form-label small text-muted mb-1">Tim kiem</label>
                <input type="text" name="search" class="form-control form-control-sm" placeholder="Ten, ma opportunity..." value="${searchQuery}">
            </div>
            <div class="col-md-2">
                <label class="form-label small text-muted mb-1">Pipeline</label>
                <select name="pipeline" class="form-select form-select-sm" onchange="this.form.submit()">
                    <option value="">Tat ca</option>
                    <c:forEach var="p" items="${pipelines}">
                        <option value="${p.pipelineId}" ${selectedPipelineId == p.pipelineId ? 'selected' : ''}>${p.pipelineName}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-2">
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
                <button type="submit" class="btn btn-outline-primary btn-sm w-100"><i class="bi bi-search me-1"></i>Loc</button>
            </div>
            <div class="col-md-2">
                <a href="${pageContext.request.contextPath}/sale/opportunity/list" class="btn btn-outline-secondary btn-sm w-100"><i class="bi bi-arrow-counterclockwise me-1"></i>Xoa loc</a>
            </div>
        </form>
    </div>
</div>

<!-- Table -->
<div class="card border-0 shadow-sm">
    <div class="card-body p-0">
        <c:choose>
            <c:when test="${not empty opportunities}">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light">
                            <tr>
                                <th class="ps-3">Opportunity</th>
                                <th>Pipeline / Stage</th>
                                <th class="text-end">Gia tri</th>
                                <th class="text-center">Xac suat</th>
                                <th class="text-center">Trang thai</th>
                                <th class="text-center">Ngay dong du kien</th>
                                <th class="text-center" style="width: 140px;">Thao tac</th>
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
                                    <td class="text-center">
                                        <div class="d-flex align-items-center justify-content-center gap-1">
                                            <div class="progress" style="width: 50px; height: 6px;">
                                                <div class="progress-bar
                                                     <c:choose>
                                                         <c:when test="${opp.probability >= 70}">bg-success</c:when>
                                                         <c:when test="${opp.probability >= 40}">bg-warning</c:when>
                                                         <c:otherwise>bg-danger</c:otherwise>
                                                     </c:choose>" style="width: ${opp.probability}%;"></div>
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
                                            <c:when test="${opp.status == 'Cancelled'}"><span class="badge bg-secondary">Cancelled</span></c:when>
                                            <c:otherwise><span class="badge bg-secondary">${opp.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <small>
                                            <c:choose>
                                                <c:when test="${not empty opp.expectedCloseDate}">${opp.expectedCloseDate}</c:when>
                                                <c:otherwise><span class="text-muted">-</span></c:otherwise>
                                            </c:choose>
                                        </small>
                                    </td>
                                    <td class="text-center">
                                        <div class="btn-group btn-group-sm">
                                            <a href="${pageContext.request.contextPath}/sale/opportunity/detail?id=${opp.opportunityId}" class="btn btn-outline-primary btn-sm" title="Xem"><i class="bi bi-eye"></i></a>
                                            <a href="${pageContext.request.contextPath}/sale/opportunity/form?id=${opp.opportunityId}" class="btn btn-outline-secondary btn-sm" title="Sua"><i class="bi bi-pencil"></i></a>
                                            <button onclick="deleteOpp(${opp.opportunityId}, '${opp.opportunityName}')" class="btn btn-outline-danger btn-sm" title="Xoa"><i class="bi bi-trash"></i></button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5">
                    <i class="bi bi-briefcase text-muted" style="font-size: 3rem;"></i>
                    <p class="text-muted mt-3 mb-2">Chua co opportunity nao</p>
                    <a href="${pageContext.request.contextPath}/sale/opportunity/form" class="btn btn-primary btn-sm"><i class="bi bi-plus-lg me-1"></i>Them Opportunity</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    <!-- Pagination -->
    <c:if test="${totalPages > 1}">
        <div class="card-footer bg-transparent d-flex justify-content-between align-items-center">
            <small class="text-muted">Hien thi ${(currentPage - 1) * 10 + 1}-${currentPage * 10 > totalItems ? totalItems : currentPage * 10} / ${totalItems} opportunity</small>
            <nav>
                <ul class="pagination pagination-sm mb-0">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/sale/opportunity/list?page=${currentPage - 1}&pipeline=${selectedPipelineId}&status=${filterStatus}&search=${searchQuery}"><i class="bi bi-chevron-left"></i></a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:if test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/sale/opportunity/list?page=${i}&pipeline=${selectedPipelineId}&status=${filterStatus}&search=${searchQuery}">${i}</a>
                            </li>
                        </c:if>
                        <c:if test="${(i == currentPage - 3 && i > 1) || (i == currentPage + 3 && i < totalPages)}">
                            <li class="page-item disabled"><span class="page-link">...</span></li>
                            </c:if>
                        </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/sale/opportunity/list?page=${currentPage + 1}&pipeline=${selectedPipelineId}&status=${filterStatus}&search=${searchQuery}"><i class="bi bi-chevron-right"></i></a>
                    </li>
                </ul>
            </nav>
        </div>
    </c:if>
</div>

<script>
    function deleteOpp(oppId, oppName) {
        if (confirm('Ban co chac muon xoa opportunity "' + oppName + '"?\nHanh dong nay khong the hoan tac.')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/sale/opportunity/list';
            form.innerHTML = '<input type="hidden" name="action" value="delete"><input type="hidden" name="opportunityId" value="' + oppId + '">';
            document.body.appendChild(form);
            form.submit();
        }
    }
</script>
