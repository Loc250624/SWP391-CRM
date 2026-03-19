<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ page contentType="text/html;charset=UTF-8" %>

        <!-- Header -->
        <header class="navbar navbar-expand bg-white border-bottom shadow-sm position-fixed"
            style="left: 260px; right: 0; top: 0; height: 64px; z-index: 1020;">
            <div class="container-fluid px-4">

                <!-- Left: Breadcrumb -->
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/admin/dashboard"
                                class="text-decoration-none text-muted">
                                <i class="bi bi-gear-fill me-1"></i>Admin Panel
                            </a>
                        </li>
                        <li class="breadcrumb-item active" aria-current="page">
                            ${pageTitle != null ? pageTitle : 'Dashboard'}
                        </li>
                    </ol>
                </nav>


                <!-- Right: Actions -->
                <div class="d-flex align-items-center gap-2">
                    <!-- System Notifications -->
                    <div class="dropdown">
                        <button class="btn btn-light btn-sm position-relative" type="button" data-bs-toggle="dropdown"
                            aria-expanded="false">
                            <i class="bi bi-bell"></i>
                            <span
                                class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger"
                                style="font-size: 10px;">
                                3
                            </span>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end" style="width: 320px;">
                            <li class="dropdown-header d-flex justify-content-between align-items-center">
                                <span class="fw-semibold">Thông báo hệ thống</span>
                                <a href="#" class="text-decoration-none small">Đánh dấu tất cả</a>
                            </li>
                            <li>
                                <hr class="dropdown-divider">
                            </li>
                            <li>
                                <a class="dropdown-item d-flex gap-2 py-2" href="#">
                                    <div class="bg-danger bg-opacity-10 rounded p-2">
                                        <i class="bi bi-exclamation-triangle-fill text-danger"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="small fw-medium">Phát hiện đăng nhập lạ tại IP 192.168.1.1</div>
                                        <div class="text-muted" style="font-size: 11px;">10 phút trước</div>
                                    </div>
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item d-flex gap-2 py-2" href="#">
                                    <div class="bg-info bg-opacity-10 rounded p-2">
                                        <i class="bi bi-info-circle text-info"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="small fw-medium">Hệ thống sẽ bảo trì lúc 00:00 AM</div>
                                        <div class="text-muted" style="font-size: 11px;">2 giờ trước</div>
                                    </div>
                                </a>
                            </li>
                        </ul>
                    </div>

                    <!-- Divider -->
                    <div class="vr mx-2"></div>

                    <!-- User Profile (Admin) -->
                    <div class="dropdown">
                        <button class="btn btn-light btn-sm d-flex align-items-center gap-2 px-2" type="button"
                            data-bs-toggle="dropdown" aria-expanded="false">
                            <div class="d-none d-md-block text-end">
                                <div class="small fw-medium lh-sm">
                                    ${sessionScope.user != null ? sessionScope.user.firstName : 'Admin'}
                                </div>
                                <div class="text-muted" style="font-size: 11px;">System Administrator</div>
                            </div>
                            <div class="bg-dark text-white rounded d-flex align-items-center justify-content-center"
                                style="width: 36px; height: 36px; font-size: 14px; font-weight: 600;">
                                A
                            </div>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li class="dropdown-header">
                                <div class="fw-semibold">${sessionScope.user != null ? sessionScope.user.email :
                                    'admin@crmpro.com'}</div>
                                <div class="text-muted small">Quyền: ${sessionScope.role}</div>
                            </li>
                            <li>
                                <hr class="dropdown-divider">
                            </li>
                            <li>
                                <a class="dropdown-item" href="#">
                                    <i class="bi bi-person-circle me-2"></i>My Profile
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item" href="#">
                                    <i class="bi bi-lock me-2"></i>Change Password
                                </a>
                            </li>
                            <li>
                                <hr class="dropdown-divider">
                            </li>
                            <li>
                                <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                                    <i class="bi bi-box-arrow-right me-2"></i>Sign Out
                                </a>
                            </li>
                        </ul>
                    </div>

                </div>
            </div>
        </header>