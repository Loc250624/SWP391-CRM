<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ page contentType="text/html;charset=UTF-8" %>

        <!-- Sidebar -->
        <aside class="d-flex flex-column vh-100 position-fixed start-0 top-0 bg-white border-end"
            style="width: 260px; z-index: 1040;">

            <!-- Logo -->
            <div class="p-3 border-bottom">
                <a href="${pageContext.request.contextPath}/marketing/dashboard"
                    class="d-flex align-items-center gap-2 text-decoration-none">
                    <div class="d-flex align-items-center justify-content-center rounded bg-primary text-white"
                        style="width: 40px; height: 40px;">
                        <i class="bi bi-megaphone fs-5"></i>
                    </div>
                    <div>
                        <h6 class="mb-0 fw-bold text-dark">Marketing Hub</h6>
                        <small class="text-muted" style="font-size: 11px;">CRM Pro - Module 3</small>
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
                            <a href="${pageContext.request.contextPath}/marketing/dashboard"
                                class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'DASHBOARD' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                                <i class="bi bi-speedometer2"></i>
                                <span>Dashboard</span>
                            </a>
                        </li>
                    </ul>
                </div>

                <!-- Lead Management -->
                <div class="mb-1">
                    <div class="px-3 py-2">
                        <small class="text-uppercase text-muted fw-semibold"
                            style="font-size: 10px; letter-spacing: 0.5px;">Quản lý Lead</small>
                    </div>
                    <ul class="nav flex-column px-2">
                        <li class="nav-item mb-1">
                            <a href="${pageContext.request.contextPath}/marketing/lead/list"
                                class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'LEAD_LIST' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                                <i class="bi bi-people"></i>
                                <span>Danh sách Lead</span>
                            </a>
                        </li>
                        <li class="nav-item mb-1">
                            <a href="${pageContext.request.contextPath}/marketing/lead/form"
                                class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'LEAD_FORM' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                                <i class="bi bi-person-plus"></i>
                                <span>Tạo Lead mới</span>
                            </a>
                        </li>
                    </ul>
                </div>

                <!-- Campaigns -->
                <div class="mb-1">
                    <div class="px-3 py-2">
                        <small class="text-uppercase text-muted fw-semibold"
                            style="font-size: 10px; letter-spacing: 0.5px;">Chiến dịch</small>
                    </div>
                    <ul class="nav flex-column px-2">
                        <li class="nav-item mb-1">
                            <a href="${pageContext.request.contextPath}/marketing/campaign/list"
                                class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'CAMPAIGN_LIST' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                                <i class="bi bi-megaphone"></i>
                                <span>Danh sách chiến dịch</span>
                            </a>
                        </li>
                        <li class="nav-item mb-1">
                            <a href="${pageContext.request.contextPath}/marketing/campaign/form"
                                class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'CAMPAIGN_FORM' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                                <i class="bi bi-plus-circle"></i>
                                <span>Tạo chiến dịch mới</span>
                            </a>
                        </li>
                    </ul>
                </div>

                <!-- Email Marketing -->
                <div class="mb-1">
                    <div class="px-3 py-2">
                        <small class="text-uppercase text-muted fw-semibold"
                            style="font-size: 10px; letter-spacing: 0.5px;">Email Marketing</small>
                    </div>
                    <ul class="nav flex-column px-2">
                        <li class="nav-item mb-1">
                            <a href="${pageContext.request.contextPath}/marketing/email/template/list"
                                class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'EMAIL_TEMPLATES' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                                <i class="bi bi-envelope-paper"></i>
                                <span>Mẫu Email</span>
                            </a>
                        </li>
                        <li class="nav-item mb-1">
                            <a href="${pageContext.request.contextPath}/marketing/email/log"
                                class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'EMAIL_LOG' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                                <i class="bi bi-journal-text"></i>
                                <span>Lịch sử gửi Email</span>
                            </a>
                        </li>
                    </ul>
                </div>

                <!-- Content & Automation -->
                <div class="mb-1">
                    <div class="px-3 py-2">
                        <small class="text-uppercase text-muted fw-semibold"
                            style="font-size: 10px; letter-spacing: 0.5px;">Nội dung & Tự động hóa</small>
                    </div>
                    <ul class="nav flex-column px-2">
                        <li class="nav-item mb-1">
                            <a href="${pageContext.request.contextPath}/marketing/landingpage/list"
                                class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'LANDING_PAGE' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                                <i class="bi bi-window"></i>
                                <span>Landing Pages / Web Forms</span>
                            </a>
                        </li>
                    </ul>
                </div>

            </nav>

            <!-- Footer -->
            <div class="p-3 border-top">
                <div class="d-flex align-items-center justify-content-between">
                    <span class="badge bg-primary">SALES MODULE</span>
                </div>
            </div>

        </aside>

        <!-- Hover Style -->
        <style>
            .nav-link:not(.active):hover {
                background-color: #f8f9fa !important;
                color: #0d6efd !important;
            }
        </style>

        <!-- Sidebar scroll persistence -->
        <script>
            (function () {
                var nav = document.getElementById('sidebarNav');
                if (!nav) return;

                // Restore scroll position
                var saved = sessionStorage.getItem('sidebarScroll');
                if (saved) nav.scrollTop = parseInt(saved, 10);

                // Save scroll position on scroll
                nav.addEventListener('scroll', function () {
                    sessionStorage.setItem('sidebarScroll', nav.scrollTop);
                });
            })();
        </script>