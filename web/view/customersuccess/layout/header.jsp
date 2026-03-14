<%-- 
    Document   : header
    Created on : Feb 15, 2026, 5:19:22 PM
    Author     : admin
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<header class="navbar navbar-expand bg-white border-bottom shadow-sm position-fixed" style="left: 250px; right: 0; top: 0; height: 64px; z-index: 1020;">
    <div class="container-fluid px-4">
        
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/support/dashboard" class="text-decoration-none text-muted">
                        <i class="bi bi-headset me-1"></i>Support Center
                    </a>
                </li>
                <li class="breadcrumb-item active" aria-current="page">
                    ${pageTitle != null ? pageTitle : 'Dashboard'}
                </li>
            </ol>
        </nav>
        
<!--        <form class="d-none d-lg-flex mx-4" style="width: 400px;">
            <div class="input-group">
                <span class="input-group-text bg-light border-end-0">
                    <i class="bi bi-search text-muted"></i>
                </span>
                <input type="text" class="form-control bg-light border-start-0" 
                       placeholder="Tìm mã ticket, tên khách hàng...">
            </div>
        </form>
        -->
        <div class="d-flex align-items-center gap-2">
            
            <div class="dropdown">
                <button class="btn btn-info btn-sm text-white dropdown-toggle d-flex align-items-center gap-1" 
                        type="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="bi bi-plus-lg"></i>
                    <span class="d-none d-md-inline">Hỗ trợ nhanh</span>
                </button>
                <ul class="dropdown-menu dropdown-menu-end shadow border-0">
                    <li>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/support/ticket/create">
                            <i class="bi bi-ticket-perforated me-2 text-danger"></i>Tạo Ticket mới
                        </a>
                    </li>
                   
                    <li><hr class="dropdown-divider"></li>
                    <li>
                        <a class="dropdown-item" href="#">
                            <i class="bi bi-chat-left-quote me-2 text-primary"></i>Ghi nhận Feedback
                        </a>
                    </li>
                </ul>
            </div>
            
            <div class="vr mx-2 d-none d-md-block"></div>
            
            <div class="dropdown">
                <button class="btn btn-light btn-sm position-relative" type="button" 
                        data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="bi bi-bell"></i>
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size: 10px;">
                        3
                    </span>
                </button>
                <ul class="dropdown-menu dropdown-menu-end shadow border-0" style="width: 320px;">
                    <li class="dropdown-header d-flex justify-content-between align-items-center">
                        <span class="fw-semibold">Thông báo mới</span>
                    </li>
                    <li><hr class="dropdown-divider"></li>
                    <li>
                        <a class="dropdown-item d-flex gap-2 py-2" href="#">
                            <div class="bg-primary bg-opacity-10 rounded p-2">
                                <i class="bi bi-envelope text-primary"></i>
                            </div>
<!--                            <div class="flex-grow-1">
                                <div class="small fw-medium">Khách hàng vừa phản hồi Ticket #TK-99</div>
                                <div class="text-muted" style="font-size: 11px;">5 phút trước</div>
                            </div>-->
                        </a>
                    </li>
                    <li>
                        <a class="dropdown-item d-flex gap-2 py-2" href="#">
                            <div class="bg-warning bg-opacity-10 rounded p-2">
                                <i class="bi bi-exclamation-triangle text-warning"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="small fw-medium">Ticket #TK-45 đã quá hạn xử lý</div>
                                <div class="text-muted" style="font-size: 11px;">1 giờ trước</div>
                            </div>
                        </a>
                    </li>
                    <li><hr class="dropdown-divider"></li>
                    <li>
                        <a class="dropdown-item text-center small text-primary" href="#">Xem tất cả</a>
                    </li>
                </ul>
            </div>
            
            <div class="vr mx-2"></div>
            
            <div class="dropdown">
                <button class="btn btn-light btn-sm d-flex align-items-center gap-2 px-2 border-0" 
                        type="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <div class="d-none d-md-block text-end">
                        <div class="small fw-medium lh-sm">
                            ${sessionScope.user.lastName} ${sessionScope.user.firstName}
                        </div>
                        <div class="text-muted" style="font-size: 11px;">${sessionScope.user.employeeCode}</div>
                    </div>
                    <img src="https://ui-avatars.com/api/?name=${sessionScope.user.lastName}+${sessionScope.user.firstName}&background=0D8ABC&color=fff" 
                         class="rounded border" width="36" height="36">
                </button>
                <ul class="dropdown-menu dropdown-menu-end shadow border-0">
                    <li class="dropdown-header">
                        <div class="fw-semibold">${sessionScope.user.lastName} ${sessionScope.user.firstName}</div>
                        <div class="text-muted small">${sessionScope.user.email}</div>
                    </li>
                    <li><hr class="dropdown-divider"></li>
                    <li>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                            <i class="bi bi-person me-2"></i>Cài đặt tài khoản
                        </a>
                    </li>
                    <li>
                        <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                            <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
                        </a>
                    </li>
                </ul>
            </div>
            
        </div>
    </div>
</header>