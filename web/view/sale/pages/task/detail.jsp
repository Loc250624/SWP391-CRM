<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="container-fluid">

    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/sale/task/list">Công việc của tôi</a>
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

    <!-- Header Actions -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="mb-0"><i class="bi bi-file-earmark-text me-2"></i>Chi tiết Công việc</h3>
        <div class="d-flex gap-2">
            <c:if test="${task.status != 'COMPLETED' && task.status != 'CANCELLED'}">
                <a href="${pageContext.request.contextPath}/sale/task/log?taskId=${task.taskId}"
                   class="btn btn-primary">
                    <i class="bi bi-journal-text me-2"></i>Ghi nhật ký
                </a>
                <a href="${pageContext.request.contextPath}/sale/task/status?id=${task.taskId}"
                   class="btn btn-success">
                    <i class="bi bi-check2-circle me-2"></i>Cập nhật Trạng thái
                </a>
            </c:if>
            <a href="${pageContext.request.contextPath}/sale/task/list" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-2"></i>Quay lại
            </a>
        </div>
    </div>

    <div class="row">
        <!-- Main Content -->
        <div class="col-lg-8">
            <div class="card mb-4">
                <div class="card-header bg-white">
                    <div class="d-flex align-items-start justify-content-between">
                        <div>
                            <h5 class="mb-1">${task.title}</h5>
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
                                    <span class="badge bg-danger ms-1">Ưu tiên cao</span>
                                </c:when>
                                <c:when test="${task.priority == 'MEDIUM'}">
                                    <span class="badge bg-warning text-dark ms-1">Ưu tiên trung bình</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary ms-1">Ưu tiên thấp</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <h6 class="fw-bold mb-2">Mô tả</h6>
                    <c:choose>
                        <c:when test="${not empty task.description}">
                            <p class="text-muted">${task.description}</p>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted fst-italic">Không có mô tả</p>
                        </c:otherwise>
                    </c:choose>

                    <hr>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <h6 class="fw-bold mb-1"><i class="bi bi-calendar-event me-1"></i>Hạn chót</h6>
                            <c:choose>
                                <c:when test="${task.dueDate != null}">
                                    <p class="mb-0">
                                        ${fn:substring(task.dueDate, 8, 10)}/${fn:substring(task.dueDate, 5, 7)}/${fn:substring(task.dueDate, 0, 4)}
                                        ${fn:length(task.dueDate) > 10 ? fn:substring(task.dueDate, 11, 16) : ''}
                                    </p>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted mb-0">Không xác định</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="col-md-6 mb-3">
                            <h6 class="fw-bold mb-1"><i class="bi bi-bell me-1"></i>Nhắc nhở</h6>
                            <c:choose>
                                <c:when test="${task.reminderAt != null}">
                                    <p class="mb-0">
                                        ${fn:substring(task.reminderAt, 8, 10)}/${fn:substring(task.reminderAt, 5, 7)}/${fn:substring(task.reminderAt, 0, 4)}
                                    </p>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted mb-0">Không có</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="col-md-6 mb-3">
                            <h6 class="fw-bold mb-1"><i class="bi bi-calendar-plus me-1"></i>Ngày tạo</h6>
                            <c:if test="${task.createdAt != null}">
                                <p class="mb-0">
                                    ${fn:substring(task.createdAt, 8, 10)}/${fn:substring(task.createdAt, 5, 7)}/${fn:substring(task.createdAt, 0, 4)}
                                </p>
                            </c:if>
                        </div>
                        <c:if test="${task.completedAt != null}">
                            <div class="col-md-6 mb-3">
                                <h6 class="fw-bold mb-1"><i class="bi bi-check-circle me-1"></i>Hoàn thành lúc</h6>
                                <p class="mb-0 text-success">
                                    ${fn:substring(task.completedAt, 8, 10)}/${fn:substring(task.completedAt, 5, 7)}/${fn:substring(task.completedAt, 0, 4)}
                                </p>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Related Object -->
            <c:if test="${not empty relatedObjectName}">
                <div class="card">
                    <div class="card-header bg-white">
                        <h6 class="mb-0"><i class="bi bi-link-45deg me-2"></i>Liên kết với</h6>
                    </div>
                    <div class="card-body">
                        <p class="mb-1 fw-medium">${relatedObjectName}</p>
                        <p class="text-muted small mb-0">Loại: ${task.relatedType}</p>
                    </div>
                </div>
            </c:if>
        </div>

        <!-- Sidebar -->
        <div class="col-lg-4">
            <!-- Creator -->
            <div class="card mb-3">
                <div class="card-header bg-white">
                    <h6 class="mb-0"><i class="bi bi-person-plus me-2"></i>Người tạo</h6>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${creator != null}">
                            <div class="d-flex align-items-center">
                                <div class="rounded-circle bg-secondary d-flex align-items-center justify-content-center text-white me-3"
                                     style="width:40px;height:40px;font-size:0.875rem;font-weight:600;">
                                    <%-- FIX: fn:substring is null-safe; avoids StringIndexOutOfBoundsException --%>
                                    ${fn:substring(creator.firstName, 0, 1)}${fn:substring(creator.lastName, 0, 1)}
                                </div>
                                <div>
                                    <h6 class="mb-0">${creator.firstName} ${creator.lastName}</h6>
                                    <small class="text-muted">${creator.email}</small>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted mb-0">Không xác định</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Status Update Info -->
            <c:if test="${task.status != 'COMPLETED' && task.status != 'CANCELLED'}">
                <div class="card bg-light border-0">
                    <div class="card-body">
                        <h6 class="mb-2"><i class="bi bi-info-circle me-2"></i>Ghi chú</h6>
                        <ul class="list-unstyled small mb-0">
                            <li class="mb-1">
                                <i class="bi bi-check2 text-success me-1"></i>
                                Bạn chỉ có thể cập nhật trạng thái công việc
                            </li>
                            <li class="mb-1">
                                <i class="bi bi-check2 text-success me-1"></i>
                                Không thể thay đổi tiêu đề, hạn chót, ưu tiên
                            </li>
                            <li>
                                <i class="bi bi-check2 text-success me-1"></i>
                                Liên hệ quản lý để thay đổi thông tin khác
                            </li>
                        </ul>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</div>
