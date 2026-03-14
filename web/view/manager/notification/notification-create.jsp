<%@ page contentType="text/html;charset=UTF-8" %>

<div class="container-fluid">
    <!-- Header -->
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <h3 class="mb-1"><i class="bi bi-megaphone me-2"></i>Tạo Thông báo</h3>
            <p class="text-muted mb-0">Soạn thông báo CRM theo kênh, đối tượng và quy tắc gửi</p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/manager/notifications" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-2"></i>Quay lại
            </a>
            <button class="btn btn-primary">
                <i class="bi bi-send-check me-2"></i>Gửi ngay
            </button>
        </div>
    </div>

    <div class="row g-3">
        <!-- Form -->
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <h5 class="mb-3">Nội dung thông báo</h5>

                    <div class="mb-3">
                        <label class="form-label">Tiêu đề</label>
                        <input type="text" class="form-control" placeholder="Nhập tiêu đề thông báo">
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Tóm tắt</label>
                        <input type="text" class="form-control" placeholder="Mô tả ngắn hiển thị ở danh sách">
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Nội dung chi tiết</label>
                        <textarea class="form-control" rows="8" placeholder="Soạn nội dung thông báo..."></textarea>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Loại thông báo</label>
                            <select class="form-select">
                                <option>System</option>
                                <option>Sales</option>
                                <option>Marketing</option>
                                <option>SLA</option>
                                <option>Security</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Mức ưu tiên</label>
                            <select class="form-select">
                                <option>Normal</option>
                                <option>High</option>
                                <option>Urgent</option>
                            </select>
                        </div>
                    </div>

                    <div class="mt-3">
                        <label class="form-label">Hành động khi click</label>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <input type="text" class="form-control" placeholder="URL hoặc route nội bộ">
                            </div>
                            <div class="col-md-6">
                                <select class="form-select">
                                    <option>Mở trong tab hiện tại</option>
                                    <option>Mở tab mới</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="mt-4 d-flex gap-2">
                        <button class="btn btn-primary"><i class="bi bi-send-check me-2"></i>Gửi ngay</button>
                        <button class="btn btn-outline-secondary"><i class="bi bi-clock me-2"></i>Lên lịch gửi</button>
                        <button class="btn btn-outline-secondary"><i class="bi bi-save me-2"></i>Lưu nháp</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Side Panel -->
        <div class="col-lg-4">
            <div class="card border-0 shadow-sm mb-3">
                <div class="card-body">
                    <h6 class="mb-3">Chọn kênh gửi</h6>
                    <div class="form-check form-switch mb-2">
                        <input class="form-check-input" type="checkbox" checked>
                        <label class="form-check-label">In-app</label>
                    </div>
                    <div class="form-check form-switch mb-2">
                        <input class="form-check-input" type="checkbox" checked>
                        <label class="form-check-label">Email</label>
                    </div>
                    <div class="form-check form-switch mb-2">
                        <input class="form-check-input" type="checkbox">
                        <label class="form-check-label">SMS</label>
                    </div>
                    <div class="form-check form-switch">
                        <input class="form-check-input" type="checkbox">
                        <label class="form-check-label">Push</label>
                    </div>
                </div>
            </div>

            <div class="card border-0 shadow-sm mb-3">
                <div class="card-body">
                    <h6 class="mb-3">Đối tượng nhận</h6>
                    <select class="form-select mb-2">
                        <option>Toàn bộ hệ thống</option>
                        <option>Theo vai trò</option>
                        <option>Theo phòng ban</option>
                        <option>Theo tag/segment</option>
                        <option>Chỉ định người dùng</option>
                    </select>
                    <input type="text" class="form-control" placeholder="Nhập role, phòng ban hoặc tag">
                    <div class="form-text">Ví dụ: Sales, Manager, CS, VIP, Team A</div>
                </div>
            </div>

            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <h6 class="mb-3">Lên lịch</h6>
                    <div class="mb-3">
                        <label class="form-label">Thời gian gửi</label>
                        <input type="text" class="form-control" placeholder="14/03/2026 18:00">
                    </div>
                    <div class="form-check form-switch">
                        <input class="form-check-input" type="checkbox">
                        <label class="form-check-label">Lặp lại hàng tuần</label>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
