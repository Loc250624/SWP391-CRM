<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">Tao Bao gia moi</h4>
        <p class="text-muted mb-0">Dien thong tin de tao bao gia cho khach hang</p>
    </div>
</div>

<form>
    <div class="row g-4">
        <div class="col-lg-8">
            <!-- Basic Info -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold"><i class="bi bi-info-circle me-2"></i>Thong tin co ban</h6></div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Tieu de bao gia <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" placeholder="VD: Bao gia goi dao tao...">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Opportunity <span class="text-danger">*</span></label>
                            <select class="form-select">
                                <option selected disabled>Chon opportunity...</option>
                                <option>OPP-0025 - Hop dong ERP Enterprise</option>
                                <option>OPP-0030 - Giai phap dao tao XYZ</option>
                                <option>OPP-0035 - He thong E-Learning ABC</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Khach hang</label>
                            <select class="form-select"><option selected disabled>Tu dong theo opportunity</option></select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Hieu luc den <span class="text-danger">*</span></label>
                            <input type="date" class="form-control" value="2026-03-14">
                        </div>
                        <div class="col-12">
                            <label class="form-label">Mo ta</label>
                            <textarea class="form-control" rows="3" placeholder="Mo ta chi tiet bao gia..."></textarea>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Items -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0 d-flex justify-content-between align-items-center">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-list-check me-2"></i>Hang muc</h6>
                    <button type="button" class="btn btn-sm btn-outline-primary"><i class="bi bi-plus me-1"></i>Them hang muc</button>
                </div>
                <div class="card-body pt-0">
                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead class="table-light"><tr><th>Khoa hoc / Dich vu</th><th style="width:80px;">SL</th><th style="width:160px;">Don gia</th><th style="width:120px;">Giam gia</th><th style="width:160px;" class="text-end">Thanh tien</th><th style="width:50px;"></th></tr></thead>
                            <tbody>
                                <tr>
                                    <td><select class="form-select form-select-sm"><option>Digital Marketing Masterclass</option><option>Data Science Bootcamp</option></select></td>
                                    <td><input type="number" class="form-control form-control-sm" value="5"></td>
                                    <td><input type="text" class="form-control form-control-sm" value="120,000,000"></td>
                                    <td><input type="text" class="form-control form-control-sm" value="10%"></td>
                                    <td class="text-end fw-semibold">540,000,000 d</td>
                                    <td><button type="button" class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i></button></td>
                                </tr>
                                <tr>
                                    <td><select class="form-select form-select-sm"><option>Leadership Workshop</option></select></td>
                                    <td><input type="number" class="form-control form-control-sm" value="3"></td>
                                    <td><input type="text" class="form-control form-control-sm" value="85,000,000"></td>
                                    <td><input type="text" class="form-control form-control-sm" value="0%"></td>
                                    <td class="text-end fw-semibold">255,000,000 d</td>
                                    <td><button type="button" class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i></button></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Terms -->
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold"><i class="bi bi-file-text me-2"></i>Dieu khoan</h6></div>
                <div class="card-body">
                    <div class="mb-3">
                        <label class="form-label">Dieu khoan thanh toan</label>
                        <textarea class="form-control" rows="2" placeholder="VD: Thanh toan 50% khi ky hop dong, 50% sau khi hoan thanh">Thanh toan 50% truoc khi bat dau khoa hoc, 50% con lai sau khi hoan thanh.</textarea>
                    </div>
                    <div>
                        <label class="form-label">Ghi chu noi bo</label>
                        <textarea class="form-control" rows="2" placeholder="Chi hien thi noi bo, khach hang khong thay..."></textarea>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <!-- Summary -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Tom tat</h6></div>
                <div class="card-body">
                    <div class="d-flex justify-content-between mb-2"><span class="text-muted">Tong phu</span><span class="fw-medium">795,000,000 d</span></div>
                    <div class="d-flex justify-content-between mb-2"><span class="text-muted">Giam gia</span><span class="fw-medium text-danger">-60,000,000 d</span></div>
                    <div class="d-flex justify-content-between mb-2"><span class="text-muted">Thue (10%)</span><span class="fw-medium">73,500,000 d</span></div>
                    <hr>
                    <div class="d-flex justify-content-between"><span class="fw-bold">Tong cong</span><span class="fw-bold text-success fs-5">808,500,000 d</span></div>
                </div>
            </div>

            <!-- Actions -->
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary"><i class="bi bi-save me-1"></i>Luu bao gia</button>
                        <button type="button" class="btn btn-outline-primary"><i class="bi bi-send me-1"></i>Luu & Gui cho khach</button>
                        <a href="${pageContext.request.contextPath}/sale/quotation/list" class="btn btn-outline-secondary">Huy</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>
