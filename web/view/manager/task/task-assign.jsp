<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="container-fluid">
    <!-- Header -->
    <div class="mb-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/manager/task/list">Công việc</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}">Chi tiết</a></li>
                <li class="breadcrumb-item active">Gán công việc</li>
            </ol>
        </nav>
        <h3><i class="bi bi-person-check me-2"></i>Gán Công việc</h3>
        <p class="text-muted">Gán hoặc thay đổi người thực hiện công việc</p>
    </div>

    <!-- Error Messages -->
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle me-2"></i>${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="errorMessage" scope="session" />
    </c:if>

    <div class="row">
        <div class="col-lg-8">
            <!-- Task Info Card -->
            <div class="card mb-4">
                <div class="card-header bg-white">
                    <h5 class="mb-0">Thông tin công việc</h5>
                </div>
                <div class="card-body">
                    <h4 class="mb-3">${task.title}</h4>
                    <div class="row">
                        <div class="col-md-6">
                            <small class="text-muted d-block">Mã công việc</small>
                            <p class="fw-bold">${task.taskCode}</p>
                        </div>
                        <div class="col-md-6">
                            <small class="text-muted d-block">Trạng thái</small>
                            <p>
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
                            </p>
                        </div>
                        <div class="col-md-6">
                            <small class="text-muted d-block">Ưu tiên</small>
                            <p>
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
                            </p>
                        </div>
                        <div class="col-md-6">
                            <small class="text-muted d-block">Hạn chót</small>
                            <p class="fw-bold">
                                <fmt:formatDate value="${task.dueDate}" pattern="dd/MM/yyyy" />
                            </p>
                        </div>
                    </div>
                    <c:if test="${task.description != null && !task.description.isEmpty()}">
                        <hr>
                        <small class="text-muted d-block">Mô tả</small>
                        <p class="text-muted">${task.description}</p>
                    </c:if>
                </div>
            </div>

            <!-- Assign Form -->
            <div class="card">
                <div class="card-header bg-white">
                    <h5 class="mb-0"><i class="bi bi-person-plus me-2"></i>Gán người thực hiện</h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/manager/task/assign" method="post">
                        <input type="hidden" name="taskId" value="${task.taskId}">

                        <!-- Current Assignee -->
                        <c:if test="${currentAssignee != null}">
                            <div class="alert alert-info">
                                <strong>Người thực hiện hiện tại:</strong><br>
                                <div class="d-flex align-items-center mt-2">
                                    <div class="avatar-md bg-primary rounded-circle d-flex align-items-center justify-content-center text-white me-3">
                                        ${currentAssignee.firstName.substring(0, 1)}${currentAssignee.lastName.substring(0, 1)}
                                    </div>
                                    <div>
                                        <strong>${currentAssignee.firstName} ${currentAssignee.lastName}</strong><br>
                                        <small class="text-muted">${currentAssignee.email}</small>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        <!-- Select New Assignee -->
                        <div class="mb-4">
                            <label for="assignedTo" class="form-label">
                                Chọn người thực hiện mới <span class="text-danger">*</span>
                            </label>
                            <select class="form-select form-select-lg" id="assignedTo" name="assignedTo" required>
                                <option value="">-- Chọn nhân viên --</option>
                                <c:forEach var="user" items="${allUsers}">
                                    <option value="${user.userId}"
                                            ${task.assignedTo == user.userId ? 'selected' : ''}
                                            data-email="${user.email}"
                                            data-phone="${user.phone}">
                                        ${user.firstName} ${user.lastName} - ${user.email}
                                    </option>
                                </c:forEach>
                            </select>
                            <small class="text-muted">Chọn nhân viên sẽ chịu trách nhiệm thực hiện công việc này</small>
                        </div>

                        <!-- Selected User Info -->
                        <div id="selectedUserInfo" class="card bg-light mb-4" style="display: none;">
                            <div class="card-body">
                                <h6 class="mb-3">Thông tin người được chọn:</h6>
                                <div class="d-flex align-items-center">
                                    <div class="avatar-lg bg-primary rounded-circle d-flex align-items-center justify-content-center text-white me-3">
                                        <span id="userInitials"></span>
                                    </div>
                                    <div>
                                        <strong id="userName"></strong><br>
                                        <small class="text-muted">
                                            <i class="bi bi-envelope me-1"></i><span id="userEmail"></span>
                                        </small><br>
                                        <small class="text-muted">
                                            <i class="bi bi-telephone me-1"></i><span id="userPhone"></span>
                                        </small>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Note -->
                        <div class="mb-4">
                            <label for="assignNote" class="form-label">Ghi chú (tùy chọn)</label>
                            <textarea class="form-control" id="assignNote" name="assignNote" rows="3"
                                      placeholder="Thêm ghi chú về việc gán công việc này..."></textarea>
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="bi bi-check-circle me-2"></i>
                                Gán công việc
                            </button>
                            <a href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}"
                               class="btn btn-secondary btn-lg">
                                <i class="bi bi-x-circle me-2"></i>Hủy
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Sidebar -->
        <div class="col-lg-4">
            <!-- Tips Card -->
            <div class="card bg-light mb-3">
                <div class="card-body">
                    <h6 class="card-title"><i class="bi bi-lightbulb me-2"></i>Lưu ý khi gán công việc</h6>
                    <ul class="list-unstyled small mb-0">
                        <li class="mb-2">
                            <i class="bi bi-check2 text-success me-2"></i>
                            Chọn người có kỹ năng phù hợp
                        </li>
                        <li class="mb-2">
                            <i class="bi bi-check2 text-success me-2"></i>
                            Kiểm tra khối lượng công việc hiện tại
                        </li>
                        <li class="mb-2">
                            <i class="bi bi-check2 text-success me-2"></i>
                            Thông báo cho người được gán
                        </li>
                        <li class="mb-2">
                            <i class="bi bi-check2 text-success me-2"></i>
                            Theo dõi tiến độ thực hiện
                        </li>
                        <li class="mb-0">
                            <i class="bi bi-check2 text-success me-2"></i>
                            Hỗ trợ khi cần thiết
                        </li>
                    </ul>
                </div>
            </div>

            <!-- Team Members Card -->
            <div class="card">
                <div class="card-header bg-white">
                    <h6 class="mb-0"><i class="bi bi-people me-2"></i>Nhóm của bạn</h6>
                </div>
                <div class="card-body">
                    <div class="list-group list-group-flush">
                        <c:forEach var="user" items="${allUsers}" end="5">
                            <div class="list-group-item px-0">
                                <div class="d-flex align-items-center">
                                    <div class="avatar-sm bg-secondary rounded-circle d-flex align-items-center justify-content-center text-white me-2">
                                        ${user.firstName.substring(0, 1)}${user.lastName.substring(0, 1)}
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="fw-medium small">${user.firstName} ${user.lastName}</div>
                                        <small class="text-muted">${user.email}</small>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .avatar-sm {
        width: 32px;
        height: 32px;
        font-size: 0.75rem;
        font-weight: 600;
    }
    .avatar-md {
        width: 48px;
        height: 48px;
        font-size: 1rem;
        font-weight: 600;
    }
    .avatar-lg {
        width: 64px;
        height: 64px;
        font-size: 1.5rem;
        font-weight: 600;
    }
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const assignSelect = document.getElementById('assignedTo');
    const userInfo = document.getElementById('selectedUserInfo');
    const userName = document.getElementById('userName');
    const userEmail = document.getElementById('userEmail');
    const userPhone = document.getElementById('userPhone');
    const userInitials = document.getElementById('userInitials');

    assignSelect.addEventListener('change', function() {
        const selectedOption = this.options[this.selectedIndex];

        if (this.value) {
            const fullName = selectedOption.text.split(' - ')[0];
            const email = selectedOption.dataset.email;
            const phone = selectedOption.dataset.phone || 'N/A';

            // Get initials
            const names = fullName.trim().split(' ');
            const initials = names[0].charAt(0) + (names[names.length - 1]?.charAt(0) || '');

            userName.textContent = fullName;
            userEmail.textContent = email;
            userPhone.textContent = phone;
            userInitials.textContent = initials.toUpperCase();

            userInfo.style.display = 'block';
        } else {
            userInfo.style.display = 'none';
        }
    });

    // Trigger change if already selected
    if (assignSelect.value) {
        assignSelect.dispatchEvent(new Event('change'));
    }
});
</script>
