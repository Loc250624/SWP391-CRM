<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">Sales Dashboard</h4>
        <p class="text-muted mb-0">Xin chào, ${sessionScope.userName != null ? sessionScope.userName : 'Sales Manager'}! Đây là tổng quan hoạt động bán hàng.</p>
    </div>
    <div class="d-flex gap-2">
        <select class="form-select form-select-sm" style="width: auto;">
            <option selected>Tháng này</option>
            <option>Tháng trước</option>
            <option>Quý này</option>
            <option>Năm nay</option>
        </select>
        <button class="btn btn-outline-secondary btn-sm d-flex align-items-center gap-1">
            <i class="bi bi-download"></i>
            Xuất báo cáo
        </button>
    </div>
</div>

<!-- KPI Cards -->
<div class="row g-3 mb-4">

    <!-- Total Pipeline Value -->
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center mb-3">
                    <div class="bg-primary bg-opacity-10 rounded-3 p-2 me-3">
                        <i class="bi bi-currency-dollar text-primary fs-4"></i>
                    </div>
                    <div class="flex-grow-1">
                        <small class="text-muted">Tổng giá trị Pipeline</small>
                        <h3 class="mb-0 fw-bold">18.7<small class="fs-6 fw-normal">tỷ</small></h3>
                    </div>
                </div>
                <div class="d-flex align-items-center">
                    <span class="badge bg-success-subtle text-success me-2">
                        <i class="bi bi-arrow-up"></i> 15.3%
                    </span>
                    <small class="text-muted">vs tháng trước</small>
                </div>
            </div>
        </div>
    </div>

    <!-- Active Opportunities -->
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center mb-3">
                    <div class="bg-warning bg-opacity-10 rounded-3 p-2 me-3">
                        <i class="bi bi-lightning text-warning fs-4"></i>
                    </div>
                    <div class="flex-grow-1">
                        <small class="text-muted">Opportunity đang mở</small>
                        <h3 class="mb-0 fw-bold">64</h3>
                    </div>
                </div>
                <div class="d-flex align-items-center">
                    <span class="badge bg-success-subtle text-success me-2">
                        <i class="bi bi-plus"></i> 12 mới
                    </span>
                    <small class="text-muted">tuần này</small>
                </div>
            </div>
        </div>
    </div>

    <!-- Win Rate -->
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center mb-3">
                    <div class="bg-success bg-opacity-10 rounded-3 p-2 me-3">
                        <i class="bi bi-trophy text-success fs-4"></i>
                    </div>
                    <div class="flex-grow-1">
                        <small class="text-muted">Tỷ lệ Win Rate</small>
                        <h3 class="mb-0 fw-bold">72<small class="fs-6 fw-normal">%</small></h3>
                    </div>
                </div>
                <div class="d-flex align-items-center">
                    <span class="badge bg-success-subtle text-success me-2">
                        <i class="bi bi-arrow-up"></i> 7%
                    </span>
                    <small class="text-muted">cải thiện</small>
                </div>
            </div>
        </div>
    </div>

    <!-- Quotations Sent -->
    <div class="col-xl-3 col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="d-flex align-items-center mb-3">
                    <div class="bg-info bg-opacity-10 rounded-3 p-2 me-3">
                        <i class="bi bi-file-earmark-text text-info fs-4"></i>
                    </div>
                    <div class="flex-grow-1">
                        <small class="text-muted">Báo giá đã gửi</small>
                        <h3 class="mb-0 fw-bold">38</h3>
                    </div>
                </div>
                <div class="d-flex align-items-center">
                    <span class="badge bg-warning-subtle text-warning me-2">
                        <i class="bi bi-clock"></i> 12
                    </span>
                    <small class="text-muted">chờ phản hồi</small>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Charts Row -->
<div class="row g-3 mb-4">

    <!-- Revenue Chart -->
    <div class="col-lg-8">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0 d-flex justify-content-between align-items-center">
                <div>
                    <h6 class="mb-0 fw-semibold">Xu hướng Doanh thu</h6>
                    <small class="text-muted">6 tháng gần nhất</small>
                </div>
                <div class="d-flex gap-3">
                    <div class="d-flex align-items-center gap-1">
                        <span class="rounded-circle bg-primary" style="width: 10px; height: 10px;"></span>
                        <small class="text-muted">Thực tế</small>
                    </div>
                    <div class="d-flex align-items-center gap-1">
                        <span class="rounded-circle bg-warning" style="width: 10px; height: 10px;"></span>
                        <small class="text-muted">Mục tiêu</small>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <canvas id="revenueChart" height="100"></canvas>
            </div>
        </div>
    </div>

    <!-- Win/Loss Chart -->
    <div class="col-lg-4">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold">Tỷ lệ Won / Lost</h6>
                <small class="text-muted">Quý này</small>
            </div>
            <div class="card-body d-flex flex-column align-items-center justify-content-center">
                <canvas id="winLossChart" style="max-width: 180px; max-height: 180px;"></canvas>
                <div class="d-flex gap-4 mt-3">
                    <div class="text-center">
                        <div class="d-flex align-items-center gap-1 mb-1">
                            <span class="rounded-1 bg-success" style="width: 12px; height: 12px;"></span>
                            <small class="fw-medium">Won</small>
                        </div>
                        <h5 class="mb-0 text-success fw-bold">28</h5>
                        <small class="text-muted">8.4 tỷ</small>
                    </div>
                    <div class="text-center">
                        <div class="d-flex align-items-center gap-1 mb-1">
                            <span class="rounded-1 bg-danger" style="width: 12px; height: 12px;"></span>
                            <small class="fw-medium">Lost</small>
                        </div>
                        <h5 class="mb-0 text-danger fw-bold">11</h5>
                        <small class="text-muted">2.8 tỷ</small>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Pipeline & Quick Actions -->
<div class="row g-3 mb-4">

    <!-- Pipeline Stages -->
    <div class="col-lg-8">
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-transparent border-0 d-flex justify-content-between align-items-center">
                <div>
                    <h6 class="mb-0 fw-semibold">Pipeline theo giai đoạn</h6>
                    <small class="text-muted">Phân bố opportunity hiện tại</small>
                </div>
                <a href="${pageContext.request.contextPath}/sale/opportunity/kanban" class="btn btn-sm btn-outline-primary">
                    <i class="bi bi-kanban me-1"></i>Xem Kanban
                </a>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Giai đoạn</th>
                                <th class="text-center">Số lượng</th>
                                <th class="text-end">Giá trị</th>
                                <th style="width: 200px;">Tỷ lệ chuyển đổi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Prospecting -->
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="rounded-1" style="width: 4px; height: 32px; background-color: #94a3b8;"></span>
                                        <div>
                                            <div class="fw-medium">🔍 Prospecting</div>
                                            <small class="text-muted">Tìm kiếm cơ hội</small>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-secondary-subtle text-secondary">18 deals</span>
                                </td>
                                <td class="text-end fw-semibold">3.2 tỷ</td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="progress flex-grow-1" style="height: 6px;">
                                            <div class="progress-bar bg-secondary" style="width: 45%;"></div>
                                        </div>
                                        <small class="text-muted" style="width: 35px;">45%</small>
                                    </div>
                                </td>
                            </tr>
                            <!-- Qualified -->
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="rounded-1" style="width: 4px; height: 32px; background-color: #06b6d4;"></span>
                                        <div>
                                            <div class="fw-medium">✅ Qualified</div>
                                            <small class="text-muted">Đã xác nhận nhu cầu</small>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-info-subtle text-info">15 deals</span>
                                </td>
                                <td class="text-end fw-semibold">4.8 tỷ</td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="progress flex-grow-1" style="height: 6px;">
                                            <div class="progress-bar bg-info" style="width: 65%;"></div>
                                        </div>
                                        <small class="text-muted" style="width: 35px;">65%</small>
                                    </div>
                                </td>
                            </tr>
                            <!-- Proposal -->
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="rounded-1" style="width: 4px; height: 32px; background-color: #f59e0b;"></span>
                                        <div>
                                            <div class="fw-medium">📄 Proposal</div>
                                            <small class="text-muted">Đã gửi báo giá</small>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-warning-subtle text-warning">12 deals</span>
                                </td>
                                <td class="text-end fw-semibold">3.9 tỷ</td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="progress flex-grow-1" style="height: 6px;">
                                            <div class="progress-bar bg-warning" style="width: 75%;"></div>
                                        </div>
                                        <small class="text-muted" style="width: 35px;">75%</small>
                                    </div>
                                </td>
                            </tr>
                            <!-- Negotiation -->
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="rounded-1" style="width: 4px; height: 32px; background-color: #3b82f6;"></span>
                                        <div>
                                            <div class="fw-medium">🤝 Negotiation</div>
                                            <small class="text-muted">Đang đàm phán</small>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-primary-subtle text-primary">10 deals</span>
                                </td>
                                <td class="text-end fw-semibold">4.2 tỷ</td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="progress flex-grow-1" style="height: 6px;">
                                            <div class="progress-bar bg-primary" style="width: 85%;"></div>
                                        </div>
                                        <small class="text-muted" style="width: 35px;">85%</small>
                                    </div>
                                </td>
                            </tr>
                            <!-- Closed Won -->
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="rounded-1" style="width: 4px; height: 32px; background-color: #10b981;"></span>
                                        <div>
                                            <div class="fw-medium">🎉 Closed Won</div>
                                            <small class="text-muted">Thắng deal tháng này</small>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-success-subtle text-success">9 deals</span>
                                </td>
                                <td class="text-end fw-semibold text-success">2.6 tỷ</td>
                                <td>
                                    <span class="badge bg-success-subtle text-success">
                                        <i class="bi bi-arrow-up"></i> +18% vs tháng trước
                                    </span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Actions & Tasks -->
    <div class="col-lg-4">
        <div class="row g-3">

            <!-- Quick Actions -->
            <div class="col-12">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-transparent border-0">
                        <h6 class="mb-0 fw-semibold">Thao tác nhanh</h6>
                    </div>
                    <div class="card-body pt-0">
                        <div class="d-grid gap-2">
                            <a href="${pageContext.request.contextPath}/sale/opportunity/form" class="btn btn-primary">
                                <i class="bi bi-plus-lg me-1"></i>Tạo Opportunity
                            </a>
                            <a href="${pageContext.request.contextPath}/sale/quotation/form" class="btn btn-outline-primary">
                                <i class="bi bi-file-earmark-text me-1"></i>Tạo Báo giá
                            </a>
                            <a href="${pageContext.request.contextPath}/sale/activity/form" class="btn btn-outline-secondary">
                                <i class="bi bi-calendar-plus me-1"></i>Đặt lịch hẹn
                            </a>
                        </div>
                        <hr>
                        <div class="d-flex flex-column gap-2">
                            <a href="${pageContext.request.contextPath}/sale/opportunity/kanban" class="text-decoration-none d-flex align-items-center gap-2 text-body-secondary">
                                <i class="bi bi-kanban"></i>
                                <span>Pipeline Kanban</span>
                                <i class="bi bi-chevron-right ms-auto"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/sale/opportunity/forecast" class="text-decoration-none d-flex align-items-center gap-2 text-body-secondary">
                                <i class="bi bi-graph-up-arrow"></i>
                                <span>Sales Forecast</span>
                                <i class="bi bi-chevron-right ms-auto"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/sale/report/revenue" class="text-decoration-none d-flex align-items-center gap-2 text-body-secondary">
                                <i class="bi bi-bar-chart"></i>
                                <span>Báo cáo doanh thu</span>
                                <i class="bi bi-chevron-right ms-auto"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Today's Tasks -->
            <div class="col-12">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-transparent border-0 d-flex justify-content-between align-items-center">
                        <h6 class="mb-0 fw-semibold">Công việc hôm nay</h6>
                        <span class="badge bg-danger">3 việc</span>
                    </div>
                    <div class="card-body pt-0">
                        <div class="d-flex flex-column gap-2">

                            <!-- Task 1 -->
                            <div class="d-flex align-items-start gap-2 p-2 rounded hover-bg-light">
                                <div class="form-check mt-1">
                                    <input class="form-check-input" type="checkbox" id="task1">
                                </div>
                                <div class="flex-grow-1">
                                    <label class="form-check-label fw-medium mb-0" for="task1">
                                        Gọi follow-up ABC Corp
                                    </label>
                                    <div class="d-flex align-items-center gap-2 mt-1">
                                        <small class="text-muted">
                                            <i class="bi bi-clock me-1"></i>10:00
                                        </small>
                                        <span class="badge bg-danger-subtle text-danger" style="font-size: 10px;">HIGH</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Task 2 -->
                            <div class="d-flex align-items-start gap-2 p-2 rounded hover-bg-light">
                                <div class="form-check mt-1">
                                    <input class="form-check-input" type="checkbox" id="task2">
                                </div>
                                <div class="flex-grow-1">
                                    <label class="form-check-label fw-medium mb-0" for="task2">
                                        Gửi proposal XYZ Ltd
                                    </label>
                                    <div class="d-flex align-items-center gap-2 mt-1">
                                        <small class="text-muted">
                                            <i class="bi bi-clock me-1"></i>14:30
                                        </small>
                                        <span class="badge bg-danger-subtle text-danger" style="font-size: 10px;">HIGH</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Task 3 -->
                            <div class="d-flex align-items-start gap-2 p-2 rounded hover-bg-light">
                                <div class="form-check mt-1">
                                    <input class="form-check-input" type="checkbox" id="task3">
                                </div>
                                <div class="flex-grow-1">
                                    <label class="form-check-label fw-medium mb-0" for="task3">
                                        Meeting với DEF Group
                                    </label>
                                    <div class="d-flex align-items-center gap-2 mt-1">
                                        <small class="text-muted">
                                            <i class="bi bi-clock me-1"></i>16:00
                                        </small>
                                        <span class="badge bg-warning-subtle text-warning" style="font-size: 10px;">MEDIUM</span>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <a href="${pageContext.request.contextPath}/sale/task/list" class="btn btn-link btn-sm text-decoration-none p-0 mt-2">
                            Xem tất cả <i class="bi bi-chevron-right"></i>
                        </a>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<!-- Recent Opportunities & Activities -->
<div class="row g-3 mb-4">

    <!-- Recent Opportunities -->
    <div class="col-lg-8">
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-transparent border-0 d-flex justify-content-between align-items-center">
                <div>
                    <h6 class="mb-0 fw-semibold">Opportunity gần đây</h6>
                    <small class="text-muted">Cập nhật trong 24h qua</small>
                </div>
                <a href="${pageContext.request.contextPath}/sale/opportunity/list" class="btn btn-sm btn-link text-decoration-none">
                    Xem tất cả <i class="bi bi-chevron-right"></i>
                </a>
            </div>
            <div class="card-body pt-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Opportunity</th>
                                <th>Khách hàng</th>
                                <th>Giai đoạn</th>
                                <th class="text-end">Giá trị</th>
                                <th>Dự kiến</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <div class="fw-medium">OPP-2024-0089</div>
                                    <small class="text-muted">Hợp đồng ERP Enterprise</small>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="bg-primary text-white rounded d-flex align-items-center justify-content-center" style="width: 32px; height: 32px; font-size: 12px;">
                                            AC
                                        </div>
                                        <div>
                                            <div class="fw-medium">ABC Corporation</div>
                                            <small class="text-muted">Enterprise</small>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="badge bg-primary">Negotiation</span></td>
                                <td class="text-end fw-semibold">1.45 tỷ</td>
                                <td><small class="text-muted">28/02/2026</small></td>
                                <td>
                                    <div class="dropdown">
                                        <button class="btn btn-sm btn-light" data-bs-toggle="dropdown">
                                            <i class="bi bi-three-dots-vertical"></i>
                                        </button>
                                        <ul class="dropdown-menu dropdown-menu-end">
                                            <li><a class="dropdown-item" href="#"><i class="bi bi-eye me-2"></i>Xem chi tiết</a></li>
                                            <li><a class="dropdown-item" href="#"><i class="bi bi-pencil me-2"></i>Chỉnh sửa</a></li>
                                            <li><hr class="dropdown-divider"></li>
                                            <li><a class="dropdown-item text-success" href="#"><i class="bi bi-trophy me-2"></i>Đánh dấu Won</a></li>
                                        </ul>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="fw-medium">OPP-2024-0088</div>
                                    <small class="text-muted">Dự án CRM Cloud</small>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="bg-success text-white rounded d-flex align-items-center justify-content-center" style="width: 32px; height: 32px; font-size: 12px;">
                                            XY
                                        </div>
                                        <div>
                                            <div class="fw-medium">XYZ Limited</div>
                                            <small class="text-muted">Mid-Market</small>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="badge bg-warning text-dark">Proposal</span></td>
                                <td class="text-end fw-semibold">925 triệu</td>
                                <td><small class="text-muted">15/03/2026</small></td>
                                <td>
                                    <div class="dropdown">
                                        <button class="btn btn-sm btn-light" data-bs-toggle="dropdown">
                                            <i class="bi bi-three-dots-vertical"></i>
                                        </button>
                                        <ul class="dropdown-menu dropdown-menu-end">
                                            <li><a class="dropdown-item" href="#"><i class="bi bi-eye me-2"></i>Xem chi tiết</a></li>
                                            <li><a class="dropdown-item" href="#"><i class="bi bi-pencil me-2"></i>Chỉnh sửa</a></li>
                                        </ul>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="fw-medium">OPP-2024-0087</div>
                                    <small class="text-muted">Hệ thống HRM</small>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="bg-info text-white rounded d-flex align-items-center justify-content-center" style="width: 32px; height: 32px; font-size: 12px;">
                                            DF
                                        </div>
                                        <div>
                                            <div class="fw-medium">DEF Group</div>
                                            <small class="text-muted">Enterprise</small>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="badge bg-info">Qualified</span></td>
                                <td class="text-end fw-semibold">2.8 tỷ</td>
                                <td><small class="text-muted">30/03/2026</small></td>
                                <td>
                                    <div class="dropdown">
                                        <button class="btn btn-sm btn-light" data-bs-toggle="dropdown">
                                            <i class="bi bi-three-dots-vertical"></i>
                                        </button>
                                        <ul class="dropdown-menu dropdown-menu-end">
                                            <li><a class="dropdown-item" href="#"><i class="bi bi-eye me-2"></i>Xem chi tiết</a></li>
                                            <li><a class="dropdown-item" href="#"><i class="bi bi-pencil me-2"></i>Chỉnh sửa</a></li>
                                        </ul>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="fw-medium">OPP-2024-0086</div>
                                    <small class="text-muted">Platform Integration</small>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="bg-secondary text-white rounded d-flex align-items-center justify-content-center" style="width: 32px; height: 32px; font-size: 12px;">
                                            GH
                                        </div>
                                        <div>
                                            <div class="fw-medium">GHI Technology</div>
                                            <small class="text-muted">SMB</small>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="badge bg-secondary">Prospecting</span></td>
                                <td class="text-end fw-semibold">480 triệu</td>
                                <td><small class="text-muted">15/04/2026</small></td>
                                <td>
                                    <div class="dropdown">
                                        <button class="btn btn-sm btn-light" data-bs-toggle="dropdown">
                                            <i class="bi bi-three-dots-vertical"></i>
                                        </button>
                                        <ul class="dropdown-menu dropdown-menu-end">
                                            <li><a class="dropdown-item" href="#"><i class="bi bi-eye me-2"></i>Xem chi tiết</a></li>
                                            <li><a class="dropdown-item" href="#"><i class="bi bi-pencil me-2"></i>Chỉnh sửa</a></li>
                                        </ul>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Activities -->
    <div class="col-lg-4">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-transparent border-0 d-flex justify-content-between align-items-center">
                <h6 class="mb-0 fw-semibold">Hoạt động gần đây</h6>
                <a href="${pageContext.request.contextPath}/sale/activity/list" class="btn btn-sm btn-link text-decoration-none p-0">
                    Xem tất cả
                </a>
            </div>
            <div class="card-body pt-0">
                <div class="d-flex flex-column gap-3">

                    <!-- Activity 1 -->
                    <div class="d-flex gap-3">
                        <div class="bg-success-subtle text-success rounded-circle d-flex align-items-center justify-content-center flex-shrink-0" style="width: 36px; height: 36px;">
                            <i class="bi bi-telephone"></i>
                        </div>
                        <div class="flex-grow-1">
                            <div class="fw-medium">Cuộc gọi với ABC Corp</div>
                            <small class="text-muted">Thảo luận về điều khoản hợp đồng</small>
                            <div class="text-muted mt-1" style="font-size: 11px;">
                                <i class="bi bi-clock me-1"></i>2 giờ trước • Nguyễn Thanh
                            </div>
                        </div>
                    </div>

                    <!-- Activity 2 -->
                    <div class="d-flex gap-3">
                        <div class="bg-primary-subtle text-primary rounded-circle d-flex align-items-center justify-content-center flex-shrink-0" style="width: 36px; height: 36px;">
                            <i class="bi bi-envelope"></i>
                        </div>
                        <div class="flex-grow-1">
                            <div class="fw-medium">Gửi email báo giá</div>
                            <small class="text-muted">Báo giá QT-2024-0156 cho XYZ Ltd</small>
                            <div class="text-muted mt-1" style="font-size: 11px;">
                                <i class="bi bi-clock me-1"></i>4 giờ trước • Lê Mai
                            </div>
                        </div>
                    </div>

                    <!-- Activity 3 -->
                    <div class="d-flex gap-3">
                        <div class="bg-warning-subtle text-warning rounded-circle d-flex align-items-center justify-content-center flex-shrink-0" style="width: 36px; height: 36px;">
                            <i class="bi bi-people"></i>
                        </div>
                        <div class="flex-grow-1">
                            <div class="fw-medium">Họp demo sản phẩm</div>
                            <small class="text-muted">Demo CRM cho DEF Group</small>
                            <div class="text-muted mt-1" style="font-size: 11px;">
                                <i class="bi bi-clock me-1"></i>Hôm qua • Phạm Huy
                            </div>
                        </div>
                    </div>

                    <!-- Activity 4 -->
                    <div class="d-flex gap-3">
                        <div class="bg-info-subtle text-info rounded-circle d-flex align-items-center justify-content-center flex-shrink-0" style="width: 36px; height: 36px;">
                            <i class="bi bi-sticky"></i>
                        </div>
                        <div class="flex-grow-1">
                            <div class="fw-medium">Ghi chú mới</div>
                            <small class="text-muted">Cập nhật tình trạng GHI Tech</small>
                            <div class="text-muted mt-1" style="font-size: 11px;">
                                <i class="bi bi-clock me-1"></i>2 ngày trước • Nguyễn Thanh
                            </div>
                        </div>
                    </div>

                    <!-- Activity 5 -->
                    <div class="d-flex gap-3">
                        <div class="bg-danger-subtle text-danger rounded-circle d-flex align-items-center justify-content-center flex-shrink-0" style="width: 36px; height: 36px;">
                            <i class="bi bi-x-circle"></i>
                        </div>
                        <div class="flex-grow-1">
                            <div class="fw-medium">Opportunity Lost</div>
                            <small class="text-muted">JKL Inc - Lý do: Ngân sách hạn chế</small>
                            <div class="text-muted mt-1" style="font-size: 11px;">
                                <i class="bi bi-clock me-1"></i>3 ngày trước • Lê Mai
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<!-- Quotation Status & Top Performers -->
<div class="row g-3">

    <!-- Quotation Status -->
    <div class="col-lg-6">
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-transparent border-0 d-flex justify-content-between align-items-center">
                <div>
                    <h6 class="mb-0 fw-semibold">Trạng thái Báo giá</h6>
                    <small class="text-muted">Tháng này</small>
                </div>
                <a href="${pageContext.request.contextPath}/sale/quotation/list" class="btn btn-sm btn-link text-decoration-none p-0">
                    Xem tất cả
                </a>
            </div>
            <div class="card-body pt-0">
                <div class="row g-3">
                    <div class="col-6">
                        <div class="border rounded p-3 text-center">
                            <div class="fs-3 fw-bold text-primary">15</div>
                            <small class="text-muted">Đã gửi</small>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="border rounded p-3 text-center">
                            <div class="fs-3 fw-bold text-warning">8</div>
                            <small class="text-muted">Chờ duyệt</small>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="border rounded p-3 text-center">
                            <div class="fs-3 fw-bold text-success">10</div>
                            <small class="text-muted">Được chấp nhận</small>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="border rounded p-3 text-center">
                            <div class="fs-3 fw-bold text-danger">5</div>
                            <small class="text-muted">Bị từ chối</small>
                        </div>
                    </div>
                </div>
                <div class="mt-3">
                    <div class="d-flex justify-content-between mb-1">
                        <small class="text-muted">Tỷ lệ chấp nhận</small>
                        <small class="fw-semibold">66.7%</small>
                    </div>
                    <div class="progress" style="height: 8px;">
                        <div class="progress-bar bg-success" style="width: 66.7%;"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Top Performers -->
    <div class="col-lg-6">
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-transparent border-0">
                <h6 class="mb-0 fw-semibold">Top Performers</h6>
                <small class="text-muted">Dựa trên doanh số tháng này</small>
            </div>
            <div class="card-body pt-0">
                <div class="d-flex flex-column gap-3">

                    <!-- #1 -->
                    <div class="d-flex align-items-center gap-3 p-2 bg-warning-subtle rounded">
                        <div class="fs-5">🥇</div>
                        <div class="bg-warning text-white rounded d-flex align-items-center justify-content-center" style="width: 40px; height: 40px;">
                            NT
                        </div>
                        <div class="flex-grow-1">
                            <div class="fw-semibold">Nguyễn Thanh</div>
                            <small class="text-muted">Senior Sales</small>
                        </div>
                        <div class="text-end">
                            <div class="fw-bold">3.2 tỷ</div>
                            <small class="text-muted">12 deals</small>
                        </div>
                    </div>

                    <!-- #2 -->
                    <div class="d-flex align-items-center gap-3 p-2 bg-light rounded">
                        <div class="fs-5">🥈</div>
                        <div class="bg-secondary text-white rounded d-flex align-items-center justify-content-center" style="width: 40px; height: 40px;">
                            LM
                        </div>
                        <div class="flex-grow-1">
                            <div class="fw-semibold">Lê Mai</div>
                            <small class="text-muted">Sales Executive</small>
                        </div>
                        <div class="text-end">
                            <div class="fw-bold">2.8 tỷ</div>
                            <small class="text-muted">10 deals</small>
                        </div>
                    </div>

                    <!-- #3 -->
                    <div class="d-flex align-items-center gap-3 p-2 bg-light rounded">
                        <div class="fs-5">🥉</div>
                        <div class="bg-orange text-white rounded d-flex align-items-center justify-content-center" style="width: 40px; height: 40px; background-color: #fb923c;">
                            PH
                        </div>
                        <div class="flex-grow-1">
                            <div class="fw-semibold">Phạm Huy</div>
                            <small class="text-muted">Sales Manager</small>
                        </div>
                        <div class="text-end">
                            <div class="fw-bold">2.4 tỷ</div>
                            <small class="text-muted">9 deals</small>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {

        // Revenue Chart
        const revenueCtx = document.getElementById('revenueChart');
        if (revenueCtx) {
            new Chart(revenueCtx, {
                type: 'line',
                data: {
                    labels: ['T9', 'T10', 'T11', 'T12', 'T1', 'T2'],
                    datasets: [
                        {
                            label: 'Thực tế',
                            data: [2.2, 2.8, 3.1, 2.9, 3.4, 3.8],
                            borderColor: '#0d6efd',
                            backgroundColor: 'rgba(13, 110, 253, 0.1)',
                            tension: 0.4,
                            fill: true,
                            borderWidth: 2
                        },
                        {
                            label: 'Mục tiêu',
                            data: [2.5, 2.7, 2.9, 3.1, 3.3, 3.5],
                            borderColor: '#ffc107',
                            backgroundColor: 'rgba(255, 193, 7, 0.1)',
                            tension: 0.4,
                            fill: true,
                            borderWidth: 2,
                            borderDash: [5, 5]
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: false,
                            ticks: {
                                callback: function (value) {
                                    return value + ' tỷ';
                                }
                            }
                        }
                    }
                }
            });
        }

        // Win/Loss Chart
        const winLossCtx = document.getElementById('winLossChart');
        if (winLossCtx) {
            new Chart(winLossCtx, {
                type: 'doughnut',
                data: {
                    labels: ['Won', 'Lost'],
                    datasets: [{
                            data: [28, 11],
                            backgroundColor: ['#198754', '#dc3545'],
                            borderWidth: 0,
                            hoverOffset: 10
                        }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    cutout: '70%',
                    plugins: {
                        legend: {
                            display: false
                        }
                    }
                }
            });
        }
    });
</script>

<style>
    .hover-bg-light:hover {
        background-color: #f8f9fa !important;
    }
</style>
