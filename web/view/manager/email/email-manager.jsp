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
            <h3 class="mb-1"><i class="bi bi-envelope-paper me-2"></i>Quản lý Email</h3>
            <p class="text-muted mb-0">Theo dõi lịch sử gửi, mẫu email và cấu hình SMTP</p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/manager/email/template" class="btn btn-outline-success">
                <i class="bi bi-plus-lg me-2"></i>Tạo mẫu email
            </a>
            <a href="${pageContext.request.contextPath}/manager/email/send" class="btn btn-primary">
                <i class="bi bi-send me-2"></i>Gửi email mới
            </a>
        </div>
    </div>

    <!-- KPI Cards -->
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="text-muted small">Tổng email đã gửi</div>
                    <div class="h4 mb-0" id="kpiTotal">--</div>
                    <div class="mt-2"><span class="badge bg-success-subtle text-success" id="kpiSentBadge">--</span> thành công</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="text-muted small">Tỷ lệ mở</div>
                    <div class="h4 mb-0" id="kpiOpenRate">--</div>
                    <div class="mt-2 small text-muted">Trung bình tổng</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="text-muted small">Bounce rate</div>
                    <div class="h4 mb-0" id="kpiBounceRate">--</div>
                    <div class="mt-2 small text-muted">Email trả lại</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="text-muted small">Hàng đợi / Thất bại</div>
                    <div class="h4 mb-0"><span id="kpiQueued">--</span> / <span id="kpiFailed" class="text-danger">--</span></div>
                    <div class="mt-2 small text-muted">Đang chờ / lỗi</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Tabs -->
    <ul class="nav nav-tabs mb-3" role="tablist">
        <li class="nav-item">
            <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tab-logs" type="button">
                <i class="bi bi-clock-history me-2"></i>Nhật ký gửi
            </button>
        </li>
        <li class="nav-item">
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-templates" type="button" onclick="emailMgr.loadTemplates()">
                <i class="bi bi-file-earmark-text me-2"></i>Mẫu email
            </button>
        </li>
        <li class="nav-item">
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-settings" type="button" onclick="emailMgr.loadConfig()">
                <i class="bi bi-gear me-2"></i>Cấu hình SMTP
            </button>
        </li>
    </ul>

    <div class="tab-content">
        <!-- ═══ Logs Tab ═══ -->
        <div class="tab-pane fade show active" id="tab-logs">
            <div class="card">
                <div class="card-header bg-white">
                    <div class="d-flex flex-wrap gap-3 justify-content-between align-items-center">
                        <h5 class="mb-0">Danh sách email đã gửi</h5>
                        <div class="d-flex gap-2">
                            <select class="form-select form-select-sm" id="logFilterStatus" onchange="emailMgr.loadLogs()" style="width:auto">
                                <option value="">Tất cả</option>
                                <option value="Sent">Sent</option>
                                <option value="Queued">Queued</option>
                                <option value="Failed">Failed</option>
                                <option value="Bounced">Bounced</option>
                            </select>
                            <input type="text" class="form-control form-control-sm" id="logFilterKeyword"
                                   placeholder="Tìm email, tiêu đề..." style="width:200px"
                                   onkeyup="if(event.key==='Enter')emailMgr.loadLogs()">
                            <button class="btn btn-outline-secondary btn-sm" onclick="emailMgr.loadLogs()">
                                <i class="bi bi-search"></i>
                            </button>
                        </div>
                    </div>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Người nhận</th>
                                    <th>Chủ đề</th>
                                    <th>Loại</th>
                                    <th>Trạng thái</th>
                                    <th>Thời gian</th>
                                    <th class="text-end">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody id="logTableBody">
                                <tr><td colspan="6" class="text-center py-4 text-muted">
                                    <div class="spinner-border spinner-border-sm me-2"></div>Đang tải...
                                </td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="card-footer bg-white">
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="text-muted small" id="logInfo">--</span>
                        <div class="btn-group btn-group-sm">
                            <button class="btn btn-outline-secondary" id="logPrev" onclick="emailMgr.logPrev()" disabled><i class="bi bi-chevron-left"></i></button>
                            <button class="btn btn-outline-secondary" id="logNext" onclick="emailMgr.logNext()"><i class="bi bi-chevron-right"></i></button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ═══ Templates Tab ═══ -->
        <div class="tab-pane fade" id="tab-templates">
            <div class="d-flex justify-content-between mb-3">
                <h5 class="mb-0">Danh sách mẫu email</h5>
                <a href="${pageContext.request.contextPath}/manager/email/template" class="btn btn-success btn-sm">
                    <i class="bi bi-plus-lg me-1"></i>Tạo mẫu mới
                </a>
            </div>
            <div class="row g-3" id="templateList">
                <div class="col-12 text-center py-4 text-muted">
                    <div class="spinner-border spinner-border-sm me-2"></div>Đang tải...
                </div>
            </div>
        </div>

        <!-- ═══ Settings Tab ═══ -->
        <div class="tab-pane fade" id="tab-settings">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <h5 class="mb-3">Cấu hình SMTP</h5>
                    <form id="smtpForm" onsubmit="return emailMgr.saveConfig()">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">SMTP Host <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="cfgHost" placeholder="smtp.gmail.com" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Port</label>
                                <input type="number" class="form-control" id="cfgPort" value="587">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Bảo mật</label>
                                <select class="form-select" id="cfgSecurity">
                                    <option value="tls">TLS (587)</option>
                                    <option value="ssl">SSL (465)</option>
                                    <option value="none">None</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Email đăng nhập SMTP <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="cfgUsername" placeholder="yourname@gmail.com" required>
                                <div class="form-text">Địa chỉ email dùng để đăng nhập SMTP server (VD: yourname@gmail.com)</div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Mật khẩu ứng dụng (App Password) <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <input type="password" class="form-control" id="cfgPassword" placeholder="••••••••" disabled>
                                    <button class="btn btn-outline-secondary" type="button" id="btnChangePassword" onclick="emailMgr.enablePassword()">
                                        <i class="bi bi-pencil me-1"></i>Đổi
                                    </button>
                                </div>
                                <div class="form-text" id="cfgPasswordHint">Với Gmail: bật 2FA → tạo App Password tại <a href="https://myaccount.google.com/apppasswords" target="_blank">myaccount.google.com</a></div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Email người gửi (From)</label>
                                <input type="email" class="form-control" id="cfgFromEmail" placeholder="yourname@gmail.com">
                                <div class="form-text">Email hiển thị ở trường "From" khi người nhận thấy. Thường trùng với email đăng nhập.</div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Tên người gửi</label>
                                <input type="text" class="form-control" id="cfgFromName" placeholder="CRM System">
                                <div class="form-text">Tên hiển thị bên cạnh email người gửi (VD: "CRM System", "Công ty ABC")</div>
                            </div>
                        </div>
                        <div class="mt-4 d-flex gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-save me-2"></i>Lưu cấu hình
                            </button>
                            <button type="button" class="btn btn-outline-secondary" onclick="emailMgr.testConnection()">
                                <i class="bi bi-send-check me-2"></i>Kiểm tra kết nối
                            </button>
                        </div>
                    </form>
                    <div id="configResult" class="mt-3"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
var emailMgr = (function () {
    var API = '${pageContext.request.contextPath}/manager/email-data';
    var logPage = 0, logSize = 15;

    function loadKpi() {
        fetch(API + '?action=kpi').then(function(r){return r.json()}).then(function(d){
            document.getElementById('kpiTotal').textContent = d.total || 0;
            document.getElementById('kpiSentBadge').textContent = d.sent || 0;
            document.getElementById('kpiOpenRate').textContent = (d.openRate || '0.0') + '%';
            document.getElementById('kpiBounceRate').textContent = (d.bounceRate || '0.0') + '%';
            document.getElementById('kpiQueued').textContent = d.queued || 0;
            document.getElementById('kpiFailed').textContent = d.failed || 0;
        }).catch(function(){});
    }

    function statusBadge(s) {
        switch(s) {
            case 'Sent':    return '<span class="badge bg-success-subtle text-success border border-success-subtle">Sent</span>';
            case 'Queued':  return '<span class="badge bg-warning-subtle text-warning border border-warning-subtle">Queued</span>';
            case 'Failed':  return '<span class="badge bg-danger-subtle text-danger border border-danger-subtle">Failed</span>';
            case 'Bounced': return '<span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle">Bounced</span>';
            case 'Opened':  return '<span class="badge bg-info-subtle text-info border border-info-subtle">Opened</span>';
            default:        return '<span class="badge bg-secondary">' + (s||'N/A') + '</span>';
        }
    }

    function timeStr(iso) {
        if (!iso) return '--';
        var d = new Date(iso.replace('T',' '));
        var dd = String(d.getDate()).padStart(2,'0');
        var mm = String(d.getMonth()+1).padStart(2,'0');
        var hh = String(d.getHours()).padStart(2,'0');
        var mi = String(d.getMinutes()).padStart(2,'0');
        return hh+':'+mi+' '+dd+'/'+mm+'/'+d.getFullYear();
    }

    function loadLogs() {
        logPage = 0; fetchLogs();
    }

    function fetchLogs() {
        var status = document.getElementById('logFilterStatus').value;
        var keyword = document.getElementById('logFilterKeyword').value;
        var url = API + '?action=logs&offset=' + (logPage*logSize) + '&limit=' + logSize;
        if (status) url += '&status=' + status;
        if (keyword) url += '&keyword=' + encodeURIComponent(keyword);

        var tbody = document.getElementById('logTableBody');
        tbody.innerHTML = '<tr><td colspan="6" class="text-center py-4 text-muted"><div class="spinner-border spinner-border-sm me-2"></div>Đang tải...</td></tr>';

        fetch(url).then(function(r){return r.json()}).then(function(data){
            if (!data.logs || data.logs.length === 0) {
                tbody.innerHTML = '<tr><td colspan="6" class="text-center py-4 text-muted"><i class="bi bi-inbox fs-3 d-block mb-2"></i>Chưa có email nào</td></tr>';
                document.getElementById('logInfo').textContent = '0 email';
                document.getElementById('logPrev').disabled = true;
                document.getElementById('logNext').disabled = true;
                return;
            }
            var html = '';
            for (var i = 0; i < data.logs.length; i++) {
                var l = data.logs[i];
                html += '<tr>'
                    + '<td><div class="fw-semibold">' + (l.toEmail||'') + '</div>'
                    + (l.toName ? '<div class="text-muted small">' + l.toName + '</div>' : '') + '</td>'
                    + '<td class="text-truncate" style="max-width:250px">' + (l.subject||'') + '</td>'
                    + '<td><span class="badge bg-light text-dark border">' + (l.relatedType||'') + '</span></td>'
                    + '<td>' + statusBadge(l.status) + '</td>'
                    + '<td class="text-nowrap small">' + timeStr(l.sentDate || l.createdAt) + '</td>'
                    + '<td class="text-end">';
                if (l.status === 'Failed') {
                    html += '<button class="btn btn-sm btn-outline-primary" onclick="emailMgr.resend(' + l.id + ')" title="Gửi lại"><i class="bi bi-arrow-repeat"></i></button>';
                }
                html += '</td></tr>';
            }
            tbody.innerHTML = html;

            var start = logPage * logSize + 1;
            var end = start + data.logs.length - 1;
            document.getElementById('logInfo').textContent = start + '-' + end + ' / ' + data.total;
            document.getElementById('logPrev').disabled = logPage === 0;
            document.getElementById('logNext').disabled = end >= data.total;
        }).catch(function(){ tbody.innerHTML = '<tr><td colspan="6" class="text-center py-4 text-danger">Lỗi tải dữ liệu</td></tr>'; });
    }

    function logPrev() { if (logPage > 0) { logPage--; fetchLogs(); } }
    function logNext() { logPage++; fetchLogs(); }

    function resend(logId) {
        if (!confirm('Gửi lại email này?')) return;
        fetch(API + '?action=resend&logId=' + logId, {method:'POST'})
            .then(function(r){return r.json()})
            .then(function(d){ alert(d.message); loadLogs(); loadKpi(); })
            .catch(function(){ alert('Lỗi'); });
    }

    function categoryBadge(cat) {
        var colors = {Quotation:'primary',Lead:'info',Customer:'success',Ticket:'warning',Campaign:'danger',General:'secondary'};
        var bg = colors[cat] || 'secondary';
        return '<span class="badge bg-'+bg+'-subtle text-'+bg+' border border-'+bg+'-subtle">'+(cat||'General')+'</span>';
    }

    function loadTemplates() {
        var container = document.getElementById('templateList');
        container.innerHTML = '<div class="col-12 text-center py-4 text-muted"><div class="spinner-border spinner-border-sm me-2"></div>Đang tải...</div>';

        fetch(API + '?action=templates').then(function(r){return r.json()}).then(function(data){
            if (!data.templates || data.templates.length === 0) {
                container.innerHTML = '<div class="col-12 text-center py-5 text-muted"><i class="bi bi-file-earmark-x fs-1 d-block mb-2"></i>Chưa có mẫu email nào<br><a href="${pageContext.request.contextPath}/manager/email/template" class="btn btn-success btn-sm mt-3"><i class="bi bi-plus-lg me-1"></i>Tạo mẫu đầu tiên</a></div>';
                return;
            }
            var html = '';
            for (var i = 0; i < data.templates.length; i++) {
                var t = data.templates[i];
                html += '<div class="col-lg-4"><div class="card h-100 border-0 shadow-sm">'
                    + '<div class="card-body">'
                    + '<div class="d-flex justify-content-between align-items-center mb-2">'
                    + categoryBadge(t.category)
                    + '<span class="text-muted small">' + (t.isActive ? '<i class="bi bi-check-circle text-success me-1"></i>Active' : '<i class="bi bi-x-circle text-muted me-1"></i>Inactive') + '</span>'
                    + '</div>'
                    + '<h6 class="mb-1">' + (t.name||'') + '</h6>'
                    + '<div class="text-muted small mb-2"><code>' + (t.code||'') + '</code></div>'
                    + '<p class="text-muted small mb-3">' + (t.description || t.subject || '--') + '</p>'
                    + '<div class="d-flex gap-2">'
                    + '<a href="${pageContext.request.contextPath}/manager/email/template?id=' + t.id + '" class="btn btn-outline-primary btn-sm"><i class="bi bi-pencil me-1"></i>Sửa</a>'
                    + '<form method="post" action="${pageContext.request.contextPath}/manager/email/template" style="display:inline">'
                    + '<input type="hidden" name="action" value="toggleActive"><input type="hidden" name="id" value="' + t.id + '">'
                    + '<input type="hidden" name="active" value="' + (!t.isActive) + '">'
                    + '<button type="submit" class="btn btn-outline-secondary btn-sm">' + (t.isActive ? 'Tắt' : 'Bật') + '</button></form>'
                    + '</div></div></div></div>';
            }
            container.innerHTML = html;
        }).catch(function(){ container.innerHTML = '<div class="col-12 text-center py-4 text-danger">Lỗi tải dữ liệu</div>'; });
    }

    var originalUsername = '';

    function loadConfig() {
        fetch(API + '?action=configStatus').then(function(r){return r.json()}).then(function(d){
            if (d.host) document.getElementById('cfgHost').value = d.host;
            if (d.port) document.getElementById('cfgPort').value = d.port;
            if (d.tls) document.getElementById('cfgSecurity').value = 'tls';
            else if (d.ssl) document.getElementById('cfgSecurity').value = 'ssl';
            else document.getElementById('cfgSecurity').value = 'none';
            if (d.username) document.getElementById('cfgUsername').value = d.username;
            originalUsername = d.username || '';
            if (d.fromEmail) document.getElementById('cfgFromEmail').value = d.fromEmail;
            if (d.fromName) document.getElementById('cfgFromName').value = d.fromName;

            // Password status
            var pwdInput = document.getElementById('cfgPassword');
            if (d.hasPassword) {
                pwdInput.placeholder = '••••••••  (đã cấu hình)';
                pwdInput.disabled = true;
            } else {
                pwdInput.placeholder = 'Chưa có — nhập mật khẩu ứng dụng';
                pwdInput.disabled = false;
                document.getElementById('btnChangePassword').classList.add('d-none');
            }
        }).catch(function(){});

        // Auto enable password khi username thay đổi
        document.getElementById('cfgUsername').addEventListener('input', function() {
            if (this.value !== originalUsername) {
                enablePassword();
            }
        });
    }

    function enablePassword() {
        var pwdInput = document.getElementById('cfgPassword');
        pwdInput.disabled = false;
        pwdInput.placeholder = 'Nhập mật khẩu ứng dụng mới';
        pwdInput.value = '';
        pwdInput.focus();
        document.getElementById('btnChangePassword').classList.add('d-none');
    }

    function saveConfig() {
        var sec = document.getElementById('cfgSecurity').value;
        var pwd = document.getElementById('cfgPassword').value;
        var params = 'action=saveConfig'
            + '&host=' + encodeURIComponent(document.getElementById('cfgHost').value)
            + '&port=' + document.getElementById('cfgPort').value
            + '&tls=' + (sec==='tls')
            + '&ssl=' + (sec==='ssl')
            + '&username=' + encodeURIComponent(document.getElementById('cfgUsername').value)
            + '&fromEmail=' + encodeURIComponent(document.getElementById('cfgFromEmail').value)
            + '&fromName=' + encodeURIComponent(document.getElementById('cfgFromName').value);
        if (pwd) params += '&password=' + encodeURIComponent(pwd);

        fetch(API, {method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'}, body:params})
            .then(function(r){return r.json()})
            .then(function(d){
                document.getElementById('configResult').innerHTML = '<div class="alert alert-'+(d.success?'success':'danger')+' py-2 small">'+d.message+'</div>';
            }).catch(function(){ document.getElementById('configResult').innerHTML = '<div class="alert alert-danger py-2 small">Lỗi kết nối</div>'; });
        return false;
    }

    function testConnection() {
        document.getElementById('configResult').innerHTML = '<div class="text-muted small"><div class="spinner-border spinner-border-sm me-1"></div>Đang kiểm tra...</div>';
        fetch(API + '?action=testConnection', {method:'POST'})
            .then(function(r){return r.json()})
            .then(function(d){
                document.getElementById('configResult').innerHTML = '<div class="alert alert-'+(d.success?'success':'danger')+' py-2 small">'+d.message+'</div>';
            }).catch(function(){ document.getElementById('configResult').innerHTML = '<div class="alert alert-danger py-2 small">Lỗi kết nối</div>'; });
    }

    // Auto-activate tab from hash
    document.addEventListener('DOMContentLoaded', function(){
        loadKpi();
        loadLogs();
        if (location.hash === '#tab-templates') {
            var tabEl = document.querySelector('[data-bs-target="#tab-templates"]');
            if (tabEl) new bootstrap.Tab(tabEl).show();
            loadTemplates();
        }
    });

    return {
        loadKpi: loadKpi, loadLogs: loadLogs, logPrev: logPrev, logNext: logNext,
        resend: resend, loadTemplates: loadTemplates, loadConfig: loadConfig,
        saveConfig: saveConfig, testConnection: testConnection, enablePassword: enablePassword
    };
})();
</script>
