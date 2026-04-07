<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

            <div class="container-fluid px-4 py-3">
                <div class="d-flex align-items-center justify-content-between mb-4">
                    <div>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb mb-1">
                                <li class="breadcrumb-item"><a
                                        href="${pageContext.request.contextPath}/admin/customer/list"
                                        class="text-decoration-none">Khách hàng</a></li>
                                <li class="breadcrumb-item"><a
                                        href="${pageContext.request.contextPath}/admin/customer/360?id=${customer.customerId}"
                                        class="text-decoration-none">${fn:escapeXml(customer.fullName)}</a></li>
                                <li class="breadcrumb-item active">Nhật ký hoạt động</li>
                            </ol>
                        </nav>
                        <h2 class="fw-bold mb-0">Nhật ký hoạt động hệ thống</h2>
                        <p class="text-muted small mb-0">Theo dõi lịch sử chỉnh sửa thông tin khách hàng:
                            <b>${fn:escapeXml(customer.fullName)}</b></p>
                    </div>
                    <div>
                        <a class="btn btn-outline-secondary px-4 rounded-3"
                            href="${pageContext.request.contextPath}/admin/customer/360?id=${customer.customerId}">
                            <i class="bi bi-arrow-left me-2"></i>Quay lại 360
                        </a>
                    </div>
                </div>

                <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="bg-light">
                                    <tr>
                                        <th class="ps-4 py-3 border-0">Thời gian</th>
                                        <th class="py-3 border-0">Hành động</th>
                                        <th class="py-3 border-0">Người thực hiện</th>
                                        <th class="py-3 border-0">Giá trị cũ</th>
                                        <th class="py-3 border-0">Giá trị mới</th>
                                        <th class="pe-4 py-3 border-0">Thiết bị/IP</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:if test="${empty auditLogs}">
                                        <tr>
                                            <td colspan="6" class="text-center py-5 text-muted italic">Chưa có bản ghi
                                                hoạt động nào.</td>
                                        </tr>
                                    </c:if>
                                    <c:forEach items="${auditLogs}" var="log">
                                        <tr>
                                            <td class="ps-4 small fw-semibold text-dark">${log.createdAt}</td>
                                            <td>
                                                <span
                                                    class="badge ${log.action == 'UPDATE' ? 'bg-info' : (log.action == 'DELETE' ? 'bg-danger' : 'bg-success')} rounded-pill px-3">
                                                    ${log.action}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <i class="bi bi-person-circle text-muted"></i>
                                                    <span class="small fw-medium">User ID: ${log.userId}</span>
                                                </div>
                                            </td>
                                            <td class="small"><code
                                                    class="text-danger bg-danger-subtle p-1 rounded">${not empty log.oldValues ? log.oldValues : '---'}</code>
                                            </td>
                                            <td class="small"><code
                                                    class="text-success bg-success-subtle p-1 rounded">${not empty log.newValues ? log.newValues : '---'}</code>
                                            </td>
                                            <td class="pe-4 small text-muted">
                                                <div class="text-truncate" style="max-width: 150px;"
                                                    title="${log.userAgent}">${log.userAgent}</div>
                                                <div class="extra-small">IP: ${log.ipAddress}</div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <style>
                .extra-small {
                    font-size: 0.7rem;
                }
            </style>