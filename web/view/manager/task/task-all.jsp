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
            <h3 class="mb-1"><i class="bi bi-grid-3x3-gap me-2"></i>Tat ca Cong viec</h3>
            <p class="text-muted mb-0">Xem va quan ly toan bo cong viec cua phong ban</p>
        </div>
        <a href="${pageContext.request.contextPath}/manager/task/form?action=create" class="btn btn-primary">
            <i class="bi bi-plus-circle me-2"></i>Tao Cong viec
        </a>
    </div>

    <!-- Filters -->
    <div class="card mb-4">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/manager/task/all" class="row g-3">
                <div class="col-md-3">
                    <label class="form-label">Tim kiem</label>
                    <input type="text" class="form-control" name="keyword" value="${keyword}"
                           placeholder="Tim theo tieu de...">
                </div>
                <div class="col-md-3">
                    <label class="form-label">Nhan vien</label>
                    <select class="form-select" name="employee">
                        <option value="">Tat ca</option>
                        <c:forEach var="member" items="${deptMembers}">
                            <option value="${member.userId}"
                                ${employeeFilter == member.userId ? 'selected' : ''}>
                                ${member.firstName} ${member.lastName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Trang thai</label>
                    <select class="form-select" name="status">
                        <option value="">Tat ca</option>
                        <c:forEach var="s" items="${taskStatusValues}">
                            <option value="${s.name()}" ${statusFilter == s.name() ? 'selected' : ''}>${s.vietnamese}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Uu tien</label>
                    <select class="form-select" name="priority">
                        <option value="">Tat ca</option>
                        <c:forEach var="p" items="${priorityValues}">
                            <option value="${p.name()}" ${priorityFilter == p.name() ? 'selected' : ''}>${p.vietnamese}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary w-100"><i class="bi bi-search me-1"></i>Loc</button>
                </div>
                <div class="col-md-12 d-flex align-items-center gap-3">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="overdue" value="1" id="overdueCheck"
                            ${overdueOnly ? 'checked' : ''} onchange="this.form.submit()">
                        <label class="form-check-label" for="overdueCheck">Chi hien qua han</label>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Task Table -->
    <div class="card">
        <div class="card-header bg-white">
            <div class="d-flex justify-content-between align-items-center">
                <h5 class="mb-0">Danh sach (${totalTasks})</h5>
                <select class="form-select form-select-sm" style="width: auto;"
                        onchange="window.location.href='${pageContext.request.contextPath}/manager/task/all'
                            + '?sortBy=' + this.value
                            + '&status=${statusFilter}&priority=${priorityFilter}&keyword=${keyword}'
                            + '&employee=${employeeFilter}&overdue=${overdueOnly ? 1 : 0}'">
                    <option value="due_date"   ${sortBy == 'due_date'   ? 'selected' : ''}>Sap xep: Han chot</option>
                    <option value="priority"   ${sortBy == 'priority'   ? 'selected' : ''}>Sap xep: Uu tien</option>
                    <option value="created_at" ${sortBy == 'created_at' ? 'selected' : ''}>Sap xep: Ngay tao</option>
                </select>
            </div>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Ma</th>
                            <th>Tieu de</th>
                            <th>Nguoi thuc hien</th>
                            <th>Han chot</th>
                            <th>Uu tien</th>
                            <th>Trang thai</th>
                            <th class="text-end">Thao tac</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty taskList}">
                                <tr>
                                    <td colspan="7" class="text-center py-5">
                                        <i class="bi bi-inbox text-muted" style="font-size: 3rem;"></i>
                                        <p class="text-muted mt-3">Khong co cong viec nao</p>
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
                                                <c:if test="${fn:contains(task.title, '[R-')}">
                                                    <i class="bi bi-arrow-repeat text-info me-1" title="Cong viec lap lai"></i>
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
                                                    <span data-due="${task.dueDate}" data-status="${task.statusName}">
                                                        ${fn:substring(task.dueDate, 8, 10)}/${fn:substring(task.dueDate, 5, 7)}/${fn:substring(task.dueDate, 0, 4)}
                                                    </span>
                                                </c:when>
                                                <c:otherwise><span class="text-muted">-</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${task.priorityName == 'HIGH'}">
                                                    <span class="badge bg-danger">Cao</span>
                                                </c:when>
                                                <c:when test="${task.priorityName == 'MEDIUM'}">
                                                    <span class="badge bg-warning text-dark">TB</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">Thap</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${task.statusName == 'COMPLETED'}">
                                                    <span class="badge bg-success">Hoan thanh</span>
                                                </c:when>
                                                <c:when test="${task.statusName == 'IN_PROGRESS'}">
                                                    <span class="badge bg-info">Dang thuc hien</span>
                                                </c:when>
                                                <c:when test="${task.statusName == 'CANCELLED'}">
                                                    <span class="badge bg-dark">Da huy</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">Cho xu ly</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <div class="btn-group" role="group">
                                                <a href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}"
                                                   class="btn btn-sm btn-outline-primary" title="Chi tiet">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/manager/task/form?action=edit&id=${task.taskId}"
                                                   class="btn btn-sm btn-outline-secondary" title="Sua">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/manager/task/delete"
                                                      class="d-inline"
                                                      onsubmit="return confirm('Xoa cong viec nay?');">
                                                    <input type="hidden" name="id" value="${task.taskId}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger" title="Xoa">
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
                               href="${pageContext.request.contextPath}/manager/task/all?page=${currentPage - 1}&status=${statusFilter}&priority=${priorityFilter}&keyword=${keyword}&employee=${employeeFilter}&overdue=${overdueOnly ? 1 : 0}&sortBy=${sortBy}">
                                <i class="bi bi-chevron-left"></i>
                            </a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <c:if test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link"
                                       href="${pageContext.request.contextPath}/manager/task/all?page=${i}&status=${statusFilter}&priority=${priorityFilter}&keyword=${keyword}&employee=${employeeFilter}&overdue=${overdueOnly ? 1 : 0}&sortBy=${sortBy}">
                                        ${i}
                                    </a>
                                </li>
                            </c:if>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/manager/task/all?page=${currentPage + 1}&status=${statusFilter}&priority=${priorityFilter}&keyword=${keyword}&employee=${employeeFilter}&overdue=${overdueOnly ? 1 : 0}&sortBy=${sortBy}">
                                <i class="bi bi-chevron-right"></i>
                            </a>
                        </li>
                    </ul>
                </nav>
                <p class="text-center text-muted small mb-0 mt-2">
                    Trang ${currentPage} / ${totalPages} - Tong ${totalTasks} cong viec
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
            el.insertAdjacentHTML('afterend', ' <span class="badge bg-danger">Qua han</span>');
        }
    });
});
</script>
