<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">
            <c:choose>
                <c:when test="${mode == 'edit'}">Chỉnh sửa Lead</c:when>
                <c:otherwise>Tạo Lead mới</c:otherwise>
            </c:choose>
        </h4>
        <p class="text-muted mb-0">
            <c:choose>
                <c:when test="${mode == 'edit'}">Cập nhật thông tin lead ${lead.leadCode}</c:when>
                <c:otherwise>Nhập thông tin khách hàng tiềm năng mới</c:otherwise>
            </c:choose>
        </p>
    </div>
    <a href="${pageContext.request.contextPath}/sale/lead/list" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left me-1"></i>Quay lại</a>
</div>

<!-- Toast Messages -->
<c:if test="${not empty error}">
    <script>document.addEventListener('DOMContentLoaded', function(){ CRM.showToast('${error}', 'error'); });</script>
</c:if>

<form method="POST" action="${pageContext.request.contextPath}/sale/lead/form" id="leadForm" novalidate>
    <c:if test="${mode == 'edit'}">
        <input type="hidden" name="leadId" value="${lead.leadId}">
    </c:if>

    <div class="row g-4">
        <!-- Main Content -->
        <div class="col-lg-8">
            <!-- Thông tin cơ bản -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-person me-2"></i>Thông tin cơ bản</h6>
                </div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-medium" for="fullName">Họ tên <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="fullName" name="fullName"
                                   placeholder="Nhập họ tên" value="${lead.fullName}"
                                   maxlength="150" required>
                            <div class="form-text">Tối đa 150 ký tự</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-medium" for="email">Email</label>
                            <input type="email" class="form-control" id="email" name="email"
                                   placeholder="email@company.com" value="${lead.email}"
                                   maxlength="255">
                            <div class="form-text">VD: ten@congty.com</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-medium" for="phone">Số điện thoại</label>
                            <input type="tel" class="form-control" id="phone" name="phone"
                                   placeholder="0xxx xxx xxx" value="${lead.phone}"
                                   maxlength="20">
                            <div class="form-text">7-20 ký tự, chỉ gồm số và +, -, (, )</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-medium" for="companyName">Công ty</label>
                            <input type="text" class="form-control" id="companyName" name="companyName"
                                   placeholder="Tên công ty" value="${lead.companyName}"
                                   maxlength="255">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-medium" for="jobTitle">Chức danh</label>
                            <input type="text" class="form-control" id="jobTitle" name="jobTitle"
                                   placeholder="Vị trí / Chức danh" value="${lead.jobTitle}"
                                   maxlength="150">
                        </div>
                    </div>
                </div>
            </div>

            <!-- Thông tin bổ sung -->
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-info-circle me-2"></i>Thông tin bổ sung</h6>
                </div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label fw-medium" for="interests">Sở thích / Quan tâm</label>
                            <input type="text" class="form-control" id="interests" name="interests"
                                   placeholder="VD: Digital Marketing, Data Science, Leadership"
                                   value="${lead.interests}" maxlength="500">
                            <div class="form-text">Sản phẩm hoặc dịch vụ lead quan tâm, cách nhau bởi dấu phẩy (tối đa 500 ký tự)</div>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-medium" for="notes">Ghi chú</label>
                            <textarea class="form-control" id="notes" name="notes" rows="4"
                                      placeholder="Ghi chú thêm về lead..."
                                      maxlength="2000">${lead.notes}</textarea>
                            <div class="form-text">Tối đa 2000 ký tự</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sidebar -->
        <div class="col-lg-4">
            <!-- Phân loại -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-tag me-2"></i>Phân loại</h6>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <label class="form-label fw-medium">Trạng thái</label>
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
                                <div class="form-text">Trạng thái không thể thay đổi trực tiếp</div>
                            </c:when>
                            <c:otherwise>
                                <!-- Create mode: default Assigned, hidden -->
                                <input type="hidden" name="status" value="Assigned">
                                <div class="form-control bg-light"><span class="badge bg-primary">Assigned</span> (Mặc định)</div>
                                <div class="form-text">Lead mới sẽ tự động ở trạng thái Assigned</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-medium" for="rating">Rating</label>
                        <select class="form-select" id="rating" name="rating">
                            <option value="">-- Chọn rating --</option>
                            <c:forEach var="ratingEnum" items="${leadRatings}">
                                <option value="${ratingEnum}" <c:if test="${lead.rating == ratingEnum.toString()}">selected</c:if>>${ratingEnum}</option>
                            </c:forEach>
                            <c:if test="${empty leadRatings}">
                                <option value="Hot">Hot</option>
                                <option value="Warm">Warm</option>
                                <option value="Cold">Cold</option>
                            </c:if>
                        </select>
                        <div class="form-text">Mức độ tiềm năng của lead</div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-medium" for="leadScore">Điểm (Score)</label>
                        <input type="number" class="form-control" id="leadScore" name="leadScore"
                               placeholder="0" value="${lead.leadScore != null ? lead.leadScore : 0}"
                               min="0" max="100">
                        <div class="form-text">Điểm đánh giá lead (0 - 100)</div>
                    </div>
                </div>
            </div>

            <!-- Nguồn -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-diagram-3 me-2"></i>Nguồn & Chiến dịch</h6>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <label class="form-label fw-medium" for="sourceId">Nguồn Lead</label>
                        <select class="form-select" id="sourceId" name="sourceId">
                            <option value="">-- Chọn nguồn --</option>
                            <c:forEach var="source" items="${leadSources}">
                                <option value="${source.sourceId}" <c:if test="${lead.sourceId == source.sourceId}">selected</c:if>>${source.sourceName}</option>
                            </c:forEach>
                        </select>
                        <div class="form-text">Lead đến từ đâu?</div>
                    </div>
                    <div>
                        <label class="form-label fw-medium" for="campaignId">Chiến dịch</label>
                        <select class="form-select" id="campaignId" name="campaignId">
                            <option value="">-- Chọn chiến dịch --</option>
                            <c:forEach var="campaign" items="${campaigns}">
                                <option value="${campaign.campaignId}" <c:if test="${lead.campaignId == campaign.campaignId}">selected</c:if>>${campaign.campaignName}</option>
                            </c:forEach>
                        </select>
                        <div class="form-text">Chiến dịch marketing liên quan</div>
                    </div>
                </div>
            </div>

            <!-- Action buttons -->
            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary" id="submitBtn"><i class="bi bi-check-lg me-1"></i>
                    <c:choose>
                        <c:when test="${mode == 'edit'}">Cập nhật Lead</c:when>
                        <c:otherwise>Tạo Lead</c:otherwise>
                    </c:choose>
                </button>
                <c:if test="${mode == 'edit' && lead.status != 'Inactive'}">
                    <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#inactiveModal">
                        <i class="bi bi-x-circle me-1"></i>Vô hiệu hóa Lead
                    </button>
                </c:if>
                <a href="${pageContext.request.contextPath}/sale/lead/list" class="btn btn-outline-secondary">Hủy</a>
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
                    <h5 class="modal-title" id="inactiveModalLabel"><i class="bi bi-exclamation-triangle me-2"></i>Xác nhận vô hiệu hóa Lead</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-warning d-flex align-items-start mb-3">
                        <i class="bi bi-exclamation-triangle-fill me-2 mt-1"></i>
                        <div>
                            <strong>Cảnh báo:</strong> Vô hiệu hóa lead <strong>"${lead.fullName}"</strong> (${lead.leadCode}) sẽ:
                            <ul class="mb-0 mt-1">
                                <li>Chuyển lead sang trạng thái <strong>Inactive</strong></li>
                                <li>Đóng (Cancelled) <strong>tất cả Opportunity</strong> liên quan</li>
                                <li>Các Opportunity bị đóng sẽ <strong>chỉ có thể xem</strong>, không thể chỉnh sửa</li>
                            </ul>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${not empty leadOpportunities}">
                            <h6 class="fw-semibold mb-2">Các Opportunity sẽ bị đóng:</h6>
                            <div class="table-responsive">
                                <table class="table table-sm table-bordered mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Mã OPP</th>
                                            <th>Tên Opportunity</th>
                                            <th>Trạng thái</th>
                                            <th>Giá trị</th>
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
                            <p class="text-muted mb-0"><i class="bi bi-info-circle me-1"></i>Lead này không có Opportunity nào.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <form method="POST" action="${pageContext.request.contextPath}/sale/lead/form" class="d-inline">
                        <input type="hidden" name="action" value="inactive">
                        <input type="hidden" name="leadId" value="${lead.leadId}">
                        <button type="submit" class="btn btn-danger"><i class="bi bi-x-circle me-1"></i>Xác nhận vô hiệu hóa</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</c:if>

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
            errors.push('Họ tên là bắt buộc!');
        } else if (fullName.length > 150) {
            errors.push('Họ tên không được vượt quá 150 ký tự!');
        }

        if (email) {
            var emailRegex = /^[\w.%+-]+@[\w.-]+\.[a-zA-Z]{2,}$/;
            if (!emailRegex.test(email)) {
                errors.push('Email không hợp lệ!');
            } else if (email.length > 255) {
                errors.push('Email không được vượt quá 255 ký tự!');
            }
        }

        if (phone) {
            var phoneRegex = /^[0-9+\-() ]{7,20}$/;
            if (!phoneRegex.test(phone)) {
                errors.push('Số điện thoại không hợp lệ (7-20 ký tự, chỉ gồm số và +, -, (, ))!');
            }
        }

        if (companyName && companyName.length > 255) {
            errors.push('Tên công ty không được vượt quá 255 ký tự!');
        }
        if (jobTitle && jobTitle.length > 150) {
            errors.push('Chức danh không được vượt quá 150 ký tự!');
        }
        if (interests && interests.length > 500) {
            errors.push('Sở thích không được vượt quá 500 ký tự!');
        }
        if (notes && notes.length > 2000) {
            errors.push('Ghi chú không được vượt quá 2000 ký tự!');
        }

        var leadScore = parseInt(document.getElementById('leadScore').value) || 0;
        if (leadScore < 0 || leadScore > 100) {
            errors.push('Điểm (Score) phải từ 0 đến 100!');
        }

        if (errors.length > 0) {
            e.preventDefault();
            errors.forEach(function(err){ CRM.showToast(err, 'error'); });
            return;
        }

        var btn = document.getElementById('submitBtn');
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>Đang lưu...';
    });
</script>
