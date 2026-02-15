<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

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
        <i class="bi bi-exclamation-triangle-fill me-2"></i><span>${error}</span>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<form method="POST" action="${pageContext.request.contextPath}/sale/lead/form" id="leadForm" novalidate>
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
                        <c:choose>
                            <c:when test="${mode == 'edit'}">
                                <!-- Edit mode: status is read-only, displayed as badge -->
                                <div class="form-control bg-light">
                                    <c:choose>
                                        <c:when test="${lead.status == 'Assigned'}"><span class="badge bg-primary">Assigned</span></c:when>
                                        <c:when test="${lead.status == 'Working'}"><span class="badge bg-info">Working</span></c:when>
                                        <c:when test="${lead.status == 'Nurturing'}"><span class="badge bg-warning text-dark">Nurturing</span></c:when>
                                        <c:when test="${lead.status == 'Unqualified'}"><span class="badge bg-secondary">Unqualified</span></c:when>
                                        <c:when test="${lead.status == 'Converted'}"><span class="badge bg-success">Converted</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary">${lead.status}</span></c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="form-text">Trang thai khong the thay doi truc tiep</div>
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
                <button type="submit" class="btn btn-primary" id="submitBtn"><i class="bi bi-check-lg me-1"></i>
                    <c:choose>
                        <c:when test="${mode == 'edit'}">Cap nhat Lead</c:when>
                        <c:otherwise>Tao Lead</c:otherwise>
                    </c:choose>
                </button>
                <c:if test="${mode == 'edit'}">
                    <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#inactiveModal">
                        <i class="bi bi-x-circle me-1"></i>Vo hieu hoa Lead
                    </button>
                </c:if>
                <a href="${pageContext.request.contextPath}/sale/lead/list" class="btn btn-outline-secondary">Huy</a>
            </div>
        </div>
    </div>
</form>

<!-- Inactive Confirmation Modal (edit mode only) -->
<c:if test="${mode == 'edit'}">
<div class="modal fade" id="inactiveModal" tabindex="-1" aria-labelledby="inactiveModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="inactiveModalLabel"><i class="bi bi-exclamation-triangle me-2"></i>Xac nhan vo hieu hoa Lead</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="alert alert-warning d-flex align-items-start mb-3">
                    <i class="bi bi-exclamation-triangle-fill me-2 mt-1"></i>
                    <div>
                        <strong>Canh bao:</strong> Vo hieu hoa lead <strong>"${lead.fullName}"</strong> (${lead.leadCode}) se:
                        <ul class="mb-0 mt-1">
                            <li>Chuyen lead sang trang thai <strong>Inactive</strong></li>
                            <li>Dong (Cancelled) <strong>tat ca Opportunity</strong> lien quan</li>
                            <li>Cac Opportunity bi dong se <strong>chi co the xem</strong>, khong the chinh sua</li>
                        </ul>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${not empty leadOpportunities}">
                        <h6 class="fw-semibold mb-2">Cac Opportunity se bi dong:</h6>
                        <div class="table-responsive">
                            <table class="table table-sm table-bordered mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Ma OPP</th>
                                        <th>Ten Opportunity</th>
                                        <th>Trang thai</th>
                                        <th>Gia tri</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="opp" items="${leadOpportunities}">
                                        <tr>
                                            <td><span class="fw-semibold text-primary">${opp.opportunityCode}</span></td>
                                            <td>${opp.opportunityName}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${opp.status == 'Open'}"><span class="badge bg-primary-subtle text-primary">Open</span></c:when>
                                                    <c:when test="${opp.status == 'InProgress'}"><span class="badge bg-info-subtle text-info">In Progress</span></c:when>
                                                    <c:when test="${opp.status == 'Won'}"><span class="badge bg-success">Won</span></c:when>
                                                    <c:when test="${opp.status == 'Lost'}"><span class="badge bg-danger">Lost</span></c:when>
                                                    <c:when test="${opp.status == 'OnHold'}"><span class="badge bg-warning-subtle text-warning">On Hold</span></c:when>
                                                    <c:when test="${opp.status == 'Cancelled'}"><span class="badge bg-secondary">Cancelled</span></c:when>
                                                    <c:otherwise><span class="badge bg-secondary">${opp.status}</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${opp.estimatedValue != null}">
                                                        <fmt:formatNumber value="${opp.estimatedValue}" type="number" groupingUsed="true"/> VND
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted mb-0"><i class="bi bi-info-circle me-1"></i>Lead nay khong co Opportunity nao.</p>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Huy</button>
                <form method="POST" action="${pageContext.request.contextPath}/sale/lead/form" class="d-inline">
                    <input type="hidden" name="action" value="inactive">
                    <input type="hidden" name="leadId" value="${lead.leadId}">
                    <button type="submit" class="btn btn-danger"><i class="bi bi-x-circle me-1"></i>Xac nhan vo hieu hoa</button>
                </form>
            </div>
        </div>
    </div>
</div>
</c:if>

<script>
document.getElementById('leadForm').addEventListener('submit', function(e) {
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

    if (errors.length > 0) {
        e.preventDefault();
        alert(errors.join('\n'));
        return;
    }

    var btn = document.getElementById('submitBtn');
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>Dang luu...';
});
</script>
