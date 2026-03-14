<%@ page contentType="text/html;charset=UTF-8" %>

<div class="container-fluid">
    <!-- Header -->
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <h3 class="mb-1"><i class="bi bi-envelope-paper me-2"></i>Quản lý Email</h3>
            <p class="text-muted mb-0">Theo dõi chiến dịch, mẫu email và lịch sử gửi trong hệ thống</p>
        </div>
        <div class="d-flex gap-2">
            <button class="btn btn-outline-secondary">
                <i class="bi bi-upload me-2"></i>Import danh sách
            </button>
            <a href="${pageContext.request.contextPath}/manager/email/send" class="btn btn-primary">
                <i class="bi bi-send me-2"></i>Gửi email mới
            </a>
        </div>
    </div>

    <!-- KPI Cards -->
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-muted small">Tổng email đã gửi</div>
                            <div class="h4 mb-0">12,480</div>
                        </div>
                        <span class="badge bg-success-subtle text-success border border-success-subtle px-3 py-2">
                            +12.5%
                        </span>
                    </div>
                    <div class="mt-3 small text-muted">
                        Cập nhật hôm nay
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-muted small">Tỷ lệ mở</div>
                            <div class="h4 mb-0">38.6%</div>
                        </div>
                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-2">
                            +3.2%
                        </span>
                    </div>
                    <div class="mt-3 small text-muted">
                        Trung bình 7 ngày
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-muted small">Bounce rate</div>
                            <div class="h4 mb-0">1.8%</div>
                        </div>
                        <span class="badge bg-warning-subtle text-warning border border-warning-subtle px-3 py-2">
                            -0.4%
                        </span>
                    </div>
                    <div class="mt-3 small text-muted">
                        Email trả lại
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-muted small">Hàng đợi</div>
                            <div class="h4 mb-0">248</div>
                        </div>
                        <span class="badge bg-info-subtle text-info border border-info-subtle px-3 py-2">
                            +24
                        </span>
                    </div>
                    <div class="mt-3 small text-muted">
                        Sẽ gửi trong 1 giờ
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Tabs -->
    <ul class="nav nav-tabs mb-3" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tab-logs" type="button" role="tab">
                <i class="bi bi-clock-history me-2"></i>Nhật ký gửi
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-templates" type="button" role="tab">
                <i class="bi bi-file-earmark-text me-2"></i>Mẫu email
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-settings" type="button" role="tab">
                <i class="bi bi-gear me-2"></i>Cấu hình gửi
            </button>
        </li>
    </ul>

    <div class="tab-content">
        <!-- Logs Tab -->
        <div class="tab-pane fade show active" id="tab-logs" role="tabpanel">
            <div class="card">
                <div class="card-header bg-white">
                    <div class="d-flex flex-wrap gap-3 justify-content-between align-items-center">
                        <h5 class="mb-0">Danh sách email đã gửi</h5>
                        <div class="d-flex gap-2">
                            <select class="form-select form-select-sm">
                                <option>Trạng thái: Tất cả</option>
                                <option>Sent</option>
                                <option>Queued</option>
                                <option>Failed</option>
                            </select>
                            <input type="text" class="form-control form-control-sm" placeholder="Tìm theo email, tiêu đề...">
                            <button class="btn btn-outline-secondary btn-sm">
                                <i class="bi bi-funnel me-1"></i>Lọc
                            </button>
                        </div>
                    </div>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>#</th>
                                    <th>Người nhận</th>
                                    <th>Chủ đề</th>
                                    <th>Trạng thái</th>
                                    <th>Thời gian</th>
                                    <th class="text-end">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>EM-10231</td>
                                    <td>
                                        <div class="fw-semibold">nguyen.anh@email.com</div>
                                        <div class="text-muted small">Lead · Nguyễn Anh</div>
                                    </td>
                                    <td>Báo giá khóa học Fullstack</td>
                                    <td><span class="badge bg-success-subtle text-success border border-success-subtle">Sent</span></td>
                                    <td>09:42 14/03/2026</td>
                                    <td class="text-end">
                                        <button class="btn btn-sm btn-outline-secondary">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                        <button class="btn btn-sm btn-outline-primary">
                                            <i class="bi bi-arrow-repeat"></i>
                                        </button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>EM-10230</td>
                                    <td>
                                        <div class="fw-semibold">linh.tran@email.com</div>
                                        <div class="text-muted small">Customer · Trần Linh</div>
                                    </td>
                                    <td>Ưu đãi gia hạn khóa học</td>
                                    <td><span class="badge bg-warning-subtle text-warning border border-warning-subtle">Queued</span></td>
                                    <td>09:15 14/03/2026</td>
                                    <td class="text-end">
                                        <button class="btn btn-sm btn-outline-secondary">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                        <button class="btn btn-sm btn-outline-primary">
                                            <i class="bi bi-arrow-repeat"></i>
                                        </button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>EM-10229</td>
                                    <td>
                                        <div class="fw-semibold">cuong.le@email.com</div>
                                        <div class="text-muted small">Lead · Lê Cường</div>
                                    </td>
                                    <td>Nhắc lịch tư vấn miễn phí</td>
                                    <td><span class="badge bg-danger-subtle text-danger border border-danger-subtle">Failed</span></td>
                                    <td>08:40 14/03/2026</td>
                                    <td class="text-end">
                                        <button class="btn btn-sm btn-outline-secondary">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                        <button class="btn btn-sm btn-outline-primary">
                                            <i class="bi bi-arrow-repeat"></i>
                                        </button>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="6" class="text-center text-muted py-4">
                                        Kéo xuống để xem thêm nhật ký
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Templates Tab -->
        <div class="tab-pane fade" id="tab-templates" role="tabpanel">
            <div class="row g-3">
                <div class="col-lg-4">
                    <div class="card h-100 border-0 shadow-sm">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle">Quotation</span>
                                <span class="text-muted small">Default</span>
                            </div>
                            <h6 class="mb-2">Gửi báo giá cho khách hàng</h6>
                            <p class="text-muted small mb-3">
                                Dùng khi gửi báo giá mới, tự động chèn số báo giá và link xem.
                            </p>
                            <div class="d-flex gap-2">
                                <button class="btn btn-outline-secondary btn-sm">Xem</button>
                                <button class="btn btn-primary btn-sm">Sửa mẫu</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="card h-100 border-0 shadow-sm">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="badge bg-success-subtle text-success border border-success-subtle">Marketing</span>
                                <span class="text-muted small">Active</span>
                            </div>
                            <h6 class="mb-2">Ưu đãi mùa hè</h6>
                            <p class="text-muted small mb-3">
                                Email khuyến mãi theo segment khách hàng VIP và Regular.
                            </p>
                            <div class="d-flex gap-2">
                                <button class="btn btn-outline-secondary btn-sm">Xem</button>
                                <button class="btn btn-primary btn-sm">Sửa mẫu</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="card h-100 border-0 shadow-sm">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="badge bg-info-subtle text-info border border-info-subtle">Onboarding</span>
                                <span class="text-muted small">Active</span>
                            </div>
                            <h6 class="mb-2">Chào mừng khách hàng mới</h6>
                            <p class="text-muted small mb-3">
                                Gửi ngay sau khi khách hàng hoàn tất đăng ký.
                            </p>
                            <div class="d-flex gap-2">
                                <button class="btn btn-outline-secondary btn-sm">Xem</button>
                                <button class="btn btn-primary btn-sm">Sửa mẫu</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Settings Tab -->
        <div class="tab-pane fade" id="tab-settings" role="tabpanel">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <h5 class="mb-3">Cấu hình SMTP</h5>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">SMTP Host</label>
                            <input type="text" class="form-control" placeholder="smtp.yourdomain.com">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Port</label>
                            <input type="text" class="form-control" placeholder="587">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Bảo mật</label>
                            <select class="form-select">
                                <option>TLS</option>
                                <option>SSL</option>
                                <option>None</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Email gửi mặc định</label>
                            <input type="email" class="form-control" placeholder="no-reply@yourdomain.com">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Tên hiển thị</label>
                            <input type="text" class="form-control" placeholder="CRM Pro Mailer">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Tài khoản SMTP</label>
                            <input type="text" class="form-control" placeholder="smtp-user">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Mật khẩu</label>
                            <input type="password" class="form-control" placeholder="••••••••">
                        </div>
                        <div class="col-12">
                            <label class="form-label">Tracking</label>
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" checked>
                                <label class="form-check-label">Bật theo dõi mở email và click</label>
                            </div>
                        </div>
                    </div>
                    <div class="mt-4 d-flex gap-2">
                        <button class="btn btn-primary">
                            <i class="bi bi-save me-2"></i>Lưu cấu hình
                        </button>
                        <button class="btn btn-outline-secondary">
                            <i class="bi bi-send-check me-2"></i>Gửi thử
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
