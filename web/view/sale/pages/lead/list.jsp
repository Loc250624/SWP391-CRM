<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">Quan ly Lead</h4>
        <p class="text-muted mb-0">Danh sach khach hang tiem nang</p>
    </div>
    <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/sale/lead/form" class="btn btn-primary btn-sm"><i class="bi bi-plus-lg me-1"></i>Them Lead</a>
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
        <i class="bi bi-exclamation-triangle-fill me-2"></i>Ban khong co quyen truy cap lead nay!
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${param.error == 'delete_failed'}">
    <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i>Xoa lead that bai. Vui long thu lai.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${param.error == 'not_found'}">
    <div class="alert alert-warning alert-dismissible fade show d-flex align-items-center" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i>Khong tim thay lead.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<!-- KPI Cards -->
<div class="row g-3 mb-4">
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center mb-3">
                    <div class="bg-primary bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-people text-primary fs-4"></i></div>
                    <div class="flex-grow-1">
                        <small class="text-muted">Tong Lead</small>
                        <h3 class="mb-0 fw-bold">${totalLeads}</h3>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center mb-3">
                    <div class="bg-info bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-person-check text-info fs-4"></i></div>
                    <div class="flex-grow-1">
                        <small class="text-muted">Assigned</small>
                        <h3 class="mb-0 fw-bold">${assignedLeads}</h3>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center mb-3">
                    <div class="bg-danger bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-fire text-danger fs-4"></i></div>
                    <div class="flex-grow-1">
                        <small class="text-muted">Lead Hot</small>
                        <h3 class="mb-0 fw-bold">${hotLeads}</h3>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center mb-3">
                    <div class="bg-success bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-check-circle text-success fs-4"></i></div>
                    <div class="flex-grow-1">
                        <small class="text-muted">Da chuyen doi</small>
                        <h3 class="mb-0 fw-bold">${convertedLeads}</h3>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Filters -->
<div class="card border-0 shadow-sm mb-4">
    <div class="card-body py-2">
        <form method="GET" action="${pageContext.request.contextPath}/sale/lead/list" class="d-flex gap-2 align-items-center flex-wrap" id="filterForm">
            <span class="text-muted small me-1"><i class="bi bi-funnel me-1"></i>Loc:</span>
            <select class="form-select form-select-sm" style="width:auto;" name="status" onchange="this.form.submit()">
                <option value="">Tat ca trang thai</option>
                <option value="Assigned" ${filterStatus == 'Assigned' ? 'selected' : ''}>Assigned</option>
                <option value="Unqualified" ${filterStatus == 'Unqualified' ? 'selected' : ''}>Unqualified</option>
                <option value="Recycled" ${filterStatus == 'Recycled' ? 'selected' : ''}>Recycled</option>
                <option value="Nurturing" ${filterStatus == 'Nurturing' ? 'selected' : ''}>Nurturing</option>
                <option value="Converted" ${filterStatus == 'Converted' ? 'selected' : ''}>Converted</option>
            </select>
            <select class="form-select form-select-sm" style="width:auto;" name="rating" onchange="this.form.submit()">
                <option value="">Tat ca rating</option>
                <option value="Hot" ${filterRating == 'Hot' ? 'selected' : ''}>Hot</option>
                <option value="Warm" ${filterRating == 'Warm' ? 'selected' : ''}>Warm</option>
                <option value="Cold" ${filterRating == 'Cold' ? 'selected' : ''}>Cold</option>
            </select>
            <div class="input-group input-group-sm" style="width: 240px;">
                <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
                <input type="text" class="form-control" placeholder="Tim kiem lead..." name="search" value="${searchQuery}">
                <button type="submit" class="btn btn-outline-secondary"><i class="bi bi-search"></i></button>
            </div>
            <c:if test="${not empty filterStatus || not empty filterRating || not empty searchQuery}">
                <a href="${pageContext.request.contextPath}/sale/lead/list" class="btn btn-outline-secondary btn-sm"><i class="bi bi-x-lg me-1"></i>Xoa loc</a>
            </c:if>
        </form>
    </div>
</div>

<!-- Lead Table -->
<div class="card border-0 shadow-sm">
    <div class="card-body p-0">
        <c:choose>
            <c:when test="${empty leadList}">
                <div class="text-center py-5">
                    <div class="mb-3"><i class="bi bi-people text-muted" style="font-size: 3rem;"></i></div>
                    <h5 class="fw-semibold text-muted">Chua co lead nao</h5>
                    <p class="text-muted mb-3">
                        <c:choose>
                            <c:when test="${not empty filterStatus || not empty filterRating || not empty searchQuery}">Khong tim thay lead phu hop voi bo loc</c:when>
                            <c:otherwise>Bat dau bang cach tao lead dau tien</c:otherwise>
                        </c:choose>
                    </p>
                    <c:choose>
                        <c:when test="${not empty filterStatus || not empty filterRating || not empty searchQuery}">
                            <a href="${pageContext.request.contextPath}/sale/lead/list" class="btn btn-outline-primary btn-sm"><i class="bi bi-x-lg me-1"></i>Xoa bo loc</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/sale/lead/form" class="btn btn-primary btn-sm"><i class="bi bi-plus-lg me-1"></i>Tao Lead</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th style="width:40px;"><input type="checkbox" class="form-check-input" id="checkAll"></th>
                                <th>Ma Lead</th>
                                <th>Ho ten</th>
                                <th>Lien he</th>
                                <th>Cong ty</th>
                                <th>Trang thai</th>
                                <th>Rating</th>
                                <th>Nguon</th>
                                <th>Diem</th>
                                <th>Ngay tao</th>
                                <th class="text-center" style="width:130px;">Thao tac</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="lead" items="${leadList}">
                                <tr>
                                    <td><input type="checkbox" class="form-check-input row-check" value="${lead.leadId}"></td>
                                    <td><span class="fw-semibold text-primary">${lead.leadCode}</span></td>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center flex-shrink-0" style="width:32px;height:32px;font-size:11px;font-weight:600;">
                                                <c:choose>
                                                    <c:when test="${not empty lead.fullName}">${lead.fullName.substring(0,1)}</c:when>
                                                    <c:otherwise>?</c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div>
                                                <div class="fw-medium">${lead.fullName}</div>
                                                <c:if test="${not empty lead.jobTitle}">
                                                    <small class="text-muted">${lead.jobTitle}</small>
                                                </c:if>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <c:if test="${not empty lead.email}"><small class="d-block"><i class="bi bi-envelope me-1 text-muted"></i>${lead.email}</small></c:if>
                                        <c:if test="${not empty lead.phone}"><small class="d-block"><i class="bi bi-telephone me-1 text-muted"></i>${lead.phone}</small></c:if>
                                        <c:if test="${empty lead.email && empty lead.phone}"><span class="text-muted">-</span></c:if>
                                        </td>
                                        <td>
                                        <c:choose>
                                            <c:when test="${not empty lead.companyName}">${lead.companyName}</c:when>
                                            <c:otherwise><span class="text-muted">-</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${lead.status == 'Assigned'}"><span class="badge bg-primary-subtle text-primary">Assigned</span></c:when>
                                            <c:when test="${lead.status == 'Unqualified'}"><span class="badge bg-secondary-subtle text-secondary">Unqualified</span></c:when>
                                            <c:when test="${lead.status == 'Recycled'}"><span class="badge bg-warning-subtle text-warning">Recycled</span></c:when>
                                            <c:when test="${lead.status == 'Nurturing'}"><span class="badge bg-info-subtle text-info">Nurturing</span></c:when>
                                            <c:when test="${lead.status == 'Converted'}"><span class="badge bg-success">Converted</span></c:when>
                                            <c:otherwise><span class="badge bg-secondary-subtle text-secondary">${lead.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${lead.rating == 'Hot'}"><span class="badge bg-danger">Hot</span></c:when>
                                            <c:when test="${lead.rating == 'Warm'}"><span class="badge bg-warning text-dark">Warm</span></c:when>
                                            <c:when test="${lead.rating == 'Cold'}"><span class="badge bg-secondary">Cold</span></c:when>
                                            <c:otherwise><span class="text-muted">-</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty lead.sourceId && not empty sourceNameMap[lead.sourceId]}">
                                                <small class="text-muted">${sourceNameMap[lead.sourceId]}</small>
                                            </c:when>
                                            <c:otherwise><small class="text-muted">-</small></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center gap-1">
                                            <div class="progress" style="width:40px;height:5px;">
                                                <div class="progress-bar
                                                     <c:choose>
                                                         <c:when test="${lead.leadScore >= 70}">bg-success</c:when>
                                                         <c:when test="${lead.leadScore >= 40}">bg-warning</c:when>
                                                         <c:otherwise>bg-danger</c:otherwise>
                                                     </c:choose>" style="width:${lead.leadScore}%;"></div>
                                            </div>
                                            <small class="fw-semibold">${lead.leadScore}</small>
                                        </div>
                                    </td>
                                    <td>
                                        <small class="text-muted">
                                            <c:if test="${not empty lead.createdAt}">${lead.createdAt.toString().substring(0, 10)}</c:if>
                                            <c:if test="${empty lead.createdAt}">-</c:if>
                                            </small>
                                        </td>
                                        <td class="text-center">
                                            <div class="btn-group btn-group-sm">
                                                <a href="${pageContext.request.contextPath}/sale/lead/detail?id=${lead.leadId}" class="btn btn-outline-primary btn-sm" title="Xem chi tiet"><i class="bi bi-eye"></i></a>
                                            <a href="${pageContext.request.contextPath}/sale/lead/form?id=${lead.leadId}" class="btn btn-outline-secondary btn-sm" title="Chinh sua"><i class="bi bi-pencil"></i></a>
                                            <button onclick="deleteLead(${lead.leadId}, '${lead.fullName}')" class="btn btn-outline-danger btn-sm" title="Xoa"><i class="bi bi-trash"></i></button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    <!-- Pagination -->
    <c:if test="${totalPages > 1}">
        <div class="card-footer bg-transparent d-flex justify-content-between align-items-center">
            <small class="text-muted">Hien thi ${(currentPage - 1) * 10 + 1}-${currentPage * 10 > totalItems ? totalItems : currentPage * 10} / ${totalItems} lead</small>
            <nav>
                <ul class="pagination pagination-sm mb-0">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/sale/lead/list?page=${currentPage - 1}&status=${filterStatus}&rating=${filterRating}&search=${searchQuery}"><i class="bi bi-chevron-left"></i></a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:if test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/sale/lead/list?page=${i}&status=${filterStatus}&rating=${filterRating}&search=${searchQuery}">${i}</a>
                            </li>
                        </c:if>
                        <c:if test="${(i == currentPage - 3 && i > 1) || (i == currentPage + 3 && i < totalPages)}">
                            <li class="page-item disabled"><span class="page-link">...</span></li>
                        </c:if>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/sale/lead/list?page=${currentPage + 1}&status=${filterStatus}&rating=${filterRating}&search=${searchQuery}"><i class="bi bi-chevron-right"></i></a>
                    </li>
                </ul>
            </nav>
        </div>
    </c:if>
</div>

<script>
    function deleteLead(leadId, leadName) {
        if (confirm('Ban co chac muon xoa lead "' + leadName + '"?\nLuu y: Tat ca Opportunity lien quan cung se bi huy (Cancelled).')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/sale/lead/list';
            form.innerHTML = '<input type="hidden" name="action" value="delete"><input type="hidden" name="leadId" value="' + leadId + '">';
            document.body.appendChild(form);
            form.submit();
        }
    }

// Check all checkbox
    document.getElementById('checkAll')?.addEventListener('change', function () {
        document.querySelectorAll('.row-check').forEach(function (cb) {
            cb.checked = this.checked;
        }.bind(this));
    });
</script>
