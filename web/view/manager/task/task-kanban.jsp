<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<style>
    /* ===== Kanban (match Sale UI) ===== */
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
    .kb-board::-webkit-scrollbar {
        height: 6px;
    }
    .kb-board::-webkit-scrollbar-thumb {
        background: #c1c7d0;
        border-radius: 3px;
    }
    .kb-col {
        background: #f4f5f7;
        border-radius: 6px;
        display: flex;
        flex-direction: column;
        min-width: 0;
        flex: 1 1 0;
        max-height: calc(100vh - 340px);
    }
    .kb-col-head {
        padding: 10px 10px 8px;
        flex-shrink: 0;
    }
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
    .kb-col-dot {
        width: 8px;
        height: 8px;
        border-radius: 50%;
        flex-shrink: 0;
    }
    .kb-dot-progress { background: #36b37e; }
    .kb-dot-completed { background: #0052cc; }
    .kb-dot-cancelled { background: #ff5630; }

    .kb-cards {
        padding: 0 6px 6px;
        flex: 1;
        overflow-y: auto;
        min-height: 80px;
    }
    .kb-cards::-webkit-scrollbar {
        width: 4px;
    }
    .kb-cards::-webkit-scrollbar-thumb {
        background: #c1c7d0;
        border-radius: 2px;
    }

    .kb-card {
        background: #fff;
        border-radius: 4px;
        padding: 8px 10px;
        margin-bottom: 6px;
        box-shadow: 0 1px 1px rgba(9,30,66,.13), 0 0 1px rgba(9,30,66,.2);
        transition: background .12s, box-shadow .12s;
    }
    .kb-card:hover {
        background: #ebecf0;
        box-shadow: 0 2px 4px rgba(9,30,66,.18), 0 0 1px rgba(9,30,66,.2);
        text-decoration: none;
    }
    a.kb-card { color: inherit; text-decoration: none; display: block; cursor: pointer; }
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
    .kb-card-title a {
        color: inherit;
        text-decoration: none;
    }
    .kb-card-title a:hover {
        color: #0052cc;
    }
    .kb-card-code {
        font-size: .65rem;
        color: #8993a4;
    }
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

    .kb-priority-dot {
        width: 6px;
        height: 6px;
        border-radius: 50%;
        display: inline-block;
    }
    .kb-priority-high { background: #ff5630; }
    .kb-priority-med  { background: #ffab00; }
    .kb-priority-low  { background: #36b37e; }

    .kb-empty {
        text-align: center;
        padding: 20px 10px;
        color: #b3bac5;
        font-size: .75rem;
    }
</style>

<div class="container-fluid">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h3 class="mb-1"><i class="bi bi-kanban me-2"></i>Kanban Công việc</h3>
            <p class="text-muted mb-0">Chế độ xem theo trạng thái (chỉ xem chi tiết)</p>
        </div>
        <a href="${pageContext.request.contextPath}/manager/task/list" class="btn btn-outline-secondary">
            <i class="bi bi-list-task me-2"></i>Danh sách công việc
        </a>
    </div>

    <!-- Tabs -->
    <ul class="nav nav-tabs mb-3">
        <li class="nav-item">
            <a class="nav-link ${empty viewType || viewType == 'personal' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/manager/task/kanban?view=personal&relatedType=${relatedType}&employee=${employeeFilter}&keyword=${keyword}">
                <i class="bi bi-person me-1"></i>Công việc cá nhân
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${viewType == 'group' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/manager/task/kanban?view=group&relatedType=${relatedType}&employee=${employeeFilter}&keyword=${keyword}">
                <i class="bi bi-people me-1"></i>Công việc nhóm
            </a>
        </li>
    </ul>

    <!-- Filters -->
    <div class="kb-toolbar">
        <form method="get" action="${pageContext.request.contextPath}/manager/task/kanban" class="row g-2 align-items-end">
            <input type="hidden" name="view" value="${empty viewType ? 'personal' : viewType}">
            <div class="col-md-3">
                <select class="form-select form-select-sm" name="employee">
                    <option value="">Tất cả nhân viên</option>
                    <c:forEach var="member" items="${deptMembers}">
                        <option value="${member.userId}" ${employeeFilter == member.userId ? 'selected' : ''}>
                            ${member.firstName} ${member.lastName}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-3">
                <select class="form-select form-select-sm" name="relatedType">
                    <option value="">Tất cả đối tượng</option>
                    <option value="LEAD" ${relatedType == 'LEAD' ? 'selected' : ''}>Lead</option>
                    <option value="CUSTOMER" ${relatedType == 'CUSTOMER' ? 'selected' : ''}>Customer</option>
                </select>
            </div>
            <div class="col-md-4">
                <input type="text" class="form-control form-control-sm" name="keyword" value="${keyword}" placeholder="Tìm tiêu đề...">
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-sm btn-primary">
                    <i class="bi bi-search me-1"></i>Lọc
                </button>
            </div>
        </form>
    </div>

    <!-- Board -->
    <div class="kb-board">
        <!-- IN_PROGRESS (includes PENDING) -->
        <div class="kb-col">
            <div class="kb-col-head">
                <div class="kb-col-title">
                    <span class="kb-col-dot kb-dot-progress"></span>
                    Đang thực hiện
                    <span class="kb-col-count">${fn:length(inProgressTasks)}</span>
                </div>
            </div>
            <div class="kb-cards">
                <c:choose>
                    <c:when test="${empty inProgressTasks}">
                        <div class="kb-empty">Không có công việc</div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="task" items="${inProgressTasks}">
                            <a class="kb-card" href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}">
                                <div class="kb-card-title">${task.title}</div>
                                <div class="kb-card-code">
                                    ${task.taskCode}
                                    <c:if test="${not empty task.relatedType}">
                                        &nbsp;· ${task.relatedType}
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
                                            <div class="kb-card-avatar" title="Nhóm">
                                                <i class="bi bi-people"></i>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="user" items="${allUsers}">
                                                <c:if test="${user.userId == task.assignedTo}">
                                                    <div class="kb-card-avatar" title="${user.firstName} ${user.lastName}">
                                                        ${fn:substring(user.firstName,0,1)}${fn:substring(user.lastName,0,1)}
                                                    </div>
                                                </c:if>
                                            </c:forEach>
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
        <div class="kb-col">
            <div class="kb-col-head">
                <div class="kb-col-title">
                    <span class="kb-col-dot kb-dot-completed"></span>
                    Hoàn thành
                    <span class="kb-col-count">${fn:length(completedTasks)}</span>
                </div>
            </div>
            <div class="kb-cards">
                <c:choose>
                    <c:when test="${empty completedTasks}">
                        <div class="kb-empty">Không có công việc</div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="task" items="${completedTasks}">
                            <a class="kb-card" href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}" style="opacity:.85;">
                                <div class="kb-card-title">
                                    <i class="bi bi-check2 text-success me-1"></i>${task.title}
                                </div>
                                <div class="kb-card-code">
                                    ${task.taskCode}
                                    <c:if test="${not empty task.relatedType}">
                                        &nbsp;· ${task.relatedType}
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
                                            <div class="kb-card-avatar" title="Nhóm">
                                                <i class="bi bi-people"></i>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="user" items="${allUsers}">
                                                <c:if test="${user.userId == task.assignedTo}">
                                                    <div class="kb-card-avatar" title="${user.firstName} ${user.lastName}">
                                                        ${fn:substring(user.firstName,0,1)}${fn:substring(user.lastName,0,1)}
                                                    </div>
                                                </c:if>
                                            </c:forEach>
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
        <div class="kb-col">
            <div class="kb-col-head">
                <div class="kb-col-title">
                    <span class="kb-col-dot kb-dot-cancelled"></span>
                    Đã hủy
                    <span class="kb-col-count">${fn:length(cancelledTasks)}</span>
                </div>
            </div>
            <div class="kb-cards">
                <c:choose>
                    <c:when test="${empty cancelledTasks}">
                        <div class="kb-empty">Không có công việc</div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="task" items="${cancelledTasks}">
                            <a class="kb-card" href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}" style="opacity:.7;">
                                <div class="kb-card-title">
                                    <i class="bi bi-x-circle text-danger me-1"></i>${task.title}
                                </div>
                                <div class="kb-card-code">
                                    ${task.taskCode}
                                    <c:if test="${not empty task.relatedType}">
                                        &nbsp;· ${task.relatedType}
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
                                            <div class="kb-card-avatar" title="Nhóm">
                                                <i class="bi bi-people"></i>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="user" items="${allUsers}">
                                                <c:if test="${user.userId == task.assignedTo}">
                                                    <div class="kb-card-avatar" title="${user.firstName} ${user.lastName}">
                                                        ${fn:substring(user.firstName,0,1)}${fn:substring(user.lastName,0,1)}
                                                    </div>
                                                </c:if>
                                            </c:forEach>
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
