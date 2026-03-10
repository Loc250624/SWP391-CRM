<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="container-fluid">
    <!-- Header -->
    <div class="mb-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/manager/task/list">Công việc</a>
                </li>
                <li class="breadcrumb-item active">Chi tiết</li>
            </ol>
        </nav>
        <div class="d-flex justify-content-between align-items-center">
            <h3><i class="bi bi-file-earmark-text me-2"></i>Chi tiết Công việc</h3>
            <div class="d-flex gap-2 flex-wrap">
                <c:if test="${task.statusName != 'COMPLETED' && task.statusName != 'CANCELLED'}">
                    <a href="${pageContext.request.contextPath}/manager/task/status?id=${task.taskId}"
                       class="btn btn-success btn-sm">
                        <i class="bi bi-arrow-repeat me-1"></i>Trạng thái
                    </a>
                    <a href="${pageContext.request.contextPath}/manager/task/assign?id=${task.taskId}"
                       class="btn btn-outline-primary btn-sm">
                        <i class="bi bi-person-check me-1"></i>Gán lại
                    </a>
                </c:if>
                <a href="${pageContext.request.contextPath}/manager/task/recurring?id=${task.taskId}"
                   class="btn btn-outline-info btn-sm">
                    <i class="bi bi-arrow-clockwise me-1"></i>Lặp lại
                </a>
                <a href="${pageContext.request.contextPath}/manager/task/form?action=edit&id=${task.taskId}"
                   class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-pencil me-1"></i>Sửa
                </a>
                <%-- FIX: Delete via POST form to prevent CSRF / accidental GET deletion --%>
                <form method="post"
                      action="${pageContext.request.contextPath}/manager/task/delete"
                      class="d-inline"
                      onsubmit="return confirm('Bạn có chắc chắn muốn xóa công việc này?');">
                    <input type="hidden" name="id" value="${task.taskId}">
                    <button type="submit" class="btn btn-outline-danger btn-sm">
                        <i class="bi bi-trash me-1"></i>Xóa
                    </button>
                </form>
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
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle me-2"></i>${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="errorMessage" scope="session" />
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
                            <c:when test="${task.statusName == 'COMPLETED'}">
                                <span class="badge bg-success">Hoàn thành</span>
                            </c:when>
                            <c:when test="${task.statusName == 'IN_PROGRESS'}">
                                <span class="badge bg-info">Đang thực hiện</span>
                            </c:when>
                            <c:when test="${task.statusName == 'CANCELLED'}">
                                <span class="badge bg-dark">Đã hủy</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary">Chờ xử lý</span>
                            </c:otherwise>
                        </c:choose>
                        <c:choose>
                            <c:when test="${task.priorityName == 'HIGH'}">
                                <span class="badge bg-danger ms-2">Ưu tiên cao</span>
                            </c:when>
                            <c:when test="${task.priorityName == 'MEDIUM'}">
                                <span class="badge bg-warning text-dark ms-2">Ưu tiên trung bình</span>
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
                        <c:when test="${not empty cleanDescription}">
                            <p class="text-muted">${cleanDescription}</p>
                        </c:when>
                        <c:when test="${empty cleanDescription && not empty task.description && !fn:startsWith(task.description, '[DEPS:')}">
                            <p class="text-muted">${task.description}</p>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted fst-italic">Không có mô tả</p>
                        </c:otherwise>
                    </c:choose>

                    <hr class="my-4">

                    <!-- Timeline Info -->
                    <%-- FIX: Replace fmt:formatDate (only works with java.util.Date) with fn:substring.
                         LocalDateTime.toString() = "YYYY-MM-DDTHH:mm:ss[.nanos]"
                         We extract: day=8-10, month=5-7, year=0-4, time=11-16 --%>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <h6 class="fw-bold mb-2">
                                <i class="bi bi-calendar-event me-2"></i>Hạn chót
                            </h6>
                            <c:choose>
                                <c:when test="${task.dueDate != null}">
                                    <p class="mb-0" id="dueDateText">
                                        ${fn:substring(task.dueDate, 8, 10)}/${fn:substring(task.dueDate, 5, 7)}/${fn:substring(task.dueDate, 0, 4)}
                                        ${fn:substring(task.dueDate, 11, 16)}
                                    </p>
                                    <%-- FIX: Overdue badge rendered by JS below --%>
                                    <span id="overdueLabel"></span>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted mb-0">Không xác định</p>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="col-md-6 mb-3">
                            <h6 class="fw-bold mb-2">
                                <i class="bi bi-bell me-2"></i>Nhắc nhở
                            </h6>
                            <c:choose>
                                <c:when test="${task.reminderAt != null}">
                                    <p class="mb-0">
                                        ${fn:substring(task.reminderAt, 8, 10)}/${fn:substring(task.reminderAt, 5, 7)}/${fn:substring(task.reminderAt, 0, 4)}
                                        ${fn:substring(task.reminderAt, 11, 16)}
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
                            <h6 class="fw-bold mb-2">
                                <i class="bi bi-calendar-plus me-2"></i>Ngày tạo
                            </h6>
                            <c:if test="${task.createdAt != null}">
                                <p class="mb-0">
                                    ${fn:substring(task.createdAt, 8, 10)}/${fn:substring(task.createdAt, 5, 7)}/${fn:substring(task.createdAt, 0, 4)}
                                    ${fn:substring(task.createdAt, 11, 16)}
                                </p>
                            </c:if>
                        </div>

                        <div class="col-md-6 mb-3">
                            <h6 class="fw-bold mb-2">
                                <i class="bi bi-calendar-check me-2"></i>Hoàn thành
                            </h6>
                            <c:choose>
                                <c:when test="${task.completedAt != null}">
                                    <p class="mb-0 text-success">
                                        ${fn:substring(task.completedAt, 8, 10)}/${fn:substring(task.completedAt, 5, 7)}/${fn:substring(task.completedAt, 0, 4)}
                                        ${fn:substring(task.completedAt, 11, 16)}
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
                <div class="card mb-4">
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
                                <c:when test="${task.relatedType == 'LEAD' || task.relatedType == 'Lead'}">
                                    <a href="${pageContext.request.contextPath}/manager/lead/detail?id=${task.relatedId}"
                                       class="btn btn-sm btn-outline-primary">
                                        Xem chi tiết <i class="bi bi-arrow-right ms-1"></i>
                                    </a>
                                </c:when>
                                <c:when test="${task.relatedType == 'CUSTOMER' || task.relatedType == 'Customer'}">
                                    <a href="${pageContext.request.contextPath}/manager/customer/detail?id=${task.relatedId}"
                                       class="btn btn-sm btn-outline-primary">
                                        Xem chi tiết <i class="bi bi-arrow-right ms-1"></i>
                                    </a>
                                </c:when>
                                <c:when test="${task.relatedType == 'OPPORTUNITY' || task.relatedType == 'Opportunity'}">
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

            <!-- Subtasks -->
            <div class="card mb-4">
                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                    <h6 class="mb-0"><i class="bi bi-diagram-2 me-2"></i>Công việc con (${subtaskCount})</h6>
                    <c:if test="${task.statusName != 'COMPLETED' && task.statusName != 'CANCELLED'}">
                        <button class="btn btn-sm btn-outline-success" type="button"
                                data-bs-toggle="collapse" data-bs-target="#addSubtaskForm">
                            <i class="bi bi-plus me-1"></i>Thêm
                        </button>
                    </c:if>
                </div>
                <div class="card-body">
                    <%-- Subtask progress bar --%>
                    <c:if test="${subtaskCount > 0}">
                        <div class="mb-3">
                            <div class="d-flex justify-content-between mb-1">
                                <small class="text-muted">Tiến độ subtask</small>
                                <small class="fw-bold">${completedSubtaskCount}/${subtaskCount}</small>
                            </div>
                            <div class="progress" style="height: 8px;">
                                <div class="progress-bar bg-success" role="progressbar"
                                     style="width: ${subtaskCount > 0 ? (completedSubtaskCount * 100 / subtaskCount) : 0}%">
                                </div>
                            </div>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-sm table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Tiêu đề</th>
                                        <th>Người thực hiện</th>
                                        <th>Hạn chót</th>
                                        <th>Trạng thái</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="sub" items="${subtasks}">
                                        <tr>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/manager/task/detail?id=${sub.taskId}"
                                                   class="text-decoration-none">${sub.title}</a>
                                            </td>
                                            <td>
                                                <c:forEach var="u" items="${allUsers}">
                                                    <c:if test="${u.userId == sub.assignedTo}">
                                                        <small>${u.firstName} ${u.lastName}</small>
                                                    </c:if>
                                                </c:forEach>
                                            </td>
                                            <td>
                                                <c:if test="${sub.dueDate != null}">
                                                    <small>${fn:substring(sub.dueDate, 8, 10)}/${fn:substring(sub.dueDate, 5, 7)}/${fn:substring(sub.dueDate, 0, 4)}</small>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${sub.statusName == 'COMPLETED'}">
                                                        <span class="badge bg-success">Hoàn thành</span>
                                                    </c:when>
                                                    <c:when test="${sub.statusName == 'IN_PROGRESS'}">
                                                        <span class="badge bg-info">Đang làm</span>
                                                    </c:when>
                                                    <c:when test="${sub.statusName == 'CANCELLED'}">
                                                        <span class="badge bg-dark">Đã hủy</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Chờ</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/manager/task/detail?id=${sub.taskId}"
                                                   class="btn btn-xs btn-outline-primary" style="font-size:0.7rem; padding:1px 6px;">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                    <c:if test="${subtaskCount == 0}">
                        <p class="text-muted fst-italic mb-0">Chưa có công việc con</p>
                    </c:if>

                    <%-- Add Subtask Form (collapsed) --%>
                    <c:if test="${task.statusName != 'COMPLETED' && task.statusName != 'CANCELLED'}">
                        <div class="collapse mt-3" id="addSubtaskForm">
                            <div class="border rounded p-3 bg-light">
                                <h6 class="mb-3">Thêm công việc con</h6>
                                <form method="post" action="${pageContext.request.contextPath}/manager/task/form">
                                    <input type="hidden" name="action"      value="create">
                                    <input type="hidden" name="relatedType" value="SUBTASK">
                                    <input type="hidden" name="relatedId"   value="${task.taskId}">
                                    <div class="row g-2">
                                        <div class="col-md-5">
                                            <input type="text" class="form-control form-control-sm"
                                                   name="title" placeholder="Tiêu đề công việc con *" required>
                                        </div>
                                        <div class="col-md-3">
                                            <select class="form-select form-select-sm" name="assignedTo">
                                                <option value="">-- Người thực hiện --</option>
                                                <c:forEach var="u" items="${allUsers}">
                                                    <option value="${u.userId}">${u.firstName} ${u.lastName}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <input type="date" class="form-control form-control-sm" name="dueDate">
                                        </div>
                                        <div class="col-md-2">
                                            <button type="submit" class="btn btn-sm btn-success w-100">
                                                <i class="bi bi-check2"></i> Lưu
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Dependencies -->
            <c:if test="${not empty dependencyTasks}">
                <div class="card mb-4">
                    <div class="card-header bg-white">
                        <h6 class="mb-0">
                            <i class="bi bi-lock me-2 ${allDepsCompleted ? 'text-success' : 'text-danger'}"></i>
                            Công việc phụ thuộc
                            <c:if test="${!allDepsCompleted}">
                                <span class="badge bg-danger ms-2">Đang bị chặn</span>
                            </c:if>
                            <c:if test="${allDepsCompleted}">
                                <span class="badge bg-success ms-2">Đã giải phóng</span>
                            </c:if>
                        </h6>
                    </div>
                    <div class="card-body">
                        <c:if test="${!allDepsCompleted}">
                            <div class="alert alert-warning py-2 mb-3">
                                <i class="bi bi-exclamation-triangle me-2"></i>
                                Công việc này bị chặn — cần hoàn thành các công việc phụ thuộc trước khi bắt đầu.
                            </div>
                        </c:if>
                        <ul class="list-unstyled mb-0">
                            <c:forEach var="dep" items="${dependencyTasks}">
                                <li class="d-flex align-items-center mb-2">
                                    <c:choose>
                                        <c:when test="${dep.statusName == 'COMPLETED'}">
                                            <i class="bi bi-check-circle-fill text-success me-2"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="bi bi-x-circle-fill text-danger me-2"></i>
                                        </c:otherwise>
                                    </c:choose>
                                    <a href="${pageContext.request.contextPath}/manager/task/detail?id=${dep.taskId}"
                                       class="text-decoration-none">
                                        <span class="badge bg-secondary me-1">${dep.taskCode}</span>
                                        ${dep.title}
                                    </a>
                                    <c:choose>
                                        <c:when test="${dep.statusName == 'COMPLETED'}">
                                            <span class="badge bg-success ms-2">Hoàn thành</span>
                                        </c:when>
                                        <c:when test="${dep.statusName == 'IN_PROGRESS'}">
                                            <span class="badge bg-info ms-2">Đang làm</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary ms-2">Chờ xử lý</span>
                                        </c:otherwise>
                                    </c:choose>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
            </c:if>
            <!-- Comments -->
            <div class="card mb-4">
                <div class="card-header bg-white">
                    <h6 class="mb-0"><i class="bi bi-chat-left-text me-2"></i>Bình luận (${fn:length(comments)})</h6>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${empty comments}">
                            <p class="text-muted fst-italic mb-3">Chưa có bình luận nào</p>
                        </c:when>
                        <c:otherwise>
                            <ul class="list-unstyled mb-3">
                                <c:forEach var="cmt" items="${comments}">
                                    <li class="mb-3 d-flex gap-2">
                                        <div class="avatar-sm bg-secondary rounded-circle d-flex align-items-center justify-content-center text-white flex-shrink-0" style="width:32px;height:32px;font-size:0.75rem;">
                                            <c:forEach var="u" items="${allUsers}">
                                                <c:if test="${u.userId == cmt.createdBy}">${fn:substring(u.firstName,0,1)}</c:if>
                                            </c:forEach>
                                        </div>
                                        <div class="bg-light rounded p-2 flex-grow-1">
                                            <div class="d-flex justify-content-between mb-1">
                                                <strong class="small">
                                                    <c:forEach var="u" items="${allUsers}">
                                                        <c:if test="${u.userId == cmt.createdBy}">${u.firstName} ${u.lastName}</c:if>
                                                    </c:forEach>
                                                </strong>
                                                <small class="text-muted">
                                                    ${fn:substring(cmt.createdAt, 8, 10)}/${fn:substring(cmt.createdAt, 5, 7)}/${fn:substring(cmt.createdAt, 0, 4)}
                                                    ${fn:substring(cmt.createdAt, 11, 16)}
                                                </small>
                                            </div>
                                            <p class="mb-0 small">${cmt.content}</p>
                                        </div>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:otherwise>
                    </c:choose>
                    <form method="post" action="${pageContext.request.contextPath}/manager/task/comment">
                        <input type="hidden" name="taskId" value="${task.taskId}">
                        <div class="input-group">
                            <input type="text" class="form-control form-control-sm"
                                   name="content" placeholder="Thêm bình luận..." required maxlength="500">
                            <button type="submit" class="btn btn-sm btn-success">
                                <i class="bi bi-send"></i>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
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
                                    <%-- FIX: use fn:substring which is null-safe --%>
                                    <h4 class="mb-0">${fn:substring(assignedUser.firstName, 0, 1)}${fn:substring(assignedUser.lastName, 0, 1)}</h4>
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
                                    ${fn:substring(creator.firstName, 0, 1)}${fn:substring(creator.lastName, 0, 1)}
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
    .avatar-lg { width: 60px; height: 60px; flex-shrink: 0; }
    .avatar-md { width: 40px; height: 40px; font-size: 0.875rem; font-weight: 600; flex-shrink: 0; }
</style>

<script>
<%-- FIX: Overdue detection via JavaScript (EL cannot call LocalDateTime.isBefore(now())) --%>
document.addEventListener('DOMContentLoaded', function () {
    <c:if test="${task.dueDate != null && task.statusName != 'COMPLETED' && task.statusName != 'CANCELLED'}">
    (function () {
        var dueStr = '${fn:substring(task.dueDate, 0, 10)}'; // YYYY-MM-DD
        var today = new Date();
        today.setHours(0, 0, 0, 0);
        var due = new Date(dueStr);
        if (due < today) {
            var label = document.getElementById('overdueLabel');
            if (label) {
                label.innerHTML = '<span class="badge bg-danger mt-1">Quá hạn</span>';
            }
            var txt = document.getElementById('dueDateText');
            if (txt) txt.classList.add('text-danger', 'fw-bold');
        }
    }());
    </c:if>
});
</script>
