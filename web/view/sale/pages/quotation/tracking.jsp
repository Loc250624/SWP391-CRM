<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">Theo dõi Báo giá</h4>
        <p class="text-muted mb-0">Theo dõi trạng thái và tương tác của khách hàng với báo giá đã gửi</p>
    </div>
</div>

<!-- Overview Stats -->
<div class="row g-3 mb-4">
    <div class="col-md-3">
        <div class="card border-0 shadow-sm"><div class="card-body py-3">
            <div class="d-flex align-items-center">
                <div class="bg-primary bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-send text-primary fs-5"></i></div>
                <div><small class="text-muted">Đã gửi</small><h4 class="mb-0 fw-bold">${stats['sent'] != null ? stats['sent'] : 0}</h4></div>
            </div>
        </div></div>
    </div>
    <div class="col-md-3">
        <div class="card border-0 shadow-sm"><div class="card-body py-3">
            <div class="d-flex align-items-center">
                <div class="bg-info bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-eye text-info fs-5"></i></div>
                <div><small class="text-muted">Đã xem</small><h4 class="mb-0 fw-bold">${stats['viewed'] != null ? stats['viewed'] : 0}</h4></div>
            </div>
        </div></div>
    </div>
    <div class="col-md-3">
        <div class="card border-0 shadow-sm"><div class="card-body py-3">
            <div class="d-flex align-items-center">
                <div class="bg-success bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-check-circle text-success fs-5"></i></div>
                <div><small class="text-muted">Chấp nhận</small><h4 class="mb-0 fw-bold">${stats['accepted'] != null ? stats['accepted'] : 0}</h4></div>
            </div>
        </div></div>
    </div>
    <div class="col-md-3">
        <div class="card border-0 shadow-sm"><div class="card-body py-3">
            <div class="d-flex align-items-center">
                <div class="bg-warning bg-opacity-10 rounded-3 p-2 me-3"><i class="bi bi-clock text-warning fs-5"></i></div>
                <div><small class="text-muted">Sắp hết hạn</small><h4 class="mb-0 fw-bold">${stats['expiring'] != null ? stats['expiring'] : 0}</h4></div>
            </div>
        </div></div>
    </div>
</div>

<!-- Tracking Table -->
<div class="card border-0 shadow-sm">
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th>Báo giá</th>
                        <th>Khách hàng</th>
                        <th class="text-end">Giá trị</th>
                        <th>Trạng thái</th>
                        <th class="text-center">Lượt xem</th>
                        <th>Lần xem cuối</th>
                        <th>Thời gian xem</th>
                        <th>Hết hạn</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty trackingList}">
                            <c:forEach var="t" items="${trackingList}">
                                <tr>
                                    <td>
                                        <div class="fw-medium">${t.quotationCode}</div>
                                        <small class="text-muted">${t.title}</small>
                                    </td>
                                    <td>${not empty t.contactName ? t.contactName : '-'}</td>
                                    <td class="text-end fw-semibold">
                                        <c:if test="${not empty t.totalAmount && t.totalAmount > 0}">
                                            <fmt:formatNumber value="${t.totalAmount}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ
                                        </c:if>
                                        <c:if test="${empty t.totalAmount || t.totalAmount == 0}">-</c:if>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${t.status == 'Sent' && (t.viewCount == null || t.viewCount == 0)}">
                                                <span class="badge bg-warning-subtle text-warning">Chưa xem</span>
                                            </c:when>
                                            <c:when test="${t.status == 'Sent' && t.viewCount > 0}">
                                                <span class="badge bg-info-subtle text-info">Đã xem</span>
                                            </c:when>
                                            <c:when test="${t.status == 'Accepted'}">
                                                <span class="badge bg-success-subtle text-success">Đã chấp nhận</span>
                                            </c:when>
                                            <c:when test="${t.status == 'Rejected'}">
                                                <span class="badge bg-danger-subtle text-danger">Từ chối</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary-subtle text-secondary">${t.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <span class="badge bg-primary-subtle text-primary">${t.viewCount != null ? t.viewCount : 0} lần</span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty t.lastViewedDate}">
                                                <small>${t.lastViewedDate.toString().substring(0, 16).replace('T', ' ')}</small>
                                            </c:when>
                                            <c:otherwise><small class="text-muted">-</small></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty t.totalViewDurationSeconds && t.totalViewDurationSeconds > 0}">
                                                <small>
                                                    <c:choose>
                                                        <c:when test="${t.totalViewDurationSeconds >= 3600}">
                                                            <fmt:formatNumber value="${t.totalViewDurationSeconds / 3600}" maxFractionDigits="0"/> giờ
                                                            <fmt:formatNumber value="${(t.totalViewDurationSeconds % 3600) / 60}" maxFractionDigits="0"/> phút
                                                        </c:when>
                                                        <c:when test="${t.totalViewDurationSeconds >= 60}">
                                                            <fmt:formatNumber value="${t.totalViewDurationSeconds / 60}" maxFractionDigits="0"/> phút
                                                        </c:when>
                                                        <c:otherwise>${t.totalViewDurationSeconds} giây</c:otherwise>
                                                    </c:choose>
                                                </small>
                                            </c:when>
                                            <c:otherwise><small class="text-muted">-</small></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${t.status == 'Accepted'}">
                                                <span class="text-success"><i class="bi bi-check-circle"></i></span>
                                            </c:when>
                                            <c:when test="${not empty t.validUntil}">
                                                <jsp:useBean id="now" class="java.util.Date"/>
                                                <c:set var="validStr" value="${t.validUntil.toString()}"/>
                                                <small class="text-muted">${validStr}</small>
                                            </c:when>
                                            <c:otherwise><small class="text-muted">-</small></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/sale/quotation/detail?id=${t.quotationId}" class="btn btn-sm btn-light" title="Xem chi tiết">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr><td colspan="9" class="text-center text-muted py-4"><i class="bi bi-inbox me-1"></i>Chưa có báo giá nào đã gửi</td></tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>
