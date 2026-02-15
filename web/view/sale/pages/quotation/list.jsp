<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">De xuat & Bao gia</h4>
        <p class="text-muted mb-0">Draft = De xuat (cho duyet) | Approved = Da duyet | Sent = Bao gia (da gui khach)</p>
    </div>
    <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/sale/quotation/form" class="btn btn-primary btn-sm"><i class="bi bi-plus-lg me-1"></i>Tao de xuat</a>
    </div>
</div>

<c:if test="${param.success == '1'}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-check-circle me-1"></i>Luu de xuat thanh cong!
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${param.error == 'readonly'}">
    <div class="alert alert-warning alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-triangle me-1"></i>Khong the chinh sua de xuat nay (chi cho phep sua khi o trang thai Draft).
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<!-- Stats -->
<div class="row g-3 mb-4">
    <div class="col-md-3">
        <div class="card border-0 shadow-sm"><div class="card-body py-3 text-center">
            <div class="fs-3 fw-bold text-primary">${totalCount}</div><small class="text-muted">Tong</small>
        </div></div>
    </div>
    <div class="col-md-3">
        <div class="card border-0 shadow-sm"><div class="card-body py-3 text-center">
            <div class="fs-3 fw-bold text-secondary">${statusCounts['Draft'] != null ? statusCounts['Draft'] : 0}</div><small class="text-muted">De xuat (cho duyet)</small>
        </div></div>
    </div>
    <div class="col-md-3">
        <div class="card border-0 shadow-sm"><div class="card-body py-3 text-center">
            <div class="fs-3 fw-bold text-success">${statusCounts['Approved'] != null ? statusCounts['Approved'] : 0}</div><small class="text-muted">Da duyet</small>
        </div></div>
    </div>
    <div class="col-md-3">
        <div class="card border-0 shadow-sm"><div class="card-body py-3 text-center">
            <div class="fs-3 fw-bold text-warning">${statusCounts['Sent'] != null ? statusCounts['Sent'] : 0}</div><small class="text-muted">Bao gia (da gui)</small>
        </div></div>
    </div>
</div>

<!-- Filters -->
<div class="card border-0 shadow-sm mb-4">
    <div class="card-body py-3">
        <form method="GET" action="${pageContext.request.contextPath}/sale/quotation/list" class="d-flex gap-3 flex-wrap align-items-center">
            <div class="input-group" style="width: 300px;">
                <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-muted"></i></span>
                <input type="text" class="form-control bg-light border-start-0" name="keyword" placeholder="Tim kiem..." value="${keyword}">
            </div>
            <select class="form-select form-select-sm" name="status" style="width: auto;">
                <option value="" ${empty statusFilter ? 'selected' : ''}>Tat ca trang thai</option>
                <option value="Draft" ${statusFilter == 'Draft' ? 'selected' : ''}>De xuat (Draft)</option>
                <option value="Approved" ${statusFilter == 'Approved' ? 'selected' : ''}>Da duyet (Approved)</option>
                <option value="Sent" ${statusFilter == 'Sent' ? 'selected' : ''}>Bao gia (Sent)</option>
                <option value="Accepted" ${statusFilter == 'Accepted' ? 'selected' : ''}>Khach chap nhan</option>
                <option value="Rejected" ${statusFilter == 'Rejected' ? 'selected' : ''}>Tu choi</option>
            </select>
            <button type="submit" class="btn btn-sm btn-primary"><i class="bi bi-funnel me-1"></i>Loc</button>
        </form>
    </div>
</div>

<!-- Table -->
<div class="card border-0 shadow-sm">
    <div class="card-body pt-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th>Ma</th>
                        <th>Tieu de</th>
                        <th>Lead / Customer</th>
                        <th>Opportunity</th>
                        <th class="text-end">Gia tri</th>
                        <th>Trang thai</th>
                        <th>Hieu luc</th>
                        <th>Ngay tao</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty quotations}">
                            <c:forEach var="q" items="${quotations}">
                                <tr>
                                    <td class="fw-medium"><small>${q.quotationCode}</small></td>
                                    <td>${q.title}</td>
                                    <td>
                                        <c:if test="${not empty q.leadId && not empty leadNameMap[q.leadId]}">
                                            <small><i class="bi bi-person text-primary me-1"></i>${leadNameMap[q.leadId]}</small>
                                        </c:if>
                                        <c:if test="${not empty q.customerId && not empty customerNameMap[q.customerId]}">
                                            <small><i class="bi bi-building text-success me-1"></i>${customerNameMap[q.customerId]}</small>
                                        </c:if>
                                        <c:if test="${empty q.leadId && empty q.customerId}">
                                            <small class="text-muted">-</small>
                                        </c:if>
                                    </td>
                                    <td><small class="text-muted">${oppNameMap[q.opportunityId]}</small></td>
                                    <td class="text-end fw-semibold">
                                        <c:if test="${not empty q.totalAmount && q.totalAmount > 0}">
                                            <fmt:formatNumber value="${q.totalAmount}" type="number" groupingUsed="true" maxFractionDigits="0"/> d
                                        </c:if>
                                        <c:if test="${empty q.totalAmount || q.totalAmount == 0}">-</c:if>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${q.status == 'Draft'}"><span class="badge bg-secondary-subtle text-secondary">De xuat</span></c:when>
                                            <c:when test="${q.status == 'Approved'}"><span class="badge bg-success-subtle text-success">Da duyet</span></c:when>
                                            <c:when test="${q.status == 'Sent'}"><span class="badge bg-warning-subtle text-warning">Bao gia</span></c:when>
                                            <c:when test="${q.status == 'Accepted'}"><span class="badge bg-primary-subtle text-primary">Chap nhan</span></c:when>
                                            <c:when test="${q.status == 'Rejected'}"><span class="badge bg-danger-subtle text-danger">Tu choi</span></c:when>
                                            <c:otherwise><span class="badge bg-secondary-subtle text-secondary">${q.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><small class="text-muted">${q.validUntil}</small></td>
                                    <td><small class="text-muted">${q.createdAt != null ? q.createdAt.toLocalDate() : '-'}</small></td>
                                    <td>
                                        <div class="dropdown">
                                            <button class="btn btn-sm btn-light" data-bs-toggle="dropdown"><i class="bi bi-three-dots-vertical"></i></button>
                                            <ul class="dropdown-menu dropdown-menu-end">
                                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/sale/quotation/form?id=${q.quotationId}"><i class="bi bi-eye me-2"></i>Xem / Sua</a></li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr><td colspan="9" class="text-center text-muted py-4"><i class="bi bi-inbox me-1"></i>Chua co de xuat nao</td></tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>
