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
                            href="${pageContext.request.contextPath}/admin/category/export?q=${fn:escapeXml(q)}">
                            <i class="bi bi-file-earmark-spreadsheet me-2 text-success"></i>Xuất Excel
                        </a>
                    </div>
                </div>

                <!-- ── Filter & Search ── -->
                <div class="card border-0 shadow-sm rounded-4 mb-4">
                    <div class="card-body p-4">
                        <form method="get" action="${pageContext.request.contextPath}/admin/category/list"
                            class="row g-3 align-items-end">
                            <div class="col-md-8">
                                <label class="form-label small fw-bold text-muted">Tìm kiếm</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-0"><i
                                            class="bi bi-search text-muted"></i></span>
                                    <input type="text" name="q" class="form-control bg-light border-0"
                                        placeholder="Tên, mã hoặc mô tả..." value="${fn:escapeXml(q)}">
                                </div>
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

                <!-- ── Table ── -->
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="bg-light bg-opacity-50">
                                <tr>
                                    <th class="ps-4 py-3 border-0 text-uppercase small fw-bold text-muted">Mã</th>
                                    <th class="py-3 border-0 text-uppercase small fw-bold text-muted">Tên Danh mục</th>
                                    <th class="py-3 border-0 text-uppercase small fw-bold text-muted">Mô tả</th>
                                    <th class="py-3 border-0 text-uppercase small fw-bold text-muted text-center">Số khóa học</th>
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
                                            <div class="text-muted small text-truncate" style="max-width: 300px;">
                                                ${fn:escapeXml(cat.description)}</div>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge rounded-pill bg-primary-subtle text-primary border border-primary px-3 py-2">
                                                <i class="bi bi-book me-1"></i>${courseCount[cat.categoryId]} khóa học
                                            </span>
                                        </td>
                                        <td class="pe-4 text-end">
                                            <a class="btn btn-sm btn-outline-primary rounded-3 px-3 shadow-sm"
                                                href="${pageContext.request.contextPath}/admin/category/view?id=${cat.categoryId}"
                                                title="Xem chi tiết">
                                                <i class="bi bi-eye me-1"></i> Xem
                                            </a>
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
                                value="${pageContext.request.contextPath}/admin/category/list?q=${fn:escapeXml(q)}&pageSize=${pageSize}" />
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