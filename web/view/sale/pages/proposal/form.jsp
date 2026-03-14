<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div><h4 class="mb-1 fw-bold">Tao Proposal moi</h4><p class="text-muted mb-0">Tao de xuat thuong mai cho khach hang</p></div>
</div>

<form>
    <div class="row g-4">
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold"><i class="bi bi-info-circle me-2"></i>Thong tin Proposal</h6></div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-12"><label class="form-label">Tieu de <span class="text-danger">*</span></label><input type="text" class="form-control" placeholder="VD: De xuat giai phap dao tao..."></div>
                        <div class="col-md-6"><label class="form-label">Opportunity</label><select class="form-select"><option selected disabled>Chon opportunity...</option><option>OPP-0025 - Hop dong ERP</option><option>OPP-0030 - Giai phap XYZ</option></select></div>
                        <div class="col-md-6"><label class="form-label">Khach hang</label><select class="form-select"><option selected disabled>Chon khach hang...</option><option>ABC Corporation</option><option>XYZ Limited</option></select></div>
                        <div class="col-12"><label class="form-label">Tom tat</label><textarea class="form-control" rows="3" placeholder="Tom tat noi dung proposal..."></textarea></div>
                    </div>
                </div>
            </div>
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold"><i class="bi bi-file-text me-2"></i>Noi dung chinh</h6></div>
                <div class="card-body">
                    <div class="mb-3"><label class="form-label">Van de khach hang</label><textarea class="form-control" rows="3" placeholder="Mo ta van de khach hang dang gap..."></textarea></div>
                    <div class="mb-3"><label class="form-label">Giai phap de xuat</label><textarea class="form-control" rows="4" placeholder="Mo ta giai phap ban de xuat..."></textarea></div>
                    <div><label class="form-label">Loi ich mang lai</label><textarea class="form-control" rows="3" placeholder="Liet ke cac loi ich chinh..."></textarea></div>
                </div>
            </div>
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-transparent border-0 d-flex justify-content-between"><h6 class="mb-0 fw-semibold"><i class="bi bi-paperclip me-2"></i>File dinh kem</h6><button type="button" class="btn btn-sm btn-outline-primary"><i class="bi bi-upload me-1"></i>Tai len</button></div>
                <div class="card-body text-center py-4 text-muted"><i class="bi bi-cloud-upload fs-1 d-block mb-2"></i><p>Keo tha hoac nhan de tai file len</p></div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="card border-0 shadow-sm"><div class="card-body">
                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-primary"><i class="bi bi-save me-1"></i>Luu Proposal</button>
                    <button type="button" class="btn btn-outline-primary"><i class="bi bi-send me-1"></i>Luu & Gui duyet</button>
                    <a href="${pageContext.request.contextPath}/sale/proposal/list" class="btn btn-outline-secondary">Huy</a>
                </div>
            </div></div>
        </div>
    </div>
</form>
