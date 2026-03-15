<%-- 
    Document   : header
    Created on : Feb 15, 2026, 5:19:22 PM
    Author     : admin
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<header class="navbar navbar-expand bg-white border-bottom shadow-sm position-fixed" style="left: 250px; right: 0; top: 0; height: 64px; z-index: 1020;">
    <div class="container-fluid px-4">
        
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/support/dashboard" class="text-decoration-none text-muted">
                        <i class="bi bi-headset me-1"></i>Support Center
                    </a>
                </li>
                <li class="breadcrumb-item active" aria-current="page">
                    ${pageTitle != null ? pageTitle : 'Dashboard'}
                </li>
            </ol>
        </nav>
        
<!--        <form class="d-none d-lg-flex mx-4" style="width: 400px;">
            <div class="input-group">
                <span class="input-group-text bg-light border-end-0">
                    <i class="bi bi-search text-muted"></i>
                </span>
                <input type="text" class="form-control bg-light border-start-0" 
                       placeholder="Tìm mã ticket, tên khách hàng...">
            </div>
        </form>
        -->
        <div class="d-flex align-items-center gap-2">
            
            <div class="dropdown">
                <button class="btn btn-info btn-sm text-white dropdown-toggle d-flex align-items-center gap-1" 
                        type="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="bi bi-plus-lg"></i>
                    <span class="d-none d-md-inline">Hỗ trợ nhanh</span>
                </button>
                <ul class="dropdown-menu dropdown-menu-end shadow border-0">
                    <li>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/support/ticket/create">
                            <i class="bi bi-ticket-perforated me-2 text-danger"></i>Tạo Ticket mới
                        </a>
                    </li>
                   
                    <li><hr class="dropdown-divider"></li>
                    <li>
                        <a class="dropdown-item" href="#">
                            <i class="bi bi-chat-left-quote me-2 text-primary"></i>Ghi nhận Feedback
                        </a>
                    </li>
                </ul>
            </div>
            
            <div class="vr mx-2 d-none d-md-block"></div>
            
            <div class="dropdown" id="notifDropdown">
                <button class="btn btn-light btn-sm position-relative" type="button"
                        data-bs-toggle="dropdown" aria-expanded="false" onclick="csNotif.load()">
                    <i class="bi bi-bell"></i>
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger"
                          style="font-size: 10px;" id="notiCount"></span>
                </button>
                <ul class="dropdown-menu dropdown-menu-end shadow border-0" style="width: 370px; max-height: 480px; overflow-y: auto;">
                    <li class="dropdown-header d-flex justify-content-between align-items-center">
                        <span class="fw-semibold">Thông báo</span>
                        <a href="javascript:void(0)" class="text-decoration-none small" onclick="csNotif.markAllRead()">Đánh dấu đã đọc</a>
                    </li>
                    <li><hr class="dropdown-divider"></li>
                    <li id="notifList">
                        <div class="text-center py-3 text-muted small">Đang tải...</div>
                    </li>
                    <li><hr class="dropdown-divider"></li>
                    <li>
                        <a class="dropdown-item text-center small text-primary"
                           href="${pageContext.request.contextPath}/support/notifications">
                            Xem tất cả thông báo
                        </a>
                    </li>
                </ul>
            </div>
            
            <div class="vr mx-2"></div>
            
            <div class="dropdown">
                <button class="btn btn-light btn-sm d-flex align-items-center gap-2 px-2 border-0" 
                        type="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <div class="d-none d-md-block text-end">
                        <div class="small fw-medium lh-sm">
                            ${sessionScope.user.lastName} ${sessionScope.user.firstName}
                        </div>
                        <div class="text-muted" style="font-size: 11px;">${sessionScope.user.employeeCode}</div>
                    </div>
                    <img src="https://ui-avatars.com/api/?name=${sessionScope.user.lastName}+${sessionScope.user.firstName}&background=0D8ABC&color=fff" 
                         class="rounded border" width="36" height="36">
                </button>
                <ul class="dropdown-menu dropdown-menu-end shadow border-0">
                    <li class="dropdown-header">
                        <div class="fw-semibold">${sessionScope.user.lastName} ${sessionScope.user.firstName}</div>
                        <div class="text-muted small">${sessionScope.user.email}</div>
                    </li>
                    <li><hr class="dropdown-divider"></li>
                    <li>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                            <i class="bi bi-person me-2"></i>Cài đặt tài khoản
                        </a>
                    </li>
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
var csNotif = (function () {
    var API = '${pageContext.request.contextPath}/support/notifications';
    var pollInterval = 30000;
    var timer = null;

    function iconFor(type) {
        switch (type) {
            case 'TASK_ASSIGNED':       return {icon: 'bi-check2-square', bg: 'success'};
            case 'TASK_COMPLETED':      return {icon: 'bi-check-circle', bg: 'success'};
            case 'TASK_OVERDUE':        return {icon: 'bi-exclamation-triangle', bg: 'danger'};
            case 'TASK_REMINDER':       return {icon: 'bi-alarm', bg: 'warning'};
            case 'TASK_STATUS_CHANGED': return {icon: 'bi-arrow-repeat', bg: 'info'};
            case 'TASK_COMMENT':        return {icon: 'bi-chat-left-text', bg: 'primary'};
            case 'CUSTOMER_CREATED':    return {icon: 'bi-person-check', bg: 'success'};
            case 'CUSTOMER_STATUS_CHANGED': return {icon: 'bi-arrow-left-right', bg: 'info'};
            case 'MANAGER_BROADCAST':   return {icon: 'bi-megaphone', bg: 'warning'};
            case 'SYSTEM_ANNOUNCEMENT': return {icon: 'bi-info-circle', bg: 'secondary'};
            default:                    return {icon: 'bi-bell', bg: 'secondary'};
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
                ? '${pageContext.request.contextPath}/support' + rawUrl
                : 'javascript:void(0)';

            html += '<a class="dropdown-item d-flex gap-2 py-2 ' + unreadClass + '" '
                  + 'href="' + url + '" onclick="csNotif.markRead(' + n.id + ')">'
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

    function startPolling() {
        fetchCount();
        timer = setInterval(fetchCount, pollInterval);
    }

    document.addEventListener('DOMContentLoaded', startPolling);

    return {load: load, markRead: markRead, markAllRead: markAllRead};
})();
</script>