<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

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
            <h3 class="mb-1"><i class="bi bi-people-fill me-2 text-success"></i>Quản lý Khách hàng</h3>
            <p class="text-muted mb-0">Quản lý danh sách khách hàng chưa giao và đã giao cho Sales.</p>
        </div>
        <a href="${pageContext.request.contextPath}/manager/crm/customer/form" class="btn btn-success btn-sm">
            <i class="bi bi-person-plus me-1"></i>Tạo Customer
        </a>
    </div>

    <%-- Tabs: Chưa giao / Đã giao --%>
    <ul class="nav nav-tabs mb-4">
        <li class="nav-item">
            <a class="nav-link ${activeTab != 'assigned' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/manager/crm/customers?tab=unassigned">
                <i class="bi bi-people me-1"></i>Chưa giao
                <span class="badge ${activeTab != 'assigned' ? 'bg-warning text-dark' : 'bg-secondary'} ms-1">${countUnassigned}</span>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${activeTab == 'assigned' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/manager/crm/customers?tab=assigned">
                <i class="bi bi-people-fill me-1"></i>Đã giao
                <span class="badge ${activeTab == 'assigned' ? 'bg-success' : 'bg-secondary'} ms-1">${countAssigned}</span>
            </a>
        </li>
    </ul>

    <%-- Filters --%>
    <div class="card mb-4 shadow-sm">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/manager/crm/customers">
                <input type="hidden" name="tab" value="${activeTab}">
                <div class="row g-2 align-items-end">
                    <div class="col-md-3">
                        <label class="form-label fw-semibold small">Tìm kiếm</label>
                        <input type="text" name="keyword" class="form-control form-control-sm"
                               placeholder="Tên, mã, SĐT, email..." value="${keyword}">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label fw-semibold small">Phân khúc</label>
                        <select name="segment" class="form-select form-select-sm">
                            <option value="">-- Tất cả --</option>
                            <c:forEach var="sg" items="${segmentOptions}">
                                <option value="${sg}" ${segmentFilter == sg ? 'selected' : ''}>${sg}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label fw-semibold small">Từ ngày</label>
                        <input type="date" name="dateFrom" class="form-control form-control-sm" value="${dateFrom}">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label fw-semibold small">Đến ngày</label>
                        <input type="date" name="dateTo" class="form-control form-control-sm" value="${dateTo}">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-semibold small">Khóa học</label>
                        <select name="course" class="form-select form-select-sm">
                            <option value="">-- Tất cả --</option>
                            <c:forEach var="cr" items="${courseOptions}">
                                <option value="${cr}" ${courseFilter == cr ? 'selected' : ''}>${cr}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3 d-flex gap-2 align-items-end">
                        <button type="submit" class="btn btn-primary btn-sm flex-fill"><i class="bi bi-search me-1"></i>Lọc</button>
                        <a href="${pageContext.request.contextPath}/manager/crm/customers?tab=${activeTab}" class="btn btn-outline-secondary btn-sm" title="Xóa bộ lọc">
                            <i class="bi bi-arrow-counterclockwise"></i>
                        </a>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <%-- Summary --%>
    <div class="d-flex justify-content-between align-items-center mb-3">
        <span class="text-muted small">
            Tìm thấy <strong>${totalCustomers}</strong> khách hàng
            ${activeTab == 'assigned' ? 'đã giao' : 'chưa giao'}
        </span>
        <span class="text-muted small">Trang ${currentPage}/${totalPages}</span>
    </div>

    <%-- Table --%>
    <div class="card shadow-sm">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th>Mã KH</th>
                        <th>Họ tên</th>
                        <th>SĐT</th>
                        <th>Email</th>
                        <th>Phân khúc</th>
                        <th>Trạng thái</th>
                        <c:if test="${activeTab == 'assigned'}">
                            <th>Người phụ trách</th>
                        </c:if>
                        <th>Ngày tạo</th>
                        <th class="text-center">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty customers}">
                            <tr>
                                <td colspan="${activeTab == 'assigned' ? 8 : 8}" class="text-center py-5 text-muted">
                                    <i class="bi bi-inbox fs-3 d-block mb-2"></i>Không có Khách hàng nào phù hợp
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="cust" items="${customers}">
                                <tr>
                                    <td><span class="badge bg-light text-dark border">${cust.customerCode}</span></td>
                                    <td>
                                        <div class="fw-semibold">${cust.fullName}</div>
                                        <c:if test="${not empty cust.city}">
                                            <small class="text-muted"><i class="bi bi-geo-alt"></i> ${cust.city}</small>
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty cust.phone}">${cust.phone}</c:when>
                                            <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty cust.email}"><small>${cust.email}</small></c:when>
                                            <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty cust.customerSegment}">
                                                <span class="badge
                                                    ${cust.customerSegment == 'VIP'      ? 'bg-warning text-dark' :
                                                      cust.customerSegment == 'Premium'  ? 'bg-primary' :
                                                      cust.customerSegment == 'Standard' ? 'bg-info text-dark' :
                                                      'bg-secondary'}">
                                                    ${cust.customerSegment}
                                                </span>
                                            </c:when>
                                            <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty cust.status}">
                                                <span class="badge
                                                    ${cust.status == 'Active'    ? 'bg-success' :
                                                      cust.status == 'Inactive'  ? 'bg-secondary' :
                                                      cust.status == 'Churned'   ? 'bg-danger' :
                                                      'bg-warning text-dark'}">
                                                    ${cust.status}
                                                </span>
                                            </c:when>
                                            <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <c:if test="${activeTab == 'assigned'}">
                                        <td>
                                            <c:set var="ownerFound" value="false"/>
                                            <c:forEach var="u" items="${salesUsers}">
                                                <c:if test="${u.userId == cust.ownerId}">
                                                    <span class="badge bg-primary bg-opacity-10 text-primary">
                                                        <i class="bi bi-person-fill me-1"></i>${u.firstName} ${u.lastName}
                                                    </span>
                                                    <c:set var="ownerFound" value="true"/>
                                                </c:if>
                                            </c:forEach>
                                            <c:if test="${!ownerFound}">
                                                <span class="text-muted small">ID: ${cust.ownerId}</span>
                                            </c:if>
                                        </td>
                                    </c:if>
                                    <td>
                                        <c:if test="${cust.createdAt != null}">
                                            <small>${fn:substring(cust.createdAt.toString(), 8, 10)}/${fn:substring(cust.createdAt.toString(), 5, 7)}/${fn:substring(cust.createdAt.toString(), 0, 4)}</small>
                                        </c:if>
                                    </td>
                                    <td class="text-center">
                                        <div class="d-flex gap-1 justify-content-center">
                                            <button type="button" class="btn btn-sm btn-outline-secondary"
                                                    title="Xem chi tiết"
                                                    data-bs-toggle="modal" data-bs-target="#customerModal_${cust.customerId}">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <c:if test="${activeTab != 'assigned'}">
                                                <a href="${pageContext.request.contextPath}/manager/task/form?action=create&customerId=${cust.customerId}"
                                                   class="btn btn-sm btn-success" title="Giao việc">
                                                    <i class="bi bi-plus-circle me-1"></i>Giao việc
                                                </a>
                                            </c:if>
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
                    <a class="page-link" href="?tab=${activeTab}&page=${currentPage - 1}&keyword=${keyword}&status=${statusFilter}&segment=${segmentFilter}&dateFrom=${dateFrom}&dateTo=${dateTo}&course=${courseFilter}">
                        <i class="bi bi-chevron-left"></i>
                    </a>
                </li>
                <c:forEach begin="1" end="${totalPages}" var="p">
                    <c:if test="${p >= currentPage - 2 && p <= currentPage + 2}">
                        <li class="page-item ${p == currentPage ? 'active' : ''}">
                            <a class="page-link" href="?tab=${activeTab}&page=${p}&keyword=${keyword}&status=${statusFilter}&segment=${segmentFilter}&dateFrom=${dateFrom}&dateTo=${dateTo}&course=${courseFilter}">${p}</a>
                        </li>
                    </c:if>
                </c:forEach>
                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="?tab=${activeTab}&page=${currentPage + 1}&keyword=${keyword}&status=${statusFilter}&segment=${segmentFilter}&dateFrom=${dateFrom}&dateTo=${dateTo}&course=${courseFilter}">
                        <i class="bi bi-chevron-right"></i>
                    </a>
                </li>
            </ul>
        </nav>
    </c:if>
</div>


<c:forEach var="cust" items="${customers}">
    <div class="modal fade" id="customerModal_${cust.customerId}" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title">
                        <i class="bi bi-person-vcard me-2"></i>Chi tiết Khách hàng
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">

                    <%-- ── Header card ── --%>
                    <div class="d-flex align-items-center gap-3 mb-3 pb-3 border-bottom">
                        <div class="bg-success bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center" style="width:56px;height:56px">
                            <i class="bi bi-person-fill text-success fs-3"></i>
                        </div>
                        <div>
                            <h5 class="mb-0">${fn:escapeXml(cust.fullName)}</h5>
                            <span class="badge bg-light text-dark border me-1">${fn:escapeXml(cust.customerCode)}</span>
                            <c:if test="${not empty cust.customerSegment}">
                                <span class="badge ${cust.customerSegment == 'VIP' ? 'bg-warning text-dark' :
                                                      cust.customerSegment == 'Premium' ? 'bg-primary' :
                                                      cust.customerSegment == 'Standard' ? 'bg-info text-dark' : 'bg-secondary'}">
                                    ${fn:escapeXml(cust.customerSegment)}
                                </span>
                            </c:if>
                            <c:if test="${not empty cust.status}">
                                <span class="badge ${cust.status == 'Active' ? 'bg-success' :
                                                      cust.status == 'Inactive' ? 'bg-secondary' :
                                                      cust.status == 'Churned' ? 'bg-danger' : 'bg-warning text-dark'}">
                                    ${fn:escapeXml(cust.status)}
                                </span>
                            </c:if>
                        </div>
                    </div>

                    <%-- ── Thông tin cá nhân ── --%>
                    <h6 class="text-muted mb-2"><i class="bi bi-person me-1"></i>Thông tin cá nhân</h6>
                    <div class="row g-2 mb-3">
                        <div class="col-md-4">
                            <div class="mb-1"><small class="text-muted d-block">SĐT</small>
                            <span>${not empty cust.phone ? fn:escapeXml(cust.phone) : '<span class="text-muted">—</span>'}</span></div>
                        </div>
                        <div class="col-md-4">
                            <div class="mb-1"><small class="text-muted d-block">Email</small>
                            <span>${not empty cust.email ? fn:escapeXml(cust.email) : '<span class="text-muted">—</span>'}</span></div>
                        </div>
                        <div class="col-md-4">
                            <div class="mb-1"><small class="text-muted d-block">Giới tính</small>
                            <span>${not empty cust.gender ? fn:escapeXml(cust.gender) : '<span class="text-muted">—</span>'}</span></div>
                        </div>
                        <div class="col-md-4">
                            <div class="mb-1"><small class="text-muted d-block">Ngày sinh</small>
                            <span><c:choose>
                                <c:when test="${cust.dateOfBirth != null}">
                                    <c:set var="dob" value="${cust.dateOfBirth.toString()}"/>
                                    ${fn:substring(dob, 8, 10)}/${fn:substring(dob, 5, 7)}/${fn:substring(dob, 0, 4)}
                                </c:when>
                                <c:otherwise><span class="text-muted">—</span></c:otherwise>
                            </c:choose></span></div>
                        </div>
                        <div class="col-md-4">
                            <div class="mb-1"><small class="text-muted d-block">Địa chỉ</small>
                            <span>${not empty cust.address ? fn:escapeXml(cust.address) : '<span class="text-muted">—</span>'}</span></div>
                        </div>
                        <div class="col-md-4">
                            <div class="mb-1"><small class="text-muted d-block">Thành phố</small>
                            <span>${not empty cust.city ? fn:escapeXml(cust.city) : '<span class="text-muted">—</span>'}</span></div>
                        </div>
                    </div>

                    <%-- ── Thông tin CRM ── --%>
                    <h6 class="text-muted mb-2"><i class="bi bi-briefcase me-1"></i>Thông tin CRM</h6>
                    <div class="row g-2 mb-3">
                        <div class="col-md-4">
                            <div class="mb-1"><small class="text-muted d-block">Nguồn</small>
                            <span>${not empty sourceNameMap[cust.sourceId] ? fn:escapeXml(sourceNameMap[cust.sourceId]) : '<span class="text-muted">—</span>'}</span></div>
                        </div>
                        <div class="col-md-4">
                            <div class="mb-1"><small class="text-muted d-block">Người phụ trách</small>
                            <span><c:choose>
                                <c:when test="${not empty ownerNameMap[cust.ownerId]}">${fn:escapeXml(ownerNameMap[cust.ownerId])}</c:when>
                                <c:otherwise><span class="text-muted">Chưa giao</span></c:otherwise>
                            </c:choose></span></div>
                        </div>
                        <div class="col-md-4">
                            <div class="mb-1"><small class="text-muted d-block">Tổng khóa học</small>
                            <span>${cust.totalCourses}</span></div>
                        </div>
                        <div class="col-md-4">
                            <div class="mb-1"><small class="text-muted d-block">Tổng chi tiêu</small>
                            <span><c:choose>
                                <c:when test="${cust.totalSpent != null}"><fmt:formatNumber value="${cust.totalSpent}" type="number" groupingUsed="true"/> ₫</c:when>
                                <c:otherwise>0 ₫</c:otherwise>
                            </c:choose></span></div>
                        </div>
                        <div class="col-md-4">
                            <div class="mb-1"><small class="text-muted d-block">Mua lần đầu</small>
                            <span><c:choose>
                                <c:when test="${cust.firstPurchaseDate != null}">
                                    <c:set var="fpd" value="${cust.firstPurchaseDate.toString()}"/>
                                    ${fn:substring(fpd, 8, 10)}/${fn:substring(fpd, 5, 7)}/${fn:substring(fpd, 0, 4)}
                                </c:when>
                                <c:otherwise><span class="text-muted">—</span></c:otherwise>
                            </c:choose></span></div>
                        </div>
                        <div class="col-md-4">
                            <div class="mb-1"><small class="text-muted d-block">Mua gần nhất</small>
                            <span><c:choose>
                                <c:when test="${cust.lastPurchaseDate != null}">
                                    <c:set var="lpd" value="${cust.lastPurchaseDate.toString()}"/>
                                    ${fn:substring(lpd, 8, 10)}/${fn:substring(lpd, 5, 7)}/${fn:substring(lpd, 0, 4)}
                                </c:when>
                                <c:otherwise><span class="text-muted">—</span></c:otherwise>
                            </c:choose></span></div>
                        </div>
                    </div>

                    <%-- ── Chỉ số ── --%>
                    <div class="row g-2 mb-3">
                        <div class="col-md-3">
                            <div class="card border-0 bg-success bg-opacity-10 text-center p-2">
                                <small class="text-muted">Health Score</small>
                                <div class="fs-4 fw-bold text-success">${cust.healthScore != null ? cust.healthScore : '—'}</div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card border-0 bg-primary bg-opacity-10 text-center p-2">
                                <small class="text-muted">Satisfaction</small>
                                <div class="fs-4 fw-bold text-primary">${cust.satisfactionScore != null ? cust.satisfactionScore.toString().concat('/5') : '—'}</div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card border-0 bg-light text-center p-2">
                                <small class="text-muted">Email Opt-out</small>
                                <div class="fs-5">
                                    <c:choose>
                                        <c:when test="${cust.emailOptOut}"><i class="bi bi-x-circle text-danger"></i> Có</c:when>
                                        <c:otherwise><i class="bi bi-check-circle text-success"></i> Không</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card border-0 bg-light text-center p-2">
                                <small class="text-muted">SMS Opt-out</small>
                                <div class="fs-5">
                                    <c:choose>
                                        <c:when test="${cust.smsOptOut}"><i class="bi bi-x-circle text-danger"></i> Có</c:when>
                                        <c:otherwise><i class="bi bi-check-circle text-success"></i> Không</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%-- ── Khóa học đã đăng ký ── --%>
                    <c:set var="courses" value="${enrolledCoursesMap[cust.customerId]}"/>
                    <c:if test="${not empty courses}">
                        <h6 class="text-muted mb-2"><i class="bi bi-book me-1"></i>Khóa học đã đăng ký (${fn:length(courses)})</h6>
                        <c:forEach var="cr" items="${courses}">
                            <div class="card border mb-2">
                                <div class="card-body py-2 px-3">
                                    <%-- Row 1: Course name + code + level + payment badge --%>
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <div>
                                            <strong>${fn:escapeXml(cr.courseName)}</strong>
                                            <c:if test="${not empty cr.courseCode}">
                                                <span class="badge bg-light text-dark border ms-1">${fn:escapeXml(cr.courseCode)}</span>
                                            </c:if>
                                            <c:if test="${not empty cr.level}">
                                                <span class="badge bg-info text-dark">${fn:escapeXml(cr.level)}</span>
                                            </c:if>
                                        </div>
                                        <span class="badge ${cr.paymentStatus == 'Paid' ? 'bg-success' :
                                                             cr.paymentStatus == 'Pending' ? 'bg-warning text-dark' : 'bg-secondary'}">
                                            ${not empty cr.paymentStatus ? fn:escapeXml(cr.paymentStatus) : '—'}
                                        </span>
                                    </div>
                                    <%-- Row 2: Course details --%>
                                    <div class="row g-1 small text-muted mb-2">
                                        <c:if test="${not empty cr.instructorName}">
                                            <div class="col-auto"><i class="bi bi-person-workspace me-1"></i>${fn:escapeXml(cr.instructorName)}</div>
                                        </c:if>
                                        <c:if test="${not empty cr.durationHours}">
                                            <div class="col-auto"><i class="bi bi-clock me-1"></i>${cr.durationHours} giờ</div>
                                        </c:if>
                                        <c:if test="${not empty cr.totalLessons}">
                                            <div class="col-auto"><i class="bi bi-journal-text me-1"></i>${cr.totalLessons} bài</div>
                                        </c:if>
                                        <c:if test="${not empty cr.enrolledDate}">
                                            <div class="col-auto"><i class="bi bi-calendar-check me-1"></i>
                                                <c:set var="ed" value="${cr.enrolledDate.toString()}"/>
                                                ${fn:substring(ed, 8, 10)}/${fn:substring(ed, 5, 7)}/${fn:substring(ed, 0, 4)}
                                            </div>
                                        </c:if>
                                    </div>
                                    <%-- Row 3: Price + Progress --%>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="small">
                                            <c:if test="${not empty cr.finalAmount}">
                                                <strong><fmt:formatNumber value="${cr.finalAmount}" type="number" groupingUsed="true"/> ₫</strong>
                                            </c:if>
                                            <c:if test="${not empty cr.discountAmount and cr.discountAmount > 0}">
                                                <span class="text-success">(-<fmt:formatNumber value="${cr.discountAmount}" type="number" groupingUsed="true"/> ₫)</span>
                                            </c:if>
                                        </div>
                                        <div class="d-flex align-items-center gap-2">
                                            <span class="badge ${cr.learningStatus == 'Completed' ? 'bg-success' :
                                                                  cr.learningStatus == 'In Progress' ? 'bg-primary' : 'bg-secondary'} small">
                                                ${not empty cr.learningStatus ? fn:escapeXml(cr.learningStatus) : '—'}
                                            </span>
                                            <c:set var="prog" value="${cr.progressPercentage != null ? cr.progressPercentage : 0}"/>
                                            <div class="progress" style="width:80px;height:6px;">
                                                <div class="progress-bar bg-success" style="width:${prog}%"></div>
                                            </div>
                                            <small>${prog}%</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:if>

                    <%-- ── Ghi chú ── --%>
                    <c:if test="${not empty cust.notes}">
                        <hr>
                        <div>
                            <strong><i class="bi bi-sticky me-1"></i>Ghi chú:</strong>
                            <p class="mt-1 mb-0 text-muted fst-italic">${fn:escapeXml(cust.notes)}</p>
                        </div>
                    </c:if>

                    <%-- ── Ngày tạo ── --%>
                    <c:if test="${cust.createdAt != null}">
                        <div class="text-muted small mt-3 text-end">
                            <i class="bi bi-clock me-1"></i>Ngày tạo:
                            <c:set var="ca" value="${cust.createdAt.toString()}"/>
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
