<%@ page contentType="text/html;charset=UTF-8" %>

<div class="container-fluid">
    <!-- Header -->
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <h3 class="mb-1"><i class="bi bi-activity me-2"></i>Log Activities</h3>
            <p class="text-muted mb-0">Theo dõi hoạt động của Sales và Customer Success với Lead/Customer</p>
        </div>
    </div>

    <!-- KPI -->
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="text-muted small">Tổng hoạt động</div>
                    <div class="h4 mb-1" id="kpiTotal">--</div>
                    <div class="small text-muted">Tổng cộng</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="text-muted small">Lịch hẹn (Meeting)</div>
                    <div class="h4 mb-1" id="kpiMeetings">--</div>
                    <div class="small text-muted">Tổng cộng</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="text-muted small">Cuộc gọi (Call)</div>
                    <div class="h4 mb-1" id="kpiCalls">--</div>
                    <div class="small text-muted">Tổng cộng</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="text-muted small">Email</div>
                    <div class="h4 mb-1" id="kpiEmails">--</div>
                    <div class="small text-muted">Tổng cộng</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Filters -->
    <div class="card mb-4">
        <div class="card-body">
            <div class="row g-3 align-items-end">
                <div class="col-md-2">
                    <label class="form-label">Loại hoạt động</label>
                    <select class="form-select" id="filterActivityType">
                        <option value="">Tất cả</option>
                        <option value="Meeting">Meeting</option>
                        <option value="Call">Call</option>
                        <option value="Email">Email</option>
                        <option value="Note">Note</option>
                        <option value="Task">Task</option>
                        <option value="REPORT">Report</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Đối tượng</label>
                    <select class="form-select" id="filterRelatedType">
                        <option value="">Tất cả</option>
                        <option value="Lead">Lead</option>
                        <option value="Customer">Customer</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Vai trò</label>
                    <select class="form-select" id="filterRole">
                        <option value="">Tất cả</option>
                        <option value="SALES">Sales</option>
                        <option value="SUPPORT">Customer Success</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Trạng thái</label>
                    <select class="form-select" id="filterStatus">
                        <option value="">Tất cả</option>
                        <option value="Completed">Completed</option>
                        <option value="Pending">Pending</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Tìm kiếm</label>
                    <input type="text" class="form-control" id="filterKeyword"
                           placeholder="Tên, tiêu đề...">
                </div>
                <div class="col-md-2 d-flex gap-2">
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
                <h5 class="mb-0">Danh sách hoạt động <span class="text-muted small fw-normal" id="totalLabel"></span></h5>
            </div>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0 align-middle">
                    <thead class="table-light">
                        <tr>
                            <th style="width:60px">#</th>
                            <th>Thời gian</th>
                            <th>Loại</th>
                            <th>Đối tượng</th>
                            <th>Nội dung</th>
                            <th>Người thực hiện</th>
                            <th>Thời lượng</th>
                            <th>Trạng thái</th>
                            <th class="text-end" style="width:70px">Chi tiết</th>
                        </tr>
                    </thead>
                    <tbody id="logTableBody">
                        <tr>
                            <td colspan="9" class="text-center text-muted py-4">
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
                <h5 class="modal-title"><i class="bi bi-activity me-2"></i>Chi tiết hoạt động</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="detailBody">
            </div>
        </div>
    </div>
</div>

<script>
(function() {
    var baseUrl = '${pageContext.request.contextPath}/manager/activity-log';
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

    function typeBadge(type) {
        var map = {
            'Meeting': 'bg-success-subtle text-success border-success-subtle',
            'Call':    'bg-primary-subtle text-primary border-primary-subtle',
            'Email':   'bg-info-subtle text-info border-info-subtle',
            'Note':    'bg-warning-subtle text-warning border-warning-subtle',
            'Task':    'bg-secondary-subtle text-secondary border-secondary-subtle',
            'REPORT':  'bg-dark-subtle text-dark border-dark-subtle'
        };
        var cls = map[type] || 'bg-primary-subtle text-primary border-primary-subtle';
        return '<span class="badge ' + cls + ' border">' + escHtml(type) + '</span>';
    }

    function statusBadge(status) {
        if (status === 'Completed') {
            return '<span class="badge bg-success-subtle text-success border border-success-subtle">Completed</span>';
        } else if (status === 'Pending') {
            return '<span class="badge bg-warning-subtle text-warning border border-warning-subtle">Pending</span>';
        }
        return '<span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle">' + escHtml(status || '--') + '</span>';
    }

    function relatedBadge(type) {
        if (type === 'Lead') {
            return '<span class="badge bg-info-subtle text-info border border-info-subtle">Lead</span>';
        } else if (type === 'Customer') {
            return '<span class="badge bg-primary-subtle text-primary border border-primary-subtle">Customer</span>';
        }
        return escHtml(type || '--');
    }

    function escHtml(s) {
        if (!s) return '';
        var div = document.createElement('div');
        div.appendChild(document.createTextNode(s));
        return div.innerHTML;
    }

    function loadKpi() {
        fetch(baseUrl + '?action=kpi')
            .then(function(r) { return r.json(); })
            .then(function(data) {
                document.getElementById('kpiTotal').textContent = (data.total || 0).toLocaleString();
                document.getElementById('kpiMeetings').textContent = (data.meetings || 0).toLocaleString();
                document.getElementById('kpiCalls').textContent = (data.calls || 0).toLocaleString();
                document.getElementById('kpiEmails').textContent = (data.emails || 0).toLocaleString();
            })
            .catch(function() {});
    }

    window.loadLogs = function(offset) {
        currentOffset = offset || 0;
        var activityType = document.getElementById('filterActivityType').value;
        var relatedType = document.getElementById('filterRelatedType').value;
        var roleFilter = document.getElementById('filterRole').value;
        var statusFilter = document.getElementById('filterStatus').value;
        var keyword = document.getElementById('filterKeyword').value;

        var url = baseUrl + '?action=logs&offset=' + currentOffset + '&limit=' + pageSize;
        if (activityType) url += '&activityType=' + encodeURIComponent(activityType);
        if (relatedType) url += '&relatedType=' + encodeURIComponent(relatedType);
        if (roleFilter) url += '&roleFilter=' + encodeURIComponent(roleFilter);
        if (statusFilter) url += '&status=' + encodeURIComponent(statusFilter);
        if (keyword) url += '&keyword=' + encodeURIComponent(keyword);

        var tbody = document.getElementById('logTableBody');
        tbody.innerHTML = '<tr><td colspan="9" class="text-center text-muted py-4"><div class="spinner-border spinner-border-sm me-2"></div>Đang tải...</td></tr>';

        fetch(url)
            .then(function(r) { return r.json(); })
            .then(function(data) {
                totalLogs = data.total || 0;
                document.getElementById('totalLabel').textContent = '(' + totalLogs.toLocaleString() + ' kết quả)';

                if (!data.logs || data.logs.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="9" class="text-center text-muted py-4">Không có dữ liệu hoạt động</td></tr>';
                    document.getElementById('paginationContainer').innerHTML = '';
                    return;
                }

                var html = '';
                for (var i = 0; i < data.logs.length; i++) {
                    var l = data.logs[i];
                    html += '<tr>'
                        + '<td class="text-muted small">' + l.activityId + '</td>'
                        + '<td class="small">' + formatDate(l.createdAt) + '</td>'
                        + '<td>' + typeBadge(l.activityType) + '</td>'
                        + '<td>'
                        +   '<div>' + relatedBadge(l.relatedType) + '</div>'
                        +   '<div class="text-muted small mt-1">' + escHtml(l.contactName || '--') + '</div>'
                        + '</td>'
                        + '<td>'
                        +   '<div class="fw-semibold">' + escHtml(l.subject || '--') + '</div>'
                        +   '<div class="text-muted small text-truncate" style="max-width:250px;">' + escHtml(l.description || '') + '</div>'
                        + '</td>'
                        + '<td>'
                        +   '<div class="fw-semibold">' + escHtml(l.performerName || '--') + '</div>'
                        + '</td>'
                        + '<td class="small">' + (l.durationMinutes ? l.durationMinutes + ' phút' : '--') + '</td>'
                        + '<td>' + statusBadge(l.status) + '</td>'
                        + '<td class="text-end">'
                        +   '<button class="btn btn-sm btn-outline-secondary" onclick="showDetail(' + l.activityId + ')">'
                        +     '<i class="bi bi-eye"></i>'
                        +   '</button>'
                        + '</td>'
                        + '</tr>';
                }
                tbody.innerHTML = html;
                renderPagination();
            })
            .catch(function() {
                tbody.innerHTML = '<tr><td colspan="9" class="text-center text-danger py-4">Lỗi tải dữ liệu</td></tr>';
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
        document.getElementById('filterActivityType').value = '';
        document.getElementById('filterRelatedType').value = '';
        document.getElementById('filterRole').value = '';
        document.getElementById('filterStatus').value = '';
        document.getElementById('filterKeyword').value = '';
        loadLogs(0);
    };

    window.showDetail = function(activityId) {
        var body = document.getElementById('detailBody');
        body.innerHTML = '<div class="text-center py-4"><div class="spinner-border"></div></div>';
        var modal = new bootstrap.Modal(document.getElementById('detailModal'));
        modal.show();

        fetch(baseUrl + '?action=detail&id=' + activityId)
            .then(function(r) { return r.json(); })
            .then(function(a) {
                if (a.error) { body.innerHTML = '<p class="text-danger">' + escHtml(a.error) + '</p>'; return; }

                var html = '<table class="table table-sm mb-0">';
                html += '<tr><th style="width:160px">Activity ID</th><td>' + a.activityId + '</td></tr>';
                html += '<tr><th>Loại hoạt động</th><td>' + typeBadge(a.activityType) + '</td></tr>';
                html += '<tr><th>Đối tượng</th><td>' + relatedBadge(a.relatedType) + ' <span class="text-muted">(ID: ' + a.relatedId + ')</span></td></tr>';
                html += '<tr><th>Tên liên hệ</th><td>' + escHtml(a.contactName || '--') + '</td></tr>';
                html += '<tr><th>Tiêu đề</th><td>' + escHtml(a.subject || '--') + '</td></tr>';
                html += '<tr><th>Mô tả</th><td>' + escHtml(a.description || '--') + '</td></tr>';
                html += '<tr><th>Ngày hoạt động</th><td>' + formatDate(a.activityDate) + '</td></tr>';
                html += '<tr><th>Người thực hiện</th><td>' + escHtml(a.performerName || '--') + '</td></tr>';
                html += '<tr><th>Thời lượng</th><td>' + (a.durationMinutes ? a.durationMinutes + ' phút' : '--') + '</td></tr>';

                if (a.activityType === 'Call') {
                    html += '<tr><th>Hướng cuộc gọi</th><td>' + escHtml(a.callDirection || '--') + '</td></tr>';
                    html += '<tr><th>Kết quả cuộc gọi</th><td>' + escHtml(a.callResult || '--') + '</td></tr>';
                }

                html += '<tr><th>Trạng thái</th><td>' + statusBadge(a.status) + '</td></tr>';
                html += '<tr><th>Ngày tạo</th><td>' + formatDate(a.createdAt) + '</td></tr>';
                html += '</table>';
                body.innerHTML = html;
            })
            .catch(function() {
                body.innerHTML = '<p class="text-danger">Lỗi tải dữ liệu</p>';
            });
    };

    // Init
    loadKpi();
    loadLogs(0);
})();
</script>
