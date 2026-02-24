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
            <h3 class="mb-1"><i class="bi bi-grid-3x3-gap me-2"></i>Tất cả Công việc</h3>
            <p class="text-muted mb-0">Xem và quản lý toàn bộ công việc của phòng ban</p>
        </div>
        <a href="${pageContext.request.contextPath}/manager/task/form?action=create" class="btn btn-primary">
            <i class="bi bi-plus-circle me-2"></i>Tạo Công việc
        </a>
    </div>

    <!-- SLA Summary Cards -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <p class="text-muted mb-1 small">Tổng công việc (SLA)</p>
                            <h4 class="mb-0">${slaStats['total']}</h4>
                        </div>
                        <div class="bg-primary bg-opacity-10 p-2 rounded">
                            <i class="bi bi-list-check text-primary fs-5"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <p class="text-muted mb-1 small">Trong SLA</p>
                            <h4 class="mb-0 text-success">${slaStats['ok']}</h4>
                        </div>
                        <div class="bg-success bg-opacity-10 p-2 rounded">
                            <i class="bi bi-check-circle text-success fs-5"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <p class="text-muted mb-1 small">Cảnh báo SLA</p>
                            <h4 class="mb-0 text-warning">${slaStats['warning']}</h4>
                        </div>
                        <div class="bg-warning bg-opacity-10 p-2 rounded">
                            <i class="bi bi-exclamation-circle text-warning fs-5"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <p class="text-muted mb-1 small">Vi phạm SLA</p>
                            <h4 class="mb-0 text-danger">${slaStats['breached']}</h4>
                        </div>
                        <div class="bg-danger bg-opacity-10 p-2 rounded">
                            <i class="bi bi-x-circle text-danger fs-5"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Filters -->
    <div class="card mb-4">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/manager/task/all" class="row g-3">
                <div class="col-md-3">
                    <label class="form-label">Tìm kiếm</label>
                    <input type="text" class="form-control" name="keyword" value="${keyword}"
                           placeholder="Tìm theo tiêu đề...">
                </div>
                <div class="col-md-2">
                    <label class="form-label">Nhân viên</label>
                    <select class="form-select" name="employee">
                        <option value="">Tất cả</option>
                        <c:forEach var="member" items="${deptMembers}">
                            <option value="${member.userId}"
                                ${employeeFilter == member.userId ? 'selected' : ''}>
                                ${member.firstName} ${member.lastName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Trạng thái</label>
                    <select class="form-select" name="status">
                        <option value="">Tất cả</option>
                        <c:forEach var="s" items="${taskStatusValues}">
                            <option value="${s.name()}" ${statusFilter == s.name() ? 'selected' : ''}>${s.vietnamese}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Ưu tiên</label>
                    <select class="form-select" name="priority">
                        <option value="">Tất cả</option>
                        <c:forEach var="p" items="${priorityValues}">
                            <option value="${p.name()}" ${priorityFilter == p.name() ? 'selected' : ''}>${p.vietnamese}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Lọc SLA</label>
                    <select class="form-select" name="sla">
                        <option value="">Tất cả</option>
                        <option value="BREACHED" ${'BREACHED' == slaFilter ? 'selected' : ''}>Vi phạm SLA</option>
                        <option value="OK"       ${'OK' == slaFilter ? 'selected' : ''}>Trong SLA</option>
                    </select>
                </div>
                <div class="col-md-1 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary w-100"><i class="bi bi-search"></i></button>
                </div>
                <div class="col-md-12 d-flex align-items-center gap-3">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="overdue" value="1" id="overdueCheck"
                            ${overdueOnly ? 'checked' : ''} onchange="this.form.submit()">
                        <label class="form-check-label" for="overdueCheck">Chỉ hiện quá hạn</label>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Task Table -->
    <div class="card">
        <div class="card-header bg-white">
            <div class="d-flex justify-content-between align-items-center">
                <h5 class="mb-0">Danh sách (${totalTasks})</h5>
                <select class="form-select form-select-sm" style="width: auto;"
                        onchange="window.location.href='${pageContext.request.contextPath}/manager/task/all'
                            + '?sortBy=' + this.value
                            + '&status=${statusFilter}&priority=${priorityFilter}&keyword=${keyword}'
                            + '&employee=${employeeFilter}&sla=${slaFilter}&overdue=${overdueOnly ? 1 : 0}'">
                    <option value="due_date"   ${sortBy == 'due_date'   ? 'selected' : ''}>Sắp xếp: Hạn chót</option>
                    <option value="priority"   ${sortBy == 'priority'   ? 'selected' : ''}>Sắp xếp: Ưu tiên</option>
                    <option value="created_at" ${sortBy == 'created_at' ? 'selected' : ''}>Sắp xếp: Ngày tạo</option>
                </select>
            </div>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Mã</th>
                            <th>Tiêu đề</th>
                            <th>Người thực hiện</th>
                            <th>Hạn chót</th>
                            <th>Ưu tiên</th>
                            <th>Trạng thái</th>
                            <th>SLA</th>
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
                                    <tr>
                                        <td><span class="badge bg-secondary">${task.taskCode}</span></td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}"
                                               class="text-decoration-none fw-medium">
                                                <%-- Recurring icon --%>
                                                <c:if test="${fn:contains(task.title, '[R-')}">
                                                    <i class="bi bi-arrow-repeat text-info me-1" title="Công việc lặp lại"></i>
                                                </c:if>
                                                ${task.title}
                                            </a>
                                            <c:if test="${not empty task.relatedType && task.relatedType != 'SUBTASK'}">
                                                <br><small class="text-muted"><i class="bi bi-link-45deg"></i>${task.relatedType}</small>
                                            </c:if>
                                        </td>
                                        <td>
                                            <c:forEach var="user" items="${allUsers}">
                                                <c:if test="${user.userId == task.assignedTo}">
                                                    <div class="d-flex align-items-center">
                                                        <div class="avatar-sm bg-primary rounded-circle d-flex align-items-center justify-content-center text-white me-2">
                                                            ${fn:substring(user.firstName, 0, 1)}${fn:substring(user.lastName, 0, 1)}
                                                        </div>
                                                        <div>
                                                            <div class="fw-medium small">${user.firstName} ${user.lastName}</div>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </c:forEach>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${task.dueDate != null}">
                                                    <span data-due="${task.dueDate}" data-status="${task.status}">
                                                        ${fn:substring(task.dueDate, 8, 10)}/${fn:substring(task.dueDate, 5, 7)}/${fn:substring(task.dueDate, 0, 4)}
                                                    </span>
                                                </c:when>
                                                <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${task.priority == 'HIGH'}">
                                                    <span class="badge bg-danger">Cao</span>
                                                </c:when>
                                                <c:when test="${task.priority == 'MEDIUM'}">
                                                    <span class="badge bg-warning text-dark">TB</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">Thấp</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
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
                                        </td>
                                        <td>
                                            <%-- SLA badge rendered by JS based on created_at, completed_at, priority --%>
                                            <c:if test="${task.status != 'CANCELLED'}">
                                                <span class="sla-badge"
                                                      data-created="${task.createdAt}"
                                                      data-completed="${task.completedAt}"
                                                      data-priority="${task.priority}">
                                                </span>
                                            </c:if>
                                        </td>
                                        <td class="text-end">
                                            <div class="btn-group" role="group">
                                                <a href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}"
                                                   class="btn btn-sm btn-outline-primary" title="Chi tiết">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/manager/task/form?action=edit&id=${task.taskId}"
                                                   class="btn btn-sm btn-outline-secondary" title="Sửa">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/manager/task/delete"
                                                      class="d-inline"
                                                      onsubmit="return confirm('Xóa công việc này?');">
                                                    <input type="hidden" name="id" value="${task.taskId}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger" title="Xóa">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
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
                <nav>
                    <ul class="pagination justify-content-center mb-0">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/manager/task/all?page=${currentPage - 1}&status=${statusFilter}&priority=${priorityFilter}&keyword=${keyword}&employee=${employeeFilter}&sla=${slaFilter}&overdue=${overdueOnly ? 1 : 0}&sortBy=${sortBy}">
                                <i class="bi bi-chevron-left"></i>
                            </a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <c:if test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link"
                                       href="${pageContext.request.contextPath}/manager/task/all?page=${i}&status=${statusFilter}&priority=${priorityFilter}&keyword=${keyword}&employee=${employeeFilter}&sla=${slaFilter}&overdue=${overdueOnly ? 1 : 0}&sortBy=${sortBy}">
                                        ${i}
                                    </a>
                                </li>
                            </c:if>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/manager/task/all?page=${currentPage + 1}&status=${statusFilter}&priority=${priorityFilter}&keyword=${keyword}&employee=${employeeFilter}&sla=${slaFilter}&overdue=${overdueOnly ? 1 : 0}&sortBy=${sortBy}">
                                <i class="bi bi-chevron-right"></i>
                            </a>
                        </li>
                    </ul>
                </nav>
                <p class="text-center text-muted small mb-0 mt-2">
                    Trang ${currentPage} / ${totalPages} — Tổng ${totalTasks} công việc
                </p>
            </div>
        </c:if>
    </div>
</div>

<style>
    .avatar-sm { width: 32px; height: 32px; font-size: 0.75rem; font-weight: 600; flex-shrink: 0; }
</style>

<script>
document.addEventListener('DOMContentLoaded', function () {
    var today = new Date();
    today.setHours(0, 0, 0, 0);

    // Overdue detection
    document.querySelectorAll('[data-due]').forEach(function (el) {
        var dueStr = el.getAttribute('data-due');
        var status = el.getAttribute('data-status');
        if (!dueStr) return;
        var due = new Date(dueStr.substring(0, 10));
        if (due < today && status !== 'COMPLETED' && status !== 'CANCELLED') {
            el.insertAdjacentHTML('afterend', ' <span class="badge bg-danger">Quá hạn</span>');
        }
    });

    // SLA badge rendering
    var SLA_HOURS = { HIGH: 24, MEDIUM: 72, LOW: 120 };

    document.querySelectorAll('.sla-badge').forEach(function (el) {
        var createdStr   = el.getAttribute('data-created');
        var completedStr = el.getAttribute('data-completed');
        var priority     = el.getAttribute('data-priority') || 'LOW';
        if (!createdStr) return;

        var slaHours = SLA_HOURS[priority] || 120;
        var created  = new Date(createdStr.replace('T', ' '));
        var end      = completedStr ? new Date(completedStr.replace('T', ' ')) : new Date();
        var elapsed  = (end - created) / 3600000; // hours

        var badge, cls;
        if (elapsed > slaHours) {
            badge = 'Vi phạm'; cls = 'danger';
        } else if (elapsed > slaHours * 0.8) {
            badge = 'Cảnh báo'; cls = 'warning text-dark';
        } else {
            badge = 'Đúng hạn'; cls = 'success';
        }
        el.innerHTML = '<span class="badge bg-' + cls + '">' + badge + '</span>';
    });
});
</script>
