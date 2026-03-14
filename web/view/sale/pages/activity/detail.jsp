<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">Chi tiet Hoat dong</h4>
        <p class="text-muted mb-0">${activity.subject}</p>
    </div>
    <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/sale/activity/form?id=${activity.activityId}" class="btn btn-outline-primary btn-sm"><i class="bi bi-pencil me-1"></i>Chinh sua</a>
        <a href="${pageContext.request.contextPath}/sale/activity/list" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left me-1"></i>Quay lai</a>
    </div>
</div>

<div class="row g-4">
    <div class="col-lg-8">
        <div class="card border-0 shadow-sm">
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="text-muted small">Loai</label>
                        <div>
                            <c:choose>
                                <c:when test="${activity.activityType == 'Call'}"><span class="badge bg-success-subtle text-success"><i class="bi bi-telephone me-1"></i>Cuoc goi</span></c:when>
                                <c:when test="${activity.activityType == 'Email'}"><span class="badge bg-primary-subtle text-primary"><i class="bi bi-envelope me-1"></i>Email</span></c:when>
                                <c:when test="${activity.activityType == 'Meeting'}"><span class="badge bg-warning-subtle text-warning"><i class="bi bi-people me-1"></i>Cuoc hop</span></c:when>
                                <c:when test="${activity.activityType == 'Note'}"><span class="badge bg-info-subtle text-info"><i class="bi bi-sticky me-1"></i>Ghi chu</span></c:when>
                                <c:otherwise><span class="badge bg-secondary-subtle text-secondary">${activity.activityType}</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Lien quan</label>
                        <div class="fw-medium">
                            <c:if test="${not empty activity.customerName}">${activity.relatedType} - ${activity.customerName}</c:if>
                            <c:if test="${empty activity.customerName}">${not empty activity.relatedType ? activity.relatedType : '-'}</c:if>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Ngay gio</label>
                        <div>
                            <c:if test="${not empty activity.activityDate}">${activity.activityDate.toString().substring(0, 16).replace('T', ' ')}</c:if>
                            <c:if test="${empty activity.activityDate}">-</c:if>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Thoi luong</label>
                        <div>
                            <c:if test="${not empty activity.durationMinutes && activity.durationMinutes > 0}">${activity.durationMinutes} phut</c:if>
                            <c:if test="${empty activity.durationMinutes || activity.durationMinutes == 0}">-</c:if>
                        </div>
                    </div>
                    <c:if test="${activity.activityType == 'Call'}">
                        <div class="col-md-6">
                            <label class="text-muted small">Huong</label>
                            <div>
                                <c:choose>
                                    <c:when test="${activity.callDirection == 'Outbound'}">Goi di (Outbound)</c:when>
                                    <c:when test="${activity.callDirection == 'Inbound'}">Goi den (Inbound)</c:when>
                                    <c:otherwise>${not empty activity.callDirection ? activity.callDirection : '-'}</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="text-muted small">Ket qua</label>
                            <div>
                                <c:if test="${not empty activity.callResult}">
                                    <c:choose>
                                        <c:when test="${activity.callResult == 'Success'}"><span class="badge bg-success">Thanh cong</span></c:when>
                                        <c:when test="${activity.callResult == 'NoAnswer'}"><span class="badge bg-secondary">Khong tra loi</span></c:when>
                                        <c:when test="${activity.callResult == 'Busy'}"><span class="badge bg-warning text-dark">Ban</span></c:when>
                                        <c:when test="${activity.callResult == 'Callback'}"><span class="badge bg-info">Hen lai</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary">${activity.callResult}</span></c:otherwise>
                                    </c:choose>
                                </c:if>
                                <c:if test="${empty activity.callResult}">-</c:if>
                            </div>
                        </div>
                    </c:if>
                    <c:if test="${not empty activity.description}">
                        <div class="col-12">
                            <label class="text-muted small">Mo ta</label>
                            <div class="text-muted mt-1" style="white-space: pre-wrap;">${activity.description}</div>
                        </div>
                    </c:if>
                    <div class="col-md-6">
                        <label class="text-muted small">Trang thai</label>
                        <div>
                            <c:choose>
                                <c:when test="${activity.status == 'Completed'}"><span class="badge bg-success">Hoan thanh</span></c:when>
                                <c:when test="${activity.status == 'Pending'}"><span class="badge bg-warning text-dark">Cho xu ly</span></c:when>
                                <c:otherwise><span class="badge bg-secondary">${activity.status}</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-lg-4">
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Nguoi thuc hien</h6></div>
            <div class="card-body">
                <c:if test="${not empty activity.performerName}">
                    <div class="d-flex align-items-center gap-3">
                        <div class="bg-primary text-white rounded d-flex align-items-center justify-content-center" style="width:40px;height:40px;font-size:14px;">
                            ${activity.performerName.substring(0,1)}
                        </div>
                        <div><div class="fw-semibold">${activity.performerName}</div></div>
                    </div>
                </c:if>
                <c:if test="${empty activity.performerName}"><span class="text-muted">-</span></c:if>
            </div>
        </div>
        <c:if test="${not empty activity.createdAt}">
            <div class="card border-0 shadow-sm mt-3">
                <div class="card-body">
                    <label class="text-muted small">Ngay tao</label>
                    <div>${activity.createdAt.toString().substring(0, 16).replace('T', ' ')}</div>
                </div>
            </div>
        </c:if>
    </div>
</div>
