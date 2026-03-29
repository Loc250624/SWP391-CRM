<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid px-4 py-3">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
            <h2 class="fw-bold mb-0">Nhật ký hệ thống (Audit Logs)</h2>
            <p class="text-muted small mb-0">Truy vết mọi thay đổi dữ liệu và hành động của người dùng</p>
        </div>
    </div>

    <!-- Filter Card -->
    <div class="card border-0 shadow-sm rounded-4 mb-4">
        <div class="card-body p-3">
            <form method="get" class="row g-3 align-items-end">
                <div class="col-md-3">
                    <label class="form-label small fw-bold text-muted">Hành động</label>
                    <select name="action" class="form-select bg-light border-0">
                        <option value="">Tất cả</option>
                        <option value="Create" ${param.action == 'Create' ? 'selected' : ''}>Create</option>
                        <option value="Update" ${param.action == 'Update' ? 'selected' : ''}>Update</option>
                        <option value="Delete" ${param.action == 'Delete' ? 'selected' : ''}>Delete</option>
                        <option value="Login" ${param.action == 'Login' ? 'selected' : ''}>Login</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label small fw-bold text-muted">Thực thể (Entity)</label>
                    <select name="entityType" class="form-select bg-light border-0">
                        <option value="">Tất cả</option>
                        <option value="Customer" ${param.entityType == 'Customer' ? 'selected' : ''}>Khách hàng</option>
                        <option value="Lead" ${param.entityType == 'Lead' ? 'selected' : ''}>Lead</option>
                        <option value="User" ${param.entityType == 'User' ? 'selected' : ''}>Tài khoản</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label small fw-bold text-muted">Tìm kiếm</label>
                    <input type="text" name="q" class="form-control bg-light border-0" placeholder="IP, giá trị, user..." value="${fn:escapeXml(q)}">
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-indigo w-100 text-white">Lọc</button>
                </div>
            </form>
        </div>
    </div>

    <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="bg-light">
                    <tr>
                        <th class="ps-4 py-3 border-0">Thời gian</th>
                        <th class="py-3 border-0">Hành động</th>
                        <th class="py-3 border-0">Đối tượng tác động</th>
                        <th class="py-3 border-0">Người thực hiện</th>
                        <th class="py-3 border-0">Địa chỉ IP</th>
                        <th class="pe-4 py-3 border-0 text-end">Chi tiết</th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${empty auditLogs}">
                        <tr>
                            <td colspan="6" class="text-center py-5 text-muted">Không tìm thấy dữ liệu nhật ký phù hợp.</td>
                        </tr>
                    </c:if>
                    <c:forEach items="${auditLogs}" var="log">
                        <tr>
                            <td class="ps-4 small">
                                ${log.createdAt}
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${log.action == 'Create'}"><span class="badge bg-success-subtle text-success border border-success">Create</span></c:when>
                                    <c:when test="${log.action == 'Update'}"><span class="badge bg-warning-subtle text-warning border border-warning">Update</span></c:when>
                                    <c:when test="${log.action == 'Delete'}"><span class="badge bg-danger-subtle text-danger border border-danger">Delete</span></c:when>
                                    <c:otherwise><span class="badge bg-info-subtle text-info border border-info">${log.action}</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="fw-bold">${log.entityType}</div>
                                <div class="text-muted small">ID: ${log.entityId}</div>
                            </td>
                            <td>
                                <div class="fw-medium">${fn:escapeXml(log.userName)}</div>
                                <div class="text-muted extra-small">${fn:escapeXml(log.userEmail)}</div>
                            </td>
                            <td class="small text-muted">${log.ipAddress}</td>
                            <td class="pe-4 text-end">
                                <button class="btn btn-sm btn-light border-0" type="button" data-bs-toggle="collapse" data-bs-target="#log-${log.logId}">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </td>
                        </tr>
                        <tr class="collapse" id="log-${log.logId}">
                            <td colspan="6" class="bg-light p-4">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <div class="p-3 bg-white border rounded-3 h-100">
                                            <h6 class="small fw-bold text-muted mb-2 text-uppercase">Giá trị cũ</h6>
                                            <pre class="mb-0 extra-small text-danger" style="white-space: pre-wrap;">${log.oldValues}</pre>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="p-3 bg-white border rounded-3 h-100">
                                            <h6 class="small fw-bold text-muted mb-2 text-uppercase">Giá trị mới</h6>
                                            <pre class="mb-0 extra-small text-success" style="white-space: pre-wrap;">${log.newValues}</pre>
                                        </div>
                                    </div>
                                    <div class="col-12 mt-3">
                                        <div class="extra-small text-muted">
                                            <i class="bi bi-browser-edge me-1"></i> User Agent: ${log.userAgent}
                                        </div>
                                    </div>
                                </div>
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
                    <a class="page-link border-0 shadow-sm rounded-3 me-2" href="?page=${currentPage - 1}&action=${param.action}&entityType=${param.entityType}&q=${param.q}"><i class="bi bi-chevron-left"></i></a>
                </li>
                <c:forEach begin="1" end="${totalPages}" var="p">
                    <li class="page-item mx-1">
                        <a class="page-link border-0 shadow-sm rounded-3 ${p == currentPage ? 'active bg-indigo text-white' : 'bg-white text-dark'}" 
                           href="?page=${p}&action=${param.action}&entityType=${param.entityType}&q=${param.q}">${p}</a>
                    </li>
                </c:forEach>
                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link border-0 shadow-sm rounded-3 ms-2" href="?page=${currentPage + 1}&action=${param.action}&entityType=${param.entityType}&q=${param.q}"><i class="bi bi-chevron-right"></i></a>
                </li>
            </ul>
        </nav>
    </c:if>
</div>

<style>
    .bg-indigo { background-color: #4f46e5 !important; }
    .btn-indigo { background-color: #4f46e5 !important; }
    .extra-small { font-size: 0.75rem; }
    .page-link.active { background-color: #4f46e5 !important; }
    pre { font-family: monospace; }
</style>
