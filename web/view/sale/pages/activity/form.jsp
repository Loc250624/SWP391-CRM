<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div><h4 class="mb-1 fw-bold">Ghi nhan Hoat dong</h4><p class="text-muted mb-0">Ghi nhan cuoc goi, email, cuoc hop hoac ghi chu</p></div>
</div>

<form>
    <div class="row g-4">
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold"><i class="bi bi-activity me-2"></i>Thong tin hoat dong</h6></div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Loai hoat dong <span class="text-danger">*</span></label>
                            <select class="form-select"><option selected disabled>Chon loai...</option><option>Cuoc goi</option><option>Email</option><option>Cuoc hop</option><option>Ghi chu</option></select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Doi tuong lien quan</label>
                            <select class="form-select"><option selected disabled>Chon...</option><option>OPP-0025 - Hop dong ERP</option><option>LEAD-0089 - Nguyen Van A</option><option>CUST-001 - ABC Corp</option></select>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label">Tieu de <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" placeholder="VD: Goi tu van khoa hoc...">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Ngay gio <span class="text-danger">*</span></label>
                            <input type="datetime-local" class="form-control" value="2026-02-14T10:00">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Thoi luong (phut)</label>
                            <input type="number" class="form-control" placeholder="30">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Huong cuoc goi</label>
                            <select class="form-select"><option>Goi di (Outbound)</option><option>Goi den (Inbound)</option></select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Ket qua</label>
                            <select class="form-select"><option selected disabled>Chon ket qua...</option><option>Thanh cong</option><option>Khong tra loi</option><option>Ban</option><option>Hen lai</option></select>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Mo ta chi tiet</label>
                            <textarea class="form-control" rows="4" placeholder="Noi dung chi tiet cuoc goi / email / cuoc hop..."></textarea>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="card border-0 shadow-sm"><div class="card-body">
                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-primary"><i class="bi bi-save me-1"></i>Luu hoat dong</button>
                    <a href="${pageContext.request.contextPath}/sale/activity/list" class="btn btn-outline-secondary">Huy</a>
                </div>
            </div></div>
        </div>
    </div>
</form>
