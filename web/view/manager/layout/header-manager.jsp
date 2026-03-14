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
                        data-bs-toggle="dropdown" aria-expanded="false" onclick="loadNotifications()">
                    <i class="bi bi-bell"></i>
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size: 10px;"
                          id="notiCount"></span>
                </button>
                <ul class="dropdown-menu dropdown-menu-end shadow" style="width: 370px; max-height: 480px; overflow-y: auto;">
                    <li class="dropdown-header d-flex justify-content-between align-items-center">
                        <span class="fw-semibold">Thông báo</span>
                        <a href="javascript:void(0)" class="text-decoration-none small" onclick="markAllRead()">Đánh dấu đã đọc</a>
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
