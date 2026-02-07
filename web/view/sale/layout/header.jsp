<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<style>
    .header-container {
        background: white;
        border-bottom: 1px solid #e2e8f0;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
    }
    
    .search-box {
        position: relative;
    }
    
    .search-input {
        padding: 0.5rem 1rem 0.5rem 2.5rem;
        border: 1px solid #e2e8f0;
        border-radius: 0.5rem;
        width: 30rem;
        font-size: 0.875rem;
        transition: all 0.2s;
    }
    
    .search-input:focus {
        outline: none;
        border-color: #60a5fa;
        box-shadow: 0 0 0 3px rgba(96, 165, 250, 0.1);
    }
    
    .search-icon {
        position: absolute;
        left: 0.75rem;
        top: 50%;
        transform: translateY(-50%);
        color: #94a3b8;
        width: 1.125rem;
        height: 1.125rem;
    }
    
    .header-action {
        position: relative;
        padding: 0.5rem;
        border-radius: 0.5rem;
        color: #64748b;
        transition: all 0.15s;
        cursor: pointer;
    }
    
    .header-action:hover {
        background: #f1f5f9;
        color: #3b82f6;
    }
    
    .notification-badge {
        position: absolute;
        top: 0.25rem;
        right: 0.25rem;
        background: linear-gradient(135deg, #fb923c, #f97316);
        color: white;
        font-size: 0.625rem;
        font-weight: 700;
        padding: 0.125rem 0.375rem;
        border-radius: 0.75rem;
        min-width: 1.125rem;
        text-align: center;
    }
    
    .user-avatar {
        width: 2rem;
        height: 2rem;
        border-radius: 0.5rem;
        background: linear-gradient(135deg, #60a5fa, #3b82f6);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: 600;
        font-size: 0.875rem;
        cursor: pointer;
        border: 2px solid #e2e8f0;
        transition: all 0.2s;
    }
    
    .user-avatar:hover {
        border-color: #60a5fa;
        box-shadow: 0 0 0 3px rgba(96, 165, 250, 0.1);
    }
    
    .breadcrumb {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        font-size: 0.875rem;
    }
    
    .breadcrumb-item {
        color: #64748b;
    }
    
    .breadcrumb-item.active {
        color: #1e293b;
        font-weight: 500;
    }
    
    .breadcrumb-separator {
        color: #cbd5e1;
    }
    
    .quick-action-btn {
        padding: 0.5rem 1rem;
        background: linear-gradient(135deg, #60a5fa, #3b82f6);
        color: white;
        border: none;
        border-radius: 0.5rem;
        font-size: 0.875rem;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.15s;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    
    .quick-action-btn:hover {
        box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        transform: translateY(-1px);
    }
</style>

<header class="header-container" style="position: fixed; top: 0; left: 16rem; right: 0; z-index: 40; height: 4rem;">
    <div style="display: flex; align-items: center; justify-content: space-between; height: 100%; padding: 0 1.5rem;">
        
        <!-- Left: Breadcrumb & Page Title -->
        <div style="display: flex; flex-direction: column; gap: 0.25rem;">
            <div class="breadcrumb">
                <span class="breadcrumb-item">Sales Pipeline</span>
                <span class="breadcrumb-separator">/</span>
                <span class="breadcrumb-item active">${pageTitle != null ? pageTitle : 'Dashboard'}</span>
            </div>
        </div>
        
        <!-- Center: Search -->
        <div class="search-box">
            <svg class="search-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
            </svg>
            <input type="text" class="search-input" placeholder="Tìm kiếm opportunity, khách hàng...">
        </div>
        
        <!-- Right: Actions -->
        <div style="display: flex; align-items: center; gap: 1rem;">
            
            <!-- Notifications -->
            <div class="header-action">
                <svg style="width: 1.25rem; height: 1.25rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/>
                </svg>
                <span class="notification-badge">5</span>
            </div>
            
            <!-- Tasks -->
            <div class="header-action">
                <svg style="width: 1.25rem; height: 1.25rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"/>
                </svg>
            </div>
            
            <!-- Messages -->
            <div class="header-action">
                <svg style="width: 1.25rem; height: 1.25rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z"/>
                </svg>
                <span class="notification-badge">2</span>
            </div>
            
            <!-- Divider -->
            <div style="width: 1px; height: 2rem; background: #e2e8f0;"></div>
            
            <!-- User Profile -->
            <div style="display: flex; align-items: center; gap: 0.75rem;">
                <div style="text-align: right;">
                    <div style="font-size: 0.875rem; font-weight: 500; color: #1e293b;">
                        ${sessionScope.userName != null ? sessionScope.userName : 'Sales Manager'}
                    </div>
                    <div style="font-size: 0.75rem; color: #64748b;">
                        Sales Team
                    </div>
                </div>
                <div class="user-avatar">
                    ${sessionScope.userInitial != null ? sessionScope.userInitial : 'SM'}
                </div>
            </div>
            
        </div>
        
    </div>
</header>
