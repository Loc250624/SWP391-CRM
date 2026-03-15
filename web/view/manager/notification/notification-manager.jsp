<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid">
    <!-- Header -->
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <h3 class="mb-1"><i class="bi bi-bell me-2"></i>Quản lý Thông báo</h3>
            <p class="text-muted mb-0">Theo dõi và quản lý thông báo hệ thống CRM</p>
        </div>
        <div class="d-flex gap-2">
            <button class="btn btn-outline-secondary" onclick="mgrNotifPage.markAllRead()">
                <i class="bi bi-check2-all me-2"></i>Đánh dấu tất cả đã đọc
            </button>
            <a href="${pageContext.request.contextPath}/manager/notifications/create" class="btn btn-primary">
                <i class="bi bi-plus-circle me-2"></i>Tạo thông báo
            </a>
        </div>
    </div>

    <!-- KPI -->
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex align-items-center gap-3">
                        <div class="bg-primary bg-opacity-10 rounded p-3">
                            <i class="bi bi-bell fs-4 text-primary"></i>
                        </div>
                        <div>
                            <div class="text-muted small">Tổng thông báo</div>
                            <div class="h4 mb-0" id="kpiTotal">--</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex align-items-center gap-3">
                        <div class="bg-danger bg-opacity-10 rounded p-3">
                            <i class="bi bi-envelope fs-4 text-danger"></i>
                        </div>
                        <div>
                            <div class="text-muted small">Chưa đọc</div>
                            <div class="h4 mb-0" id="kpiUnread">--</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex align-items-center gap-3">
                        <div class="bg-success bg-opacity-10 rounded p-3">
                            <i class="bi bi-envelope-open fs-4 text-success"></i>
                        </div>
                        <div>
                            <div class="text-muted small">Đã đọc</div>
                            <div class="h4 mb-0" id="kpiRead">--</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex align-items-center gap-3">
                        <div class="bg-info bg-opacity-10 rounded p-3">
                            <i class="bi bi-broadcast fs-4 text-info"></i>
                        </div>
                        <div>
                            <div class="text-muted small">Kênh</div>
                            <div class="h4 mb-0">In-app</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Tabs -->
    <ul class="nav nav-tabs mb-3" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tab-my" type="button" role="tab">
                <i class="bi bi-inbox me-2"></i>Thông báo của tôi
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-sent" type="button" role="tab" onclick="mgrNotifPage.loadSentList()">
                <i class="bi bi-send me-2"></i>Đã gửi
            </button>
        </li>
    </ul>

    <div class="tab-content">
        <!-- My Notifications -->
        <div class="tab-pane fade show active" id="tab-my" role="tabpanel">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white">
                    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
                        <h5 class="mb-0">Danh sách thông báo</h5>
                        <div class="d-flex gap-2">
                            <select class="form-select form-select-sm" id="filterRead" onchange="mgrNotifPage.loadMyList()">
                                <option value="">Tất cả</option>
                                <option value="unread">Chưa đọc</option>
                                <option value="read">Đã đọc</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="card-body p-0">
                    <div id="myNotifList">
                        <div class="text-center py-5 text-muted">
                            <div class="spinner-border spinner-border-sm me-2" role="status"></div>Đang tải...
                        </div>
                    </div>
                </div>
                <div class="card-footer bg-white">
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="text-muted small" id="myNotifInfo">--</span>
                        <div class="btn-group btn-group-sm">
                            <button class="btn btn-outline-secondary" id="btnPrev" onclick="mgrNotifPage.prevPage()" disabled>
                                <i class="bi bi-chevron-left"></i>
                            </button>
                            <button class="btn btn-outline-secondary" id="btnNext" onclick="mgrNotifPage.nextPage()">
                                <i class="bi bi-chevron-right"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sent Notifications (manager broadcast) -->
        <div class="tab-pane fade" id="tab-sent" role="tabpanel">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white">
                    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
                        <h5 class="mb-0">Thông báo đã gửi</h5>
                        <div class="d-flex gap-2">
                            <input type="text" class="form-control form-control-sm" id="sentSearch"
                                   placeholder="Tìm theo tiêu đề..." onkeyup="mgrNotifPage.debounceSearch()">
                        </div>
                    </div>
                </div>
                <div class="card-body p-0">
                    <div id="sentNotifList">
                        <div class="text-center py-5 text-muted small">Chọn tab để tải dữ liệu</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
var mgrNotifPage = (function () {
    var API = '${pageContext.request.contextPath}/manager/notifications-data';
    var currentPage = 0;
    var pageSize = 15;
    var searchTimer = null;

    function iconFor(type) {
        switch (type) {
            case 'TASK_ASSIGNED':       return {icon: 'bi-check2-square', bg: 'success'};
            case 'TASK_COMPLETED':      return {icon: 'bi-check-circle', bg: 'success'};
            case 'TASK_OVERDUE':        return {icon: 'bi-exclamation-triangle', bg: 'danger'};
            case 'TASK_REMINDER':       return {icon: 'bi-alarm', bg: 'warning'};
            case 'TASK_STATUS_CHANGED': return {icon: 'bi-arrow-repeat', bg: 'info'};
            case 'TASK_COMMENT':        return {icon: 'bi-chat-left-text', bg: 'primary'};
            case 'LEAD_ASSIGNED':       return {icon: 'bi-person-plus', bg: 'primary'};
            case 'LEAD_CONVERTED':      return {icon: 'bi-arrow-up-circle', bg: 'success'};
            case 'LEAD_STATUS_CHANGED': return {icon: 'bi-arrow-left-right', bg: 'info'};
            case 'CUSTOMER_CREATED':    return {icon: 'bi-person-check', bg: 'success'};
            case 'OPPORTUNITY_CREATED': return {icon: 'bi-star', bg: 'primary'};
            case 'OPPORTUNITY_STAGE_CHANGED': return {icon: 'bi-signpost-split', bg: 'info'};
            case 'OPPORTUNITY_WON':     return {icon: 'bi-trophy', bg: 'success'};
            case 'OPPORTUNITY_LOST':    return {icon: 'bi-x-circle', bg: 'danger'};
            case 'QUOTATION_SENT':      return {icon: 'bi-send', bg: 'primary'};
            case 'QUOTATION_APPROVED':  return {icon: 'bi-check-circle', bg: 'success'};
            case 'QUOTATION_REJECTED':  return {icon: 'bi-x-octagon', bg: 'danger'};
            case 'QUOTATION_EXPIRING':  return {icon: 'bi-hourglass-split', bg: 'warning'};
            case 'MANAGER_BROADCAST':   return {icon: 'bi-megaphone', bg: 'warning'};
            case 'SYSTEM_ANNOUNCEMENT': return {icon: 'bi-info-circle', bg: 'secondary'};
            default:                    return {icon: 'bi-bell', bg: 'secondary'};
        }
    }

    function typeLabel(type) {
        switch (type) {
            case 'TASK_ASSIGNED':       return 'Giao việc';
            case 'TASK_COMPLETED':      return 'Hoàn thành';
            case 'TASK_OVERDUE':        return 'Quá hạn';
            case 'TASK_REMINDER':       return 'Nhắc nhở';
            case 'TASK_STATUS_CHANGED': return 'Đổi trạng thái';
            case 'TASK_COMMENT':        return 'Bình luận';
            case 'LEAD_ASSIGNED':       return 'Giao Lead';
            case 'LEAD_CONVERTED':      return 'Chuyển đổi Lead';
            case 'LEAD_STATUS_CHANGED': return 'Trạng thái Lead';
            case 'CUSTOMER_CREATED':    return 'Khách hàng mới';
            case 'OPPORTUNITY_CREATED': return 'Cơ hội mới';
            case 'OPPORTUNITY_STAGE_CHANGED': return 'Đổi giai đoạn';
            case 'OPPORTUNITY_WON':     return 'Thắng cơ hội';
            case 'OPPORTUNITY_LOST':    return 'Thua cơ hội';
            case 'QUOTATION_SENT':      return 'Gửi báo giá';
            case 'QUOTATION_APPROVED':  return 'Duyệt báo giá';
            case 'QUOTATION_REJECTED':  return 'Từ chối báo giá';
            case 'QUOTATION_EXPIRING':  return 'Báo giá sắp hết hạn';
            case 'MANAGER_BROADCAST':   return 'Thông báo chung';
            case 'SYSTEM_ANNOUNCEMENT': return 'Hệ thống';
            default:                    return type || 'Khác';
        }
    }

    function priorityBadge(p) {
        switch (p) {
            case 'URGENT': return '<span class="badge bg-danger-subtle text-danger border border-danger-subtle">Khẩn</span>';
            case 'HIGH':   return '<span class="badge bg-warning-subtle text-warning border border-warning-subtle">Cao</span>';
            case 'LOW':    return '<span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle">Thấp</span>';
            default:       return '<span class="badge bg-info-subtle text-info border border-info-subtle">Bình thường</span>';
        }
    }

    function timeAgo(isoStr) {
        if (!isoStr) return '';
        var d = new Date(isoStr.replace('T', ' '));
        var now = new Date();
        var diff = Math.floor((now - d) / 1000);
        if (diff < 60)    return 'Vừa xong';
        if (diff < 3600)  return Math.floor(diff / 60) + ' phút trước';
        if (diff < 86400) return Math.floor(diff / 3600) + ' giờ trước';
        return Math.floor(diff / 86400) + ' ngày trước';
    }

    function formatDate(isoStr) {
        if (!isoStr) return '';
        var d = new Date(isoStr.replace('T', ' '));
        var dd = ('0' + d.getDate()).slice(-2);
        var mm = ('0' + (d.getMonth() + 1)).slice(-2);
        var hh = ('0' + d.getHours()).slice(-2);
        var mi = ('0' + d.getMinutes()).slice(-2);
        return dd + '/' + mm + '/' + d.getFullYear() + ' ' + hh + ':' + mi;
    }

    function loadMyList() {
        currentPage = 0;
        fetchMyPage();
    }

    function fetchMyPage() {
        var container = document.getElementById('myNotifList');
        container.innerHTML = '<div class="text-center py-4 text-muted"><div class="spinner-border spinner-border-sm me-2"></div>Đang tải...</div>';

        var filter = document.getElementById('filterRead').value;
        var url = API + '?action=listPage&offset=' + (currentPage * pageSize) + '&limit=' + pageSize;
        if (filter === 'unread') url += '&unreadOnly=1';

        fetch(url)
            .then(function (r) { return r.json(); })
            .then(function (data) {
                document.getElementById('kpiTotal').textContent = data.total || 0;
                document.getElementById('kpiUnread').textContent = data.unreadCount || 0;
                document.getElementById('kpiRead').textContent = (data.total || 0) - (data.unreadCount || 0);

                if (!data.notifications || data.notifications.length === 0) {
                    container.innerHTML = '<div class="text-center py-5 text-muted"><i class="bi bi-bell-slash fs-1 d-block mb-2"></i>Không có thông báo</div>';
                    document.getElementById('myNotifInfo').textContent = '0 thông báo';
                    document.getElementById('btnPrev').disabled = true;
                    document.getElementById('btnNext').disabled = true;
                    return;
                }

                var html = '<div class="list-group list-group-flush">';
                for (var i = 0; i < data.notifications.length; i++) {
                    var n = data.notifications[i];
                    var ic = iconFor(n.type);
                    var unreadClass = n.isRead ? '' : 'bg-light border-start border-primary border-3';
                    var actionUrl = n.actionUrl
                        ? '${pageContext.request.contextPath}/manager' + n.actionUrl
                        : 'javascript:void(0)';

                    html += '<a href="' + actionUrl + '" class="list-group-item list-group-item-action ' + unreadClass + '" onclick="mgrNotifPage.markRead(' + n.id + ')">'
                          + '<div class="d-flex gap-3 py-1">'
                          + '<div class="bg-' + ic.bg + ' bg-opacity-10 rounded p-2 flex-shrink-0 align-self-start" style="width:40px;height:40px;display:flex;align-items:center;justify-content:center;">'
                          + '<i class="bi ' + ic.icon + ' text-' + ic.bg + '"></i></div>'
                          + '<div class="flex-grow-1 min-width-0">'
                          + '<div class="d-flex justify-content-between align-items-start">'
                          + '<div class="fw-semibold small">' + (n.title || '') + '</div>'
                          + '<div class="text-muted text-nowrap ms-2" style="font-size:11px;">' + timeAgo(n.createdAt) + '</div>'
                          + '</div>'
                          + '<div class="text-muted small text-truncate">' + (n.summary || '') + '</div>'
                          + '<div class="d-flex gap-2 mt-1">'
                          + '<span class="badge bg-' + ic.bg + '-subtle text-' + ic.bg + ' border border-' + ic.bg + '-subtle" style="font-size:10px;">' + typeLabel(n.type) + '</span>'
                          + priorityBadge(n.priority)
                          + (n.senderName ? '<span class="text-muted" style="font-size:10px;"><i class="bi bi-person me-1"></i>' + n.senderName + '</span>' : '')
                          + '</div>'
                          + '</div>';
                    if (!n.isRead) html += '<span class="bg-primary rounded-circle flex-shrink-0 align-self-center" style="width:8px;height:8px;"></span>';
                    html += '</div></a>';
                }
                html += '</div>';
                container.innerHTML = html;

                var start = currentPage * pageSize + 1;
                var end = start + data.notifications.length - 1;
                document.getElementById('myNotifInfo').textContent = start + '-' + end + ' / ' + data.total + ' thông báo';
                document.getElementById('btnPrev').disabled = currentPage === 0;
                document.getElementById('btnNext').disabled = end >= data.total;
            })
            .catch(function () {
                container.innerHTML = '<div class="text-center py-4 text-danger small">Lỗi tải dữ liệu</div>';
            });
    }

    function prevPage() { if (currentPage > 0) { currentPage--; fetchMyPage(); } }
    function nextPage() { currentPage++; fetchMyPage(); }

    function markRead(notifId) {
        fetch(API + '?action=markRead&notificationId=' + notifId, {method: 'POST'}).catch(function(){});
    }

    function markAllRead() {
        fetch(API + '?action=markAllRead', {method: 'POST'})
            .then(function () { loadMyList(); })
            .catch(function () {});
    }

    function loadSentList() {
        var container = document.getElementById('sentNotifList');
        container.innerHTML = '<div class="text-center py-4 text-muted"><div class="spinner-border spinner-border-sm me-2"></div>Đang tải...</div>';
        var keyword = (document.getElementById('sentSearch') || {}).value || '';
        var url = API + '?action=sentList&limit=30&keyword=' + encodeURIComponent(keyword);

        fetch(url)
            .then(function (r) { return r.json(); })
            .then(function (data) {
                if (!data.notifications || data.notifications.length === 0) {
                    container.innerHTML = '<div class="text-center py-5 text-muted small">Chưa gửi thông báo nào</div>';
                    return;
                }
                var html = '<div class="table-responsive"><table class="table table-hover mb-0 align-middle"><thead class="table-light"><tr>'
                         + '<th>Mã</th><th>Tiêu đề</th><th>Loại</th><th>Ưu tiên</th><th>Người nhận</th><th>Tỉ lệ đọc</th><th>Thời gian</th>'
                         + '</tr></thead><tbody>';
                for (var i = 0; i < data.notifications.length; i++) {
                    var n = data.notifications[i];
                    var readPct = n.recipientCount > 0 ? Math.round(n.readCount / n.recipientCount * 100) : 0;
                    html += '<tr>'
                          + '<td class="text-muted small">' + (n.code || '--') + '</td>'
                          + '<td><div class="fw-semibold small">' + (n.title || '') + '</div>'
                          + '<div class="text-muted" style="font-size:11px;">' + (n.summary || '') + '</div></td>'
                          + '<td><span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle" style="font-size:10px;">' + typeLabel(n.type) + '</span></td>'
                          + '<td>' + priorityBadge(n.priority) + '</td>'
                          + '<td class="text-center">' + n.recipientCount + '</td>'
                          + '<td>'
                          + '<div class="progress" style="height:6px;width:80px;">'
                          + '<div class="progress-bar bg-success" style="width:' + readPct + '%"></div></div>'
                          + '<span class="text-muted" style="font-size:10px;">' + n.readCount + '/' + n.recipientCount + ' (' + readPct + '%)</span>'
                          + '</td>'
                          + '<td class="text-muted small text-nowrap">' + formatDate(n.createdAt) + '</td>'
                          + '</tr>';
                }
                html += '</tbody></table></div>';
                container.innerHTML = html;
            })
            .catch(function () {
                container.innerHTML = '<div class="text-center py-4 text-danger small">Lỗi tải dữ liệu</div>';
            });
    }

    function debounceSearch() {
        if (searchTimer) clearTimeout(searchTimer);
        searchTimer = setTimeout(loadSentList, 400);
    }

    // Auto-load on page ready
    document.addEventListener('DOMContentLoaded', loadMyList);

    return {
        loadMyList: loadMyList, loadSentList: loadSentList,
        prevPage: prevPage, nextPage: nextPage,
        markRead: markRead, markAllRead: markAllRead,
        debounceSearch: debounceSearch
    };
})();
</script>
