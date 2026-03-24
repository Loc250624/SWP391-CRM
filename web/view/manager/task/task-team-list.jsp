<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="container-fluid">

    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="mb-1"><i class="bi bi-people me-2"></i>Công việc Nhóm</h3>
            <small class="text-muted">Tổng: <strong>${totalTasks}</strong> công việc</small>
        </div>
        <a href="${pageContext.request.contextPath}/manager/task/form?action=create"
           class="btn btn-success">
            <i class="bi bi-plus-circle me-2"></i>Tạo mới
        </a>
    </div>

    <!-- Messages -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show">
            <i class="bi bi-check-circle me-2"></i>${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show">
            <i class="bi bi-exclamation-triangle me-2"></i>${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <!-- Filters -->
    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/manager/task/team" id="filterForm">
                <div class="row g-2 align-items-end">
                    <!-- Employee filter -->
                    <div class="col-lg-2 col-md-3">
                        <label class="form-label small fw-semibold">Nhân viên</label>
                        <select class="form-select form-select-sm" name="employee">
                            <option value="">Tất cả</option>
                            <c:forEach var="member" items="${teamMembers}">
                                <option value="${member.userId}"
                                        ${employeeFilter == member.userId ? 'selected' : ''}>
                                    ${member.firstName} ${member.lastName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <!-- Status filter -->
                    <div class="col-lg-2 col-md-2">
                        <label class="form-label small fw-semibold">Trạng thái</label>
                        <select class="form-select form-select-sm" name="status">
                            <option value="">Tất cả</option>
                            <c:forEach var="s" items="${taskStatusValues}">
                                <option value="${s.name()}" ${statusFilter == s.name() ? 'selected' : ''}>${s.vietnamese}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <!-- Priority filter -->
                    <div class="col-lg-2 col-md-2">
                        <label class="form-label small fw-semibold">Ưu tiên</label>
                        <select class="form-select form-select-sm" name="priority">
                            <option value="">Tất cả</option>
                            <c:forEach var="p" items="${priorityValues}">
                                <option value="${p.name()}" ${priorityFilter == p.name() ? 'selected' : ''}>${p.vietnamese}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <!-- Overdue toggle -->
                    <div class="col-lg-1 col-md-2">
                        <label class="form-label small fw-semibold">Quá hạn</label>
                        <div class="form-check form-switch mt-1">
                            <input class="form-check-input" type="checkbox" id="overdueCheck"
                                   name="overdue" value="1" ${overdueOnly ? 'checked' : ''}>
                        </div>
                    </div>
                    <!-- Keyword -->
                    <div class="col-lg-3 col-md-3">
                        <label class="form-label small fw-semibold">Tìm kiếm</label>
                        <input type="text" class="form-control form-control-sm" name="keyword"
                               value="${fn:escapeXml(keyword)}" placeholder="Tìm tiêu đề...">
                    </div>
                    <!-- Sort -->
                    <div class="col-lg-1 col-md-2">
                        <label class="form-label small fw-semibold">Sắp xếp</label>
                        <select class="form-select form-select-sm" name="sortBy"
                                onchange="this.form.submit()">
                            <option value="due_date"   ${sortBy == 'due_date'   ? 'selected' : ''}>Hạn chót</option>
                            <option value="priority"   ${sortBy == 'priority'   ? 'selected' : ''}>Ưu tiên</option>
                            <option value="created_at" ${sortBy == 'created_at' ? 'selected' : ''}>Ngày tạo</option>
                        </select>
                    </div>
                    <!-- Buttons -->
                    <div class="col-lg-1 col-md-12">
                        <button type="submit" class="btn btn-primary btn-sm w-100">
                            <i class="bi bi-search"></i>
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Task Table -->
    <div class="card shadow-sm">
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${empty taskList}">
                    <div class="text-center py-5">
                        <i class="bi bi-inbox text-muted" style="font-size:3rem;"></i>
                        <p class="text-muted mt-2 mb-0">Không có công việc nào</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0" id="teamTaskTable">
                            <thead class="table-light">
                                <tr>
                                    <th>Mã</th>
                                    <th>Tiêu đề</th>
                                    <th>Nhân viên</th>
                                    <th>Trạng thái</th>
                                    <th>Ưu tiên</th>
                                    <th>Hạn chót</th>
                                    <th class="text-end">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="task" items="${taskList}">
                                    <tr data-due="${fn:substring(task.dueDate, 0, 10)}"
                                        data-status="${task.statusName}">
                                        <td><code class="small">${task.taskCode}</code></td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}"
                                               class="text-decoration-none fw-medium">
                                                <%-- Strip [R-*] prefix for display --%>
                                                <c:set var="taskTitle" value="${task.title}"/>
                                                <c:choose>
                                                    <c:when test="${fn:contains(taskTitle, '[R-')}">
                                                        <i class="bi bi-arrow-repeat text-info me-1" title="Lặp lại"></i>
                                                        ${fn:substringAfter(taskTitle, '] ')}
                                                    </c:when>
                                                    <c:otherwise>${taskTitle}</c:otherwise>
                                                </c:choose>
                                            </a>
                                            <span class="overdue-badge ms-1" style="display:none;">
                                                <span class="badge bg-danger">Quá hạn</span>
                                            </span>
                                        </td>
                                        <td>
                                            <%-- Resolve assignee name from allUsers --%>
                                            <c:forEach var="user" items="${allUsers}">
                                                <c:if test="${user.userId == task.assignedTo}">
                                                    <div class="d-flex align-items-center">
                                                        <div class="rounded-circle bg-secondary d-flex align-items-center justify-content-center text-white me-2"
                                                             style="width:28px;height:28px;font-size:0.75rem;font-weight:600;flex-shrink:0;">
                                                            ${fn:substring(user.firstName, 0, 1)}${fn:substring(user.lastName, 0, 1)}
                                                        </div>
                                                        <span class="small">${user.firstName} ${user.lastName}</span>
                                                    </div>
                                                </c:if>
                                            </c:forEach>
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
                                            <span class="due-date-text small">
                                                <c:choose>
                                                    <c:when test="${task.dueDate != null}">
                                                        ${fn:substring(task.dueDate, 8, 10)}/${fn:substring(task.dueDate, 5, 7)}/${fn:substring(task.dueDate, 0, 4)}
                                                    </c:when>
                                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td class="text-end">
                                            <div class="btn-group btn-group-sm">
                                                <a href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}"
                                                   class="btn btn-outline-secondary" title="Chi tiết">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/manager/task/status?id=${task.taskId}"
                                                   class="btn btn-outline-primary" title="Cập nhật">
                                                    <i class="bi bi-arrow-repeat"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/manager/task/assign?id=${task.taskId}"
                                                   class="btn btn-outline-success" title="Gán lại">
                                                    <i class="bi bi-person-check"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <div class="card-footer bg-white d-flex justify-content-between align-items-center">
                <small class="text-muted">
                    Trang ${currentPage} / ${totalPages} &bull; ${totalTasks} công việc
                </small>
                <nav>
                    <ul class="pagination pagination-sm mb-0">
                        <c:if test="${currentPage > 1}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${currentPage - 1}&employee=${employeeFilter}&status=${statusFilter}&priority=${priorityFilter}&keyword=${fn:escapeXml(keyword)}&sortBy=${sortBy}&overdue=${overdueOnly ? 1 : ''}">
                                    &laquo;
                                </a>
                            </li>
                        </c:if>
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <li class="page-item ${p == currentPage ? 'active' : ''}">
                                <a class="page-link" href="?page=${p}&employee=${employeeFilter}&status=${statusFilter}&priority=${priorityFilter}&keyword=${fn:escapeXml(keyword)}&sortBy=${sortBy}&overdue=${overdueOnly ? 1 : ''}">${p}</a>
                            </li>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${currentPage + 1}&employee=${employeeFilter}&status=${statusFilter}&priority=${priorityFilter}&keyword=${fn:escapeXml(keyword)}&sortBy=${sortBy}&overdue=${overdueOnly ? 1 : ''}">
                                    &raquo;
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </div>
        </c:if>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function () {
    var today = new Date();
    today.setHours(0, 0, 0, 0);

    document.querySelectorAll('#teamTaskTable tbody tr').forEach(function (row) {
        var dueStr = row.dataset.due;
        var status = row.dataset.status;

        if (dueStr && status !== 'COMPLETED' && status !== 'CANCELLED') {
            var due = new Date(dueStr);
            due.setHours(0, 0, 0, 0);
            if (due < today) {
                row.classList.add('table-danger');
                var badge = row.querySelector('.overdue-badge');
                if (badge) badge.style.display = 'inline';
            }
        }
    });
});
</script>
