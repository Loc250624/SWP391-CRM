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
            <p class="text-muted mb-0">Soạn và gửi email cho lead/khách hàng/nhân viên</p>
        </div>
        <a href="${backUrl}" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left me-2"></i>Quay lại
        </a>
    </div>

    <form method="post" action="${formAction}" id="sendForm">
        <input type="hidden" name="bodyHtml" id="finalBodyHtml">
        <!-- Hidden inputs for multi-recipient data (JSON) -->
        <input type="hidden" name="recipientsJson" id="recipientsJson">

        <div class="row g-4">
            <!-- Left -->
            <div class="col-lg-8">
                <!-- Selected recipients display -->
                <div class="card border-0 shadow-sm mb-3">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h6 class="fw-bold mb-0"><i class="bi bi-people me-2"></i>Người nhận <span class="badge bg-primary ms-1" id="recipientCount">0</span></h6>
                            <button type="button" class="btn btn-sm btn-outline-danger d-none" id="btnClearAll" onclick="clearAllRecipients()">
                                <i class="bi bi-x-lg me-1"></i>Xóa tất cả
                            </button>
                        </div>
                        <div id="selectedRecipients">
                            <div class="text-muted small" id="noRecipientMsg">
                                <i class="bi bi-info-circle me-1"></i>Chưa chọn người nhận. Vui lòng chọn từ danh sách bên phải.
                            </div>
                        </div>
                        <!-- Manual add row -->
                        <div class="mt-3 pt-3 border-top">
                            <div class="row g-2 align-items-end">
                                <div class="col">
                                    <label class="form-label small">Thêm email thủ công</label>
                                    <input type="email" class="form-control form-control-sm" id="manualEmail" placeholder="email@domain.com">
                                </div>
                                <div class="col">
                                    <label class="form-label small">Tên (tùy chọn)</label>
                                    <input type="text" class="form-control form-control-sm" id="manualName" placeholder="Nguyễn Văn A">
                                </div>
                                <div class="col-auto">
                                    <button type="button" class="btn btn-sm btn-outline-primary" onclick="addManualRecipient()">
                                        <i class="bi bi-plus-lg"></i>
                                    </button>
                                </div>
                            </div>
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
                            <div class="form-text mt-2">
                                <i class="bi bi-info-circle me-1"></i>Các biến như <code>{customer_name}</code> sẽ được thay thế tự động cho từng người nhận khi gửi.
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
                    <button type="submit" class="btn btn-primary btn-lg" id="btnSend" ${!smtpConfigured ? 'disabled' : ''}>
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

                <!-- Recipient picker with checkboxes -->
                <div class="card border-0 shadow-sm mb-3">
                    <div class="card-body">
                        <h6 class="fw-bold mb-3"><i class="bi bi-person-plus me-2"></i>Chọn người nhận</h6>
                        <input type="text" class="form-control form-control-sm mb-2" id="recipientSearch"
                               placeholder="Tìm kiếm theo tên, email...">

                        <div style="max-height: 400px; overflow-y: auto;" id="recipientList">
                            <!-- Customers -->
                            <c:if test="${not empty customers}">
                                <div class="recipient-group" data-group-type="customer">
                                    <div class="d-flex justify-content-between align-items-center py-1 px-2 bg-light rounded mb-1 sticky-top">
                                        <strong class="small text-primary"><i class="bi bi-people me-1"></i>Khách hàng</strong>
                                        <button type="button" class="btn btn-link btn-sm p-0 text-primary" onclick="toggleGroup('customer')">Chọn tất cả</button>
                                    </div>
                                    <c:forEach var="c" items="${customers}">
                                        <c:if test="${not empty c.email}">
                                            <div class="form-check py-1 px-2 recipient-item" data-search="${c.fullName} ${c.email} ${c.customerCode}">
                                                <input class="form-check-input recipient-cb" type="checkbox" id="cb_cus_${c.customerId}"
                                                       data-group="customer"
                                                       data-type="Customer" data-id="${c.customerId}"
                                                       data-email="${c.email}" data-name="${c.fullName}"
                                                       data-phone="${c.phone}" data-code="${c.customerCode}"
                                                       onchange="onRecipientToggle(this)">
                                                <label class="form-check-label small w-100" for="cb_cus_${c.customerId}" style="cursor:pointer">
                                                    ${c.fullName}
                                                    <br><span class="text-muted" style="font-size:0.8em">${c.email}</span>
                                                </label>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </c:if>

                            <!-- Leads -->
                            <c:if test="${not empty leads}">
                                <div class="recipient-group mt-2" data-group-type="lead">
                                    <div class="d-flex justify-content-between align-items-center py-1 px-2 bg-light rounded mb-1 sticky-top">
                                        <strong class="small text-success"><i class="bi bi-funnel me-1"></i>Lead</strong>
                                        <button type="button" class="btn btn-link btn-sm p-0 text-success" onclick="toggleGroup('lead')">Chọn tất cả</button>
                                    </div>
                                    <c:forEach var="l" items="${leads}">
                                        <c:if test="${not empty l.email}">
                                            <div class="form-check py-1 px-2 recipient-item" data-search="${l.fullName} ${l.email} ${l.leadCode}">
                                                <input class="form-check-input recipient-cb" type="checkbox" id="cb_lead_${l.leadId}"
                                                       data-group="lead"
                                                       data-type="Lead" data-id="${l.leadId}"
                                                       data-email="${l.email}" data-name="${l.fullName}"
                                                       data-phone="${l.phone}" data-code="${l.leadCode}"
                                                       data-company="${l.companyName}"
                                                       onchange="onRecipientToggle(this)">
                                                <label class="form-check-label small w-100" for="cb_lead_${l.leadId}" style="cursor:pointer">
                                                    ${l.fullName}
                                                    <br><span class="text-muted" style="font-size:0.8em">${l.email}</span>
                                                </label>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </c:if>

                            <!-- Sale Staff -->
                            <c:if test="${not empty saleUsers}">
                                <div class="recipient-group mt-2" data-group-type="sale">
                                    <div class="d-flex justify-content-between align-items-center py-1 px-2 bg-light rounded mb-1 sticky-top">
                                        <strong class="small text-warning"><i class="bi bi-briefcase me-1"></i>Nhân viên Sale</strong>
                                        <button type="button" class="btn btn-link btn-sm p-0 text-warning" onclick="toggleGroup('sale')">Chọn tất cả</button>
                                    </div>
                                    <c:forEach var="u" items="${saleUsers}">
                                        <c:if test="${not empty u.email}">
                                            <div class="form-check py-1 px-2 recipient-item" data-search="${u.firstName} ${u.lastName} ${u.email}">
                                                <input class="form-check-input recipient-cb" type="checkbox" id="cb_sale_${u.userId}"
                                                       data-group="sale"
                                                       data-type="User" data-id="${u.userId}"
                                                       data-email="${u.email}" data-name="${u.firstName} ${u.lastName}"
                                                       data-phone="${u.phone}" data-code="${u.employeeCode}"
                                                       onchange="onRecipientToggle(this)">
                                                <label class="form-check-label small w-100" for="cb_sale_${u.userId}" style="cursor:pointer">
                                                    ${u.firstName} ${u.lastName}
                                                    <br><span class="text-muted" style="font-size:0.8em">${u.email}</span>
                                                </label>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </c:if>

                            <!-- Customer Success / Support Staff -->
                            <c:if test="${not empty supportUsers}">
                                <div class="recipient-group mt-2" data-group-type="support">
                                    <div class="d-flex justify-content-between align-items-center py-1 px-2 bg-light rounded mb-1 sticky-top">
                                        <strong class="small text-info"><i class="bi bi-headset me-1"></i>Customer Success</strong>
                                        <button type="button" class="btn btn-link btn-sm p-0 text-info" onclick="toggleGroup('support')">Chọn tất cả</button>
                                    </div>
                                    <c:forEach var="u" items="${supportUsers}">
                                        <c:if test="${not empty u.email}">
                                            <div class="form-check py-1 px-2 recipient-item" data-search="${u.firstName} ${u.lastName} ${u.email}">
                                                <input class="form-check-input recipient-cb" type="checkbox" id="cb_sup_${u.userId}"
                                                       data-group="support"
                                                       data-type="User" data-id="${u.userId}"
                                                       data-email="${u.email}" data-name="${u.firstName} ${u.lastName}"
                                                       data-phone="${u.phone}" data-code="${u.employeeCode}"
                                                       onchange="onRecipientToggle(this)">
                                                <label class="form-check-label small w-100" for="cb_sup_${u.userId}" style="cursor:pointer">
                                                    ${u.firstName} ${u.lastName}
                                                    <br><span class="text-muted" style="font-size:0.8em">${u.email}</span>
                                                </label>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- Unmapped variables -->
                <div class="card border-0 shadow-sm mb-3 d-none" id="variablesCard">
                    <div class="card-body">
                        <h6 class="fw-bold mb-3"><i class="bi bi-input-cursor-text me-2"></i>Thông tin bổ sung</h6>
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
    var templateCategory = '', templateCode = '';
    var isTemplateMode = false, showingSource = false;

    // Multi-recipient state: [{email, name, type, id, phone, code, company}, ...]
    var recipients = [];

    var varLabels = {
        'customer_name': 'Tên khách hàng', 'customer_code': 'Mã khách hàng',
        'quotation_code': 'Mã báo giá', 'total_amount': 'Tổng giá trị',
        'currency': 'Đơn vị tiền', 'valid_until': 'Hiệu lực đến',
        'company_name': 'Tên công ty', 'sales_name': 'Tên nhân viên',
        'lead_name': 'Tên lead', 'phone': 'Số điện thoại',
        'email': 'Email', 'address': 'Địa chỉ', 'name': 'Tên',
        'staff_name': 'Tên nhân viên', 'employee_code': 'Mã nhân viên',
        'product_name': 'Tên sản phẩm', 'order_number': 'Mã đơn hàng'
    };

    function getVarLabel(v) {
        return varLabels[v] || v.replace(/_/g, ' ').replace(/\b\w/g, function(c) { return c.toUpperCase(); });
    }

    // ── Recipient management ──

    window.onRecipientToggle = function(cb) {
        var email = cb.getAttribute('data-email');
        if (cb.checked) {
            recipients.push({
                email: email,
                name: cb.getAttribute('data-name') || '',
                type: cb.getAttribute('data-type') || '',
                id: cb.getAttribute('data-id') || '',
                phone: cb.getAttribute('data-phone') || '',
                code: cb.getAttribute('data-code') || '',
                company: cb.getAttribute('data-company') || ''
            });
        } else {
            recipients = recipients.filter(function(r) { return r.email !== email; });
        }
        renderSelectedRecipients();
        updatePreview();
    };

    window.addManualRecipient = function() {
        var emailInput = document.getElementById('manualEmail');
        var nameInput = document.getElementById('manualName');
        var email = emailInput.value.trim();
        if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
            emailInput.classList.add('is-invalid');
            return;
        }
        emailInput.classList.remove('is-invalid');

        // Check duplicate
        if (recipients.some(function(r) { return r.email === email; })) {
            alert('Email này đã có trong danh sách');
            return;
        }

        recipients.push({
            email: email,
            name: nameInput.value.trim(),
            type: 'Manual', id: '', phone: '', code: '', company: ''
        });
        emailInput.value = '';
        nameInput.value = '';
        renderSelectedRecipients();
    };

    window.removeRecipient = function(email) {
        recipients = recipients.filter(function(r) { return r.email !== email; });
        // Uncheck corresponding checkbox
        var cbs = document.querySelectorAll('.recipient-cb');
        for (var i = 0; i < cbs.length; i++) {
            if (cbs[i].getAttribute('data-email') === email) {
                cbs[i].checked = false;
            }
        }
        renderSelectedRecipients();
        updatePreview();
    };

    window.clearAllRecipients = function() {
        recipients = [];
        var cbs = document.querySelectorAll('.recipient-cb');
        for (var i = 0; i < cbs.length; i++) { cbs[i].checked = false; }
        renderSelectedRecipients();
        updatePreview();
    };

    window.toggleGroup = function(group) {
        var cbs = document.querySelectorAll('.recipient-cb[data-group="' + group + '"]');
        // If all checked → uncheck all, else check all
        var allChecked = true;
        for (var i = 0; i < cbs.length; i++) {
            if (!cbs[i].checked && cbs[i].closest('.recipient-item').style.display !== 'none') {
                allChecked = false; break;
            }
        }
        for (var j = 0; j < cbs.length; j++) {
            if (cbs[j].closest('.recipient-item').style.display !== 'none') {
                if (allChecked) {
                    if (cbs[j].checked) { cbs[j].checked = false; onRecipientToggle(cbs[j]); }
                } else {
                    if (!cbs[j].checked) { cbs[j].checked = true; onRecipientToggle(cbs[j]); }
                }
            }
        }
    };

    function renderSelectedRecipients() {
        var container = document.getElementById('selectedRecipients');
        var noMsg = document.getElementById('noRecipientMsg');
        var countEl = document.getElementById('recipientCount');
        var clearBtn = document.getElementById('btnClearAll');
        var btnSend = document.getElementById('btnSend');

        countEl.textContent = recipients.length;

        if (recipients.length === 0) {
            noMsg.classList.remove('d-none');
            clearBtn.classList.add('d-none');
            // Remove all tags
            var tags = container.querySelectorAll('.recipient-tag');
            for (var i = 0; i < tags.length; i++) tags[i].remove();
            btnSend.textContent = '';
            btnSend.innerHTML = '<i class="bi bi-send-check me-2"></i>Gửi email';
            return;
        }

        noMsg.classList.add('d-none');
        clearBtn.classList.remove('d-none');

        var html = '<div class="d-flex flex-wrap gap-1">';
        for (var i = 0; i < recipients.length; i++) {
            var r = recipients[i];
            var typeIcon = r.type === 'Customer' ? 'bi-person' : r.type === 'Lead' ? 'bi-funnel' : r.type === 'User' ? 'bi-briefcase' : 'bi-envelope';
            var typeBg = r.type === 'Customer' ? 'primary' : r.type === 'Lead' ? 'success' : r.type === 'User' ? 'warning' : 'secondary';
            html += '<span class="badge bg-' + typeBg + ' bg-opacity-10 text-' + typeBg + ' border border-' + typeBg + ' border-opacity-25 recipient-tag" style="font-size:0.8em">'
                + '<i class="bi ' + typeIcon + ' me-1"></i>'
                + (r.name || r.email)
                + '<button type="button" class="btn-close btn-close-sm ms-1" style="font-size:0.6em" onclick="removeRecipient(\'' + r.email.replace(/'/g, "\\'") + '\')"></button>'
                + '</span>';
        }
        html += '</div>';

        // Keep noMsg and manual row, replace tags area
        var existingTags = container.querySelector('.d-flex.flex-wrap');
        if (existingTags) existingTags.remove();
        noMsg.insertAdjacentHTML('afterend', html);

        btnSend.innerHTML = '<i class="bi bi-send-check me-2"></i>Gửi email (' + recipients.length + ' người)';
    }

    // ── Search filter ──
    document.getElementById('recipientSearch').addEventListener('input', function() {
        var query = this.value.toLowerCase();
        var items = document.querySelectorAll('.recipient-item');
        for (var i = 0; i < items.length; i++) {
            var searchText = (items[i].getAttribute('data-search') || '').toLowerCase();
            items[i].style.display = (!query || searchText.indexOf(query) !== -1) ? '' : 'none';
        }
    });

    // ── Filter recipient groups based on template ──

    function filterRecipientGroups() {
        var groups = document.querySelectorAll('.recipient-group');
        if (!templateCategory) {
            // No template / manual → show all
            for (var i = 0; i < groups.length; i++) groups[i].style.display = '';
            return;
        }

        var cat = templateCategory.toLowerCase();
        var code = templateCode.toLowerCase();

        for (var i = 0; i < groups.length; i++) {
            var gType = groups[i].getAttribute('data-group-type');
            var show = false;

            if (cat === 'customer' || cat === 'quotation') {
                show = (gType === 'customer');
            } else if (cat === 'lead') {
                show = (gType === 'lead');
            } else if (cat === 'internal') {
                if (code.indexOf('sale_') === 0) {
                    show = (gType === 'sale');
                } else if (code.indexOf('cs_') === 0) {
                    show = (gType === 'support');
                } else {
                    // TEAM_ANNOUNCE etc → show all staff
                    show = (gType === 'sale' || gType === 'support');
                }
            } else {
                show = true;
            }

            groups[i].style.display = show ? '' : 'none';
        }

        // Clear selected recipients from hidden groups
        var cbs = document.querySelectorAll('.recipient-cb:checked');
        for (var j = 0; j < cbs.length; j++) {
            var grp = cbs[j].closest('.recipient-group');
            if (grp && grp.style.display === 'none') {
                cbs[j].checked = false;
                onRecipientToggle(cbs[j]);
            }
        }
    }

    // ── Template handling ──

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
                templateCategory = data.category || '';
                templateCode = data.code || '';
                templateVars = data.variables ? data.variables.split(',').map(function(v) { return v.trim(); }).filter(function(v) { return v; }) : [];
                filterRecipientGroups();
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
        showVariableInputs();
        updatePreview();
    }

    // Auto-mapped variables from recipient data
    var autoVarKeys = ['customer_name','customer_code','lead_name','company_name','phone','email','name','staff_name','employee_code'];

    function showVariableInputs() {
        if (!isTemplateMode || templateVars.length === 0) {
            variablesCard.classList.add('d-none');
            return;
        }
        // Show only variables that CAN'T be auto-filled from recipient
        var unmapped = templateVars.filter(function(v) { return autoVarKeys.indexOf(v) === -1; });
        if (unmapped.length === 0) { variablesCard.classList.add('d-none'); return; }

        variablesCard.classList.remove('d-none');
        var html = '';
        for (var i = 0; i < unmapped.length; i++) {
            var v = unmapped[i];
            html += '<div class="mb-3">'
                + '<label class="form-label small fw-semibold">' + getVarLabel(v) + ' <code class="fw-normal text-muted">{' + v + '}</code></label>'
                + '<input type="text" class="form-control var-input" data-var="' + v + '" placeholder="Nhập ' + getVarLabel(v).toLowerCase() + '...">'
                + '</div>';
        }
        variableInputs.innerHTML = html;
        var inputs = variableInputs.querySelectorAll('.var-input');
        for (var j = 0; j < inputs.length; j++) { inputs[j].addEventListener('input', updatePreview); }
    }

    function switchToManualMode() {
        isTemplateMode = false; templateSubject = ''; templateBodyHtml = ''; templateVars = [];
        templateCategory = ''; templateCode = '';
        document.getElementById('templateMode').classList.add('d-none');
        document.getElementById('manualMode').classList.remove('d-none');
        variablesCard.classList.add('d-none');
        inputSubject.value = '';
        filterRecipientGroups();
    }

    // Build variable values from first recipient (for preview) + manual inputs
    function getVariableValues() {
        var values = {};
        // From first recipient (for preview)
        if (recipients.length > 0) {
            var r = recipients[0];
            values['customer_name'] = r.name || '';
            values['customer_code'] = r.code || '';
            values['lead_name'] = r.name || '';
            values['staff_name'] = r.name || '';
            values['employee_code'] = r.code || '';
            values['company_name'] = r.company || '';
            values['phone'] = r.phone || '';
            values['email'] = r.email || '';
            values['name'] = r.name || '';
        }
        // From manual inputs
        var inputs = variableInputs.querySelectorAll('.var-input');
        for (var i = 0; i < inputs.length; i++) {
            var val = inputs[i].value;
            if (val) values[inputs[i].getAttribute('data-var')] = val;
        }
        return values;
    }

    // Build variable values for a specific recipient
    function getValuesForRecipient(r) {
        var values = {};
        values['customer_name'] = r.name || '';
        values['customer_code'] = r.code || '';
        values['lead_name'] = r.name || '';
        values['staff_name'] = r.name || '';
        values['employee_code'] = r.code || '';
        values['company_name'] = r.company || '';
        values['phone'] = r.phone || '';
        values['email'] = r.email || '';
        values['name'] = r.name || '';
        // Add manual inputs
        var inputs = variableInputs.querySelectorAll('.var-input');
        for (var i = 0; i < inputs.length; i++) {
            var val = inputs[i].value;
            if (val) values[inputs[i].getAttribute('data-var')] = val;
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
                var ph = '<span style="background:#fef3c7;padding:1px 4px;border-radius:3px;color:#92400e;font-size:0.9em;">{' + key + '}</span>';
                result = result.split('{' + key + '}').join(ph);
                result = result.split('{{' + key + '}}').join(ph);
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
        if (!isTemplateMode) return;
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

    // ── Form submit ──
    document.getElementById('sendForm').addEventListener('submit', function(e) {
        if (recipients.length === 0) {
            e.preventDefault();
            alert('Vui lòng chọn ít nhất một người nhận');
            return;
        }

        // Build per-recipient data with resolved body
        var data = [];
        for (var i = 0; i < recipients.length; i++) {
            var r = recipients[i];
            var bodyHtml;
            if (isTemplateMode) {
                if (showingSource) templateBodyHtml = document.getElementById('sourceEditor').value;
                bodyHtml = replaceVarsClean(templateBodyHtml, getValuesForRecipient(r));
            } else {
                bodyHtml = document.getElementById('manualBody').value;
            }
            var subjectResolved = isTemplateMode ? replaceVarsClean(templateSubject, getValuesForRecipient(r)) : inputSubject.value;
            data.push({
                email: r.email,
                name: r.name,
                type: r.type,
                id: r.id,
                subject: subjectResolved,
                bodyHtml: bodyHtml
            });
        }

        document.getElementById('recipientsJson').value = JSON.stringify(data);
        // Set a default for legacy single-send fields
        document.getElementById('finalBodyHtml').value = data[0].bodyHtml;
    });
})();
</script>
