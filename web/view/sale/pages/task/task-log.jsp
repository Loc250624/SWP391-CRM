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
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/sale/task/detail?id=${task.taskId}">Chi tiết</a>
            </li>
            <li class="breadcrumb-item active">Ghi nhật ký</li>
        </ol>
    </nav>

    <!-- Error Message -->
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="errorMessage" scope="session" />
    </c:if>

    <div class="row justify-content-center">
        <div class="col-lg-8">

            <!-- Overdue Warning (shown by JS if past due) -->
            <c:if test="${task.dueDate != null}">
                <div id="overdueAlert" class="alert alert-warning d-none" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                    <strong>Cảnh báo:</strong> Công việc này đã <strong>quá hạn</strong> vào ngày
                    ${fn:substring(task.dueDate, 8, 10)}/${fn:substring(task.dueDate, 5, 7)}/${fn:substring(task.dueDate, 0, 4)}.
                    Vui lòng liên hệ quản lý nếu cần gia hạn.
                </div>
            </c:if>

            <!-- Task Summary Card -->
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-white d-flex justify-content-between align-items-start">
                    <div>
                        <h5 class="mb-1">${task.title}</h5>
                        <span class="badge bg-secondary me-1">${task.taskCode}</span>
                        <c:choose>
                            <c:when test="${task.status == 'IN_PROGRESS'}">
                                <span class="badge bg-info">Đang thực hiện</span>
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
                    <c:if test="${task.dueDate != null}">
                        <small class="text-muted text-nowrap">
                            <i class="bi bi-calendar-event me-1"></i>Hạn:
                            <strong id="dueDateText">
                                ${fn:substring(task.dueDate, 8, 10)}/${fn:substring(task.dueDate, 5, 7)}/${fn:substring(task.dueDate, 0, 4)}
                            </strong>
                        </small>
                    </c:if>
                </div>
                <c:if test="${not empty task.description}">
                    <div class="card-body py-3">
                        <p class="text-muted small mb-0">${task.description}</p>
                    </div>
                </c:if>
            </div>

            <!-- Log Form Card -->
            <div class="card shadow-sm">
                <div class="card-header bg-white">
                    <h5 class="mb-0">
                        <i class="bi bi-journal-text me-2"></i>Ghi nhật ký công việc
                    </h5>
                </div>
                <div class="card-body">
                    <form id="logForm"
                          action="${pageContext.request.contextPath}/sale/task/log"
                          method="post"
                          novalidate>
                        <input type="hidden" name="taskId" value="${task.taskId}">

                        <!-- Log Note -->
                        <div class="mb-3">
                            <label for="logNote" class="form-label fw-semibold">
                                Nội dung công việc đã thực hiện
                                <span class="text-danger">*</span>
                            </label>
                            <textarea class="form-control" id="logNote" name="logNote"
                                      rows="5"
                                      placeholder="Mô tả chi tiết công việc bạn đã làm trong ca/ngày hôm nay..."
                                      required></textarea>
                            <div class="invalid-feedback">Vui lòng nhập nội dung nhật ký.</div>
                        </div>

                        <!-- Time Spent -->
                        <div class="mb-3">
                            <label for="timeSpent" class="form-label fw-semibold">
                                Thời gian thực hiện (phút)
                            </label>
                            <input type="number" class="form-control" id="timeSpent"
                                   name="timeSpent" min="0" max="9999"
                                   placeholder="Ví dụ: 90 (để trống nếu không rõ)">
                            <div class="invalid-feedback">Thời gian phải là số không âm.</div>
                            <small class="text-muted">
                                <i class="bi bi-info-circle me-1"></i>
                                Nhập số phút bạn đã làm việc cho task này.
                            </small>
                        </div>

                        <!-- Status -->
                        <div class="mb-4">
                            <label for="status" class="form-label fw-semibold">
                                Cập nhật trạng thái sau khi ghi log
                                <span class="text-danger">*</span>
                            </label>
                            <select class="form-select" id="status" name="status" required>
                                <c:forEach var="s" items="${taskStatusValues}">
                                    <c:if test="${s.name() != 'CANCELLED'}">
                                        <option value="${s.name()}"
                                            ${task.status == s.name() ? 'selected' : ''}>
                                            ${s.vietnamese}
                                        </option>
                                    </c:if>
                                </c:forEach>
                            </select>
                            <small class="text-muted">
                                <i class="bi bi-info-circle me-1"></i>
                                Chọn <strong>Hoàn thành</strong> nếu đây là lần ghi log cuối cùng.
                            </small>
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-journal-check me-2"></i>Lưu nhật ký
                            </button>
                            <a href="${pageContext.request.contextPath}/sale/task/detail?id=${task.taskId}"
                               class="btn btn-outline-secondary">
                                <i class="bi bi-x-circle me-2"></i>Hủy
                            </a>
                        </div>
                    </form>
                </div>
            </div>

        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function () {

    // ---------- Overdue detection ----------
    <c:if test="${task.dueDate != null}">
    (function () {
        var dueStr = '${fn:substring(task.dueDate, 0, 10)}'; // YYYY-MM-DD
        var today = new Date();
        today.setHours(0, 0, 0, 0);
        var due = new Date(dueStr);
        if (due < today) {
            var alert = document.getElementById('overdueAlert');
            if (alert) alert.classList.remove('d-none');
            var txt = document.getElementById('dueDateText');
            if (txt) txt.classList.add('text-danger', 'fw-bold');
        }
    }());
    </c:if>

    // ---------- Client-side form validation ----------
    var form = document.getElementById('logForm');
    form.addEventListener('submit', function (e) {
        var valid = true;

        var logNote = document.getElementById('logNote');
        if (!logNote.value.trim()) {
            logNote.classList.add('is-invalid');
            valid = false;
        } else {
            logNote.classList.remove('is-invalid');
        }

        var timeSpent = document.getElementById('timeSpent');
        var tsVal = timeSpent.value.trim();
        if (tsVal !== '') {
            var num = parseInt(tsVal, 10);
            if (isNaN(num) || num < 0 || String(num) !== tsVal) {
                timeSpent.classList.add('is-invalid');
                valid = false;
            } else {
                timeSpent.classList.remove('is-invalid');
            }
        }

        if (!valid) e.preventDefault();
    });

    // Clear invalid state on input
    ['logNote', 'timeSpent'].forEach(function (id) {
        var el = document.getElementById(id);
        if (el) el.addEventListener('input', function () {
            this.classList.remove('is-invalid');
        });
    });
});
</script>
