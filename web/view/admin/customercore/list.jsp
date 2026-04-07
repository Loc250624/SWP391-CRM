<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

            <div class="customer-container">
                <!-- ── Header Section ── -->
                <div class="d-flex align-items-center justify-content-between mb-4 flex-wrap gap-3">
                    <div>
                        <h2 class="fw-bold mb-0">Customer Management</h2>
                        <p class="text-muted small mb-0">Manage and oversee all customer records in the system</p>
                    </div>
                    <div class="d-flex gap-2">
                        <div class="btn-group shadow-sm">
                            <a class="btn btn-white border px-3 py-2 rounded-3 text-dark bg-white"
                                href="${pageContext.request.contextPath}/admin/customer/export?q=${fn:escapeXml(q)}&status=${fn:escapeXml(status)}&segment=${fn:escapeXml(segment)}">
                                <i class="bi bi-download me-2 text-indigo"></i>Export
                            </a>
                            <a class="btn btn-white border-start-0 border px-3 py-2 rounded-3 text-dark bg-white"
                                href="${pageContext.request.contextPath}/admin/customer/dedup">
                                <i class="bi bi-intersect me-2 text-warning"></i>Dedup
                            </a>
                        </div>
                        <a class="btn btn-indigo px-4 py-2 rounded-3 shadow-sm text-white"
                            style="background-color: #4f46e5; border-color: #4f46e5;"
                            href="${pageContext.request.contextPath}/admin/customer/form">
                            <i class="bi bi-person-plus-fill me-2"></i>Create Customer
                        </a>
                    </div>
                </div>

                <!-- ── Filter Card ── -->
                <div class="card border-0 shadow-sm rounded-4 mb-4">
                    <div class="card-body p-4">
                        <form method="get" action="${pageContext.request.contextPath}/admin/customer/list"
                            class="row g-3 align-items-end">
                            <div class="col-md-3">
                                <label class="form-label small fw-bold text-muted">Search Query</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-0"><i
                                            class="bi bi-search text-muted"></i></span>
                                    <input type="text" name="q" class="form-control bg-light border-0"
                                        placeholder="Name, email, phone..." value="${fn:escapeXml(q)}">
                                </div>
                            </div>
                            <div class="col-md-3 d-flex gap-2">
                                <button type="submit" class="btn btn-indigo flex-grow-1 text-white"
                                    style="background-color: #4f46e5;">Apply Filter</button>
                                <a href="${pageContext.request.contextPath}/admin/customer/list"
                                    class="btn btn-light border px-3 shadow-sm">Reset</a>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- ── Summary Section ── -->
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div class="text-muted small">
                        Found <b>${paged.totalItems}</b> customers &bull; Page <b>${paged.page}</b> /
                        <b>${paged.totalPages}</b>
                    </div>
                </div>

                <!-- ── Table Card ── -->
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="bg-light bg-opacity-50">
                                <tr class="border-bottom">
                                    <th class="ps-4 text-uppercase small fw-bold text-muted py-3 border-0">#</th>
                                    <th class="text-uppercase small fw-bold text-muted py-3 border-0">Name</th>
                                    <th class="text-uppercase small fw-bold text-muted py-3 border-0">Contact</th>
                                    <th class="text-uppercase small fw-bold text-muted py-3 border-0">Status</th>
                                    <th class="pe-4 text-end text-uppercase small fw-bold text-muted py-3 border-0">
                                        Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:if test="${empty paged.items}">
                                    <tr>
                                        <td colspan="6" class="text-center py-5">
                                            <i class="bi bi-person-x fs-1 text-muted"></i>
                                            <p class="text-muted mt-2">No customers match your criteria.</p>
                                        </td>
                                    </tr>
                                </c:if>
                                <c:forEach items="${paged.items}" var="c" varStatus="st">
                                    <tr>
                                        <td class="ps-4 text-muted small">${(paged.page - 1) * paged.pageSize + st.index
                                            + 1}</td>
                                        <td>
                                            <div class="fw-bold text-dark">${fn:escapeXml(c.fullName)}</div>
                                            <div class="text-muted small">${fn:escapeXml(c.email)}</div>
                                        </td>
                                        <td>
                                            <div class="small fw-medium">${fn:escapeXml(c.phone)}</div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${c.status == 'Active'}">
                                                    <span
                                                        class="badge rounded-pill bg-success-subtle text-success border border-success px-3">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span
                                                        class="badge rounded-pill bg-danger-subtle text-danger border border-danger px-3">${fn:escapeXml(c.status)}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="pe-4 text-end">
                                            <div class="dropdown">
                                                <button class="btn btn-white btn-sm border-0 bg-transparent text-muted"
                                                    type="button" data-bs-toggle="dropdown">
                                                    <i class="bi bi-three-dots-vertical fs-5"></i>
                                                </button>
                                                <ul
                                                    class="dropdown-menu dropdown-menu-end shadow-lg border-0 rounded-3">
                                                    <li>
                                                        <a class="dropdown-item py-2"
                                                            href="${pageContext.request.contextPath}/admin/customer/360?id=${c.customerId}">
                                                            <i class="bi bi-eye me-2 text-primary"></i>View Customer 360
                                                        </a>
                                                    </li>
                                                    <li>
                                                        <a class="dropdown-item py-2"
                                                            href="${pageContext.request.contextPath}/admin/customer/form?id=${c.customerId}">
                                                            <i class="bi bi-pencil me-2 text-success"></i>Edit Record
                                                        </a>
                                                    </li>
                                                    <li>
                                                        <hr class="dropdown-divider">
                                                    </li>
                                                    <li>
                                                        <form method="post"
                                                            action="${pageContext.request.contextPath}/admin/customer/delete"
                                                            onsubmit="return confirm('Delete this record?');">
                                                            <input type="hidden" name="id" value="${c.customerId}" />
                                                            <button class="dropdown-item py-2 text-danger"
                                                                type="submit">
                                                                <i class="bi bi-trash-fill me-2"></i>Delete Record
                                                            </button>
                                                        </form>
                                                    </li>
                                                </ul>
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
                                value="${pageContext.request.contextPath}/admin/customer/list?q=${fn:escapeXml(q)}&status=${fn:escapeXml(status)}&segment=${fn:escapeXml(segment)}&pageSize=${paged.pageSize}" />

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
            </div>

            <style>
                .text-indigo {
                    color: #4f46e5 !important;
                }

                .bg-indigo {
                    background-color: #4f46e5 !important;
                }

                .dropdown-item:hover {
                    background-color: #f8f9fa;
                }

                .page-link.active {
                    background-color: #4f46e5 !important;
                }
            </style>