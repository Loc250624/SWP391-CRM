<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<style>
    /* ===== Kanban (match Manager UI) ===== */
    .kb-toolbar {
        background: #fff;
        border-radius: 8px;
        padding: 10px 16px;
        margin-bottom: 16px;
        box-shadow: 0 1px 3px rgba(0,0,0,.06);
    }
    .kb-board {
        display: flex;
        gap: 8px;
        overflow-x: auto;
        padding-bottom: 8px;
        align-items: flex-start;
    }
    .kb-board::-webkit-scrollbar { height: 6px; }
    .kb-board::-webkit-scrollbar-thumb { background: #c1c7d0; border-radius: 3px; }

    .kb-col {
        background: #f4f5f7;
        border-radius: 6px;
        display: flex;
        flex-direction: column;
        min-width: 0;
        flex: 1 1 0;
        max-height: calc(100vh - 340px);
    }
    .kb-col-head { padding: 10px 10px 8px; flex-shrink: 0; }
    .kb-col-title {
        font-size: .75rem;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: .4px;
        color: #5e6c84;
        display: flex;
        align-items: center;
        gap: 6px;
    }
    .kb-col-count {
        background: #dfe1e6;
        color: #44546f;
        border-radius: 10px;
        font-size: .65rem;
        font-weight: 700;
        padding: 1px 7px;
        min-width: 20px;
        text-align: center;
    }
    .kb-col-dot { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0; }
    .kb-dot-progress { background: #36b37e; }
    .kb-dot-completed { background: #0052cc; }
    .kb-dot-cancelled { background: #ff5630; }

    .kb-cards {
        padding: 0 6px 6px;
        flex: 1;
        overflow-y: auto;
        min-height: 80px;
    }
    .kb-cards::-webkit-scrollbar { width: 4px; }
    .kb-cards::-webkit-scrollbar-thumb { background: #c1c7d0; border-radius: 2px; }

    .kb-card {
        background: #fff;
        border-radius: 4px;
        padding: 8px 10px;
        margin-bottom: 6px;
        box-shadow: 0 1px 1px rgba(9,30,66,.13), 0 0 1px rgba(9,30,66,.2);
        transition: background .12s, box-shadow .12s;
        cursor: grab;
    }
    .kb-card:active { cursor: grabbing; }
    .kb-card:hover {
        background: #ebecf0;
        box-shadow: 0 2px 4px rgba(9,30,66,.18), 0 0 1px rgba(9,30,66,.2);
        text-decoration: none;
    }
    a.kb-card { color: inherit; text-decoration: none; display: block; cursor: pointer; }
    .kb-card.dragging { opacity: .5; transform: rotate(2deg); }
    .kb-col.drag-over { background-color: rgba(0, 82, 204, 0.06); border: 2px dashed #0052cc; }

    .kb-card-title {
        font-size: .8rem;
        font-weight: 500;
        color: #172b4d;
        line-height: 1.3;
        margin-bottom: 4px;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }
    .kb-card-title a { color: inherit; text-decoration: none; }
    .kb-card-title a:hover { color: #0052cc; }
    .kb-card-code { font-size: .65rem; color: #8993a4; }
    .kb-card-footer {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-top: 6px;
    }
    .kb-card-meta {
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: .65rem;
        color: #8993a4;
    }
    .kb-card-avatar {
        width: 22px;
        height: 22px;
        border-radius: 50%;
        background: #dfe1e6;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: .6rem;
        font-weight: 700;
        color: #44546f;
    }

    .kb-priority-dot { width: 6px; height: 6px; border-radius: 50%; display: inline-block; }
    .kb-priority-high { background: #ff5630; }
    .kb-priority-med  { background: #ffab00; }
    .kb-priority-low  { background: #36b37e; }

    .kb-empty { text-align: center; padding: 20px 10px; color: #b3bac5; font-size: .75rem; }
</style>

<div class="container-fluid">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h3 class="mb-1"><i class="bi bi-kanban me-2"></i>Kanban Công việc</h3>
            <p class="text-muted mb-0">Kéo thả để cập nhật trạng thái</p>
        </div>
        <a href="${pageContext.request.contextPath}/sale/task/calendar" class="btn btn-outline-primary">
            <i class="bi bi-calendar3 me-2"></i>Xem lịch
        </a>
    </div>

    <!-- Tabs -->
    <ul class="nav nav-tabs mb-3">
        <li class="nav-item">
            <a class="nav-link ${empty viewType || viewType == 'personal' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/sale/task/list?view=personal&relatedType=${relatedType}&keyword=${keyword}">
                <i class="bi bi-person me-1"></i>Công việc cá nhân
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${viewType == 'group' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/sale/task/list?view=group&relatedType=${relatedType}&keyword=${keyword}">
                <i class="bi bi-people me-1"></i>Công việc nhóm
            </a>
        </li>
    </ul>

    <!-- Filters -->
    <div class="kb-toolbar">
        <form method="get" action="${pageContext.request.contextPath}/sale/task/list" class="row g-2 align-items-end">
            <input type="hidden" name="view" value="${empty viewType ? 'personal' : viewType}">
            <div class="col-md-3">
                <select class="form-select form-select-sm" name="relatedType">
                    <option value="">Tất cả đối tượng</option>
                    <option value="LEAD" ${relatedType == 'LEAD' ? 'selected' : ''}>Lead</option>
                    <option value="CUSTOMER" ${relatedType == 'CUSTOMER' ? 'selected' : ''}>Customer</option>
                </select>
            </div>
            <div class="col-md-5">
                <input type="text" class="form-control form-control-sm" name="keyword" value="${keyword}" placeholder="Tìm tiêu đề...">
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-sm btn-primary">
                    <i class="bi bi-search me-1"></i>Lọc
                </button>
            </div>
        </form>
    </div>

    <!-- Toast -->
    <div class="position-fixed bottom-0 end-0 p-3" style="z-index: 2000;">
        <div id="saleKanbanToast" class="toast align-items-center text-white" role="alert">
            <div class="d-flex">
                <div class="toast-body" id="saleKanbanToastMsg"></div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
    </div>

    <!-- Board -->
    <div class="kb-board">
        <!-- IN_PROGRESS (includes PENDING) -->
        <div class="kb-col" data-status="IN_PROGRESS">
            <div class="kb-col-head">
                <div class="kb-col-title">
                    <span class="kb-col-dot kb-dot-progress"></span>
                    Đang thực hiện
                    <span class="kb-col-count" id="count-IN_PROGRESS">${fn:length(inProgressTasks)}</span>
                </div>
            </div>
            <div class="kb-cards" data-status="IN_PROGRESS">
                <c:choose>
                    <c:when test="${empty inProgressTasks}">
                        <div class="kb-empty">Không có công việc</div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="task" items="${inProgressTasks}">
                            <a class="kb-card" draggable="true" data-task-id="${task.taskId}" data-status="IN_PROGRESS"
                               href="${pageContext.request.contextPath}/sale/task/detail?id=${task.taskId}">
                                <div class="kb-card-title">${task.title}</div>
                                <div class="kb-card-code">
                                    ${task.taskCode}
                                    <c:if test="${not empty task.relatedType}">
                                        <c:set var="relKey" value="${task.relatedType}:${task.relatedId}" />
                                        <c:choose>
                                            <c:when test="${not empty relatedObjectMap[relKey]}">
                                                &nbsp;· ${task.relatedType == 'LEAD' ? 'Lead' : 'Customer'}: ${relatedObjectMap[relKey]}
                                            </c:when>
                                            <c:otherwise>
                                                &nbsp;· ${task.relatedType}
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                    <c:if test="${task.groupTaskId != null}">
                                        &nbsp;· Nhóm
                                    </c:if>
                                </div>
                                <div class="kb-card-footer">
                                    <div class="kb-card-meta">
                                        <c:choose>
                                            <c:when test="${task.priorityName == 'HIGH'}"><span class="kb-priority-dot kb-priority-high"></span></c:when>
                                            <c:when test="${task.priorityName == 'MEDIUM'}"><span class="kb-priority-dot kb-priority-med"></span></c:when>
                                            <c:otherwise><span class="kb-priority-dot kb-priority-low"></span></c:otherwise>
                                        </c:choose>
                                        <c:if test="${task.dueDate != null}">
                                            <span><i class="bi bi-calendar3"></i> ${fn:substring(task.dueDate, 8, 10)}/${fn:substring(task.dueDate, 5, 7)}</span>
                                        </c:if>
                                    </div>
                                    <c:choose>
                                        <c:when test="${task.groupTaskId != null}">
                                            <div class="kb-card-avatar" title="Nhóm"><i class="bi bi-people"></i></div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="kb-card-avatar" title="${currentUser.firstName} ${currentUser.lastName}">
                                                ${fn:substring(currentUser.firstName,0,1)}${fn:substring(currentUser.lastName,0,1)}
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </a>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- COMPLETED -->
        <div class="kb-col" data-status="COMPLETED">
            <div class="kb-col-head">
                <div class="kb-col-title">
                    <span class="kb-col-dot kb-dot-completed"></span>
                    Hoàn thành
                    <span class="kb-col-count" id="count-COMPLETED">${fn:length(completedTasks)}</span>
                </div>
            </div>
            <div class="kb-cards" data-status="COMPLETED">
                <c:choose>
                    <c:when test="${empty completedTasks}">
                        <div class="kb-empty">Không có công việc</div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="task" items="${completedTasks}">
                            <a class="kb-card" draggable="false" data-task-id="${task.taskId}" data-status="COMPLETED" style="opacity:.85;"
                               href="${pageContext.request.contextPath}/sale/task/detail?id=${task.taskId}">
                                <div class="kb-card-title">
                                    <i class="bi bi-check2 text-success me-1"></i>${task.title}
                                </div>
                                <div class="kb-card-code">
                                    ${task.taskCode}
                                    <c:if test="${not empty task.relatedType}">
                                        <c:set var="relKey" value="${task.relatedType}:${task.relatedId}" />
                                        <c:choose>
                                            <c:when test="${not empty relatedObjectMap[relKey]}">
                                                &nbsp;· ${task.relatedType == 'LEAD' ? 'Lead' : 'Customer'}: ${relatedObjectMap[relKey]}
                                            </c:when>
                                            <c:otherwise>
                                                &nbsp;· ${task.relatedType}
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                    <c:if test="${task.groupTaskId != null}">
                                        &nbsp;· Nhóm
                                    </c:if>
                                </div>
                                <div class="kb-card-footer">
                                    <div class="kb-card-meta">
                                        <c:choose>
                                            <c:when test="${task.priorityName == 'HIGH'}"><span class="kb-priority-dot kb-priority-high"></span></c:when>
                                            <c:when test="${task.priorityName == 'MEDIUM'}"><span class="kb-priority-dot kb-priority-med"></span></c:when>
                                            <c:otherwise><span class="kb-priority-dot kb-priority-low"></span></c:otherwise>
                                        </c:choose>
                                    </div>
                                    <c:choose>
                                        <c:when test="${task.groupTaskId != null}">
                                            <div class="kb-card-avatar" title="Nhóm"><i class="bi bi-people"></i></div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="kb-card-avatar" title="${currentUser.firstName} ${currentUser.lastName}">
                                                ${fn:substring(currentUser.firstName,0,1)}${fn:substring(currentUser.lastName,0,1)}
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </a>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- CANCELLED -->
        <div class="kb-col" data-status="CANCELLED">
            <div class="kb-col-head">
                <div class="kb-col-title">
                    <span class="kb-col-dot kb-dot-cancelled"></span>
                    Đã hủy
                    <span class="kb-col-count" id="count-CANCELLED">${fn:length(cancelledTasks)}</span>
                </div>
            </div>
            <div class="kb-cards" data-status="CANCELLED">
                <c:choose>
                    <c:when test="${empty cancelledTasks}">
                        <div class="kb-empty">Không có công việc</div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="task" items="${cancelledTasks}">
                            <a class="kb-card" draggable="false" data-task-id="${task.taskId}" data-status="CANCELLED" style="opacity:.7;"
                               href="${pageContext.request.contextPath}/sale/task/detail?id=${task.taskId}">
                                <div class="kb-card-title">
                                    <i class="bi bi-x-circle text-danger me-1"></i>${task.title}
                                </div>
                                <div class="kb-card-code">
                                    ${task.taskCode}
                                    <c:if test="${not empty task.relatedType}">
                                        <c:set var="relKey" value="${task.relatedType}:${task.relatedId}" />
                                        <c:choose>
                                            <c:when test="${not empty relatedObjectMap[relKey]}">
                                                &nbsp;· ${task.relatedType == 'LEAD' ? 'Lead' : 'Customer'}: ${relatedObjectMap[relKey]}
                                            </c:when>
                                            <c:otherwise>
                                                &nbsp;· ${task.relatedType}
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                    <c:if test="${task.groupTaskId != null}">
                                        &nbsp;· Nhóm
                                    </c:if>
                                </div>
                                <div class="kb-card-footer">
                                    <div class="kb-card-meta">
                                        <c:choose>
                                            <c:when test="${task.priorityName == 'HIGH'}"><span class="kb-priority-dot kb-priority-high"></span></c:when>
                                            <c:when test="${task.priorityName == 'MEDIUM'}"><span class="kb-priority-dot kb-priority-med"></span></c:when>
                                            <c:otherwise><span class="kb-priority-dot kb-priority-low"></span></c:otherwise>
                                        </c:choose>
                                    </div>
                                    <c:choose>
                                        <c:when test="${task.groupTaskId != null}">
                                            <div class="kb-card-avatar" title="Nhóm"><i class="bi bi-people"></i></div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="kb-card-avatar" title="${currentUser.firstName} ${currentUser.lastName}">
                                                ${fn:substring(currentUser.firstName,0,1)}${fn:substring(currentUser.lastName,0,1)}
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </a>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<script>
(function () {
    'use strict';
    var ctxPath = '${pageContext.request.contextPath}';
    var ajaxUrl = ctxPath + '/sale/task/ajax/status';
    var dragged = null;

    function showToast(msg, ok) {
        var t = document.getElementById('saleKanbanToast');
        var m = document.getElementById('saleKanbanToastMsg');
        t.classList.remove('bg-success', 'bg-danger');
        t.classList.add(ok ? 'bg-success' : 'bg-danger');
        m.textContent = msg;
        var toast = new bootstrap.Toast(t, { delay: 2500 });
        toast.show();
    }

    function updateCount(colId) {
        var col = document.querySelector('.kb-col[data-status="' + colId + '"] .kb-cards');
        var cnt = document.getElementById('count-' + colId);
        if (col && cnt) cnt.textContent = col.querySelectorAll('.kb-card').length;
    }

    var isDragging = false;

    document.querySelectorAll('.kb-card[draggable="true"]').forEach(function(card) {
        card.addEventListener('dragstart', function(e) {
            isDragging = true;
            dragged = card;
            card.classList.add('dragging');
            e.dataTransfer.effectAllowed = 'move';
            e.dataTransfer.setData('text/plain', card.getAttribute('data-task-id'));
        });
        card.addEventListener('dragend', function() {
            card.classList.remove('dragging');
            setTimeout(function() { isDragging = false; }, 100);
        });
        card.addEventListener('click', function(e) {
            if (isDragging) { e.preventDefault(); }
        });
    });

    document.querySelectorAll('.kb-col').forEach(function(col) {
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
            var taskId = dragged.getAttribute('data-task-id');
            var fromStatus = dragged.getAttribute('data-status');
            var toStatus = col.getAttribute('data-status') 
                || col.querySelector('.kb-cards')?.getAttribute('data-status')
                || (e.target && e.target.closest('.kb-col') ? e.target.closest('.kb-col').getAttribute('data-status') : '');

            if (fromStatus === toStatus) return;
            if (!toStatus) {
                showToast('Không xác định được trạng thái đích', false);
                return;
            }

            // Sale can only drag to COMPLETED
            if (toStatus !== 'COMPLETED') {
                showToast('Bạn chỉ có thể cập nhật sang Hoàn thành', false);
                return;
            }

            if (!confirm('Bạn có chắc chắn muốn đánh dấu công việc này là Hoàn thành?')) return;

            var fd = new URLSearchParams();
            fd.append('taskId', taskId);
            fd.append('newStatus', String(toStatus || ''));

            fetch(ajaxUrl, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
                body: fd.toString()
            })
                .then(function(r) { return r.json(); })
                .then(function(data) {
                    if (data.success) {
                        dragged.setAttribute('data-status', toStatus);
                        dragged.setAttribute('draggable', 'false');
                        dragged.style.opacity = '.85';
                        col.querySelector('.kb-cards').appendChild(dragged);
                        updateCount(fromStatus);
                        updateCount(toStatus);
                        showToast('Cập nhật trạng thái thành công', true);
                    } else {
                        showToast(data.message || 'Cập nhật thất bại', false);
                    }
                })
                .catch(function() { showToast('Lỗi kết nối máy chủ', false); });
        });
    });
})();
</script>
