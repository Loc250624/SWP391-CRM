<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid p-0">
    
    <div class="row mb-4">
        <div class="col-12">
            <div class="card border-0 shadow-sm overflow-hidden" style="border-radius: 15px;">
                <div class="card-body p-0">
                    <div class="d-flex align-items-center bg-white p-4">
                        <div class="flex-shrink-0 bg-info bg-opacity-10 p-3 rounded-circle me-4">
                            <i class="bi bi-stars text-info fs-1"></i>
                        </div>
                        <div>
                            <h3 class="fw-bold mb-1">Chào mừng quay trở lại, ${sessionScope.user.firstName}!</h3>
                            <p class="text-muted mb-0">Hôm nay là một ngày tuyệt vời để hỗ trợ khách hàng của chúng ta.</p>
                        </div>
                        <div class="ms-auto d-none d-lg-block">
                            <img src="https://cdn-icons-png.flaticon.com/512/6209/6209641.png" alt="welcome" width="120">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-md-4">
            <div class="card border-0 shadow-sm p-3" style="border-radius: 12px;">
                <div class="d-flex align-items-center">
                    <div class="bg-primary bg-opacity-10 text-primary p-3 rounded-3 me-3">
                        <i class="bi bi-ticket-detailed fs-4"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Ticket mới</div>
                        <h4 class="fw-bold mb-0">12</h4>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-0 shadow-sm p-3" style="border-radius: 12px;">
                <div class="d-flex align-items-center">
                    <div class="bg-warning bg-opacity-10 text-warning p-3 rounded-3 me-3">
                        <i class="bi bi-clock-history fs-4"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Đang chờ xử lý</div>
                        <h4 class="fw-bold mb-0">05</h4>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-0 shadow-sm p-3" style="border-radius: 12px;">
                <div class="d-flex align-items-center">
                    <div class="bg-success bg-opacity-10 text-success p-3 rounded-3 me-3">
                        <i class="bi bi-check-circle fs-4"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Đã hoàn thành</div>
                        <h4 class="fw-bold mb-0">28</h4>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-12 text-center py-5">
            <div class="empty-state">
                <div class="mb-4">
                    <i class="bi bi-search-heart text-muted" style="font-size: 80px; opacity: 0.3;"></i>
                </div>
                <h5 class="fw-semibold text-secondary">Bắt đầu công việc của bạn</h5>
                <p class="text-muted mx-auto" style="max-width: 400px;">
                    Bạn có thể xem danh sách khách hàng hoặc kiểm tra các ticket mới cần được phản hồi ngay bây giờ.
                </p>
                <div class="mt-4">
                    <a href="${pageContext.request.contextPath}/support/customers" class="btn btn-primary px-4 py-2 me-2">
                        <i class="bi bi-people me-2"></i>Quản lý Customer
                    </a>
                    <a href="#" class="btn btn-outline-secondary px-4 py-2">
                        <i class="bi bi-ticket-perforated me-2"></i>Xem Ticket
                    </a>
                </div>
            </div>
        </div>
    </div>

</div>