<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">Quan ly Customer</h4>
        <p class="text-muted mb-0">Danh sach khach hang</p>
    </div>
    <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/sale/customer/form" class="btn btn-primary btn-sm"><i class="bi bi-plus-lg me-1"></i>Them Customer</a>
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
        <i class="bi bi-exclamation-triangle-fill me-2"></i>Ban khong co quyen truy cap customer nay!
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${param.error == 'delete_failed'}">
    <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i>Xoa customer that bai. Vui long thu lai.
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
                        <small class="text-muted">Tong Customer</small>
                        <h4 class="mb-0 fw-bold">${totalCustomers}</h4>
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
                        <small class="text-muted">Dang hoat dong</small>
                        <h4 class="mb-0 fw-bold">${activeCustomers}</h4>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center mb-3">
                    <div class="bg-warning bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-star text-warning fs-4"></i></div>
                    <div class="flex-grow-1">
                        <small class="text-muted">Khach VIP</small>
                        <h4 class="mb-0 fw-bold">${vipCustomers}</h4>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center mb-3">
                    <div class="bg-info bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-person-plus text-info fs-4"></i></div>
                    <div class="flex-grow-1">
                        <small class="text-muted">Khach moi</small>
                        <h4 class="mb-0 fw-bold">${newCustomers}</h4>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Filter & Search -->
<div class="card border-0 shadow-sm mb-4">
    <div class="card-body py-3">
        <form method="GET" action="${pageContext.request.contextPath}/sale/customer/list" class="row g-2 align-items-end">
            <div class="col-md-3">
                <label class="form-label small text-muted mb-1">Tim kiem</label>
                <input type="text" name="search" class="form-control form-control-sm" placeholder="Ten, email, SDT, ma KH..." value="${searchQuery}">
            </div>
            <div class="col-md-2">
                <label class="form-label small text-muted mb-1">Trang thai</label>
                <select name="status" class="form-select form-select-sm" onchange="this.form.submit()">
                    <option value="">Tat ca</option>
                    <option value="Active" ${filterStatus == 'Active' ? 'selected' : ''}>Active</option>
                    <option value="Inactive" ${filterStatus == 'Inactive' ? 'selected' : ''}>Inactive</option>
                    <option value="Churned" ${filterStatus == 'Churned' ? 'selected' : ''}>Churned</option>
                    <option value="Blocked" ${filterStatus == 'Blocked' ? 'selected' : ''}>Blocked</option>
                </select>
            </div>
            <div class="col-md-2">
                <label class="form-label small text-muted mb-1">Phan khuc</label>
                <select name="segment" class="form-select form-select-sm" onchange="this.form.submit()">
                    <option value="">Tat ca</option>
                    <option value="New" ${filterSegment == 'New' ? 'selected' : ''}>New</option>
                    <option value="Returning" ${filterSegment == 'Returning' ? 'selected' : ''}>Returning</option>
                    <option value="VIP" ${filterSegment == 'VIP' ? 'selected' : ''}>VIP</option>
                    <option value="Champion" ${filterSegment == 'Champion' ? 'selected' : ''}>Champion</option>
                    <option value="Risk" ${filterSegment == 'Risk' ? 'selected' : ''}>Risk</option>
                </select>
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-outline-primary btn-sm w-100"><i class="bi bi-search me-1"></i>Loc</button>
            </div>
            <div class="col-md-2">
                <a href="${pageContext.request.contextPath}/sale/customer/list" class="btn btn-outline-secondary btn-sm w-100"><i class="bi bi-arrow-counterclockwise me-1"></i>Xoa loc</a>
            </div>
        </form>
    </div>
</div>

<!-- Customer Table -->
<div class="card border-0 shadow-sm">
    <div class="card-body p-0">
        <c:choose>
            <c:when test="${not empty customerList}">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light">
                            <tr>
                                <th class="ps-3" style="width: 40px;"><input type="checkbox" class="form-check-input" id="checkAll"></th>
                                <th>Khach hang</th>
                                <th>Lien he</th>
                                <th>Phan khuc</th>
                                <th>Nguon</th>
                                <th class="text-center">Khoa hoc</th>
                                <th class="text-end">Tong chi</th>
                                <th class="text-center">Trang thai</th>
                                <th class="text-center">Ngay tao</th>
                                <th class="text-center" style="width: 140px;">Thao tac</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="cust" items="${customerList}">
                                <tr>
                                    <td class="ps-3"><input type="checkbox" class="form-check-input row-check" value="${cust.customerId}"></td>
                                    <td>
                                        <div class="fw-semibold">${cust.fullName}</div>
                                        <small class="text-muted">${cust.customerCode}</small>
                                    </td>
                                    <td>
                                        <c:if test="${not empty cust.email}">
                                            <div><small><i class="bi bi-envelope me-1 text-muted"></i>${cust.email}</small></div>
                                        </c:if>
                                        <c:if test="${not empty cust.phone}">
                                            <div><small><i class="bi bi-telephone me-1 text-muted"></i>${cust.phone}</small></div>
                                        </c:if>
                                        <c:if test="${empty cust.email and empty cust.phone}">
                                            <span class="text-muted">-</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${cust.customerSegment == 'VIP'}"><span class="badge bg-warning-subtle text-warning">VIP</span></c:when>
                                            <c:when test="${cust.customerSegment == 'Champion'}"><span class="badge bg-success-subtle text-success">Champion</span></c:when>
                                            <c:when test="${cust.customerSegment == 'New'}"><span class="badge bg-info-subtle text-info">New</span></c:when>
                                            <c:when test="${cust.customerSegment == 'Returning'}"><span class="badge bg-primary-subtle text-primary">Returning</span></c:when>
                                            <c:when test="${cust.customerSegment == 'Risk'}"><span class="badge bg-danger-subtle text-danger">Risk</span></c:when>
                                            <c:otherwise><span class="badge bg-secondary">${cust.customerSegment}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty sourceNameMap[cust.sourceId]}">
                                                <small>${sourceNameMap[cust.sourceId]}</small>
                                            </c:when>
                                            <c:otherwise><span class="text-muted">-</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <span class="fw-semibold">${cust.totalCourses}</span>
                                    </td>
                                    <td class="text-end">
                                        <c:choose>
                                            <c:when test="${not empty cust.totalSpent and cust.totalSpent > 0}">
                                                <span class="fw-semibold text-success"><fmt:formatNumber value="${cust.totalSpent}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</span>
                                            </c:when>
                                            <c:otherwise><span class="text-muted">0</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${cust.status == 'Active'}"><span class="badge bg-success-subtle text-success">Active</span></c:when>
                                            <c:when test="${cust.status == 'Inactive'}"><span class="badge bg-secondary-subtle text-secondary">Inactive</span></c:when>
                                            <c:when test="${cust.status == 'Churned'}"><span class="badge bg-danger-subtle text-danger">Churned</span></c:when>
                                            <c:when test="${cust.status == 'Blocked'}"><span class="badge bg-dark">Blocked</span></c:when>
                                            <c:otherwise><span class="badge bg-secondary">${cust.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <small>
                                        <c:choose>
                                            <c:when test="${not empty cust.createdAt}">${cust.createdAt.toString().substring(0, 10)}</c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                        </small>
                                    </td>
                                    <td class="text-center">
                                        <div class="btn-group btn-group-sm">
                                            <a href="${pageContext.request.contextPath}/sale/customer/detail?id=${cust.customerId}" class="btn btn-outline-primary btn-sm" title="Xem chi tiet"><i class="bi bi-eye"></i></a>
                                            <a href="${pageContext.request.contextPath}/sale/customer/form?id=${cust.customerId}" class="btn btn-outline-secondary btn-sm" title="Chinh sua"><i class="bi bi-pencil"></i></a>
                                            <button onclick="deleteCustomer(${cust.customerId}, '${cust.fullName}')" class="btn btn-outline-danger btn-sm" title="Xoa"><i class="bi bi-trash"></i></button>
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
                    <i class="bi bi-people text-muted" style="font-size: 3rem;"></i>
                    <p class="text-muted mt-3 mb-2">Chua co customer nao</p>
                    <a href="${pageContext.request.contextPath}/sale/customer/form" class="btn btn-primary btn-sm"><i class="bi bi-plus-lg me-1"></i>Them Customer</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    <!-- Pagination -->
    <c:if test="${totalPages > 1}">
        <div class="card-footer bg-transparent d-flex justify-content-between align-items-center">
            <small class="text-muted">Hien thi ${(currentPage - 1) * 10 + 1}-${currentPage * 10 > totalItems ? totalItems : currentPage * 10} / ${totalItems} customer</small>
            <nav>
                <ul class="pagination pagination-sm mb-0">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/sale/customer/list?page=${currentPage - 1}&status=${filterStatus}&segment=${filterSegment}&search=${searchQuery}"><i class="bi bi-chevron-left"></i></a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:if test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/sale/customer/list?page=${i}&status=${filterStatus}&segment=${filterSegment}&search=${searchQuery}">${i}</a>
                            </li>
                        </c:if>
                        <c:if test="${(i == currentPage - 3 && i > 1) || (i == currentPage + 3 && i < totalPages)}">
                            <li class="page-item disabled"><span class="page-link">...</span></li>
                        </c:if>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/sale/customer/list?page=${currentPage + 1}&status=${filterStatus}&segment=${filterSegment}&search=${searchQuery}"><i class="bi bi-chevron-right"></i></a>
                    </li>
                </ul>
            </nav>
        </div>
    </c:if>
</div>

<script>
    function deleteCustomer(customerId, customerName) {
        if (confirm('Ban co chac muon xoa customer "' + customerName + '"?\nHanh dong nay khong the hoan tac.')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/sale/customer/list';
            form.innerHTML = '<input type="hidden" name="action" value="delete"><input type="hidden" name="customerId" value="' + customerId + '">';
            document.body.appendChild(form);
            form.submit();
        }
    }

    document.getElementById('checkAll')?.addEventListener('change', function () {
        document.querySelectorAll('.row-check').forEach(function (cb) {
            cb.checked = this.checked;
        }.bind(this));
    });
</script>
