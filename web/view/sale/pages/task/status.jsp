<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="container-fluid">

    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/sale/task/list">Công việc của tôi</a>
            </li>
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/sale/task/detail?id=${task.taskId}">Chi tiết</a>
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
        <div class="col-lg-6">
            <div class="card">
                <div class="card-header bg-white">
                    <h5 class="mb-0"><i class="bi bi-check2-circle me-2"></i>Cập nhật Trạng thái Công việc</h5>
                </div>
                <div class="card-body">
                    <!-- Task Summary -->
                    <div class="alert alert-light border mb-4">
                        <h6 class="mb-1">${task.title}</h6>
                        <small class="text-muted">
                            Mã: <strong>${task.taskCode}</strong>
                            <c:if test="${task.dueDate != null}">
                                &nbsp;|&nbsp; Hạn chót:
                                <strong>${fn:substring(task.dueDate, 8, 10)}/${fn:substring(task.dueDate, 5, 7)}/${fn:substring(task.dueDate, 0, 4)}</strong>
                            </c:if>
                        </small>
                    </div>

                    <!-- Current Status -->
                    <div class="mb-4">
                        <label class="form-label text-muted small">Trạng thái hiện tại</label>
                        <div>
                            <c:choose>
                                <c:when test="${task.statusName == 'COMPLETED'}">
                                    <span class="badge bg-success fs-6 px-3 py-2">Hoàn thành</span>
                                </c:when>
                                <c:when test="${task.statusName == 'IN_PROGRESS'}">
                                    <span class="badge bg-info fs-6 px-3 py-2">Đang thực hiện</span>
                                </c:when>
                                <c:when test="${task.statusName == 'CANCELLED'}">
                                    <span class="badge bg-dark fs-6 px-3 py-2">Đã hủy</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary fs-6 px-3 py-2">Chờ xử lý</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Update Form -->
                    <form action="${pageContext.request.contextPath}/sale/task/status" method="post"
                          onsubmit="return confirm('Bạn có chắc chắn muốn đánh dấu công việc này là Hoàn thành?');">
                        <input type="hidden" name="taskId" value="${task.taskId}">
                        <input type="hidden" name="status" value="COMPLETED">

                        <div class="alert alert-info mb-4">
                            <i class="bi bi-info-circle me-2"></i>
                            Bạn chỉ có thể cập nhật trạng thái sang <strong>Hoàn thành</strong>.
                            Liên hệ quản lý nếu cần thay đổi khác.
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-success btn-lg">
                                <i class="bi bi-check2-circle me-2"></i>Đánh dấu Hoàn thành
                            </button>
                            <a href="${pageContext.request.contextPath}/sale/task/detail?id=${task.taskId}"
                               class="btn btn-outline-secondary btn-lg">
                                <i class="bi bi-arrow-left me-2"></i>Quay lại
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
