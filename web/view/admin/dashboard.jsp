<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!-- Dashboard Welcome -->
<div class="mb-4">
    <h4 class="fw-bold mb-1">Chào mừng trở lại, Administrator!</h4>
    <p class="text-muted small">Dưới đây là tổng quan về hoạt động của hệ thống trong ngày hôm nay.</p>
</div>

<!-- Stats Grid -->
<div class="row g-4 mb-4">
    <!-- Total Customers -->
    <div class="col-12 col-sm-6 col-xl-3">
        <div class="card border-0 shadow-sm rounded-4 h-100 kpi-card">
            <div class="card-body p-4">
                <div class="d-flex align-items-center justify-content-between mb-3">
                    <div class="kpi-icon bg-primary bg-opacity-10 text-primary">
                        <i class="bi bi-people fs-4"></i>
                    </div>
                    <span class="badge bg-success bg-opacity-10 text-success small">+12%</span>
                </div>
                <div>
                    <h3 class="fw-bold mb-1">${totalCustomers}</h3>
                    <p class="text-muted small mb-0">Tổng khách hàng</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Active Courses -->
    <div class="col-12 col-sm-6 col-xl-3">
        <div class="card border-0 shadow-sm rounded-4 h-100 kpi-card">
            <div class="card-body p-4">
                <div class="d-flex align-items-center justify-content-between mb-3">
                    <div class="kpi-icon bg-info bg-opacity-10 text-info">
                        <i class="bi bi-journal-bookmark fs-4"></i>
                    </div>
                    <span class="badge bg-info bg-opacity-10 text-info small">Đang chạy</span>
                </div>
                <div>
                    <h3 class="fw-bold mb-1">${totalCourses}</h3>
                    <p class="text-muted small mb-0">Khóa học đang mở</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Staff Members -->
    <div class="col-12 col-sm-6 col-xl-3">
        <div class="card border-0 shadow-sm rounded-4 h-100 kpi-card">
            <div class="card-body p-4">
                <div class="d-flex align-items-center justify-content-between mb-3">
                    <div class="kpi-icon bg-warning bg-opacity-10 text-warning">
                        <i class="bi bi-person-badge fs-4"></i>
                    </div>
                </div>
                <div>
                    <h3 class="fw-bold mb-1">${totalStaff}</h3>
                    <p class="text-muted small mb-0">Nhân sự hệ thống</p>
                </div>
            </div>
        </div>
    </div>

    <!-- System Health -->
    <div class="col-12 col-sm-6 col-xl-3">
        <div class="card border-0 shadow-sm rounded-4 h-100 kpi-card">
            <div class="card-body p-4">
                <div class="d-flex align-items-center justify-content-between mb-3">
                    <div class="kpi-icon bg-success bg-opacity-10 text-success">
                        <i class="bi bi-shield-check fs-4"></i>
                    </div>
                    <span class="badge bg-success text-white small">Ổn định</span>
                </div>
                <div>
                    <h3 class="fw-bold mb-1">99.9%</h3>
                    <p class="text-muted small mb-0">Trạng thái hệ thống</p>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row g-4 mb-4">
    <!-- Chart Section -->
    <div class="col-12 col-xl-8">
        <div class="card border-0 shadow-sm rounded-4 h-100">
            <div class="card-header bg-transparent border-0 p-4 d-flex align-items-center justify-content-between">
                <h5 class="fw-bold mb-0">Tăng trưởng khách hàng</h5>
                <div class="dropdown">
                    <button class="btn btn-light btn-sm dropdown-toggle" type="button" data-bs-toggle="dropdown">
                        7 ngày qua
                    </button>
                    <ul class="dropdown-menu shadow border-0">
                        <li><a class="dropdown-item" href="#">30 ngày qua</a></li>
                        <li><a class="dropdown-item" href="#">Năm nay</a></li>
                    </ul>
                </div>
            </div>
            <div class="card-body p-4 pt-0">
                <div style="height: 300px;">
                    <canvas id="customerChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="col-12 col-xl-4">
        <div class="card border-0 shadow-sm rounded-4 h-100">
            <div class="card-header bg-transparent border-0 p-4">
                <h5 class="fw-bold mb-0">Thao tác nhanh</h5>
            </div>
            <div class="card-body p-4 pt-0">
                <div class="d-grid gap-3">
                    <a href="${pageContext.request.contextPath}/admin/customer/form" class="btn btn-light text-start p-3 rounded-3 border d-flex align-items-center gap-3 quick-action-btn">
                        <div class="icon-circle bg-primary text-white">
                            <i class="bi bi-person-plus"></i>
                        </div>
                        <div>
                            <div class="fw-bold">Thêm khách hàng</div>
                            <small class="text-muted">Tạo hồ sơ khách hàng mới</small>
                        </div>
                        <i class="bi bi-chevron-right ms-auto text-muted"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/category/list" class="btn btn-light text-start p-3 rounded-3 border d-flex align-items-center gap-3 quick-action-btn">
                        <div class="icon-circle bg-info text-white">
                            <i class="bi bi-tags"></i>
                        </div>
                        <div>
                            <div class="fw-bold">Quản lý danh mục</div>
                            <small class="text-muted">Cập nhật lĩnh vực đào tạo</small>
                        </div>
                        <i class="bi bi-chevron-right ms-auto text-muted"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/audit/list" class="btn btn-light text-start p-3 rounded-3 border d-flex align-items-center gap-3 quick-action-btn">
                        <div class="icon-circle bg-secondary text-white">
                            <i class="bi bi-journal-text"></i>
                        </div>
                        <div>
                            <div class="fw-bold">Xem nhật ký</div>
                            <small class="text-muted">Kiểm tra lịch sử hệ thống</small>
                        </div>
                        <i class="bi bi-chevron-right ms-auto text-muted"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Recent Activities -->
<div class="card border-0 shadow-sm rounded-4">
    <div class="card-header bg-transparent border-0 p-4 d-flex align-items-center justify-content-between">
        <h5 class="fw-bold mb-0">Hoạt động gần đây</h5>
        <a href="${pageContext.request.contextPath}/admin/activity/log" class="text-decoration-none small fw-bold">Xem tất cả <i class="bi bi-arrow-right"></i></a>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="bg-light bg-opacity-50">
                    <tr>
                        <th class="ps-4 border-0">Nội dung</th>
                        <th class="border-0">Đối tượng</th>
                        <th class="border-0">Người thực hiện</th>
                        <th class="border-0 text-end pe-4">Thời gian</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="a" items="${recentActivities}">
                        <tr>
                            <td class="ps-4">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="icon-sm rounded bg-primary bg-opacity-10 text-primary d-flex align-items-center justify-content-center" 
                                         style="width: 32px; height: 32px;">
                                        <i class="bi bi-record-circle small"></i>
                                    </div>
                                    <span class="fw-medium">${a.subject}</span>
                                </div>
                            </td>
                            <td>
                                <span class="text-dark">${a.customerName != null ? a.customerName : 'N/A'}</span>
                                <div class="text-muted small">${a.relatedType}</div>
                            </td>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <div class="avatar-circle">
                                        ${a.performerName != null ? a.performerName.substring(0,1) : 'U'}
                                    </div>
                                    <span>${a.performerName}</span>
                                </div>
                            </td>
                            <td class="text-end pe-4">
                                <span class="text-muted small">${a.createdAt}</span>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty recentActivities}">
                        <tr>
                            <td colspan="4" class="text-center py-5">
                                <div class="text-muted">
                                    <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                                    Chưa có dữ liệu hoạt động gần đây
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<style>
    :root {
        --primary-color: #4f46e5;
        --secondary-color: #64748b;
    }
    
    .kpi-card {
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        border: 1px solid rgba(0,0,0,0.02) !important;
    }
    
    .kpi-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04) !important;
    }
    
    .kpi-icon {
        width: 48px;
        height: 48px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    
    .icon-circle {
        width: 40px;
        height: 40px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    
    .quick-action-btn {
        border-color: #f1f5f9 !important;
        background-color: #fff !important;
    }
    
    .quick-action-btn:hover {
        background-color: #f8fafc !important;
        border-color: var(--primary-color) !important;
    }
    
    .avatar-circle {
        width: 32px;
        height: 32px;
        background: #e2e8f0;
        color: #475569;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 11px;
        font-weight: 600;
    }
    
    .table thead th {
        font-size: 11px;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        font-weight: 700;
        color: #64748b;
        padding-top: 15px;
        padding-bottom: 15px;
    }
    
    .table tbody td {
        padding-top: 16px;
        padding-bottom: 16px;
        border-bottom: 1px solid #f1f5f9;
        font-size: 14px;
    }
</style>

<!-- Chart.js CDN -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const ctx = document.getElementById('customerChart').getContext('2d');
        const gradient = ctx.createLinearGradient(0, 0, 0, 300);
        gradient.addColorStop(0, 'rgba(79, 70, 229, 0.2)');
        gradient.addColorStop(1, 'rgba(79, 70, 229, 0)');

        new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'CN'],
                datasets: [{
                    label: 'Khách hàng mới',
                    data: [12, 19, 15, 25, 22, 30, 28],
                    borderColor: '#4f46e5',
                    backgroundColor: gradient,
                    fill: true,
                    tension: 0.4,
                    pointRadius: 4,
                    pointBackgroundColor: '#fff',
                    pointBorderColor: '#4f46e5',
                    pointBorderWidth: 2,
                    pointHoverRadius: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        backgroundColor: '#1e293b',
                        padding: 12,
                        titleFont: { size: 13 },
                        bodyFont: { size: 13 },
                        cornerRadius: 8,
                        displayColors: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        border: { display: false },
                        grid: { borderDash: [5, 5], color: '#f1f5f9' }
                    },
                    x: {
                        border: { display: false },
                        grid: { display: false }
                    }
                }
            }
        });
    });
</script>