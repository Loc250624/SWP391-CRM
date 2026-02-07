<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<style>
    .sidebar-container {
        background: linear-gradient(to bottom, #f8fafc, #f1f5f9);
        border-right: 1px solid #e2e8f0;
    }

    .menu-section {
        margin-bottom: 1.5rem;
    }

    .section-label {
        font-size: 0.75rem;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        color: #64748b;
        padding: 0.5rem 1rem;
        margin-bottom: 0.25rem;
    }

    .menu-item {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        padding: 0.625rem 1rem;
        margin: 0.125rem 0.5rem;
        border-radius: 0.5rem;
        color: #475569;
        text-decoration: none;
        font-size: 0.875rem;
        transition: all 0.15s ease;
        position: relative;
    }

    .menu-item:hover {
        background-color: #dbeafe;
        color: #1e40af;
    }

    .menu-item.active {
        background: linear-gradient(to right, #60a5fa, #3b82f6);
        color: white;
        font-weight: 500;
        box-shadow: 0 1px 3px rgba(59, 130, 246, 0.3);
    }

    .menu-item.active::before {
        content: '';
        position: absolute;
        left: 0;
        top: 50%;
        transform: translateY(-50%);
        width: 3px;
        height: 60%;
        background: #fb923c;
        border-radius: 0 2px 2px 0;
    }

    .menu-icon {
        width: 1.25rem;
        height: 1.25rem;
        flex-shrink: 0;
    }

    .logo-container {
        padding: 1.5rem 1rem;
        border-bottom: 1px solid #e2e8f0;
        background: white;
    }

    .logo-box {
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }

    .logo-icon {
        width: 2.5rem;
        height: 2.5rem;
        background: linear-gradient(135deg, #60a5fa 0%, #3b82f6 50%, #fb923c 100%);
        border-radius: 0.5rem;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 2px 8px rgba(59, 130, 246, 0.2);
    }

    .logo-text h1 {
        font-size: 1.125rem;
        font-weight: 700;
        color: #1e293b;
        margin: 0;
    }

    .logo-text p {
        font-size: 0.75rem;
        color: #64748b;
        margin: 0;
    }

    .sidebar-footer {
        padding: 1rem;
        border-top: 1px solid #e2e8f0;
        background: white;
        text-align: center;
    }

    .badge {
        display: inline-block;
        background: linear-gradient(to right, #60a5fa, #3b82f6);
        color: white;
        padding: 0.25rem 0.625rem;
        border-radius: 1rem;
        font-size: 0.75rem;
        font-weight: 600;
    }

    .submenu-item {
        padding-left: 3rem;
        font-size: 0.8125rem;
    }
</style>

<aside class="sidebar-container" style="width: 16rem; height: 100vh; display: flex; flex-direction: column; position: fixed; left: 0; top: 0; z-index: 50;">

    <!-- Logo -->
    <div class="logo-container">
        <div class="logo-box">
            <div class="logo-icon">
                <svg class="menu-icon" style="color: white;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
                </svg>
            </div>
            <div class="logo-text">
                <h1>Sales Pipeline</h1>
                <p>Module 2</p>
            </div>
        </div>
    </div>

    <!-- Menu -->
    <nav style="flex: 1; overflow-y: auto; padding: 1rem 0;">

         <!-- Pipeline -->
        <div class="menu-section">
            <div class="section-label">Dashboard</div>
            <a href="${pageContext.request.contextPath}/sale/dashboard" 
               class="menu-item ${ACTIVE_MENU=='DASHBOARD'?'active':''}">
                <svg class="menu-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17V7m0 10a2 2 0 01-2 2H5a2 2 0 01-2-2V7a2 2 0 012-2h2a2 2 0 012 2m0 10a2 2 0 002 2h2a2 2 0 002-2M9 7a2 2 0 012-2h2a2 2 0 012 2m0 10V7m0 10a2 2 0 002 2h2a2 2 0 002-2V7a2 2 0 00-2-2h-2a2 2 0 00-2 2"/>
                </svg>
                My Dashboard
            </a>
           
        </div>
        
        <!-- Pipeline -->
        <div class="menu-section">
            <div class="section-label">Pipeline</div>
            <a href="${pageContext.request.contextPath}/sale/opportunity/kanban" 
               class="menu-item ${ACTIVE_MENU=='OPP_KANBAN'?'active':''}">
                <svg class="menu-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17V7m0 10a2 2 0 01-2 2H5a2 2 0 01-2-2V7a2 2 0 012-2h2a2 2 0 012 2m0 10a2 2 0 002 2h2a2 2 0 002-2M9 7a2 2 0 012-2h2a2 2 0 012 2m0 10V7m0 10a2 2 0 002 2h2a2 2 0 002-2V7a2 2 0 00-2-2h-2a2 2 0 00-2 2"/>
                </svg>
                Pipeline Kanban
            </a>
            <a href="${pageContext.request.contextPath}/sale/opportunity/list" 
               class="menu-item ${ACTIVE_MENU=='OPP_LIST'?'active':''}">
                <svg class="menu-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 10h16M4 14h16M4 18h16"/>
                </svg>
                Pipeline List
            </a>
            <a href="${pageContext.request.contextPath}/sale/opportunity/statistics" 
               class="menu-item ${ACTIVE_MENU=='OPP_STATS'?'active':''}">
                <svg class="menu-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
                </svg>
                Pipeline Statistics
            </a>
            <a href="${pageContext.request.contextPath}/sale/opportunity/forecast" 
               class="menu-item ${ACTIVE_MENU=='OPP_FORECAST'?'active':''}">
                <svg class="menu-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/>
                </svg>
                Sales Forecast
            </a>
        </div>

        <!-- Opportunity -->
        <div class="menu-section">
            <div class="section-label">Opportunity</div>
            <a href="${pageContext.request.contextPath}/sale/opportunity/create" 
               class="menu-item ${ACTIVE_MENU=='OPP_CREATE'?'active':''}">
                <svg class="menu-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                </svg>
                Tạo Opportunity
            </a>
            <a href="${pageContext.request.contextPath}/sale/opportunity/list-all" 
               class="menu-item ${ACTIVE_MENU=='OPP_LIST_ALL'?'active':''}">
                <svg class="menu-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
                </svg>
                Danh sách Opportunity
            </a>
            <a href="${pageContext.request.contextPath}/sale/opportunity/history" 
               class="menu-item ${ACTIVE_MENU=='OPP_HISTORY'?'active':''}">
                <svg class="menu-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                Lịch sử Opportunity
            </a>
            <a href="${pageContext.request.contextPath}/sale/lead/convert" 
               class="menu-item ${ACTIVE_MENU=='LEAD_CONVERT'?'active':''}">
                <svg class="menu-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7h12m0 0l-4-4m4 4l-4 4m0 6H4m0 0l4 4m-4-4l4-4"/>
                </svg>
                Convert Lead
            </a>
        </div>

        <!-- Lead -->
        <div class="menu-section">
            <div class="section-label">Lead</div>
            <a href="${pageContext.request.contextPath}/sale/lead/list" 
               class="menu-item ${ACTIVE_MENU=='OPP_CREATE'?'active':''}">
                <svg class="menu-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
                </svg>
                Danh sách Lead
            </a>
        </div>
        <!-- Quotation -->
        <div class="menu-section">
            <div class="section-label">Báo giá</div>
            <a href="${pageContext.request.contextPath}/sale/quotation/create" 
               class="menu-item ${ACTIVE_MENU=='QUOT_CREATE'?'active':''}">
                <svg class="menu-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                </svg>
                Tạo báo giá
            </a>
            <a href="${pageContext.request.contextPath}/sale/quotation/list" 
               class="menu-item ${ACTIVE_MENU=='QUOT_LIST'?'active':''}">
                <svg class="menu-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                </svg>
                Danh sách báo giá
            </a>
            <a href="${pageContext.request.contextPath}/sale/quotation/tracking" 
               class="menu-item ${ACTIVE_MENU=='QUOT_TRACK'?'active':''}">
                <svg class="menu-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                </svg>
                Theo dõi trạng thái
            </a>
        </div>

        <!-- Proposal -->
        <div class="menu-section">
            <div class="section-label">Đề xuất</div>
            <a href="${pageContext.request.contextPath}/sale/proposal/create" 
               class="menu-item ${ACTIVE_MENU=='PROP_CREATE'?'active':''}">
                <svg class="menu-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                </svg>
                Tạo Proposal
            </a>
            <a href="${pageContext.request.contextPath}/sale/proposal/list" 
               class="menu-item ${ACTIVE_MENU=='PROP_LIST'?'active':''}">
                <svg class="menu-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/>
                </svg>
                Danh sách Proposal
            </a>
        </div>

        <!-- Activity -->
        <div class="menu-section">
            <div class="section-label">Hoạt động</div>
            <a href="${pageContext.request.contextPath}/sale/activity/calendar" 
               class="menu-item ${ACTIVE_MENU=='ACT_CALENDAR'?'active':''}">
                <svg class="menu-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                </svg>
                Lịch hẹn
            </a>
            <a href="${pageContext.request.contextPath}/sale/task/list" 
               class="menu-item ${ACTIVE_MENU=='TASK_LIST'?'active':''}">
                <svg class="menu-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"/>
                </svg>
                Công việc
            </a>
            <a href="${pageContext.request.contextPath}/sale/activity/log" 
               class="menu-item ${ACTIVE_MENU=='ACT_LOG'?'active':''}">
                <svg class="menu-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"/>
                </svg>
                Ghi nhận hoạt động
            </a>
            <a href="${pageContext.request.contextPath}/sale/activity/list" 
               class="menu-item ${ACTIVE_MENU=='ACT_LIST'?'active':''}">
                <svg class="menu-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 10h16M4 14h16M4 18h16"/>
                </svg>
                Danh sách Activity
            </a>
        </div>

        <!-- Reports -->
        <div class="menu-section">
            <div class="section-label">Báo cáo</div>
            <a href="${pageContext.request.contextPath}/sale/report/pipeline" 
               class="menu-item ${ACTIVE_MENU=='RPT_PIPELINE'?'active':''}">
                <svg class="menu-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
                </svg>
                Pipeline
            </a>
            <a href="${pageContext.request.contextPath}/sale/report/revenue" 
               class="menu-item ${ACTIVE_MENU=='RPT_REVENUE'?'active':''}">
                <svg class="menu-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                Doanh thu
            </a>
            <a href="${pageContext.request.contextPath}/sale/report/win-loss" 
               class="menu-item ${ACTIVE_MENU=='RPT_WINLOSS'?'active':''}">
                <svg class="menu-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                Win / Loss
            </a>
            <a href="${pageContext.request.contextPath}/sale/report/quotation" 
               class="menu-item ${ACTIVE_MENU=='RPT_QUOTATION'?'active':''}">
                <svg class="menu-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"/>
                </svg>
                Báo cáo Quotation
            </a>
            <a href="${pageContext.request.contextPath}/sale/report/performance" 
               class="menu-item ${ACTIVE_MENU=='RPT_PERFORMANCE'?'active':''}">
                <svg class="menu-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                </svg>
                Performance cá nhân
            </a>
        </div>

    </nav>

    <!-- Footer -->
    <div class="sidebar-footer">
        <span class="badge">SALES MODULE</span>
    </div>

</aside>
