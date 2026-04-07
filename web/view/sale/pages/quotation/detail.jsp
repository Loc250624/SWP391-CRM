<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- Toast messages -->
<c:if test="${param.sent == '1'}">
    <script>document.addEventListener('DOMContentLoaded', function(){ CRM.showToast('Đã gửi báo giá thành công!', 'success'); });</script>
</c:if>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">Chi tiết Báo giá</h4>
        <p class="text-muted mb-0">${quotation.quotationCode} - ${quotation.title}</p>
    </div>
    <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/sale/quotation/list" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left me-1"></i>Quay lại</a>
        <c:if test="${quotation.status == 'Sent'}">
            <form method="POST" action="${pageContext.request.contextPath}/sale/quotation/send" style="display:inline;">
                <input type="hidden" name="quotationId" value="${quotation.quotationId}">
                <button type="submit" class="btn btn-warning btn-sm"><i class="bi bi-send me-1"></i>Gửi lại</button>
            </form>
        </c:if>
    </div>
</div>

<div class="row g-4">
    <div class="col-lg-8">
        <!-- Basic Info -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="text-muted small">Mã báo giá</label>
                        <div class="fw-medium">${quotation.quotationCode}</div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Phiên bản</label>
                        <div class="fw-medium">v${quotation.version}</div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Opportunity</label>
                        <div class="fw-medium">
                            <c:choose>
                                <c:when test="${not empty linkedOpp}">
                                    <a href="${pageContext.request.contextPath}/sale/opportunity/detail?id=${linkedOpp.opportunityId}" class="text-decoration-none">
                                        ${linkedOpp.opportunityCode} - ${linkedOpp.opportunityName}
                                    </a>
                                </c:when>
                                <c:otherwise><span class="text-muted">-</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Khách hàng / Lead</label>
                        <div class="fw-medium">
                            <c:if test="${not empty linkedCustomer}">
                                <i class="bi bi-building text-success me-1"></i>${linkedCustomer.fullName}
                            </c:if>
                            <c:if test="${not empty linkedLead}">
                                <i class="bi bi-person text-primary me-1"></i>${linkedLead.fullName}
                            </c:if>
                            <c:if test="${empty linkedCustomer && empty linkedLead}">
                                <span class="text-muted">-</span>
                            </c:if>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Ngày tạo</label>
                        <div>
                            <c:choose>
                                <c:when test="${not empty quotation.createdAt}">${quotation.createdAt.toString().substring(0, 10)}</c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="text-muted small">Hiệu lực đến</label>
                        <div>
                            <c:choose>
                                <c:when test="${not empty quotation.validUntil}">${quotation.validUntil}</c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <c:if test="${not empty creatorName}">
                        <div class="col-md-6">
                            <label class="text-muted small">Người tạo</label>
                            <div class="fw-medium">${creatorName}</div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Items -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Hạng mục</h6></div>
            <div class="card-body pt-0">
                <div class="table-responsive">
                    <table class="table align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Khóa học / Dịch vụ</th>
                                <th class="text-center">SL</th>
                                <th class="text-end">Đơn giá</th>
                                <th class="text-end">Giảm giá</th>
                                <th class="text-end">Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty items}">
                                    <c:forEach var="item" items="${items}">
                                        <tr>
                                            <td>
                                                ${item.description}
                                                <c:if test="${item.isOptional == true}">
                                                    <span class="badge bg-secondary-subtle text-secondary ms-1">Tùy chọn</span>
                                                </c:if>
                                            </td>
                                            <td class="text-center">${item.quantity}</td>
                                            <td class="text-end">
                                                <c:if test="${not empty item.unitPrice}">
                                                    <fmt:formatNumber value="${item.unitPrice}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ
                                                </c:if>
                                                <c:if test="${empty item.unitPrice}">-</c:if>
                                            </td>
                                            <td class="text-end">
                                                <c:choose>
                                                    <c:when test="${not empty item.discountPercent && item.discountPercent > 0}">${item.discountPercent}%</c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end fw-semibold">
                                                <c:if test="${not empty item.lineTotal}">
                                                    <fmt:formatNumber value="${item.lineTotal}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ
                                                </c:if>
                                                <c:if test="${empty item.lineTotal}">-</c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr><td colspan="5" class="text-center text-muted py-3">Chưa có hạng mục nào</td></tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                        <c:if test="${not empty items}">
                            <tfoot class="table-light">
                                <c:if test="${not empty quotation.subtotal && quotation.subtotal > 0}">
                                    <tr>
                                        <td colspan="4" class="text-end">Tổng phụ:</td>
                                        <td class="text-end fw-semibold"><fmt:formatNumber value="${quotation.subtotal}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</td>
                                    </tr>
                                </c:if>
                                <c:if test="${not empty quotation.discountAmount && quotation.discountAmount > 0}">
                                    <tr>
                                        <td colspan="4" class="text-end">Giảm giá<c:if test="${not empty quotation.discountPercent && quotation.discountPercent > 0}"> (${quotation.discountPercent}%)</c:if>:</td>
                                        <td class="text-end text-danger">-<fmt:formatNumber value="${quotation.discountAmount}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</td>
                                    </tr>
                                </c:if>
                                <c:if test="${not empty quotation.taxAmount && quotation.taxAmount > 0}">
                                    <tr>
                                        <td colspan="4" class="text-end">Thuế<c:if test="${not empty quotation.taxPercent && quotation.taxPercent > 0}"> (${quotation.taxPercent}%)</c:if>:</td>
                                        <td class="text-end"><fmt:formatNumber value="${quotation.taxAmount}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</td>
                                    </tr>
                                </c:if>
                                <c:if test="${not empty quotation.totalAmount && quotation.totalAmount > 0}">
                                    <tr>
                                        <td colspan="4" class="text-end fw-bold">Tổng cộng:</td>
                                        <td class="text-end fw-bold text-success fs-5"><fmt:formatNumber value="${quotation.totalAmount}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</td>
                                    </tr>
                                </c:if>
                            </tfoot>
                        </c:if>
                    </table>
                </div>
            </div>
        </div>

        <!-- Terms -->
        <c:if test="${not empty quotation.paymentTerms || not empty quotation.termsConditions || not empty quotation.deliveryTerms}">
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Điều khoản</h6></div>
                <div class="card-body">
                    <c:if test="${not empty quotation.paymentTerms}">
                        <div class="mb-3">
                            <label class="text-muted small fw-semibold">Điều khoản thanh toán</label>
                            <p class="mb-0" style="white-space: pre-wrap;">${quotation.paymentTerms}</p>
                        </div>
                    </c:if>
                    <c:if test="${not empty quotation.deliveryTerms}">
                        <div class="mb-3">
                            <label class="text-muted small fw-semibold">Điều khoản giao hàng</label>
                            <p class="mb-0" style="white-space: pre-wrap;">${quotation.deliveryTerms}</p>
                        </div>
                    </c:if>
                    <c:if test="${not empty quotation.termsConditions}">
                        <div>
                            <label class="text-muted small fw-semibold">Điều kiện chung</label>
                            <p class="mb-0" style="white-space: pre-wrap;">${quotation.termsConditions}</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </c:if>

        <!-- Notes -->
        <c:if test="${not empty quotation.notes || not empty quotation.description}">
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Ghi chú</h6></div>
                <div class="card-body">
                    <c:if test="${not empty quotation.description}">
                        <div class="mb-2">
                            <label class="text-muted small fw-semibold">Mô tả</label>
                            <p class="mb-0" style="white-space: pre-wrap;">${quotation.description}</p>
                        </div>
                    </c:if>
                    <c:if test="${not empty quotation.notes}">
                        <div>
                            <label class="text-muted small fw-semibold">Ghi chú</label>
                            <p class="mb-0" style="white-space: pre-wrap;">${quotation.notes}</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </c:if>

        <!-- Tracking Logs -->
        <c:if test="${not empty trackingLogs}">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Nhật ký hoạt động</h6></div>
                <div class="card-body pt-0">
                    <div class="table-responsive">
                        <table class="table table-sm align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Sự kiện</th>
                                    <th>Thời gian</th>
                                    <th>IP</th>
                                    <th>Trình duyệt</th>
                                    <th>Thiết bị</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="log" items="${trackingLogs}">
                                    <tr>
                                        <td>
                                            <c:choose>
                                                <c:when test="${log.eventType == 'CREATED'}"><span class="badge bg-primary-subtle text-primary">Tạo mới</span></c:when>
                                                <c:when test="${log.eventType == 'UPDATED'}"><span class="badge bg-info-subtle text-info">Cập nhật</span></c:when>
                                                <c:when test="${log.eventType == 'VIEWED'}"><span class="badge bg-secondary-subtle text-secondary">Xem</span></c:when>
                                                <c:when test="${log.eventType == 'APPROVED'}"><span class="badge bg-success-subtle text-success">Duyệt</span></c:when>
                                                <c:when test="${log.eventType == 'REJECTED'}"><span class="badge bg-danger-subtle text-danger">Từ chối</span></c:when>
                                                <c:when test="${log.eventType == 'SENT'}"><span class="badge bg-warning-subtle text-warning">Gửi</span></c:when>
                                                <c:otherwise><span class="badge bg-secondary-subtle text-secondary">${log.eventType}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><small class="text-muted">
                                            <c:if test="${not empty log.eventDate}">${log.eventDate.toString().substring(0, 16).replace('T', ' ')}</c:if>
                                        </small></td>
                                        <td><small class="text-muted">${log.ipAddress}</small></td>
                                        <td><small class="text-muted">${log.browser}</small></td>
                                        <td><small class="text-muted">${log.deviceType}</small></td>
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
        <!-- Status -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Trạng thái</h6></div>
            <div class="card-body">
                <div class="mb-3">
                    <c:choose>
                        <c:when test="${quotation.status == 'Draft'}"><span class="badge bg-info-subtle text-info fs-6 px-3 py-2">Nháp</span></c:when>
                        <c:when test="${quotation.status == 'Approved'}"><span class="badge bg-success-subtle text-success fs-6 px-3 py-2">Đã xử lý</span></c:when>
                        <c:when test="${quotation.status == 'Sent'}"><span class="badge bg-warning-subtle text-warning fs-6 px-3 py-2">Đã gửi - Chờ phản hồi</span></c:when>
                        <c:when test="${quotation.status == 'Accepted'}"><span class="badge bg-primary-subtle text-primary fs-6 px-3 py-2">Khách chấp nhận</span></c:when>
                        <c:when test="${quotation.status == 'Rejected'}"><span class="badge bg-danger-subtle text-danger fs-6 px-3 py-2">Từ chối</span></c:when>
                        <c:otherwise><span class="badge bg-secondary-subtle text-secondary fs-6 px-3 py-2">${quotation.status}</span></c:otherwise>
                    </c:choose>
                </div>

                <!-- Sent info -->
                <c:if test="${not empty quotation.sentDate}">
                    <div class="mb-3">
                        <label class="text-muted small">Gửi ngày</label>
                        <div>${quotation.sentDate.toString().substring(0, 16).replace('T', ' ')}</div>
                    </div>
                    <c:if test="${not empty senderName}">
                        <div class="mb-3">
                            <label class="text-muted small">Người gửi</label>
                            <div class="fw-medium">${senderName}</div>
                        </div>
                    </c:if>
                </c:if>

                <!-- View tracking -->
                <c:if test="${not empty quotation.lastViewedDate}">
                    <div class="mb-3">
                        <label class="text-muted small">Lần xem cuối</label>
                        <div>${quotation.lastViewedDate.toString().substring(0, 16).replace('T', ' ')}</div>
                    </div>
                </c:if>
                <c:if test="${not empty quotation.viewCount && quotation.viewCount > 0}">
                    <div>
                        <label class="text-muted small">Số lần xem</label>
                        <div class="fw-bold">${quotation.viewCount} lần</div>
                    </div>
                </c:if>

                <!-- Rejection info -->
                <c:if test="${not empty quotation.rejectedDate}">
                    <hr>
                    <div class="mb-3">
                        <label class="text-muted small">Từ chối ngày</label>
                        <div class="text-danger">${quotation.rejectedDate.toString().substring(0, 16).replace('T', ' ')}</div>
                    </div>
                    <c:if test="${not empty quotation.rejectionReason}">
                        <div>
                            <label class="text-muted small">Lý do từ chối</label>
                            <div>${quotation.rejectionReason}</div>
                        </div>
                    </c:if>
                </c:if>

                <!-- Customer acceptance -->
                <c:if test="${not empty quotation.acceptedDate}">
                    <hr>
                    <div class="mb-3">
                        <label class="text-muted small">Khách chấp nhận ngày</label>
                        <div class="text-success fw-medium">${quotation.acceptedDate.toString().substring(0, 16).replace('T', ' ')}</div>
                    </div>
                    <c:if test="${not empty quotation.acceptedByName}">
                        <div class="mb-3">
                            <label class="text-muted small">Người chấp nhận</label>
                            <div>${quotation.acceptedByName} <c:if test="${not empty quotation.acceptedByEmail}"><small class="text-muted">(${quotation.acceptedByEmail})</small></c:if></div>
                        </div>
                    </c:if>
                </c:if>

                <!-- Customer rejection -->
                <c:if test="${not empty quotation.customerRejectedDate}">
                    <hr>
                    <div class="mb-3">
                        <label class="text-muted small">Khách từ chối ngày</label>
                        <div class="text-danger">${quotation.customerRejectedDate.toString().substring(0, 16).replace('T', ' ')}</div>
                    </div>
                    <c:if test="${not empty quotation.customerRejectionReason}">
                        <div>
                            <label class="text-muted small">Lý do khách từ chối</label>
                            <div>${quotation.customerRejectionReason}</div>
                        </div>
                    </c:if>
                </c:if>
            </div>
        </div>

        <!-- Version History -->
        <c:if test="${not empty versions}">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold">Lịch sử phiên bản</h6></div>
                <div class="card-body">
                    <div class="d-flex flex-column gap-2">
                        <c:forEach var="ver" items="${versions}" varStatus="loop">
                            <div class="d-flex justify-content-between align-items-center p-2 ${loop.first ? 'bg-primary-subtle' : 'bg-light'} rounded">
                                <div>
                                    <div class="fw-medium">v${ver.versionNumber}${loop.first ? ' (Hiện tại)' : ''}</div>
                                    <small class="text-muted">
                                        <c:if test="${not empty ver.createdAt}">${ver.createdAt.toString().substring(0, 10)}</c:if>
                                    </small>
                                    <c:if test="${not empty ver.changeSummary}">
                                        <div><small class="text-muted">${ver.changeSummary}</small></div>
                                    </c:if>
                                </div>
                                <c:if test="${not empty ver.totalAmount}">
                                    <span class="fw-semibold ${loop.first ? '' : 'text-muted'}"><fmt:formatNumber value="${ver.totalAmount}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</span>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </c:if>
    </div>
</div>

