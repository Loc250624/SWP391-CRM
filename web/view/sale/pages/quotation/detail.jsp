<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">Chi tiet Bao gia</h4>
        <p class="text-muted mb-0">QT-2026-0156 - Bao gia goi ERP Premium</p>
    </div>
    <div class="d-flex gap-2">
        <button class="btn btn-outline-secondary btn-sm"><i class="bi bi-printer me-1"></i>In PDF</button>
        <button class="btn btn-outline-primary btn-sm"><i class="bi bi-send me-1"></i>Gui lai</button>
        <a href="${pageContext.request.contextPath}/sale/quotation/form?id=156" class="btn btn-primary btn-sm"><i class="bi bi-pencil me-1"></i>Chinh sua</a>
    </div>
</div>

<div class="row g-4">
    <div class="col-lg-8">
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-6"><label class="text-muted small">Ma bao gia</label><div class="fw-medium">QT-2026-0156</div></div>
                    <div class="col-md-6"><label class="text-muted small">Phien ban</label><div class="fw-medium">v2</div></div>
                    <div class="col-md-6"><label class="text-muted small">Opportunity</label><div class="fw-medium">OPP-0025 - Hop dong ERP Enterprise</div></div>
                    <div class="col-md-6"><label class="text-muted small">Khach hang</label><div class="fw-medium">ABC Corporation</div></div>
                    <div class="col-md-6"><label class="text-muted small">Ngay tao</label><div>12/02/2026</div></div>
                    <div class="col-md-6"><label class="text-muted small">Hieu luc den</label><div>28/02/2026</div></div>
                </div>
            </div>
        </div>

        <!-- Items -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Hang muc</h6></div>
            <div class="card-body pt-0">
                <div class="table-responsive">
                    <table class="table align-middle mb-0">
                        <thead class="table-light"><tr><th>Khoa hoc / Dich vu</th><th class="text-center">SL</th><th class="text-end">Don gia</th><th class="text-end">Giam gia</th><th class="text-end">Thanh tien</th></tr></thead>
                        <tbody>
                            <tr><td>ERP Enterprise License</td><td class="text-center">1</td><td class="text-end">800,000,000 d</td><td class="text-end">-</td><td class="text-end fw-semibold">800,000,000 d</td></tr>
                            <tr><td>Dao tao su dung (20 nguoi)</td><td class="text-center">1</td><td class="text-end">350,000,000 d</td><td class="text-end">10%</td><td class="text-end fw-semibold">315,000,000 d</td></tr>
                            <tr><td>Ho tro ky thuat 12 thang</td><td class="text-center">1</td><td class="text-end">200,000,000 d</td><td class="text-end">-</td><td class="text-end fw-semibold">200,000,000 d</td></tr>
                        </tbody>
                        <tfoot class="table-light">
                            <tr><td colspan="4" class="text-end">Tong phu:</td><td class="text-end fw-semibold">1,315,000,000 d</td></tr>
                            <tr><td colspan="4" class="text-end">Giam gia:</td><td class="text-end text-danger">-35,000,000 d</td></tr>
                            <tr><td colspan="4" class="text-end">Thue (10%):</td><td class="text-end">128,000,000 d</td></tr>
                            <tr><td colspan="4" class="text-end fw-bold">Tong cong:</td><td class="text-end fw-bold text-success fs-5">1,450,000,000 d</td></tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>

        <!-- Terms -->
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Dieu khoan thanh toan</h6></div>
            <div class="card-body"><p class="text-muted mb-0">Thanh toan 50% khi ky hop dong. 50% con lai thanh toan sau khi hoan thanh trien khai va dao tao.</p></div>
        </div>
    </div>

    <div class="col-lg-4">
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Trang thai</h6></div>
            <div class="card-body">
                <div class="mb-3"><span class="badge bg-warning-subtle text-warning fs-6 px-3 py-2">Da gui - Cho phan hoi</span></div>
                <div class="mb-3"><label class="text-muted small">Gui ngay</label><div>12/02/2026 10:00</div></div>
                <div class="mb-3"><label class="text-muted small">Nguoi gui</label><div class="fw-medium">Le Mai</div></div>
                <div class="mb-3"><label class="text-muted small">Lan xem cuoi</label><div>13/02/2026 16:30</div></div>
                <div><label class="text-muted small">So lan xem</label><div class="fw-bold">3 lan</div></div>
            </div>
        </div>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Lich su phien ban</h6></div>
            <div class="card-body">
                <div class="d-flex flex-column gap-2">
                    <div class="d-flex justify-content-between align-items-center p-2 bg-primary-subtle rounded">
                        <div><div class="fw-medium">v2 (Hien tai)</div><small class="text-muted">12/02/2026</small></div>
                        <span class="fw-semibold">1,450,000,000 d</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center p-2 bg-light rounded">
                        <div><div class="fw-medium">v1</div><small class="text-muted">05/02/2026</small></div>
                        <span class="fw-semibold text-muted">1,350,000,000 d</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
