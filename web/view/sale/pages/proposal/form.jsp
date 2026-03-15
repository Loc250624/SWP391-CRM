<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div><h4 class="mb-1 fw-bold">Tạo Proposal mới</h4><p class="text-muted mb-0">Tạo đề xuất thương mại cho khách hàng</p></div>
</div>

<form>
    <div class="row g-4">
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold"><i class="bi bi-info-circle me-2"></i>Thông tin Proposal</h6></div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-12"><label class="form-label">Tiêu đề <span class="text-danger">*</span></label><input type="text" class="form-control" placeholder="VD: Đề xuất giải pháp đào tạo..."></div>
                        <div class="col-md-6"><label class="form-label">Opportunity</label><select class="form-select"><option selected disabled>Chọn opportunity...</option><option>OPP-0025 - Hợp đồng ERP</option><option>OPP-0030 - Giải pháp XYZ</option></select></div>
                        <div class="col-md-6"><label class="form-label">Khách hàng</label><select class="form-select"><option selected disabled>Chọn khách hàng...</option><option>ABC Corporation</option><option>XYZ Limited</option></select></div>
                        <div class="col-12"><label class="form-label">Tóm tắt</label><textarea class="form-control" rows="3" placeholder="Tóm tắt nội dung proposal..."></textarea></div>
                    </div>
                </div>
            </div>
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold"><i class="bi bi-file-text me-2"></i>Nội dung chính</h6></div>
                <div class="card-body">
                    <div class="mb-3"><label class="form-label">Vấn đề khách hàng</label><textarea class="form-control" rows="3" placeholder="Mô tả vấn đề khách hàng đang gặp..."></textarea></div>
                    <div class="mb-3"><label class="form-label">Giải pháp đề xuất</label><textarea class="form-control" rows="4" placeholder="Mô tả giải pháp bạn đề xuất..."></textarea></div>
                    <div><label class="form-label">Lợi ích mang lại</label><textarea class="form-control" rows="3" placeholder="Liệt kê các lợi ích chính..."></textarea></div>
                </div>
            </div>
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-transparent border-0 d-flex justify-content-between"><h6 class="mb-0 fw-semibold"><i class="bi bi-paperclip me-2"></i>File đính kèm</h6><button type="button" class="btn btn-sm btn-outline-primary"><i class="bi bi-upload me-1"></i>Tải lên</button></div>
                <div class="card-body text-center py-4 text-muted"><i class="bi bi-cloud-upload fs-1 d-block mb-2"></i><p>Kéo thả hoặc nhấn để tải file lên</p></div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="card border-0 shadow-sm"><div class="card-body">
                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-primary"><i class="bi bi-save me-1"></i>Lưu Proposal</button>
                    <button type="button" class="btn btn-outline-primary"><i class="bi bi-send me-1"></i>Lưu & Gửi duyệt</button>
                    <a href="${pageContext.request.contextPath}/sale/proposal/list" class="btn btn-outline-secondary">Hủy</a>
                </div>
            </div></div>
        </div>
    </div>
</form>
