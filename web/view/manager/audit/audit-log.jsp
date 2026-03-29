<%@ page contentType="text/html;charset=UTF-8" %>

<div class="container-fluid">
    <!-- Header -->
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <h3 class="mb-1"><i class="bi bi-shield-check me-2"></i>Audit Logs</h3>
            <p class="text-muted mb-0">Theo dõi thay đổi dữ liệu và hành động hệ thống theo người dùng</p>
        </div>
    </div>

    <!-- KPI -->
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="text-muted small">Tổng log</div>
                    <div class="h4 mb-1" id="kpiTotal">--</div>
                    <div class="small text-muted">30 ngày gần nhất</div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="text-muted small">Thay đổi quan trọng</div>
                    <div class="h4 mb-1" id="kpiChanges">--</div>
                    <div class="small text-muted">Update/Delete</div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="text-muted small">User hoạt động</div>
                    <div class="h4 mb-1" id="kpiActiveUsers">--</div>
                    <div class="small text-muted">Trong hôm nay</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Filters -->
    <div class="card mb-4">
        <div class="card-body">
            <div class="row g-3 align-items-end">
                <div class="col-md-3">
                    <label class="form-label">Hành động</label>
                    <select class="form-select" id="filterAction">
                        <option value="">Tất cả</option>
                        <option value="Create">Create</option>
                        <option value="Update">Update</option>
                        <option value="Delete">Delete</option>
                        <option value="Login">Login</option>
                        <option value="Logout">Logout</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Entity</label>
                    <select class="form-select" id="filterEntity">
                        <option value="">Tất cả</option>
                        <option value="Customer">Customer</option>
                        <option value="Lead">Lead</option>
                        <option value="Task">Task</option>
                        <option value="Quotation">Quotation</option>
                        <option value="User">User</option>
                        <option value="EmailTemplate">EmailTemplate</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Tìm kiếm</label>
                    <input type="text" class="form-control" id="filterKeyword"
                           placeholder="Tên, email, giá trị...">
                </div>
                <div class="col-md-3 d-flex gap-2">
                    <button class="btn btn-primary flex-fill" onclick="loadLogs(0)">
                        <i class="bi bi-search me-1"></i>Tìm
                    </button>
                    <button class="btn btn-outline-secondary" onclick="resetFilters()">
                        <i class="bi bi-x-circle me-1"></i>Reset
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Table -->
    <div class="card">
        <div class="card-header bg-white">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
                <h5 class="mb-0">Danh sách Audit Logs <span class="text-muted small fw-normal" id="totalLabel"></span></h5>
            </div>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0 align-middle">
                    <thead class="table-light">
                        <tr>
                            <th style="width:60px">#</th>
                            <th>Thời gian</th>
                            <th>Hành động</th>
                            <th>Entity</th>
                            <th>Người dùng</th>
                            <th>Thay đổi</th>
                            <th class="text-end" style="width:70px">Chi tiết</th>
                        </tr>
                    </thead>
                    <tbody id="logTableBody">
                        <tr>
                            <td colspan="7" class="text-center text-muted py-4">
                                <div class="spinner-border spinner-border-sm me-2"></div>Đang tải...
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="card-footer bg-white" id="paginationContainer">
        </div>
    </div>
</div>

<!-- Detail Modal -->
<div class="modal fade" id="detailModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-shield-check me-2"></i>Chi tiết Audit Log</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="detailBody">
            </div>
        </div>
    </div>
</div>

<script>
(function() {
    var baseUrl = '${pageContext.request.contextPath}/manager/audit-log';
    var currentOffset = 0;
    var pageSize = 20;
    var totalLogs = 0;

    function formatDate(isoStr) {
        if (!isoStr) return '--';
        var d = new Date(isoStr);
        var dd = String(d.getDate()).padStart(2, '0');
        var mm = String(d.getMonth() + 1).padStart(2, '0');
        var yyyy = d.getFullYear();
        var hh = String(d.getHours()).padStart(2, '0');
        var mi = String(d.getMinutes()).padStart(2, '0');
        return dd + '/' + mm + '/' + yyyy + ' ' + hh + ':' + mi;
    }

    function actionBadge(action) {
        var map = {
            'Create': 'bg-success-subtle text-success border-success-subtle',
            'Update': 'bg-warning-subtle text-warning border-warning-subtle',
            'Delete': 'bg-danger-subtle text-danger border-danger-subtle',
            'Login':  'bg-info-subtle text-info border-info-subtle',
            'Logout': 'bg-secondary-subtle text-secondary border-secondary-subtle'
        };
        var cls = map[action] || 'bg-primary-subtle text-primary border-primary-subtle';
        return '<span class="badge ' + cls + ' border">' + escHtml(action) + '</span>';
    }

    function escHtml(s) {
        if (!s) return '';
        var div = document.createElement('div');
        div.appendChild(document.createTextNode(s));
        return div.innerHTML;
    }

    function summarizeChanges(oldVal, newVal) {
        var parts = [];
        if (newVal) {
            var items = newVal.split(',');
            for (var i = 0; i < items.length && i < 3; i++) {
                var key = items[i].split('=')[0];
                if (key) parts.push(key.trim());
            }
            if (items.length > 3) parts.push('...');
        } else if (oldVal) {
            parts.push('removed');
        }
        return parts.length > 0 ? parts.join(', ') : '--';
    }

    function loadKpi() {
        fetch(baseUrl + '?action=kpi')
            .then(function(r) { return r.json(); })
            .then(function(data) {
                document.getElementById('kpiTotal').textContent = (data.total || 0).toLocaleString();
                document.getElementById('kpiChanges').textContent = (data.changes || 0).toLocaleString();
                document.getElementById('kpiActiveUsers').textContent = (data.activeUsers || 0).toLocaleString();
            })
            .catch(function() {});
    }

    window.loadLogs = function(offset) {
        currentOffset = offset || 0;
        var actionFilter = document.getElementById('filterAction').value;
        var entityType = document.getElementById('filterEntity').value;
        var keyword = document.getElementById('filterKeyword').value;

        var url = baseUrl + '?action=logs&offset=' + currentOffset + '&limit=' + pageSize;
        if (actionFilter) url += '&actionFilter=' + encodeURIComponent(actionFilter);
        if (entityType) url += '&entityType=' + encodeURIComponent(entityType);
        if (keyword) url += '&keyword=' + encodeURIComponent(keyword);

        var tbody = document.getElementById('logTableBody');
        tbody.innerHTML = '<tr><td colspan="8" class="text-center text-muted py-4"><div class="spinner-border spinner-border-sm me-2"></div>Đang tải...</td></tr>';

        fetch(url)
            .then(function(r) { return r.json(); })
            .then(function(data) {
                totalLogs = data.total || 0;
                document.getElementById('totalLabel').textContent = '(' + totalLogs.toLocaleString() + ' kết quả)';

                if (!data.logs || data.logs.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="7" class="text-center text-muted py-4">Không có dữ liệu audit log</td></tr>';
                    document.getElementById('paginationContainer').innerHTML = '';
                    return;
                }

                var html = '';
                for (var i = 0; i < data.logs.length; i++) {
                    var l = data.logs[i];
                    html += '<tr>'
                        + '<td class="text-muted small">' + l.logId + '</td>'
                        + '<td class="small">' + formatDate(l.createdAt) + '</td>'
                        + '<td>' + actionBadge(l.action) + '</td>'
                        + '<td>'
                        +   '<div class="fw-semibold">' + escHtml(l.entityType) + '</div>'
                        +   (l.entityId ? '<div class="text-muted small">ID: ' + l.entityId + '</div>' : '')
                        + '</td>'
                        + '<td>'
                        +   '<div class="fw-semibold">' + escHtml(l.userName || '--') + '</div>'
                        +   '<div class="text-muted small">' + escHtml(l.userEmail || '') + '</div>'
                        + '</td>'
                        + '<td class="small text-muted" style="max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">'
                        +   escHtml(summarizeChanges(l.oldValues, l.newValues))
                        + '</td>'
                        + '<td class="text-end">'
                        +   '<button class="btn btn-sm btn-outline-secondary" onclick="showDetail(' + l.logId + ')">'
                        +     '<i class="bi bi-eye"></i>'
                        +   '</button>'
                        + '</td>'
                        + '</tr>';
                }
                tbody.innerHTML = html;
                renderPagination();
            })
            .catch(function() {
                tbody.innerHTML = '<tr><td colspan="7" class="text-center text-danger py-4">Lỗi tải dữ liệu</td></tr>';
            });
    };

    function renderPagination() {
        var totalPages = Math.ceil(totalLogs / pageSize);
        var currentPage = Math.floor(currentOffset / pageSize) + 1;
        if (totalPages <= 1) {
            document.getElementById('paginationContainer').innerHTML = '';
            return;
        }

        var html = '<nav><ul class="pagination pagination-sm mb-0 justify-content-center">';

        html += '<li class="page-item ' + (currentPage === 1 ? 'disabled' : '') + '">'
            + '<a class="page-link" href="#" onclick="loadLogs(' + ((currentPage - 2) * pageSize) + ');return false;">&laquo;</a></li>';

        var startPage = Math.max(1, currentPage - 2);
        var endPage = Math.min(totalPages, currentPage + 2);

        for (var p = startPage; p <= endPage; p++) {
            html += '<li class="page-item ' + (p === currentPage ? 'active' : '') + '">'
                + '<a class="page-link" href="#" onclick="loadLogs(' + ((p - 1) * pageSize) + ');return false;">' + p + '</a></li>';
        }

        html += '<li class="page-item ' + (currentPage === totalPages ? 'disabled' : '') + '">'
            + '<a class="page-link" href="#" onclick="loadLogs(' + (currentPage * pageSize) + ');return false;">&raquo;</a></li>';

        html += '</ul></nav>';
        document.getElementById('paginationContainer').innerHTML = html;
    }

    window.resetFilters = function() {
        document.getElementById('filterAction').value = '';
        document.getElementById('filterEntity').value = '';
        document.getElementById('filterKeyword').value = '';
        loadLogs(0);
    };

    window.showDetail = function(logId) {
        var body = document.getElementById('detailBody');
        body.innerHTML = '<div class="text-center py-4"><div class="spinner-border"></div></div>';
        var modal = new bootstrap.Modal(document.getElementById('detailModal'));
        modal.show();

        fetch(baseUrl + '?action=detail&id=' + logId)
            .then(function(r) { return r.json(); })
            .then(function(l) {
                if (l.error) { body.innerHTML = '<p class="text-danger">' + escHtml(l.error) + '</p>'; return; }

                var html = '<table class="table table-sm mb-0">';
                html += '<tr><th style="width:140px">Log ID</th><td>' + l.logId + '</td></tr>';
                html += '<tr><th>Thời gian</th><td>' + formatDate(l.createdAt) + '</td></tr>';
                html += '<tr><th>Hành động</th><td>' + actionBadge(l.action) + '</td></tr>';
                html += '<tr><th>Entity</th><td>' + escHtml(l.entityType) + (l.entityId ? ' (ID: ' + l.entityId + ')' : '') + '</td></tr>';
                html += '<tr><th>Người dùng</th><td>' + escHtml(l.userName || '--') + (l.userEmail ? ' <span class="text-muted">(' + escHtml(l.userEmail) + ')</span>' : '') + '</td></tr>';
                html += '<tr><th>User Agent</th><td class="small text-break">' + escHtml(l.userAgent || '--') + '</td></tr>';

                if (l.oldValues) {
                    html += '<tr><th>Giá trị cũ</th><td><div class="bg-light rounded p-2 small text-break">' + formatValues(l.oldValues) + '</div></td></tr>';
                }
                if (l.newValues) {
                    html += '<tr><th>Giá trị mới</th><td><div class="bg-light rounded p-2 small text-break">' + formatValues(l.newValues) + '</div></td></tr>';
                }

                html += '</table>';
                body.innerHTML = html;
            })
            .catch(function() {
                body.innerHTML = '<p class="text-danger">Lỗi tải dữ liệu</p>';
            });
    };

    function formatValues(valStr) {
        if (!valStr) return '--';
        var parts = valStr.split(',');
        var html = '';
        for (var i = 0; i < parts.length; i++) {
            var kv = parts[i].trim();
            var eq = kv.indexOf('=');
            if (eq > 0) {
                html += '<div><span class="fw-semibold">' + escHtml(kv.substring(0, eq)) + '</span>: ' + escHtml(kv.substring(eq + 1)) + '</div>';
            } else {
                html += '<div>' + escHtml(kv) + '</div>';
            }
        }
        return html;
    }

    // Init
    loadKpi();
    loadLogs(0);
})();
</script>
