<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid">
    <!-- Messages -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle me-2"></i>${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle me-2"></i>${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <!-- Header -->
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <h3 class="mb-1">
                <i class="bi bi-file-earmark-code me-2"></i>
                <c:choose>
                    <c:when test="${isEdit}">Sửa mẫu Email</c:when>
                    <c:otherwise>Tạo mẫu Email mới</c:otherwise>
                </c:choose>
            </h3>
            <p class="text-muted mb-0">Thiết lập mẫu email với các biến động để sử dụng khi gửi</p>
        </div>
        <a href="${pageContext.request.contextPath}/manager/email#tab-templates" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left me-2"></i>Quay lại
        </a>
    </div>

    <form method="post" action="${pageContext.request.contextPath}/manager/email/template" id="templateForm">
        <c:if test="${isEdit}">
            <input type="hidden" name="templateId" value="${template.templateId}"/>
        </c:if>

        <div class="row g-4">
            <!-- Left: Main info -->
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm">
                    <div class="card-body">
                        <h6 class="fw-bold mb-3">Thông tin cơ bản</h6>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Mã template <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="templateCode"
                                       value="${isEdit ? template.templateCode : ''}"
                                       placeholder="VD: QUOT_SEND" required
                                       style="text-transform: uppercase;"
                                       <c:if test="${isEdit}">readonly</c:if>>
                                <div class="form-text">Mã duy nhất, viết hoa, không dấu, dùng gạch dưới.</div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Tên mẫu <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="templateName"
                                       value="${isEdit ? template.templateName : ''}"
                                       placeholder="VD: Gửi báo giá cho khách hàng" required>
                            </div>
                        </div>

                        <div class="row g-3 mt-1">
                            <div class="col-md-6">
                                <label class="form-label">Danh mục</label>
                                <select class="form-select" name="category">
                                    <option value="General" ${isEdit && template.category == 'General' ? 'selected' : ''}>General</option>
                                    <option value="Quotation" ${isEdit && template.category == 'Quotation' ? 'selected' : ''}>Quotation</option>
                                    <option value="Customer" ${isEdit && template.category == 'Customer' ? 'selected' : ''}>Customer</option>
                                    <option value="Lead" ${isEdit && template.category == 'Lead' ? 'selected' : ''}>Lead</option>
                                    <option value="Task" ${isEdit && template.category == 'Task' ? 'selected' : ''}>Task</option>
                                    <option value="Notification" ${isEdit && template.category == 'Notification' ? 'selected' : ''}>Notification</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Mô tả</label>
                                <input type="text" class="form-control" name="description"
                                       value="${isEdit ? template.description : ''}"
                                       placeholder="Mô tả ngắn về mẫu email">
                            </div>
                        </div>

                        <div class="mt-3">
                            <label class="form-label">Chủ đề email <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="subject"
                                   value="${isEdit ? template.subject : ''}"
                                   placeholder="VD: Báo giá {quotation_code} từ {company_name}" required>
                            <div class="form-text">Có thể sử dụng biến động trong chủ đề, VD: <code>{customer_name}</code></div>
                        </div>

                        <div class="mt-3">
                            <label class="form-label">Nội dung HTML <span class="text-danger">*</span></label>
                            <textarea class="form-control font-monospace" name="bodyHtml" rows="14"
                                      placeholder="<h2>Xin chào {customer_name},</h2>&#10;<p>Nội dung email...</p>" required>${isEdit ? template.bodyHtml : ''}</textarea>
                            <div class="form-text">Hỗ trợ HTML và biến động <code>{variable}</code>. Xem preview ở bên phải.</div>
                        </div>

                        <div class="mt-3">
                            <label class="form-label">Nội dung Text (tùy chọn)</label>
                            <textarea class="form-control font-monospace" name="bodyText" rows="5"
                                      placeholder="Phiên bản plain-text cho email client không hỗ trợ HTML">${isEdit ? template.bodyText : ''}</textarea>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right: Settings & Preview -->
            <div class="col-lg-4">
                <!-- Settings -->
                <div class="card border-0 shadow-sm mb-3">
                    <div class="card-body">
                        <h6 class="fw-bold mb-3">Thiết lập</h6>

                        <div class="form-check form-switch mb-3">
                            <input class="form-check-input" type="checkbox" name="isActive" id="chkActive"
                                   ${!isEdit || template.isActive ? 'checked' : ''}>
                            <label class="form-check-label" for="chkActive">Kích hoạt</label>
                        </div>

                        <div class="form-check form-switch mb-3">
                            <input class="form-check-input" type="checkbox" name="isDefault" id="chkDefault"
                                   ${isEdit && template.isDefault ? 'checked' : ''}>
                            <label class="form-check-label" for="chkDefault">Mẫu mặc định</label>
                            <div class="form-text">Mẫu mặc định sẽ được dùng tự động khi gửi email cho danh mục tương ứng.</div>
                        </div>

                        <div class="mt-3">
                            <label class="form-label fw-semibold">Phân quyền sử dụng</label>
                            <div class="form-text mb-2">Chọn vai trò được phép dùng mẫu này. Không chọn = tất cả đều dùng được.</div>
                            <div class="form-check mb-1">
                                <input class="form-check-input" type="checkbox" name="allowedRoles" value="MANAGER" id="roleMgr"
                                       ${isEdit && template.allowedRoles != null && template.allowedRoles.contains('MANAGER') ? 'checked' : ''}>
                                <label class="form-check-label" for="roleMgr">Manager</label>
                            </div>
                            <div class="form-check mb-1">
                                <input class="form-check-input" type="checkbox" name="allowedRoles" value="SALES" id="roleSale"
                                       ${isEdit && template.allowedRoles != null && template.allowedRoles.contains('SALES') ? 'checked' : ''}>
                                <label class="form-check-label" for="roleSale">Sales</label>
                            </div>
                            <div class="form-check mb-1">
                                <input class="form-check-input" type="checkbox" name="allowedRoles" value="SUPPORT" id="roleSupport"
                                       ${isEdit && template.allowedRoles != null && template.allowedRoles.contains('SUPPORT') ? 'checked' : ''}>
                                <label class="form-check-label" for="roleSupport">Support</label>
                            </div>
                            <div class="form-check mb-1">
                                <input class="form-check-input" type="checkbox" name="allowedRoles" value="MARKETING" id="roleMkt"
                                       ${isEdit && template.allowedRoles != null && template.allowedRoles.contains('MARKETING') ? 'checked' : ''}>
                                <label class="form-check-label" for="roleMkt">Marketing</label>
                            </div>
                        </div>

                        <div class="mt-3">
                            <label class="form-label">Biến động có sẵn</label>
                            <textarea class="form-control" name="availableVariables" rows="3"
                                      placeholder="customer_name, quotation_code, total_amount">${isEdit ? template.availableVariables : ''}</textarea>
                            <div class="form-text">Danh sách biến cách nhau bởi dấu phẩy. Các biến sẽ hiện dưới dạng badge.</div>
                        </div>
                    </div>
                </div>

                <!-- Variable badges -->
                <div class="card border-0 shadow-sm mb-3">
                    <div class="card-body">
                        <h6 class="fw-bold mb-3">Biến động</h6>
                        <div id="variableBadges" class="d-flex flex-wrap gap-2">
                            <span class="text-muted small">Nhập biến ở trên để hiện tại đây</span>
                        </div>
                        <div class="small text-muted mt-2">Nhấn vào biến để copy vào clipboard.</div>
                    </div>
                </div>

                <!-- Preview -->
                <div class="card border-0 shadow-sm">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h6 class="fw-bold mb-0">Xem trước</h6>
                            <button type="button" class="btn btn-sm btn-outline-primary" onclick="refreshPreview()">
                                <i class="bi bi-arrow-clockwise me-1"></i>Refresh
                            </button>
                        </div>
                        <div id="previewSubject" class="fw-bold small mb-2 text-muted">(Chủ đề)</div>
                        <div id="previewBody" class="border rounded p-3 bg-white small" style="max-height: 300px; overflow-y: auto;">
                            <span class="text-muted">(Nội dung HTML sẽ hiển thị ở đây)</span>
                        </div>
                    </div>
                </div>

                <!-- Actions -->
                <div class="d-grid gap-2 mt-3">
                    <button type="submit" class="btn btn-primary btn-lg">
                        <i class="bi bi-save me-2"></i>
                        <c:choose>
                            <c:when test="${isEdit}">Cập nhật mẫu</c:when>
                            <c:otherwise>Tạo mẫu email</c:otherwise>
                        </c:choose>
                    </button>
                    <a href="${pageContext.request.contextPath}/manager/email#tab-templates" class="btn btn-outline-secondary">
                        Hủy bỏ
                    </a>
                </div>
            </div>
        </div>
    </form>
</div>

<script>
    // Variable badges from textarea
    const varInput = document.querySelector('textarea[name="availableVariables"]');
    const badgeContainer = document.getElementById('variableBadges');

    function updateBadges() {
        const val = varInput.value.trim();
        if (!val) {
            badgeContainer.innerHTML = '<span class="text-muted small">Nhập biến ở trên để hiện tại đây</span>';
            return;
        }
        const vars = val.split(',').map(v => v.trim()).filter(v => v);
        badgeContainer.innerHTML = vars.map(v =>
            '<span class="badge bg-light text-dark border" style="cursor:pointer;" onclick="copyVar(\'' + v + '\')">{' + v + '}</span>'
        ).join('');
    }

    varInput.addEventListener('input', updateBadges);
    updateBadges();

    function copyVar(name) {
        navigator.clipboard.writeText('{' + name + '}');
        // Brief visual feedback
        const el = event.target;
        const orig = el.textContent;
        el.textContent = 'Copied!';
        el.classList.replace('bg-light', 'bg-success');
        el.classList.replace('text-dark', 'text-white');
        setTimeout(() => {
            el.textContent = orig;
            el.classList.replace('bg-success', 'bg-light');
            el.classList.replace('text-white', 'text-dark');
        }, 800);
    }

    // Preview
    function refreshPreview() {
        const subject = document.querySelector('input[name="subject"]').value || '(Chủ đề)';
        const bodyHtml = document.querySelector('textarea[name="bodyHtml"]').value || '<span class="text-muted">(Nội dung HTML)</span>';

        document.getElementById('previewSubject').textContent = subject;
        document.getElementById('previewBody').innerHTML = bodyHtml;
    }

    // Auto-refresh preview on typing
    let previewTimer;
    document.querySelector('textarea[name="bodyHtml"]').addEventListener('input', () => {
        clearTimeout(previewTimer);
        previewTimer = setTimeout(refreshPreview, 500);
    });
    document.querySelector('input[name="subject"]').addEventListener('input', () => {
        clearTimeout(previewTimer);
        previewTimer = setTimeout(refreshPreview, 300);
    });

    // Initial preview if editing
    <c:if test="${isEdit}">
    refreshPreview();
    </c:if>

    // Auto uppercase template code
    const codeInput = document.querySelector('input[name="templateCode"]');
    if (codeInput && !codeInput.readOnly) {
        codeInput.addEventListener('input', function() {
            this.value = this.value.toUpperCase().replace(/[^A-Z0-9_]/g, '');
        });
    }
</script>
