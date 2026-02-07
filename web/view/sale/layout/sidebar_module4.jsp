<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<style>
    .sidebar4-container {
        background: linear-gradient(to bottom, #f0fdf4, #ecfeff);
        border-right: 1px solid #e2e8f0;
    }

    .menu4-section {
        margin-bottom: 1.5rem;
    }

    .section4-label {
        font-size: 0.75rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.06em;
        color: #0f766e;
        padding: 0.5rem 1rem;
        margin-bottom: 0.25rem;
    }

    .menu4-item {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        padding: 0.625rem 1rem;
        margin: 0.125rem 0.5rem;
        border-radius: 0.5rem;
        color: #0f172a;
        text-decoration: none;
        font-size: 0.9rem;
        transition: all 0.15s ease;
        position: relative;
    }

    .menu4-item:hover {
        background-color: #ccfbf1;
        color: #0f766e;
    }

    .menu4-item.active {
        background: linear-gradient(to right, #14b8a6, #06b6d4);
        color: white;
        font-weight: 600;
        box-shadow: 0 1px 3px rgba(20, 184, 166, 0.35);
    }

    .menu4-item.active::before {
        content: '';
        position: absolute;
        left: 0;
        top: 50%;
        transform: translateY(-50%);
        width: 3px;
        height: 60%;
        background: #f59e0b;
        border-radius: 0 2px 2px 0;
    }

    .menu4-icon {
        width: 1.25rem;
        height: 1.25rem;
        flex-shrink: 0;
    }

    .logo4-container {
        padding: 1.5rem 1rem;
        border-bottom: 1px solid #e2e8f0;
        background: white;
    }

    .logo4-box {
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }

    .logo4-icon {
        width: 2.5rem;
        height: 2.5rem;
        background: linear-gradient(135deg, #14b8a6 0%, #06b6d4 60%, #f59e0b 100%);
        border-radius: 0.5rem;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 2px 8px rgba(6, 182, 212, 0.25);
    }

    .logo4-text h1 {
        font-size: 1.05rem;
        font-weight: 800;
        color: #0f172a;
        margin: 0;
    }

    .logo4-text p {
        font-size: 0.75rem;
        color: #64748b;
        margin: 0;
    }

    .sidebar4-footer {
        padding: 1rem;
        border-top: 1px solid #e2e8f0;
        background: white;
        text-align: center;
    }

    .badge4 {
        display: inline-block;
        background: linear-gradient(to right, #14b8a6, #06b6d4);
        color: white;
        padding: 0.25rem 0.625rem;
        border-radius: 1rem;
        font-size: 0.75rem;
        font-weight: 700;
        letter-spacing: 0.02em;
    }
</style>

<aside class="sidebar4-container" style="width: 16rem; height: 100vh; display: flex; flex-direction: column; position: fixed; left: 0; top: 0; z-index: 50;">

    <!-- Logo -->
    <div class="logo4-container">
        <div class="logo4-box">
            <div class="logo4-icon">
                <svg class="menu4-icon" style="color: white;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M17 20h5V4H2v16h5m10 0V10M7 20V10m5-6l5 5-5 5-5-5 5-5z"/>
                </svg>
            </div>
            <div class="logo4-text">
                <h1>Activities & Collaboration</h1>
                <p>Module 4</p>
            </div>
        </div>
    </div>

    <!-- Menu -->
    <nav style="flex: 1; overflow-y: auto; padding: 1rem 0;">

        <!-- Tổng quan -->
        <div class="menu4-section">
            <div class="section4-label">Tổng quan</div>
            <a href="${pageContext.request.contextPath}/sale/activity/calendar" 
               class="menu4-item ${ACTIVE_MENU=='ACT_CALENDAR'?'active':''}">
                <svg class="menu4-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                </svg>
                Lịch hoạt động
            </a>
            <a href="${pageContext.request.contextPath}/sale/activity/list" 
               class="menu4-item ${ACTIVE_MENU=='ACT_LIST'?'active':''}">
                <svg class="menu4-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 10h16M4 14h16M4 18h16"/>
                </svg>
                Danh sách Activity
            </a>
        </div>

        <!-- Công việc -->
        <div class="menu4-section">
            <div class="section4-label">Công việc</div>
            <a href="${pageContext.request.contextPath}/sale/task/list" 
               class="menu4-item ${ACTIVE_MENU=='TASK_LIST'?'active':''}">
                <svg class="menu4-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"/>
                </svg>
                Danh sách công việc
            </a>
            <a href="${pageContext.request.contextPath}/sale/task/form?action=create" 
               class="menu4-item ${ACTIVE_MENU=='TASK_CREATE'?'active':''}">
                <svg class="menu4-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                </svg>
                Tạo công việc
            </a>
        </div>

        <!-- Nhắc nhở -->
        <div class="menu4-section">
            <div class="section4-label">Nhắc nhở</div>
            <a href="${pageContext.request.contextPath}/sale/task/reminder" 
               class="menu4-item ${ACTIVE_MENU=='TASK_REMINDER'?'active':''}">
                <svg class="menu4-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/>
                </svg>
                Lịch nhắc việc
            </a>
            <a href="${pageContext.request.contextPath}/sale/task/calendar" 
               class="menu4-item ${ACTIVE_MENU=='TASK_CALENDAR'?'active':''}">
                <svg class="menu4-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                </svg>
                Lịch công việc
            </a>
        </div>

        <!-- Báo cáo -->
        <div class="menu4-section">
            <div class="section4-label">Báo cáo</div>
            <a href="${pageContext.request.contextPath}/sale/task/report" 
               class="menu4-item ${ACTIVE_MENU=='TASK_REPORT'?'active':''}">
                <svg class="menu4-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17V7m0 10a2 2 0 01-2 2H5a2 2 0 01-2-2V7a2 2 0 012-2h2a2 2 0 012 2m0 10a2 2 0 002 2h2a2 2 0 002-2M9 7a2 2 0 012-2h2a2 2 0 012 2m0 10V7m0 10a2 2 0 002 2h2a2 2 0 002-2V7a2 2 0 00-2-2h-2a2 2 0 00-2 2"/>
                </svg>
                Báo cáo hoàn thành
            </a>
        </div>

        <!-- Định kỳ -->
        <div class="menu4-section">
            <div class="section4-label">Định kỳ</div>
            <a href="${pageContext.request.contextPath}/sale/task/recurring" 
               class="menu4-item ${ACTIVE_MENU=='TASK_RECURRING'?'active':''}">
                <svg class="menu4-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                Công việc định kỳ
            </a>
        </div>

    </nav>

    <!-- Footer -->
    <div class="sidebar4-footer">
        <span class="badge4">MODULE 4</span>
    </div>

</aside>
