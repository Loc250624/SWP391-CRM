<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="container-fluid">
    <!-- Header -->
    <div class="mb-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/manager/task/list">Công việc</a></li>
                <li class="breadcrumb-item active">Chi tiết</li>
            </ol>
        </nav>
        <div class="d-flex justify-content-between align-items-center">
            <h3><i class="bi bi-file-earmark-text me-2"></i>Chi tiết Công việc</h3>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/manager/task/form?action=edit&id=${task.taskId}"
                   class="btn btn-outline-primary">
                    <i class="bi bi-pencil me-2"></i>Chỉnh sửa
                </a>
                <a href="${pageContext.request.contextPath}/manager/task/delete?id=${task.taskId}"
                   class="btn btn-outline-danger"
                   onclick="return confirm('Bạn có chắc chắn muốn xóa công việc này?');">
                    <i class="bi bi-trash me-2"></i>Xóa
                </a>
            </div>
        </div>
    </div>

    <!-- Success/Error Messages -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle me-2"></i>${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="successMessage" scope="session" />
    </c:if>

    <div class="row">
        <!-- Main Content -->
        <div class="col-lg-8">
            <div class="card mb-4">
                <div class="card-header bg-white">
                    <h5 class="mb-0">${task.title}</h5>
                    <div class="mt-2">
                        <span class="badge bg-secondary me-2">${task.taskCode}</span>
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
                                <span class="badge bg-danger ms-2">Ưu tiên cao</span>
                            </c:when>
                            <c:when test="${task.priority == 'MEDIUM'}">
                                <span class="badge bg-warning ms-2">Ưu tiên trung bình</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary ms-2">Ưu tiên thấp</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="card-body">
                    <h6 class="fw-bold mb-3">Mô tả</h6>
                    <c:choose>
                        <c:when test="${not empty task.description}">
                            <p class="text-muted">${task.description}</p>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted fst-italic">Không có mô tả</p>
                        </c:otherwise>
                    </c:choose>

                    <hr class="my-4">

                    <!-- Timeline Info -->
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <h6 class="fw-bold mb-2"><i class="bi bi-calendar-event me-2"></i>Hạn chót</h6>
                            <c:choose>
                                <c:when test="${task.dueDate != null}">
                                    <p class="mb-0">
                                        <fmt:formatDate value="${task.dueDate}" pattern="dd/MM/yyyy HH:mm" />
                                    </p>
                                    <c:if test="${task.dueDate.isBefore(now()) && task.status != 'COMPLETED'}">
                                        <span class="badge bg-danger mt-1">Quá hạn</span>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted mb-0">Không xác định</p>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="col-md-6 mb-3">
                            <h6 class="fw-bold mb-2"><i class="bi bi-bell me-2"></i>Nhắc nhở</h6>
                            <c:choose>
                                <c:when test="${task.reminderAt != null}">
                                    <p class="mb-0">
                                        <fmt:formatDate value="${task.reminderAt}" pattern="dd/MM/yyyy HH:mm" />
                                    </p>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted mb-0">Không có</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <h6 class="fw-bold mb-2"><i class="bi bi-calendar-plus me-2"></i>Ngày tạo</h6>
                            <c:if test="${task.createdAt != null}">
                                <p class="mb-0">
                                    <fmt:formatDate value="${task.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                </p>
                            </c:if>
                        </div>

                        <div class="col-md-6 mb-3">
                            <h6 class="fw-bold mb-2"><i class="bi bi-calendar-check me-2"></i>Hoàn thành</h6>
                            <c:choose>
                                <c:when test="${task.completedAt != null}">
                                    <p class="mb-0">
                                        <fmt:formatDate value="${task.completedAt}" pattern="dd/MM/yyyy HH:mm" />
                                    </p>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted mb-0">Chưa hoàn thành</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Related Object -->
            <c:if test="${relatedObject != null}">
                <div class="card">
                    <div class="card-header bg-white">
                        <h6 class="mb-0"><i class="bi bi-link-45deg me-2"></i>Liên kết với</h6>
                    </div>
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="flex-grow-1">
                                <h6 class="mb-1">${relatedObjectName}</h6>
                                <p class="text-muted mb-0 small">Loại: ${task.relatedType}</p>
                            </div>
                            <c:choose>
                                <c:when test="${task.relatedType == 'Lead'}">
                                    <a href="${pageContext.request.contextPath}/manager/lead/detail?id=${task.relatedId}"
                                       class="btn btn-sm btn-outline-primary">
                                        Xem chi tiết <i class="bi bi-arrow-right ms-1"></i>
                                    </a>
                                </c:when>
                                <c:when test="${task.relatedType == 'Customer'}">
                                    <a href="${pageContext.request.contextPath}/manager/customer/detail?id=${task.relatedId}"
                                       class="btn btn-sm btn-outline-primary">
                                        Xem chi tiết <i class="bi bi-arrow-right ms-1"></i>
                                    </a>
                                </c:when>
                                <c:when test="${task.relatedType == 'Opportunity'}">
                                    <a href="${pageContext.request.contextPath}/manager/opportunity/detail?id=${task.relatedId}"
                                       class="btn btn-sm btn-outline-primary">
                                        Xem chi tiết <i class="bi bi-arrow-right ms-1"></i>
                                    </a>
                                </c:when>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>

        <!-- Sidebar -->
        <div class="col-lg-4">
            <!-- Assigned User -->
            <div class="card mb-4">
                <div class="card-header bg-white">
                    <h6 class="mb-0"><i class="bi bi-person me-2"></i>Người thực hiện</h6>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${assignedUser != null}">
                            <div class="d-flex align-items-center">
                                <div class="avatar-lg bg-primary rounded-circle d-flex align-items-center justify-content-center text-white me-3">
                                    <h4 class="mb-0">${assignedUser.firstName.substring(0, 1)}${assignedUser.lastName.substring(0, 1)}</h4>
                                </div>
                                <div>
                                    <h6 class="mb-1">${assignedUser.firstName} ${assignedUser.lastName}</h6>
                                    <p class="text-muted small mb-0">${assignedUser.email}</p>
                                    <p class="text-muted small mb-0">${assignedUser.phone}</p>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted mb-0">Chưa gán</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Creator -->
            <div class="card">
                <div class="card-header bg-white">
                    <h6 class="mb-0"><i class="bi bi-person-plus me-2"></i>Người tạo</h6>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${creator != null}">
                            <div class="d-flex align-items-center">
                                <div class="avatar-md bg-secondary rounded-circle d-flex align-items-center justify-content-center text-white me-3">
                                    ${creator.firstName.substring(0, 1)}${creator.lastName.substring(0, 1)}
                                </div>
                                <div>
                                    <h6 class="mb-1">${creator.firstName} ${creator.lastName}</h6>
                                    <p class="text-muted small mb-0">${creator.email}</p>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted mb-0">Không xác định</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .avatar-lg {
        width: 60px;
        height: 60px;
    }
    .avatar-md {
        width: 40px;
        height: 40px;
        font-size: 0.875rem;
        font-weight: 600;
    }
</style>
