<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!-- Manager Header -->
<header class="navbar navbar-expand bg-white border-bottom shadow-sm position-fixed" style="left: 260px; right: 0; top: 0; height: 64px; z-index: 1020;">
    <div class="container-fluid px-4">

        <!-- Left: Breadcrumb -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/manager/dashboard" class="text-decoration-none text-muted">
                        <i class="bi bi-house-door me-1"></i>Task Manager
                    </a>
                </li>
                <li class="breadcrumb-item active" aria-current="page">
                    ${pageTitle != null ? pageTitle : 'Dashboard'}
                </li>
            </ol>
        </nav>

        <!-- Center: Search -->
        <form class="d-none d-lg-flex mx-4" style="width: 400px;">
            <div class="input-group">
                <span class="input-group-text bg-light border-end-0">
                    <i class="bi bi-search text-muted"></i>
                </span>
                <input type="text" class="form-control bg-light border-start-0"
                       placeholder="Tìm kiếm task, nhân viên, lead...">
            </div>
        </form>

        <!-- Right: Actions -->
        <div class="d-flex align-items-center gap-2">

            <!-- Quick Add Button -->
            <div class="dropdown">
                <button class="btn btn-success btn-sm dropdown-toggle d-flex align-items-center gap-1"
                        type="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="bi bi-plus-lg"></i>
                    <span class="d-none d-md-inline">Tạo mới</span>
                </button>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/manager/task/form?action=create">
                            <i class="bi bi-check2-square me-2 text-success"></i>Công việc mới
                        </a>
                    </li>
                    <li><hr class="dropdown-divider"></li>
                    <li>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/manager/crm/leads">
                            <i class="bi bi-person-lines-fill me-2 text-primary"></i>Giao Lead
                        </a>
                    </li>
                    <li>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/manager/crm/customers">
                            <i class="bi bi-people me-2 text-info"></i>Giao Customer
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Divider -->
            <div class="vr mx-2 d-none d-md-block"></div>

            <!-- Notifications -->
            <div class="dropdown" id="notifDropdown">
                <button class="btn btn-light btn-sm position-relative" type="button"
                        data-bs-toggle="dropdown" aria-expanded="false" onclick="crmNotif.load()">
                    <i class="bi bi-bell"></i>
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger"
                          style="font-size: 10px;" id="notiCount"></span>
                </button>
                <ul class="dropdown-menu dropdown-menu-end shadow" style="width: 370px; max-height: 480px; overflow-y: auto;">
                    <li class="dropdown-header d-flex justify-content-between align-items-center">
                        <span class="fw-semibold">Thông báo</span>
                        <a href="javascript:void(0)" class="text-decoration-none small" onclick="crmNotif.markAllRead()">Đánh dấu đã đọc</a>
                    </li>
                    <li><hr class="dropdown-divider"></li>
                    <li id="notifList">
                        <div class="text-center py-3 text-muted small">Đang tải...</div>
                    </li>
                    <li><hr class="dropdown-divider"></li>
                    <li>
                        <a class="dropdown-item text-center small text-primary"
                           href="${pageContext.request.contextPath}/manager/notifications">
                            Xem tất cả thông báo
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Messages -->
            <button class="btn btn-light btn-sm position-relative" type="button">
                <i class="bi bi-chat-dots"></i>
            </button>

            <!-- Divider -->
            <div class="vr mx-2"></div>

            <!-- User Profile -->
            <div class="dropdown">
                <button class="btn btn-light btn-sm d-flex align-items-center gap-2 px-2"
                        type="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <div class="d-none d-md-block text-end">
                        <div class="small fw-medium lh-sm">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">
                                    ${sessionScope.user.firstName} ${sessionScope.user.lastName}
                                </c:when>
                                <c:otherwise>Manager</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="text-muted" style="font-size: 11px;">Manager</div>
                    </div>
                    <div class="bg-success text-white rounded d-flex align-items-center justify-content-center"
                         style="width: 36px; height: 36px; font-size: 14px; font-weight: 600;">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                ${sessionScope.user.firstName.substring(0,1)}${sessionScope.user.lastName.substring(0,1)}
                            </c:when>
                            <c:otherwise>MG</c:otherwise>
                        </c:choose>
                    </div>
                </button>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li class="dropdown-header">
                        <div class="fw-semibold">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">
                                    ${sessionScope.user.firstName} ${sessionScope.user.lastName}
                                </c:when>
                                <c:otherwise>Manager</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="text-muted small">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">${sessionScope.user.email}</c:when>
                                <c:otherwise>manager@company.com</c:otherwise>
                            </c:choose>
                        </div>
                    </li>
                    <li><hr class="dropdown-divider"></li>
                    <li>
                        <a class="dropdown-item" href="#">
                            <i class="bi bi-person me-2"></i>Hồ sơ cá nhân
                        </a>
                    </li>
                    <li>
                        <a class="dropdown-item" href="#">
                            <i class="bi bi-gear me-2"></i>Cài đặt
                        </a>
                    </li>
                    <li>
                        <a class="dropdown-item" href="#">
                            <i class="bi bi-question-circle me-2"></i>Trợ giúp
                        </a>
                    </li>
                    <li><hr class="dropdown-divider"></li>
                    <li>
                        <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                            <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
                        </a>
                    </li>
                </ul>
            </div>

        </div>
    </div>
</header>

<script>
var crmNotif = (function () {
    var API = '${pageContext.request.contextPath}/manager/notifications-data';
    var pollInterval = 30000;
    var timer = null;

    // Icon + mau theo type
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

    // Tinh thoi gian tuong doi
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

    function updateBadge(count) {
        var el = document.getElementById('notiCount');
        if (!el) return;
        if (count > 0) {
            el.textContent = count > 99 ? '99+' : count;
            el.style.display = '';
        } else {
            el.textContent = '';
            el.style.display = 'none';
        }
    }

    function renderList(data) {
        var container = document.getElementById('notifList');
        if (!container) return;

        updateBadge(data.unreadCount);

        if (!data.notifications || data.notifications.length === 0) {
            container.innerHTML = '<div class="text-center py-3 text-muted small">Không có thông báo</div>';
            return;
        }

        var html = '';
        for (var i = 0; i < data.notifications.length; i++) {
            var n = data.notifications[i];
            var ic = iconFor(n.type);
            var unreadClass = n.isRead ? '' : 'bg-light';
            var rawUrl = n.actionUrl || '';
            var url = rawUrl
                ? '${pageContext.request.contextPath}/manager' + rawUrl
                : 'javascript:void(0)';

            html += '<a class="dropdown-item d-flex gap-2 py-2 ' + unreadClass + '" '
                  + 'href="' + url + '" onclick="crmNotif.markRead(' + n.id + ')">'
                  + '<div class="bg-' + ic.bg + ' bg-opacity-10 rounded p-2 flex-shrink-0">'
                  + '<i class="bi ' + ic.icon + ' text-' + ic.bg + '"></i></div>'
                  + '<div class="flex-grow-1">'
                  + '<div class="small fw-medium">' + (n.title || '') + '</div>'
                  + '<div class="text-muted text-truncate" style="font-size:11px;max-width:260px;">'
                  + (n.summary || '') + '</div>'
                  + '<div class="text-muted" style="font-size:10px;">' + timeAgo(n.createdAt) + '</div>'
                  + '</div>';
            if (!n.isRead) html += '<span class="bg-primary rounded-circle flex-shrink-0" style="width:8px;height:8px;margin-top:6px;"></span>';
            html += '</a>';
        }
        container.innerHTML = html;
    }

    function fetchCount() {
        fetch(API + '?action=count')
            .then(function (r) { return r.json(); })
            .then(function (d) { updateBadge(d.unreadCount); })
            .catch(function () {});
    }

    function load() {
        var container = document.getElementById('notifList');
        if (container) container.innerHTML = '<div class="text-center py-3 text-muted small">Đang tải...</div>';
        fetch(API + '?action=list&limit=15')
            .then(function (r) { return r.json(); })
            .then(function (d) { renderList(d); })
            .catch(function () {
                if (container) container.innerHTML = '<div class="text-center py-3 text-danger small">Lỗi tải thông báo</div>';
            });
    }

    function markRead(notifId) {
        fetch(API + '?action=markRead&notificationId=' + notifId, {method: 'POST'})
            .then(function () { fetchCount(); })
            .catch(function () {});
    }

    function markAllRead() {
        fetch(API + '?action=markAllRead', {method: 'POST'})
            .then(function () { load(); })
            .catch(function () {});
    }

    // Auto-poll badge count
    function startPolling() {
        fetchCount();
        timer = setInterval(fetchCount, pollInterval);
    }

    // Init khi trang load xong
    document.addEventListener('DOMContentLoaded', startPolling);

    return {load: load, markRead: markRead, markAllRead: markAllRead};
})();
</script>
