<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Success Dashboard</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f3f4f6;
        }
        
        /* Sidebar */
        .sidebar {
            height: 100vh;
            width: 250px;
            position: fixed;
            top: 0;
            left: 0;
            background-color: #1e293b;
            color: white;
            padding-top: 20px;
            transition: all 0.3s;
            z-index: 1000;
        }
        
        .sidebar-brand {
            text-align: center;
            font-size: 24px;
            font-weight: bold;
            color: #38bdf8;
            margin-bottom: 30px;
        }

        .sidebar a {
            padding: 15px 25px;
            text-decoration: none;
            font-size: 16px;
            color: #cbd5e1;
            display: block;
            transition: 0.3s;
        }

        .sidebar a:hover, .sidebar a.active {
            background-color: #334155;
            color: white;
            border-left: 4px solid #38bdf8;
        }

        .sidebar i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        /* Main Content */
        .main-content {
            margin-left: 250px;
            padding: 30px;
        }

        /* Header Profile */
        .header-profile {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: white;
            padding: 15px 25px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }
        
        /* Empty State (Vùng trống) */
        .empty-state {
            text-align: center;
            padding: 50px;
            color: #94a3b8;
        }
    </style>
</head>
<body>

    <c:if test="${sessionScope.account == null}">
        <c:redirect url="${pageContext.request.contextPath}/login"></c:redirect>
    </c:if>

    <div class="sidebar">
        <div class="sidebar-brand">
            <i class="fa-solid fa-cloud"></i> CRM System
        </div>
        <a href="#" class="active"><i class="fa-solid fa-chart-line"></i> Tổng quan</a>
        <a href="#"><i class="fa-solid fa-ticket"></i> Quản lý Ticket</a>
        <a href="#"><i class="fa-solid fa-users"></i> Khách hàng</a>
        <a href="#"><i class="fa-solid fa-comment-dots"></i> Phản hồi</a>
        <a href="#"><i class="fa-solid fa-gear"></i> Cài đặt</a>
        
        <a href="${pageContext.request.contextPath}/login" style="margin-top: 50px; color: #f87171;">
            <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
        </a>
    </div>

    <div class="main-content">
        
        <div class="header-profile">
            <div>
                <h4 style="font-weight: 600; margin: 0;">Dashboard</h4>
            </div>
            <div class="d-flex align-items-center">
                <div class="me-3 text-end">
                    <div style="font-weight: bold; color: #334155;">${sessionScope.account.fullName}</div>
                    <div style="font-size: 13px; color: #64748b;">${sessionScope.account.roleCode}</div>
                </div>
                <img src="https://ui-avatars.com/api/?name=${sessionScope.account.fullName}&background=0D8ABC&color=fff" class="rounded-circle" width="45">
            </div>
        </div>

        <div class="empty-state">
            <i class="fa-regular fa-folder-open" style="font-size: 48px; margin-bottom: 15px;"></i>
            <h5>Khu vực làm việc</h5>
            <p>Chọn một chức năng từ menu bên trái để bắt đầu.</p>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>