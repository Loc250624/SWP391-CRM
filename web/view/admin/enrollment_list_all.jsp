<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid px-4 py-3">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
            <h2 class="fw-bold mb-0">Khóa học đã mua (Tất cả)</h2>
            <p class="text-muted small mb-0">Danh sách toàn bộ các khóa học đã được khách hàng đăng ký và mua</p>
        </div>
    </div>

    <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="bg-light">
                    <tr>
                        <th class="ps-4 py-3 border-0">Khách hàng</th>
                        <th class="py-3 border-0">Khóa học</th>
                        <th class="py-3 border-0">Ngày đăng ký</th>
                        <th class="py-3 border-0">Số tiền</th>
                        <th class="py-3 border-0">Thanh toán</th>
                        <th class="pe-4 py-3 border-0 text-end">Tiến độ</th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${empty enrollments}">
                        <tr>
                            <td colspan="6" class="text-center py-5 text-muted">Chưa có bản ghi đăng ký khóa học nào.</td>
                        </tr>
                    </c:if>
                    <c:forEach items="${enrollments}" var="e">
                        <tr>
                            <td class="ps-4">
                                <div class="fw-bold text-dark">${fn:escapeXml(e.notes)}</div> <!-- Notes field used for customer name -->
                                <div class="text-muted extra-small">ID: ${e.customerId}</div>
                            </td>
                            <td>
                                <div class="fw-medium text-indigo">${e.courseName}</div>
                                <div class="text-muted extra-small">Mã: ${e.enrollmentCode}</div>
                            </td>
                            <td class="small text-muted">
                                ${e.enrolledDate}
                            </td>
                            <td class="fw-bold text-dark">
                                <fmt:formatNumber value="${e.finalAmount}" type="currency" currencySymbol="₫" />
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${e.paymentStatus == 'Paid' || e.paymentStatus == 'Completed'}">
                                        <span class="badge rounded-pill bg-success-subtle text-success border border-success px-3">${e.paymentStatus}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge rounded-pill bg-warning-subtle text-warning border border-warning px-3">${e.paymentStatus}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="pe-4 text-end">
                                <div class="d-flex align-items-center justify-content-end gap-2">
                                    <div class="progress" style="width: 100px; height: 6px;">
                                        <div class="progress-bar bg-indigo" role="progressbar" style="width: ${e.progressPercentage}%"></div>
                                    </div>
                                    <span class="small fw-medium">${e.progressPercentage}%</span>
                                </div>
                                <div class="text-muted extra-small mt-1">${e.learningStatus}</div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<style>
    .bg-indigo { background-color: #4f46e5 !important; }
    .text-indigo { color: #4f46e5 !important; }
    .extra-small { font-size: 0.75rem; }
</style>
