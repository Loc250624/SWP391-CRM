<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h4 class="mb-0 fw-bold">Lịch sử gửi Email</h4>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item"><a
                                    href="${pageContext.request.contextPath}/marketing/dashboard">Marketing</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Email Logs</li>
                        </ol>
                    </nav>
                </div>
            </div>

            <div class="card border-0 shadow-sm">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light text-muted small text-uppercase">
                            <tr>
                                <th class="ps-4">Thời gian</th>
                                <th>Người nhận</th>
                                <th>Chủ đề</th>
                                <th>Trạng thái</th>
                                <th class="text-center">Tương tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="log" items="${logs}">
                                <tr>
                                    <td class="ps-4">
                                        <div class="fw-semibold text-dark">${log.sentAt}</div>
                                    </td>
                                    <td>${log.recipientEmail}</td>
                                    <td>
                                        <div class="text-dark text-truncate" style="max-width:300px;">${log.subject}
                                        </div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${log.status == 'Sent'}">
                                                <span class="badge bg-success-subtle text-success">Đã gửi</span>
                                            </c:when>
                                            <c:when test="${log.status == 'Failed'}">
                                                <span class="badge bg-danger-subtle text-danger"
                                                    title="${log.errorMessage}">Thất bại</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span
                                                    class="badge bg-secondary-subtle text-secondary">${log.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <div class="d-inline-flex gap-3 small">
                                            <span title="Số lần mở"><i class="bi bi-eye text-primary"></i>
                                                ${log.openCount}</span>
                                            <span title="Số lần click"><i class="bi bi-cursor text-success"></i>
                                                ${log.clickCount}</span>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty logs}">
                                <tr>
                                    <td colspan="5" class="text-center py-5 text-muted">Chưa có lịch sử gửi email nào.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>