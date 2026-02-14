<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!-- Sidebar -->
<aside class="d-flex flex-column vh-100 position-fixed start-0 top-0 bg-white border-end" style="width: 260px; z-index: 1040;">

    <!-- Logo -->
    <div class="p-3 border-bottom">
        <a href="${pageContext.request.contextPath}/sale/dashboard" class="d-flex align-items-center gap-2 text-decoration-none">
            <div class="d-flex align-items-center justify-content-center rounded bg-primary text-white" style="width: 40px; height: 40px;">
                <i class="bi bi-bar-chart-fill fs-5"></i>
            </div>
            <div>
                <h6 class="mb-0 fw-bold text-dark">Sales Pipeline</h6>
                <small class="text-muted" style="font-size: 11px;">CRM Pro - Module 2</small>
            </div>
        </a>
    </div>

    <!-- Menu -->
    <nav class="flex-grow-1 overflow-auto py-2">

        <!-- Dashboard -->
        <div class="mb-1">
            <div class="px-3 py-2">
                <small class="text-uppercase text-muted fw-semibold" style="font-size: 10px; letter-spacing: 0.5px;">Tổng quan</small>
            </div>
            <ul class="nav flex-column px-2">
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/sale/dashboard" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'DASHBOARD' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-speedometer2"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
            </ul>
        </div>

        <!-- Pipeline -->
        <div class="mb-1">
            <div class="px-3 py-2">
                <small class="text-uppercase text-muted fw-semibold" style="font-size: 10px; letter-spacing: 0.5px;">Pipeline</small>
            </div>
            <ul class="nav flex-column px-2">
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/sale/opportunity/kanban" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'OPP_KANBAN' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-kanban"></i>
                        <span>Kanban View</span>
                    </a>
                </li>
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/sale/report/pipeline" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'RPT_PIPELINE' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-bar-chart-line"></i>
                        <span>Statistics</span>
                    </a>
                </li>
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/sale/opportunity/forecast" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'OPP_FORECAST' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-graph-up-arrow"></i>
                        <span>Sales Forecast</span>
                    </a>
                </li>
            </ul>
        </div>

        <!-- Lead -->
        <div class="mb-1">
            <div class="px-3 py-2">
                <small class="text-uppercase text-muted fw-semibold" style="font-size: 10px; letter-spacing: 0.5px;">Users</small>
            </div>
            <ul class="nav flex-column px-2">
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/sale/lead/list" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'LEAD_LIST' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-people"></i>
                        <span>Danh sách Lead</span>
                    </a>
                </li>
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/sale/lead/form" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'LEAD_FORM' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-person-plus"></i>
                        <span>Thêm Lead</span>
                    </a>
                </li>
                  <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/sale/customer/list" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'CUSTOMER_LIST' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-people"></i>
                        <span>Danh sách Customer</span>
                    </a>
                </li>
                 <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/sale/customer/form" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'CUSTOMER_FORM' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-person-plus"></i>
                        <span>Thêm Customer</span>
                    </a>
                </li>
            </ul>
        </div>

        <!-- Opportunity -->
        <div class="mb-1">
            <div class="px-3 py-2">
                <small class="text-uppercase text-muted fw-semibold" style="font-size: 10px; letter-spacing: 0.5px;">Opportunity</small>
            </div>
            <ul class="nav flex-column px-2">
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/sale/opportunity/list" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'OPP_LIST' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-lightning"></i>
                        <span>Danh sách</span>
                    </a>
                </li>
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/sale/opportunity/form" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'OPP_FORM' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-plus-circle"></i>
                        <span>Tạo mới</span>
                    </a>
                </li>
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/sale/opportunity/history" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'OPP_HISTORY' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-clock-history"></i>
                        <span>Lịch sử</span>
                    </a>
                </li>
            </ul>
        </div>

        <!-- Quotation -->
        <div class="mb-1">
            <div class="px-3 py-2">
                <small class="text-uppercase text-muted fw-semibold" style="font-size: 10px; letter-spacing: 0.5px;">Báo giá</small>
            </div>
            <ul class="nav flex-column px-2">
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/sale/quotation/list" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'QUOT_LIST' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-file-earmark-text"></i>
                        <span>Danh sách</span>
                    </a>
                </li>
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/sale/quotation/form" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'QUOT_FORM' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-plus-circle"></i>
                        <span>Tạo báo giá</span>
                    </a>
                </li>
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/sale/quotation/tracking" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'QUOT_TRACKING' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-eye"></i>
                        <span>Theo dõi</span>
                    </a>
                </li>
            </ul>
        </div>

        <!-- Proposal -->
        <div class="mb-1">
            <div class="px-3 py-2">
                <small class="text-uppercase text-muted fw-semibold" style="font-size: 10px; letter-spacing: 0.5px;">Proposal</small>
            </div>
            <ul class="nav flex-column px-2">
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/sale/proposal/list" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'PROP_LIST' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-file-earmark-richtext"></i>
                        <span>Danh sách</span>
                    </a>
                </li>
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/sale/proposal/form" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'PROP_FORM' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-plus-circle"></i>
                        <span>Tạo mới</span>
                    </a>
                </li>
            </ul>
        </div>

        <!-- Activity -->
        <div class="mb-1">
            <div class="px-3 py-2">
                <small class="text-uppercase text-muted fw-semibold" style="font-size: 10px; letter-spacing: 0.5px;">Hoạt động</small>
            </div>
            <ul class="nav flex-column px-2">
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/sale/activity/calendar" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'ACT_CALENDAR' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-calendar-event"></i>
                        <span>Lịch hẹn</span>
                    </a>
                </li>
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/sale/activity/list" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'ACT_LIST' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-activity"></i>
                        <span>Danh sách</span>
                    </a>
                </li>
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/sale/activity/form" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'ACT_FORM' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-journal-plus"></i>
                        <span>Ghi nhận</span>
                    </a>
                </li>
            </ul>
        </div>

        <!-- Task -->
        <div class="mb-1">
            <div class="px-3 py-2">
                <small class="text-uppercase text-muted fw-semibold" style="font-size: 10px; letter-spacing: 0.5px;">Công việc</small>
            </div>
            <ul class="nav flex-column px-2">
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/sale/task/list" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'TASK_LIST' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-check2-square"></i>
                        <span>Danh sách Task</span>
                    </a>
                </li>
            </ul>
        </div>

        <!-- Reports -->
        <div class="mb-1">
            <div class="px-3 py-2">
                <small class="text-uppercase text-muted fw-semibold" style="font-size: 10px; letter-spacing: 0.5px;">Báo cáo</small>
            </div>
            <ul class="nav flex-column px-2">
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/sale/report/revenue" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'RPT_REVENUE' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-currency-dollar"></i>
                        <span>Doanh thu</span>
                    </a>
                </li>
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/sale/report/win-loss" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'RPT_WINLOSS' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-trophy"></i>
                        <span>Win / Loss</span>
                    </a>
                </li>
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/sale/report/forecast" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'RPT_FORECAST' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-graph-up"></i>
                        <span>Forecast</span>
                    </a>
                </li>
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/sale/report/quotation" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'RPT_QUOTATION' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-file-earmark-bar-graph"></i>
                        <span>Báo giá</span>
                    </a>
                </li>
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/sale/report/performance" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${ACTIVE_MENU == 'RPT_PERFORMANCE' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-person-badge"></i>
                        <span>Performance</span>
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
