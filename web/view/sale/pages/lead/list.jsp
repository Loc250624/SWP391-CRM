<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">Quản lý Lead</h4>
        <p class="text-muted mb-0">Danh sách khách hàng tiềm năng</p>
    </div>
    <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/sale/lead/form" class="btn btn-primary btn-sm"><i class="bi bi-plus-lg me-1"></i>Thêm Lead</a>
    </div>
</div>

<!-- Toast Messages -->
<c:if test="${not empty successMessage}">
    <script>document.addEventListener('DOMContentLoaded', function(){ CRM.showToast('${successMessage}', 'success'); });</script>
</c:if>
<c:if test="${param.error == 'no_permission'}">
    <script>document.addEventListener('DOMContentLoaded', function(){ CRM.showToast('Bạn không có quyền truy cập lead này!', 'error'); });</script>
</c:if>
<c:if test="${param.error == 'delete_failed'}">
    <script>document.addEventListener('DOMContentLoaded', function(){ CRM.showToast('Xóa lead thất bại. Vui lòng thử lại.', 'error'); });</script>
</c:if>
<c:if test="${param.error == 'not_found'}">
    <script>document.addEventListener('DOMContentLoaded', function(){ CRM.showToast('Không tìm thấy lead.', 'warning'); });</script>
</c:if>

<!-- Tabs -->
<ul class="nav nav-tabs mb-4">
    <li class="nav-item">
        <a class="nav-link ${activeTab == 'assigned' ? 'active' : ''}" href="${pageContext.request.contextPath}/sale/lead/list?tab=assigned">Lead được giao</a>
    </li>
    <li class="nav-item">
        <a class="nav-link ${activeTab == 'created' ? 'active' : ''}" href="${pageContext.request.contextPath}/sale/lead/list?tab=created">Lead tôi tạo</a>
    </li>
</ul>

<!-- KPI Cards -->
<div class="row g-3 mb-4">
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center mb-3">
                    <div class="bg-primary bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-people text-primary fs-4"></i></div>
                    <div class="flex-grow-1">
                        <small class="text-muted">Tổng Lead</small>
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
                        <small class="text-muted">Đã chuyển đổi</small>
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
            <input type="hidden" name="tab" value="${activeTab}">
            <span class="text-muted small me-1"><i class="bi bi-funnel me-1"></i>Lọc:</span>
            <select class="form-select form-select-sm" style="width:auto;" name="status" onchange="this.form.submit()">
                <option value="">Tất cả trạng thái</option>
                <option value="Assigned" ${filterStatus == 'Assigned' ? 'selected' : ''}>Assigned</option>
                <option value="Working" ${filterStatus == 'Working' ? 'selected' : ''}>Working</option>
                <option value="Unqualified" ${filterStatus == 'Unqualified' ? 'selected' : ''}>Unqualified</option>
                <option value="Nurturing" ${filterStatus == 'Nurturing' ? 'selected' : ''}>Nurturing</option>
                <option value="Converted" ${filterStatus == 'Converted' ? 'selected' : ''}>Converted</option>
                <option value="Inactive" ${filterStatus == 'Inactive' ? 'selected' : ''}>Inactive</option>

            </select>
            <select class="form-select form-select-sm" style="width:auto;" name="rating" onchange="this.form.submit()">
                <option value="">Tất cả rating</option>
                <option value="Hot" ${filterRating == 'Hot' ? 'selected' : ''}>Hot</option>
                <option value="Warm" ${filterRating == 'Warm' ? 'selected' : ''}>Warm</option>
                <option value="Cold" ${filterRating == 'Cold' ? 'selected' : ''}>Cold</option>
            </select>
            <div class="input-group input-group-sm" style="width: 240px;">
                <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
                <input type="text" class="form-control" placeholder="Tìm kiếm lead..." name="search" value="${searchQuery}">
                <button type="submit" class="btn btn-outline-secondary"><i class="bi bi-search"></i></button>
            </div>
            <c:if test="${not empty filterStatus || not empty filterRating || not empty searchQuery}">
                <a href="${pageContext.request.contextPath}/sale/lead/list?tab=${activeTab}" class="btn btn-outline-secondary btn-sm"><i class="bi bi-x-lg me-1"></i>Xóa lọc</a>
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
                    <h5 class="fw-semibold text-muted">Chưa có lead nào</h5>
                    <p class="text-muted mb-3">
                        <c:choose>
                            <c:when test="${not empty filterStatus || not empty filterRating || not empty searchQuery}">Không tìm thấy lead phù hợp với bộ lọc</c:when>
                            <c:otherwise>Bắt đầu bằng cách tạo lead đầu tiên</c:otherwise>
                        </c:choose>
                    </p>
                    <c:choose>
                        <c:when test="${not empty filterStatus || not empty filterRating || not empty searchQuery}">
                            <a href="${pageContext.request.contextPath}/sale/lead/list?tab=${activeTab}" class="btn btn-outline-primary btn-sm"><i class="bi bi-x-lg me-1"></i>Xóa bộ lọc</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/sale/lead/form" class="btn btn-primary btn-sm"><i class="bi bi-plus-lg me-1"></i>Tạo Lead</a>
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
                                <th>Mã Lead</th>
                                <th>Họ tên</th>
                                <th>Liên hệ</th>
                                <th>Công ty</th>
                                <th>Trạng thái</th>
                                <th>Rating</th>
                                <th>Nguồn</th>
                                <th>Điểm</th>
                                <th>Ngày tạo</th>
                                <th class="text-center" style="width:130px;">Thao tác</th>
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
                                                <a href="${pageContext.request.contextPath}/sale/lead/detail?id=${lead.leadId}" class="btn btn-outline-primary btn-sm" title="Xem chi tiết"><i class="bi bi-eye"></i></a>
                                            <a href="${pageContext.request.contextPath}/sale/lead/form?id=${lead.leadId}" class="btn btn-outline-secondary btn-sm" title="Chỉnh sửa"><i class="bi bi-pencil"></i></a>
                                                <c:if test="${lead.status != 'Inactive'}">
                                                <button onclick="showInactiveModal(${lead.leadId}, '${lead.fullName}', '${lead.leadCode}')" class="btn btn-outline-danger btn-sm" title="Vô hiệu hóa"><i class="bi bi-x-circle"></i></button>
                                                </c:if>
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
            <small class="text-muted">Hiển thị ${(currentPage - 1) * 10 + 1}-${currentPage * 10 > totalItems ? totalItems : currentPage * 10} / ${totalItems} lead</small>
            <nav>
                <ul class="pagination pagination-sm mb-0">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/sale/lead/list?page=${currentPage - 1}&tab=${activeTab}&status=${filterStatus}&rating=${filterRating}&search=${searchQuery}"><i class="bi bi-chevron-left"></i></a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:if test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/sale/lead/list?page=${i}&tab=${activeTab}&status=${filterStatus}&rating=${filterRating}&search=${searchQuery}">${i}</a>
                            </li>
                        </c:if>
                        <c:if test="${(i == currentPage - 3 && i > 1) || (i == currentPage + 3 && i < totalPages)}">
                            <li class="page-item disabled"><span class="page-link">...</span></li>
                            </c:if>
                        </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/sale/lead/list?page=${currentPage + 1}&tab=${activeTab}&status=${filterStatus}&rating=${filterRating}&search=${searchQuery}"><i class="bi bi-chevron-right"></i></a>
                    </li>
                </ul>
            </nav>
        </div>
    </c:if>
</div>

<!-- Inactive Confirmation Modal -->
<div class="modal fade" id="inactiveListModal" tabindex="-1" aria-labelledby="inactiveListModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="inactiveListModalLabel"><i class="bi bi-exclamation-triangle me-2"></i>Xác nhận vô hiệu hóa Lead</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="alert alert-warning d-flex align-items-start mb-3">
                    <i class="bi bi-exclamation-triangle-fill me-2 mt-1"></i>
                    <div>
                        <strong>Cảnh báo:</strong> Vô hiệu hóa lead <strong id="inactiveLeadName"></strong> (<span id="inactiveLeadCode"></span>) sẽ:
                        <ul class="mb-0 mt-1">
                            <li>Chuyển lead sang trạng thái <strong>Inactive</strong></li>
                            <li>Đóng (Cancelled) <strong>tất cả Opportunity</strong> liên quan</li>
                            <li>Các Opportunity bị đóng sẽ <strong>chỉ có thể xem</strong>, không thể chỉnh sửa</li>
                        </ul>
                    </div>
                </div>
                <div id="inactiveOppList">
                    <div class="text-center py-3">
                        <span class="spinner-border spinner-border-sm me-1"></span>Đang tải danh sách Opportunity...
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <form method="POST" action="${pageContext.request.contextPath}/sale/lead/form" class="d-inline" id="inactiveForm">
                    <input type="hidden" name="action" value="inactive">
                    <input type="hidden" name="leadId" id="inactiveLeadId" value="">
                    <button type="submit" class="btn btn-danger"><i class="bi bi-x-circle me-1"></i>Xác nhận vô hiệu hóa</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    function showInactiveModal(leadId, leadName, leadCode) {
        document.getElementById('inactiveLeadName').textContent = '"' + leadName + '"';
        document.getElementById('inactiveLeadCode').textContent = leadCode;
        document.getElementById('inactiveLeadId').value = leadId;

        // Fetch opportunities for this lead
        var oppListDiv = document.getElementById('inactiveOppList');
        oppListDiv.innerHTML = '<div class="text-center py-3"><span class="spinner-border spinner-border-sm me-1"></span>Đang tải danh sách Opportunity...</div>';

        fetch('${pageContext.request.contextPath}/sale/lead/opportunities?leadId=' + leadId)
                .then(function (resp) {
                    return resp.json();
                })
                .then(function (opps) {
                    if (opps.length === 0) {
                        oppListDiv.innerHTML = '<p class="text-muted mb-0"><i class="bi bi-info-circle me-1"></i>Lead này không có Opportunity nào.</p>';
                    } else {
                        var html = '<h6 class="fw-semibold mb-2">Các Opportunity sẽ bị đóng:</h6>';
                        html += '<div class="table-responsive"><table class="table table-sm table-bordered mb-0">';
                        html += '<thead class="table-light"><tr><th>Mã OPP</th><th>Tên Opportunity</th><th>Trạng thái</th><th>Giá trị</th></tr></thead><tbody>';
                        opps.forEach(function (opp) {
                            var statusBadge = '<span class="badge bg-secondary">' + opp.status + '</span>';
                            if (opp.status === 'Open')
                                statusBadge = '<span class="badge bg-primary-subtle text-primary">Open</span>';
                            else if (opp.status === 'InProgress')
                                statusBadge = '<span class="badge bg-info-subtle text-info">In Progress</span>';
                            else if (opp.status === 'Won')
                                statusBadge = '<span class="badge bg-success">Won</span>';
                            else if (opp.status === 'Lost')
                                statusBadge = '<span class="badge bg-danger">Lost</span>';
                            else if (opp.status === 'OnHold')
                                statusBadge = '<span class="badge bg-warning-subtle text-warning">On Hold</span>';
                            else if (opp.status === 'Cancelled')
                                statusBadge = '<span class="badge bg-secondary">Cancelled</span>';

                            var value = opp.estimatedValue ? Number(opp.estimatedValue).toLocaleString('vi-VN') + ' VND' : '-';
                            html += '<tr><td><span class="fw-semibold text-primary">' + opp.opportunityCode + '</span></td>';
                            html += '<td>' + opp.opportunityName + '</td>';
                            html += '<td>' + statusBadge + '</td>';
                            html += '<td>' + value + '</td></tr>';
                        });
                        html += '</tbody></table></div>';
                        oppListDiv.innerHTML = html;
                    }
                })
                .catch(function () {
                    oppListDiv.innerHTML = '<p class="text-muted mb-0"><i class="bi bi-info-circle me-1"></i>Không thể tải danh sách Opportunity.</p>';
                });

        var modal = new bootstrap.Modal(document.getElementById('inactiveListModal'));
        modal.show();
    }

    // Check all checkbox
    document.getElementById('checkAll')?.addEventListener('change', function () {
        document.querySelectorAll('.row-check').forEach(function (cb) {
            cb.checked = this.checked;
        }.bind(this));
    });
</script>
