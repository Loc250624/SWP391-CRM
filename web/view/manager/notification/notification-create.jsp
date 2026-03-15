<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid">
    <!-- Header -->
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <h3 class="mb-1"><i class="bi bi-megaphone me-2"></i>Tạo Thông báo</h3>
            <p class="text-muted mb-0">Gửi thông báo In-app đến nhân viên theo vai trò hoặc cá nhân</p>
        </div>
        <a href="${pageContext.request.contextPath}/manager/notifications" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left me-2"></i>Quay lại
        </a>
    </div>

    <!-- Alert -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle me-2"></i>${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-circle me-2"></i>${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <form method="POST" action="${pageContext.request.contextPath}/manager/notifications/create">
        <div class="row g-3">
            <!-- Form chính -->
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm">
                    <div class="card-body">
                        <h5 class="mb-3">Nội dung thông báo</h5>

                        <div class="mb-3">
                            <label class="form-label">Tiêu đề <span class="text-danger">*</span></label>
                            <input type="text" name="title" class="form-control" placeholder="Nhập tiêu đề thông báo" required
                                   maxlength="255">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Tóm tắt</label>
                            <input type="text" name="summary" class="form-control" placeholder="Mô tả ngắn hiển thị ở danh sách"
                                   maxlength="500">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Nội dung chi tiết</label>
                            <textarea name="message" class="form-control" rows="6" placeholder="Soạn nội dung thông báo..."></textarea>
                        </div>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Mức ưu tiên</label>
                                <select name="priority" class="form-select">
                                    <option value="NORMAL">Bình thường</option>
                                    <option value="HIGH">Cao</option>
                                    <option value="URGENT">Khẩn cấp</option>
                                    <option value="LOW">Thấp</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">URL hành động</label>
                                <input type="text" name="actionUrl" class="form-control"
                                       placeholder="VD: /manager/task/list (tùy chọn)">
                                <div class="form-text">Đường dẫn nội bộ khi người nhận click vào thông báo</div>
                            </div>
                        </div>

                        <div class="mt-4">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-send-check me-2"></i>Gửi ngay
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Side Panel -->
            <div class="col-lg-4">
                <!-- Đối tượng nhận -->
                <div class="card border-0 shadow-sm mb-3">
                    <div class="card-body">
                        <h6 class="mb-3">Đối tượng nhận <span class="text-danger">*</span></h6>

                        <div class="mb-3">
                            <select name="targetType" class="form-select" id="targetTypeSelect" onchange="toggleTargetFields()">
                                <option value="ALL">Toàn bộ hệ thống</option>
                                <option value="ROLE">Theo vai trò</option>
                                <option value="INDIVIDUAL">Chỉ định cá nhân</option>
                            </select>
                        </div>

                        <!-- Role selection -->
                        <div id="roleField" class="mb-3" style="display:none;">
                            <label class="form-label">Chọn vai trò</label>
                            <div class="form-check mb-1">
                                <input class="form-check-input" type="checkbox" name="targetRoles" value="SALES" id="roleSales">
                                <label class="form-check-label" for="roleSales">Sales</label>
                            </div>
                            <div class="form-check mb-1">
                                <input class="form-check-input" type="checkbox" name="targetRoles" value="MANAGER" id="roleManager">
                                <label class="form-check-label" for="roleManager">Manager</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="targetRoles" value="ADMIN" id="roleAdmin">
                                <label class="form-check-label" for="roleAdmin">Admin</label>
                            </div>
                        </div>

                        <!-- Individual selection -->
                        <div id="individualField" style="display:none;">
                            <label class="form-label">Chọn nhân viên</label>
                            <div style="max-height: 250px; overflow-y: auto; border: 1px solid #dee2e6; border-radius: 0.375rem; padding: 0.5rem;">
                                <c:forEach var="u" items="${allUsers}">
                                    <div class="form-check mb-1">
                                        <input class="form-check-input" type="checkbox" name="targetUserIds"
                                               value="${u.userId}" id="user_${u.userId}">
                                        <label class="form-check-label small" for="user_${u.userId}">
                                            ${u.firstName} ${u.lastName}
                                            <span class="text-muted">(${u.email})</span>
                                        </label>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Kênh -->
                <div class="card border-0 shadow-sm">
                    <div class="card-body">
                        <h6 class="mb-3">Kênh gửi</h6>
                        <div class="form-check form-switch mb-2">
                            <input class="form-check-input" type="checkbox" checked disabled>
                            <label class="form-check-label">In-app <span class="badge bg-success-subtle text-success ms-1">Hoạt động</span></label>
                        </div>
                        <div class="form-text text-muted">Hiện tại chỉ hỗ trợ kênh In-app. Email, SMS, Push sẽ được bổ sung sau.</div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>

<script>
function toggleTargetFields() {
    var val = document.getElementById('targetTypeSelect').value;
    document.getElementById('roleField').style.display = val === 'ROLE' ? '' : 'none';
    document.getElementById('individualField').style.display = val === 'INDIVIDUAL' ? '' : 'none';
}
</script>
