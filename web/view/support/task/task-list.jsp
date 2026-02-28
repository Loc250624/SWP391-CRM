<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

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
        <h4 class="mb-1"><i class="bi bi-list-task me-2"></i>Công việc của tôi</h4>
        <p class="text-muted mb-0">Danh sách công việc được giao cho bạn</p>
    </div>
    <a href="${pageContext.request.contextPath}/support/task/calendar" class="btn btn-outline-primary btn-sm">
        <i class="bi bi-calendar3 me-1"></i>Xem Lịch
    </a>
</div>

<!-- Filters -->
<div class="card mb-4 shadow-sm">
    <div class="card-body">
        <form method="get" action="${pageContext.request.contextPath}/support/task/list" class="row g-3 align-items-end">
            <div class="col-md-4">
                <label class="form-label small">Tìm kiếm</label>
                <input type="text" class="form-control form-control-sm" name="keyword" value="${keyword}"
                       placeholder="Tìm theo tiêu đề...">
            </div>
            <div class="col-md-3">
                <label class="form-label small">Trạng thái</label>
                <select class="form-select form-select-sm" name="status">
                    <option value="">Tất cả</option>
                    <c:forEach var="s" items="${taskStatusValues}">
                        <option value="${s.name()}" ${statusFilter == s.name() ? 'selected' : ''}>${s.vietnamese}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-3">
                <label class="form-label small">Ưu tiên</label>
                <select class="form-select form-select-sm" name="priority">
                    <option value="">Tất cả</option>
                    <c:forEach var="p" items="${priorityValues}">
                        <option value="${p.name()}" ${priorityFilter == p.name() ? 'selected' : ''}>${p.vietnamese}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-primary btn-sm w-100">
                    <i class="bi bi-search me-1"></i>Lọc
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Task Table -->
<div class="card shadow-sm">
    <div class="card-header bg-white d-flex justify-content-between align-items-center">
        <h6 class="mb-0">Công việc (${totalTasks})</h6>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead class="table-light">
                    <tr>
                        <th>Mã</th>
                        <th>Tiêu đề</th>
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
                                <td colspan="6" class="text-center py-5">
                                    <i class="bi bi-inbox text-muted" style="font-size:2.5rem;"></i>
                                    <p class="text-muted mt-2 mb-0 small">Không có công việc nào được giao cho bạn</p>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="task" items="${taskList}">
                                <tr>
                                    <td><span class="badge bg-secondary">${task.taskCode}</span></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/support/task/detail?id=${task.taskId}"
                                           class="text-decoration-none fw-medium">${task.title}</a>
                                        <c:if test="${not empty task.relatedType}">
                                            <br><small class="text-muted"><i class="bi bi-link-45deg"></i>${task.relatedType}</small>
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${task.dueDate != null}">
                                                <span data-due="${task.dueDate}" data-status="${task.statusName}">
                                                    ${fn:substring(task.dueDate, 8, 10)}/${fn:substring(task.dueDate, 5, 7)}/${fn:substring(task.dueDate, 0, 4)}
                                                </span>
                                            </c:when>
                                            <c:otherwise><span class="text-muted small">Không xác định</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${task.priorityName == 'HIGH'}"><span class="badge bg-danger">Cao</span></c:when>
                                            <c:when test="${task.priorityName == 'MEDIUM'}"><span class="badge bg-warning text-dark">Trung bình</span></c:when>
                                            <c:otherwise><span class="badge bg-secondary">Thấp</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${task.statusName == 'COMPLETED'}"><span class="badge bg-success">Hoàn thành</span></c:when>
                                            <c:when test="${task.statusName == 'IN_PROGRESS'}"><span class="badge bg-info">Đang thực hiện</span></c:when>
                                            <c:when test="${task.statusName == 'CANCELLED'}"><span class="badge bg-dark">Đã hủy</span></c:when>
                                            <c:otherwise><span class="badge bg-secondary">Chờ xử lý</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end">
                                        <a href="${pageContext.request.contextPath}/support/task/detail?id=${task.taskId}"
                                           class="btn btn-sm btn-outline-primary" title="Chi tiết">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                        <c:if test="${task.statusName != 'COMPLETED' && task.statusName != 'CANCELLED'}">
                                            <a href="${pageContext.request.contextPath}/support/task/status?id=${task.taskId}"
                                               class="btn btn-sm btn-outline-success" title="Cập nhật trạng thái">
                                                <i class="bi bi-check2-circle"></i>
                                            </a>
                                        </c:if>
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
                <ul class="pagination pagination-sm justify-content-center mb-0">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link"
                           href="${pageContext.request.contextPath}/support/task/list?page=${currentPage - 1}&status=${statusFilter}&priority=${priorityFilter}&keyword=${keyword}">
                            <i class="bi bi-chevron-left"></i>
                        </a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:if test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link"
                                   href="${pageContext.request.contextPath}/support/task/list?page=${i}&status=${statusFilter}&priority=${priorityFilter}&keyword=${keyword}">
                                    ${i}
                                </a>
                            </li>
                        </c:if>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link"
                           href="${pageContext.request.contextPath}/support/task/list?page=${currentPage + 1}&status=${statusFilter}&priority=${priorityFilter}&keyword=${keyword}">
                            <i class="bi bi-chevron-right"></i>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </c:if>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    document.querySelectorAll('[data-due]').forEach(function(el) {
        const dueStr = el.getAttribute('data-due');
        const status = el.getAttribute('data-status');
        if (!dueStr) return;
        const due = new Date(dueStr.substring(0, 10));
        if (due < today && status !== 'COMPLETED' && status !== 'CANCELLED') {
            el.insertAdjacentHTML('afterend', ' <span class="badge bg-danger" style="font-size:10px;">Quá hạn</span>');
        }
    });
});
</script>
