<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<aside class="sidebar position-fixed top-0 start-0 bottom-0 bg-dark text-white shadow-lg" 
       style="width: 250px; z-index: 1030; background: linear-gradient(180deg, #1e293b 0%, #0f172a 100%);">
    
    <div class="sidebar-brand px-4 py-4 d-flex align-items-center border-bottom border-secondary border-opacity-25" style="height: 64px;">
        <i class="bi bi-cloud-check-fill text-info fs-3 me-2"></i>
        <span class="fs-5 fw-bold tracking-tight text-uppercase">CRM Support</span>
    </div>

    <div class="sidebar-menu py-3">
        <div class="px-4 mb-2 small text-uppercase text-muted fw-bold" style="font-size: 11px; letter-spacing: 1px;">
            Main Menu
        </div>
        
        <nav class="nav flex-column gap-1 px-2">
            <a href="${pageContext.request.contextPath}/support/dashboard" 
               class="nav-link text-white d-flex align-items-center py-2 px-3 rounded ${pageTitle == 'Tổng quan' ? 'bg-primary bg-opacity-25 border-start border-4 border-primary' : 'opacity-75'}">
                <i class="bi bi-speedometer2 me-3 fs-5"></i>
                <span>Tổng quan</span>
            </a>

            <a href="${pageContext.request.contextPath}/support/tickets" 
               class="nav-link text-white d-flex align-items-center py-2 px-3 rounded opacity-75">
                <i class="bi bi-ticket-perforated me-3 fs-5"></i>
                <span>Quản lý Ticket</span>
                <span class="badge bg-danger ms-auto rounded-pill" style="font-size: 10px;">New</span>
            </a>

            <a href="${pageContext.request.contextPath}/support/customers" 
               class="nav-link text-white d-flex align-items-center py-2 px-3 rounded ${pageTitle == 'Quản lý Customer' ? 'bg-primary bg-opacity-25 border-start border-4 border-primary' : 'opacity-75'}">
                <i class="bi bi-people me-3 fs-5"></i>
                <span>Khách hàng</span>
            </a>
            
            <div class="px-4 mt-4 mb-2 small text-uppercase text-muted fw-bold" style="font-size: 11px; letter-spacing: 1px;">
                Báo cáo & Phản hồi
            </div>

            <a href="#" class="nav-link text-white d-flex align-items-center py-2 px-3 rounded opacity-75">
                <i class="bi bi-chat-heart me-3 fs-5"></i>
                <span>Phản hồi khách hàng</span>
            </a>

            <a href="#" class="nav-link text-white d-flex align-items-center py-2 px-3 rounded opacity-75">
                <i class="bi bi-bar-chart-line me-3 fs-5"></i>
                <span>Báo cáo hiệu suất</span>
            </a>
        </nav>
    </div>

    <div class="sidebar-footer position-absolute bottom-0 start-0 end-0 p-3 border-top border-secondary border-opacity-25">
        <a href="${pageContext.request.contextPath}/logout" 
           class="btn btn-outline-danger w-100 d-flex align-items-center justify-content-center gap-2 py-2 border-0">
            <i class="bi bi-box-arrow-left"></i>
            <span>Đăng xuất</span>
        </a>
    </div>
</aside>

<style>
    .sidebar .nav-link:hover {
        background-color: rgba(255, 255, 255, 0.1);
        opacity: 1 !important;
        transition: all 0.3s ease;
    }
    .sidebar .nav-link {
        transition: all 0.3s ease;
    }
</style>