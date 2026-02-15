<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

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
            <h3 class="mb-1"><i class="bi bi-list-task me-2"></i>Quản lý Công việc</h3>
            <p class="text-muted mb-0">Quản lý công việc cá nhân và nhóm</p>
        </div>
        <a href="${pageContext.request.contextPath}/manager/task/form?action=create" class="btn btn-primary">
            <i class="bi bi-plus-circle me-2"></i>Tạo Công việc
        </a>
    </div>

    <!-- Navigation Tabs -->
    <ul class="nav nav-tabs mb-4">
        <li class="nav-item">
            <a class="nav-link ${viewType == 'personal' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/manager/task/list?view=personal">
                <i class="bi bi-person me-2"></i>Công việc của tôi
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${viewType == 'team' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/manager/task/list?view=team">
                <i class="bi bi-people me-2"></i>Công việc nhóm
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/manager/task/calendar">
                <i class="bi bi-calendar me-2"></i>Lịch
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/manager/task/report">
                <i class="bi bi-graph-up me-2"></i>Báo cáo
            </a>
        </li>
    </ul>

    <!-- Filters -->
    <div class="card mb-4">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/manager/task/list" class="row g-3">
                <input type="hidden" name="view" value="${viewType}">

                <div class="col-md-3">
                    <label class="form-label">Tìm kiếm</label>
                    <input type="text" class="form-control" name="keyword" value="${keyword}"
                           placeholder="Tìm theo tiêu đề...">
                </div>

                <div class="col-md-2">
                    <label class="form-label">Trạng thái</label>
                    <select class="form-select" name="status">
                        <option value="">Tất cả</option>
                        <c:forEach var="s" items="${taskStatusValues}">
                            <option value="${s}" ${statusFilter == s.name() ? 'selected' : ''}>
                                ${s.vietnamese}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-2">
                    <label class="form-label">Ưu tiên</label>
                    <select class="form-select" name="priority">
                        <option value="">Tất cả</option>
                        <c:forEach var="p" items="${priorityValues}">
                            <option value="${p}" ${priorityFilter == p.name() ? 'selected' : ''}>
                                ${p.vietnamese}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <c:if test="${viewType == 'team'}">
                    <div class="col-md-3">
                        <label class="form-label">Nhân viên</label>
                        <select class="form-select" name="employee">
                            <option value="">Tất cả</option>
                            <c:forEach var="member" items="${teamMembers}">
                                <option value="${member.userId}" ${employeeFilter == member.userId ? 'selected' : ''}>
                                    ${member.firstName} ${member.lastName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </c:if>

                <div class="col-md-2">
                    <label class="form-label">&nbsp;</label>
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
                <div class="d-flex gap-2">
                    <select class="form-select form-select-sm" style="width: auto;"
                            onchange="window.location.href='${pageContext.request.contextPath}/manager/task/list?view=${viewType}&sortBy='+this.value">
                        <option value="due_date" ${sortBy == 'due_date' ? 'selected' : ''}>Sắp xếp: Hạn chót</option>
                        <option value="priority" ${sortBy == 'priority' ? 'selected' : ''}>Sắp xếp: Ưu tiên</option>
                        <option value="created_at" ${sortBy == 'created_at' ? 'selected' : ''}>Sắp xếp: Ngày tạo</option>
                    </select>
                </div>
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
                            <th class="text-end">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty taskList}">
                                <tr>
                                    <td colspan="7" class="text-center py-5">
                                        <i class="bi bi-inbox text-muted" style="font-size: 3rem;"></i>
                                        <p class="text-muted mt-3">Không có công việc nào</p>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="task" items="${taskList}">
                                    <tr>
                                        <td>
                                            <span class="badge bg-secondary">${task.taskCode}</span>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}"
                                               class="text-decoration-none fw-medium">
                                                ${task.title}
                                            </a>
                                            <c:if test="${task.relatedType != null}">
                                                <br><small class="text-muted">
                                                    <i class="bi bi-link-45deg"></i>${task.relatedType}
                                                </small>
                                            </c:if>
                                        </td>
                                        <td>
                                            <c:forEach var="user" items="${allUsers}">
                                                <c:if test="${user.userId == task.assignedTo}">
                                                    <div class="d-flex align-items-center">
                                                        <div class="avatar-sm bg-primary rounded-circle d-flex align-items-center justify-content-center text-white me-2">
                                                            ${user.firstName.substring(0, 1)}${user.lastName.substring(0, 1)}
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
                                            <c:choose>
                                                <c:when test="${task.dueDate != null}">
                                                    <fmt:formatDate value="${task.dueDate}" pattern="dd/MM/yyyy" />
                                                    <c:if test="${task.dueDate.isBefore(now()) && task.status != 'COMPLETED'}">
                                                        <br><span class="badge bg-danger">Quá hạn</span>
                                                    </c:if>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Không xác định</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${task.priority == 'HIGH'}">
                                                    <span class="badge bg-danger">Cao</span>
                                                </c:when>
                                                <c:when test="${task.priority == 'MEDIUM'}">
                                                    <span class="badge bg-warning">Trung bình</span>
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
                                        <td class="text-end">
                                            <div class="btn-group" role="group">
                                                <a href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}"
                                                   class="btn btn-sm btn-outline-primary" title="Chi tiết">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/manager/task/form?action=edit&id=${task.taskId}"
                                                   class="btn btn-sm btn-outline-secondary" title="Chỉnh sửa">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/manager/task/delete?id=${task.taskId}"
                                                   class="btn btn-sm btn-outline-danger" title="Xóa"
                                                   onclick="return confirm('Bạn có chắc chắn muốn xóa công việc này?');">
                                                    <i class="bi bi-trash"></i>
                                                </a>
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
                            <a class="page-link" href="${pageContext.request.contextPath}/manager/task/list?view=${viewType}&page=${currentPage - 1}&status=${statusFilter}&priority=${priorityFilter}&keyword=${keyword}&employee=${employeeFilter}">
                                <i class="bi bi-chevron-left"></i>
                            </a>
                        </li>

                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <c:if test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/manager/task/list?view=${viewType}&page=${i}&status=${statusFilter}&priority=${priorityFilter}&keyword=${keyword}&employee=${employeeFilter}">
                                        ${i}
                                    </a>
                                </li>
                            </c:if>
                        </c:forEach>

                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/manager/task/list?view=${viewType}&page=${currentPage + 1}&status=${statusFilter}&priority=${priorityFilter}&keyword=${keyword}&employee=${employeeFilter}">
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
    }
</style>
