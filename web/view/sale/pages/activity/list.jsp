<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div><h4 class="mb-1 fw-bold">Danh sach Hoat dong</h4><p class="text-muted mb-0">Tat ca hoat dong ban hang</p></div>
    <a href="${pageContext.request.contextPath}/sale/activity/form" class="btn btn-primary btn-sm"><i class="bi bi-plus-lg me-1"></i>Ghi nhan hoat dong</a>
</div>

<div class="row g-3 mb-4">
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body py-3 text-center"><div class="fs-3 fw-bold text-primary">156</div><small class="text-muted">Tong hoat dong</small></div></div></div>
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body py-3 text-center"><div class="fs-3 fw-bold text-success">48</div><small class="text-muted">Cuoc goi</small></div></div></div>
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body py-3 text-center"><div class="fs-3 fw-bold text-info">62</div><small class="text-muted">Email</small></div></div></div>
    <div class="col-md-3"><div class="card border-0 shadow-sm"><div class="card-body py-3 text-center"><div class="fs-3 fw-bold text-warning">46</div><small class="text-muted">Cuoc hop</small></div></div></div>
</div>

<div class="card border-0 shadow-sm mb-4">
    <div class="card-body py-3">
        <div class="d-flex gap-3 flex-wrap align-items-center">
            <div class="input-group" style="width: 300px;">
                <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-muted"></i></span>
                <input type="text" class="form-control bg-light border-start-0" placeholder="Tim kiem hoat dong...">
            </div>
            <select class="form-select form-select-sm" style="width: auto;">
                <option selected>Tat ca loai</option><option>Cuoc goi</option><option>Email</option><option>Cuoc hop</option><option>Ghi chu</option>
            </select>
            <select class="form-select form-select-sm" style="width: auto;">
                <option selected>7 ngay qua</option><option>30 ngay qua</option><option>Thang nay</option>
            </select>
        </div>
    </div>
</div>

<div class="card border-0 shadow-sm">
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light"><tr><th>Loai</th><th>Tieu de</th><th>Lien quan</th><th>Nguoi thuc hien</th><th>Ngay</th><th>Thoi luong</th></tr></thead>
                <tbody>
                    <tr>
                        <td><span class="badge bg-success-subtle text-success"><i class="bi bi-telephone me-1"></i>Cuoc goi</span></td>
                        <td class="fw-medium">Goi dam phan hop dong ABC Corp</td>
                        <td><small class="text-muted">OPP-0025</small></td>
                        <td><div class="d-flex align-items-center gap-2"><div class="bg-primary text-white rounded d-flex align-items-center justify-content-center" style="width:24px;height:24px;font-size:10px;">NT</div><small>Nguyen Thanh</small></div></td>
                        <td><small>14/02/2026 14:30</small></td>
                        <td><small class="text-muted">25 phut</small></td>
                    </tr>
                    <tr>
                        <td><span class="badge bg-primary-subtle text-primary"><i class="bi bi-envelope me-1"></i>Email</span></td>
                        <td class="fw-medium">Gui bao gia cho XYZ Limited</td>
                        <td><small class="text-muted">OPP-0030</small></td>
                        <td><div class="d-flex align-items-center gap-2"><div class="bg-success text-white rounded d-flex align-items-center justify-content-center" style="width:24px;height:24px;font-size:10px;">LM</div><small>Le Mai</small></div></td>
                        <td><small>14/02/2026 10:00</small></td>
                        <td><small class="text-muted">-</small></td>
                    </tr>
                    <tr>
                        <td><span class="badge bg-warning-subtle text-warning"><i class="bi bi-people me-1"></i>Cuoc hop</span></td>
                        <td class="fw-medium">Demo san pham cho DEF Group</td>
                        <td><small class="text-muted">OPP-0035</small></td>
                        <td><div class="d-flex align-items-center gap-2"><div class="rounded d-flex align-items-center justify-content-center text-white" style="width:24px;height:24px;font-size:10px;background:#fb923c;">PH</div><small>Pham Huy</small></div></td>
                        <td><small>13/02/2026 09:00</small></td>
                        <td><small class="text-muted">90 phut</small></td>
                    </tr>
                    <tr>
                        <td><span class="badge bg-info-subtle text-info"><i class="bi bi-sticky me-1"></i>Ghi chu</span></td>
                        <td class="fw-medium">Cap nhat tinh trang GHI Technology</td>
                        <td><small class="text-muted">OPP-0040</small></td>
                        <td><div class="d-flex align-items-center gap-2"><div class="bg-primary text-white rounded d-flex align-items-center justify-content-center" style="width:24px;height:24px;font-size:10px;">NT</div><small>Nguyen Thanh</small></div></td>
                        <td><small>12/02/2026 16:00</small></td>
                        <td><small class="text-muted">-</small></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>
