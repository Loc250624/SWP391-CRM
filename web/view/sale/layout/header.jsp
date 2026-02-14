<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!-- Header -->
<header class="navbar navbar-expand bg-white border-bottom shadow-sm position-fixed" style="left: 260px; right: 0; top: 0; height: 64px; z-index: 1020;">
    <div class="container-fluid px-4">
        
        <!-- Left: Breadcrumb -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/sale/dashboard" class="text-decoration-none text-muted">
                        <i class="bi bi-house-door me-1"></i>Sales Pipeline
                    </a>
                </li>
                <li class="breadcrumb-item active" aria-current="page">
                    ${pageTitle != null ? pageTitle : 'Dashboard'}
                </li>
            </ol>
        </nav>
        
        <!-- Center: Search -->
        <form class="d-none d-lg-flex mx-4" style="width: 400px;">
            <div class="input-group">
                <span class="input-group-text bg-light border-end-0">
                    <i class="bi bi-search text-muted"></i>
                </span>
                <input type="text" class="form-control bg-light border-start-0" 
                       placeholder="Tìm kiếm opportunity, khách hàng...">
            </div>
        </form>
        
        <!-- Right: Actions -->
        <div class="d-flex align-items-center gap-2">
            
            <!-- Quick Add Button -->
            <div class="dropdown">
                <button class="btn btn-primary btn-sm dropdown-toggle d-flex align-items-center gap-1" 
                        type="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="bi bi-plus-lg"></i>
                    <span class="d-none d-md-inline">Tạo mới</span>
                </button>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/sale/opportunity/form">
                            <i class="bi bi-lightning me-2 text-warning"></i>Opportunity
                        </a>
                    </li>
                    <li>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/sale/quotation/create">
                            <i class="bi bi-file-earmark-text me-2 text-info"></i>Báo giá
                        </a>
                    </li>
                    <li>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/sale/proposal/create">
                            <i class="bi bi-file-earmark-richtext me-2 text-success"></i>Proposal
                        </a>
                    </li>
                    <li><hr class="dropdown-divider"></li>
                    <li>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/sale/activity/log">
                            <i class="bi bi-journal-plus me-2 text-secondary"></i>Ghi nhận hoạt động
                        </a>
                    </li>
                    <li>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/sale/task/create">
                            <i class="bi bi-check2-square me-2 text-primary"></i>Task mới
                        </a>
                    </li>
                </ul>
            </div>
            
            <!-- Divider -->
            <div class="vr mx-2 d-none d-md-block"></div>
            
            <!-- Notifications -->
            <div class="dropdown">
                <button class="btn btn-light btn-sm position-relative" type="button" 
                        data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="bi bi-bell"></i>
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size: 10px;">
                        5
                    </span>
                </button>
                <ul class="dropdown-menu dropdown-menu-end" style="width: 320px;">
                    <li class="dropdown-header d-flex justify-content-between align-items-center">
                        <span class="fw-semibold">Thông báo</span>
                        <a href="#" class="text-decoration-none small">Đánh dấu đã đọc</a>
                    </li>
                    <li><hr class="dropdown-divider"></li>
                    <li>
                        <a class="dropdown-item d-flex gap-2 py-2" href="#">
                            <div class="bg-success bg-opacity-10 rounded p-2">
                                <i class="bi bi-trophy text-success"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="small fw-medium">Opportunity #OPP-0025 đã Won</div>
                                <div class="text-muted" style="font-size: 11px;">2 phút trước</div>
                            </div>
                        </a>
                    </li>
                    <li>
                        <a class="dropdown-item d-flex gap-2 py-2" href="#">
                            <div class="bg-warning bg-opacity-10 rounded p-2">
                                <i class="bi bi-clock text-warning"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="small fw-medium">Báo giá #QT-0012 sắp hết hạn</div>
                                <div class="text-muted" style="font-size: 11px;">1 giờ trước</div>
                            </div>
                        </a>
                    </li>
                    <li>
                        <a class="dropdown-item d-flex gap-2 py-2" href="#">
                            <div class="bg-info bg-opacity-10 rounded p-2">
                                <i class="bi bi-person-plus text-info"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="small fw-medium">Lead mới được assign cho bạn</div>
                                <div class="text-muted" style="font-size: 11px;">3 giờ trước</div>
                            </div>
                        </a>
                    </li>
                    <li><hr class="dropdown-divider"></li>
                    <li>
                        <a class="dropdown-item text-center small text-primary" href="#">
                            Xem tất cả thông báo
                        </a>
                    </li>
                </ul>
            </div>
            
            <!-- Tasks -->
            <div class="dropdown">
                <button class="btn btn-light btn-sm position-relative" type="button" 
                        data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="bi bi-check2-square"></i>
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-primary" style="font-size: 10px;">
                        3
                    </span>
                </button>
                <ul class="dropdown-menu dropdown-menu-end" style="width: 300px;">
                    <li class="dropdown-header d-flex justify-content-between align-items-center">
                        <span class="fw-semibold">Task của tôi</span>
                        <a href="${pageContext.request.contextPath}/sale/task/list" class="text-decoration-none small">Xem tất cả</a>
                    </li>
                    <li><hr class="dropdown-divider"></li>
                    <li>
                        <a class="dropdown-item d-flex gap-2 py-2" href="#">
                            <i class="bi bi-circle text-danger"></i>
                            <div class="flex-grow-1">
                                <div class="small fw-medium">Gọi lại khách hàng ABC</div>
                                <div class="text-muted" style="font-size: 11px;">
                                    <i class="bi bi-clock me-1"></i>Hôm nay, 14:00
                                </div>
                            </div>
                        </a>
                    </li>
                    <li>
                        <a class="dropdown-item d-flex gap-2 py-2" href="#">
                            <i class="bi bi-circle text-warning"></i>
                            <div class="flex-grow-1">
                                <div class="small fw-medium">Gửi báo giá cho XYZ Corp</div>
                                <div class="text-muted" style="font-size: 11px;">
                                    <i class="bi bi-clock me-1"></i>Hôm nay, 16:00
                                </div>
                            </div>
                        </a>
                    </li>
                    <li>
                        <a class="dropdown-item d-flex gap-2 py-2" href="#">
                            <i class="bi bi-circle text-info"></i>
                            <div class="flex-grow-1">
                                <div class="small fw-medium">Follow up Opportunity #OPP-0030</div>
                                <div class="text-muted" style="font-size: 11px;">
                                    <i class="bi bi-clock me-1"></i>Ngày mai, 09:00
                                </div>
                            </div>
                        </a>
                    </li>
                </ul>
            </div>
            
            <!-- Messages -->
            <button class="btn btn-light btn-sm position-relative" type="button">
                <i class="bi bi-chat-dots"></i>
                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-success" style="font-size: 10px;">
                    2
                </span>
            </button>
            
            <!-- Divider -->
            <div class="vr mx-2"></div>
            
            <!-- User Profile -->
            <div class="dropdown">
                <button class="btn btn-light btn-sm d-flex align-items-center gap-2 px-2" 
                        type="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <div class="d-none d-md-block text-end">
                        <div class="small fw-medium lh-sm">
                            ${sessionScope.userName != null ? sessionScope.userName : 'Sales Manager'}
                        </div>
                        <div class="text-muted" style="font-size: 11px;">Sales Team</div>
                    </div>
                    <div class="bg-primary text-white rounded d-flex align-items-center justify-content-center" 
                         style="width: 36px; height: 36px; font-size: 14px; font-weight: 600;">
                        ${sessionScope.userInitial != null ? sessionScope.userInitial : 'SM'}
                    </div>
                </button>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li class="dropdown-header">
                        <div class="fw-semibold">${sessionScope.userName != null ? sessionScope.userName : 'Sales Manager'}</div>
                        <div class="text-muted small">${sessionScope.userEmail != null ? sessionScope.userEmail : 'sales@company.com'}</div>
                    </li>
                    <li><hr class="dropdown-divider"></li>
                    <li>
                        <a class="dropdown-item" href="#">
                            <i class="bi bi-person me-2"></i>Hồ sơ cá nhân
                        </a>
                    </li>
                    <li>
                        <a class="dropdown-item" href="#">
                            <i class="bi bi-gear me-2"></i>Cài đặt
                        </a>
                    </li>
                    <li>
                        <a class="dropdown-item" href="#">
                            <i class="bi bi-question-circle me-2"></i>Trợ giúp
                        </a>
                    </li>
                    <li><hr class="dropdown-divider"></li>
                    <li>
                        <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/auth/logout">
                            <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
                        </a>
                    </li>
                </ul>
            </div>
            
        </div>
    </div>
</header>
