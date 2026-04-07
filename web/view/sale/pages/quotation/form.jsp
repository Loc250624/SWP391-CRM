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
                        <c:when test="${quotation.status == 'Draft'}"><span class="badge bg-secondary">Đề xuất (Draft)</span> - Cần Manager duyệt</c:when>
                        <c:when test="${quotation.status == 'Approved'}"><span class="badge bg-success">Đã duyệt</span> - Sẵn sàng gửi cho khách</c:when>
                        <c:when test="${quotation.status == 'Sent'}"><span class="badge bg-warning text-dark">Báo giá (Đã gửi)</span></c:when>
                        <c:when test="${quotation.status == 'Accepted'}"><span class="badge bg-primary">Khách chấp nhận</span></c:when>
                        <c:when test="${quotation.status == 'Rejected'}"><span class="badge bg-danger">Bị từ chối</span></c:when>
                        <c:otherwise><span class="badge bg-secondary">${quotation.status}</span></c:otherwise>
                    </c:choose>
                </c:when>
                <c:otherwise>Đề xuất sẽ ở trạng thái Draft. Cần Manager duyệt trước khi gửi cho khách hàng.</c:otherwise>
            </c:choose>
        </p>
    </div>
    <a href="${pageContext.request.contextPath}/sale/quotation/list" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left me-1"></i>Quay lại</a>
</div>

<c:if test="${not empty error}">
    <script>document.addEventListener('DOMContentLoaded', function(){ CRM.showToast('${error}', 'error'); });</script>
</c:if>

<form method="POST" action="${pageContext.request.contextPath}/sale/quotation/form" id="quotationForm">
    <c:if test="${not empty quotation}">
        <input type="hidden" name="quotationId" value="${quotation.quotationId}" />
    </c:if>

    <c:set var="isDraft" value="${empty quotation || quotation.status == 'Draft'}" />
    <c:set var="readonly" value="${not isDraft}" />

    <div class="row g-4">
        <div class="col-lg-8">
            <!-- Opportunity & Lead/Customer -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-briefcase me-2"></i>Opportunity & Liên hệ</h6>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty selectedOpp}">
                            <input type="hidden" name="opportunityId" value="${selectedOpp.opportunityId}" />
                            <div class="row g-3">
                                <div class="col-12">
                                    <label class="form-label small text-muted">Opportunity</label>
                                    <div class="form-control form-control-sm bg-light">
                                        <i class="bi bi-briefcase me-1 text-primary"></i>${selectedOpp.opportunityCode} - ${selectedOpp.opportunityName}
                                        <c:if test="${not empty selectedOpp.estimatedValue}">
                                            <span class="text-success ms-2">(<fmt:formatNumber value="${selectedOpp.estimatedValue}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ)</span>
                                        </c:if>
                                    </div>
                                </div>
                                <c:if test="${not empty selectedOppLead}">
                                    <div class="col-md-6">
                                        <label class="form-label small text-muted">Lead</label>
                                        <div class="form-control form-control-sm bg-light">
                                            <i class="bi bi-person me-1 text-primary"></i>${selectedOppLead.fullName}
                                            <small class="text-muted">(${selectedOppLead.leadCode})</small>
                                        </div>
                                    </div>
                                </c:if>
                                <c:if test="${not empty selectedOppCustomer}">
                                    <div class="col-md-6">
                                        <label class="form-label small text-muted">Customer</label>
                                        <div class="form-control form-control-sm bg-light">
                                            <i class="bi bi-building me-1 text-success"></i>${selectedOppCustomer.fullName}
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </c:when>
                        <c:when test="${not empty quotation && !isDraft}">
                            <div class="row g-3">
                                <c:if test="${not empty linkedOpp}">
                                    <div class="col-12">
                                        <label class="form-label small text-muted">Opportunity</label>
                                        <div class="form-control form-control-sm bg-light">
                                            <i class="bi bi-briefcase me-1 text-primary"></i>${linkedOpp.opportunityCode} - ${linkedOpp.opportunityName}
                                        </div>
                                    </div>
                                </c:if>
                                <div class="col-md-6">
                                    <label class="form-label small text-muted">Lead</label>
                                    <c:choose>
                                        <c:when test="${not empty linkedLead}">
                                            <div class="form-control form-control-sm bg-light"><i class="bi bi-person me-1 text-primary"></i>${linkedLead.fullName} <small class="text-muted">(${linkedLead.leadCode})</small></div>
                                        </c:when>
                                        <c:otherwise><div class="form-control form-control-sm bg-light text-muted">-- Không có --</div></c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small text-muted">Customer</label>
                                    <c:choose>
                                        <c:when test="${not empty linkedCustomer}">
                                            <div class="form-control form-control-sm bg-light"><i class="bi bi-building me-1 text-success"></i>${linkedCustomer.fullName}</div>
                                        </c:when>
                                        <c:otherwise><div class="form-control form-control-sm bg-light text-muted">-- Không có --</div></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <input type="hidden" name="opportunityId" id="hiddenOppId"
                                   value="${not empty quotation ? quotation.opportunityId : ''}" />
                            <div class="row g-3">
                                <div class="col-12">
                                    <label class="form-label">Opportunity <span class="text-danger">*</span></label>
                                    <div id="oppSelectedPreview" style="display:none;">
                                        <div class="d-flex align-items-center gap-2 p-2 bg-light rounded border">
                                            <i class="bi bi-briefcase-fill text-primary"></i>
                                            <div class="flex-grow-1">
                                                <div class="fw-semibold" id="oppPreviewName"></div>
                                                <small class="text-muted" id="oppPreviewContact"></small>
                                            </div>
                                            <button type="button" class="btn btn-outline-danger btn-sm" onclick="clearOppSelection()" title="Bỏ chọn"><i class="bi bi-x-lg"></i></button>
                                        </div>
                                    </div>
                                    <button type="button" class="btn btn-outline-primary btn-sm w-100" id="oppPickerOpenBtn" onclick="openOppPicker()">
                                        <i class="bi bi-briefcase me-1"></i>Chọn Opportunity <span class="text-danger">*</span>
                                    </button>
                                    <small class="text-muted">Lead/Customer sẽ tự động lấy từ Opportunity</small>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Basic Info -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold"><i class="bi bi-info-circle me-2"></i>Thông tin cơ bản</h6></div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Tiêu đề <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="title" required
                                   placeholder="VD: Đề xuất gói đào tạo..."
                                   value="${not empty quotation ? quotation.title : ''}"
                                   ${readonly ? 'readonly' : ''}>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Hiệu lực đến <span class="text-danger">*</span></label>
                            <input type="date" class="form-control" name="validUntil" required
                                   value="${not empty quotation ? quotation.validUntil : ''}"
                                   ${readonly ? 'readonly' : ''}>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Số ngày hết hạn</label>
                            <input type="number" class="form-control" name="expiryDays" min="1"
                                   value="${not empty quotation ? quotation.expiryDays : 30}"
                                   ${readonly ? 'readonly' : ''}>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Mô tả</label>
                            <textarea class="form-control" rows="3" name="description"
                                      placeholder="Mô tả chi tiết đề xuất..."
                                      ${readonly ? 'readonly' : ''}>${not empty quotation ? quotation.description : ''}</textarea>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Determine course list label --%>
            <c:choose>
                <c:when test="${isCustomerOpp && not empty enrolledCourses}">
                    <c:set var="courseList" value="${enrolledCourses}" />
                    <c:set var="courseListLabel" value="Khóa học đã đăng ký" />
                </c:when>
                <c:otherwise>
                    <c:set var="courseList" value="${courses}" />
                    <c:set var="courseListLabel" value="Tất cả khóa học" />
                </c:otherwise>
            </c:choose>

            <!-- Items -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0 d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="mb-0 fw-semibold"><i class="bi bi-list-check me-2"></i>Hạng mục</h6>
                        <c:if test="${isCustomerOpp && not empty enrolledCourses}">
                            <small class="text-muted">Khóa học đã đăng ký của customer</small>
                        </c:if>
                    </div>
                    <c:if test="${isDraft}">
                        <div class="d-flex gap-2">
                            <button type="button" class="btn btn-sm btn-primary" onclick="openCoursePicker()"><i class="bi bi-mortarboard me-1"></i>Chọn khóa học</button>
                            <button type="button" class="btn btn-sm btn-outline-secondary" onclick="addManualItem()"><i class="bi bi-plus me-1"></i>Thêm dịch vụ khác</button>
                        </div>
                    </c:if>
                </div>
                <div class="card-body pt-0">
                    <div class="table-responsive">
                        <table class="table align-middle mb-0" id="itemsTable">
                            <thead class="table-light">
                                <tr>
                                    <th>Loại</th>
                                    <th>Mô tả</th>
                                    <th style="width:70px;">SL</th>
                                    <th style="width:140px;">Đơn giá</th>
                                    <th style="width:90px;">Giảm (%)</th>
                                    <th style="width:140px;" class="text-end">Thành tiền</th>
                                    <c:if test="${isDraft}"><th style="width:40px;"></th></c:if>
                                </tr>
                            </thead>
                            <tbody id="itemsBody">
                                <c:if test="${not empty quotationItems}">
                                    <c:forEach var="item" items="${quotationItems}">
                                        <tr class="item-row">
                                            <td>
                                                <input type="hidden" name="itemCourseId" value="${item.courseId}">
                                                <input type="hidden" name="itemType" value="${item.itemType}">
                                                <c:choose>
                                                    <c:when test="${item.itemType == 'Course'}"><span class="badge bg-primary-subtle text-primary"><i class="bi bi-mortarboard me-1"></i>Khóa học</span></c:when>
                                                    <c:when test="${item.itemType == 'Service'}"><span class="badge bg-info-subtle text-info"><i class="bi bi-gear me-1"></i>Dịch vụ</span></c:when>
                                                    <c:otherwise><span class="badge bg-secondary-subtle text-secondary">Khác</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><input type="text" class="form-control form-control-sm" name="itemDescription"
                                                       value="${item.description}" ${readonly ? 'readonly' : ''}></td>
                                            <td><input type="number" class="form-control form-control-sm item-qty" name="itemQuantity"
                                                       value="${item.quantity}" min="1" onchange="calcLine(this)" ${readonly ? 'readonly' : ''}></td>
                                            <td><input type="text" class="form-control form-control-sm item-price" name="itemUnitPrice"
                                                       value="${item.unitPrice}" onchange="calcLine(this)" ${readonly ? 'readonly' : ''}></td>
                                            <td><input type="text" class="form-control form-control-sm item-disc" name="itemDiscount"
                                                       value="${item.discountPercent}" onchange="calcLine(this)" ${readonly ? 'readonly' : ''}></td>
                                            <td class="text-end fw-semibold item-total"><fmt:formatNumber value="${item.lineTotal}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</td>
                                            <c:if test="${isDraft}">
                                                <td><button type="button" class="btn btn-sm btn-outline-danger" onclick="removeItem(this)"><i class="bi bi-trash"></i></button></td>
                                            </c:if>
                                        </tr>
                                    </c:forEach>
                                </c:if>
                            </tbody>
                            <tfoot>
                                <tr class="table-light">
                                    <td colspan="${isDraft ? 5 : 4}" class="text-end fw-bold">Tổng hạng mục:</td>
                                    <td class="text-end fw-bold" id="subtotalDisplay">0 đ</td>
                                    <c:if test="${isDraft}"><td></td></c:if>
                                </tr>
                            </tfoot>
                        </table>
                    </div>

                    <%-- Empty state --%>
                    <div id="itemsEmpty" class="text-center text-muted py-4" style="display:none;">
                        <i class="bi bi-inbox" style="font-size:2rem;"></i>
                        <p class="mb-2 mt-2">Chưa có hạng mục nào</p>
                        <c:if test="${isDraft}">
                            <button type="button" class="btn btn-sm btn-primary" onclick="openCoursePicker()"><i class="bi bi-mortarboard me-1"></i>Chọn khóa học</button>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Discount & Tax -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold"><i class="bi bi-percent me-2"></i>Giảm giá & Thuế</h6></div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label">Loại giảm giá</label>
                            <select class="form-select" name="discountType" ${readonly ? 'disabled' : ''}>
                                <option value="Percentage" ${not empty quotation && quotation.discountType == 'Percentage' ? 'selected' : ''}>Phần trăm (%)</option>
                                <option value="Fixed" ${not empty quotation && quotation.discountType == 'Fixed' ? 'selected' : ''}>Cố định (VND)</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Giảm giá (%)</label>
                            <input type="number" class="form-control" name="discountPercent" min="0" max="100"
                                   value="${not empty quotation ? quotation.discountPercent : 0}"
                                   ${readonly ? 'readonly' : ''} onchange="calcOverall()">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Thuế (%)</label>
                            <input type="number" class="form-control" name="taxPercent" min="0" max="100"
                                   value="${not empty quotation ? quotation.taxPercent : 0}"
                                   ${readonly ? 'readonly' : ''} onchange="calcOverall()">
                        </div>
                    </div>
                    <c:if test="${not empty quotation}">
                        <div class="row g-3 mt-2">
                            <div class="col-md-4"><small class="text-muted">Subtotal:</small><div class="fw-semibold"><fmt:formatNumber value="${quotation.subtotal}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</div></div>
                            <div class="col-md-4"><small class="text-muted">Giảm giá:</small><div class="fw-semibold text-danger">-<fmt:formatNumber value="${quotation.discountAmount}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</div></div>
                            <div class="col-md-4"><small class="text-muted">Thuế:</small><div class="fw-semibold">+<fmt:formatNumber value="${quotation.taxAmount}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</div></div>
                        </div>
                    </c:if>
                    <div class="mt-3 p-3 bg-light rounded text-end">
                        <span class="text-muted me-2">Tổng cộng:</span>
                        <span class="fs-4 fw-bold text-success" id="grandTotal">
                            <c:choose>
                                <c:when test="${not empty quotation}"><fmt:formatNumber value="${quotation.totalAmount}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</c:when>
                                <c:otherwise>0 đ</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
            </div>

            <!-- Terms -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold"><i class="bi bi-file-text me-2"></i>Điều khoản & Ghi chú</h6></div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Điều khoản thanh toán</label>
                            <textarea class="form-control" rows="2" name="paymentTerms" placeholder="VD: Thanh toán 50% khi ký hợp đồng..." ${readonly ? 'readonly' : ''}>${not empty quotation ? quotation.paymentTerms : ''}</textarea>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Điều khoản giao hàng</label>
                            <textarea class="form-control" rows="2" name="deliveryTerms" placeholder="VD: Bắt đầu sau 2 tuần..." ${readonly ? 'readonly' : ''}>${not empty quotation ? quotation.deliveryTerms : ''}</textarea>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Điều khoản & Điều kiện</label>
                            <textarea class="form-control" rows="3" name="termsConditions" placeholder="Các điều khoản chung..." ${readonly ? 'readonly' : ''}>${not empty quotation ? quotation.termsConditions : ''}</textarea>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Ghi chú (hiển thị cho khách)</label>
                            <textarea class="form-control" rows="2" name="notes" ${readonly ? 'readonly' : ''}>${not empty quotation ? quotation.notes : ''}</textarea>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Ghi chú nội bộ</label>
                            <textarea class="form-control" rows="2" name="internalNotes" placeholder="Chỉ hiển thị nội bộ..." ${readonly ? 'readonly' : ''}>${not empty quotation ? quotation.internalNotes : ''}</textarea>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Version History -->
            <c:if test="${not empty quotationVersions}">
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold"><i class="bi bi-clock-history me-2"></i>Lịch sử phiên bản</h6></div>
                    <div class="card-body pt-0">
                        <div class="table-responsive">
                            <table class="table table-sm table-hover mb-0">
                                <thead class="table-light"><tr><th>Phiên bản</th><th>Giá trị</th><th>Lý do thay đổi</th><th>Tóm tắt</th><th>Ngày</th></tr></thead>
                                <tbody>
                                    <c:forEach var="ver" items="${quotationVersions}">
                                        <tr>
                                            <td><span class="badge bg-secondary">v${ver.versionNumber}</span></td>
                                            <td><fmt:formatNumber value="${ver.totalAmount}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</td>
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
                                <thead class="table-light"><tr><th>Sự kiện</th><th>Ngày</th><th>IP</th><th>Thiết bị</th><th>Trình duyệt</th><th>Thời gian (s)</th></tr></thead>
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
            <c:if test="${not empty quotation && !isDraft}">
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold"><i class="bi bi-shield-check me-2"></i>Thông tin duyệt</h6></div>
                    <div class="card-body">
                        <c:if test="${not empty quotation.approvedBy}">
                            <div class="mb-2"><small class="text-muted">Người duyệt:</small> <strong>Manager #${quotation.approvedBy}</strong></div>
                            <div class="mb-2"><small class="text-muted">Ngày duyệt:</small> <strong>${quotation.approvedDate}</strong></div>
                            <c:if test="${not empty quotation.approvalNotes}"><div class="mb-2"><small class="text-muted">Ghi chú:</small><br>${quotation.approvalNotes}</div></c:if>
                        </c:if>
                        <c:if test="${not empty quotation.rejectedBy}">
                            <div class="mb-2"><small class="text-muted">Người từ chối:</small> <strong>Manager #${quotation.rejectedBy}</strong></div>
                            <div class="mb-2"><small class="text-muted">Lý do:</small><br><span class="text-danger">${quotation.rejectionReason}</span></div>
                        </c:if>
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty linkedOpp}">
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold"><i class="bi bi-briefcase me-2"></i>Opportunity</h6></div>
                    <div class="card-body">
                        <div class="mb-2"><small class="text-muted">Mã:</small> <strong>${linkedOpp.opportunityCode}</strong></div>
                        <div class="mb-2"><small class="text-muted">Tên:</small> <strong>${linkedOpp.opportunityName}</strong></div>
                        <c:if test="${not empty linkedOpp.estimatedValue}">
                            <div class="mb-2"><small class="text-muted">Giá trị:</small> <strong><fmt:formatNumber value="${linkedOpp.estimatedValue}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</strong></div>
                        </c:if>
                    </div>
                </div>
            </c:if>

            <div class="card border-0 shadow-sm mb-4">
                <div class="card-body">
                    <div class="d-grid gap-2">
                        <c:choose>
                            <c:when test="${isDraft}">
                                <button type="submit" class="btn btn-primary"><i class="bi bi-save me-1"></i>Lưu đề xuất</button>
                                <small class="text-muted text-center">Sau khi lưu, Manager sẽ duyệt đề xuất này</small>
                            </c:when>
                            <c:when test="${quotation.status == 'Approved'}"><div class="alert alert-success py-2 mb-2 small"><i class="bi bi-check-circle me-1"></i>Đề xuất đã được duyệt.</div></c:when>
                            <c:when test="${quotation.status == 'Sent'}"><div class="alert alert-info py-2 mb-2 small"><i class="bi bi-send me-1"></i>Báo giá đã gửi cho khách hàng.</div></c:when>
                            <c:when test="${quotation.status == 'Accepted'}"><div class="alert alert-primary py-2 mb-2 small"><i class="bi bi-hand-thumbs-up me-1"></i>Khách hàng đã chấp nhận báo giá.</div></c:when>
                            <c:when test="${quotation.status == 'Rejected'}"><div class="alert alert-danger py-2 mb-2 small"><i class="bi bi-x-circle me-1"></i>Báo giá bị từ chối.</div></c:when>
                        </c:choose>
                        <a href="${pageContext.request.contextPath}/sale/quotation/list" class="btn btn-outline-secondary">Quay lại danh sách</a>
                    </div>
                </div>
            </div>

            <div class="card border-0 shadow-sm">
                <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold"><i class="bi bi-diagram-3 me-2"></i>Quy trình</h6></div>
                <div class="card-body">
                    <div class="d-flex flex-column gap-2">
                        <div class="d-flex align-items-center gap-2">
                            <span class="badge ${quotation.status == 'Draft' || empty quotation ? 'bg-secondary' : 'bg-light text-muted'} rounded-circle p-1" style="width:24px;height:24px;display:flex;align-items:center;justify-content:center;">1</span>
                            <small><strong>Draft</strong> - Sale tạo đề xuất</small>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <span class="badge ${quotation.status == 'Approved' ? 'bg-success' : 'bg-light text-muted'} rounded-circle p-1" style="width:24px;height:24px;display:flex;align-items:center;justify-content:center;">2</span>
                            <small><strong>Approved</strong> - Manager duyệt</small>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <span class="badge ${quotation.status == 'Sent' ? 'bg-warning text-dark' : 'bg-light text-muted'} rounded-circle p-1" style="width:24px;height:24px;display:flex;align-items:center;justify-content:center;">3</span>
                            <small><strong>Sent</strong> - Gửi báo giá cho khách</small>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <span class="badge ${quotation.status == 'Accepted' || quotation.status == 'Rejected' ? 'bg-primary' : 'bg-light text-muted'} rounded-circle p-1" style="width:24px;height:24px;display:flex;align-items:center;justify-content:center;">4</span>
                            <small><strong>Accepted/Rejected</strong> - Khách phản hồi</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>

<!-- ==================== Opportunity Picker Modal ==================== -->
<div class="modal fade" id="oppPickerModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content border-0 shadow">
            <div class="modal-header py-2" style="border-bottom: 3px solid #0d6efd;">
                <div>
                    <h6 class="modal-title fw-bold mb-0"><i class="bi bi-briefcase me-2"></i>Chọn Opportunity</h6>
                    <small class="text-muted">Chọn opportunity để tạo báo giá</small>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-0">
                <div class="p-3 border-bottom bg-light">
                    <div class="input-group input-group-sm">
                        <span class="input-group-text bg-white"><i class="bi bi-search text-muted"></i></span>
                        <input type="text" class="form-control" id="oppSearchInput" placeholder="Tìm theo mã, tên opportunity..." oninput="filterOppRows()">
                    </div>
                </div>
                <div class="table-responsive" style="max-height: 400px;">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light sticky-top">
                            <tr><th>Mã</th><th>Tên</th><th>Lead/Customer</th><th class="text-end">Giá trị</th></tr>
                        </thead>
                        <tbody id="oppPickerBody">
                            <c:forEach var="opp" items="${allowedOpps}">
                                <tr class="opp-picker-row" style="cursor:pointer;"
                                    data-id="${opp.opportunityId}"
                                    data-code="${opp.opportunityCode}"
                                    data-name="${opp.opportunityName}"
                                    data-lead-name="${oppLeadNameMap[opp.opportunityId]}"
                                    data-customer-name="${oppCustomerNameMap[opp.opportunityId]}"
                                    data-value="${opp.estimatedValue}"
                                    onclick="confirmOppSelection(this)">
                                    <td><small class="text-muted">${opp.opportunityCode}</small></td>
                                    <td class="fw-medium">${opp.opportunityName}</td>
                                    <td>
                                        <c:if test="${not empty oppLeadNameMap[opp.opportunityId]}">
                                            <small><i class="bi bi-person me-1 text-primary"></i>${oppLeadNameMap[opp.opportunityId]}</small>
                                        </c:if>
                                        <c:if test="${not empty oppCustomerNameMap[opp.opportunityId]}">
                                            <small><i class="bi bi-building me-1 text-success"></i>${oppCustomerNameMap[opp.opportunityId]}</small>
                                        </c:if>
                                    </td>
                                    <td class="text-end fw-semibold text-success">
                                        <c:if test="${not empty opp.estimatedValue}">
                                            <fmt:formatNumber value="${opp.estimatedValue}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div id="oppPickerEmpty" class="text-center text-muted py-4" style="display:none;"><i class="bi bi-inbox me-1"></i>Không tìm thấy opportunity nào</div>
            </div>
        </div>
    </div>
</div>

<!-- ==================== Course Picker Modal ==================== -->
<div class="modal fade" id="coursePickerModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content border-0 shadow">
            <div class="modal-header py-2" style="border-bottom: 3px solid #0d6efd;">
                <div>
                    <h6 class="modal-title fw-bold mb-0"><i class="bi bi-mortarboard me-2"></i>${courseListLabel}</h6>
                    <small class="text-muted">Tick chọn các khóa học muốn thêm vào báo giá</small>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-0">
                <!-- Search -->
                <div class="p-3 border-bottom bg-light">
                    <div class="input-group input-group-sm">
                        <span class="input-group-text bg-white"><i class="bi bi-search text-muted"></i></span>
                        <input type="text" class="form-control" id="courseSearchInput" placeholder="Tìm kiếm khóa học..." oninput="filterCourses()">
                    </div>
                    <div class="d-flex justify-content-between align-items-center mt-2">
                        <small class="text-muted"><span id="courseSelectedCount">0</span> khóa học đã chọn</small>
                        <div class="d-flex gap-2">
                            <button type="button" class="btn btn-outline-secondary btn-sm py-0 px-2" style="font-size:.75rem;" onclick="toggleAllCourses(true)">Chọn tất cả</button>
                            <button type="button" class="btn btn-outline-secondary btn-sm py-0 px-2" style="font-size:.75rem;" onclick="toggleAllCourses(false)">Bỏ chọn</button>
                        </div>
                    </div>
                </div>
                <!-- Course table -->
                <div class="table-responsive" style="max-height: 400px;">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light sticky-top">
                            <tr>
                                <th style="width:40px;" class="text-center"><input type="checkbox" class="form-check-input" id="courseCheckAll" onchange="toggleAllCourses(this.checked)"></th>
                                <th>Mã</th>
                                <th>Tên khóa học</th>
                                <th class="text-end">Giá</th>
                                <c:if test="${isCustomerOpp}"><th>Trạng thái</th></c:if>
                            </tr>
                        </thead>
                        <tbody id="coursePickerBody">
                            <c:forEach var="course" items="${courseList}">
                                <tr class="course-picker-row" data-name="${course.courseName}" data-code="${course.courseCode}">
                                    <td class="text-center">
                                        <input type="checkbox" class="form-check-input course-check"
                                               value="${course.courseId}"
                                               data-name="${course.courseName}"
                                               data-code="${course.courseCode}"
                                               data-price="${course.price}"
                                               onchange="updateSelectedCount()">
                                    </td>
                                    <td><small class="text-muted">${course.courseCode}</small></td>
                                    <td class="fw-medium">${course.courseName}</td>
                                    <td class="text-end fw-semibold text-success">
                                        <fmt:formatNumber value="${course.price}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ
                                    </td>
                                    <c:if test="${isCustomerOpp}">
                                        <td>
                                            <c:choose>
                                                <c:when test="${course.learningStatus == 'Completed'}"><span class="badge bg-success-subtle text-success">Hoàn thành</span></c:when>
                                                <c:when test="${course.learningStatus == 'InProgress'}"><span class="badge bg-primary-subtle text-primary">Đang học</span></c:when>
                                                <c:when test="${course.learningStatus == 'NotStarted'}"><span class="badge bg-secondary-subtle text-secondary">Chưa bắt đầu</span></c:when>
                                                <c:otherwise><span class="badge bg-secondary-subtle text-secondary">${course.learningStatus}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                    </c:if>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div id="coursePickerEmpty" class="text-center text-muted py-4" style="display:none;">
                    <i class="bi bi-search"></i> Không tìm thấy khóa học nào
                </div>
            </div>
            <div class="modal-footer py-2">
                <button type="button" class="btn btn-light btn-sm" data-bs-dismiss="modal">Hủy</button>
                <button type="button" class="btn btn-primary btn-sm" onclick="confirmCourseSelection()">
                    <i class="bi bi-check-lg me-1"></i>Thêm <span id="confirmCount">0</span> khóa học
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    // ==================== Opportunity Picker Modal ====================
    var oppModal = null;
    function getOppModal() {
        if (!oppModal) oppModal = new bootstrap.Modal(document.getElementById('oppPickerModal'));
        return oppModal;
    }

    function openOppPicker() {
        var inp = document.getElementById('oppSearchInput');
        if (inp) inp.value = '';
        filterOppRows();
        getOppModal().show();
    }

    function filterOppRows() {
        var query = (document.getElementById('oppSearchInput').value || '').toLowerCase().trim();
        var rows = document.querySelectorAll('.opp-picker-row');
        var visible = 0;
        rows.forEach(function(row) {
            var text = (row.getAttribute('data-code') || '') + ' ' + (row.getAttribute('data-name') || '') + ' ' +
                       (row.getAttribute('data-lead-name') || '') + ' ' + (row.getAttribute('data-customer-name') || '');
            var match = !query || text.toLowerCase().indexOf(query) >= 0;
            row.style.display = match ? '' : 'none';
            if (match) visible++;
        });
        document.getElementById('oppPickerEmpty').style.display = visible === 0 ? '' : 'none';
    }

    function confirmOppSelection(row) {
        var id = row.getAttribute('data-id');
        var code = row.getAttribute('data-code') || '';
        var name = row.getAttribute('data-name') || '';
        var leadName = row.getAttribute('data-lead-name') || '';
        var custName = row.getAttribute('data-customer-name') || '';

        var hidden = document.getElementById('hiddenOppId');
        if (hidden) hidden.value = id;

        var previewName = document.getElementById('oppPreviewName');
        if (previewName) previewName.textContent = code + ' - ' + name;

        var contactParts = [];
        if (leadName) contactParts.push('Lead: ' + leadName);
        if (custName) contactParts.push('Customer: ' + custName);
        var previewContact = document.getElementById('oppPreviewContact');
        if (previewContact) previewContact.textContent = contactParts.join(' | ') || 'Không có lead/customer';

        var preview = document.getElementById('oppSelectedPreview');
        var btn = document.getElementById('oppPickerOpenBtn');
        if (preview) preview.style.display = '';
        if (btn) btn.style.display = 'none';

        getOppModal().hide();
    }

    function clearOppSelection() {
        var hidden = document.getElementById('hiddenOppId');
        if (hidden) hidden.value = '';
        var preview = document.getElementById('oppSelectedPreview');
        var btn = document.getElementById('oppPickerOpenBtn');
        if (preview) preview.style.display = 'none';
        if (btn) btn.style.display = '';
    }

    // Init: if editing and opp already selected, show preview
    (function() {
        var hidden = document.getElementById('hiddenOppId');
        if (hidden && hidden.value) {
            var row = document.querySelector('.opp-picker-row[data-id="' + hidden.value + '"]');
            if (row) confirmOppSelection(row);
        }
    })();

    // ==================== Course Picker Modal ====================
    var courseModal = null;
    function getCourseModal() {
        if (!courseModal) courseModal = new bootstrap.Modal(document.getElementById('coursePickerModal'));
        return courseModal;
    }

    function openCoursePicker() {
        // Uncheck all first
        document.querySelectorAll('.course-check').forEach(function(cb) { cb.checked = false; });
        document.getElementById('courseCheckAll').checked = false;

        // Pre-check courses already in the items table
        var existingIds = [];
        document.querySelectorAll('#itemsBody input[name="itemCourseId"]').forEach(function(inp) {
            if (inp.value) existingIds.push(inp.value);
        });
        document.querySelectorAll('.course-check').forEach(function(cb) {
            if (existingIds.indexOf(cb.value) >= 0) cb.checked = true;
        });

        // Reset search
        document.getElementById('courseSearchInput').value = '';
        filterCourses();
        updateSelectedCount();
        getCourseModal().show();
    }

    function filterCourses() {
        var query = document.getElementById('courseSearchInput').value.toLowerCase().trim();
        var rows = document.querySelectorAll('.course-picker-row');
        var visible = 0;
        rows.forEach(function(row) {
            var name = (row.getAttribute('data-name') || '').toLowerCase();
            var code = (row.getAttribute('data-code') || '').toLowerCase();
            var match = !query || name.indexOf(query) >= 0 || code.indexOf(query) >= 0;
            row.style.display = match ? '' : 'none';
            if (match) visible++;
        });
        document.getElementById('coursePickerEmpty').style.display = visible === 0 ? '' : 'none';
    }

    function toggleAllCourses(checked) {
        document.querySelectorAll('.course-picker-row').forEach(function(row) {
            if (row.style.display !== 'none') {
                var cb = row.querySelector('.course-check');
                if (cb) cb.checked = checked;
            }
        });
        document.getElementById('courseCheckAll').checked = checked;
        updateSelectedCount();
    }

    function updateSelectedCount() {
        var count = document.querySelectorAll('.course-check:checked').length;
        document.getElementById('courseSelectedCount').textContent = count;
        document.getElementById('confirmCount').textContent = count;
    }

    function confirmCourseSelection() {
        var checked = document.querySelectorAll('.course-check:checked');
        if (checked.length === 0) {
            getCourseModal().hide();
            return;
        }

        // Get existing course IDs to avoid duplicates
        var existingIds = [];
        document.querySelectorAll('#itemsBody input[name="itemCourseId"]').forEach(function(inp) {
            if (inp.value) existingIds.push(inp.value);
        });

        // Remove existing course items that are now unchecked
        var checkedIds = [];
        checked.forEach(function(cb) { checkedIds.push(cb.value); });
        document.querySelectorAll('#itemsBody tr.item-row').forEach(function(row) {
            var cid = row.querySelector('input[name="itemCourseId"]');
            if (cid && cid.value && checkedIds.indexOf(cid.value) < 0) {
                row.remove();
            }
        });

        // Add new courses
        var tbody = document.getElementById('itemsBody');
        checked.forEach(function(cb) {
            if (existingIds.indexOf(cb.value) >= 0) return; // already exists
            var name = cb.getAttribute('data-name') || '';
            var price = cb.getAttribute('data-price') || '0';
            var tr = document.createElement('tr');
            tr.className = 'item-row';
            tr.innerHTML =
                '<td>' +
                    '<input type="hidden" name="itemCourseId" value="' + cb.value + '">' +
                    '<input type="hidden" name="itemType" value="Course">' +
                    '<span class="badge bg-primary-subtle text-primary"><i class="bi bi-mortarboard me-1"></i>Khóa học</span>' +
                '</td>' +
                '<td><input type="text" class="form-control form-control-sm" name="itemDescription" value="' + escapeHtml(name) + '"></td>' +
                '<td><input type="number" class="form-control form-control-sm item-qty" name="itemQuantity" value="1" min="1" onchange="calcLine(this)"></td>' +
                '<td><input type="text" class="form-control form-control-sm item-price" name="itemUnitPrice" value="' + price + '" onchange="calcLine(this)"></td>' +
                '<td><input type="text" class="form-control form-control-sm item-disc" name="itemDiscount" value="0" onchange="calcLine(this)"></td>' +
                '<td class="text-end fw-semibold item-total">' + formatNumber(Math.round(parseFloat(price))) + ' đ</td>' +
                '<td><button type="button" class="btn btn-sm btn-outline-danger" onclick="removeItem(this)"><i class="bi bi-trash"></i></button></td>';
            tbody.appendChild(tr);
        });

        getCourseModal().hide();
        toggleEmptyState();
        calcGrandTotal();
    }

    // ==================== Manual item (Service/Other) ====================
    function addManualItem() {
        var tbody = document.getElementById('itemsBody');
        var tr = document.createElement('tr');
        tr.className = 'item-row';
        tr.innerHTML =
            '<td>' +
                '<input type="hidden" name="itemCourseId" value="">' +
                '<input type="hidden" name="itemType" value="Service">' +
                '<span class="badge bg-info-subtle text-info"><i class="bi bi-gear me-1"></i>Dịch vụ</span>' +
            '</td>' +
            '<td><input type="text" class="form-control form-control-sm" name="itemDescription" placeholder="Mô tả dịch vụ..."></td>' +
            '<td><input type="number" class="form-control form-control-sm item-qty" name="itemQuantity" value="1" min="1" onchange="calcLine(this)"></td>' +
            '<td><input type="text" class="form-control form-control-sm item-price" name="itemUnitPrice" value="0" onchange="calcLine(this)"></td>' +
            '<td><input type="text" class="form-control form-control-sm item-disc" name="itemDiscount" value="0" onchange="calcLine(this)"></td>' +
            '<td class="text-end fw-semibold item-total">0 đ</td>' +
            '<td><button type="button" class="btn btn-sm btn-outline-danger" onclick="removeItem(this)"><i class="bi bi-trash"></i></button></td>';
        tbody.appendChild(tr);
        toggleEmptyState();
    }

    // ==================== Item calculations ====================
    function removeItem(btn) {
        btn.closest('tr').remove();
        toggleEmptyState();
        calcGrandTotal();
    }

    function toggleEmptyState() {
        var rows = document.querySelectorAll('#itemsBody .item-row');
        var empty = document.getElementById('itemsEmpty');
        var table = document.getElementById('itemsTable');
        if (rows.length === 0) {
            if (empty) empty.style.display = '';
            if (table) table.style.display = 'none';
        } else {
            if (empty) empty.style.display = 'none';
            if (table) table.style.display = '';
        }
    }

    function calcLine(input) {
        var row = input.closest('tr');
        var qty = parseInt(row.querySelector('.item-qty').value) || 0;
        var price = parseFloat(row.querySelector('.item-price').value.replace(/,/g, '')) || 0;
        var disc = parseInt(row.querySelector('.item-disc').value.replace('%', '')) || 0;
        var total = qty * price;
        if (disc > 0) total = total - (total * disc / 100);
        row.querySelector('.item-total').textContent = formatNumber(Math.round(total)) + ' đ';
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
        if (el) el.textContent = formatNumber(subtotal) + ' đ';
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
        if (gt) gt.textContent = formatNumber(Math.round(total)) + ' đ';
    }

    function formatNumber(num) {
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    }

    function escapeHtml(str) {
        var div = document.createElement('div');
        div.textContent = str;
        return div.innerHTML.replace(/"/g, '&quot;');
    }

    document.addEventListener('DOMContentLoaded', function() {
        toggleEmptyState();
        calcGrandTotal();
    });
</script>
