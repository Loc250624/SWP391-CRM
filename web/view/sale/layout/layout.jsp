<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle != null ? pageTitle : 'Sales Pipeline'} - CRM Pro</title>
    
    <!-- HeroUI CSS -->
    <link href="https://cdn.jsdelivr.net/npm/@heroui/react@latest/dist/heroui.min.css" rel="stylesheet">
    
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    
    <!-- Chart.js (if needed) -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');
        
        body {
            font-family: 'Inter', sans-serif;
        }
        
        ::-webkit-scrollbar {
            width: 8px;
            height: 8px;
        }
        
        ::-webkit-scrollbar-track {
            background: #1e293b;
        }
        
        ::-webkit-scrollbar-thumb {
            background: #475569;
            border-radius: 4px;
        }
        
        ::-webkit-scrollbar-thumb:hover {
            background: #64748b;
        }
    </style>
</head>
<body class="bg-slate-50">
    
    <div class="flex min-h-screen">
        
        <!-- Sidebar -->
        <jsp:include page="sidebar.jsp"/>
        
        <!-- Main Content -->
        <main class="flex-1 ml-64 min-h-screen">
            
            <!-- Page Content -->
            <div class="p-6">
                <jsp:include page="${CONTENT_PAGE}" />
            </div>
            
        </main>
        
    </div>

</body>
</html>