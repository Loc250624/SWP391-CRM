<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:if test="${param.success == '1'}">
    <script>document.addEventListener('DOMContentLoaded', function(){ CRM.showToast('Lưu hoạt động thành công!', 'success'); });</script>
</c:if>
<c:if test="${param.deleted == '1'}">
    <script>document.addEventListener('DOMContentLoaded', function(){ CRM.showToast('Đã xóa hoạt động.', 'info'); });</script>
</c:if>

<div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
    <div>
        <h4 class="mb-1 fw-bold"><i class="bi bi-activity me-2"></i>Danh sách hoạt động</h4>
        <p class="text-muted mb-0">Tất cả hoạt động bán hàng của bạn</p>
    </div>
    <a href="${pageContext.request.contextPath}/sale/activity/form" class="btn btn-primary btn-sm"><i class="bi bi-plus-lg me-1"></i>Ghi nhận hoạt động</a>
</div>

<!-- KPI -->
<div class="row g-3 mb-4">
    <div class="col-md-3">
        <div class="card border-0 shadow-sm">
            <div class="card-body">
                <div class="text-muted small">Tổng hoạt động</div>
                <div class="h4 mb-1">${stats['total'] != null ? stats['total'] : 0}</div>
                <div class="small text-muted">Tổng cộng</div>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card border-0 shadow-sm">
            <div class="card-body">
                <div class="text-muted small">Cuộc gọi (Call)</div>
                <div class="h4 mb-1">${stats['calls'] != null ? stats['calls'] : 0}</div>
                <div class="small text-muted">Tổng cộng</div>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card border-0 shadow-sm">
            <div class="card-body">
                <div class="text-muted small">Email</div>
                <div class="h4 mb-1">${stats['emails'] != null ? stats['emails'] : 0}</div>
                <div class="small text-muted">Tổng cộng</div>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card border-0 shadow-sm">
            <div class="card-body">
                <div class="text-muted small">Lịch hẹn (Meeting)</div>
                <div class="h4 mb-1">${stats['meetings'] != null ? stats['meetings'] : 0}</div>
                <div class="small text-muted">Tổng cộng</div>
            </div>
        </div>
    </div>
</div>

<!-- Bộ lọc -->
<div class="card mb-4">
    <div class="card-body">
        <form method="GET" action="${pageContext.request.contextPath}/sale/activity/list">
            <div class="row g-3 align-items-end">
                <div class="col-md-2">
                    <label class="form-label">Loại hoạt động</label>
                    <select class="form-select" name="type">
                        <option value="" ${empty typeFilter ? 'selected' : ''}>Tất cả</option>
                        <option value="Call" ${typeFilter == 'Call' ? 'selected' : ''}>Cuộc gọi</option>
                        <option value="Email" ${typeFilter == 'Email' ? 'selected' : ''}>Email</option>
                        <option value="Meeting" ${typeFilter == 'Meeting' ? 'selected' : ''}>Cuộc họp</option>
                        <option value="Note" ${typeFilter == 'Note' ? 'selected' : ''}>Ghi chú</option>
                        <option value="REPORT" ${typeFilter == 'REPORT' ? 'selected' : ''}>Báo cáo</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Đối tượng</label>
                    <select class="form-select" name="relatedType">
                        <option value="" ${empty relatedTypeFilter ? 'selected' : ''}>Tất cả</option>
                        <option value="Lead" ${relatedTypeFilter == 'Lead' ? 'selected' : ''}>Lead</option>
                        <option value="Customer" ${relatedTypeFilter == 'Customer' ? 'selected' : ''}>Customer</option>
                        <option value="Opportunity" ${relatedTypeFilter == 'Opportunity' ? 'selected' : ''}>Opportunity</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Trạng thái</label>
                    <select class="form-select" name="status">
                        <option value="" ${empty statusFilter ? 'selected' : ''}>Tất cả</option>
                        <option value="Completed" ${statusFilter == 'Completed' ? 'selected' : ''}>Hoàn thành</option>
                        <option value="Pending" ${statusFilter == 'Pending' ? 'selected' : ''}>Đang chờ</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Từ ngày</label>
                    <input type="date" class="form-control" name="startDate" value="${startDate}">
                </div>
                <div class="col-md-2">
                    <label class="form-label">Đến ngày</label>
                    <input type="date" class="form-control" name="endDate" value="${endDate}">
                </div>
                <div class="col-md-2 d-flex gap-2">
                    <button type="submit" class="btn btn-primary flex-fill"><i class="bi bi-search me-1"></i>Tìm</button>
                    <a href="${pageContext.request.contextPath}/sale/activity/list" class="btn btn-outline-secondary"><i class="bi bi-x-circle me-1"></i>Reset</a>
                </div>
            </div>
            <c:if test="${not empty keyword || not empty typeFilter}">
                <div class="row mt-2">
                    <div class="col-md-4">
                        <input type="text" class="form-control" name="keyword" placeholder="Tìm kiếm tiêu đề, mô tả..." value="${keyword}">
                    </div>
                </div>
            </c:if>
            <c:if test="${empty keyword && empty typeFilter}">
                <div class="row mt-2">
                    <div class="col-md-4">
                        <input type="text" class="form-control" name="keyword" placeholder="Tìm kiếm tiêu đề, mô tả..." value="${keyword}">
                    </div>
                </div>
            </c:if>
        </form>
    </div>
</div>

<!-- Bảng danh sách -->
<div class="card">
    <div class="card-header bg-white">
        <h5 class="mb-0">Danh sách hoạt động <span class="text-muted small fw-normal">(${totalCount} kết quả)</span></h5>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th>Thời gian</th>
                        <th>Loại</th>
                        <th>Tiêu đề</th>
                        <th>Đối tượng</th>
                        <th>Người thực hiện</th>
                        <th>Thời lượng</th>
                        <th>Trạng thái</th>
                        <th class="text-end" style="width:100px">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty activities}">
                            <c:forEach var="act" items="${activities}">
                                <tr>
                                    <td class="small">
                                        <c:if test="${not empty act.activityDate}">${act.activityDate.toString().substring(0, 16).replace('T', ' ')}</c:if>
                                        <c:if test="${empty act.activityDate}"><span class="text-muted">--</span></c:if>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${act.activityType == 'Call'}"><span class="badge bg-success-subtle text-success border border-success-subtle">Call</span></c:when>
                                            <c:when test="${act.activityType == 'Email'}"><span class="badge bg-info-subtle text-info border border-info-subtle">Email</span></c:when>
                                            <c:when test="${act.activityType == 'Meeting'}"><span class="badge bg-primary-subtle text-primary border border-primary-subtle">Meeting</span></c:when>
                                            <c:when test="${act.activityType == 'Note'}"><span class="badge bg-warning-subtle text-warning border border-warning-subtle">Note</span></c:when>
                                            <c:when test="${act.activityType == 'REPORT'}"><span class="badge bg-dark-subtle text-dark border border-dark-subtle">Report</span></c:when>
                                            <c:otherwise><span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle">${act.activityType}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="fw-semibold">${act.subject}</div>
                                        <c:if test="${not empty act.description}">
                                            <div class="text-muted small text-truncate" style="max-width:250px;">${act.description}</div>
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:if test="${not empty act.relatedType}">
                                            <c:choose>
                                                <c:when test="${act.relatedType == 'Lead'}"><span class="badge bg-info-subtle text-info border border-info-subtle">Lead</span></c:when>
                                                <c:when test="${act.relatedType == 'Customer'}"><span class="badge bg-primary-subtle text-primary border border-primary-subtle">Customer</span></c:when>
                                                <c:when test="${act.relatedType == 'Opportunity'}"><span class="badge bg-success-subtle text-success border border-success-subtle">Opportunity</span></c:when>
                                                <c:otherwise><span class="text-muted">${act.relatedType}</span></c:otherwise>
                                            </c:choose>
                                            <c:if test="${not empty act.customerName}">
                                                <div class="text-muted small mt-1">${act.customerName}</div>
                                            </c:if>
                                        </c:if>
                                        <c:if test="${empty act.relatedType}"><span class="text-muted">--</span></c:if>
                                    </td>
                                    <td>
                                        <c:if test="${not empty act.performerName}"><div class="fw-semibold">${act.performerName}</div></c:if>
                                        <c:if test="${empty act.performerName}"><span class="text-muted">--</span></c:if>
                                    </td>
                                    <td class="small">
                                        <c:if test="${not empty act.durationMinutes && act.durationMinutes > 0}">${act.durationMinutes} phút</c:if>
                                        <c:if test="${empty act.durationMinutes || act.durationMinutes == 0}"><span class="text-muted">--</span></c:if>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${act.status == 'Completed'}"><span class="badge bg-success-subtle text-success border border-success-subtle">Hoàn thành</span></c:when>
                                            <c:when test="${act.status == 'Pending'}"><span class="badge bg-warning-subtle text-warning border border-warning-subtle">Đang chờ</span></c:when>
                                            <c:otherwise><span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle">${act.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end">
                                        <div class="d-flex gap-1 justify-content-end">
                                            <a href="${pageContext.request.contextPath}/sale/activity/detail?id=${act.activityId}" class="btn btn-sm btn-outline-secondary" title="Xem chi tiết"><i class="bi bi-eye"></i></a>
                                            <button type="button" class="btn btn-sm btn-outline-danger" title="Xóa" onclick="deleteActivityFromList(${act.activityId})"><i class="bi bi-trash"></i></button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr><td colspan="8" class="text-center text-muted py-4">Không có dữ liệu hoạt động</td></tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
    <!-- Phân trang -->
    <c:if test="${totalPages > 1}">
        <div class="card-footer bg-white">
            <nav>
                <ul class="pagination pagination-sm mb-0 justify-content-center">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/sale/activity/list?page=${currentPage - 1}&type=${typeFilter}&keyword=${keyword}&status=${statusFilter}&relatedType=${relatedTypeFilter}&startDate=${startDate}&endDate=${endDate}">&laquo;</a>
                    </li>
                    <c:forEach begin="${currentPage - 2 > 0 ? currentPage - 2 : 1}" end="${currentPage + 2 < totalPages ? currentPage + 2 : totalPages}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/sale/activity/list?page=${i}&type=${typeFilter}&keyword=${keyword}&status=${statusFilter}&relatedType=${relatedTypeFilter}&startDate=${startDate}&endDate=${endDate}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/sale/activity/list?page=${currentPage + 1}&type=${typeFilter}&keyword=${keyword}&status=${statusFilter}&relatedType=${relatedTypeFilter}&startDate=${startDate}&endDate=${endDate}">&raquo;</a>
                    </li>
                </ul>
            </nav>
        </div>
    </c:if>
</div>

<!-- Hidden form for delete -->
<form id="deleteForm" method="POST" action="${pageContext.request.contextPath}/sale/activity/cancel" style="display:none;">
    <input type="hidden" name="activityId" id="deleteActivityId">
</form>

<script>
function deleteActivityFromList(activityId) {
    if (confirm('Bạn có chắc muốn xóa hoạt động này?\nHành động này không thể hoàn tác.')) {
        document.getElementById('deleteActivityId').value = activityId;
        document.getElementById('deleteForm').submit();
    }
}
</script>
