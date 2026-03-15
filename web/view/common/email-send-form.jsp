<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid">
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

    <c:if test="${!smtpConfigured}">
        <div class="alert alert-warning" role="alert">
            <i class="bi bi-exclamation-triangle me-2"></i>
            Hệ thống email chưa được cấu hình. Vui lòng liên hệ quản lý để thiết lập.
        </div>
    </c:if>

    <!-- Header -->
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <h3 class="mb-1"><i class="bi bi-send me-2"></i>Gửi Email</h3>
            <p class="text-muted mb-0">Soạn và gửi email cho lead/khách hàng</p>
        </div>
        <a href="${backUrl}" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left me-2"></i>Quay lại
        </a>
    </div>

    <form method="post" action="${formAction}" id="sendForm">
        <input type="hidden" name="bodyHtml" id="finalBodyHtml">

        <div class="row g-4">
            <!-- Left -->
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm mb-3">
                    <div class="card-body">
                        <h6 class="fw-bold mb-3">Thông tin người nhận</h6>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Email người nhận <span class="text-danger">*</span></label>
                                <input type="email" class="form-control" name="toEmail" placeholder="email@domain.com" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Tên người nhận</label>
                                <input type="text" class="form-control" name="toName" placeholder="Nguyễn Văn A">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">CC <span class="text-muted fw-normal">(tùy chọn)</span></label>
                                <input type="text" class="form-control" name="ccEmails" placeholder="cc1@domain.com, cc2@domain.com">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">BCC <span class="text-muted fw-normal">(tùy chọn)</span></label>
                                <input type="text" class="form-control" name="bccEmails" placeholder="bcc@domain.com">
                            </div>
                            <c:if test="${showRelated}">
                                <div class="col-md-6">
                                    <label class="form-label">Liên kết với</label>
                                    <select class="form-select" name="relatedType">
                                        <option value="">-- Không liên kết --</option>
                                        <option value="Customer">Customer</option>
                                        <option value="Lead">Lead</option>
                                        <option value="Opportunity">Opportunity</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">ID liên kết</label>
                                    <input type="number" class="form-control" name="relatedId" placeholder="ID của Customer/Lead/Opportunity">
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <div class="card border-0 shadow-sm mb-3">
                    <div class="card-body">
                        <label class="form-label fw-bold">Chủ đề email <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="subject" id="inputSubject"
                               placeholder="Nhập tiêu đề email" required>
                    </div>
                </div>

                <div class="card border-0 shadow-sm">
                    <div class="card-body">
                        <div id="templateMode" class="d-none">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h6 class="fw-bold mb-0"><i class="bi bi-eye me-2"></i>Xem trước nội dung email</h6>
                                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="toggleSource()">
                                    <i class="bi bi-code-slash me-1"></i><span id="toggleLabel">Xem HTML</span>
                                </button>
                            </div>
                            <div id="previewContainer" class="border rounded p-4 bg-white" style="min-height:200px;"></div>
                            <div id="sourceContainer" class="d-none">
                                <textarea class="form-control font-monospace" id="sourceEditor" rows="14"></textarea>
                            </div>
                        </div>
                        <div id="manualMode">
                            <h6 class="fw-bold mb-3">Nội dung email</h6>
                            <textarea class="form-control font-monospace" id="manualBody" rows="14"
                                      placeholder="Nhập nội dung HTML hoặc text..."></textarea>
                        </div>
                    </div>
                </div>

                <div class="mt-3 d-flex gap-2">
                    <button type="submit" class="btn btn-primary btn-lg" ${!smtpConfigured ? 'disabled' : ''}>
                        <i class="bi bi-send-check me-2"></i>Gửi email
                    </button>
                    <a href="${backUrl}" class="btn btn-outline-secondary btn-lg">Hủy bỏ</a>
                </div>
            </div>

            <!-- Right -->
            <div class="col-lg-4">
                <div class="card border-0 shadow-sm mb-3">
                    <div class="card-body">
                        <h6 class="fw-bold mb-3"><i class="bi bi-file-earmark-code me-2"></i>Chọn mẫu email</h6>
                        <select class="form-select" id="templateSelect">
                            <option value="">-- Soạn thủ công --</option>
                            <c:forEach var="t" items="${templates}">
                                <option value="${t.templateId}">
                                    ${t.templateName} (${t.category})
                                </option>
                            </c:forEach>
                        </select>
                        <div id="templateLoading" class="text-center py-2 d-none">
                            <div class="spinner-border spinner-border-sm text-primary"></div>
                            <span class="ms-2 small">Đang tải mẫu...</span>
                        </div>
                    </div>
                </div>

                <div class="card border-0 shadow-sm mb-3 d-none" id="variablesCard">
                    <div class="card-body">
                        <h6 class="fw-bold mb-3"><i class="bi bi-input-cursor-text me-2"></i>Điền thông tin</h6>
                        <div id="variableInputs"></div>
                    </div>
                </div>

                <div class="card border-0 shadow-sm">
                    <div class="card-body">
                        <h6 class="fw-bold mb-3"><i class="bi bi-gear me-2"></i>Thiết lập gửi</h6>
                        <div class="mb-3">
                            <label class="form-label">Email gửi (From)</label>
                            <input type="email" class="form-control" name="fromEmail" placeholder="Mặc định: email đã cấu hình">
                            <div class="form-text">Để trống sẽ dùng email SMTP đã cấu hình.</div>
                        </div>
                        <div>
                            <label class="form-label">Tên người gửi</label>
                            <input type="text" class="form-control" name="fromName" placeholder="Mặc định: CRM System">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>

<script>
(function() {
    var apiUrl = '${templateApiUrl}';
    var templateSelect = document.getElementById('templateSelect');
    var loadingEl = document.getElementById('templateLoading');
    var variablesCard = document.getElementById('variablesCard');
    var variableInputs = document.getElementById('variableInputs');
    var inputSubject = document.getElementById('inputSubject');

    var templateSubject = '', templateBodyHtml = '', templateVars = [];
    var isTemplateMode = false, showingSource = false;

    var varLabels = {
        'customer_name': 'Tên khách hàng', 'customer_code': 'Mã khách hàng',
        'quotation_code': 'Mã báo giá', 'total_amount': 'Tổng giá trị',
        'currency': 'Đơn vị tiền', 'valid_until': 'Hiệu lực đến',
        'company_name': 'Tên công ty', 'sales_name': 'Tên nhân viên',
        'lead_name': 'Tên lead', 'phone': 'Số điện thoại',
        'email': 'Email', 'address': 'Địa chỉ',
        'product_name': 'Tên sản phẩm', 'order_number': 'Mã đơn hàng'
    };

    function getVarLabel(v) {
        return varLabels[v] || v.replace(/_/g, ' ').replace(/\b\w/g, function(c) { return c.toUpperCase(); });
    }

    templateSelect.addEventListener('change', function() {
        var id = this.value;
        if (!id) { switchToManualMode(); return; }

        loadingEl.classList.remove('d-none');
        fetch(apiUrl + '&id=' + id)
            .then(function(r) { return r.json(); })
            .then(function(data) {
                loadingEl.classList.add('d-none');
                if (data.error) { alert('Lỗi: ' + data.error); return; }
                templateSubject = data.subject || '';
                templateBodyHtml = data.bodyHtml || '';
                templateVars = data.variables ? data.variables.split(',').map(function(v) { return v.trim(); }).filter(function(v) { return v; }) : [];
                switchToTemplateMode();
            })
            .catch(function() { loadingEl.classList.add('d-none'); });
    });

    function switchToTemplateMode() {
        isTemplateMode = true; showingSource = false;
        document.getElementById('templateMode').classList.remove('d-none');
        document.getElementById('manualMode').classList.add('d-none');
        document.getElementById('previewContainer').classList.remove('d-none');
        document.getElementById('sourceContainer').classList.add('d-none');
        document.getElementById('toggleLabel').textContent = 'Xem HTML';

        if (templateVars.length > 0) {
            variablesCard.classList.remove('d-none');
            var html = '';
            for (var i = 0; i < templateVars.length; i++) {
                var v = templateVars[i];
                html += '<div class="mb-3">'
                    + '<label class="form-label small fw-semibold">' + getVarLabel(v) + ' <code class="fw-normal text-muted">{' + v + '}</code></label>'
                    + '<input type="text" class="form-control var-input" data-var="' + v + '" placeholder="Nhập ' + getVarLabel(v).toLowerCase() + '...">'
                    + '</div>';
            }
            variableInputs.innerHTML = html;
            var inputs = variableInputs.querySelectorAll('.var-input');
            for (var j = 0; j < inputs.length; j++) { inputs[j].addEventListener('input', updatePreview); }
        } else {
            variablesCard.classList.add('d-none');
        }
        updatePreview();
    }

    function switchToManualMode() {
        isTemplateMode = false; templateSubject = ''; templateBodyHtml = ''; templateVars = [];
        document.getElementById('templateMode').classList.add('d-none');
        document.getElementById('manualMode').classList.remove('d-none');
        variablesCard.classList.add('d-none');
        inputSubject.value = '';
    }

    function getVariableValues() {
        var values = {};
        var inputs = variableInputs.querySelectorAll('.var-input');
        for (var i = 0; i < inputs.length; i++) {
            values[inputs[i].getAttribute('data-var')] = inputs[i].value;
        }
        return values;
    }

    function replaceVars(template, values) {
        var result = template;
        for (var key in values) {
            var val = values[key];
            if (val) {
                result = result.split('{' + key + '}').join(val);
                result = result.split('{{' + key + '}}').join(val);
            } else {
                var placeholder = '<span style="background:#fef3c7;padding:1px 4px;border-radius:3px;color:#92400e;font-size:0.9em;">{' + key + '}</span>';
                result = result.split('{' + key + '}').join(placeholder);
                result = result.split('{{' + key + '}}').join(placeholder);
            }
        }
        return result;
    }

    function replaceVarsClean(template, values) {
        var result = template;
        for (var key in values) {
            var val = values[key] || '';
            result = result.split('{' + key + '}').join(val);
            result = result.split('{{' + key + '}}').join(val);
        }
        return result;
    }

    function updatePreview() {
        var values = getVariableValues();
        inputSubject.value = replaceVarsClean(templateSubject, values);
        document.getElementById('previewContainer').innerHTML = replaceVars(templateBodyHtml, values);
        if (showingSource) document.getElementById('sourceEditor').value = replaceVarsClean(templateBodyHtml, values);
    }

    window.toggleSource = function() {
        showingSource = !showingSource;
        if (showingSource) {
            document.getElementById('previewContainer').classList.add('d-none');
            document.getElementById('sourceContainer').classList.remove('d-none');
            document.getElementById('toggleLabel').textContent = 'Xem trước';
            document.getElementById('sourceEditor').value = replaceVarsClean(templateBodyHtml, getVariableValues());
        } else {
            templateBodyHtml = document.getElementById('sourceEditor').value;
            document.getElementById('sourceContainer').classList.add('d-none');
            document.getElementById('previewContainer').classList.remove('d-none');
            document.getElementById('toggleLabel').textContent = 'Xem HTML';
            updatePreview();
        }
    };

    document.getElementById('sendForm').addEventListener('submit', function() {
        var finalHtml;
        if (isTemplateMode) {
            if (showingSource) templateBodyHtml = document.getElementById('sourceEditor').value;
            finalHtml = replaceVarsClean(templateBodyHtml, getVariableValues());
        } else {
            finalHtml = document.getElementById('manualBody').value;
        }
        document.getElementById('finalBodyHtml').value = finalHtml;
    });
})();
</script>
