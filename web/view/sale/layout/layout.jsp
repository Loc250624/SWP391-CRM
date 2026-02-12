<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle != null ? pageTitle : 'Sales Pipeline'} - CRM Pro</title>
    
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    
    <!-- Chart.js (if needed) -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    
    <!-- Font Awesome (optional) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            background: #f8fafc;
        }
        
        /* Custom Scrollbar */
        ::-webkit-scrollbar {
            width: 8px;
            height: 8px;
        }
        
        ::-webkit-scrollbar-track {
            background: #f1f5f9;
            border-radius: 4px;
        }
        
        ::-webkit-scrollbar-thumb {
            background: #cbd5e1;
            border-radius: 4px;
        }
        
        ::-webkit-scrollbar-thumb:hover {
            background: #94a3b8;
        }
        
        /* Smooth transitions */
        * {
            transition: background-color 0.15s ease, border-color 0.15s ease, color 0.15s ease;
        }
        
        /* Layout Structure */
        .app-layout {
            display: flex;
            min-height: 100vh;
            background: #f8fafc;
        }
        
        .main-content {
            flex: 1;
            margin-left: 16rem; /* sidebar width */
            margin-top: 4rem; /* header height */
        }
        
        .content-wrapper {
            padding: 1.5rem;
            min-height: calc(100vh - 4rem);
        }
        
        /* Responsive */
        @media (max-width: 1024px) {
            .main-content {
                margin-left: 0;
            }
        }
    </style>
    
    <!-- Additional Custom CSS -->
    <c:if test="${not empty customCSS}">
        <style>${customCSS}</style>
    </c:if>
</head>
<body>
    
    <div class="app-layout">
        
        <!-- Sidebar -->
        <jsp:include page="sidebar.jsp"/>
        
        <!-- Header -->
        <jsp:include page="header.jsp"/>
        
        <!-- Main Content Area -->
        <main class="main-content">
            <div class="content-wrapper">
                
                <!-- Page Content -->
                <c:choose>
                    <c:when test="${not empty CONTENT_PAGE}">
                        <jsp:include page="${CONTENT_PAGE}" />
                    </c:when>
                    <c:otherwise>
                        <!-- Default Content -->
                        <div style="text-align: center; padding: 3rem; color: #94a3b8;">
                            <svg style="width: 4rem; height: 4rem; margin: 0 auto 1rem; color: #cbd5e1;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                            </svg>
                            <h3 style="font-size: 1.125rem; font-weight: 600; color: #64748b; margin-bottom: 0.5rem;">
                                No Content Page Specified
                            </h3>
                            <p style="font-size: 0.875rem;">
                                Please set CONTENT_PAGE variable
                            </p>
                        </div>
                    </c:otherwise>
                </c:choose>
                
            </div>
        </main>
        
    </div>
    
    <!-- JavaScript Libraries -->
    <script>
        // Global utility functions
        window.CRM = {
            showNotification: function(message, type = 'success') {
                // Implement notification system
                console.log(`[${type.toUpperCase()}] ${message}`);
            },
            
            confirmAction: function(message, callback) {
                if (confirm(message)) {
                    callback();
                }
            },
            
            formatCurrency: function(amount) {
                return new Intl.NumberFormat('vi-VN', {
                    style: 'currency',
                    currency: 'VND'
                }).format(amount);
            },
            
            formatDate: function(date) {
                return new Intl.DateTimeFormat('vi-VN').format(new Date(date));
            }
        };
    </script>
    
    <!-- Additional Custom JS -->
    <c:if test="${not empty customJS}">
        <script>${customJS}</script>
    </c:if>
    
</body>
</html>
