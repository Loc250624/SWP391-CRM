<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!-- Manager Sidebar -->
<aside class="d-flex flex-column vh-100 position-fixed start-0 top-0 bg-white border-end" style="width: 260px; z-index: 1040;">

    <!-- Logo -->
    <div class="p-3 border-bottom">
        <a href="${pageContext.request.contextPath}/manager/task/list" class="d-flex align-items-center gap-2 text-decoration-none">
            <div class="d-flex align-items-center justify-content-center rounded bg-success text-white" style="width: 40px; height: 40px;">
                <i class="bi bi-diagram-3-fill fs-5"></i>
            </div>
            <div>
                <h6 class="mb-0 fw-bold text-dark">Task Manager</h6>
                <small class="text-muted" style="font-size: 11px;">CRM Pro - Module 4</small>
            </div>
        </a>
    </div>

    <!-- Menu -->
    <nav class="flex-grow-1 overflow-auto py-2" id="sidebarNav">

        <!-- Overview -->
        <div class="mb-1">
            <div class="px-3 py-2">
                <small class="text-uppercase text-muted fw-semibold" style="font-size: 10px; letter-spacing: 0.5px;">Tổng quan</small>
            </div>
            <ul class="nav flex-column px-2">
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/manager/dashboard"
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'DASHBOARD' ? 'active bg-success text-white' : 'text-body-secondary'}">
                        <i class="bi bi-speedometer2"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/manager/task/report"
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'TASK_REPORT' ? 'active bg-success text-white' : 'text-body-secondary'}">
                        <i class="bi bi-bar-chart-line"></i>
                        <span>Báo cáo</span>
                    </a>
                </li>
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/manager/task/kanban"
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'TASK_KANBAN' ? 'active bg-success text-white' : 'text-body-secondary'}">
                        <i class="bi bi-kanban"></i>
                        <span>Kanban Board</span>
                    </a>
                </li>
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/manager/task/workload"
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'TASK_WORKLOAD' ? 'active bg-success text-white' : 'text-body-secondary'}">
                        <i class="bi bi-bar-chart"></i>
                        <span>Workload</span>
                    </a>
                </li>
            </ul>
        </div>
        <!-- Tasks -->
        <div class="mb-1">
            <div class="px-3 py-2">
                <small class="text-uppercase text-muted fw-semibold" style="font-size: 10px; letter-spacing: 0.5px;">Công việc</small>
            </div>
            <ul class="nav flex-column px-2">

                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/manager/crm/leads"
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'CRM_LEADS' ? 'active bg-success text-white' : 'text-body-secondary'}">
                        <i class="bi bi-person-lines-fill"></i>
                        <span>Quản lý Lead</span>
                    </a>
                </li>

                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/manager/crm/customers"
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'CRM_CUSTOMERS' ? 'active bg-success text-white' : 'text-body-secondary'}">
                        <i class="bi bi-people"></i>
                        <span>Quản lý Customer</span>
                    </a>
                </li>

                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/manager/task/list"
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'TASK_MY_LIST' || ACTIVE_MENU == 'TASK_TEAM_LIST' ? 'active bg-success text-white' : 'text-body-secondary'}">
                        <i class="bi bi-person-check"></i>
                        <span>Quản lý task</span>
                    </a>
                </li>
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/manager/task/form?action=create"
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'TASK_FORM' ? 'active bg-success text-white' : 'text-body-secondary'}">
                        <i class="bi bi-plus-circle"></i>
                        <span>Tạo công việc</span>
                    </a>
                </li>
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/manager/task/calendar"
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'TASK_CALENDAR' ? 'active bg-success text-white' : 'text-body-secondary'}">
                        <i class="bi bi-calendar3"></i>
                        <span>Lịch công việc</span>
                    </a>
                </li>
            </ul>
        </div>

        <div class="mb-1">
            <div class="px-3 py-2">
                <small class="text-uppercase text-muted fw-semibold" style="font-size: 10px; letter-spacing: 0.5px;">Config</small>
            </div>
            <ul class="nav flex-column px-2">
                <li class="nav-item mb-1">
                    <a href=""
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'PERFORMANCE' ? 'active bg-success text-white' : 'text-body-secondary'}">
                        <i class="bi bi-award"></i>
                        <span>Quản lý email</span>
                    </a>
                </li>
                 <li class="nav-item mb-1">
                    <a href=""
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'PERFORMANCE' ? 'active bg-success text-white' : 'text-body-secondary'}">
                        <i class="bi bi-award"></i>
                        <span>Quản lý thông báo</span>
                    </a>
                </li>
                <li class="nav-item mb-1">
                    <a href=""
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'PERFORMANCE' ? 'active bg-success text-white' : 'text-body-secondary'}">
                        <i class="bi bi-award"></i>
                        <span>Log activities</span>
                    </a>
                </li>
                 <li class="nav-item mb-1">
                    <a href=""
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'PERFORMANCE' ? 'active bg-success text-white' : 'text-body-secondary'}">
                        <i class="bi bi-award"></i>
                        <span>Audit Logs</span>
                    </a>
                </li>
            </ul>
        </div>


        <!-- Analytics -->
        <div class="mb-1">
            <div class="px-3 py-2">
                <small class="text-uppercase text-muted fw-semibold" style="font-size: 10px; letter-spacing: 0.5px;">Phân tích</small>
            </div>
            <ul class="nav flex-column px-2">
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/manager/performance"
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'PERFORMANCE' ? 'active bg-success text-white' : 'text-body-secondary'}">
                        <i class="bi bi-award"></i>
                        <span>Hiệu suất KPI</span>
                    </a>
                </li>
            </ul>
        </div>

    </nav>

    <!-- Footer -->
    <div class="p-3 border-top">
        <div class="d-flex align-items-center justify-content-between">
            <span class="badge bg-success">MANAGER MODULE</span>
        </div>
    </div>

</aside>

<!-- Hover Style -->
<style>
    .nav-link:not(.active):hover {
        background-color: #f8f9fa !important;
        color: #198754 !important;
    }
</style>

<!-- Sidebar scroll persistence -->
<script>
    (function () {
        var nav = document.getElementById('sidebarNav');
        if (!nav)
            return;
        var saved = sessionStorage.getItem('mgrSidebarScroll');
        if (saved)
            nav.scrollTop = parseInt(saved, 10);
        nav.addEventListener('scroll', function () {
            sessionStorage.setItem('mgrSidebarScroll', nav.scrollTop);
        });
    })();
</script>
