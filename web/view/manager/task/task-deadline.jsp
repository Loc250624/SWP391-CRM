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
                <li class="breadcrumb-item active">Đặt hạn chót</li>
            </ol>
        </nav>
        <h3><i class="bi bi-calendar-event me-2"></i>Đặt Hạn chót</h3>
        <p class="text-muted">Thay đổi thời hạn hoàn thành công việc</p>
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
                        <div class="col-md-6">
                            <small class="text-muted d-block">Hạn chót hiện tại</small>
                            <h4 class="mb-0">
                                <c:choose>
                                    <c:when test="${task.dueDate != null}">
                                        <fmt:formatDate value="${task.dueDate}" pattern="dd/MM/yyyy" />
                                        <c:if test="${task.dueDate.isBefore(now()) && task.status != 'COMPLETED'}">
                                            <span class="badge bg-danger ms-2">Quá hạn</span>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Chưa đặt</span>
                                    </c:otherwise>
                                </c:choose>
                            </h4>
                        </div>
                        <div class="col-md-6">
                            <small class="text-muted d-block">Người thực hiện</small>
                            <p class="fw-bold mb-0">
                                <c:forEach var="user" items="${allUsers}">
                                    <c:if test="${user.userId == task.assignedTo}">
                                        ${user.firstName} ${user.lastName}
                                    </c:if>
                                </c:forEach>
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Deadline Form -->
            <div class="card">
                <div class="card-header bg-white">
                    <h5 class="mb-0"><i class="bi bi-calendar3 me-2"></i>Đặt ngày hết hạn mới</h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/manager/task/deadline" method="post">
                        <input type="hidden" name="taskId" value="${task.taskId}">

                        <!-- New Due Date -->
                        <div class="mb-4">
                            <label for="dueDate" class="form-label fw-bold">
                                Ngày hết hạn mới <span class="text-danger">*</span>
                            </label>
                            <input type="date" class="form-control form-control-lg" id="dueDate" name="dueDate"
                                   value="<fmt:formatDate value='${task.dueDate}' pattern='yyyy-MM-dd' />"
                                   required>
                            <small class="text-muted">Ngày phải hoàn thành công việc</small>
                        </div>

                        <!-- Due Time (Optional) -->
                        <div class="mb-4">
                            <label for="dueTime" class="form-label">Giờ hết hạn (tùy chọn)</label>
                            <input type="time" class="form-control" id="dueTime" name="dueTime"
                                   value="<fmt:formatDate value='${task.dueDate}' pattern='HH:mm' />">
                            <small class="text-muted">Nếu không chọn, mặc định là 23:59</small>
                        </div>

                        <!-- Reminder Settings -->
                        <div class="card bg-light mb-4">
                            <div class="card-header bg-transparent">
                                <h6 class="mb-0"><i class="bi bi-bell me-2"></i>Cài đặt nhắc nhở</h6>
                            </div>
                            <div class="card-body">
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" id="autoReminder" name="autoReminder" checked>
                                    <label class="form-check-label" for="autoReminder">
                                        Tự động nhắc nhở trước 24 giờ
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="notifyAssignee" name="notifyAssignee" checked>
                                    <label class="form-check-label" for="notifyAssignee">
                                        Thông báo cho người thực hiện
                                    </label>
                                </div>
                            </div>
                        </div>

                        <!-- Extension Reason -->
                        <div class="mb-4">
                            <label for="deadlineReason" class="form-label">Lý do thay đổi (tùy chọn)</label>
                            <textarea class="form-control" id="deadlineReason" name="deadlineReason" rows="3"
                                      placeholder="Giải thích lý do gia hạn hoặc rút ngắn thời gian..."></textarea>
                        </div>

                        <!-- Warning -->
                        <div id="pastDateWarning" class="alert alert-warning" style="display: none;">
                            <i class="bi bi-exclamation-triangle me-2"></i>
                            <strong>Cảnh báo:</strong> Bạn đang đặt hạn chót trong quá khứ. Công việc sẽ được đánh dấu là quá hạn.
                        </div>

                        <div id="extensionInfo" class="alert alert-info" style="display: none;">
                            <i class="bi bi-info-circle me-2"></i>
                            <strong>Thông tin:</strong> Bạn đang gia hạn thêm <span id="extensionDays"></span> ngày.
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="bi bi-check-circle me-2"></i>
                                Cập nhật hạn chót
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
            <!-- Quick Date Selection -->
            <div class="card mb-3">
                <div class="card-header bg-white">
                    <h6 class="mb-0"><i class="bi bi-lightning me-2"></i>Chọn nhanh</h6>
                </div>
                <div class="card-body">
                    <div class="d-grid gap-2">
                        <button type="button" class="btn btn-outline-primary btn-sm quick-date" data-days="1">
                            <i class="bi bi-clock me-2"></i>+1 ngày
                        </button>
                        <button type="button" class="btn btn-outline-primary btn-sm quick-date" data-days="3">
                            <i class="bi bi-clock me-2"></i>+3 ngày
                        </button>
                        <button type="button" class="btn btn-outline-primary btn-sm quick-date" data-days="7">
                            <i class="bi bi-clock me-2"></i>+1 tuần
                        </button>
                        <button type="button" class="btn btn-outline-primary btn-sm quick-date" data-days="14">
                            <i class="bi bi-clock me-2"></i>+2 tuần
                        </button>
                        <button type="button" class="btn btn-outline-primary btn-sm quick-date" data-days="30">
                            <i class="bi bi-clock me-2"></i>+1 tháng
                        </button>
                    </div>
                </div>
            </div>

            <!-- Calendar Info -->
            <div class="card mb-3">
                <div class="card-header bg-white">
                    <h6 class="mb-0"><i class="bi bi-calendar2-week me-2"></i>Thông tin</h6>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <small class="text-muted d-block">Ngày tạo</small>
                        <strong><fmt:formatDate value="${task.createdAt}" pattern="dd/MM/yyyy" /></strong>
                    </div>
                    <div class="mb-3">
                        <small class="text-muted d-block">Trạng thái</small>
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
                    </div>
                    <div class="mb-0">
                        <small class="text-muted d-block">Ưu tiên</small>
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
                    </div>
                </div>
            </div>

            <!-- Tips Card -->
            <div class="card bg-light">
                <div class="card-body">
                    <h6 class="card-title"><i class="bi bi-lightbulb me-2"></i>Lưu ý</h6>
                    <ul class="list-unstyled small mb-0">
                        <li class="mb-2">
                            <i class="bi bi-check2 text-success me-2"></i>
                            Đặt deadline thực tế
                        </li>
                        <li class="mb-2">
                            <i class="bi bi-check2 text-success me-2"></i>
                            Tính thời gian dự phòng
                        </li>
                        <li class="mb-2">
                            <i class="bi bi-check2 text-success me-2"></i>
                            Thông báo khi thay đổi
                        </li>
                        <li class="mb-2">
                            <i class="bi bi-check2 text-success me-2"></i>
                            Giải thích nếu gia hạn
                        </li>
                        <li class="mb-0">
                            <i class="bi bi-check2 text-success me-2"></i>
                            Nhắc nhở trước deadline
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const dueDateInput = document.getElementById('dueDate');
    const pastDateWarning = document.getElementById('pastDateWarning');
    const extensionInfo = document.getElementById('extensionInfo');
    const extensionDays = document.getElementById('extensionDays');
    const currentDueDate = new Date('<fmt:formatDate value="${task.dueDate}" pattern="yyyy-MM-dd" />');

    // Quick date buttons
    document.querySelectorAll('.quick-date').forEach(button => {
        button.addEventListener('click', function() {
            const days = parseInt(this.dataset.days);
            const today = new Date();
            const newDate = new Date(today);
            newDate.setDate(today.getDate() + days);

            const formattedDate = newDate.toISOString().split('T')[0];
            dueDateInput.value = formattedDate;
            dueDateInput.dispatchEvent(new Event('change'));
        });
    });

    // Date change validation
    dueDateInput.addEventListener('change', function() {
        const selectedDate = new Date(this.value);
        const today = new Date();
        today.setHours(0, 0, 0, 0);

        // Check if past date
        if (selectedDate < today) {
            pastDateWarning.style.display = 'block';
            extensionInfo.style.display = 'none';
        } else {
            pastDateWarning.style.display = 'none';

            // Calculate extension
            if (currentDueDate) {
                const diffTime = selectedDate - currentDueDate;
                const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

                if (diffDays > 0) {
                    extensionDays.textContent = diffDays;
                    extensionInfo.style.display = 'block';
                } else if (diffDays < 0) {
                    extensionDays.textContent = Math.abs(diffDays);
                    extensionInfo.querySelector('strong').textContent = 'Thông tin:';
                    extensionInfo.querySelector('span').parentNode.textContent = ' Bạn đang rút ngắn ' + Math.abs(diffDays) + ' ngày.';
                    extensionInfo.style.display = 'block';
                } else {
                    extensionInfo.style.display = 'none';
                }
            }
        }
    });

    // Set min date to today
    const today = new Date().toISOString().split('T')[0];
    dueDateInput.setAttribute('min', today);
});
</script>
