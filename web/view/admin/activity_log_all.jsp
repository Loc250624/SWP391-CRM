<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid px-4 py-3">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
            <h2 class="fw-bold mb-0">Lịch sử chăm sóc (Tất cả)</h2>
            <p class="text-muted small mb-0">Theo dõi toàn bộ hoạt động tương tác với khách hàng và lead</p>
        </div>
    </div>

    <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="bg-light">
                    <tr>
                        <th class="ps-4 py-3 border-0">Thời gian</th>
                        <th class="py-3 border-0">Loại</th>
                        <th class="py-3 border-0">Đối tượng</th>
                        <th class="py-3 border-0">Nội dung</th>
                        <th class="py-3 border-0">Người thực hiện</th>
                        <th class="pe-4 py-3 border-0 text-end">Trạng thái</th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${empty activities}">
                        <tr>
                            <td colspan="6" class="text-center py-5">
                                <i class="bi bi-chat-square-text fs-1 text-muted opacity-25"></i>
                                <p class="text-muted mt-2">Chưa có hoạt động nào được ghi nhận.</p>
                            </td>
                        </tr>
                    </c:if>
                    <c:forEach items="${activities}" var="a">
                        <tr>
                            <td class="ps-4 small text-muted">
                                ${a.createdAt}
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${a.activityType == 'Call'}">
                                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle"><i class="bi bi-phone me-1"></i>Call</span>
                                    </c:when>
                                    <c:when test="${a.activityType == 'Email'}">
                                        <span class="badge bg-info-subtle text-info border border-info-subtle"><i class="bi bi-envelope me-1"></i>Email</span>
                                    </c:when>
                                    <c:when test="${a.activityType == 'Meeting'}">
                                        <span class="badge bg-success-subtle text-success border border-success-subtle"><i class="bi bi-people me-1"></i>Meeting</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-light text-dark border"><i class="bi bi-journal-text me-1"></i>${a.activityType}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="fw-bold text-dark">${fn:escapeXml(a.customerName)}</div>
                                <div class="text-muted extra-small">${a.relatedType}</div>
                            </td>
                            <td>
                                <div class="fw-medium">${fn:escapeXml(a.subject)}</div>
                                <div class="text-muted small text-truncate" style="max-width: 250px;">${fn:escapeXml(a.description)}</div>
                            </td>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <i class="bi bi-person-circle text-muted"></i>
                                    <span>${fn:escapeXml(a.performerName)}</span>
                                </div>
                            </td>
                            <td class="pe-4 text-end">
                                <c:choose>
                                    <c:when test="${a.status == 'Completed'}">
                                        <span class="badge bg-success-subtle text-success border border-success">Hoàn thành</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-warning-subtle text-warning border border-warning">${a.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Pagination -->
    <c:if test="${totalPages > 1}">
        <nav class="mt-4">
            <ul class="pagination justify-content-center">
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link border-0 shadow-sm rounded-3 me-2" href="?page=${currentPage - 1}"><i class="bi bi-chevron-left"></i></a>
                </li>
                <c:forEach begin="1" end="${totalPages}" var="p">
                    <li class="page-item mx-1">
                        <a class="page-link border-0 shadow-sm rounded-3 ${p == currentPage ? 'active bg-indigo text-white' : 'bg-white text-dark'}" 
                           href="?page=${p}">${p}</a>
                    </li>
                </c:forEach>
                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link border-0 shadow-sm rounded-3 ms-2" href="?page=${currentPage + 1}"><i class="bi bi-chevron-right"></i></a>
                </li>
            </ul>
        </nav>
    </c:if>
</div>

<style>
    .bg-indigo { background-color: #4f46e5 !important; }
    .text-indigo { color: #4f46e5 !important; }
    .extra-small { font-size: 0.75rem; }
    .page-link.active { background-color: #4f46e5 !important; }
</style>
