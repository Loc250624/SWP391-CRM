<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="container-fluid">
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

    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <c:choose>
                <c:when test="${taskType == 'workload'}">
                    <h3 class="mb-1"><i class="bi bi-person-workspace me-2"></i>Công việc của ${workloadEmployee}</h3>
                    <p class="text-muted mb-0">Tất cả công việc được giao cho nhân viên này</p>
                </c:when>
                <c:otherwise>
                    <h3 class="mb-1"><i class="bi bi-list-task me-2"></i>Quản lý Công việc</h3>
                    <p class="text-muted mb-0">
                        <c:choose>
                            <c:when test="${taskType == 'team'}">Công việc nhóm đã giao cho nhân viên</c:when>
                            <c:otherwise>Công việc cá nhân (Lead & Khách hàng)</c:otherwise>
                        </c:choose>
                    </p>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="d-flex gap-2">
            <c:if test="${taskType == 'workload'}">
                <a href="${pageContext.request.contextPath}/manager/task/workload" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left me-1"></i>Quay lại Workload
                </a>
            </c:if>
            <a href="${pageContext.request.contextPath}/manager/task/form?action=create" class="btn btn-primary">
                <i class="bi bi-plus-circle me-2"></i>Tạo Công việc
            </a>
        </div>
    </div>

    <c:if test="${taskType != 'workload'}">
    <%-- Top-level: Personal / Team --%>
    <ul class="nav nav-pills mb-3">
        <li class="nav-item">
            <a class="nav-link ${taskType == 'personal' || empty taskType ? 'active' : ''}"
               href="${pageContext.request.contextPath}/manager/task/list?taskType=personal&view=${viewType}">
                <i class="bi bi-person me-1"></i>Công việc cá nhân
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${taskType == 'team' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/manager/task/list?taskType=team&view=${viewType}">
                <i class="bi bi-people me-1"></i>Công việc nhóm
            </a>
        </li>
    </ul>

    <%-- Sub-tabs: Lead / Customer --%>
    <ul class="nav nav-tabs mb-4">
        <li class="nav-item">
            <a class="nav-link ${viewType == 'lead' || empty viewType ? 'active' : ''}"
               href="${pageContext.request.contextPath}/manager/task/list?taskType=${taskType}&view=lead">
                <i class="bi bi-person-lines-fill me-2"></i>Lead
                <span class="badge bg-primary ms-1">${leadCount}</span>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${viewType == 'customer' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/manager/task/list?taskType=${taskType}&view=customer">
                <i class="bi bi-people-fill me-2"></i>Customer
                <span class="badge bg-success ms-1">${customerCount}</span>
            </a>
        </li>
    </ul>
    </c:if>

    <!-- Filters -->
    <div class="card mb-4">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/manager/task/list" class="row g-3">
                <c:choose>
                    <c:when test="${taskType == 'workload'}">
                        <input type="hidden" name="source" value="workload">
                        <input type="hidden" name="employee" value="${workloadEmployeeId}">
                    </c:when>
                    <c:otherwise>
                        <input type="hidden" name="taskType" value="${taskType}">
                        <input type="hidden" name="view" value="${viewType}">
                    </c:otherwise>
                </c:choose>

                <div class="col-md-3">
                    <label class="form-label">Tìm kiếm</label>
                    <input type="text" class="form-control" name="keyword" value="${keyword}"
                           placeholder="Tìm theo tiêu đề...">
                </div>

                <div class="col-md-2">
                    <label class="form-label">Trạng thái</label>
                    <select class="form-select" name="status">
                        <option value="">Tất cả</option>
                        <%-- FIX: Use s.name() for value (consistent String comparison) --%>
                        <c:forEach var="s" items="${taskStatusValues}">
                            <option value="${s.name()}" ${statusFilter == s.name() ? 'selected' : ''}>
                                ${s.vietnamese}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-2">
                    <label class="form-label">Ưu tiên</label>
                    <select class="form-select" name="priority">
                        <option value="">Tất cả</option>
                        <%-- FIX: Use p.name() for value --%>
                        <c:forEach var="p" items="${priorityValues}">
                            <option value="${p.name()}" ${priorityFilter == p.name() ? 'selected' : ''}>
                                ${p.vietnamese}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <c:if test="${taskType == 'team'}">
                    <div class="col-md-3">
                        <label class="form-label">Nhân viên</label>
                        <select class="form-select" name="employee">
                            <option value="">Tất cả</option>
                            <c:forEach var="member" items="${teamMembers}">
                                <option value="${member.userId}"
                                        ${employeeFilter == member.userId ? 'selected' : ''}>
                                    ${member.firstName} ${member.lastName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </c:if>

                <div class="col-md-2 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="bi bi-search me-2"></i>Lọc
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Task List -->
    <div class="card">
        <div class="card-header bg-white">
            <div class="d-flex justify-content-between align-items-center">
                <h5 class="mb-0">Danh sách Công việc (${totalTasks})</h5>
                <c:if test="${taskType != 'workload'}">
                <%-- FIX: Sort URL now preserves all active filter params --%>
                <select class="form-select form-select-sm" style="width: auto;"
                        onchange="
                                var url = '${pageContext.request.contextPath}/manager/task/list'
                                        + '?taskType=${taskType}'
                                        + '&view=${viewType}'
                                        + '&sortBy=' + this.value
                                        + '&status=${statusFilter}'
                                        + '&priority=${priorityFilter}'
                                        + '&keyword=${keyword}'
                                        + '&employee=${employeeFilter}';
                                window.location.href = url;">
                    <option value="due_date"   ${sortBy == 'due_date'   ? 'selected' : ''}>Sắp xếp: Hạn chót</option>
                    <option value="priority"   ${sortBy == 'priority'   ? 'selected' : ''}>Sắp xếp: Ưu tiên</option>
                    <option value="created_at" ${sortBy == 'created_at' ? 'selected' : ''}>Sắp xếp: Ngày tạo</option>
                </select>
                </c:if>
            </div>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Mã</th>
                            <th>Tiêu đề</th>
                            <th>Đối tượng</th>
                            <th>Người thực hiện</th>
                            <th>Hạn chót</th>
                            <th>Ưu tiên</th>
                            <th>Trạng thái</th>
                            <th class="text-end">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty taskList}">
                                <tr>
                                    <td colspan="8" class="text-center py-5">
                                        <i class="bi bi-inbox text-muted" style="font-size: 3rem;"></i>
                                        <p class="text-muted mt-3">Không có công việc nào</p>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="task" items="${taskList}">
                                    <%-- Determine if this row is a group summary task --%>
                                    <c:set var="isGroupSummary" value="${task.groupTaskId != null && task.groupTaskId == task.taskId}" />
                                    <c:set var="groupMembers"   value="${groupMembersMap[task.taskId]}" />

                                    <c:choose>
                                        <%-- ════ GROUP SUMMARY ROW ════ --%>
                                        <c:when test="${isGroupSummary}">
                                            <c:set var="memberCount" value="${groupMembers != null ? fn:length(groupMembers) : 0}" />
                                            <tr class="table-group-row clickable-row" data-href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}">
                                                <td>
                                                    <span class="badge bg-secondary">${task.taskCode}</span>
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center gap-2">
                                                        <a href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}"
                                                           class="text-decoration-none fw-medium">${task.title}</a>
                                                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle">
                                                            <i class="bi bi-people-fill me-1"></i>Nhóm · ${memberCount} người
                                                        </span>
                                                    </div>
                                                    <%-- Avatar stack (first 3 members) --%>
                                                    <div class="avatar-stack mt-1">
                                                        <c:forEach var="m" items="${groupMembers}" varStatus="ms">
                                                            <c:if test="${ms.index < 3}">
                                                                <c:forEach var="u" items="${allUsers}">
                                                                    <c:if test="${u.userId == m.assignedTo}">
                                                                        <span class="avatar-xs bg-secondary rounded-circle d-inline-flex align-items-center justify-content-center text-white"
                                                                              title="${u.firstName} ${u.lastName}">
                                                                            ${fn:substring(u.firstName,0,1)}${fn:substring(u.lastName,0,1)}
                                                                        </span>
                                                                    </c:if>
                                                                </c:forEach>
                                                            </c:if>
                                                        </c:forEach>
                                                        <c:if test="${memberCount > 3}">
                                                            <span class="avatar-xs bg-light text-muted rounded-circle d-inline-flex align-items-center justify-content-center border">
                                                                +${memberCount - 3}
                                                            </span>
                                                        </c:if>
                                                    </div>
                                                </td>
                                                <%-- Related object --%>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty task.relatedType && task.relatedId != null}">
                                                            <c:set var="rKey">${task.relatedType}:${task.relatedId}</c:set>
                                                            <c:set var="rName" value="${relatedObjectMap[rKey]}"/>
                                                            <c:choose>
                                                                <c:when test="${task.relatedType == 'LEAD'}">
                                                                    <span class="badge bg-info text-dark me-1">Lead</span>
                                                                    <c:if test="${not empty rName}"><small>${rName}</small></c:if>
                                                                </c:when>
                                                                <c:when test="${task.relatedType == 'CUSTOMER'}">
                                                                    <span class="badge bg-success me-1">KH</span>
                                                                    <c:if test="${not empty rName}"><small>${rName}</small></c:if>
                                                                </c:when>
                                                                <c:otherwise><small class="text-muted">${task.relatedType}</small></c:otherwise>
                                                            </c:choose>
                                                        </c:when>
                                                        <c:otherwise><span class="text-muted small">—</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <%-- Assignee: show member count for group --%>
                                                <td><span class="text-muted small">${memberCount} thành viên</span></td>
                                                <%-- Due date --%>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${task.dueDate != null}">
                                                            <span data-due="${task.dueDate}" data-status="${task.statusName}">
                                                                ${fn:substring(task.dueDate,8,10)}/${fn:substring(task.dueDate,5,7)}/${fn:substring(task.dueDate,0,4)}
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <%-- Priority --%>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${task.priorityName == 'HIGH'}"><span class="badge bg-danger">Cao</span></c:when>
                                                        <c:when test="${task.priorityName == 'MEDIUM'}"><span class="badge bg-warning text-dark">Trung bình</span></c:when>
                                                        <c:otherwise><span class="badge bg-secondary">Thấp</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <%-- Status --%>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${task.statusName == 'COMPLETED'}"><span class="badge bg-success">Hoàn thành</span></c:when>
                                                        <c:when test="${task.statusName == 'IN_PROGRESS'}"><span class="badge bg-info">Đang thực hiện</span></c:when>
                                                        <c:when test="${task.statusName == 'CANCELLED'}"><span class="badge bg-dark">Đã hủy</span></c:when>
                                                        <c:otherwise><span class="badge bg-secondary">Chờ xử lý</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <%-- Actions --%>
                                                <td class="text-end">
                                                    <div class="btn-group" role="group">
                                                        <a href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}"
                                                           class="btn btn-sm btn-outline-primary" title="Xem chi tiết">
                                                            <i class="bi bi-eye"></i>
                                                        </a>
                                                        <button type="button" class="btn btn-sm btn-outline-secondary"
                                                                onclick="toggleGroupMembers(${task.taskId})"
                                                                title="Xem thành viên">
                                                            <i class="bi bi-chevron-down" id="icon-${task.taskId}"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                            <%-- Expanded member sub-table (hidden by default) --%>
                                            <tr id="group-members-${task.taskId}" class="d-none">
                                                <td colspan="8" class="p-0 bg-light">
                                                    <table class="table table-sm mb-0 ms-4">
                                                        <thead class="table-secondary">
                                                            <tr>
                                                                <th>Thành viên</th>
                                                                <th>Email</th>
                                                                <th>Trạng thái</th>
                                                                <th></th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach var="m" items="${groupMembers}">
                                                                <tr>
                                                                    <td>
                                                                        <c:forEach var="u" items="${allUsers}">
                                                                            <c:if test="${u.userId == m.assignedTo}">
                                                                                <div class="d-flex align-items-center gap-2">
                                                                                    <div class="avatar-xs bg-primary rounded-circle d-flex align-items-center justify-content-center text-white">
                                                                                        ${fn:substring(u.firstName,0,1)}${fn:substring(u.lastName,0,1)}
                                                                                    </div>
                                                                                    ${u.firstName} ${u.lastName}
                                                                                </div>
                                                                            </c:if>
                                                                        </c:forEach>
                                                                    </td>
                                                                    <td>
                                                                        <c:forEach var="u" items="${allUsers}">
                                                                            <c:if test="${u.userId == m.assignedTo}">
                                                                                <small class="text-muted">${u.email}</small>
                                                                            </c:if>
                                                                        </c:forEach>
                                                                    </td>
                                                                    <td>
                                                                        <c:choose>
                                                                            <c:when test="${m.statusName == 'COMPLETED'}"><span class="badge bg-success">Hoàn thành</span></c:when>
                                                                            <c:when test="${m.statusName == 'IN_PROGRESS'}"><span class="badge bg-info">Đang thực hiện</span></c:when>
                                                                            <c:when test="${m.statusName == 'CANCELLED'}"><span class="badge bg-dark">Đã hủy</span></c:when>
                                                                            <c:otherwise><span class="badge bg-secondary">Chờ xử lý</span></c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td>
                                                                        <a href="${pageContext.request.contextPath}/manager/task/detail?id=${m.taskId}"
                                                                           class="btn btn-xs btn-outline-primary btn-sm" title="Chi tiết">
                                                                            <i class="bi bi-eye"></i>
                                                                        </a>
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </td>
                                            </tr>
                                        </c:when>

                                        <%-- ════ INDIVIDUAL TASK ROW (unchanged) ════ --%>
                                        <c:otherwise>
                                            <tr class="clickable-row" data-href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}">
                                                <td>
                                                    <span class="badge bg-secondary">${task.taskCode}</span>
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}"
                                                       class="text-decoration-none fw-medium">
                                                        ${task.title}
                                                    </a>
                                                </td>
                                                <%-- Đối tượng liên quan (Lead / Customer) --%>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty task.relatedType && task.relatedId != null}">
                                                            <c:set var="rKey">${task.relatedType}:${task.relatedId}</c:set>
                                                            <c:set var="rName" value="${relatedObjectMap[rKey]}"/>
                                                            <c:choose>
                                                                <c:when test="${task.relatedType == 'LEAD'}">
                                                                    <span class="badge bg-info text-dark me-1">Lead</span>
                                                                    <c:choose>
                                                                        <c:when test="${not empty rName}">
                                                                            <a href="${pageContext.request.contextPath}/sale/lead/detail?id=${task.relatedId}"
                                                                               class="text-decoration-none small" target="_blank">${rName}</a>
                                                                        </c:when>
                                                                        <c:otherwise><small class="text-muted">#${task.relatedId}</small></c:otherwise>
                                                                    </c:choose>
                                                                </c:when>
                                                                <c:when test="${task.relatedType == 'CUSTOMER'}">
                                                                    <span class="badge bg-success me-1">KH</span>
                                                                    <c:choose>
                                                                        <c:when test="${not empty rName}">
                                                                            <a href="${pageContext.request.contextPath}/sale/customer/detail?id=${task.relatedId}"
                                                                               class="text-decoration-none small" target="_blank">${rName}</a>
                                                                        </c:when>
                                                                        <c:otherwise><small class="text-muted">#${task.relatedId}</small></c:otherwise>
                                                                    </c:choose>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <small class="text-muted">${task.relatedType}</small>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted small">—</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <%-- Find the assigned user from allUsers list --%>
                                                    <c:forEach var="user" items="${allUsers}">
                                                        <c:if test="${user.userId == task.assignedTo}">
                                                            <div class="d-flex align-items-center">
                                                                <div class="avatar-sm bg-primary rounded-circle d-flex align-items-center justify-content-center text-white me-2">
                                                                    <%-- FIX: use fn:substring which is null-safe --%>
                                                                    ${fn:substring(user.firstName, 0, 1)}${fn:substring(user.lastName, 0, 1)}
                                                                </div>
                                                                <div>
                                                                    <div class="fw-medium">${user.firstName} ${user.lastName}</div>
                                                                    <small class="text-muted">${user.email}</small>
                                                                </div>
                                                            </div>
                                                        </c:if>
                                                    </c:forEach>
                                                </td>
                                                <td>
                                                    <%-- FIX: Use fn:substring instead of fmt:formatDate
                                                         LocalDateTime.toString() = "YYYY-MM-DDTHH:mm:ss"
                                                         Overdue detection is done in JavaScript below. --%>
                                                    <c:choose>
                                                        <c:when test="${task.dueDate != null}">
                                                            <span data-due="${task.dueDate}"
                                                                  data-status="${task.statusName}">
                                                                ${fn:substring(task.dueDate, 8, 10)}/${fn:substring(task.dueDate, 5, 7)}/${fn:substring(task.dueDate, 0, 4)}
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Không xác định</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${task.priorityName == 'HIGH'}">
                                                            <span class="badge bg-danger">Cao</span>
                                                        </c:when>
                                                        <c:when test="${task.priorityName == 'MEDIUM'}">
                                                            <span class="badge bg-warning text-dark">Trung bình</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">Thấp</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
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
                                                </td>
                                                <td class="text-end">
                                                    <a href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}"
                                                       class="btn btn-sm btn-outline-primary" title="Chi tiết">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <div class="card-footer bg-white">
                <c:choose>
                    <c:when test="${taskType == 'workload'}">
                        <c:set var="pageBaseUrl" value="${pageContext.request.contextPath}/manager/task/list?source=workload&employee=${workloadEmployeeId}&status=${statusFilter}&priority=${priorityFilter}&keyword=${keyword}"/>
                    </c:when>
                    <c:otherwise>
                        <c:set var="pageBaseUrl" value="${pageContext.request.contextPath}/manager/task/list?taskType=${taskType}&view=${viewType}&status=${statusFilter}&priority=${priorityFilter}&keyword=${keyword}&employee=${employeeFilter}&sortBy=${sortBy}&sortOrder=${sortOrder}"/>
                    </c:otherwise>
                </c:choose>
                <nav>
                    <ul class="pagination justify-content-center mb-0">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageBaseUrl}&page=${currentPage - 1}">
                                <i class="bi bi-chevron-left"></i>
                            </a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <c:if test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="${pageBaseUrl}&page=${i}">
                                        ${i}
                                    </a>
                                </li>
                            </c:if>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageBaseUrl}&page=${currentPage + 1}">
                                <i class="bi bi-chevron-right"></i>
                            </a>
                        </li>
                    </ul>
                </nav>
                <p class="text-center text-muted small mb-0 mt-2">
                    Trang ${currentPage} / ${totalPages} - Tổng số ${totalTasks} công việc
                </p>
            </div>
        </c:if>
    </div>
</div>

<style>
    .avatar-sm {
        width: 32px;
        height: 32px;
        font-size: 0.75rem;
        font-weight: 600;
        flex-shrink: 0;
    }
    .avatar-xs {
        width: 24px;
        height: 24px;
        font-size: 0.65rem;
        font-weight: 600;
        flex-shrink: 0;
    }
    .avatar-stack .avatar-xs + .avatar-xs {
        margin-left: -6px;
    }
    .avatar-stack {
        display: flex;
        align-items: center;
    }
    .table-group-row {
        background-color: #f8f9ff;
    }
    tr.clickable-row { cursor: pointer; }
    tr.clickable-row:hover { background-color: #f0f4ff; }
</style>

<script>
    /* Toggle expand/collapse for group task member sub-table */
    function toggleGroupMembers(id) {
        var row = document.getElementById('group-members-' + id);
        var icon = document.getElementById('icon-' + id);
        row.classList.toggle('d-none');
        icon.classList.toggle('bi-chevron-down');
        icon.classList.toggle('bi-chevron-up');
    }

    <%-- Make entire row clickable --%>
    document.addEventListener('DOMContentLoaded', function () {
        document.querySelectorAll('tr.clickable-row').forEach(function (row) {
            row.addEventListener('click', function (e) {
                // Don't navigate if clicking a link, button, or input inside the row
                if (e.target.closest('a, button, input, .btn-group')) return;
                var href = row.getAttribute('data-href');
                if (href) window.location.href = href;
            });
        });
    });

    <%-- FIX: Overdue detection via JavaScript (EL cannot call LocalDateTime.isBefore(now())) --%>
    document.addEventListener('DOMContentLoaded', function () {
        var today = new Date();
        today.setHours(0, 0, 0, 0);

        document.querySelectorAll('[data-due]').forEach(function (el) {
            var dueStr = el.getAttribute('data-due');
            var status = el.getAttribute('data-status');
            if (!dueStr)
                return;
            var due = new Date(dueStr.substring(0, 10));
            if (due < today && status !== 'COMPLETED' && status !== 'CANCELLED') {
                el.insertAdjacentHTML('afterend', ' <span class="badge bg-danger">Quá hạn</span>');
            }
        });
    });
</script>
