<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">
            <c:choose>
                <c:when test="${mode == 'edit'}">Chinh sua Lead</c:when>
                <c:otherwise>Tao Lead moi</c:otherwise>
            </c:choose>
        </h4>
        <p class="text-muted mb-0">
            <c:choose>
                <c:when test="${mode == 'edit'}">Cap nhat thong tin lead ${lead.leadCode}</c:when>
                <c:otherwise>Nhap thong tin khach hang tiem nang moi</c:otherwise>
            </c:choose>
        </p>
    </div>
    <a href="${pageContext.request.contextPath}/sale/lead/list" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left me-1"></i>Quay lai</a>
</div>

<!-- Error Message -->
<c:if test="${not empty error}">
    <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<form method="POST" action="${pageContext.request.contextPath}/sale/lead/form" id="leadForm">
    <c:if test="${mode == 'edit'}">
        <input type="hidden" name="leadId" value="${lead.leadId}">
    </c:if>

    <div class="row g-4">
        <!-- Main Content -->
        <div class="col-lg-8">
            <!-- Thong tin co ban -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-person me-2"></i>Thong tin co ban</h6>
                </div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-medium">Ho ten <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="fullName" name="fullName" placeholder="Nhap ho ten" value="${lead.fullName}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-medium">Email</label>
                            <input type="email" class="form-control" id="email" name="email" placeholder="email@company.com" value="${lead.email}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-medium">So dien thoai</label>
                            <input type="tel" class="form-control" id="phone" name="phone" placeholder="0xxx xxx xxx" value="${lead.phone}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-medium">Cong ty</label>
                            <input type="text" class="form-control" id="companyName" name="companyName" placeholder="Ten cong ty" value="${lead.companyName}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-medium">Chuc danh</label>
                            <input type="text" class="form-control" id="jobTitle" name="jobTitle" placeholder="Vi tri / Chuc danh" value="${lead.jobTitle}">
                        </div>
                    </div>
                </div>
            </div>

            <!-- Thong tin bo sung -->
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-info-circle me-2"></i>Thong tin bo sung</h6>
                </div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label fw-medium">So thich / Quan tam</label>
                            <input type="text" class="form-control" id="interests" name="interests" placeholder="VD: Digital Marketing, Data Science, Leadership" value="${lead.interests}">
                            <div class="form-text">San pham hoac dich vu lead quan tam, cach nhau boi dau phay</div>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-medium">Ghi chu</label>
                            <textarea class="form-control" id="notes" name="notes" rows="4" placeholder="Ghi chu them ve lead...">${lead.notes}</textarea>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sidebar -->
        <div class="col-lg-4">
            <!-- Phan loai -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-tag me-2"></i>Phan loai</h6>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <label class="form-label fw-medium">Trang thai <span class="text-danger">*</span></label>
                        <c:choose>
                            <c:when test="${mode == 'edit'}">
                                <!-- Edit mode: only allow Assigned, Unqualified, Recycled, Nurturing, Delete -->
                                <select class="form-select" id="status" name="status" required>
                                    <option value="Assigned" ${lead.status == 'Assigned' ? 'selected' : ''}>Assigned</option>
                                    <option value="Unqualified" ${lead.status == 'Unqualified' ? 'selected' : ''}>Unqualified</option>
                                    <option value="Recycled" ${lead.status == 'Recycled' ? 'selected' : ''}>Recycled</option>
                                    <option value="Nurturing" ${lead.status == 'Nurturing' ? 'selected' : ''}>Nurturing</option>
                                    <option value="Delete" ${lead.status == 'Delete' ? 'selected' : ''}>Delete (Xoa)</option>
                                </select>
                                <div class="form-text">Chi co the chuyen sang: Unqualified, Recycled, Nurturing hoac Delete</div>
                            </c:when>
                            <c:otherwise>
                                <!-- Create mode: default Assigned, hidden -->
                                <input type="hidden" name="status" value="Assigned">
                                <div class="form-control bg-light"><span class="badge bg-primary">Assigned</span> (Mac dinh)</div>
                                <div class="form-text">Lead moi se tu dong o trang thai Assigned</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-medium">Rating</label>
                        <select class="form-select" id="rating" name="rating">
                            <option value="">-- Chon rating --</option>
                            <c:forEach var="ratingEnum" items="${leadRatings}">
                                <option value="${ratingEnum}" <c:if test="${lead.rating == ratingEnum.toString()}">selected</c:if>>${ratingEnum}</option>
                            </c:forEach>
                            <c:if test="${empty leadRatings}">
                                <option value="Hot">Hot</option>
                                <option value="Warm">Warm</option>
                                <option value="Cold">Cold</option>
                            </c:if>
                        </select>
                        <div class="form-text">Muc do tiem nang cua lead</div>
                    </div>
                </div>
            </div>

            <!-- Nguon -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-diagram-3 me-2"></i>Nguon & Chien dich</h6>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <label class="form-label fw-medium">Nguon Lead</label>
                        <select class="form-select" id="sourceId" name="sourceId">
                            <option value="">-- Chon nguon --</option>
                            <c:forEach var="source" items="${leadSources}">
                                <option value="${source.sourceId}" <c:if test="${lead.sourceId == source.sourceId}">selected</c:if>>${source.sourceName}</option>
                            </c:forEach>
                            <c:if test="${empty leadSources}">
                                <option>Website</option><option>Facebook</option><option>Google Ads</option><option>Gioi thieu</option><option>Hoi thao</option>
                            </c:if>
                        </select>
                        <div class="form-text">Lead den tu dau?</div>
                    </div>
                    <div>
                        <label class="form-label fw-medium">Chien dich</label>
                        <select class="form-select" id="campaignId" name="campaignId">
                            <option value="">-- Chon chien dich --</option>
                            <c:forEach var="campaign" items="${campaigns}">
                                <option value="${campaign.campaignId}" <c:if test="${lead.campaignId == campaign.campaignId}">selected</c:if>>${campaign.campaignName}</option>
                            </c:forEach>
                            <c:if test="${empty campaigns}">
                                <option>Facebook Ads T2/2026</option><option>Google Ads Q1</option><option>Email Marketing</option>
                            </c:if>
                        </select>
                        <div class="form-text">Chien dich marketing lien quan</div>
                    </div>
                </div>
            </div>

            <!-- Action buttons -->
            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary"><i class="bi bi-check-lg me-1"></i>
                    <c:choose>
                        <c:when test="${mode == 'edit'}">Cap nhat Lead</c:when>
                        <c:otherwise>Tao Lead</c:otherwise>
                    </c:choose>
                </button>
                <a href="${pageContext.request.contextPath}/sale/lead/list" class="btn btn-outline-secondary">Huy</a>
            </div>
        </div>
    </div>
</form>

<script>
document.getElementById('leadForm').addEventListener('submit', function(e) {
    const fullName = document.getElementById('fullName').value.trim();
    const status = document.getElementById('status').value;
    if (!fullName) { e.preventDefault(); alert('Ho ten la bat buoc!'); document.getElementById('fullName').focus(); return; }
    if (!status) { e.preventDefault(); alert('Vui long chon trang thai!'); document.getElementById('status').focus(); return; }
    const btn = this.querySelector('button[type="submit"]');
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>Dang luu...';
});
</script>
