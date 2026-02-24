<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!-- Breadcrumb -->
<nav aria-label="breadcrumb" class="mb-3">
    <ol class="breadcrumb">
        <li class="breadcrumb-item">
            <a href="${pageContext.request.contextPath}/support/task/list">Công việc của tôi</a>
        </li>
        <li class="breadcrumb-item active">Chi tiết</li>
    </ol>
</nav>

<!-- Success/Error Messages -->
<c:if test="${not empty sessionScope.successMessage}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-check-circle me-2"></i>${sessionScope.successMessage}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <c:remove var="successMessage" scope="session" />
</c:if>
<c:if test="${not empty sessionScope.errorMessage}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-triangle me-2"></i>${sessionScope.errorMessage}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <c:remove var="errorMessage" scope="session" />
</c:if>

<!-- Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <h4 class="mb-0"><i class="bi bi-file-earmark-text me-2"></i>Chi tiết Công việc</h4>
    <div class="d-flex gap-2">
        <c:if test="${task.status != 'COMPLETED' && task.status != 'CANCELLED'}">
            <a href="${pageContext.request.contextPath}/support/task/status?id=${task.taskId}"
               class="btn btn-success btn-sm">
                <i class="bi bi-check2-circle me-1"></i>Cập nhật Trạng thái
            </a>
        </c:if>
        <a href="${pageContext.request.contextPath}/support/task/list"
           class="btn btn-outline-secondary btn-sm">
            <i class="bi bi-arrow-left me-1"></i>Quay lại
        </a>
    </div>
</div>

<div class="row">
    <!-- Main Content -->
    <div class="col-lg-8">
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-white">
                <h5 class="mb-1">${task.title}</h5>
                <div>
                    <span class="badge bg-secondary me-1">${task.taskCode}</span>
                    <c:choose>
                        <c:when test="${task.status == 'COMPLETED'}">
                            <span class="badge bg-success">Hoàn thành</span>
                        </c:when>
                        <c:when test="${task.status == 'IN_PROGRESS'}">
                            <span class="badge bg-info">Đang thực hiện</span>
                        </c:when>
                        <c:when test="${task.status == 'CANCELLED'}">
                            <span class="badge bg-dark">Đã hủy</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-secondary">Chờ xử lý</span>
                        </c:otherwise>
                    </c:choose>
                    <c:choose>
                        <c:when test="${task.priority == 'HIGH'}">
                            <span class="badge bg-danger ms-1">Cao</span>
                        </c:when>
                        <c:when test="${task.priority == 'MEDIUM'}">
                            <span class="badge bg-warning text-dark ms-1">Trung bình</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-secondary ms-1">Thấp</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="card-body">
                <h6 class="fw-bold mb-2">Mô tả</h6>
                <c:choose>
                    <c:when test="${not empty task.description}">
                        <p class="text-muted">${task.description}</p>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted fst-italic small">Không có mô tả</p>
                    </c:otherwise>
                </c:choose>

                <hr>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <small class="text-muted d-block">Hạn chót</small>
                        <c:choose>
                            <c:when test="${task.dueDate != null}">
                                <strong>${fn:substring(task.dueDate, 8, 10)}/${fn:substring(task.dueDate, 5, 7)}/${fn:substring(task.dueDate, 0, 4)}</strong>
                            </c:when>
                            <c:otherwise><span class="text-muted small">Không xác định</span></c:otherwise>
                        </c:choose>
                    </div>
                    <div class="col-md-6 mb-3">
                        <small class="text-muted d-block">Nhắc nhở</small>
                        <c:choose>
                            <c:when test="${task.reminderAt != null}">
                                <strong>${fn:substring(task.reminderAt, 8, 10)}/${fn:substring(task.reminderAt, 5, 7)}/${fn:substring(task.reminderAt, 0, 4)}</strong>
                            </c:when>
                            <c:otherwise><span class="text-muted small">Không có</span></c:otherwise>
                        </c:choose>
                    </div>
                    <div class="col-md-6 mb-3">
                        <small class="text-muted d-block">Ngày tạo</small>
                        <c:if test="${task.createdAt != null}">
                            <strong>${fn:substring(task.createdAt, 8, 10)}/${fn:substring(task.createdAt, 5, 7)}/${fn:substring(task.createdAt, 0, 4)}</strong>
                        </c:if>
                    </div>
                    <c:if test="${task.completedAt != null}">
                        <div class="col-md-6 mb-3">
                            <small class="text-muted d-block">Hoàn thành lúc</small>
                            <strong class="text-success">${fn:substring(task.completedAt, 8, 10)}/${fn:substring(task.completedAt, 5, 7)}/${fn:substring(task.completedAt, 0, 4)}</strong>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Related Object -->
        <c:if test="${not empty relatedObjectName}">
            <div class="card shadow-sm">
                <div class="card-header bg-white">
                    <h6 class="mb-0"><i class="bi bi-link-45deg me-2"></i>Liên kết với</h6>
                </div>
                <div class="card-body">
                    <p class="fw-medium mb-1">${relatedObjectName}</p>
                    <small class="text-muted">Loại: ${task.relatedType}</small>
                </div>
            </div>
        </c:if>
    </div>

    <!-- Sidebar -->
    <div class="col-lg-4">
        <div class="card shadow-sm mb-3">
            <div class="card-header bg-white">
                <h6 class="mb-0"><i class="bi bi-person-plus me-2"></i>Người tạo</h6>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${creator != null}">
                        <div class="d-flex align-items-center">
                            <div class="rounded-circle bg-secondary d-flex align-items-center justify-content-center text-white me-3"
                                 style="width:40px;height:40px;font-size:0.875rem;">
                                ${fn:substring(creator.firstName, 0, 1)}${fn:substring(creator.lastName, 0, 1)}
                            </div>
                            <div>
                                <div class="fw-medium">${creator.firstName} ${creator.lastName}</div>
                                <small class="text-muted">${creator.email}</small>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted small mb-0">Không xác định</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <c:if test="${task.status != 'COMPLETED' && task.status != 'CANCELLED'}">
            <div class="card bg-light border-0">
                <div class="card-body">
                    <h6 class="mb-2"><i class="bi bi-info-circle me-1"></i>Quyền của bạn</h6>
                    <ul class="list-unstyled small mb-0">
                        <li class="mb-1"><i class="bi bi-check2 text-success me-1"></i>Xem chi tiết công việc</li>
                        <li class="mb-1"><i class="bi bi-check2 text-success me-1"></i>Cập nhật trạng thái</li>
                        <li class="mb-1"><i class="bi bi-x text-danger me-1"></i>Không thể chỉnh sửa thông tin khác</li>
                    </ul>
                </div>
            </div>
        </c:if>
    </div>
</div>
