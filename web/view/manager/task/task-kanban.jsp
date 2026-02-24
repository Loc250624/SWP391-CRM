<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="container-fluid">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="mb-1"><i class="bi bi-kanban me-2"></i>Kanban Board</h3>
            <p class="text-muted mb-0">Kéo thả để cập nhật trạng thái công việc</p>
        </div>
        <a href="${pageContext.request.contextPath}/manager/task/form?action=create" class="btn btn-primary">
            <i class="bi bi-plus-circle me-2"></i>Tạo Công việc
        </a>
    </div>

    <!-- Filter bar -->
    <div class="card mb-4">
        <div class="card-body py-2">
            <form method="get" action="${pageContext.request.contextPath}/manager/task/kanban" class="row g-2 align-items-end">
                <div class="col-md-3">
                    <select class="form-select form-select-sm" name="employee">
                        <option value="">Tất cả nhân viên</option>
                        <c:forEach var="member" items="${deptMembers}">
                            <option value="${member.userId}"
                                ${employeeFilter == member.userId ? 'selected' : ''}>
                                ${member.firstName} ${member.lastName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <input type="text" class="form-control form-control-sm" name="keyword"
                           value="${keyword}" placeholder="Tìm tiêu đề...">
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-sm btn-primary">
                        <i class="bi bi-search me-1"></i>Lọc
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Toast notification -->
    <div class="position-fixed bottom-0 end-0 p-3" style="z-index: 2000;">
        <div id="kanbanToast" class="toast align-items-center text-white" role="alert">
            <div class="d-flex">
                <div class="toast-body" id="kanbanToastMsg"></div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
    </div>

    <!-- Kanban Columns -->
    <div class="row g-3">

        <!-- PENDING -->
        <div class="col-md-4">
            <div class="card h-100">
                <div class="card-header bg-secondary text-white d-flex justify-content-between align-items-center">
                    <span><i class="bi bi-clock-history me-2"></i>Chờ xử lý</span>
                    <span class="badge bg-white text-secondary" id="count-PENDING">${fn:length(pendingTasks)}</span>
                </div>
                <div class="card-body p-2 kanban-column" id="col-PENDING"
                     data-status="PENDING" style="min-height: 400px; overflow-y: auto;">
                    <c:forEach var="task" items="${pendingTasks}">
                        <div class="kanban-card card mb-2 shadow-sm"
                             draggable="true"
                             data-task-id="${task.taskId}"
                             data-status="PENDING"
                             data-due="${task.dueDate}"
                             data-deps="${fn:contains(task.description, '[DEPS:')}">
                            <div class="card-body p-2">
                                <div class="d-flex justify-content-between align-items-start mb-1">
                                    <a href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}"
                                       class="text-decoration-none text-dark fw-medium small" style="max-width: 80%;">
                                        <c:if test="${fn:contains(task.title, '[R-')}">
                                            <i class="bi bi-arrow-repeat text-info" title="Lặp lại"></i>
                                        </c:if>
                                        ${task.title}
                                    </a>
                                    <c:choose>
                                        <c:when test="${task.priority == 'HIGH'}">
                                            <span class="badge bg-danger" style="font-size:0.6rem;">CAO</span>
                                        </c:when>
                                        <c:when test="${task.priority == 'MEDIUM'}">
                                            <span class="badge bg-warning text-dark" style="font-size:0.6rem;">TB</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary" style="font-size:0.6rem;">THẤP</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="d-flex justify-content-between align-items-center">
                                    <c:forEach var="user" items="${allUsers}">
                                        <c:if test="${user.userId == task.assignedTo}">
                                            <small class="text-muted">
                                                <i class="bi bi-person me-1"></i>${user.firstName} ${user.lastName}
                                            </small>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${task.dueDate != null}">
                                        <small class="text-muted due-label" data-due="${task.dueDate}" data-status="${task.status}">
                                            ${fn:substring(task.dueDate, 8, 10)}/${fn:substring(task.dueDate, 5, 7)}
                                        </small>
                                    </c:if>
                                </div>
                                <c:if test="${fn:contains(task.description, '[DEPS:')}">
                                    <small class="text-warning"><i class="bi bi-lock me-1"></i>Có phụ thuộc</small>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>

        <!-- IN_PROGRESS -->
        <div class="col-md-4">
            <div class="card h-100">
                <div class="card-header bg-info text-white d-flex justify-content-between align-items-center">
                    <span><i class="bi bi-hourglass-split me-2"></i>Đang thực hiện</span>
                    <span class="badge bg-white text-info" id="count-IN_PROGRESS">${fn:length(inProgressTasks)}</span>
                </div>
                <div class="card-body p-2 kanban-column" id="col-IN_PROGRESS"
                     data-status="IN_PROGRESS" style="min-height: 400px; overflow-y: auto;">
                    <c:forEach var="task" items="${inProgressTasks}">
                        <div class="kanban-card card mb-2 shadow-sm"
                             draggable="true"
                             data-task-id="${task.taskId}"
                             data-status="IN_PROGRESS"
                             data-due="${task.dueDate}"
                             data-deps="${fn:contains(task.description, '[DEPS:')}">
                            <div class="card-body p-2">
                                <div class="d-flex justify-content-between align-items-start mb-1">
                                    <a href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}"
                                       class="text-decoration-none text-dark fw-medium small" style="max-width: 80%;">
                                        <c:if test="${fn:contains(task.title, '[R-')}">
                                            <i class="bi bi-arrow-repeat text-info" title="Lặp lại"></i>
                                        </c:if>
                                        ${task.title}
                                    </a>
                                    <c:choose>
                                        <c:when test="${task.priority == 'HIGH'}">
                                            <span class="badge bg-danger" style="font-size:0.6rem;">CAO</span>
                                        </c:when>
                                        <c:when test="${task.priority == 'MEDIUM'}">
                                            <span class="badge bg-warning text-dark" style="font-size:0.6rem;">TB</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary" style="font-size:0.6rem;">THẤP</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="d-flex justify-content-between align-items-center">
                                    <c:forEach var="user" items="${allUsers}">
                                        <c:if test="${user.userId == task.assignedTo}">
                                            <small class="text-muted">
                                                <i class="bi bi-person me-1"></i>${user.firstName} ${user.lastName}
                                            </small>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${task.dueDate != null}">
                                        <small class="text-muted due-label" data-due="${task.dueDate}" data-status="${task.status}">
                                            ${fn:substring(task.dueDate, 8, 10)}/${fn:substring(task.dueDate, 5, 7)}
                                        </small>
                                    </c:if>
                                </div>
                                <c:if test="${fn:contains(task.description, '[DEPS:')}">
                                    <small class="text-warning"><i class="bi bi-lock me-1"></i>Có phụ thuộc</small>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>

        <!-- COMPLETED -->
        <div class="col-md-4">
            <div class="card h-100">
                <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
                    <span><i class="bi bi-check-circle me-2"></i>Hoàn thành</span>
                    <span class="badge bg-white text-success" id="count-COMPLETED">${fn:length(completedTasks)}</span>
                </div>
                <div class="card-body p-2 kanban-column" id="col-COMPLETED"
                     data-status="COMPLETED" style="min-height: 400px; overflow-y: auto;">
                    <c:forEach var="task" items="${completedTasks}">
                        <div class="kanban-card card mb-2 shadow-sm opacity-75"
                             draggable="false"
                             data-task-id="${task.taskId}"
                             data-status="COMPLETED">
                            <div class="card-body p-2">
                                <div class="d-flex justify-content-between align-items-start mb-1">
                                    <a href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}"
                                       class="text-decoration-none text-muted small" style="max-width: 80%;">
                                        <i class="bi bi-check2 text-success me-1"></i>${task.title}
                                    </a>
                                    <c:choose>
                                        <c:when test="${task.priority == 'HIGH'}">
                                            <span class="badge bg-danger" style="font-size:0.6rem;">CAO</span>
                                        </c:when>
                                        <c:when test="${task.priority == 'MEDIUM'}">
                                            <span class="badge bg-warning text-dark" style="font-size:0.6rem;">TB</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary" style="font-size:0.6rem;">THẤP</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <c:forEach var="user" items="${allUsers}">
                                    <c:if test="${user.userId == task.assignedTo}">
                                        <small class="text-muted">
                                            <i class="bi bi-person me-1"></i>${user.firstName} ${user.lastName}
                                        </small>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>

    </div>
</div>

<style>
    .kanban-card { cursor: grab; transition: transform 0.1s, box-shadow 0.1s; }
    .kanban-card:active { cursor: grabbing; }
    .kanban-card.dragging { opacity: 0.5; transform: rotate(2deg); }
    .kanban-column.drag-over { background-color: rgba(0, 128, 0, 0.05); border: 2px dashed #198754; border-radius: 8px; }
</style>

<script>
(function () {
    'use strict';

    var ctxPath = '${pageContext.request.contextPath}';
    var ajaxUrl = ctxPath + '/manager/task/ajax/status';
    var dragged  = null;

    function showToast(msg, ok) {
        var t = document.getElementById('kanbanToast');
        var m = document.getElementById('kanbanToastMsg');
        t.classList.remove('bg-success', 'bg-danger');
        t.classList.add(ok ? 'bg-success' : 'bg-danger');
        m.textContent = msg;
        var toast = new bootstrap.Toast(t, { delay: 3000 });
        toast.show();
    }

    function updateCount(colId) {
        var col = document.getElementById('col-' + colId);
        var cnt = document.getElementById('count-' + colId);
        if (col && cnt) cnt.textContent = col.querySelectorAll('.kanban-card').length;
    }

    // Overdue labels
    var today = new Date(); today.setHours(0,0,0,0);
    document.querySelectorAll('.due-label').forEach(function(el) {
        var dueStr = el.getAttribute('data-due');
        var status = el.getAttribute('data-status');
        if (!dueStr) return;
        var due = new Date(dueStr.substring(0, 10));
        if (due < today && status !== 'COMPLETED' && status !== 'CANCELLED') {
            el.classList.add('text-danger', 'fw-bold');
        }
    });

    // Drag & Drop
    document.querySelectorAll('.kanban-card[draggable="true"]').forEach(function(card) {
        card.addEventListener('dragstart', function(e) {
            dragged = card;
            card.classList.add('dragging');
            e.dataTransfer.effectAllowed = 'move';
            e.dataTransfer.setData('text/plain', card.getAttribute('data-task-id'));
        });
        card.addEventListener('dragend', function() {
            card.classList.remove('dragging');
        });
    });

    document.querySelectorAll('.kanban-column').forEach(function(col) {
        col.addEventListener('dragover', function(e) {
            e.preventDefault();
            col.classList.add('drag-over');
        });
        col.addEventListener('dragleave', function() {
            col.classList.remove('drag-over');
        });
        col.addEventListener('drop', function(e) {
            e.preventDefault();
            col.classList.remove('drag-over');

            if (!dragged) return;
            var taskId   = dragged.getAttribute('data-task-id');
            var fromStatus = dragged.getAttribute('data-status');
            var toStatus   = col.getAttribute('data-status');

            if (fromStatus === toStatus) return;

            // COMPLETED column is drop-only (no drag out from COMPLETED)
            if (fromStatus === 'COMPLETED') {
                showToast('Không thể thay đổi trạng thái công việc đã hoàn thành', false);
                return;
            }

            // AJAX call
            var fd = new FormData();
            fd.append('taskId',    taskId);
            fd.append('newStatus', toStatus);

            fetch(ajaxUrl, { method: 'POST', body: fd })
                .then(function(r) { return r.json(); })
                .then(function(data) {
                    if (data.success) {
                        // Move card to target column
                        dragged.setAttribute('data-status', toStatus);
                        if (toStatus === 'COMPLETED') {
                            dragged.setAttribute('draggable', 'false');
                            dragged.classList.add('opacity-75');
                        }
                        col.appendChild(dragged);
                        updateCount(fromStatus);
                        updateCount(toStatus);
                        showToast('Cập nhật trạng thái thành công', true);
                    } else {
                        showToast(data.message || 'Cập nhật thất bại', false);
                    }
                    dragged = null;
                })
                .catch(function() {
                    showToast('Lỗi kết nối — vui lòng thử lại', false);
                    dragged = null;
                });
        });
    });
})();
</script>
