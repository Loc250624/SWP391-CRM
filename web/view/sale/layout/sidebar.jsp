<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<aside class="w-64 h-screen bg-gradient-to-b from-slate-900 to-slate-800 text-slate-100 flex flex-col fixed left-0 top-0 shadow-xl z-50">
    
    <!-- Logo / Branding -->
    <div class="px-6 py-6 border-b border-slate-700/50">
        <div class="flex items-center gap-3">
            <div class="w-10 h-10 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-lg flex items-center justify-center">
                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/>
                </svg>
            </div>
            <div>
                <h1 class="text-xl font-bold">CRM Pro</h1>
                <p class="text-xs text-slate-400">Sales Pipeline</p>
            </div>
        </div>
    </div>

    <!-- Navigation Menu -->
    <nav class="flex-1 px-3 py-6 space-y-2 overflow-y-auto">
        
        <!-- Dashboard Section -->
        <div class="mb-4">
            <p class="px-4 text-xs font-semibold text-slate-500 uppercase tracking-wider mb-2">Overview</p>
            <a href="${pageContext.request.contextPath}/sales/dashboard"
               class="flex items-center gap-3 px-4 py-2.5 rounded-lg transition-all duration-200
               ${ACTIVE_MENU == 'DASHBOARD' ? 'bg-gradient-to-r from-blue-600 to-indigo-600 text-white shadow-lg' : 'text-slate-300 hover:bg-slate-800/50 hover:text-white'}">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
                </svg>
                <span class="font-medium">Dashboard</span>
            </a>
        </div>

        <!-- Sales Pipeline Section -->
        <div class="mb-4">
            <p class="px-4 text-xs font-semibold text-slate-500 uppercase tracking-wider mb-2">Pipeline</p>
            
            <a href="${pageContext.request.contextPath}/sales/leads"
               class="flex items-center gap-3 px-4 py-2.5 rounded-lg transition-all duration-200
               ${ACTIVE_MENU == 'LEADS' ? 'bg-gradient-to-r from-blue-600 to-indigo-600 text-white shadow-lg' : 'text-slate-300 hover:bg-slate-800/50 hover:text-white'}">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                </svg>
                <span class="font-medium">Leads</span>
            </a>

            <a href="${pageContext.request.contextPath}/sales/pipeline"
               class="flex items-center gap-3 px-4 py-2.5 rounded-lg transition-all duration-200
               ${ACTIVE_MENU == 'PIPELINE' ? 'bg-gradient-to-r from-blue-600 to-indigo-600 text-white shadow-lg' : 'text-slate-300 hover:bg-slate-800/50 hover:text-white'}">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                <span class="font-medium">Opportunities</span>
            </a>
        </div>

        <!-- Sales Operations Section -->
        <div class="mb-4">
            <p class="px-4 text-xs font-semibold text-slate-500 uppercase tracking-wider mb-2">Operations</p>
            
            <a href="${pageContext.request.contextPath}/sales/quotes"
               class="flex items-center gap-3 px-4 py-2.5 rounded-lg transition-all duration-200
               ${ACTIVE_MENU == 'QUOTES' ? 'bg-gradient-to-r from-blue-600 to-indigo-600 text-white shadow-lg' : 'text-slate-300 hover:bg-slate-800/50 hover:text-white'}">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                </svg>
                <span class="font-medium">Quotes</span>
            </a>

            <a href="${pageContext.request.contextPath}/sales/proposals"
               class="flex items-center gap-3 px-4 py-2.5 rounded-lg transition-all duration-200
               ${ACTIVE_MENU == 'PROPOSALS' ? 'bg-gradient-to-r from-blue-600 to-indigo-600 text-white shadow-lg' : 'text-slate-300 hover:bg-slate-800/50 hover:text-white'}">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"/>
                </svg>
                <span class="font-medium">Proposals</span>
            </a>

            <a href="${pageContext.request.contextPath}/sales/contracts"
               class="flex items-center gap-3 px-4 py-2.5 rounded-lg transition-all duration-200
               ${ACTIVE_MENU == 'CONTRACTS' ? 'bg-gradient-to-r from-blue-600 to-indigo-600 text-white shadow-lg' : 'text-slate-300 hover:bg-slate-800/50 hover:text-white'}">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                </svg>
                <span class="font-medium">Contracts</span>
            </a>
        </div>

        <!-- Customer & Activity Section -->
        <div class="mb-4">
            <p class="px-4 text-xs font-semibold text-slate-500 uppercase tracking-wider mb-2">Management</p>
            
            <a href="${pageContext.request.contextPath}/sales/accounts"
               class="flex items-center gap-3 px-4 py-2.5 rounded-lg transition-all duration-200
               ${ACTIVE_MENU == 'ACCOUNTS' ? 'bg-gradient-to-r from-blue-600 to-indigo-600 text-white shadow-lg' : 'text-slate-300 hover:bg-slate-800/50 hover:text-white'}">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
                </svg>
                <span class="font-medium">Accounts</span>
            </a>

            <a href="${pageContext.request.contextPath}/sales/contacts"
               class="flex items-center gap-3 px-4 py-2.5 rounded-lg transition-all duration-200
               ${ACTIVE_MENU == 'CONTACTS' ? 'bg-gradient-to-r from-blue-600 to-indigo-600 text-white shadow-lg' : 'text-slate-300 hover:bg-slate-800/50 hover:text-white'}">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                </svg>
                <span class="font-medium">Contacts</span>
            </a>

            <a href="${pageContext.request.contextPath}/sales/activities"
               class="flex items-center gap-3 px-4 py-2.5 rounded-lg transition-all duration-200
               ${ACTIVE_MENU == 'ACTIVITIES' ? 'bg-gradient-to-r from-blue-600 to-indigo-600 text-white shadow-lg' : 'text-slate-300 hover:bg-slate-800/50 hover:text-white'}">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                <span class="font-medium">Activities</span>
            </a>
        </div>

        <!-- Analytics Section -->
        <div class="mb-4">
            <p class="px-4 text-xs font-semibold text-slate-500 uppercase tracking-wider mb-2">Analytics</p>
            
            <a href="${pageContext.request.contextPath}/sales/reports"
               class="flex items-center gap-3 px-4 py-2.5 rounded-lg transition-all duration-200
               ${ACTIVE_MENU == 'REPORTS' ? 'bg-gradient-to-r from-blue-600 to-indigo-600 text-white shadow-lg' : 'text-slate-300 hover:bg-slate-800/50 hover:text-white'}">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                </svg>
                <span class="font-medium">Reports</span>
            </a>

            <a href="${pageContext.request.contextPath}/sales/forecasting"
               class="flex items-center gap-3 px-4 py-2.5 rounded-lg transition-all duration-200
               ${ACTIVE_MENU == 'FORECASTING' ? 'bg-gradient-to-r from-blue-600 to-indigo-600 text-white shadow-lg' : 'text-slate-300 hover:bg-slate-800/50 hover:text-white'}">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 12l3-3 3 3 4-4M8 21l4-4 4 4M3 4h18M4 4h16v12a1 1 0 01-1 1H5a1 1 0 01-1-1V4z"/>
                </svg>
                <span class="font-medium">Forecasting</span>
            </a>
        </div>

    </nav>

    <!-- User Profile Footer -->
    <div class="px-4 py-4 border-t border-slate-700/50">
        <div class="flex items-center gap-3 px-2 py-2 rounded-lg hover:bg-slate-800/50 cursor-pointer transition-all">
            <div class="w-10 h-10 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-full flex items-center justify-center text-white font-semibold">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        ${sessionScope.user.firstName.substring(0,1)}${sessionScope.user.lastName.substring(0,1)}
                    </c:when>
                    <c:otherwise>
                        SM
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="flex-1 min-w-0">
                <p class="text-sm font-medium text-white truncate">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            ${sessionScope.user.fullName}
                        </c:when>
                        <c:otherwise>
                            Sales Manager
                        </c:otherwise>
                    </c:choose>
                </p>
                <p class="text-xs text-slate-400">Sales Manager</p>
            </div>
            <svg class="w-5 h-5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"/>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
            </svg>
        </div>
    </div>

</aside>