<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="container-fluid">
    <!-- Header -->
    <div class="mb-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/manager/task/list">Công việc</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}">Chi tiết</a></li>
                <li class="breadcrumb-item active">Đặt mức độ ưu tiên</li>
            </ol>
        </nav>
        <h3><i class="bi bi-flag me-2"></i>Đặt Mức độ Ưu tiên</h3>
        <p class="text-muted">Thay đổi mức độ quan trọng của công việc</p>
    </div>

    <div class="row">
        <div class="col-lg-8">
            <!-- Task Info -->
            <div class="card mb-4">
                <div class="card-header bg-white">
                    <h5 class="mb-1">${task.title}</h5>
                    <small class="text-muted">Mã: ${task.taskCode}</small>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <small class="text-muted d-block">Trạng thái</small>
                            <p>
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
                            </p>
                        </div>
                        <div class="col-md-3">
                            <small class="text-muted d-block">Người thực hiện</small>
                            <p class="fw-bold">
                                <c:forEach var="user" items="${allUsers}">
                                    <c:if test="${user.userId == task.assignedTo}">
                                        ${user.firstName} ${user.lastName}
                                    </c:if>
                                </c:forEach>
                            </p>
                        </div>
                        <div class="col-md-3">
                            <small class="text-muted d-block">Hạn chót</small>
                            <p class="fw-bold">
                                <fmt:formatDate value="${task.dueDate}" pattern="dd/MM/yyyy" />
                            </p>
                        </div>
                        <div class="col-md-3">
                            <small class="text-muted d-block">Ưu tiên hiện tại</small>
                            <p>
                                <c:choose>
                                    <c:when test="${task.priority == 'HIGH'}">
                                        <span class="badge bg-danger">🔴 Cao</span>
                                    </c:when>
                                    <c:when test="${task.priority == 'MEDIUM'}">
                                        <span class="badge bg-warning">🟡 Trung bình</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">⚪ Thấp</span>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Priority Selection Form -->
            <div class="card">
                <div class="card-header bg-white">
                    <h5 class="mb-0"><i class="bi bi-flag-fill me-2"></i>Chọn mức độ ưu tiên</h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/manager/task/priority" method="post">
                        <input type="hidden" name="taskId" value="${task.taskId}">

                        <div class="mb-4">
                            <div class="row g-3">
                                <c:forEach var="p" items="${priorityValues}">
                                    <div class="col-md-4">
                                        <div class="form-check priority-card">
                                            <input class="form-check-input" type="radio"
                                                   name="priority" id="priority_${p.name()}"
                                                   value="${p.name()}"
                                                   ${task.priority == p.name() ? 'checked' : ''}
                                                   required>
                                            <label class="form-check-label card p-4 w-100 text-center cursor-pointer" for="priority_${p.name()}">
                                                <c:choose>
                                                    <c:when test="${p.name() == 'HIGH'}">
                                                        <div class="priority-icon text-danger mb-3">
                                                            <i class="bi bi-exclamation-triangle-fill" style="font-size: 3rem;"></i>
                                                        </div>
                                                        <h4 class="mb-2 text-danger">🔴 ${p.vietnamese}</h4>
                                                        <p class="text-muted small mb-0">
                                                            Công việc cực kỳ quan trọng<br>
                                                            Cần ưu tiên cao nhất<br>
                                                            Xử lý ngay lập tức
                                                        </p>
                                                        <div class="mt-3">
                                                            <span class="badge bg-danger">Khẩn cấp</span>
                                                        </div>
                                                    </c:when>
                                                    <c:when test="${p.name() == 'MEDIUM'}">
                                                        <div class="priority-icon text-warning mb-3">
                                                            <i class="bi bi-flag-fill" style="font-size: 3rem;"></i>
                                                        </div>
                                                        <h4 class="mb-2 text-warning">🟡 ${p.vietnamese}</h4>
                                                        <p class="text-muted small mb-0">
                                                            Công việc quan trọng<br>
                                                            Ưu tiên bình thường<br>
                                                            Hoàn thành đúng hạn
                                                        </p>
                                                        <div class="mt-3">
                                                            <span class="badge bg-warning">Bình thường</span>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="priority-icon text-secondary mb-3">
                                                            <i class="bi bi-flag" style="font-size: 3rem;"></i>
                                                        </div>
                                                        <h4 class="mb-2 text-secondary">⚪ ${p.vietnamese}</h4>
                                                        <p class="text-muted small mb-0">
                                                            Công việc ít quan trọng<br>
                                                            Có thể làm sau<br>
                                                            Không cần gấp
                                                        </p>
                                                        <div class="mt-3">
                                                            <span class="badge bg-secondary">Không gấp</span>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </label>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <!-- Reason -->
                        <div class="mb-4">
                            <label for="priorityReason" class="form-label">Lý do thay đổi (tùy chọn)</label>
                            <textarea class="form-control" id="priorityReason" name="priorityReason" rows="3"
                                      placeholder="Giải thích lý do thay đổi mức độ ưu tiên..."></textarea>
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="bi bi-check-circle me-2"></i>
                                Cập nhật ưu tiên
                            </button>
                            <a href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}"
                               class="btn btn-secondary btn-lg">
                                <i class="bi bi-x-circle me-2"></i>Hủy
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Sidebar -->
        <div class="col-lg-4">
            <!-- Priority Guide -->
            <div class="card mb-3">
                <div class="card-header bg-white">
                    <h6 class="mb-0"><i class="bi bi-info-circle me-2"></i>Hướng dẫn chọn ưu tiên</h6>
                </div>
                <div class="card-body">
                    <div class="priority-guide mb-3">
                        <div class="d-flex align-items-start mb-2">
                            <span class="badge bg-danger me-2">HIGH</span>
                            <small class="text-muted">
                                Ảnh hưởng lớn, cần làm ngay, deadline gần, blocking khác
                            </small>
                        </div>
                        <div class="d-flex align-items-start mb-2">
                            <span class="badge bg-warning me-2">MEDIUM</span>
                            <small class="text-muted">
                                Quan trọng nhưng không gấp, có thể lên kế hoạch
                            </small>
                        </div>
                        <div class="d-flex align-items-start">
                            <span class="badge bg-secondary me-2">LOW</span>
                            <small class="text-muted">
                                Ít quan trọng, có thể hoãn, nice-to-have
                            </small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tips Card -->
            <div class="card bg-light">
                <div class="card-body">
                    <h6 class="card-title"><i class="bi bi-lightbulb me-2"></i>Mẹo</h6>
                    <ul class="list-unstyled small mb-0">
                        <li class="mb-2">
                            <i class="bi bi-check2 text-success me-2"></i>
                            Xem xét tác động của công việc
                        </li>
                        <li class="mb-2">
                            <i class="bi bi-check2 text-success me-2"></i>
                            Cân nhắc deadline
                        </li>
                        <li class="mb-2">
                            <i class="bi bi-check2 text-success me-2"></i>
                            Tránh đặt quá nhiều HIGH
                        </li>
                        <li class="mb-2">
                            <i class="bi bi-check2 text-success me-2"></i>
                            Có thể thay đổi khi cần
                        </li>
                        <li class="mb-0">
                            <i class="bi bi-check2 text-success me-2"></i>
                            Thông báo cho team khi thay đổi
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .priority-card .form-check-input:checked + .form-check-label {
        box-shadow: 0 0 0 3px rgba(13, 110, 253, 0.25);
        transform: scale(1.02);
        transition: all 0.2s;
    }
    .priority-card .form-check-label {
        transition: all 0.2s;
        border: 2px solid transparent;
    }
    .priority-card .form-check-label:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }
    .cursor-pointer {
        cursor: pointer;
    }
</style>
