<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="container-fluid">

    <%-- Success / Error messages --%>
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle me-2"></i>${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle me-2"></i>${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <%-- Page header --%>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="mb-1"><i class="bi bi-person-lines-fill me-2 text-primary"></i>Quản lý Lead (CRM)</h3>
            <p class="text-muted mb-0">Quản lý Lead chưa được giao và theo dõi tiến độ Lead đã giao việc.</p>
        </div>
        <a href="${pageContext.request.contextPath}/manager/crm/customers" class="btn btn-outline-secondary">
            <i class="bi bi-people me-1"></i>Xem Khách hàng
        </a>
    </div>

    <%-- Tabs --%>
    <ul class="nav nav-tabs mb-4" role="tablist">
        <li class="nav-item">
            <a class="nav-link ${currentTab == 'unassigned' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/manager/crm/leads?tab=unassigned">
                <i class="bi bi-inbox me-1"></i>Lead chưa giao việc
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${currentTab == 'assigned' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/manager/crm/leads?tab=assigned">
                <i class="bi bi-check2-circle me-1"></i>Lead đã giao việc
            </a>
        </li>
    </ul>

    <%-- Filters --%>
    <div class="card mb-4 shadow-sm">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/manager/crm/leads" class="row g-2 align-items-end">
                <input type="hidden" name="tab" value="${currentTab}">
                <div class="col-md-3">
                    <label class="form-label fw-semibold small">Tìm kiếm</label>
                    <input type="text" name="keyword" class="form-control" placeholder="Tên, mã, SĐT, email..." value="${keyword}">
                </div>
                <c:if test="${currentTab == 'assigned'}">
                    <div class="col-md-2">
                        <label class="form-label fw-semibold small">Trạng thái</label>
                        <select name="status" class="form-select">
                            <option value="">-- Tất cả --</option>
                            <option value="New"         ${statusFilter == 'New'         ? 'selected' : ''}>New</option>
                            <option value="Assigned"    ${statusFilter == 'Assigned'    ? 'selected' : ''}>Assigned</option>
                            <option value="Working"     ${statusFilter == 'Working'     ? 'selected' : ''}>Working</option>
                            <option value="Qualified"   ${statusFilter == 'Qualified'   ? 'selected' : ''}>Qualified</option>
                            <option value="Unqualified" ${statusFilter == 'Unqualified' ? 'selected' : ''}>Unqualified</option>
                            <option value="Nurturing"   ${statusFilter == 'Nurturing'   ? 'selected' : ''}>Nurturing</option>
                            <option value="Converted"   ${statusFilter == 'Converted'   ? 'selected' : ''}>Converted</option>
                            <option value="Inactive"    ${statusFilter == 'Inactive'    ? 'selected' : ''}>Inactive</option>
                        </select>
                    </div>
                </c:if>
                <div class="col-md-2">
                    <label class="form-label fw-semibold small">Nguồn</label>
                    <select name="source" class="form-select">
                        <option value="">-- Tất cả --</option>
                        <c:forEach var="src" items="${leadSources}">
                            <option value="${src.sourceId}" ${sourceFilter == src.sourceId ? 'selected' : ''}>${src.sourceName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold small">Từ ngày</label>
                    <input type="date" name="dateFrom" class="form-control" value="${dateFrom}">
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold small">Đến ngày</label>
                    <input type="date" name="dateTo" class="form-control" value="${dateTo}">
                </div>
                <div class="col-md-1 d-flex gap-1 align-items-end">
                    <button type="submit" class="btn btn-primary flex-fill" title="Lọc"><i class="bi bi-search"></i></button>
                    <a href="${pageContext.request.contextPath}/manager/crm/leads?tab=${currentTab}" class="btn btn-outline-secondary" title="Xóa bộ lọc">
                        <i class="bi bi-arrow-counterclockwise"></i>
                    </a>
                </div>
            </form>
        </div>
    </div>

    <%-- Summary --%>
    <div class="d-flex justify-content-between align-items-center mb-3">
        <span class="text-muted small">
            Tìm thấy <strong>${totalLeads}</strong> lead
            <c:choose>
                <c:when test="${currentTab == 'assigned'}">đã giao việc</c:when>
                <c:otherwise>chưa được giao</c:otherwise>
            </c:choose>
        </span>
        <span class="text-muted small">Trang ${currentPage}/${totalPages}</span>
    </div>

    <%-- Table --%>
    <div class="card shadow-sm">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th>Mã Lead</th>
                        <th>Họ tên</th>
                        <th>SĐT</th>
                        <th>Email</th>
                        <th>Trạng thái</th>
                        <th>Nguồn</th>
                        <th>Ngày tạo</th>
                        <th class="text-center">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty leads}">
                            <tr>
                                <td colspan="8" class="text-center py-5 text-muted">
                                    <i class="bi bi-inbox fs-3 d-block mb-2"></i>
                                    <c:choose>
                                        <c:when test="${currentTab == 'assigned'}">Chưa có Lead nào được giao việc</c:when>
                                        <c:otherwise>Không có Lead nào chưa được giao</c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="lead" items="${leads}">
                                <tr>
                                    <td><span class="badge bg-light text-dark border">${lead.leadCode}</span></td>
                                    <td>
                                        <div class="fw-semibold">${lead.fullName}</div>
                                        <c:if test="${not empty lead.companyName}">
                                            <small class="text-muted">${lead.companyName}</small>
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty lead.phone}">${lead.phone}</c:when>
                                            <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty lead.email}"><small>${lead.email}</small></c:when>
                                            <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="badge
                                              ${lead.status == 'New'         ? 'bg-secondary' :
                                                lead.status == 'Assigned'    ? 'bg-info text-dark' :
                                                lead.status == 'Working'     ? 'bg-primary' :
                                                lead.status == 'Qualified'   ? 'bg-success' :
                                                lead.status == 'Converted'   ? 'bg-warning text-dark' :
                                                lead.status == 'Unqualified' ? 'bg-danger' :
                                                'bg-light text-dark border'}">
                                                  ${lead.status}
                                              </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty lead.sourceId}">
                                                    <c:forEach var="src" items="${leadSources}">
                                                        <c:if test="${src.sourceId == lead.sourceId}">
                                                            <small class="text-muted">${src.sourceName}</small>
                                                        </c:if>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:if test="${lead.createdAt != null}">
                                                <small>${fn:substring(lead.createdAt.toString(), 8, 10)}/${fn:substring(lead.createdAt.toString(), 5, 7)}/${fn:substring(lead.createdAt.toString(), 0, 4)}</small>
                                            </c:if>
                                        </td>
                                        <td class="text-center">
                                            <div class="d-flex gap-1 justify-content-center">
                                                <c:choose>
                                                    <c:when test="${currentTab == 'assigned'}">
                                                        <%-- Tab "Đã giao việc": show progress popup --%>
                                                        <button type="button"
                                                                class="btn btn-sm btn-outline-info"
                                                                title="Xem tiến độ"
                                                                data-bs-toggle="modal" data-bs-target="#leadProgressModal_${lead.leadId}">
                                                            <i class="bi bi-bar-chart-steps me-1"></i>Tiến độ
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <%-- Tab "Chưa giao": show detail popup + assign button --%>
                                                        <button type="button"
                                                                class="btn btn-sm btn-outline-secondary"
                                                                title="Xem chi tiết"
                                                                data-bs-toggle="modal" data-bs-target="#leadModal_${lead.leadId}">
                                                            <i class="bi bi-eye"></i>
                                                        </button>
                                                        <a href="${pageContext.request.contextPath}/manager/task/form?action=create&leadId=${lead.leadId}"
                                                           class="btn btn-sm btn-primary"
                                                           title="Giao việc cho Lead này">
                                                            <i class="bi bi-plus-circle me-1"></i>Giao việc
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <%-- Pagination --%>
        <c:if test="${totalPages > 1}">
            <nav class="mt-4">
                <ul class="pagination justify-content-center">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="?tab=${currentTab}&page=${currentPage - 1}&keyword=${keyword}&status=${statusFilter}&source=${sourceFilter}&dateFrom=${dateFrom}&dateTo=${dateTo}">
                            <i class="bi bi-chevron-left"></i>
                        </a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="p">
                        <c:if test="${p >= currentPage - 2 && p <= currentPage + 2}">
                            <li class="page-item ${p == currentPage ? 'active' : ''}">
                                <a class="page-link" href="?tab=${currentTab}&page=${p}&keyword=${keyword}&status=${statusFilter}&source=${sourceFilter}&dateFrom=${dateFrom}&dateTo=${dateTo}">${p}</a>
                            </li>
                        </c:if>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="?tab=${currentTab}&page=${currentPage + 1}&keyword=${keyword}&status=${statusFilter}&source=${sourceFilter}&dateFrom=${dateFrom}&dateTo=${dateTo}">
                            <i class="bi bi-chevron-right"></i>
                        </a>
                    </li>
                </ul>
            </nav>
        </c:if>
    </div>


    <div class="modal fade" id="leadDetailModal" tabindex="-1" aria-labelledby="leadDetailModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-secondary text-white">
                    <h5 class="modal-title" id="leadDetailModalLabel">
                        <i class="bi bi-person-vcard me-2"></i>Chi tiết Lead
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="leadDetailBody">
                    <div class="text-center py-4">
                        <div class="spinner-border text-primary" role="status"></div>
                        <p class="mt-2 text-muted">Đang tải...</p>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <c:forEach var="lead" items="${leads}">
        <div class="modal fade" id="leadModal_${lead.leadId}" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header bg-secondary text-white">
                        <h5 class="modal-title">
                            <i class="bi bi-person-vcard me-2"></i>Chi tiết Lead
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">

                        <%-- Header --%>
                        <div class="d-flex align-items-center gap-3 mb-3 pb-3 border-bottom">
                            <div class="bg-secondary bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center" style="width:56px;height:56px">
                                <i class="bi bi-person-fill text-secondary fs-3"></i>
                            </div>
                            <div>
                                <h5 class="mb-0">${fn:escapeXml(lead.fullName)}</h5>
                                <span class="badge bg-light text-dark border me-1">${fn:escapeXml(lead.leadCode)}</span>
                                <c:if test="${not empty lead.status}">
                                    <span class="badge
                                          ${lead.status == 'New'         ? 'bg-secondary' :
                                            lead.status == 'Assigned'    ? 'bg-info text-dark' :
                                            lead.status == 'Working'     ? 'bg-primary' :
                                            lead.status == 'Qualified'   ? 'bg-success' :
                                            lead.status == 'Converted'   ? 'bg-warning text-dark' :
                                            lead.status == 'Unqualified' ? 'bg-danger' :
                                            'bg-light text-dark border'}">
                                              ${fn:escapeXml(lead.status)}
                                          </span>
                                    </c:if>
                                    <c:if test="${not empty lead.rating}">
                                        <span class="badge
                                              ${lead.rating == 'Hot'  ? 'bg-danger' :
                                                lead.rating == 'Warm' ? 'bg-warning text-dark' :
                                                lead.rating == 'Cold' ? 'bg-secondary' : 'bg-light text-dark border'}">
                                                  ${fn:escapeXml(lead.rating)}
                                              </span>
                                        </c:if>
                                    </div>
                                </div>

                                <%-- Thông tin cá nhân --%>
                                <h6 class="text-muted mb-2"><i class="bi bi-person me-1"></i>Thông tin cá nhân</h6>
                                <div class="row g-2 mb-3">
                                    <div class="col-md-4">
                                        <div class="mb-1"><small class="text-muted d-block">SĐT</small>
                                            <span>${not empty lead.phone ? fn:escapeXml(lead.phone) : '<span class="text-muted">—</span>'}</span></div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="mb-1"><small class="text-muted d-block">Email</small>
                                            <span>${not empty lead.email ? fn:escapeXml(lead.email) : '<span class="text-muted">—</span>'}</span></div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="mb-1"><small class="text-muted d-block">Công ty</small>
                                            <span>${not empty lead.companyName ? fn:escapeXml(lead.companyName) : '<span class="text-muted">—</span>'}</span></div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="mb-1"><small class="text-muted d-block">Chức vụ</small>
                                            <span>${not empty lead.jobTitle ? fn:escapeXml(lead.jobTitle) : '<span class="text-muted">—</span>'}</span></div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="mb-1"><small class="text-muted d-block">Sở thích / Quan tâm</small>
                                            <span>${not empty lead.interests ? fn:escapeXml(lead.interests) : '<span class="text-muted">—</span>'}</span></div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="mb-1"><small class="text-muted d-block">Điểm Lead</small>
                                            <span>${lead.leadScore}</span></div>
                                    </div>
                                </div>

                                <%-- Thông tin CRM --%>
                                <h6 class="text-muted mb-2"><i class="bi bi-briefcase me-1"></i>Thông tin CRM</h6>
                                <div class="row g-2 mb-3">
                                    <div class="col-md-4">
                                        <div class="mb-1"><small class="text-muted d-block">Nguồn</small>
                                            <span>
                                                <c:choose>
                                                    <c:when test="${not empty lead.sourceId}">
                                                        <c:forEach var="src" items="${leadSources}">
                                                            <c:if test="${src.sourceId == lead.sourceId}">
                                                                ${fn:escapeXml(src.sourceName)}
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                </c:choose>
                                            </span></div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="mb-1"><small class="text-muted d-block">Người phụ trách</small>
                                            <span>
                                                <c:choose>
                                                    <c:when test="${not empty lead.assignedTo}">
                                                        <c:set var="assignedFound" value="false"/>
                                                        <c:forEach var="u" items="${teamMembers}">
                                                            <c:if test="${u.userId == lead.assignedTo}">
                                                                ${fn:escapeXml(u.firstName)} ${fn:escapeXml(u.lastName)}
                                                                <c:set var="assignedFound" value="true"/>
                                                            </c:if>
                                                        </c:forEach>
                                                        <c:if test="${!assignedFound}">
                                                            <span class="text-muted small">ID: ${lead.assignedTo}</span>
                                                        </c:if>
                                                    </c:when>
                                                    <c:otherwise><span class="text-muted">Chưa giao</span></c:otherwise>
                                                </c:choose>
                                            </span></div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="mb-1"><small class="text-muted d-block">Chuyển đổi</small>
                                            <span>${lead.isConverted ? 'Đã chuyển đổi' : 'Chưa chuyển đổi'}</span></div>
                                    </div>
                                </div>

                                <%-- Ghi chú --%>
                                <c:if test="${not empty lead.notes}">
                                    <hr>
                                    <div>
                                        <strong><i class="bi bi-sticky me-1"></i>Ghi chú:</strong>
                                        <p class="mt-1 mb-0 text-muted fst-italic">${fn:escapeXml(lead.notes)}</p>
                                    </div>
                                </c:if>

                                <%-- Ngày tạo --%>
                                <c:if test="${lead.createdAt != null}">
                                    <div class="text-muted small mt-3 text-end">
                                        <i class="bi bi-clock me-1"></i>Ngày tạo:
                                        <c:set var="ca" value="${lead.createdAt.toString()}"/>
                                        ${fn:substring(ca, 8, 10)}/${fn:substring(ca, 5, 7)}/${fn:substring(ca, 0, 4)} ${fn:substring(ca, 11, 16)}
                                    </div>
                                </c:if>

                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Đóng</button>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>



            <%-- Lead Progress Modal --%>
            <div class="modal fade" id="leadProgressModal" tabindex="-1" aria-labelledby="leadProgressModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-xl">
                    <div class="modal-content">
                        <div class="modal-header bg-info text-white">
                            <h5 class="modal-title" id="leadProgressModalLabel">
                                <i class="bi bi-bar-chart-steps me-2"></i>Tiến độ Lead
                            </h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body" id="leadProgressBody">
                            <div class="text-center py-4">
                                <div class="spinner-border text-primary" role="status"></div>
                                <p class="mt-2 text-muted">Đang tải...</p>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Đóng</button>
                        </div>
                    </div>
                </div>
            </div>
            <%-- Lead Progress Modals (server-rendered) --%>
            <c:forEach var="lead" items="${leads}">
                <div class="modal fade" id="leadProgressModal_${lead.leadId}" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-xl">
                        <div class="modal-content">
                            <div class="modal-header bg-info text-white">
                                <h5 class="modal-title">
                                    <i class="bi bi-bar-chart-steps me-2"></i>Tiến độ Lead
                                </h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">

                                <%-- Lead summary --%>
                                <div class="card mb-3">
                                    <div class="card-body">
                                        <div class="row g-2">
                                            <div class="col-md-4">
                                                <strong>Lead:</strong> ${fn:escapeXml(lead.fullName)}
                                                <span class="badge bg-light text-dark border ms-1">${fn:escapeXml(lead.leadCode)}</span>
                                            </div>
                                            <div class="col-md-3"><strong>SĐT:</strong> ${not empty lead.phone ? fn:escapeXml(lead.phone) : '—'}</div>
                                            <div class="col-md-3"><strong>Email:</strong> ${not empty lead.email ? fn:escapeXml(lead.email) : '—'}</div>
                                            <div class="col-md-2">
                                                <strong>Trạng thái:</strong>
                                                <span class="badge
                                                      ${lead.status == 'New'         ? 'bg-secondary' :
                                                        lead.status == 'Assigned'    ? 'bg-info text-dark' :
                                                        lead.status == 'Working'     ? 'bg-primary' :
                                                        lead.status == 'Qualified'   ? 'bg-success' :
                                                        lead.status == 'Converted'   ? 'bg-warning text-dark' :
                                                        lead.status == 'Unqualified' ? 'bg-danger' :
                                                        'bg-light text-dark border'}">
                                                          ${fn:escapeXml(lead.status)}
                                                      </span>
                                                </div>
                                                <div class="col-md-4"><strong>Công ty:</strong> ${not empty lead.companyName ? fn:escapeXml(lead.companyName) : '—'}</div>
                                                <div class="col-md-4"><strong>Chức vụ:</strong> ${not empty lead.jobTitle ? fn:escapeXml(lead.jobTitle) : '—'}</div>
                                                <div class="col-md-4"><strong>Điểm Lead:</strong> ${lead.leadScore}</div>
                                                <div class="col-md-4"><strong>Đánh giá:</strong> ${not empty lead.rating ? fn:escapeXml(lead.rating) : '—'}</div>
                                                <div class="col-md-4">
                                                    <strong>Nguồn:</strong>
                                                    <c:choose>
                                                        <c:when test="${not empty lead.sourceId}">
                                                            <c:forEach var="src" items="${leadSources}">
                                                                <c:if test="${src.sourceId == lead.sourceId}">
                                                                    ${fn:escapeXml(src.sourceName)}
                                                                </c:if>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>—</c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="col-md-4">
                                                    <strong>Người phụ trách:</strong>
                                                    <c:choose>
                                                        <c:when test="${not empty lead.assignedTo}">
                                                            ${not empty userNameMap[lead.assignedTo] ? fn:escapeXml(userNameMap[lead.assignedTo]) : 'ID: '.concat(lead.assignedTo)}
                                                        </c:when>
                                                        <c:otherwise>Chưa giao</c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="col-md-12"><strong>Sở thích / Quan tâm:</strong> ${not empty lead.interests ? fn:escapeXml(lead.interests) : '—'}</div>
                                                <c:if test="${not empty lead.notes}">
                                                    <div class="col-md-12"><strong>Ghi chú:</strong> ${fn:escapeXml(lead.notes)}</div>
                                                </c:if>
                                                <div class="col-md-6">
                                                    <strong>Ngày tạo:</strong>
                                                    <c:if test="${lead.createdAt != null}">
                                                        <c:set var="ca" value="${lead.createdAt.toString()}"/>
                                                        ${fn:substring(ca, 8, 10)}/${fn:substring(ca, 5, 7)}/${fn:substring(ca, 0, 4)} ${fn:substring(ca, 11, 16)}
                                                    </c:if>
                                                </div>
                                                <div class="col-md-6">
                                                    <strong>Cập nhật:</strong>
                                                    <c:if test="${lead.updatedAt != null}">
                                                        <c:set var="ua" value="${lead.updatedAt.toString()}"/>
                                                        ${fn:substring(ua, 8, 10)}/${fn:substring(ua, 5, 7)}/${fn:substring(ua, 0, 4)} ${fn:substring(ua, 11, 16)}
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <%-- Tasks table --%>
                                    <c:set var="tasks" value="${leadTasksMap[lead.leadId]}"/>
                                    <c:choose>
                                        <c:when test="${not empty tasks}">
                                            <h6 class="mb-3"><i class="bi bi-list-task me-1"></i>Danh sách công việc liên quan (${fn:length(tasks)})</h6>
                                            <div class="table-responsive">
                                                <table class="table table-bordered table-hover align-middle mb-0">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th>Mã Task</th>
                                                            <th>Tiêu đề</th>
                                                            <th>Mô tả</th>
                                                            <th>Người thực hiện</th>
                                                            <th>Trạng thái</th>
                                                            <th>Ưu tiên</th>
                                                            <th>Hạn chót</th>
                                                            <th>Nhắc việc</th>
                                                            <th>Hoàn thành</th>
                                                            <th>Tạo</th>
                                                            <th>Cập nhật</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="t" items="${tasks}">
                                                            <tr>
                                                                <td><span class="badge bg-light text-dark border">${fn:escapeXml(t.taskCode)}</span></td>
                                                                <td>${fn:escapeXml(t.title)}</td>
                                                                <td>${not empty t.description ? fn:escapeXml(t.description) : '—'}</td>
                                                                <td>${not empty t.assignedTo ? (not empty userNameMap[t.assignedTo] ? fn:escapeXml(userNameMap[t.assignedTo]) : 'ID: '.concat(t.assignedTo)) : '—'}</td>
                                                                <td>
                                                                    <span class="badge
                                                                          ${t.statusName == 'PENDING'     ? 'bg-warning text-dark' :
                                                                            t.statusName == 'IN_PROGRESS' ? 'bg-primary' :
                                                                            t.statusName == 'COMPLETED'   ? 'bg-success' :
                                                                            t.statusName == 'CANCELLED'   ? 'bg-danger' :
                                                                            'bg-secondary'}">
                                                                              ${fn:escapeXml(t.statusVietnamese)}
                                                                          </span>
                                                                    </td>
                                                                    <td>
                                                                        <span class="badge
                                                                              ${t.priorityVietnamese == 'Cao'        ? 'bg-danger' :
                                                                                t.priorityVietnamese == 'Trung bình' ? 'bg-warning text-dark' :
                                                                                t.priorityVietnamese == 'Thấp'       ? 'bg-info text-dark' :
                                                                                'bg-secondary'}">
                                                                                  ${fn:escapeXml(t.priorityVietnamese)}
                                                                              </span>
                                                                        </td>
                                                                        <td>
                                                                            <c:if test="${t.dueDate != null}">
                                                                                <c:set var="dd" value="${t.dueDate.toString()}"/>
                                                                                ${fn:substring(dd, 8, 10)}/${fn:substring(dd, 5, 7)}/${fn:substring(dd, 0, 4)} ${fn:substring(dd, 11, 16)}
                                                                            </c:if>
                                                                        </td>
                                                                        <td>
                                                                            <c:if test="${t.reminderAt != null}">
                                                                                <c:set var="ra" value="${t.reminderAt.toString()}"/>
                                                                                ${fn:substring(ra, 8, 10)}/${fn:substring(ra, 5, 7)}/${fn:substring(ra, 0, 4)} ${fn:substring(ra, 11, 16)}
                                                                            </c:if>
                                                                        </td>
                                                                        <td>
                                                                            <c:if test="${t.completedAt != null}">
                                                                                <c:set var="ca2" value="${t.completedAt.toString()}"/>
                                                                                ${fn:substring(ca2, 8, 10)}/${fn:substring(ca2, 5, 7)}/${fn:substring(ca2, 0, 4)} ${fn:substring(ca2, 11, 16)}
                                                                            </c:if>
                                                                        </td>
                                                                        <td>
                                                                            <c:if test="${t.createdAt != null}">
                                                                                <c:set var="tca" value="${t.createdAt.toString()}"/>
                                                                                ${fn:substring(tca, 8, 10)}/${fn:substring(tca, 5, 7)}/${fn:substring(tca, 0, 4)} ${fn:substring(tca, 11, 16)}
                                                                            </c:if>
                                                                        </td>
                                                                        <td>
                                                                            <c:if test="${t.updatedAt != null}">
                                                                                <c:set var="tua" value="${t.updatedAt.toString()}"/>
                                                                                ${fn:substring(tua, 8, 10)}/${fn:substring(tua, 5, 7)}/${fn:substring(tua, 0, 4)} ${fn:substring(tua, 11, 16)}
                                                                            </c:if>
                                                                        </td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="alert alert-warning"><i class="bi bi-exclamation-triangle me-2"></i>Chưa có công việc nào được tạo cho Lead này.</div>
                                                </c:otherwise>
                                            </c:choose>

                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Đóng</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>



                        <script>
                            /* ── Lead Detail Modal (Tab chưa giao) ── */
                            function openDetailModal(leadId) {
                                return;
                                var body = document.getElementById('leadDetailBody');
                                body.innerHTML = '<div class="text-center py-4"><div class="spinner-border text-primary" role="status"></div><p class="mt-2 text-muted">Đang tải...</p></div>';
                                new bootstrap.Modal(document.getElementById('leadDetailModal')).show();

                                fetch('${pageContext.request.contextPath}/manager/task/object-info?type=LEAD&id=' + leadId)
                                        .then(function (res) {
                                            return res.json();
                                        })
                                        .then(function (data) {
                                            if (data.error) {
                                                body.innerHTML = '<div class="alert alert-danger">' + data.error + '</div>';
                                                return;
                                            }
                                            var html = '<div class="row g-3">';
                                            html += buildInfoRow('Họ tên', data.fullName);
                                            html += buildInfoRow('Số điện thoại', data.phone || '<span class="text-muted">—</span>');
                                            html += buildInfoRow('Email', data.email || '<span class="text-muted">—</span>');
                                            html += buildInfoRow('Nguồn', data.sourceName || '<span class="text-muted">—</span>');
                                            html += buildInfoRow('Trạng thái', buildStatusBadge(data.status));
                                            html += buildInfoRow('Đánh giá', data.rating || '<span class="text-muted">—</span>');
                                            html += buildInfoRow('Người phụ trách', data.assignedUserName || '<span class="text-muted">Chưa có</span>');
                                            html += buildInfoRow('Sở thích / Quan tâm', data.interests || '<span class="text-muted">—</span>');
                                            html += '</div>';
                                            if (data.notes) {
                                                html += '<hr><div><strong>Ghi chú:</strong><p class="mt-1 mb-0">' + escapeHtml(data.notes) + '</p></div>';
                                            }
                                            body.innerHTML = html;
                                        })
                                        .catch(function () {
                                            body.innerHTML = '<div class="alert alert-danger">Lỗi khi tải thông tin Lead.</div>';
                                        });
                            }

                            /* ── Lead Progress Modal (Tab đã giao) ── */
                            function openProgressModal(leadId) {
                                var body = document.getElementById('leadProgressBody');
                                body.innerHTML = '<div class="text-center py-4"><div class="spinner-border text-primary" role="status"></div><p class="mt-2 text-muted">Đang tải...</p></div>';
                                new bootstrap.Modal(document.getElementById('leadProgressModal')).show();

                                fetch('${pageContext.request.contextPath}/manager/task/object-info?type=LEAD_TASKS&id=' + leadId)
                                        .then(function (res) {
                                            return res.json();
                                        })
                                        .then(function (data) {
                                            if (data.error) {
                                                body.innerHTML = '<div class="alert alert-danger">' + data.error + '</div>';
                                                return;
                                            }

                                            var html = '';

                                            /* Lead info summary */
                                            html += '<div class="card mb-3"><div class="card-body">';
                                            html += '<div class="row">';
                                            html += '<div class="col-md-4"><strong>Lead:</strong> ' + escapeHtml(data.fullName) + ' <span class="badge bg-light text-dark border">' + escapeHtml(data.leadCode) + '</span></div>';
                                            html += '<div class="col-md-3"><strong>SĐT:</strong> ' + (data.phone || '—') + '</div>';
                                            html += '<div class="col-md-3"><strong>Email:</strong> ' + (data.email || '—') + '</div>';
                                            html += '<div class="col-md-2"><strong>Trạng thái:</strong> ' + buildStatusBadge(data.status) + '</div>';
                                            html += '</div></div></div>';

                                            /* Tasks table */
                                            if (data.tasks && data.tasks.length > 0) {
                                                html += '<h6 class="mb-3"><i class="bi bi-list-task me-1"></i>Danh sách công việc liên quan (' + data.tasks.length + ')</h6>';
                                                html += '<div class="table-responsive"><table class="table table-bordered table-hover align-middle mb-0">';
                                                html += '<thead class="table-light"><tr>';
                                                html += '<th>Mã Task</th><th>Tiêu đề</th><th>Người thực hiện</th><th>Trạng thái</th><th>Độ ưu tiên</th><th>Hạn chót</th><th>Hoàn thành</th>';
                                                html += '</tr></thead><tbody>';

                                                for (var i = 0; i < data.tasks.length; i++) {
                                                    var t = data.tasks[i];
                                                    html += '<tr>';
                                                    html += '<td><span class="badge bg-light text-dark border">' + escapeHtml(t.taskCode) + '</span></td>';
                                                    html += '<td>' + escapeHtml(t.title) + '</td>';
                                                    html += '<td>' + (t.assigneeName || '<span class="text-muted">—</span>') + '</td>';
                                                    html += '<td>' + buildTaskStatusBadge(t.statusName, t.status) + '</td>';
                                                    html += '<td>' + buildPriorityBadge(t.priority) + '</td>';
                                                    html += '<td>' + formatDate(t.dueDate) + '</td>';
                                                    html += '<td>' + formatDate(t.completedAt) + '</td>';
                                                    html += '</tr>';
                                                }

                                                html += '</tbody></table></div>';
                                            } else {
                                                html += '<div class="alert alert-warning"><i class="bi bi-exclamation-triangle me-2"></i>Chưa có công việc nào được tạo cho Lead này.</div>';
                                            }

                                            body.innerHTML = html;
                                        })
                                        .catch(function () {
                                            body.innerHTML = '<div class="alert alert-danger">Lỗi khi tải thông tin tiến độ.</div>';
                                        });
                            }

                            /* ── Helpers ── */
                            function buildInfoRow(label, value) {
                                return '<div class="col-md-6"><div class="mb-2"><small class="text-muted d-block">' + label + '</small><span class="fw-semibold">' + value + '</span></div></div>';
                            }

                            function buildStatusBadge(status) {
                                if (!status)
                                    return '<span class="text-muted">—</span>';
                                var cls = 'bg-light text-dark border';
                                switch (status) {
                                    case 'New':
                                        cls = 'bg-secondary';
                                        break;
                                    case 'Assigned':
                                        cls = 'bg-info text-dark';
                                        break;
                                    case 'Working':
                                        cls = 'bg-primary';
                                        break;
                                    case 'Qualified':
                                        cls = 'bg-success';
                                        break;
                                    case 'Converted':
                                        cls = 'bg-warning text-dark';
                                        break;
                                    case 'Unqualified':
                                        cls = 'bg-danger';
                                        break;
                                }
                                return '<span class="badge ' + cls + '">' + status + '</span>';
                            }

                            function buildTaskStatusBadge(statusName, statusVietnamese) {
                                var cls = 'bg-secondary';
                                switch (statusName) {
                                    case 'PENDING':
                                        cls = 'bg-warning text-dark';
                                        break;
                                    case 'IN_PROGRESS':
                                        cls = 'bg-primary';
                                        break;
                                    case 'COMPLETED':
                                        cls = 'bg-success';
                                        break;
                                    case 'CANCELLED':
                                        cls = 'bg-danger';
                                        break;
                                }
                                return '<span class="badge ' + cls + '">' + statusVietnamese + '</span>';
                            }

                            function buildPriorityBadge(priority) {
                                if (!priority)
                                    return '<span class="text-muted">—</span>';
                                var cls = 'bg-secondary';
                                if (priority === 'Cao')
                                    cls = 'bg-danger';
                                else if (priority === 'Trung bình')
                                    cls = 'bg-warning text-dark';
                                else if (priority === 'Thấp')
                                    cls = 'bg-info text-dark';
                                return '<span class="badge ' + cls + '">' + priority + '</span>';
                            }

                            function formatDate(dateStr) {
                                if (!dateStr)
                                    return '<span class="text-muted">—</span>';
                                try {
                                    var d = dateStr.replace('T', ' ');
                                    var parts = d.split(' ');
                                    var dateParts = parts[0].split('-');
                                    var timePart = parts[1] ? parts[1].substring(0, 5) : '';
                                    return dateParts[2] + '/' + dateParts[1] + '/' + dateParts[0] + (timePart ? ' ' + timePart : '');
                                } catch (e) {
                                    return dateStr;
                                }
                            }

                            function escapeHtml(text) {
                                if (!text)
                                    return '';
                                var div = document.createElement('div');
                                div.appendChild(document.createTextNode(text));
                                return div.innerHTML;
                            }
                        </script>
