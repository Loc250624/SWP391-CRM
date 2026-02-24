<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!-- Breadcrumb -->
<nav aria-label="breadcrumb" class="mb-3">
    <ol class="breadcrumb">
        <li class="breadcrumb-item">
            <a href="${pageContext.request.contextPath}/support/task/list">Công việc của tôi</a>
        </li>
        <li class="breadcrumb-item">
            <a href="${pageContext.request.contextPath}/support/task/detail?id=${task.taskId}">Chi tiết</a>
        </li>
        <li class="breadcrumb-item active">Cập nhật Trạng thái</li>
    </ol>
</nav>

<!-- Error Messages -->
<c:if test="${not empty sessionScope.errorMessage}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-triangle me-2"></i>${sessionScope.errorMessage}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <c:remove var="errorMessage" scope="session" />
</c:if>

<div class="row justify-content-center">
    <div class="col-lg-6 col-md-8">
        <div class="card shadow-sm">
            <div class="card-header bg-white">
                <h5 class="mb-0"><i class="bi bi-check2-circle me-2"></i>Cập nhật Trạng thái</h5>
            </div>
            <div class="card-body">
                <!-- Task Summary -->
                <div class="alert alert-light border mb-4">
                    <h6 class="mb-1">${task.title}</h6>
                    <small class="text-muted">
                        <strong>${task.taskCode}</strong>
                        <c:if test="${task.dueDate != null}">
                            &nbsp;&bull;&nbsp; Hạn:
                            <strong>${fn:substring(task.dueDate, 8, 10)}/${fn:substring(task.dueDate, 5, 7)}/${fn:substring(task.dueDate, 0, 4)}</strong>
                        </c:if>
                    </small>
                </div>

                <!-- Current Status -->
                <div class="mb-4">
                    <small class="text-muted d-block mb-1">Trạng thái hiện tại</small>
                    <c:choose>
                        <c:when test="${task.status == 'COMPLETED'}">
                            <span class="badge bg-success fs-6 px-3 py-2">Hoàn thành</span>
                        </c:when>
                        <c:when test="${task.status == 'IN_PROGRESS'}">
                            <span class="badge bg-info fs-6 px-3 py-2">Đang thực hiện</span>
                        </c:when>
                        <c:when test="${task.status == 'CANCELLED'}">
                            <span class="badge bg-dark fs-6 px-3 py-2">Đã hủy</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-secondary fs-6 px-3 py-2">Chờ xử lý</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Update Form -->
                <form action="${pageContext.request.contextPath}/support/task/status" method="post">
                    <input type="hidden" name="taskId" value="${task.taskId}">

                    <div class="mb-4">
                        <label for="status" class="form-label fw-bold">
                            Trạng thái mới <span class="text-danger">*</span>
                        </label>
                        <select class="form-select" id="status" name="status" required>
                            <c:forEach var="s" items="${taskStatusValues}">
                                <%-- FIX: SUPPORT cannot cancel tasks; hide CANCELLED option --%>
                                <c:if test="${s.name() != 'CANCELLED'}">
                                    <option value="${s.name()}" ${task.status == s.name() ? 'selected' : ''}>
                                        ${s.vietnamese}
                                    </option>
                                </c:if>
                            </c:forEach>
                        </select>
                        <small class="text-muted d-block mt-1">
                            Chỉ có thể cập nhật trạng thái. Liên hệ quản lý để thay đổi thông tin khác.
                        </small>
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-success">
                            <i class="bi bi-check2-circle me-2"></i>Lưu thay đổi
                        </button>
                        <a href="${pageContext.request.contextPath}/support/task/detail?id=${task.taskId}"
                           class="btn btn-outline-secondary">
                            <i class="bi bi-x-circle me-2"></i>Hủy
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
