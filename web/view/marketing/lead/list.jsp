<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h4 class="mb-0 fw-bold">Danh sách Lead</h4>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item"><a
                                    href="${pageContext.request.contextPath}/marketing/dashboard">Marketing</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Leads</li>
                        </ol>
                    </nav>
                </div>
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/marketing/lead/form" class="btn btn-primary">
                        <i class="bi bi-person-plus me-2"></i>Thêm Lead mới
                    </a>
                </div>
            </div>

            <div class="card border-0 shadow-sm overflow-hidden">
                <div class="card-header bg-white py-3">
                    <form action="${pageContext.request.contextPath}/marketing/lead/list" method="GET" class="row g-3">
                        <div class="col-md-4">
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0">
                                    <i class="bi bi-search text-muted"></i>
                                </span>
                                <input type="text" name="search" class="form-control bg-light border-start-0"
                                    placeholder="Tìm kiếm theo số điện thoại..." value="${search}">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <select name="status" class="form-select bg-light" onchange="this.form.submit()">
                                <option value="">Tất cả trạng thái</option>
                                <option value="New" ${status=='New' ? 'selected' : '' }>Mới (New)</option>
                                <option value="Contacted" ${status=='Contacted' ? 'selected' : '' }>Đã liên hệ (Contacted)</option>
                                <option value="Qualified" ${status=='Qualified' ? 'selected' : '' }>Đủ điều kiện (Qualified)</option>
                                <option value="Unqualified" ${status=='Unqualified' ? 'selected' : '' }>Không đủ điều kiện (Unqualified)</option>
                                <option value="Converted" ${status=='Converted' ? 'selected' : '' }>Đã chuyển đổi (Converted)</option>
                            </select>
                        </div>
                        <div class="col-md-1">
                            <button type="submit" class="btn btn-light w-100">Lọc</button>
                        </div>
                    </form>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light text-muted small text-uppercase fw-bold">
                            <tr>
                                <th class="ps-4">Họ tên / Email</th>
                                <th>Số điện thoại</th>
                                <th>Công ty / Chức vụ</th>
                                <th>Sở thích</th>
                                <th>Trạng thái</th>
                                <th>Phân công cho</th>
                                <th class="text-end pe-4">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty leads}">
                                    <c:forEach var="lead" items="${leads}">
                                        <tr>
                                            <td class="ps-4">
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="avatar avatar-sm bg-primary-subtle text-primary rounded-circle d-flex align-items-center justify-content-center fw-bold"
                                                        style="width: 32px; height: 32px; font-size: 12px;">
                                                        ${lead.fullName.substring(0, 1).toUpperCase()}
                                                    </div>
                                                    <div>
                                                        <div class="fw-semibold text-dark">${lead.fullName}</div>
                                                        <div class="text-muted small">${lead.email}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>${lead.phone}</td>
                                            <td>
                                                <div class="text-dark">${lead.companyName}</div>
                                                <div class="text-muted small">${lead.jobTitle}</div>
                                            </td>
                                            <td>
                                                <div class="text-muted small" style="max-width: 120px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" title="${lead.interests}">
                                                    ${not empty lead.interests ? lead.interests : '-'}
                                                </div>
                                            </td>
                                             <td>
                                                <c:choose>
                                                    <c:when test="${lead.status == 'New'}">
                                                        <span class="badge bg-info-subtle text-info px-2 py-1">New</span>
                                                    </c:when>
                                                    <c:when test="${lead.status == 'Contacted'}">
                                                        <span class="badge bg-primary-subtle text-primary px-2 py-1">Contacted</span>
                                                    </c:when>
                                                    <c:when test="${lead.status == 'Qualified'}">
                                                        <span class="badge bg-success-subtle text-success px-2 py-1">Qualified</span>
                                                    </c:when>
                                                    <c:when test="${lead.status == 'Converted'}">
                                                        <span class="badge bg-success text-white px-2 py-1">Converted</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-light text-dark px-2 py-1">${lead.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty lead.assignedTo}">
                                                        <span class="text-dark small"><i
                                                                class="bi bi-person me-1"></i>User ID:
                                                            ${lead.assignedTo}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted small italic">Chưa phân công</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end pe-4">
                                                <div class="dropdown">
                                                    <button class="btn btn-light btn-sm rounded-circle" type="button"
                                                        data-bs-toggle="dropdown">
                                                        <i class="bi bi-three-dots-vertical"></i>
                                                    </button>
                                                    <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0">
                                                        <li><a class="dropdown-item py-2"
                                                                href="${pageContext.request.contextPath}/marketing/lead/detail?id=${lead.leadId}"><i
                                                                    class="bi bi-eye me-2"></i>Xem chi tiết</a></li>
                                                        <li><a class="dropdown-item py-2"
                                                                href="${pageContext.request.contextPath}/marketing/lead/form?id=${lead.leadId}"><i
                                                                    class="bi bi-pencil me-2"></i>Chỉnh sửa</a></li>
                                                        <li><a class="dropdown-item py-2 text-danger"
                                                                href="javascript:CRM.confirm('Xóa Lead này?', () => { window.location.href='${pageContext.request.contextPath}/marketing/lead/delete?id=${lead.leadId}'; })"><i
                                                                    class="bi bi-trash me-2"></i>Xóa</a></li>
                                                    </ul>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="text-center py-5">
                                            <div class="text-muted">Không tìm thấy Lead nào tương ứng.</div>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
                <div class="card-footer bg-white border-top-0 py-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="text-muted small">
                            Hiển thị
                            <c:out value="${(pagedResult.page - 1) * pagedResult.pageSize + 1}" /> -
                            <c:out
                                value="${pagedResult.page * pagedResult.pageSize > pagedResult.totalItems ? pagedResult.totalItems : pagedResult.page * pagedResult.pageSize}" />
                            trong tổng số
                            <c:out value="${pagedResult.totalItems}" /> kết quả
                        </span>
                        <nav>
                            <ul class="pagination pagination-sm mb-0">
                                <li class="page-item ${pagedResult.page == 1 ? 'disabled' : ''}">
                                    <a class="page-link"
                                        href="?page=${pagedResult.page - 1}&search=${search}&status=${status}">Trình
                                        trước</a>
                                </li>

                                <c:forEach var="i" begin="1" end="${pagedResult.totalPages}">
                                    <li class="page-item ${pagedResult.page == i ? 'active' : ''}">
                                        <a class="page-link"
                                            href="?page=${i}&search=${search}&status=${status}">${i}</a>
                                    </li>
                                </c:forEach>

                                <li
                                    class="page-item ${pagedResult.page == pagedResult.totalPages || pagedResult.totalPages == 0 ? 'disabled' : ''}">
                                    <a class="page-link"
                                        href="?page=${pagedResult.page + 1}&search=${search}&status=${status}">Trình
                                        sau</a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>