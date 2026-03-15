<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div><h4 class="mb-1 fw-bold">Lịch hẹn</h4><p class="text-muted mb-0">Quản lý lịch hẹn và cuộc họp</p></div>
    <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/sale/activity/form" class="btn btn-primary btn-sm"><i class="bi bi-plus-lg me-1"></i>Thêm lịch hẹn</a>
    </div>
</div>

<!-- Week Navigation -->
<div class="card border-0 shadow-sm mb-4">
    <div class="card-header bg-transparent border-0 d-flex justify-content-between align-items-center">
        <div class="d-flex align-items-center gap-3">
            <a href="${pageContext.request.contextPath}/sale/activity/calendar?weekOffset=${weekOffset - 1}" class="btn btn-sm btn-outline-secondary"><i class="bi bi-chevron-left"></i></a>
            <h6 class="mb-0 fw-semibold">
                ${weekStart.getDayOfMonth()}/${weekStart.getMonthValue()} - ${weekEnd.getDayOfMonth()}/${weekEnd.getMonthValue()}/${weekEnd.getYear()}
            </h6>
            <a href="${pageContext.request.contextPath}/sale/activity/calendar?weekOffset=${weekOffset + 1}" class="btn btn-sm btn-outline-secondary"><i class="bi bi-chevron-right"></i></a>
        </div>
        <a href="${pageContext.request.contextPath}/sale/activity/calendar" class="btn btn-sm btn-outline-primary">Hôm nay</a>
    </div>
    <div class="card-body pt-0">
        <div class="table-responsive">
            <table class="table table-bordered mb-0" style="table-layout: fixed;">
                <thead class="table-light">
                    <tr>
                        <th style="width: 60px;"></th>
                        <c:forEach var="i" begin="0" end="6">
                            <c:set var="dayDate" value="${weekStart.plusDays(i)}"/>
                            <th class="text-center small">
                                <c:choose>
                                    <c:when test="${i == 0}">T2</c:when>
                                    <c:when test="${i == 1}">T3</c:when>
                                    <c:when test="${i == 2}">T4</c:when>
                                    <c:when test="${i == 3}">T5</c:when>
                                    <c:when test="${i == 4}">T6</c:when>
                                    <c:when test="${i == 5}">T7</c:when>
                                    <c:when test="${i == 6}">CN</c:when>
                                </c:choose>
                                <br>${dayDate.getDayOfMonth()}/${dayDate.getMonthValue()}
                            </th>
                        </c:forEach>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="hour" begin="8" end="18">
                        <tr style="height: 60px;">
                            <td class="text-muted small text-center align-middle">${hour < 10 ? '0' : ''}${hour}:00</td>
                            <c:forEach var="dayIdx" begin="0" end="6">
                                <td class="align-top p-1">
                                    <c:forEach var="act" items="${weekActivities}">
                                        <c:if test="${not empty act.activityDate}">
                                            <c:set var="actDay" value="${act.activityDate.toLocalDate()}"/>
                                            <c:set var="actHour" value="${act.activityDate.getHour()}"/>
                                            <c:set var="targetDay" value="${weekStart.plusDays(dayIdx)}"/>
                                            <c:if test="${actDay.equals(targetDay) && actHour == hour}">
                                                <a href="${pageContext.request.contextPath}/sale/activity/detail?id=${act.activityId}" class="text-decoration-none">
                                                    <div class="rounded p-1 small mb-1
                                                        <c:choose>
                                                            <c:when test="${act.activityType == 'Call'}">bg-success-subtle text-success</c:when>
                                                            <c:when test="${act.activityType == 'Email'}">bg-primary-subtle text-primary</c:when>
                                                            <c:when test="${act.activityType == 'Meeting'}">bg-warning-subtle text-warning</c:when>
                                                            <c:otherwise>bg-info-subtle text-info</c:otherwise>
                                                        </c:choose>
                                                    " style="font-size: 10px;">
                                                        <c:choose>
                                                            <c:when test="${act.activityType == 'Call'}"><i class="bi bi-telephone me-1"></i></c:when>
                                                            <c:when test="${act.activityType == 'Email'}"><i class="bi bi-envelope me-1"></i></c:when>
                                                            <c:when test="${act.activityType == 'Meeting'}"><i class="bi bi-people me-1"></i></c:when>
                                                            <c:otherwise><i class="bi bi-sticky me-1"></i></c:otherwise>
                                                        </c:choose>
                                                        ${act.subject.length() > 15 ? act.subject.substring(0, 15).concat('...') : act.subject}
                                                        <br><small>${act.activityDate.toString().substring(11, 16)}</small>
                                                    </div>
                                                </a>
                                            </c:if>
                                        </c:if>
                                    </c:forEach>
                                </td>
                            </c:forEach>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Upcoming -->
<div class="card border-0 shadow-sm">
    <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Sắp tới (7 ngày)</h6></div>
    <div class="card-body">
        <c:choose>
            <c:when test="${not empty upcoming}">
                <div class="d-flex flex-column gap-2">
                    <c:forEach var="act" items="${upcoming}">
                        <a href="${pageContext.request.contextPath}/sale/activity/detail?id=${act.activityId}" class="text-decoration-none">
                            <div class="d-flex align-items-center gap-3 p-2 bg-light rounded">
                                <div class="text-center" style="width: 50px;">
                                    <c:if test="${not empty act.activityDate}">
                                        <div class="fw-bold">${act.activityDate.getDayOfMonth()}</div>
                                        <small class="text-muted">T${act.activityDate.getDayOfWeek().getValue() + 1}</small>
                                    </c:if>
                                </div>
                                <div class="flex-grow-1">
                                    <div class="fw-medium text-dark">${act.subject}</div>
                                    <small class="text-muted">
                                        <c:if test="${not empty act.activityDate}">${act.activityDate.toString().substring(11, 16)}</c:if>
                                        <c:if test="${not empty act.performerName}"> | ${act.performerName}</c:if>
                                    </small>
                                </div>
                                <c:choose>
                                    <c:when test="${act.activityType == 'Call'}"><span class="badge bg-success-subtle text-success">Call</span></c:when>
                                    <c:when test="${act.activityType == 'Email'}"><span class="badge bg-primary-subtle text-primary">Email</span></c:when>
                                    <c:when test="${act.activityType == 'Meeting'}"><span class="badge bg-warning-subtle text-warning">Meeting</span></c:when>
                                    <c:otherwise><span class="badge bg-info-subtle text-info">Note</span></c:otherwise>
                                </c:choose>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <p class="text-muted text-center mb-0">Không có hoạt động sắp tới</p>
            </c:otherwise>
        </c:choose>
    </div>
</div>
