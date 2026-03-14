<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ page contentType="text/html;charset=UTF-8" %>

        <!-- Sidebar -->
        <aside class="d-flex flex-column vh-100 position-fixed start-0 top-0 bg-white border-end"
            style="width: 260px; z-index: 1040;">

            <!-- Logo -->
            <div class="p-3 border-bottom">
                <a href="${pageContext.request.contextPath}/admin/dashboard"
                    class="d-flex align-items-center gap-2 text-decoration-none">
                    <div class="d-flex align-items-center justify-content-center rounded bg-indigo text-white"
                        style="width: 40px; height: 40px; background-color: #4f46e5;">
                        <i class="bi bi-shield-lock-fill fs-5"></i>
                    </div>
                    <div>
                        <h6 class="mb-0 fw-bold text-dark">CRM Admin</h6>
                        <small class="text-muted" style="font-size: 11px;">System Management</small>
                    </div>
                </a>
            </div>

            <!-- Menu -->
            <nav class="flex-grow-1 overflow-auto py-2" id="sidebarNav">

                <!-- Dashboard -->
                <div class="mb-1">
                    <div class="px-3 py-2">
                        <small class="text-uppercase text-muted fw-semibold"
                            style="font-size: 10px; letter-spacing: 0.5px;">Tổng quan</small>
                    </div>
                    <ul class="nav flex-column px-2">
                        <li class="nav-item mb-1">
                            <a href="${pageContext.request.contextPath}/admin/dashboard"
                                class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'DASHBOARD' ? 'active bg-indigo text-white' : 'text-body-secondary'}">
                                <i class="bi bi-speedometer2"></i>
                                <span>Dashboard</span>
                            </a>
                        </li>
                    </ul>
                </div>

                <!-- User & Customer Management -->
                <div class="mb-1">
                    <div class="px-3 py-2">
                        <small class="text-uppercase text-muted fw-semibold"
                            style="font-size: 10px; letter-spacing: 0.5px;">Khách hàng & User</small>
                    </div>
                    <ul class="nav flex-column px-2">
                        <li class="nav-item mb-1">
                            <a href="${pageContext.request.contextPath}/admin/customer/list"
                                class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'CUSTOMER_LIST' ? 'active bg-indigo text-white' : 'text-body-secondary'}">
                                <i class="bi bi-people"></i>
                                <span>Danh sách Khách hàng</span>
                            </a>
                        </li>
                        <li class="nav-item mb-1">
                            <a href="${pageContext.request.contextPath}/admin/customer/import"
                                class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'CUSTOMER_IMPORT' ? 'active bg-indigo text-white' : 'text-body-secondary'}">
                                <i class="bi bi-file-earmark-arrow-up"></i>
                                <span>Import Khách hàng</span>
                            </a>
                        </li>
                        <li class="nav-item mb-1">
                            <a href="${pageContext.request.contextPath}/admin/customer/dedup"
                                class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'CUSTOMER_DEDUP' ? 'active bg-indigo text-white' : 'text-body-secondary'}">
                                <i class="bi bi-intersect"></i>
                                <span>Xử lý trùng lặp</span>
                            </a>
                        </li>
                    </ul>
                </div>

                <!-- Course & Training -->
                <div class="mb-1">
                    <div class="px-3 py-2">
                        <small class="text-uppercase text-muted fw-semibold"
                            style="font-size: 10px; letter-spacing: 0.5px;">Khóa học & Danh mục</small>
                    </div>
                    <ul class="nav flex-column px-2">
                        <li class="nav-item mb-1">
                            <a href="${pageContext.request.contextPath}/admin/category/list"
                                class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'CATEGORY_LIST' ? 'active bg-indigo text-white' : 'text-body-secondary'}">
                                <i class="bi bi-tags"></i>
                                <span>Danh mục Khóa học</span>
                            </a>
                        </li>
                        <li class="nav-item mb-1">
                            <a href="${pageContext.request.contextPath}/admin/category/form"
                                class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'CATEGORY_FORM' ? 'active bg-indigo text-white' : 'text-body-secondary'}">
                                <i class="bi bi-plus-circle"></i>
                                <span>Thêm Danh mục mới</span>
                            </a>
                        </li>
                    </ul>
                </div>

                <!-- System Settings -->
                <div class="mb-1">
                    <div class="px-3 py-2">
                        <small class="text-uppercase text-muted fw-semibold"
                            style="font-size: 10px; letter-spacing: 0.5px;">Hệ thống</small>
                    </div>
                    <ul class="nav flex-column px-2">
                        <li class="nav-item mb-1">
                            <a href="#"
                                class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 text-body-secondary">
                                <i class="bi bi-person-fill-gear"></i>
                                <span>Quản lý Tài khoản (User)</span>
                            </a>
                        </li>
                        <li class="nav-item mb-1">
                            <a href="#"
                                class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 text-body-secondary">
                                <i class="bi bi-shield-check"></i>
                                <span>Phân quyền (Roles)</span>
                            </a>
                        </li>
                        <li class="nav-item mb-1">
                            <a href="#"
                                class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 text-body-secondary">
                                <i class="bi bi-gear"></i>
                                <span>Cài đặt chung</span>
                            </a>
                        </li>
                    </ul>
                </div>

            </nav>

            <!-- Footer -->
            <div class="p-3 border-top">
                <div class="d-flex align-items-center justify-content-between">
                    <span class="badge" style="background-color: #4f46e5;">ADMIN MODULE</span>
                </div>
            </div>

        </aside>

        <!-- Custom induction color -->
        <style>
            .bg-indigo {
                background-color: #4f46e5 !important;
            }

            .nav-link.active.bg-indigo {
                background-color: #4f46e5 !important;
            }

            .nav-link:not(.active):hover {
                background-color: #f8f9fa !important;
                color: #4f46e5 !important;
            }
        </style>

        <!-- Sidebar scroll persistence -->
        <script>
            (function () {
                var nav = document.getElementById('sidebarNav');
                if (!nav) return;

                // Restore scroll position
                var saved = sessionStorage.getItem('adminSidebarScroll');
                if (saved) nav.scrollTop = parseInt(saved, 10);

                // Save scroll position on scroll
                nav.addEventListener('scroll', function () {
                    sessionStorage.setItem('adminSidebarScroll', nav.scrollTop);
                });
            })();
        </script>