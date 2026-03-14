<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:if test="${param.success == '1'}">
    <script>document.addEventListener('DOMContentLoaded', function(){ CRM.showToast('Luu hoat dong thanh cong!', 'success'); });</script>
</c:if>
<c:if test="${param.deleted == '1'}">
    <script>document.addEventListener('DOMContentLoaded', function(){ CRM.showToast('Da xoa hoat dong.', 'info'); });</script>
</c:if>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div><h4 class="mb-1 fw-bold">Danh sach Hoat dong</h4><p class="text-muted mb-0">Tat ca hoat dong ban hang</p></div>
    <a href="${pageContext.request.contextPath}/sale/activity/form" class="btn btn-primary btn-sm"><i class="bi bi-plus-lg me-1"></i>Ghi nhan hoat dong</a>
</div>

<div class="row g-3 mb-4">
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body py-3 text-center"><div class="fs-3 fw-bold text-primary">${stats['total'] != null ? stats['total'] : 0}</div><small class="text-muted">Tong hoat dong</small></div></div></div>
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body py-3 text-center"><div class="fs-3 fw-bold text-success">${stats['calls'] != null ? stats['calls'] : 0}</div><small class="text-muted">Cuoc goi</small></div></div></div>
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body py-3 text-center"><div class="fs-3 fw-bold text-info">${stats['emails'] != null ? stats['emails'] : 0}</div><small class="text-muted">Email</small></div></div></div>
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body py-3 text-center"><div class="fs-3 fw-bold text-warning">${stats['meetings'] != null ? stats['meetings'] : 0}</div><small class="text-muted">Cuoc hop</small></div></div></div>
</div>

<div class="card border-0 shadow-sm mb-4">
    <div class="card-body py-3">
        <form method="GET" action="${pageContext.request.contextPath}/sale/activity/list" class="d-flex gap-3 flex-wrap align-items-center">
            <div class="input-group" style="width: 300px;">
                <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-muted"></i></span>
                <input type="text" class="form-control bg-light border-start-0" name="keyword" placeholder="Tim kiem hoat dong..." value="${keyword}">
            </div>
            <select class="form-select form-select-sm" name="type" style="width: auto;">
                <option value="" ${empty typeFilter ? 'selected' : ''}>Tat ca loai</option>
                <option value="Call" ${typeFilter == 'Call' ? 'selected' : ''}>Cuoc goi</option>
                <option value="Email" ${typeFilter == 'Email' ? 'selected' : ''}>Email</option>
                <option value="Meeting" ${typeFilter == 'Meeting' ? 'selected' : ''}>Cuoc hop</option>
                <option value="Note" ${typeFilter == 'Note' ? 'selected' : ''}>Ghi chu</option>
                <option value="REPORT" ${typeFilter == 'REPORT' ? 'selected' : ''}>Bao cao</option>
            </select>
            <button type="submit" class="btn btn-sm btn-primary"><i class="bi bi-funnel me-1"></i>Loc</button>
        </form>
    </div>
</div>

<div class="card border-0 shadow-sm">
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr><th>Loai</th><th>Tieu de</th><th>Lien quan</th><th>Nguoi thuc hien</th><th>Ngay</th><th>Thoi luong</th><th></th></tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty activities}">
                            <c:forEach var="act" items="${activities}">
                                <tr>
                                    <td>
                                        <c:choose>
                                            <c:when test="${act.activityType == 'Call'}"><span class="badge bg-success-subtle text-success"><i class="bi bi-telephone me-1"></i>Cuoc goi</span></c:when>
                                            <c:when test="${act.activityType == 'Email'}"><span class="badge bg-primary-subtle text-primary"><i class="bi bi-envelope me-1"></i>Email</span></c:when>
                                            <c:when test="${act.activityType == 'Meeting'}"><span class="badge bg-warning-subtle text-warning"><i class="bi bi-people me-1"></i>Cuoc hop</span></c:when>
                                            <c:when test="${act.activityType == 'Note'}"><span class="badge bg-info-subtle text-info"><i class="bi bi-sticky me-1"></i>Ghi chu</span></c:when>
                                            <c:when test="${act.activityType == 'REPORT'}"><span class="badge bg-secondary-subtle text-secondary"><i class="bi bi-file-text me-1"></i>Bao cao</span></c:when>
                                            <c:otherwise><span class="badge bg-secondary-subtle text-secondary">${act.activityType}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="fw-medium">${act.subject}</td>
                                    <td>
                                        <c:if test="${not empty act.customerName}">
                                            <small class="text-muted">${act.relatedType} - ${act.customerName}</small>
                                        </c:if>
                                        <c:if test="${empty act.customerName}">
                                            <small class="text-muted">${not empty act.relatedType ? act.relatedType : '-'}</small>
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:if test="${not empty act.performerName}">
                                            <small>${act.performerName}</small>
                                        </c:if>
                                        <c:if test="${empty act.performerName}"><small class="text-muted">-</small></c:if>
                                    </td>
                                    <td>
                                        <c:if test="${not empty act.activityDate}">
                                            <small>${act.activityDate.toString().substring(0, 16).replace('T', ' ')}</small>
                                        </c:if>
                                        <c:if test="${empty act.activityDate}"><small class="text-muted">-</small></c:if>
                                    </td>
                                    <td>
                                        <c:if test="${not empty act.durationMinutes && act.durationMinutes > 0}">
                                            <small class="text-muted">${act.durationMinutes} phut</small>
                                        </c:if>
                                        <c:if test="${empty act.durationMinutes || act.durationMinutes == 0}"><small class="text-muted">-</small></c:if>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/sale/activity/detail?id=${act.activityId}" class="btn btn-sm btn-light" title="Xem"><i class="bi bi-eye"></i></a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr><td colspan="7" class="text-center text-muted py-4"><i class="bi bi-inbox me-1"></i>Chua co hoat dong nao</td></tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>
