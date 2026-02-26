<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

            <div class="page-container">
                <!-- ── Header Section ── -->
                <div class="d-flex align-items-center justify-content-between mb-4">
                    <div>
                        <h2 class="fw-bold mb-0">Course Categories</h2>
                        <p class="text-muted small mb-0">Manage all course categories in the system</p>
                    </div>
                    <a class="btn btn-primary px-4 py-2 rounded-3 shadow-sm"
                        style="background-color: #4f46e5; border-color: #4f46e5;"
                        href="${pageContext.request.contextPath}/admin/category/form">
                        <i class="bi bi-plus-lg me-2"></i>New Category
                    </a>
                </div>

                <!-- ── Stats Overview ── -->
                <div class="row g-3 mb-4">
                    <div class="col-md-3">
                        <div class="card border-0 shadow-sm rounded-3">
                            <div class="card-body p-3 d-flex align-items-center gap-3">
                                <div class="bg-indigo bg-opacity-10 p-2 rounded-3 text-indigo">
                                    <i class="bi bi-folder2-open fs-4"></i>
                                </div>
                                <div>
                                    <div class="text-muted small text-uppercase">Total</div>
                                    <div class="h4 fw-bold mb-0">${fn:length(categories)}</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card border-0 shadow-sm rounded-3">
                            <div class="card-body p-3 d-flex align-items-center gap-3">
                                <div class="bg-success bg-opacity-10 p-2 rounded-3 text-success">
                                    <i class="bi bi-check-circle fs-4"></i>
                                </div>
                                <div>
                                    <div class="text-muted small text-uppercase">Active</div>
                                    <div class="h4 fw-bold mb-0 text-success">
                                        <c:set var="activeCount" value="0" />
                                        <c:forEach items="${categories}" var="cat">
                                            <c:if test="${cat.isActive}">
                                                <c:set var="activeCount" value="${activeCount + 1}" />
                                            </c:if>
                                        </c:forEach>
                                        ${activeCount}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card border-0 shadow-sm rounded-3">
                            <div class="card-body p-3 d-flex align-items-center gap-3">
                                <div class="bg-danger bg-opacity-10 p-2 rounded-3 text-danger">
                                    <i class="bi bi-x-circle fs-4"></i>
                                </div>
                                <div>
                                    <div class="text-muted small text-uppercase">Inactive</div>
                                    <div class="h4 fw-bold mb-0 text-danger">${fn:length(categories) - activeCount}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ── Alerts ── -->
                <c:if test="${not empty msg}">
                    <c:choose>
                        <c:when test="${msg == 'saved'}">
                            <div class="alert alert-success border-0 shadow-sm d-flex align-items-center gap-2">
                                <i class="bi bi-check-circle-fill"></i> Category saved successfully.
                            </div>
                        </c:when>
                        <c:when test="${msg == 'deleted'}">
                            <div class="alert alert-success border-0 shadow-sm d-flex align-items-center gap-2">
                                <i class="bi bi-trash-fill"></i> Category deleted successfully.
                            </div>
                        </c:when>
                        <c:when test="${msg == 'toggled'}">
                            <div class="alert alert-info border-0 shadow-sm d-flex align-items-center gap-2">
                                <i class="bi bi-info-circle-fill"></i> Category status updated.
                            </div>
                        </c:when>
                        <c:when test="${msg == 'cannot_delete'}">
                            <div class="alert alert-danger border-0 shadow-sm d-flex align-items-center gap-2">
                                <i class="bi bi-exclamation-triangle-fill"></i> Cannot delete: category has courses
                                linked.
                            </div>
                        </c:when>
                    </c:choose>
                </c:if>

                <!-- ── Filter Toolbar ── -->
                <div class="card border-0 shadow-sm rounded-3 mb-4">
                    <div class="card-body p-3">
                        <form method="get" action="${pageContext.request.contextPath}/admin/category/list"
                            class="row g-2 align-items-center">
                            <div class="col-md-5">
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-0"><i
                                            class="bi bi-search text-muted"></i></span>
                                    <input type="text" name="q" class="form-control bg-light border-0"
                                        placeholder="Search by name, code..." value="${fn:escapeXml(q)}">
                                </div>
                            </div>
                            <div class="col-md-3">
                                <select name="active" class="form-select bg-light border-0">
                                    <option value="">All Status</option>
                                    <option value="active" ${active=='active' ? 'selected' :''}>Active</option>
                                    <option value="inactive" ${active=='inactive' ? 'selected' :''}>Inactive</option>
                                </select>
                            </div>
                            <div class="col-md-4 d-flex gap-2">
                                <button type="submit" class="btn btn-indigo px-4 text-white"
                                    style="background-color: #4f46e5;">Search</button>
                                <a href="${pageContext.request.contextPath}/admin/category/list"
                                    class="btn btn-light px-4 border">Reset</a>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- ── Data Table ── -->
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="bg-light">
                                <tr>
                                    <th class="ps-4 text-uppercase small fw-bold text-muted py-3">Code</th>
                                    <th class="text-uppercase small fw-bold text-muted py-3">Category Name</th>
                                    <th class="text-uppercase small fw-bold text-muted py-3">Description</th>
                                    <th class="text-center text-uppercase small fw-bold text-muted py-3">Courses</th>
                                    <th class="text-uppercase small fw-bold text-muted py-3">Status</th>
                                    <th class="text-uppercase small fw-bold text-muted py-3">Created</th>
                                    <th class="pe-4 text-uppercase small fw-bold text-muted py-3 text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:if test="${empty categories}">
                                    <tr>
                                        <td colspan="7" class="text-center py-5">
                                            <i class="bi bi-folder-x fs-1 text-muted"></i>
                                            <p class="text-muted mt-2 mb-0">No categories found matching your search.
                                            </p>
                                        </td>
                                    </tr>
                                </c:if>
                                <c:forEach items="${categories}" var="cat" varStatus="st">
                                    <tr>
                                        <td class="ps-4">
                                            <span
                                                class="badge bg-light text-dark border font-monospace py-2 px-3">${fn:escapeXml(cat.categoryCode)}</span>
                                        </td>
                                        <td>
                                            <div class="fw-bold text-dark">${fn:escapeXml(cat.categoryName)}</div>
                                        </td>
                                        <td>
                                            <div class="text-muted small text-truncate" style="max-width: 200px;">
                                                ${not empty cat.description ? fn:escapeXml(cat.description) : 'No
                                                description'}
                                            </div>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge rounded-circle bg-indigo bg-opacity-10 text-indigo p-2"
                                                style="width: 32px; height: 32px; display: inline-flex; align-items: center; justify-content: center; color:#4f46e5;">
                                                ${courseCount[cat.categoryId] != null ? courseCount[cat.categoryId] : 0}
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${cat.isActive}">
                                                    <span
                                                        class="badge rounded-pill bg-success-subtle text-success border border-success px-3">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span
                                                        class="badge rounded-pill bg-danger-subtle text-danger border border-danger px-3">Inactive</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="text-muted small">
                                                <i class="bi bi-calendar3 me-1"></i>
                                                <c:if test="${cat.createdAt != null}">
                                                    ${fn:substring(cat.createdAt.toString(), 0, 10)}</c:if>
                                            </div>
                                        </td>
                                        <td class="pe-4 text-end">
                                            <div class="btn-group shadow-sm rounded-3">
                                                <a class="btn btn-white btn-sm border"
                                                    href="${pageContext.request.contextPath}/admin/category/form?id=${cat.categoryId}"
                                                    title="Edit">
                                                    <i class="bi bi-pencil text-primary"></i>
                                                </a>

                                                <form method="post"
                                                    action="${pageContext.request.contextPath}/admin/category/list"
                                                    class="d-inline">
                                                    <input type="hidden" name="id" value="${cat.categoryId}" />
                                                    <input type="hidden" name="action" value="toggle" />
                                                    <button class="btn btn-white btn-sm border border-start-0"
                                                        type="submit"
                                                        title="${cat.isActive ? 'Deactivate' : 'Activate'}">
                                                        <i
                                                            class="bi ${cat.isActive ? 'bi-toggle-on text-success' : 'bi-toggle-off text-muted'}"></i>
                                                    </button>
                                                </form>

                                                <form method="post"
                                                    action="${pageContext.request.contextPath}/admin/category/list"
                                                    class="d-inline" onsubmit="return confirm('Delete category?');">
                                                    <input type="hidden" name="id" value="${cat.categoryId}" />
                                                    <input type="hidden" name="action" value="delete" />
                                                    <button class="btn btn-white btn-sm border border-start-0"
                                                        type="submit" title="Delete">
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
            </div>

            <style>
                .text-indigo {
                    color: #4f46e5 !important;
                }

                .bg-indigo {
                    background-color: #4f46e5 !important;
                }

                .btn-indigo:hover {
                    opacity: 0.9;
                }
            </style>