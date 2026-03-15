<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid px-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h5 class="fw-bold text-dark m-0">
            <i class="bi bi-clock-history me-2 text-primary"></i>Lịch sử phiếu báo cáo
        </h5>
       <c:choose>
            <c:when test="${param.type eq 'Lead' || type eq 'Lead'}">
                <a href="leads" class="btn btn-sm btn-outline-secondary rounded-pill">
                    <i class="bi bi-arrow-left me-1"></i>Quay lại danh sách Lead
                </a>
            </c:when>
            <c:otherwise>
                <a href="customers" class="btn btn-sm btn-outline-secondary rounded-pill">
                    <i class="bi bi-arrow-left me-1"></i>Quay lại danh sách Khách hàng
                </a>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="bg-light">
                    <tr>
                        <th class="ps-4 border-0" style="width: 180px;">Thời gian tạo</th>
                        <th class="border-0" style="width: 250px;">Tiêu đề báo cáo</th>
                        <th class="border-0">Nội dung chi tiết</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${activities}" var="a">
                        <tr>
                            <td class="ps-4">
                                <div class="fw-bold text-dark small">${a.createdAt.toLocalDate()}</div>
                                <div class="text-muted small">${a.createdAt.toLocalTime()}</div>
                            </td>
                            <td>
                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-2 rounded-pill">
                                    <i class="bi bi-tag-fill me-1"></i>${a.subject}
                                </span>
                            </td>
                            <td class="text-wrap py-3">
                                <div class="text-muted small" style="max-width: 600px; line-height: 1.5;">
                                    ${a.description}
                                </div>
                            </td>
                            <td>
                                <div class="fw-bold text-dark small">${a.performerName}</div>
                                <div class="text-muted" style="font-size: 11px;">Nhân viên hỗ trợ</div>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty activities}">
                        <tr>
                            <td colspan="3" class="text-center py-5">
                                <div class="text-muted">
                                    <i class="bi bi-inbox display-4 d-block mb-3 text-light"></i>
                                    Chưa có dữ liệu báo cáo nào cho khách hàng này.
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>