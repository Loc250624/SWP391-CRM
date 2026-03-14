<%@ page contentType="text/html;charset=UTF-8" %>

<div class="container-fluid">
    <!-- Header -->
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <h3 class="mb-1"><i class="bi bi-send me-2"></i>Gửi Email</h3>
            <p class="text-muted mb-0">Soạn và gửi email cho lead/khách hàng theo mẫu CRM</p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/manager/email" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-2"></i>Quay lại
            </a>
            <button class="btn btn-primary">
                <i class="bi bi-send-check me-2"></i>Gửi ngay
            </button>
        </div>
    </div>

    <div class="row g-3">
        <!-- Compose -->
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <h5 class="mb-3">Soạn email</h5>

                    <div class="mb-3">
                        <label class="form-label">Người nhận (To)</label>
                        <input type="text" class="form-control" placeholder="email@domain.com">
                        <div class="form-text">Có thể nhập nhiều email, cách nhau bởi dấu phẩy.</div>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">CC</label>
                            <input type="text" class="form-control" placeholder="cc@domain.com">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">BCC</label>
                            <input type="text" class="form-control" placeholder="bcc@domain.com">
                        </div>
                    </div>

                    <div class="mt-3">
                        <label class="form-label">Chủ đề</label>
                        <input type="text" class="form-control" placeholder="Nhập tiêu đề email">
                    </div>

                    <div class="mt-3">
                        <label class="form-label">Nội dung</label>
                        <div class="border rounded">
                            <div class="d-flex flex-wrap gap-2 border-bottom p-2 bg-light">
                                <button class="btn btn-sm btn-outline-secondary"><i class="bi bi-type-bold"></i></button>
                                <button class="btn btn-sm btn-outline-secondary"><i class="bi bi-type-italic"></i></button>
                                <button class="btn btn-sm btn-outline-secondary"><i class="bi bi-type-underline"></i></button>
                                <div class="vr"></div>
                                <button class="btn btn-sm btn-outline-secondary"><i class="bi bi-list-ul"></i></button>
                                <button class="btn btn-sm btn-outline-secondary"><i class="bi bi-list-ol"></i></button>
                                <div class="vr"></div>
                                <button class="btn btn-sm btn-outline-secondary"><i class="bi bi-link-45deg"></i></button>
                                <button class="btn btn-sm btn-outline-secondary"><i class="bi bi-image"></i></button>
                            </div>
                            <textarea class="form-control border-0" rows="12" placeholder="Soạn nội dung email..."></textarea>
                        </div>
                    </div>

                    <div class="mt-3">
                        <label class="form-label">Đính kèm</label>
                        <div class="d-flex align-items-center gap-2">
                            <button class="btn btn-outline-secondary">
                                <i class="bi bi-paperclip me-2"></i>Chọn file
                            </button>
                            <span class="text-muted small">Chưa có file nào</span>
                        </div>
                    </div>

                    <div class="mt-4 d-flex gap-2">
                        <button class="btn btn-primary">
                            <i class="bi bi-send-check me-2"></i>Gửi ngay
                        </button>
                        <button class="btn btn-outline-secondary">
                            <i class="bi bi-clock me-2"></i>Lên lịch gửi
                        </button>
                        <button class="btn btn-outline-secondary">
                            <i class="bi bi-save me-2"></i>Lưu nháp
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Right Panel -->
        <div class="col-lg-4">
            <div class="card border-0 shadow-sm mb-3">
                <div class="card-body">
                    <h6 class="mb-3">Chọn mẫu email</h6>
                    <select class="form-select mb-3">
                        <option>-- Chọn mẫu --</option>
                        <option>Gửi báo giá</option>
                        <option>Nhắc lịch hẹn demo</option>
                        <option>Chào mừng khách hàng mới</option>
                    </select>
                    <div class="small text-muted">Mẫu sẽ tự điền tiêu đề và nội dung.</div>
                </div>
            </div>

            <div class="card border-0 shadow-sm mb-3">
                <div class="card-body">
                    <h6 class="mb-3">Thiết lập gửi</h6>
                    <div class="mb-3">
                        <label class="form-label">Email gửi (From)</label>
                        <select class="form-select">
                            <option>no-reply@crm.com</option>
                            <option>sales@crm.com</option>
                            <option>support@crm.com</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Tên hiển thị</label>
                        <input type="text" class="form-control" placeholder="CRM Pro">
                    </div>
                    <div class="form-check form-switch">
                        <input class="form-check-input" type="checkbox" checked>
                        <label class="form-check-label">Bật tracking mở email</label>
                    </div>
                </div>
            </div>

            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <h6 class="mb-3">Biến động (variables)</h6>
                    <div class="d-flex flex-wrap gap-2">
                        <span class="badge bg-light text-dark border">{customer_name}</span>
                        <span class="badge bg-light text-dark border">{quotation_number}</span>
                        <span class="badge bg-light text-dark border">{total_amount}</span>
                        <span class="badge bg-light text-dark border">{sales_name}</span>
                        <span class="badge bg-light text-dark border">{company_name}</span>
                    </div>
                    <div class="small text-muted mt-2">Nhấn để copy biến vào nội dung.</div>
                </div>
            </div>
        </div>
    </div>
</div>
