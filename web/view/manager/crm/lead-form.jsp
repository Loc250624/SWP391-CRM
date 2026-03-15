<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">Tao Lead moi</h4>
        <p class="text-muted mb-0">Nhap thong tin khach hang tiem nang moi</p>
    </div>
    <a href="${pageContext.request.contextPath}/manager/crm/leads" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left me-1"></i>Quay lai</a>
</div>

<!-- Toast Messages -->
<c:if test="${not empty error}">
    <script>document.addEventListener('DOMContentLoaded', function(){ CRM.showToast('${error}', 'error'); });</script>
</c:if>

<form method="POST" action="${pageContext.request.contextPath}/manager/crm/lead-form" id="leadForm" novalidate>

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
                            <label class="form-label fw-medium" for="fullName">Ho ten <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="fullName" name="fullName"
                                   placeholder="Nhap ho ten" value="${lead.fullName}"
                                   maxlength="150" required>
                            <div class="form-text">Toi da 150 ky tu</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-medium" for="email">Email</label>
                            <input type="email" class="form-control" id="email" name="email"
                                   placeholder="email@company.com" value="${lead.email}"
                                   maxlength="255">
                            <div class="form-text">VD: ten@congty.com</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-medium" for="phone">So dien thoai</label>
                            <input type="tel" class="form-control" id="phone" name="phone"
                                   placeholder="0xxx xxx xxx" value="${lead.phone}"
                                   maxlength="20">
                            <div class="form-text">7-20 ky tu, chi gom so va +, -, (, )</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-medium" for="companyName">Cong ty</label>
                            <input type="text" class="form-control" id="companyName" name="companyName"
                                   placeholder="Ten cong ty" value="${lead.companyName}"
                                   maxlength="255">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-medium" for="jobTitle">Chuc danh</label>
                            <input type="text" class="form-control" id="jobTitle" name="jobTitle"
                                   placeholder="Vi tri / Chuc danh" value="${lead.jobTitle}"
                                   maxlength="150">
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
                            <label class="form-label fw-medium" for="interests">So thich / Quan tam</label>
                            <input type="text" class="form-control" id="interests" name="interests"
                                   placeholder="VD: Digital Marketing, Data Science, Leadership"
                                   value="${lead.interests}" maxlength="500">
                            <div class="form-text">San pham hoac dich vu lead quan tam, cach nhau boi dau phay (toi da 500 ky tu)</div>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-medium" for="notes">Ghi chu</label>
                            <textarea class="form-control" id="notes" name="notes" rows="4"
                                      placeholder="Ghi chu them ve lead..."
                                      maxlength="2000">${lead.notes}</textarea>
                            <div class="form-text">Toi da 2000 ky tu</div>
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
                        <label class="form-label fw-medium">Trang thai</label>
                        <input type="hidden" name="status" value="New">
                        <div class="form-control bg-light"><span class="badge bg-secondary">New</span> (Mac dinh)</div>
                        <div class="form-text">Lead moi se o trang thai New, chua duoc giao viec</div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-medium" for="rating">Rating</label>
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
                    <div class="mb-3">
                        <label class="form-label fw-medium" for="leadScore">Diem (Score)</label>
                        <input type="number" class="form-control" id="leadScore" name="leadScore"
                               placeholder="0" value="${lead.leadScore != null ? lead.leadScore : 0}"
                               min="0" max="100">
                        <div class="form-text">Diem danh gia lead (0 - 100)</div>
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
                        <label class="form-label fw-medium" for="sourceId">Nguon Lead</label>
                        <select class="form-select" id="sourceId" name="sourceId">
                            <option value="">-- Chon nguon --</option>
                            <c:forEach var="source" items="${leadSources}">
                                <option value="${source.sourceId}" <c:if test="${lead.sourceId == source.sourceId}">selected</c:if>>${source.sourceName}</option>
                            </c:forEach>
                        </select>
                        <div class="form-text">Lead den tu dau?</div>
                    </div>
                    <div>
                        <label class="form-label fw-medium" for="campaignId">Chien dich</label>
                        <select class="form-select" id="campaignId" name="campaignId">
                            <option value="">-- Chon chien dich --</option>
                            <c:forEach var="campaign" items="${campaigns}">
                                <option value="${campaign.campaignId}" <c:if test="${lead.campaignId == campaign.campaignId}">selected</c:if>>${campaign.campaignName}</option>
                            </c:forEach>
                        </select>
                        <div class="form-text">Chien dich marketing lien quan</div>
                    </div>
                </div>
            </div>

            <!-- Action buttons -->
            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary" id="submitBtn"><i class="bi bi-check-lg me-1"></i>Tao Lead</button>
                <a href="${pageContext.request.contextPath}/manager/crm/leads" class="btn btn-outline-secondary">Huy</a>
            </div>
        </div>
    </div>
</form>

<script>
    document.getElementById('leadForm').addEventListener('submit', function (e) {
        var errors = [];
        var fullName = document.getElementById('fullName').value.trim();
        var email = document.getElementById('email').value.trim();
        var phone = document.getElementById('phone').value.trim();
        var companyName = document.getElementById('companyName').value.trim();
        var jobTitle = document.getElementById('jobTitle').value.trim();
        var interests = document.getElementById('interests').value.trim();
        var notes = document.getElementById('notes').value.trim();

        if (!fullName) {
            errors.push('Ho ten la bat buoc!');
        } else if (fullName.length > 150) {
            errors.push('Ho ten khong duoc vuot qua 150 ky tu!');
        }

        if (email) {
            var emailRegex = /^[\w.%+-]+@[\w.-]+\.[a-zA-Z]{2,}$/;
            if (!emailRegex.test(email)) {
                errors.push('Email khong hop le!');
            } else if (email.length > 255) {
                errors.push('Email khong duoc vuot qua 255 ky tu!');
            }
        }

        if (phone) {
            var phoneRegex = /^[0-9+\-() ]{7,20}$/;
            if (!phoneRegex.test(phone)) {
                errors.push('So dien thoai khong hop le (7-20 ky tu, chi gom so va +, -, (, ))!');
            }
        }

        if (companyName && companyName.length > 255) {
            errors.push('Ten cong ty khong duoc vuot qua 255 ky tu!');
        }
        if (jobTitle && jobTitle.length > 150) {
            errors.push('Chuc danh khong duoc vuot qua 150 ky tu!');
        }
        if (interests && interests.length > 500) {
            errors.push('So thich khong duoc vuot qua 500 ky tu!');
        }
        if (notes && notes.length > 2000) {
            errors.push('Ghi chu khong duoc vuot qua 2000 ky tu!');
        }

        var leadScore = parseInt(document.getElementById('leadScore').value) || 0;
        if (leadScore < 0 || leadScore > 100) {
            errors.push('Diem (Score) phai tu 0 den 100!');
        }

        if (errors.length > 0) {
            e.preventDefault();
            errors.forEach(function(err){ CRM.showToast(err, 'error'); });
            return;
        }

        var btn = document.getElementById('submitBtn');
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>Dang luu...';
    });
</script>
