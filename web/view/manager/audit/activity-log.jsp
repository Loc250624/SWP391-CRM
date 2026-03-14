<%@ page contentType="text/html;charset=UTF-8" %>

<div class="container-fluid">
    <!-- Header -->
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <h3 class="mb-1"><i class="bi bi-activity me-2"></i>Log Activities</h3>
            <p class="text-muted mb-0">Theo dõi lịch hẹn và hoạt động của các vai trò trong hệ thống</p>
        </div>
        <div class="d-flex gap-2">
            <button class="btn btn-outline-secondary">
                <i class="bi bi-download me-2"></i>Export
            </button>
            <button class="btn btn-primary">
                <i class="bi bi-funnel me-2"></i>Lọc nâng cao
            </button>
        </div>
    </div>

    <!-- KPI -->
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="text-muted small">Tổng hoạt động</div>
                    <div class="h4 mb-1">3,240</div>
                    <div class="small text-muted">7 ngày gần nhất</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="text-muted small">Lịch hẹn</div>
                    <div class="h4 mb-1">428</div>
                    <div class="small text-muted">Đã hoàn thành</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="text-muted small">Cuộc gọi</div>
                    <div class="h4 mb-1">612</div>
                    <div class="small text-muted">Tỷ lệ kết nối 78%</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="text-muted small">Email</div>
                    <div class="h4 mb-1">1,110</div>
                    <div class="small text-muted">Tỷ lệ mở 36%</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Filters -->
    <div class="card mb-4">
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-3">
                    <label class="form-label">Khoảng thời gian</label>
                    <input type="text" class="form-control" placeholder="01/03/2026 - 14/03/2026">
                </div>
                <div class="col-md-2">
                    <label class="form-label">Loại hoạt động</label>
                    <select class="form-select">
                        <option>Tất cả</option>
                        <option>Meeting</option>
                        <option>Call</option>
                        <option>Email</option>
                        <option>Task</option>
                        <option>Note</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Đối tượng</label>
                    <select class="form-select">
                        <option>Tất cả</option>
                        <option>Lead</option>
                        <option>Customer</option>
                        <option>Opportunity</option>
                        <option>Quotation</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Vai trò</label>
                    <select class="form-select">
                        <option>Tất cả</option>
                        <option>Sale</option>
                        <option>Manager</option>
                        <option>CS</option>
                        <option>Marketing</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Tìm kiếm</label>
                    <input type="text" class="form-control" placeholder="Tên người thực hiện, tiêu đề...">
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <button class="btn btn-primary w-100">
                        <i class="bi bi-search me-2"></i>Áp dụng
                    </button>
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <button class="btn btn-outline-secondary w-100">
                        <i class="bi bi-x-circle me-2"></i>Reset
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Table -->
    <div class="card">
        <div class="card-header bg-white">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
                <h5 class="mb-0">Danh sách hoạt động</h5>
                <div class="d-flex gap-2">
                    <select class="form-select form-select-sm">
                        <option>Sắp xếp: Mới nhất</option>
                        <option>Cũ nhất</option>
                        <option>Thời lượng</option>
                    </select>
                    <select class="form-select form-select-sm">
                        <option>Trạng thái: Tất cả</option>
                        <option>Đã hoàn thành</option>
                        <option>Đang xử lý</option>
                        <option>Đã hủy</option>
                    </select>
                </div>
            </div>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0 align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>#</th>
                            <th>Thời gian</th>
                            <th>Loại</th>
                            <th>Đối tượng</th>
                            <th>Nội dung</th>
                            <th>Người thực hiện</th>
                            <th>Thời lượng</th>
                            <th>Kết quả</th>
                            <th class="text-end">Chi tiết</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>AC-24109</td>
                            <td>14/03/2026 15:20</td>
                            <td><span class="badge bg-success-subtle text-success border border-success-subtle">Meeting</span></td>
                            <td>
                                <div class="fw-semibold">Lead · LD001</div>
                                <div class="text-muted small">Nguyễn Minh Quang</div>
                            </td>
                            <td>
                                <div class="fw-semibold">Tư vấn demo sản phẩm</div>
                                <div class="text-muted small">Lịch hẹn tại văn phòng</div>
                            </td>
                            <td>
                                <div class="fw-semibold">Trần Hoàng</div>
                                <div class="text-muted small">Sale</div>
                            </td>
                            <td>45 phút</td>
                            <td>Đã hoàn thành</td>
                            <td class="text-end">
                                <button class="btn btn-sm btn-outline-secondary">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </td>
                        </tr>
                        <tr>
                            <td>AC-24108</td>
                            <td>14/03/2026 14:10</td>
                            <td><span class="badge bg-primary-subtle text-primary border border-primary-subtle">Call</span></td>
                            <td>
                                <div class="fw-semibold">Customer · KH0003</div>
                                <div class="text-muted small">Lê Hoàng Cường</div>
                            </td>
                            <td>
                                <div class="fw-semibold">Gọi chăm sóc khóa học</div>
                                <div class="text-muted small">Ghi chú về nhu cầu nâng cấp</div>
                            </td>
                            <td>
                                <div class="fw-semibold">Phạm Ngọc</div>
                                <div class="text-muted small">CS</div>
                            </td>
                            <td>12 phút</td>
                            <td>Thành công</td>
                            <td class="text-end">
                                <button class="btn btn-sm btn-outline-secondary">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </td>
                        </tr>
                        <tr>
                            <td>AC-24107</td>
                            <td>14/03/2026 13:05</td>
                            <td><span class="badge bg-info-subtle text-info border border-info-subtle">Email</span></td>
                            <td>
                                <div class="fw-semibold">Opportunity · OP302</div>
                                <div class="text-muted small">Gửi báo giá mới</div>
                            </td>
                            <td>
                                <div class="fw-semibold">Email báo giá</div>
                                <div class="text-muted small">Quote #QT-00981</div>
                            </td>
                            <td>
                                <div class="fw-semibold">Lê Thảo</div>
                                <div class="text-muted small">Manager</div>
                            </td>
                            <td>-</td>
                            <td>Đã gửi</td>
                            <td class="text-end">
                                <button class="btn btn-sm btn-outline-secondary">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="9" class="text-center text-muted py-4">
                                Kéo xuống để xem thêm hoạt động
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
