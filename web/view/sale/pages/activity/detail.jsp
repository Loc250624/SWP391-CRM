<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:if test="${param.success == 'completed'}">
    <script>document.addEventListener('DOMContentLoaded', function(){ CRM.showToast('Đã đánh dấu hoàn thành!', 'success'); });</script>
</c:if>

<div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
    <div>
        <h4 class="mb-1 fw-bold">Chi tiết hoạt động</h4>
        <p class="text-muted mb-0">${activity.subject}</p>
    </div>
    <div class="d-flex gap-2">
        <c:if test="${activity.status == 'Pending'}">
            <form method="POST" action="${pageContext.request.contextPath}/sale/activity/detail" style="display:inline;">
                <input type="hidden" name="activityId" value="${activity.activityId}">
                <input type="hidden" name="action" value="complete">
                <button type="submit" class="btn btn-success btn-sm"><i class="bi bi-check-circle me-1"></i>Đánh dấu hoàn thành</button>
            </form>
        </c:if>
        <a href="${pageContext.request.contextPath}/sale/activity/form?id=${activity.activityId}" class="btn btn-outline-primary btn-sm"><i class="bi bi-pencil me-1"></i>Chỉnh sửa</a>
        <button type="button" class="btn btn-outline-danger btn-sm" onclick="deleteActivity(${activity.activityId})"><i class="bi bi-trash me-1"></i>Xóa</button>
        <a href="${pageContext.request.contextPath}/sale/activity/list" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left me-1"></i>Quay lại</a>
    </div>
</div>

<div class="row g-4">
    <div class="col-lg-8">
        <div class="card border-0 shadow-sm">
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="text-muted small">Loại</label>
                        <div>
                            <c:choose>
                                <c:when test="${activity.activityType == 'Call'}"><span class="badge bg-success-subtle text-success border border-success-subtle"><i class="bi bi-telephone me-1"></i>Cuộc gọi</span></c:when>
                                <c:when test="${activity.activityType == 'Email'}"><span class="badge bg-info-subtle text-info border border-info-subtle"><i class="bi bi-envelope me-1"></i>Email</span></c:when>
                                <c:when test="${activity.activityType == 'Meeting'}"><span class="badge bg-primary-subtle text-primary border border-primary-subtle"><i class="bi bi-people me-1"></i>Cuộc họp</span></c:when>
                                <c:when test="${activity.activityType == 'Note'}"><span class="badge bg-warning-subtle text-warning border border-warning-subtle"><i class="bi bi-sticky me-1"></i>Ghi chú</span></c:when>
                                <c:otherwise><span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle">${activity.activityType}</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Trạng thái</label>
                        <div>
                            <c:choose>
                                <c:when test="${activity.status == 'Completed'}"><span class="badge bg-success-subtle text-success border border-success-subtle">Hoàn thành</span></c:when>
                                <c:when test="${activity.status == 'Pending'}"><span class="badge bg-warning-subtle text-warning border border-warning-subtle">Đang chờ</span></c:when>
                                <c:otherwise><span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle">${activity.status}</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Liên quan</label>
                        <div class="fw-medium">
                            <c:if test="${not empty activity.customerName}">${activity.relatedType} - ${activity.customerName}</c:if>
                            <c:if test="${empty activity.customerName}">${not empty activity.relatedType ? activity.relatedType : '--'}</c:if>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Ngày giờ</label>
                        <div>
                            <c:if test="${not empty activity.activityDate}">${activity.activityDate.toString().substring(0, 16).replace('T', ' ')}</c:if>
                            <c:if test="${empty activity.activityDate}">--</c:if>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Thời lượng</label>
                        <div>
                            <c:if test="${not empty activity.durationMinutes && activity.durationMinutes > 0}">${activity.durationMinutes} phút</c:if>
                            <c:if test="${empty activity.durationMinutes || activity.durationMinutes == 0}">--</c:if>
                        </div>
                    </div>
                    <c:if test="${activity.activityType == 'Call'}">
                        <div class="col-md-6">
                            <label class="text-muted small">Hướng cuộc gọi</label>
                            <div>
                                <c:choose>
                                    <c:when test="${activity.callDirection == 'Outbound'}">Gọi đi (Outbound)</c:when>
                                    <c:when test="${activity.callDirection == 'Inbound'}">Gọi đến (Inbound)</c:when>
                                    <c:otherwise>${not empty activity.callDirection ? activity.callDirection : '--'}</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="text-muted small">Kết quả cuộc gọi</label>
                            <div>
                                <c:if test="${not empty activity.callResult}">
                                    <c:choose>
                                        <c:when test="${activity.callResult == 'Success'}"><span class="badge bg-success">Thành công</span></c:when>
                                        <c:when test="${activity.callResult == 'NoAnswer'}"><span class="badge bg-secondary">Không trả lời</span></c:when>
                                        <c:when test="${activity.callResult == 'Busy'}"><span class="badge bg-warning text-dark">Bận</span></c:when>
                                        <c:when test="${activity.callResult == 'Callback'}"><span class="badge bg-info">Hẹn lại</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary">${activity.callResult}</span></c:otherwise>
                                    </c:choose>
                                </c:if>
                                <c:if test="${empty activity.callResult}">--</c:if>
                            </div>
                        </div>
                    </c:if>
                    <c:if test="${not empty activity.description}">
                        <div class="col-12">
                            <label class="text-muted small">Mô tả</label>
                            <div class="text-muted mt-1" style="white-space: pre-wrap;">${activity.description}</div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
    <div class="col-lg-4">
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Người thực hiện</h6></div>
            <div class="card-body">
                <c:if test="${not empty activity.performerName}">
                    <div class="d-flex align-items-center gap-3">
                        <div class="bg-primary text-white rounded d-flex align-items-center justify-content-center" style="width:40px;height:40px;font-size:14px;">
                            ${activity.performerName.substring(0,1)}
                        </div>
                        <div><div class="fw-semibold">${activity.performerName}</div></div>
                    </div>
                </c:if>
                <c:if test="${empty activity.performerName}"><span class="text-muted">--</span></c:if>
            </div>
        </div>
        <c:if test="${not empty activity.createdAt}">
            <div class="card border-0 shadow-sm mt-3">
                <div class="card-body">
                    <label class="text-muted small">Ngày tạo</label>
                    <div>${activity.createdAt.toString().substring(0, 16).replace('T', ' ')}</div>
                </div>
            </div>
        </c:if>
    </div>
</div>

<script>
function deleteActivity(activityId) {
    if (confirm('Bạn có chắc muốn xóa hoạt động này?\nHành động này không thể hoàn tác.')) {
        var form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/sale/activity/detail';
        form.innerHTML = '<input type="hidden" name="activityId" value="' + activityId + '"><input type="hidden" name="action" value="delete">';
        document.body.appendChild(form);
        form.submit();
    }
}
</script>
