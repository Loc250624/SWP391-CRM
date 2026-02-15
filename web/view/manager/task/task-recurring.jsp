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
                <li class="breadcrumb-item active">Cài đặt lặp lại</li>
            </ol>
        </nav>
        <h3><i class="bi bi-arrow-repeat me-2"></i>Cài đặt Công việc Lặp lại</h3>
        <p class="text-muted">Tự động tạo công việc lặp lại theo chu kỳ</p>
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
                    <p class="text-muted">${task.description}</p>
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
                            <small class="text-muted d-block">Trạng thái</small>
                            <p>
                                <c:choose>
                                    <c:when test="${task.status == 'COMPLETED'}">
                                        <span class="badge bg-success">Hoàn thành</span>
                                    </c:when>
                                    <c:when test="${task.status == 'IN_PROGRESS'}">
                                        <span class="badge bg-info">Đang thực hiện</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">Chờ xử lý</span>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recurring Settings Form -->
            <div class="card">
                <div class="card-header bg-white">
                    <h5 class="mb-0"><i class="bi bi-arrow-clockwise me-2"></i>Cài đặt lặp lại</h5>
                </div>
                <div class="card-body">
                    <div class="alert alert-info">
                        <i class="bi bi-info-circle me-2"></i>
                        <strong>Lưu ý:</strong> Công việc lặp lại sẽ tự động được tạo khi công việc hiện tại hoàn thành.
                        Đánh dấu tiêu đề với [R] để hệ thống nhận diện công việc lặp lại.
                    </div>

                    <form action="${pageContext.request.contextPath}/manager/task/recurring" method="post">
                        <input type="hidden" name="taskId" value="${task.taskId}">

                        <!-- Enable Recurring -->
                        <div class="mb-4">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" id="enableRecurring"
                                       name="enableRecurring" ${task.title.startsWith('[R]') ? 'checked' : ''}>
                                <label class="form-check-label fw-bold" for="enableRecurring">
                                    Bật chế độ lặp lại
                                </label>
                            </div>
                        </div>

                        <div id="recurringOptions" style="display: ${task.title.startsWith('[R]') ? 'block' : 'none'};">
                            <!-- Recurrence Pattern -->
                            <div class="mb-4">
                                <label class="form-label fw-bold">Chu kỳ lặp lại</label>
                                <div class="row g-3">
                                    <div class="col-md-4">
                                        <div class="form-check card-check">
                                            <input class="form-check-input" type="radio" name="recurrencePattern"
                                                   id="pattern_daily" value="DAILY">
                                            <label class="form-check-label card p-3 w-100 cursor-pointer" for="pattern_daily">
                                                <div class="text-center">
                                                    <i class="bi bi-calendar-day text-primary fs-1"></i>
                                                    <h6 class="mt-2 mb-1">Hàng ngày</h6>
                                                    <small class="text-muted">Lặp lại mỗi ngày</small>
                                                </div>
                                            </label>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-check card-check">
                                            <input class="form-check-input" type="radio" name="recurrencePattern"
                                                   id="pattern_weekly" value="WEEKLY" checked>
                                            <label class="form-check-label card p-3 w-100 cursor-pointer" for="pattern_weekly">
                                                <div class="text-center">
                                                    <i class="bi bi-calendar-week text-primary fs-1"></i>
                                                    <h6 class="mt-2 mb-1">Hàng tuần</h6>
                                                    <small class="text-muted">Lặp lại mỗi tuần</small>
                                                </div>
                                            </label>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-check card-check">
                                            <input class="form-check-input" type="radio" name="recurrencePattern"
                                                   id="pattern_monthly" value="MONTHLY">
                                            <label class="form-check-label card p-3 w-100 cursor-pointer" for="pattern_monthly">
                                                <div class="text-center">
                                                    <i class="bi bi-calendar-month text-primary fs-1"></i>
                                                    <h6 class="mt-2 mb-1">Hàng tháng</h6>
                                                    <small class="text-muted">Lặp lại mỗi tháng</small>
                                                </div>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Additional Options -->
                            <div class="card bg-light mb-4">
                                <div class="card-header bg-transparent">
                                    <h6 class="mb-0">Tùy chọn nâng cao</h6>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="repeatCount" class="form-label">Số lần lặp lại (tùy chọn)</label>
                                            <input type="number" class="form-control" id="repeatCount" name="repeatCount"
                                                   min="1" max="100" placeholder="Không giới hạn">
                                            <small class="text-muted">Để trống nếu lặp lại vô thời hạn</small>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="endDate" class="form-label">Ngày kết thúc (tùy chọn)</label>
                                            <input type="date" class="form-control" id="endDate" name="endDate">
                                            <small class="text-muted">Ngày dừng tạo công việc lặp lại</small>
                                        </div>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="skipWeekends" name="skipWeekends">
                                        <label class="form-check-label" for="skipWeekends">
                                            Bỏ qua cuối tuần
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <!-- Preview -->
                            <div class="card mb-4">
                                <div class="card-header bg-white">
                                    <h6 class="mb-0"><i class="bi bi-eye me-2"></i>Xem trước</h6>
                                </div>
                                <div class="card-body">
                                    <p class="text-muted mb-2">Các lần lặp lại tiếp theo:</p>
                                    <ul class="list-unstyled mb-0" id="previewDates">
                                        <li class="mb-1">
                                            <i class="bi bi-calendar3 me-2 text-primary"></i>
                                            <span id="nextDate1">--/--/----</span>
                                        </li>
                                        <li class="mb-1">
                                            <i class="bi bi-calendar3 me-2 text-primary"></i>
                                            <span id="nextDate2">--/--/----</span>
                                        </li>
                                        <li class="mb-1">
                                            <i class="bi bi-calendar3 me-2 text-primary"></i>
                                            <span id="nextDate3">--/--/----</span>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="bi bi-check-circle me-2"></i>
                                Lưu cài đặt
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
            <!-- How it Works -->
            <div class="card mb-3">
                <div class="card-header bg-white">
                    <h6 class="mb-0"><i class="bi bi-question-circle me-2"></i>Cách hoạt động</h6>
                </div>
                <div class="card-body">
                    <ol class="small mb-0 ps-3">
                        <li class="mb-2">Bật chế độ lặp lại và chọn chu kỳ</li>
                        <li class="mb-2">Hệ thống tự động đánh dấu [R] vào tiêu đề</li>
                        <li class="mb-2">Khi công việc hoàn thành, hệ thống tạo bản sao mới</li>
                        <li class="mb-2">Công việc mới có deadline theo chu kỳ đã chọn</li>
                        <li class="mb-0">Quá trình lặp lại cho đến khi đạt giới hạn</li>
                    </ol>
                </div>
            </div>

            <!-- Examples -->
            <div class="card bg-light">
                <div class="card-body">
                    <h6 class="card-title"><i class="bi bi-lightbulb me-2"></i>Ví dụ</h6>
                    <ul class="list-unstyled small mb-0">
                        <li class="mb-2">
                            <strong>Họp tuần:</strong> Chu kỳ hàng tuần
                        </li>
                        <li class="mb-2">
                            <strong>Báo cáo tháng:</strong> Chu kỳ hàng tháng
                        </li>
                        <li class="mb-2">
                            <strong>Kiểm tra hàng ngày:</strong> Chu kỳ hàng ngày
                        </li>
                        <li class="mb-0">
                            <strong>Review quý:</strong> Chu kỳ 3 tháng
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
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const enableRecurring = document.getElementById('enableRecurring');
    const recurringOptions = document.getElementById('recurringOptions');
    const patternRadios = document.querySelectorAll('input[name="recurrencePattern"]');
    const dueDateStr = '<fmt:formatDate value="${task.dueDate}" pattern="yyyy-MM-dd" />';

    enableRecurring.addEventListener('change', function() {
        recurringOptions.style.display = this.checked ? 'block' : 'none';
        if (this.checked) {
            updatePreview();
        }
    });

    patternRadios.forEach(radio => {
        radio.addEventListener('change', updatePreview);
    });

    function updatePreview() {
        const pattern = document.querySelector('input[name="recurrencePattern"]:checked')?.value;
        const dueDate = new Date(dueDateStr);

        if (pattern) {
            for (let i = 1; i <= 3; i++) {
                const nextDate = new Date(dueDate);

                if (pattern === 'DAILY') {
                    nextDate.setDate(dueDate.getDate() + (7 * i)); // Show weekly for preview
                } else if (pattern === 'WEEKLY') {
                    nextDate.setDate(dueDate.getDate() + (7 * i));
                } else if (pattern === 'MONTHLY') {
                    nextDate.setMonth(dueDate.getMonth() + i);
                }

                const formatted = nextDate.toLocaleDateString('vi-VN');
                document.getElementById('nextDate' + i).textContent = formatted;
            }
        }
    }

    if (enableRecurring.checked) {
        updatePreview();
    }
});
</script>
