<%@ page contentType="text/html;charset=UTF-8" %>

<div class="container-fluid">
    <!-- Header -->
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <h3 class="mb-1"><i class="bi bi-bell me-2"></i>Quản lý Thông báo</h3>
            <p class="text-muted mb-0">Thiết lập, phân loại và theo dõi thông báo CRM theo vai trò & kênh gửi</p>
        </div>
        <div class="d-flex gap-2">
            <button class="btn btn-outline-secondary">
                <i class="bi bi-file-earmark-arrow-down me-2"></i>Export log
            </button>
            <a href="${pageContext.request.contextPath}/manager/notifications/create" class="btn btn-primary">
                <i class="bi bi-plus-circle me-2"></i>Tạo thông báo
            </a>
        </div>
    </div>

    <!-- KPI -->
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="text-muted small">Thông báo đã gửi</div>
                    <div class="h4 mb-1">6,420</div>
                    <div class="small text-muted">30 ngày gần nhất</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="text-muted small">Đang xếp hàng</div>
                    <div class="h4 mb-1">86</div>
                    <div class="small text-muted">Đợi xử lý</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="text-muted small">Tỷ lệ mở</div>
                    <div class="h4 mb-1">42.8%</div>
                    <div class="small text-muted">In-app + Email</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="text-muted small">Kênh hoạt động</div>
                    <div class="h4 mb-1">4/5</div>
                    <div class="small text-muted">In-app, Email, SMS, Push</div>
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
                <i class="bi bi-layout-text-window-reverse me-2"></i>Mẫu thông báo
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-rules" type="button" role="tab">
                <i class="bi bi-sliders2 me-2"></i>Quy tắc tự động
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-settings" type="button" role="tab">
                <i class="bi bi-gear me-2"></i>Cấu hình kênh
            </button>
        </li>
    </ul>

    <div class="tab-content">
        <!-- Logs -->
        <div class="tab-pane fade show active" id="tab-logs" role="tabpanel">
            <div class="card">
                <div class="card-header bg-white">
                    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
                        <h5 class="mb-0">Danh sách thông báo đã gửi</h5>
                        <div class="d-flex gap-2">
                            <select class="form-select form-select-sm">
                                <option>Trạng thái: Tất cả</option>
                                <option>Sent</option>
                                <option>Queued</option>
                                <option>Failed</option>
                                <option>Cancelled</option>
                            </select>
                            <select class="form-select form-select-sm">
                                <option>Kênh: Tất cả</option>
                                <option>In-app</option>
                                <option>Email</option>
                                <option>SMS</option>
                                <option>Push</option>
                            </select>
                            <input type="text" class="form-control form-control-sm" placeholder="Tìm theo tiêu đề, người nhận...">
                            <button class="btn btn-outline-secondary btn-sm">
                                <i class="bi bi-funnel me-1"></i>Lọc
                            </button>
                        </div>
                    </div>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0 align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>#</th>
                                    <th>Tiêu đề</th>
                                    <th>Người nhận</th>
                                    <th>Kênh</th>
                                    <th>Ưu tiên</th>
                                    <th>Trạng thái</th>
                                    <th>Thời gian</th>
                                    <th class="text-end">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>NT-20931</td>
                                    <td>
                                        <div class="fw-semibold">Nhắc lịch hẹn demo</div>
                                        <div class="text-muted small">Lead · Lịch hẹn 10:00</div>
                                    </td>
                                    <td>
                                        <div class="fw-semibold">Nguyễn Minh Quang</div>
                                        <div class="text-muted small">Sales · Team A</div>
                                    </td>
                                    <td><span class="badge bg-info-subtle text-info border border-info-subtle">In-app</span></td>
                                    <td><span class="badge bg-warning-subtle text-warning border border-warning-subtle">High</span></td>
                                    <td><span class="badge bg-success-subtle text-success border border-success-subtle">Sent</span></td>
                                    <td>14/03/2026 16:45</td>
                                    <td class="text-end">
                                        <button class="btn btn-sm btn-outline-secondary"><i class="bi bi-eye"></i></button>
                                        <button class="btn btn-sm btn-outline-primary"><i class="bi bi-arrow-repeat"></i></button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>NT-20930</td>
                                    <td>
                                        <div class="fw-semibold">Báo giá sắp hết hạn</div>
                                        <div class="text-muted small">Quotation · QT-00981</div>
                                    </td>
                                    <td>
                                        <div class="fw-semibold">Trần Linh</div>
                                        <div class="text-muted small">Customer · VIP</div>
                                    </td>
                                    <td><span class="badge bg-primary-subtle text-primary border border-primary-subtle">Email</span></td>
                                    <td><span class="badge bg-success-subtle text-success border border-success-subtle">Normal</span></td>
                                    <td><span class="badge bg-warning-subtle text-warning border border-warning-subtle">Queued</span></td>
                                    <td>14/03/2026 16:10</td>
                                    <td class="text-end">
                                        <button class="btn btn-sm btn-outline-secondary"><i class="bi bi-eye"></i></button>
                                        <button class="btn btn-sm btn-outline-primary"><i class="bi bi-arrow-repeat"></i></button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>NT-20929</td>
                                    <td>
                                        <div class="fw-semibold">Điểm SLA sắp vi phạm</div>
                                        <div class="text-muted small">Task · TSK-1289</div>
                                    </td>
                                    <td>
                                        <div class="fw-semibold">Đặng Văn Giang</div>
                                        <div class="text-muted small">Manager</div>
                                    </td>
                                    <td><span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle">SMS</span></td>
                                    <td><span class="badge bg-danger-subtle text-danger border border-danger-subtle">Urgent</span></td>
                                    <td><span class="badge bg-danger-subtle text-danger border border-danger-subtle">Failed</span></td>
                                    <td>14/03/2026 15:55</td>
                                    <td class="text-end">
                                        <button class="btn btn-sm btn-outline-secondary"><i class="bi bi-eye"></i></button>
                                        <button class="btn btn-sm btn-outline-primary"><i class="bi bi-arrow-repeat"></i></button>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="8" class="text-center text-muted py-4">Kéo xuống để xem thêm</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Templates -->
        <div class="tab-pane fade" id="tab-templates" role="tabpanel">
            <div class="row g-3">
                <div class="col-lg-4">
                    <div class="card h-100 border-0 shadow-sm">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle">System</span>
                                <span class="text-muted small">Default</span>
                            </div>
                            <h6 class="mb-2">Nhắc lịch hẹn demo</h6>
                            <p class="text-muted small mb-3">Tự động gửi trước lịch hẹn 30 phút cho Sales và khách hàng.</p>
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
                                <span class="badge bg-success-subtle text-success border border-success-subtle">Sales</span>
                                <span class="text-muted small">Active</span>
                            </div>
                            <h6 class="mb-2">Báo giá sắp hết hạn</h6>
                            <p class="text-muted small mb-3">Gửi nhắc khách hàng trước ngày hết hạn báo giá.</p>
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
                                <span class="badge bg-warning-subtle text-warning border border-warning-subtle">SLA</span>
                                <span class="text-muted small">Active</span>
                            </div>
                            <h6 class="mb-2">Cảnh báo SLA</h6>
                            <p class="text-muted small mb-3">Thông báo cho manager khi sắp vi phạm SLA.</p>
                            <div class="d-flex gap-2">
                                <button class="btn btn-outline-secondary btn-sm">Xem</button>
                                <button class="btn btn-primary btn-sm">Sửa mẫu</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Rules -->
        <div class="tab-pane fade" id="tab-rules" role="tabpanel">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="mb-0">Quy tắc tự động</h5>
                        <button class="btn btn-outline-primary btn-sm"><i class="bi bi-plus-circle me-1"></i>Thêm quy tắc</button>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Tên quy tắc</th>
                                    <th>Trigger</th>
                                    <th>Đối tượng</th>
                                    <th>Người nhận</th>
                                    <th>Kênh</th>
                                    <th>Ưu tiên</th>
                                    <th>Trạng thái</th>
                                    <th class="text-end">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="fw-semibold">Nhắc lịch hẹn trước 30 phút</td>
                                    <td>Activity: Meeting</td>
                                    <td>Lead/Customer</td>
                                    <td>Sales + Customer</td>
                                    <td>In-app, Email</td>
                                    <td>High</td>
                                    <td><span class="badge bg-success-subtle text-success border border-success-subtle">Active</span></td>
                                    <td class="text-end">
                                        <button class="btn btn-sm btn-outline-secondary"><i class="bi bi-gear"></i></button>
                                        <button class="btn btn-sm btn-outline-danger"><i class="bi bi-slash-circle"></i></button>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-semibold">SLA sắp vi phạm</td>
                                    <td>Task: Due &lt; 2h</td>
                                    <td>Task</td>
                                    <td>Manager</td>
                                    <td>SMS</td>
                                    <td>Urgent</td>
                                    <td><span class="badge bg-success-subtle text-success border border-success-subtle">Active</span></td>
                                    <td class="text-end">
                                        <button class="btn btn-sm btn-outline-secondary"><i class="bi bi-gear"></i></button>
                                        <button class="btn btn-sm btn-outline-danger"><i class="bi bi-slash-circle"></i></button>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-semibold">Báo giá sắp hết hạn</td>
                                    <td>Quotation: Expire -3d</td>
                                    <td>Quotation</td>
                                    <td>Sales + Customer</td>
                                    <td>Email</td>
                                    <td>Normal</td>
                                    <td><span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle">Paused</span></td>
                                    <td class="text-end">
                                        <button class="btn btn-sm btn-outline-secondary"><i class="bi bi-gear"></i></button>
                                        <button class="btn btn-sm btn-outline-success"><i class="bi bi-play"></i></button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Settings -->
        <div class="tab-pane fade" id="tab-settings" role="tabpanel">
            <div class="row g-3">
                <div class="col-lg-6">
                    <div class="card h-100 border-0 shadow-sm">
                        <div class="card-body">
                            <h5 class="mb-3">Kênh In-app</h5>
                            <div class="form-check form-switch mb-3">
                                <input class="form-check-input" type="checkbox" checked>
                                <label class="form-check-label">Bật thông báo In-app</label>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Thời gian lưu thông báo</label>
                                <select class="form-select">
                                    <option>7 ngày</option>
                                    <option>14 ngày</option>
                                    <option>30 ngày</option>
                                    <option>90 ngày</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Mức ưu tiên mặc định</label>
                                <select class="form-select">
                                    <option>Normal</option>
                                    <option>High</option>
                                    <option>Urgent</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="card h-100 border-0 shadow-sm">
                        <div class="card-body">
                            <h5 class="mb-3">Kênh Email/SMS/Push</h5>
                            <div class="form-check form-switch mb-3">
                                <input class="form-check-input" type="checkbox" checked>
                                <label class="form-check-label">Bật email notification</label>
                            </div>
                            <div class="form-check form-switch mb-3">
                                <input class="form-check-input" type="checkbox" checked>
                                <label class="form-check-label">Bật SMS notification</label>
                            </div>
                            <div class="form-check form-switch mb-3">
                                <input class="form-check-input" type="checkbox" checked>
                                <label class="form-check-label">Bật Push notification</label>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Giới hạn thông báo/giờ</label>
                                <input type="number" class="form-control" placeholder="200">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Giờ yên lặng</label>
                                <input type="text" class="form-control" placeholder="22:00 - 07:00">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="mt-3 d-flex gap-2">
                <button class="btn btn-primary"><i class="bi bi-save me-2"></i>Lưu cấu hình</button>
                <button class="btn btn-outline-secondary"><i class="bi bi-send-check me-2"></i>Gửi thử</button>
            </div>
        </div>
    </div>
</div>

