<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">${pageTitle}</h4>
        <p class="text-muted mb-0">
            <c:choose>
                <c:when test="${not empty quotation}">
                    <strong>${quotation.quotationCode}</strong> -
                    <c:choose>
                        <c:when test="${quotation.status == 'Draft'}"><span class="badge bg-secondary">De xuat (Draft)</span> - Can Manager duyet</c:when>
                        <c:when test="${quotation.status == 'Approved'}"><span class="badge bg-success">Da duyet</span> - San sang gui cho khach</c:when>
                        <c:when test="${quotation.status == 'Sent'}"><span class="badge bg-warning text-dark">Bao gia (Da gui)</span></c:when>
                        <c:when test="${quotation.status == 'Accepted'}"><span class="badge bg-primary">Khach chap nhan</span></c:when>
                        <c:when test="${quotation.status == 'Rejected'}"><span class="badge bg-danger">Bi tu choi</span></c:when>
                        <c:otherwise><span class="badge bg-secondary">${quotation.status}</span></c:otherwise>
                    </c:choose>
                </c:when>
                <c:otherwise>De xuat se o trang thai Draft. Can Manager duyet truoc khi gui cho khach hang.</c:otherwise>
            </c:choose>
        </p>
    </div>
    <a href="${pageContext.request.contextPath}/sale/quotation/list" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left me-1"></i>Quay lai</a>
</div>

<c:if test="${not empty error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-triangle me-1"></i>${error}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<form method="POST" action="${pageContext.request.contextPath}/sale/quotation/form" id="quotationForm">
    <c:if test="${not empty quotation}">
        <input type="hidden" name="quotationId" value="${quotation.quotationId}" />
    </c:if>

    <c:set var="isDraft" value="${empty quotation || quotation.status == 'Draft'}" />
    <c:set var="readonly" value="${not isDraft}" />

    <div class="row g-4">
        <div class="col-lg-8">
            <!-- Lead / Customer Selection -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-person-lines-fill me-2"></i>Lead / Customer <c:if test="${isDraft}"><span class="text-danger">*</span></c:if></h6>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty quotation && !isDraft}">
                            <!-- Read-only display for non-draft -->
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label small text-muted">Lead</label>
                                    <c:choose>
                                        <c:when test="${not empty linkedLead}">
                                            <div class="form-control form-control-sm bg-light">
                                                <i class="bi bi-person me-1 text-primary"></i>${linkedLead.fullName}
                                                <small class="text-muted">(${linkedLead.leadCode})</small>
                                            </div>
                                        </c:when>
                                        <c:otherwise><div class="form-control form-control-sm bg-light text-muted">-- Khong co --</div></c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small text-muted">Customer</label>
                                    <c:choose>
                                        <c:when test="${not empty linkedCustomer}">
                                            <div class="form-control form-control-sm bg-light">
                                                <i class="bi bi-building me-1 text-success"></i>${linkedCustomer.fullName}
                                            </div>
                                        </c:when>
                                        <c:otherwise><div class="form-control form-control-sm bg-light text-muted">-- Khong co --</div></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Editable: radio toggle lead/customer -->
                            <div class="row g-3">
                                <div class="col-12">
                                    <div class="btn-group btn-group-sm w-100 mb-3" role="group">
                                        <c:set var="leadChecked" value="checked"/>
                                        <c:set var="custChecked" value=""/>
                                        <c:if test="${not empty quotation && not empty quotation.customerId && empty quotation.leadId}">
                                            <c:set var="leadChecked" value=""/>
                                            <c:set var="custChecked" value="checked"/>
                                        </c:if>
                                        <c:if test="${not empty selectedOpp && not empty selectedOpp.customerId && empty selectedOpp.leadId}">
                                            <c:set var="leadChecked" value=""/>
                                            <c:set var="custChecked" value="checked"/>
                                        </c:if>
                                        <input type="radio" class="btn-check" name="contactType" id="typeFromLead" value="lead" autocomplete="off" ${leadChecked}>
                                        <label class="btn btn-outline-primary" for="typeFromLead"><i class="bi bi-person me-1"></i>Tu Lead</label>
                                        <input type="radio" class="btn-check" name="contactType" id="typeFromCustomer" value="customer" autocomplete="off" ${custChecked}>
                                        <label class="btn btn-outline-success" for="typeFromCustomer"><i class="bi bi-building me-1"></i>Tu Customer</label>
                                    </div>
                                </div>
                                <!-- Lead selector -->
                                <div class="col-12" id="leadSelectDiv">
                                    <label class="form-label small">Chon Lead <span class="text-danger">*</span></label>
                                    <select name="leadId" class="form-select form-select-sm" id="leadSelect">
                                        <option value="">-- Chon lead --</option>
                                        <c:forEach var="ld" items="${leads}">
                                            <option value="${ld.leadId}"
                                                <c:if test="${(not empty quotation && quotation.leadId == ld.leadId) || (not empty selectedOpp && selectedOpp.leadId == ld.leadId)}">selected</c:if>
                                            >${ld.fullName} - ${not empty ld.companyName ? ld.companyName : 'N/A'} (${ld.leadCode})</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <!-- Customer selector -->
                                <div class="col-12" id="customerSelectDiv" style="display:none;">
                                    <label class="form-label small">Chon Customer <span class="text-danger">*</span></label>
                                    <select name="customerId" class="form-select form-select-sm" id="customerSelect">
                                        <option value="">-- Chon customer --</option>
                                        <c:forEach var="cust" items="${customers}">
                                            <option value="${cust.customerId}"
                                                <c:if test="${(not empty quotation && quotation.customerId == cust.customerId) || (not empty selectedOpp && selectedOpp.customerId == cust.customerId)}">selected</c:if>
                                            >${cust.fullName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Basic Info -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold"><i class="bi bi-info-circle me-2"></i>Thong tin co ban</h6></div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Tieu de <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="title" required
                                   placeholder="VD: De xuat goi dao tao..."
                                   value="${not empty quotation ? quotation.title : ''}"
                                   ${readonly ? 'readonly' : ''}>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Opportunity</label>
                            <select class="form-select" name="opportunityId" id="opportunitySelect"
                                    ${readonly ? 'disabled' : ''}>
                                <option value="">-- Khong gan opportunity --</option>
                                <c:forEach var="opp" items="${allowedOpps}">
                                    <option value="${opp.opportunityId}"
                                            data-lead-id="${opp.leadId}"
                                            data-customer-id="${opp.customerId}"
                                            <c:choose>
                                                <c:when test="${not empty selectedOpp && selectedOpp.opportunityId == opp.opportunityId}">selected</c:when>
                                                <c:when test="${not empty quotation && quotation.opportunityId == opp.opportunityId}">selected</c:when>
                                            </c:choose>
                                    >${opp.opportunityCode} - ${opp.opportunityName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Hieu luc den <span class="text-danger">*</span></label>
                            <input type="date" class="form-control" name="validUntil" required
                                   value="${not empty quotation ? quotation.validUntil : ''}"
                                   ${readonly ? 'readonly' : ''}>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">So ngay het han</label>
                            <input type="number" class="form-control" name="expiryDays" min="1"
                                   value="${not empty quotation ? quotation.expiryDays : 30}"
                                   ${readonly ? 'readonly' : ''}>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Mo ta</label>
                            <textarea class="form-control" rows="3" name="description"
                                      placeholder="Mo ta chi tiet de xuat..."
                                      ${readonly ? 'readonly' : ''}>${not empty quotation ? quotation.description : ''}</textarea>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Items -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0 d-flex justify-content-between align-items-center">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-list-check me-2"></i>Hang muc</h6>
                    <c:if test="${isDraft}">
                        <button type="button" class="btn btn-sm btn-outline-primary" onclick="addItem()"><i class="bi bi-plus me-1"></i>Them hang muc</button>
                    </c:if>
                </div>
                <div class="card-body pt-0">
                    <div class="table-responsive">
                        <table class="table align-middle mb-0" id="itemsTable">
                            <thead class="table-light">
                                <tr>
                                    <th>Loai</th>
                                    <th>Khoa hoc</th>
                                    <th>Mo ta</th>
                                    <th style="width:70px;">SL</th>
                                    <th style="width:140px;">Don gia</th>
                                    <th style="width:90px;">Giam (%)</th>
                                    <th style="width:140px;" class="text-end">Thanh tien</th>
                                    <c:if test="${isDraft}"><th style="width:40px;"></th></c:if>
                                </tr>
                            </thead>
                            <tbody id="itemsBody">
                                <c:choose>
                                    <c:when test="${not empty quotationItems}">
                                        <c:forEach var="item" items="${quotationItems}">
                                            <tr class="item-row">
                                                <td>
                                                    <select class="form-select form-select-sm" name="itemType" ${readonly ? 'disabled' : ''}>
                                                        <option value="Course" ${item.itemType == 'Course' ? 'selected' : ''}>Khoa hoc</option>
                                                        <option value="Service" ${item.itemType == 'Service' ? 'selected' : ''}>Dich vu</option>
                                                        <option value="Other" ${item.itemType == 'Other' ? 'selected' : ''}>Khac</option>
                                                    </select>
                                                </td>
                                                <td>
                                                    <select class="form-select form-select-sm" name="itemCourseId" ${readonly ? 'disabled' : ''}>
                                                        <option value="">--</option>
                                                        <c:forEach var="course" items="${courses}">
                                                            <option value="${course.courseId}" ${item.courseId != null && item.courseId == course.courseId ? 'selected' : ''}>${course.courseName}</option>
                                                        </c:forEach>
                                                    </select>
                                                </td>
                                                <td><input type="text" class="form-control form-control-sm" name="itemDescription"
                                                           value="${item.description}" ${readonly ? 'readonly' : ''}></td>
                                                <td><input type="number" class="form-control form-control-sm item-qty" name="itemQuantity"
                                                           value="${item.quantity}" min="1" onchange="calcLine(this)" ${readonly ? 'readonly' : ''}></td>
                                                <td><input type="text" class="form-control form-control-sm item-price" name="itemUnitPrice"
                                                           value="${item.unitPrice}" onchange="calcLine(this)" ${readonly ? 'readonly' : ''}></td>
                                                <td><input type="text" class="form-control form-control-sm item-disc" name="itemDiscount"
                                                           value="${item.discountPercent}" onchange="calcLine(this)" ${readonly ? 'readonly' : ''}></td>
                                                <td class="text-end fw-semibold item-total"><fmt:formatNumber value="${item.lineTotal}" type="number" groupingUsed="true" maxFractionDigits="0"/> d</td>
                                                <c:if test="${isDraft}">
                                                    <td><button type="button" class="btn btn-sm btn-outline-danger" onclick="removeItem(this)"><i class="bi bi-trash"></i></button></td>
                                                </c:if>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr class="item-row">
                                            <td>
                                                <select class="form-select form-select-sm" name="itemType">
                                                    <option value="Course">Khoa hoc</option>
                                                    <option value="Service">Dich vu</option>
                                                    <option value="Other">Khac</option>
                                                </select>
                                            </td>
                                            <td>
                                                <select class="form-select form-select-sm" name="itemCourseId">
                                                    <option value="">--</option>
                                                    <c:forEach var="course" items="${courses}">
                                                        <option value="${course.courseId}">${course.courseName}</option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <td><input type="text" class="form-control form-control-sm" name="itemDescription" placeholder="Mo ta hang muc"></td>
                                            <td><input type="number" class="form-control form-control-sm item-qty" name="itemQuantity" value="1" min="1" onchange="calcLine(this)"></td>
                                            <td><input type="text" class="form-control form-control-sm item-price" name="itemUnitPrice" value="0" onchange="calcLine(this)"></td>
                                            <td><input type="text" class="form-control form-control-sm item-disc" name="itemDiscount" value="0" onchange="calcLine(this)"></td>
                                            <td class="text-end fw-semibold item-total">0 d</td>
                                            <td><button type="button" class="btn btn-sm btn-outline-danger" onclick="removeItem(this)"><i class="bi bi-trash"></i></button></td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                            <tfoot>
                                <tr class="table-light">
                                    <td colspan="${isDraft ? 6 : 5}" class="text-end fw-bold">Tong hang muc:</td>
                                    <td class="text-end fw-bold" id="subtotalDisplay">0 d</td>
                                    <c:if test="${isDraft}"><td></td></c:if>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Discount & Tax -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold"><i class="bi bi-percent me-2"></i>Giam gia & Thue</h6></div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label">Loai giam gia</label>
                            <select class="form-select" name="discountType" ${readonly ? 'disabled' : ''}>
                                <option value="Percentage" ${not empty quotation && quotation.discountType == 'Percentage' ? 'selected' : ''}>Phan tram (%)</option>
                                <option value="Fixed" ${not empty quotation && quotation.discountType == 'Fixed' ? 'selected' : ''}>Co dinh (VND)</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Giam gia (%)</label>
                            <input type="number" class="form-control" name="discountPercent" min="0" max="100"
                                   value="${not empty quotation ? quotation.discountPercent : 0}"
                                   ${readonly ? 'readonly' : ''} onchange="calcOverall()">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Thue (%)</label>
                            <input type="number" class="form-control" name="taxPercent" min="0" max="100"
                                   value="${not empty quotation ? quotation.taxPercent : 0}"
                                   ${readonly ? 'readonly' : ''} onchange="calcOverall()">
                        </div>
                    </div>
                    <c:if test="${not empty quotation}">
                        <div class="row g-3 mt-2">
                            <div class="col-md-4">
                                <small class="text-muted">Subtotal:</small>
                                <div class="fw-semibold"><fmt:formatNumber value="${quotation.subtotal}" type="number" groupingUsed="true" maxFractionDigits="0"/> d</div>
                            </div>
                            <div class="col-md-4">
                                <small class="text-muted">Giam gia:</small>
                                <div class="fw-semibold text-danger">-<fmt:formatNumber value="${quotation.discountAmount}" type="number" groupingUsed="true" maxFractionDigits="0"/> d</div>
                            </div>
                            <div class="col-md-4">
                                <small class="text-muted">Thue:</small>
                                <div class="fw-semibold">+<fmt:formatNumber value="${quotation.taxAmount}" type="number" groupingUsed="true" maxFractionDigits="0"/> d</div>
                            </div>
                        </div>
                    </c:if>
                    <div class="mt-3 p-3 bg-light rounded text-end">
                        <span class="text-muted me-2">Tong cong:</span>
                        <span class="fs-4 fw-bold text-success" id="grandTotal">
                            <c:choose>
                                <c:when test="${not empty quotation}"><fmt:formatNumber value="${quotation.totalAmount}" type="number" groupingUsed="true" maxFractionDigits="0"/> d</c:when>
                                <c:otherwise>0 d</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
            </div>

            <!-- Terms -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold"><i class="bi bi-file-text me-2"></i>Dieu khoan & Ghi chu</h6></div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Dieu khoan thanh toan</label>
                            <textarea class="form-control" rows="2" name="paymentTerms"
                                      placeholder="VD: Thanh toan 50% khi ky hop dong..."
                                      ${readonly ? 'readonly' : ''}>${not empty quotation ? quotation.paymentTerms : ''}</textarea>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Dieu khoan giao hang</label>
                            <textarea class="form-control" rows="2" name="deliveryTerms"
                                      placeholder="VD: Bat dau sau 2 tuan..."
                                      ${readonly ? 'readonly' : ''}>${not empty quotation ? quotation.deliveryTerms : ''}</textarea>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Dieu khoan & Dieu kien</label>
                            <textarea class="form-control" rows="3" name="termsConditions"
                                      placeholder="Cac dieu khoan chung..."
                                      ${readonly ? 'readonly' : ''}>${not empty quotation ? quotation.termsConditions : ''}</textarea>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Ghi chu (hien thi cho khach)</label>
                            <textarea class="form-control" rows="2" name="notes"
                                      ${readonly ? 'readonly' : ''}>${not empty quotation ? quotation.notes : ''}</textarea>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Ghi chu noi bo</label>
                            <textarea class="form-control" rows="2" name="internalNotes"
                                      placeholder="Chi hien thi noi bo..."
                                      ${readonly ? 'readonly' : ''}>${not empty quotation ? quotation.internalNotes : ''}</textarea>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Version History -->
            <c:if test="${not empty quotationVersions}">
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold"><i class="bi bi-clock-history me-2"></i>Lich su phien ban</h6></div>
                    <div class="card-body pt-0">
                        <div class="table-responsive">
                            <table class="table table-sm table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Phien ban</th>
                                        <th>Gia tri</th>
                                        <th>Ly do thay doi</th>
                                        <th>Tom tat</th>
                                        <th>Ngay</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="ver" items="${quotationVersions}">
                                        <tr>
                                            <td><span class="badge bg-secondary">v${ver.versionNumber}</span></td>
                                            <td><fmt:formatNumber value="${ver.totalAmount}" type="number" groupingUsed="true" maxFractionDigits="0"/> d</td>
                                            <td><small>${ver.changeReason}</small></td>
                                            <td><small>${ver.changeSummary}</small></td>
                                            <td><small class="text-muted">${ver.createdAt}</small></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Tracking Logs -->
            <c:if test="${not empty trackingLogs}">
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold"><i class="bi bi-activity me-2"></i>Tracking Logs</h6></div>
                    <div class="card-body pt-0">
                        <div class="table-responsive">
                            <table class="table table-sm table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Su kien</th>
                                        <th>Ngay</th>
                                        <th>IP</th>
                                        <th>Thiet bi</th>
                                        <th>Trinh duyet</th>
                                        <th>Thoi gian (s)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="log" items="${trackingLogs}">
                                        <tr>
                                            <td><span class="badge bg-info-subtle text-info">${log.eventType}</span></td>
                                            <td><small>${log.eventDate}</small></td>
                                            <td><small class="text-muted">${log.ipAddress}</small></td>
                                            <td><small>${log.deviceType}</small></td>
                                            <td><small>${log.browser}</small></td>
                                            <td><small>${log.durationSeconds}</small></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>

        <!-- Sidebar -->
        <div class="col-lg-4">
            <!-- Approval Info -->
            <c:if test="${not empty quotation && !isDraft}">
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold"><i class="bi bi-shield-check me-2"></i>Thong tin duyet</h6></div>
                    <div class="card-body">
                        <c:if test="${not empty quotation.approvedBy}">
                            <div class="mb-2"><small class="text-muted">Nguoi duyet:</small> <strong>Manager #${quotation.approvedBy}</strong></div>
                            <div class="mb-2"><small class="text-muted">Ngay duyet:</small> <strong>${quotation.approvedDate}</strong></div>
                            <c:if test="${not empty quotation.approvalNotes}">
                                <div class="mb-2"><small class="text-muted">Ghi chu:</small><br>${quotation.approvalNotes}</div>
                            </c:if>
                        </c:if>
                        <c:if test="${not empty quotation.rejectedBy}">
                            <div class="mb-2"><small class="text-muted">Nguoi tu choi:</small> <strong>Manager #${quotation.rejectedBy}</strong></div>
                            <div class="mb-2"><small class="text-muted">Ly do:</small><br><span class="text-danger">${quotation.rejectionReason}</span></div>
                        </c:if>
                    </div>
                </div>
            </c:if>

            <!-- Linked Opp Info -->
            <c:if test="${not empty linkedOpp}">
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold"><i class="bi bi-briefcase me-2"></i>Opportunity</h6></div>
                    <div class="card-body">
                        <div class="mb-2"><small class="text-muted">Ma:</small> <strong>${linkedOpp.opportunityCode}</strong></div>
                        <div class="mb-2"><small class="text-muted">Ten:</small> <strong>${linkedOpp.opportunityName}</strong></div>
                        <c:if test="${not empty linkedOpp.estimatedValue}">
                            <div class="mb-2"><small class="text-muted">Gia tri:</small> <strong><fmt:formatNumber value="${linkedOpp.estimatedValue}" type="number" groupingUsed="true" maxFractionDigits="0"/> d</strong></div>
                        </c:if>
                    </div>
                </div>
            </c:if>

            <!-- Actions -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-body">
                    <div class="d-grid gap-2">
                        <c:choose>
                            <c:when test="${isDraft}">
                                <button type="submit" class="btn btn-primary"><i class="bi bi-save me-1"></i>Luu de xuat</button>
                                <small class="text-muted text-center">Sau khi luu, Manager se duyet de xuat nay</small>
                            </c:when>
                            <c:when test="${quotation.status == 'Approved'}">
                                <div class="alert alert-success py-2 mb-2 small"><i class="bi bi-check-circle me-1"></i>De xuat da duoc duyet. San sang gui cho khach hang.</div>
                            </c:when>
                            <c:when test="${quotation.status == 'Sent'}">
                                <div class="alert alert-info py-2 mb-2 small"><i class="bi bi-send me-1"></i>Bao gia da gui cho khach hang.</div>
                            </c:when>
                            <c:when test="${quotation.status == 'Accepted'}">
                                <div class="alert alert-primary py-2 mb-2 small"><i class="bi bi-hand-thumbs-up me-1"></i>Khach hang da chap nhan bao gia.</div>
                            </c:when>
                            <c:when test="${quotation.status == 'Rejected'}">
                                <div class="alert alert-danger py-2 mb-2 small"><i class="bi bi-x-circle me-1"></i>Bao gia bi tu choi.</div>
                            </c:when>
                        </c:choose>
                        <a href="${pageContext.request.contextPath}/sale/quotation/list" class="btn btn-outline-secondary">Quay lai danh sach</a>
                    </div>
                </div>
            </div>

            <!-- Workflow -->
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold"><i class="bi bi-diagram-3 me-2"></i>Quy trinh</h6></div>
                <div class="card-body">
                    <div class="d-flex flex-column gap-2">
                        <div class="d-flex align-items-center gap-2">
                            <span class="badge ${quotation.status == 'Draft' || empty quotation ? 'bg-secondary' : 'bg-light text-muted'} rounded-circle p-1" style="width:24px;height:24px;display:flex;align-items:center;justify-content:center;">1</span>
                            <small><strong>Draft</strong> - Sale tao de xuat</small>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <span class="badge ${quotation.status == 'Approved' ? 'bg-success' : 'bg-light text-muted'} rounded-circle p-1" style="width:24px;height:24px;display:flex;align-items:center;justify-content:center;">2</span>
                            <small><strong>Approved</strong> - Manager duyet</small>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <span class="badge ${quotation.status == 'Sent' ? 'bg-warning text-dark' : 'bg-light text-muted'} rounded-circle p-1" style="width:24px;height:24px;display:flex;align-items:center;justify-content:center;">3</span>
                            <small><strong>Sent</strong> - Gui bao gia cho khach</small>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <span class="badge ${quotation.status == 'Accepted' || quotation.status == 'Rejected' ? 'bg-primary' : 'bg-light text-muted'} rounded-circle p-1" style="width:24px;height:24px;display:flex;align-items:center;justify-content:center;">4</span>
                            <small><strong>Accepted/Rejected</strong> - Khach phan hoi</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>

<script>
    // Toggle lead/customer selector
    var typeFromLead = document.getElementById('typeFromLead');
    var typeFromCustomer = document.getElementById('typeFromCustomer');
    var leadDiv = document.getElementById('leadSelectDiv');
    var customerDiv = document.getElementById('customerSelectDiv');
    var leadSel = document.getElementById('leadSelect');
    var customerSel = document.getElementById('customerSelect');

    function toggleContactType() {
        if (!typeFromLead || !typeFromCustomer) return;
        if (typeFromLead.checked) {
            if (leadDiv) leadDiv.style.display = '';
            if (customerDiv) customerDiv.style.display = 'none';
            if (customerSel) customerSel.value = '';
        } else {
            if (leadDiv) leadDiv.style.display = 'none';
            if (customerDiv) customerDiv.style.display = '';
            if (leadSel) leadSel.value = '';
        }
    }

    if (typeFromLead) typeFromLead.addEventListener('change', toggleContactType);
    if (typeFromCustomer) typeFromCustomer.addEventListener('change', toggleContactType);
    toggleContactType();

    // Course dropdown template for new items
    var courseOptionsHtml = '<option value="">--</option>';
    <c:forEach var="course" items="${courses}">
        courseOptionsHtml += '<option value="${course.courseId}">${course.courseName}</option>';
    </c:forEach>

    function addItem() {
        var tbody = document.getElementById('itemsBody');
        var tr = document.createElement('tr');
        tr.className = 'item-row';
        tr.innerHTML =
            '<td><select class="form-select form-select-sm" name="itemType"><option value="Course">Khoa hoc</option><option value="Service">Dich vu</option><option value="Other">Khac</option></select></td>' +
            '<td><select class="form-select form-select-sm" name="itemCourseId">' + courseOptionsHtml + '</select></td>' +
            '<td><input type="text" class="form-control form-control-sm" name="itemDescription" placeholder="Mo ta hang muc"></td>' +
            '<td><input type="number" class="form-control form-control-sm item-qty" name="itemQuantity" value="1" min="1" onchange="calcLine(this)"></td>' +
            '<td><input type="text" class="form-control form-control-sm item-price" name="itemUnitPrice" value="0" onchange="calcLine(this)"></td>' +
            '<td><input type="text" class="form-control form-control-sm item-disc" name="itemDiscount" value="0" onchange="calcLine(this)"></td>' +
            '<td class="text-end fw-semibold item-total">0 d</td>' +
            '<td><button type="button" class="btn btn-sm btn-outline-danger" onclick="removeItem(this)"><i class="bi bi-trash"></i></button></td>';
        tbody.appendChild(tr);
    }

    function removeItem(btn) {
        btn.closest('tr').remove();
        calcGrandTotal();
    }

    function calcLine(input) {
        var row = input.closest('tr');
        var qty = parseInt(row.querySelector('.item-qty').value) || 0;
        var price = parseFloat(row.querySelector('.item-price').value.replace(/,/g, '')) || 0;
        var disc = parseInt(row.querySelector('.item-disc').value.replace('%', '')) || 0;
        var total = qty * price;
        if (disc > 0) total = total - (total * disc / 100);
        row.querySelector('.item-total').textContent = formatNumber(Math.round(total)) + ' d';
        calcGrandTotal();
    }

    function calcGrandTotal() {
        var rows = document.querySelectorAll('.item-row');
        var subtotal = 0;
        rows.forEach(function(row) {
            var text = row.querySelector('.item-total').textContent.replace(/[^\d]/g, '');
            subtotal += parseInt(text) || 0;
        });
        var el = document.getElementById('subtotalDisplay');
        if (el) el.textContent = formatNumber(subtotal) + ' d';
        calcOverall();
    }

    function calcOverall() {
        var rows = document.querySelectorAll('.item-row');
        var subtotal = 0;
        rows.forEach(function(row) {
            var text = row.querySelector('.item-total').textContent.replace(/[^\d]/g, '');
            subtotal += parseInt(text) || 0;
        });
        var discInput = document.querySelector('input[name="discountPercent"]');
        var taxInput = document.querySelector('input[name="taxPercent"]');
        var discPct = discInput ? (parseInt(discInput.value) || 0) : 0;
        var taxPct = taxInput ? (parseInt(taxInput.value) || 0) : 0;
        var discAmt = subtotal * discPct / 100;
        var afterDisc = subtotal - discAmt;
        var taxAmt = afterDisc * taxPct / 100;
        var total = afterDisc + taxAmt;
        var gt = document.getElementById('grandTotal');
        if (gt) gt.textContent = formatNumber(Math.round(total)) + ' d';
    }

    function formatNumber(num) {
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    }

    document.addEventListener('DOMContentLoaded', function() {
        calcGrandTotal();
    });
</script>
