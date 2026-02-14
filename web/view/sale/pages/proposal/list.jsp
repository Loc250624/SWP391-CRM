<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div><h4 class="mb-1 fw-bold">Danh sach Proposal</h4><p class="text-muted mb-0">Quan ly cac de xuat thuong mai</p></div>
    <a href="${pageContext.request.contextPath}/sale/proposal/form" class="btn btn-primary btn-sm"><i class="bi bi-plus-lg me-1"></i>Tao Proposal</a>
</div>

<div class="row g-3 mb-4">
    <div class="col-md-4"><div class="card border-0 shadow-sm"><div class="card-body py-3 text-center"><div class="fs-3 fw-bold text-primary">12</div><small class="text-muted">Tong Proposal</small></div></div></div>
    <div class="col-md-4"><div class="card border-0 shadow-sm"><div class="card-body py-3 text-center"><div class="fs-3 fw-bold text-warning">5</div><small class="text-muted">Dang cho duyet</small></div></div></div>
    <div class="col-md-4"><div class="card border-0 shadow-sm"><div class="card-body py-3 text-center"><div class="fs-3 fw-bold text-success">7</div><small class="text-muted">Da gui</small></div></div></div>
</div>

<div class="card border-0 shadow-sm">
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light"><tr><th>Ma</th><th>Tieu de</th><th>Khach hang</th><th>Opportunity</th><th>Trang thai</th><th>Ngay tao</th><th></th></tr></thead>
                <tbody>
                    <tr>
                        <td class="fw-medium">PROP-001</td><td>De xuat giai phap ERP toan dien</td><td>ABC Corporation</td>
                        <td><small class="text-muted">OPP-0025</small></td>
                        <td><span class="badge bg-success-subtle text-success">Da gui</span></td>
                        <td><small class="text-muted">12/02/2026</small></td>
                        <td><button class="btn btn-sm btn-light"><i class="bi bi-three-dots-vertical"></i></button></td>
                    </tr>
                    <tr>
                        <td class="fw-medium">PROP-002</td><td>De xuat chuong trinh dao tao AI/ML</td><td>XYZ Limited</td>
                        <td><small class="text-muted">OPP-0030</small></td>
                        <td><span class="badge bg-warning-subtle text-warning">Cho duyet</span></td>
                        <td><small class="text-muted">10/02/2026</small></td>
                        <td><button class="btn btn-sm btn-light"><i class="bi bi-three-dots-vertical"></i></button></td>
                    </tr>
                    <tr>
                        <td class="fw-medium">PROP-003</td><td>De xuat he thong E-Learning</td><td>DEF Group</td>
                        <td><small class="text-muted">OPP-0035</small></td>
                        <td><span class="badge bg-secondary-subtle text-secondary">Nhap</span></td>
                        <td><small class="text-muted">08/02/2026</small></td>
                        <td><button class="btn btn-sm btn-light"><i class="bi bi-three-dots-vertical"></i></button></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>
