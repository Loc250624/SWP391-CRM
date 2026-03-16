<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="container-fluid">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="mb-1"><i class="bi bi-bar-chart me-2"></i>Workload Nhân viên</h3>
            <p class="text-muted mb-0">Phân bổ công việc theo từng nhân viên trong phòng ban</p>
        </div>
        <a href="${pageContext.request.contextPath}/manager/task/list?view=team" class="btn btn-outline-secondary btn-sm">
            <i class="bi bi-arrow-left me-1"></i>Danh sách công việc
        </a>
    </div>

    <!-- Dept Quick Stats -->
    <c:if test="${not empty deptStats}">
        <div class="row g-3 mb-4">
            <div class="col-6 col-md-3">
                <div class="card border-0 bg-primary bg-opacity-10 text-center py-3">
                    <div class="fs-3 fw-bold text-primary">${deptStats.totalTasks}</div>
                    <small class="text-muted">Tổng công việc</small>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="card border-0 bg-info bg-opacity-10 text-center py-3">
                    <div class="fs-3 fw-bold text-info">${deptStats.inProgressTasks}</div>
                    <small class="text-muted">Đang thực hiện</small>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="card border-0 bg-danger bg-opacity-10 text-center py-3">
                    <div class="fs-3 fw-bold text-danger">${deptStats.overdueTasks}</div>
                    <small class="text-muted">Quá hạn</small>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="card border-0 bg-success bg-opacity-10 text-center py-3">
                    <div class="fs-3 fw-bold text-success">${deptStats.completedTasks}</div>
                    <small class="text-muted">Đã hoàn thành</small>
                </div>
            </div>
        </div>
    </c:if>

    <!-- Workload Grid -->
    <div class="card">
        <div class="card-header bg-white">
            <h5 class="mb-0">
                <i class="bi bi-grid me-2"></i>
                Phân bổ công việc (mở = chưa Hoàn thành / Hủy)
                <span class="badge bg-danger ms-2" title="Quá tải: > ${overloadThreshold} công việc mở">
                    <i class="bi bi-exclamation-triangle me-1"></i>Quá tải > ${overloadThreshold}
                </span>
            </h5>
        </div>
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${empty teamMembers}">
                    <div class="text-center py-5">
                        <i class="bi bi-people text-muted" style="font-size:3rem;"></i>
                        <p class="text-muted mt-3">Không có nhân viên trong nhóm</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th style="min-width:200px;">Nhân viên</th>
                                    <th style="width:100px;" class="text-center">Công việc mở</th>
                                    <th>Phân bổ tải</th>
                                    <th class="text-center">Trạng thái</th>
                                    <th class="text-end">Xem</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="member" items="${teamMembers}">
                                    <c:set var="openCount" value="${openTaskCount[member.userId]}"/>
                                    <c:set var="isOverloaded" value="${openCount > overloadThreshold}"/>
                                    <tr class="${isOverloaded ? 'table-danger' : ''}">
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="avatar-sm ${isOverloaded ? 'bg-danger' : 'bg-primary'} rounded-circle d-flex align-items-center justify-content-center text-white">
                                                    ${fn:substring(member.firstName,0,1)}${fn:substring(member.lastName,0,1)}
                                                </div>
                                                <div>
                                                    <div class="fw-medium">${member.firstName} ${member.lastName}</div>
                                                    <small class="text-muted">${member.email}</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge ${isOverloaded ? 'bg-danger' : openCount > 3 ? 'bg-warning text-dark' : 'bg-success'} fs-6">
                                                ${openCount}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="progress flex-grow-1" style="height:12px;">
                                                    <div class="progress-bar ${isOverloaded ? 'bg-danger' : openCount > 3 ? 'bg-warning' : 'bg-success'}"
                                                         role="progressbar"
                                                         style="width:${openCount > 10 ? 100 : openCount * 10}%"
                                                         aria-valuenow="${openCount}" aria-valuemin="0" aria-valuemax="10">
                                                    </div>
                                                </div>
                                                <small class="text-muted text-nowrap">${openCount}/10</small>
                                            </div>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${isOverloaded}">
                                                    <span class="badge bg-danger">
                                                        <i class="bi bi-exclamation-triangle me-1"></i>Quá tải
                                                    </span>
                                                </c:when>
                                                <c:when test="${openCount > 3}">
                                                    <span class="badge bg-warning text-dark">Bận</span>
                                                </c:when>
                                                <c:when test="${openCount == 0}">
                                                    <span class="badge bg-secondary">Rảnh</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-success">Bình thường</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <a href="${pageContext.request.contextPath}/manager/task/list?source=workload&employee=${member.userId}"
                                               class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-eye me-1"></i>Xem việc
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<style>
    .avatar-sm {
        width: 36px;
        height: 36px;
        font-size: 0.8rem;
        font-weight: 600;
        flex-shrink: 0;
    }
</style>
