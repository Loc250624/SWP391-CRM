<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

            <div class="category-container">
                <!-- ── Header Section ── -->
                <div class="d-flex align-items-center justify-content-between mb-4">
                    <div>
                        <h2 class="fw-bold mb-0">Danh mục Khóa học</h2>
                        <p class="text-muted small mb-0">Quản lý các loại hình khóa học và phân loại hệ thống</p>
                    </div>
                    <div class="d-flex gap-2">
                        <a class="btn btn-light border px-4 py-2 rounded-3 shadow-sm"
                            href="${pageContext.request.contextPath}/admin/category/export?q=${fn:escapeXml(q)}&active=${fn:escapeXml(active)}">
                            <i class="bi bi-file-earmark-spreadsheet me-2 text-success"></i>Xuất Excel
                        </a>
                        <a class="btn btn-indigo px-4 py-2 rounded-3 shadow-sm text-white"
                            style="background-color: #4f46e5; border-color: #4f46e5;"
                            href="${pageContext.request.contextPath}/admin/category/form">
                            <i class="bi bi-plus-lg me-2"></i>Thêm Danh mục mới
                        </a>
                    </div>
                </div>

                <!-- ── Filter & Search ── -->
                <div class="card border-0 shadow-sm rounded-4 mb-4">
                    <div class="card-body p-4">
                        <form method="get" action="${pageContext.request.contextPath}/admin/category/list"
                            class="row g-3 align-items-end">
                            <div class="col-md-5">
                                <label class="form-label small fw-bold text-muted">Tìm kiếm</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-0"><i
                                            class="bi bi-search text-muted"></i></span>
                                    <input type="text" name="q" class="form-control bg-light border-0"
                                        placeholder="Tên, mã hoặc mô tả..." value="${fn:escapeXml(q)}">
                                </div>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label small fw-bold text-muted">Trạng thái</label>
                                <select name="active" class="form-select bg-light border-0">
                                    <option value="">Tất cả</option>
                                    <option value="active" ${active=='active' ? 'selected' :''}>Đang hoạt động</option>
                                    <option value="inactive" ${active=='inactive' ? 'selected' :''}>Ngưng hoạt động
                                    </option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label small fw-bold text-muted">Hiển thị</label>
                                <select name="pageSize" class="form-select bg-light border-0">
                                    <option value="10" ${pageSize==10 ? 'selected' : '' }>10 dòng</option>
                                    <option value="20" ${pageSize==20 ? 'selected' : '' }>20 dòng</option>
                                    <option value="50" ${pageSize==50 ? 'selected' : '' }>50 dòng</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-indigo w-100 text-white"
                                    style="background-color: #4f46e5;">Lọc dữ liệu</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- ── Alerts ── -->
                <c:if test="${not empty msg}">
                    <c:choose>
                        <c:when test="${msg == 'saved'}">
                            <div class="alert alert-success border-0 shadow-sm d-flex align-items-center gap-2 mb-4">
                                <i class="bi bi-check-circle-fill"></i> Lưu thông tin danh mục thành công!
                            </div>
                        </c:when>
                        <c:when test="${msg == 'deleted'}">
                            <div class="alert alert-success border-0 shadow-sm d-flex align-items-center gap-2 mb-4">
                                <i class="bi bi-trash-fill"></i> Đã xóa danh mục thành công.
                            </div>
                        </c:when>
                        <c:when test="${msg == 'cannot_delete'}">
                            <div class="alert alert-danger border-0 shadow-sm d-flex align-items-center gap-2 mb-4">
                                <i class="bi bi-exclamation-triangle-fill"></i> Không thể xóa: Danh mục đang có
                                ${param.count} khóa học liên kết.
                            </div>
                        </c:when>
                    </c:choose>
                </c:if>

                <!-- ── Table ── -->
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="bg-light bg-opacity-50">
                                <tr>
                                    <th class="ps-4 py-3 border-0 text-uppercase small fw-bold text-muted">Mã</th>
                                    <th class="py-3 border-0 text-uppercase small fw-bold text-muted">Tên Danh mục</th>
                                    <th class="py-3 border-0 text-uppercase small fw-bold text-muted">Mô tả</th>
                                    <th class="py-3 border-0 text-uppercase small fw-bold text-muted">Trạng thái</th>
                                    <th class="pe-4 py-3 border-0 text-uppercase small fw-bold text-muted text-end">Hành
                                        động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:if test="${empty paged.items}">
                                    <tr>
                                        <td colspan="5" class="text-center py-5">
                                            <i class="bi bi-folder-x fs-1 text-muted"></i>
                                            <p class="text-muted mt-2">Không tìm thấy danh mục nào.</p>
                                        </td>
                                    </tr>
                                </c:if>
                                <c:forEach items="${paged.items}" var="cat">
                                    <tr>
                                        <td class="ps-4">
                                            <span
                                                class="badge bg-light text-dark border py-2 px-3 font-monospace">${fn:escapeXml(cat.categoryCode)}</span>
                                        </td>
                                        <td>
                                            <div class="fw-bold">${fn:escapeXml(cat.categoryName)}</div>
                                        </td>
                                        <td>
                                            <div class="text-muted small text-truncate" style="max-width: 250px;">
                                                ${fn:escapeXml(cat.description)}</div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${cat.isActive}">
                                                    <span
                                                        class="badge rounded-pill bg-success-subtle text-success border border-success px-3">Đang
                                                        mở</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span
                                                        class="badge rounded-pill bg-danger-subtle text-danger border border-danger px-3">Đã
                                                        đóng</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="pe-4 text-end">
                                            <div class="btn-group shadow-sm rounded-3">
                                                <a class="btn btn-white btn-sm border"
                                                    href="${pageContext.request.contextPath}/admin/category/form?id=${cat.categoryId}"
                                                    title="Sửa">
                                                    <i class="bi bi-pencil text-primary"></i>
                                                </a>
                                                <form method="post"
                                                    action="${pageContext.request.contextPath}/admin/category/list"
                                                    class="d-inline">
                                                    <input type="hidden" name="id" value="${cat.categoryId}" />
                                                    <input type="hidden" name="action" value="toggle" />
                                                    <button class="btn btn-white btn-sm border border-start-0"
                                                        type="submit" title="Đổi trạng thái">
                                                        <i
                                                            class="bi ${cat.isActive ? 'bi-toggle-on text-success' : 'bi-toggle-off text-muted'}"></i>
                                                    </button>
                                                </form>
                                                <form method="post"
                                                    action="${pageContext.request.contextPath}/admin/category/list"
                                                    class="d-inline"
                                                    onsubmit="return confirm('Xác nhận xóa danh mục này?');">
                                                    <input type="hidden" name="id" value="${cat.categoryId}" />
                                                    <input type="hidden" name="action" value="delete" />
                                                    <button class="btn btn-white btn-sm border border-start-0"
                                                        type="submit" title="Xóa">
                                                        <i class="bi bi-trash text-danger"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- ── Pagination ── -->
                <c:if test="${paged.totalPages > 1}">
                    <nav class="mt-4">
                        <ul class="pagination justify-content-center">
                            <c:set var="base"
                                value="${pageContext.request.contextPath}/admin/category/list?q=${fn:escapeXml(q)}&active=${fn:escapeXml(active)}&pageSize=${pageSize}" />
                            <li class="page-item ${paged.page == 1 ? 'disabled' : ''}">
                                <a class="page-link border-0 shadow-sm rounded-3 me-2"
                                    href="${base}&page=${paged.page - 1}"><i class="bi bi-chevron-left"></i></a>
                            </li>
                            <c:forEach begin="1" end="${paged.totalPages}" var="p">
                                <li class="page-item mx-1">
                                    <a class="page-link border-0 shadow-sm rounded-3 ${p == paged.page ? 'active bg-indigo text-white' : 'bg-white text-dark'}"
                                        href="${base}&page=${p}"
                                        style="${p == paged.page ? 'background-color: #4f46e5 !important;' : ''}">${p}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${paged.page == paged.totalPages ? 'disabled' : ''}">
                                <a class="page-link border-0 shadow-sm rounded-3 ms-2"
                                    href="${base}&page=${paged.page + 1}"><i class="bi bi-chevron-right"></i></a>
                            </li>
                        </ul>
                    </nav>
                </c:if>

                <div class="mt-3 text-center text-muted small">
                    Hiển thị <b>${paged.items.size()}</b> trên tổng số <b>${paged.totalItems}</b> danh mục.
                </div>
            </div>

            <style>
                .text-indigo {
                    color: #4f46e5 !important;
                }

                .bg-indigo {
                    background-color: #4f46e5 !important;
                }

                .page-link.active {
                    background-color: #4f46e5 !important;
                }
            </style>