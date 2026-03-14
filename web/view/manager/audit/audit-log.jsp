<%@ page contentType="text/html;charset=UTF-8" %>

<div class="container-fluid">
    <!-- Header -->
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <h3 class="mb-1"><i class="bi bi-shield-check me-2"></i>Audit Logs</h3>
            <p class="text-muted mb-0">Theo dõi thay đổi dữ liệu và hành động hệ thống theo người dùng</p>
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
                    <div class="text-muted small">Tổng log</div>
                    <div class="h4 mb-1">9,842</div>
                    <div class="small text-muted">30 ngày gần nhất</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="text-muted small">Thay đổi quan trọng</div>
                    <div class="h4 mb-1">214</div>
                    <div class="small text-muted">Update/Delete</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="text-muted small">User hoạt động</div>
                    <div class="h4 mb-1">36</div>
                    <div class="small text-muted">Trong hôm nay</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="text-muted small">IP bất thường</div>
                    <div class="h4 mb-1">3</div>
                    <div class="small text-muted">Cần kiểm tra</div>
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
                    <label class="form-label">Hành động</label>
                    <select class="form-select">
                        <option>Tất cả</option>
                        <option>Create</option>
                        <option>Update</option>
                        <option>Delete</option>
                        <option>Login</option>
                        <option>Logout</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Entity</label>
                    <select class="form-select">
                        <option>Tất cả</option>
                        <option>Lead</option>
                        <option>Customer</option>
                        <option>Task</option>
                        <option>Quotation</option>
                        <option>User</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Người dùng</label>
                    <input type="text" class="form-control" placeholder="Tên/Email">
                </div>
                <div class="col-md-3">
                    <label class="form-label">IP</label>
                    <input type="text" class="form-control" placeholder="192.168.x.x">
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
                <h5 class="mb-0">Danh sách Audit Logs</h5>
                <div class="d-flex gap-2">
                    <select class="form-select form-select-sm">
                        <option>Sắp xếp: Mới nhất</option>
                        <option>Cũ nhất</option>
                    </select>
                    <select class="form-select form-select-sm">
                        <option>Mức độ: Tất cả</option>
                        <option>Quan trọng</option>
                        <option>Bình thường</option>
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
                            <th>Hành động</th>
                            <th>Entity</th>
                            <th>Người dùng</th>
                            <th>IP</th>
                            <th>Thay đổi</th>
                            <th class="text-end">Chi tiết</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>AL-90321</td>
                            <td>14/03/2026 16:10</td>
                            <td><span class="badge bg-warning-subtle text-warning border border-warning-subtle">Update</span></td>
                            <td>
                                <div class="fw-semibold">Customer</div>
                                <div class="text-muted small">ID: 2013</div>
                            </td>
                            <td>
                                <div class="fw-semibold">Trần Hoàng</div>
                                <div class="text-muted small">manager@crm.com</div>
                            </td>
                            <td>203.113.3.21</td>
                            <td>
                                <div class="small text-muted">email, phone, status</div>
                            </td>
                            <td class="text-end">
                                <button class="btn btn-sm btn-outline-secondary">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </td>
                        </tr>
                        <tr>
                            <td>AL-90320</td>
                            <td>14/03/2026 15:42</td>
                            <td><span class="badge bg-danger-subtle text-danger border border-danger-subtle">Delete</span></td>
                            <td>
                                <div class="fw-semibold">Lead</div>
                                <div class="text-muted small">ID: 781</div>
                            </td>
                            <td>
                                <div class="fw-semibold">Ngọc Lê</div>
                                <div class="text-muted small">sale@crm.com</div>
                            </td>
                            <td>203.113.3.18</td>
                            <td>
                                <div class="small text-muted">removed record</div>
                            </td>
                            <td class="text-end">
                                <button class="btn btn-sm btn-outline-secondary">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </td>
                        </tr>
                        <tr>
                            <td>AL-90319</td>
                            <td>14/03/2026 15:05</td>
                            <td><span class="badge bg-success-subtle text-success border border-success-subtle">Create</span></td>
                            <td>
                                <div class="fw-semibold">Quotation</div>
                                <div class="text-muted small">ID: 993</div>
                            </td>
                            <td>
                                <div class="fw-semibold">Lê Thảo</div>
                                <div class="text-muted small">manager@crm.com</div>
                            </td>
                            <td>203.113.3.10</td>
                            <td>
                                <div class="small text-muted">new quote created</div>
                            </td>
                            <td class="text-end">
                                <button class="btn btn-sm btn-outline-secondary">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="8" class="text-center text-muted py-4">
                                Kéo xuống để xem thêm audit logs
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
