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
                <li class="breadcrumb-item active">Cập nhật trạng thái</li>
            </ol>
        </nav>
        <h3><i class="bi bi-arrow-repeat me-2"></i>Cập nhật Trạng thái</h3>
        <p class="text-muted">Thay đổi trạng thái thực hiện của công việc</p>
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
                    <c:if test="${task.description != null && !task.description.isEmpty()}">
                        <p class="text-muted">${task.description}</p>
                    </c:if>
                    <div class="row">
                        <div class="col-md-4">
                            <small class="text-muted d-block">Người thực hiện</small>
                            <p class="fw-bold">
                                <c:forEach var="user" items="${allUsers}">
                                    <c:if test="${user.userId == task.assignedTo}">
                                        ${user.firstName} ${user.lastName}
                                    </c:if>
                                </c:forEach>
                            </p>
                        </div>
                        <div class="col-md-4">
                            <small class="text-muted d-block">Hạn chót</small>
                            <p class="fw-bold">
                                <fmt:formatDate value="${task.dueDate}" pattern="dd/MM/yyyy" />
                            </p>
                        </div>
                        <div class="col-md-4">
                            <small class="text-muted d-block">Ưu tiên</small>
                            <p>
                                <c:choose>
                                    <c:when test="${task.priority == 'HIGH'}">
                                        <span class="badge bg-danger">Cao</span>
                                    </c:when>
                                    <c:when test="${task.priority == 'MEDIUM'}">
                                        <span class="badge bg-warning">Trung bình</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">Thấp</span>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Status Update Form -->
            <div class="card">
                <div class="card-header bg-white">
                    <h5 class="mb-0"><i class="bi bi-toggle-on me-2"></i>Chọn trạng thái mới</h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/manager/task/status" method="post">
                        <input type="hidden" name="taskId" value="${task.taskId}">

                        <!-- Current Status -->
                        <div class="alert alert-info">
                            <strong>Trạng thái hiện tại:</strong>
                            <c:choose>
                                <c:when test="${task.status == 'COMPLETED'}">
                                    <span class="badge bg-success ms-2">Hoàn thành</span>
                                </c:when>
                                <c:when test="${task.status == 'IN_PROGRESS'}">
                                    <span class="badge bg-info ms-2">Đang thực hiện</span>
                                </c:when>
                                <c:when test="${task.status == 'CANCELLED'}">
                                    <span class="badge bg-dark ms-2">Đã hủy</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary ms-2">Chờ xử lý</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Status Selection -->
                        <div class="mb-4">
                            <label class="form-label fw-bold">Chọn trạng thái mới <span class="text-danger">*</span></label>
                            <div class="row g-3">
                                <c:forEach var="s" items="${taskStatusValues}">
                                    <div class="col-md-6">
                                        <div class="form-check card-check">
                                            <input class="form-check-input" type="radio"
                                                   name="status" id="status_${s.name()}"
                                                   value="${s.name()}"
                                                   ${task.status == s.name() ? 'checked' : ''}
                                                   required>
                                            <label class="form-check-label card p-3 w-100 cursor-pointer" for="status_${s.name()}">
                                                <div class="d-flex align-items-center justify-content-between">
                                                    <div>
                                                        <h6 class="mb-1">
                                                            <c:choose>
                                                                <c:when test="${s.name() == 'COMPLETED'}">
                                                                    <i class="bi bi-check-circle text-success me-2"></i>
                                                                </c:when>
                                                                <c:when test="${s.name() == 'IN_PROGRESS'}">
                                                                    <i class="bi bi-hourglass-split text-info me-2"></i>
                                                                </c:when>
                                                                <c:when test="${s.name() == 'CANCELLED'}">
                                                                    <i class="bi bi-x-circle text-dark me-2"></i>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <i class="bi bi-clock-history text-secondary me-2"></i>
                                                                </c:otherwise>
                                                            </c:choose>
                                                            ${s.vietnamese}
                                                        </h6>
                                                        <small class="text-muted">
                                                            <c:choose>
                                                                <c:when test="${s.name() == 'PENDING'}">
                                                                    Công việc đang chờ bắt đầu thực hiện
                                                                </c:when>
                                                                <c:when test="${s.name() == 'IN_PROGRESS'}">
                                                                    Công việc đang được thực hiện
                                                                </c:when>
                                                                <c:when test="${s.name() == 'COMPLETED'}">
                                                                    Công việc đã hoàn thành xong
                                                                </c:when>
                                                                <c:when test="${s.name() == 'CANCELLED'}">
                                                                    Công việc đã bị hủy bỏ
                                                                </c:when>
                                                            </c:choose>
                                                        </small>
                                                    </div>
                                                    <div>
                                                        <c:choose>
                                                            <c:when test="${s.name() == 'COMPLETED'}">
                                                                <span class="badge bg-success">✓</span>
                                                            </c:when>
                                                            <c:when test="${s.name() == 'IN_PROGRESS'}">
                                                                <span class="badge bg-info">●</span>
                                                            </c:when>
                                                            <c:when test="${s.name() == 'CANCELLED'}">
                                                                <span class="badge bg-dark">×</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">○</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </label>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <!-- Note -->
                        <div class="mb-4">
                            <label for="statusNote" class="form-label">Ghi chú về thay đổi (tùy chọn)</label>
                            <textarea class="form-control" id="statusNote" name="statusNote" rows="3"
                                      placeholder="Thêm ghi chú về lý do thay đổi trạng thái..."></textarea>
                        </div>

                        <!-- Warning for completion -->
                        <div id="completionWarning" class="alert alert-warning" style="display: none;">
                            <i class="bi bi-exclamation-triangle me-2"></i>
                            <strong>Lưu ý:</strong> Khi đánh dấu công việc là "Hoàn thành", hệ thống sẽ tự động ghi nhận thời gian hoàn thành.
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="bi bi-check-circle me-2"></i>
                                Cập nhật trạng thái
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
            <!-- Status Flow Card -->
            <div class="card mb-3">
                <div class="card-header bg-white">
                    <h6 class="mb-0"><i class="bi bi-diagram-3 me-2"></i>Quy trình trạng thái</h6>
                </div>
                <div class="card-body">
                    <div class="timeline">
                        <div class="timeline-item">
                            <div class="timeline-marker bg-secondary"></div>
                            <div class="timeline-content">
                                <strong>Chờ xử lý</strong>
                                <p class="small text-muted mb-0">Công việc mới tạo</p>
                            </div>
                        </div>
                        <div class="timeline-item">
                            <div class="timeline-marker bg-info"></div>
                            <div class="timeline-content">
                                <strong>Đang thực hiện</strong>
                                <p class="small text-muted mb-0">Đang làm việc</p>
                            </div>
                        </div>
                        <div class="timeline-item">
                            <div class="timeline-marker bg-success"></div>
                            <div class="timeline-content">
                                <strong>Hoàn thành</strong>
                                <p class="small text-muted mb-0">Kết thúc thành công</p>
                            </div>
                        </div>
                        <div class="timeline-item">
                            <div class="timeline-marker bg-dark"></div>
                            <div class="timeline-content">
                                <strong>Đã hủy</strong>
                                <p class="small text-muted mb-0">Không thực hiện nữa</p>
                            </div>
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
                            Cập nhật trạng thái kịp thời
                        </li>
                        <li class="mb-2">
                            <i class="bi bi-check2 text-success me-2"></i>
                            Thêm ghi chú khi cần thiết
                        </li>
                        <li class="mb-2">
                            <i class="bi bi-check2 text-success me-2"></i>
                            Hoàn thành khi công việc xong 100%
                        </li>
                        <li class="mb-0">
                            <i class="bi bi-check2 text-success me-2"></i>
                            Hủy khi công việc không còn cần thiết
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .card-check .form-check-input:checked + .form-check-label {
        border-color: var(--bs-primary);
        background-color: rgba(13, 110, 253, 0.05);
    }
    .cursor-pointer {
        cursor: pointer;
    }
    .timeline {
        position: relative;
    }
    .timeline-item {
        display: flex;
        margin-bottom: 1.5rem;
        position: relative;
    }
    .timeline-item:last-child {
        margin-bottom: 0;
    }
    .timeline-item:not(:last-child)::before {
        content: '';
        position: absolute;
        left: 10px;
        top: 30px;
        width: 2px;
        height: calc(100% + 10px);
        background-color: #dee2e6;
    }
    .timeline-marker {
        width: 20px;
        height: 20px;
        border-radius: 50%;
        margin-right: 15px;
        flex-shrink: 0;
        margin-top: 3px;
        z-index: 1;
    }
    .timeline-content {
        flex-grow: 1;
    }
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const statusRadios = document.querySelectorAll('input[name="status"]');
    const completionWarning = document.getElementById('completionWarning');

    statusRadios.forEach(radio => {
        radio.addEventListener('change', function() {
            if (this.value === 'COMPLETED') {
                completionWarning.style.display = 'block';
            } else {
                completionWarning.style.display = 'none';
            }
        });
    });

    // Trigger on page load if COMPLETED is selected
    const selectedRadio = document.querySelector('input[name="status"]:checked');
    if (selectedRadio && selectedRadio.value === 'COMPLETED') {
        completionWarning.style.display = 'block';
    }
});
</script>
