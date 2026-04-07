<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<aside class="d-flex flex-column vh-100 position-fixed start-0 top-0 bg-white border-end" style="width: 260px; z-index: 1040;">

    <div class="p-3 border-bottom">
        <a href="${pageContext.request.contextPath}/support/dashboard" class="d-flex align-items-center gap-2 text-decoration-none">
            <div class="d-flex align-items-center justify-content-center rounded bg-info text-white" style="width: 40px; height: 40px;">
                <i class="bi bi-cloud-check-fill fs-5"></i>
            </div>
            <div>
                <h6 class="mb-0 fw-bold text-dark">CRM Support</h6>
                <small class="text-muted" style="font-size: 11px;">Hệ thống hỗ trợ</small>
            </div>
        </a>
    </div>

    <nav class="flex-grow-1 overflow-auto py-2" id="sidebarNav">

        <div class="mb-1">
            <div class="px-3 py-2">
                <small class="text-uppercase text-muted fw-semibold" style="font-size: 10px; letter-spacing: 0.5px;">Main Menu</small>
            </div>
            <ul class="nav flex-column px-2">
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/support/dashboard" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${pageTitle == 'Tổng quan' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-speedometer2"></i>
                        <span>Tổng quan</span>
                    </a>
                </li>

                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/support/activities" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${pageTitle == 'Lịch sử hoạt động' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-clock-history"></i>
                        <span class="flex-grow-1">Lịch sử hoạt động</span>
                        <span class="badge bg-danger rounded-pill" style="font-size: 9px;">New</span>
                    </a>
                </li>

                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/support/customers" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${pageTitle == 'Quản lý Customer' || pageTitle == 'Danh sách khách hàng' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-people"></i>
                        <span>Khách hàng</span>
                    </a>
                </li>

                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/support/leads" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${pageTitle == 'Quản lý Leads' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-person-plus"></i>
                        <span>Quản lý Leads</span>
                    </a>
                </li>

                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/support/queue" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${pageTitle == 'Hàng chờ' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-hourglass-split"></i>
                        <span>Hàng chờ</span>
                    </a>
                </li>

                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/support/search" 
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${pageTitle == 'Tìm kiếm tổng hợp' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-search"></i>
                        <span>Tìm kiếm khách hàng</span>
                    </a>
                </li>
                
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/support/receive"
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${pageTitle == 'Phiếu hỗ trợ được phân công' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-inbox-fill"></i>
                        <span>Tiếp nhận</span>
                        <span id="receiveBadge" class="badge bg-danger rounded-pill ms-auto shadow-sm" style="display: none;">0</span>
                    </a>
                </li>
            </ul>
        </div>

        <div class="mb-1 mt-3">
            <div class="px-3 py-2">
                <small class="text-uppercase text-muted fw-semibold" style="font-size: 10px; letter-spacing: 0.5px;">Công việc</small>
            </div>
            <ul class="nav flex-column px-2">
                <li class="nav-item mb-1">
                    <a href="${pageContext.request.contextPath}/support/task/list"
                       class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 ${pageTitle == 'Công việc của tôi' ? 'active bg-primary text-white' : 'text-body-secondary'}">
                        <i class="bi bi-list-task"></i>
                        <span>Công việc của tôi</span>
                    </a>
                </li>
            </ul>
        </div>

        <div class="mb-1 mt-3">
            <div class="px-3 py-2">
                <small class="text-uppercase text-muted fw-semibold" style="font-size: 10px; letter-spacing: 0.5px;">Báo cáo & Phản hồi</small>
            </div>
            <ul class="nav flex-column px-2">
                <li class="nav-item mb-1">
                    <a href="#" class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 text-body-secondary">
                        <i class="bi bi-chat-heart"></i>
                        <span>Phản hồi khách hàng</span>
                    </a>
                </li>
                <li class="nav-item mb-1">
                    <a href="#" class="nav-link rounded-2 d-flex align-items-center gap-2 py-2 px-3 text-body-secondary">
                        <i class="bi bi-bar-chart-line"></i>
                        <span>Báo cáo hiệu suất</span>
                    </a>
                </li>
            </ul>
        </div>

    </nav>

    <div class="p-3 border-top">
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm w-100 d-flex align-items-center justify-content-center gap-2 py-2 border-0 fw-bold">
            <i class="bi bi-box-arrow-left"></i>
            <span>ĐĂNG XUẤT</span>
        </a>
    </div>

</aside>

<style>
    .nav-link:not(.active):hover {
        background-color: #f8f9fa !important;
        color: #0d6efd !important;
    }
    .nav-link.active {
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
    }
</style>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    (function () {
        var nav = document.getElementById('sidebarNav');
        if (!nav)
            return;
        var saved = sessionStorage.getItem('sidebarScroll_Support');
        if (saved)
            nav.scrollTop = parseInt(saved, 10);
        nav.addEventListener('scroll', function () {
            sessionStorage.setItem('sidebarScroll_Support', nav.scrollTop);
        });
    })();

    // --- THÊM MỚI: SCRIPT KIỂM TRA THÔNG BÁO REAL-TIME ---
    function checkNewNotifications() {
        $.get('${pageContext.request.contextPath}/support/api/notifications', function(data) {
            let count = parseInt(data);
            if(count > 0) {
                $('#receiveBadge').text(count).fadeIn(); // Hiện chấm đỏ kèm số
            } else {
                $('#receiveBadge').fadeOut(); // Ẩn đi nếu không có
            }
        });
    }

    $(document).ready(function() {
        // Chạy ngay khi tải trang
        checkNewNotifications();
        // Lặp lại mỗi 5 giây (5000ms)
        setInterval(checkNewNotifications, 5000); 
    });
</script>