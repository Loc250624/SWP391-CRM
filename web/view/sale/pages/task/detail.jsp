<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="container-fluid">

    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/sale/task/list">Công việc của tôi</a>
            </li>
            <li class="breadcrumb-item active">Chi tiết</li>
        </ol>
    </nav>

    <!-- Success/Error Messages -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle me-2"></i>${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="successMessage" scope="session" />
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle me-2"></i>${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="errorMessage" scope="session" />
    </c:if>

    <!-- Header Actions -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="mb-0"><i class="bi bi-file-earmark-text me-2"></i>Chi tiết Công việc</h3>
        <div class="d-flex gap-2">
            <c:if test="${task.statusName != 'COMPLETED' && task.statusName != 'CANCELLED'}">
                <form method="post" action="${pageContext.request.contextPath}/sale/task/status" class="d-inline"
                      onsubmit="return confirm('Bạn có chắc chắn muốn đánh dấu công việc này là Hoàn thành?');">
                    <input type="hidden" name="taskId" value="${task.taskId}">
                    <input type="hidden" name="status" value="COMPLETED">
                    <button type="submit" class="btn btn-success btn-sm">
                        <i class="bi bi-check2-circle me-1"></i>Đánh dấu Hoàn thành
                    </button>
                </form>
            </c:if>
            <c:if test="${task.statusName == 'COMPLETED'}">
                <span class="badge bg-success fs-6 py-2 px-3">
                    <i class="bi bi-check-circle me-1"></i>Đã hoàn thành
                </span>
            </c:if>
            <c:if test="${task.statusName == 'CANCELLED'}">
                <span class="badge bg-dark fs-6 py-2 px-3">
                    <i class="bi bi-x-circle me-1"></i>Đã hủy
                </span>
            </c:if>
            <a href="${pageContext.request.contextPath}/sale/task/list" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-arrow-left me-1"></i>Quay lại
            </a>
        </div>
    </div>

    <div class="row">
        <!-- Main Content -->
        <div class="col-lg-8">
            <!-- Task Info -->
            <div class="card mb-4">
                <div class="card-header bg-white">
                    <h5 class="mb-1">${task.title}</h5>
                    <div class="mt-1">
                        <span class="badge bg-secondary me-1">${task.taskCode}</span>
                        <c:choose>
                            <c:when test="${task.statusName == 'COMPLETED'}">
                                <span class="badge bg-success">Hoàn thành</span>
                            </c:when>
                            <c:when test="${task.statusName == 'IN_PROGRESS'}">
                                <span class="badge bg-info">Đang thực hiện</span>
                            </c:when>
                            <c:when test="${task.statusName == 'CANCELLED'}">
                                <span class="badge bg-dark">Đã hủy</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary">Chờ xử lý</span>
                            </c:otherwise>
                        </c:choose>
                        <c:choose>
                            <c:when test="${task.priorityName == 'HIGH'}">
                                <span class="badge bg-danger ms-1">Ưu tiên cao</span>
                            </c:when>
                            <c:when test="${task.priorityName == 'MEDIUM'}">
                                <span class="badge bg-warning text-dark ms-1">Ưu tiên trung bình</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary ms-1">Ưu tiên thấp</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="card-body">
                    <h6 class="fw-bold mb-2">Mô tả</h6>
                    <c:choose>
                        <c:when test="${not empty cleanDescription}">
                            <p class="text-muted">${cleanDescription}</p>
                        </c:when>
                        <c:when test="${not empty task.description && !fn:startsWith(task.description, '[DEPS:')}">
                            <p class="text-muted">${task.description}</p>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted fst-italic">Không có mô tả</p>
                        </c:otherwise>
                    </c:choose>

                    <hr>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <h6 class="fw-bold mb-1"><i class="bi bi-calendar-event me-1"></i>Hạn chót</h6>
                            <c:choose>
                                <c:when test="${task.dueDate != null}">
                                    <p class="mb-0" id="dueDateText">
                                        ${fn:substring(task.dueDate, 8, 10)}/${fn:substring(task.dueDate, 5, 7)}/${fn:substring(task.dueDate, 0, 4)}
                                        ${fn:substring(task.dueDate, 11, 16)}
                                    </p>
                                    <span id="overdueLabel"></span>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted mb-0">Không xác định</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="col-md-6 mb-3">
                            <h6 class="fw-bold mb-1"><i class="bi bi-bell me-1"></i>Nhắc nhở</h6>
                            <c:choose>
                                <c:when test="${task.reminderAt != null}">
                                    <p class="mb-0">
                                        ${fn:substring(task.reminderAt, 8, 10)}/${fn:substring(task.reminderAt, 5, 7)}/${fn:substring(task.reminderAt, 0, 4)}
                                        ${fn:substring(task.reminderAt, 11, 16)}
                                    </p>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted mb-0">Không có</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="col-md-6 mb-3">
                            <h6 class="fw-bold mb-1"><i class="bi bi-calendar-plus me-1"></i>Ngày tạo</h6>
                            <c:if test="${task.createdAt != null}">
                                <p class="mb-0">
                                    ${fn:substring(task.createdAt, 8, 10)}/${fn:substring(task.createdAt, 5, 7)}/${fn:substring(task.createdAt, 0, 4)}
                                    ${fn:substring(task.createdAt, 11, 16)}
                                </p>
                            </c:if>
                        </div>
                        <div class="col-md-6 mb-3">
                            <h6 class="fw-bold mb-1"><i class="bi bi-calendar-check me-1"></i>Hoàn thành</h6>
                            <c:choose>
                                <c:when test="${task.completedAt != null}">
                                    <p class="mb-0 text-success">
                                        ${fn:substring(task.completedAt, 8, 10)}/${fn:substring(task.completedAt, 5, 7)}/${fn:substring(task.completedAt, 0, 4)}
                                        ${fn:substring(task.completedAt, 11, 16)}
                                    </p>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted mb-0">Chưa hoàn thành</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Related Objects -->
            <c:if test="${not empty relatedLeads || not empty relatedCustomers || not empty relatedObjectName}">
                <div class="card mb-4">
                    <div class="card-header bg-white">
                        <h6 class="mb-0"><i class="bi bi-link-45deg me-2"></i>Đối tượng liên kết</h6>
                    </div>
                    <div class="card-body">
                        <%-- Lead list --%>
                        <c:forEach var="ld" items="${relatedLeads}" varStatus="ls">
                            <div class="d-flex align-items-center justify-content-between ${!ls.last || not empty relatedCustomers ? 'mb-3 pb-3 border-bottom' : ''}">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="bg-primary bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center"
                                         style="width:40px;height:40px;">
                                        <i class="bi bi-person-lines-fill text-primary"></i>
                                    </div>
                                    <div>
                                        <div class="fw-semibold">${fn:escapeXml(ld.fullName)}</div>
                                        <small class="text-muted">${ld.leadCode} · ${not empty ld.phone ? ld.phone : ld.email}</small>
                                    </div>
                                </div>
                                <div class="d-flex align-items-center gap-2">
                                    <c:choose>
                                        <c:when test="${ld.status == 'New'}"><span class="badge bg-secondary">${ld.status}</span></c:when>
                                        <c:when test="${ld.status == 'Assigned'}"><span class="badge bg-primary">${ld.status}</span></c:when>
                                        <c:when test="${ld.status == 'Working'}"><span class="badge bg-info">${ld.status}</span></c:when>
                                        <c:when test="${ld.status == 'Converted'}"><span class="badge bg-success">${ld.status}</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary">${ld.status}</span></c:otherwise>
                                    </c:choose>
                                    <button type="button" class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#leadModal-${ld.leadId}">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                        <%-- Customer list --%>
                        <c:forEach var="cust" items="${relatedCustomers}" varStatus="cs">
                            <div class="d-flex align-items-center justify-content-between ${!cs.last ? 'mb-3 pb-3 border-bottom' : ''}">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="bg-success bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center"
                                         style="width:40px;height:40px;">
                                        <i class="bi bi-people-fill text-success"></i>
                                    </div>
                                    <div>
                                        <div class="fw-semibold">${fn:escapeXml(cust.fullName)}</div>
                                        <small class="text-muted">${cust.customerCode} · ${not empty cust.phone ? cust.phone : cust.email}</small>
                                    </div>
                                </div>
                                <div class="d-flex align-items-center gap-2">
                                    <c:if test="${not empty cust.status}"><span class="badge bg-success">${cust.status}</span></c:if>
                                    <button type="button" class="btn btn-sm btn-outline-success" data-bs-toggle="modal" data-bs-target="#custModal-${cust.customerId}">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                        <%-- Single related object fallback --%>
                        <c:if test="${empty relatedLeads && empty relatedCustomers && not empty relatedObjectName}">
                            <div class="d-flex align-items-center justify-content-between">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="${task.relatedType == 'LEAD' || task.relatedType == 'Lead' ? 'bg-primary' : 'bg-success'} bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center"
                                         style="width:40px;height:40px;">
                                        <i class="bi ${task.relatedType == 'LEAD' || task.relatedType == 'Lead' ? 'bi-person-lines-fill text-primary' : 'bi-people-fill text-success'}"></i>
                                    </div>
                                    <div>
                                        <div class="fw-semibold">${relatedObjectName}</div>
                                        <small class="text-muted">${task.relatedType}</small>
                                    </div>
                                </div>
                                <c:if test="${not empty relatedLead || not empty relatedCustomer}">
                                    <button type="button" class="btn btn-sm ${not empty relatedLead ? 'btn-outline-primary' : 'btn-outline-success'}"
                                            data-bs-toggle="modal" data-bs-target="#relatedObjectModal">
                                        <i class="bi bi-eye me-1"></i>Chi tiết
                                    </button>
                                </c:if>
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:if>

            <!-- Comments -->
            <div class="card mb-4">
                <div class="card-header bg-white">
                    <h6 class="mb-0"><i class="bi bi-chat-left-text me-2"></i>Bình luận (${fn:length(comments)})</h6>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${empty comments}">
                            <p class="text-muted fst-italic mb-3">Chưa có bình luận nào</p>
                        </c:when>
                        <c:otherwise>
                            <ul class="list-unstyled mb-3">
                                <c:forEach var="cmt" items="${comments}">
                                    <li class="mb-3 d-flex gap-2">
                                        <div class="bg-secondary rounded-circle d-flex align-items-center justify-content-center text-white flex-shrink-0"
                                             style="width:32px;height:32px;font-size:0.75rem;">
                                            <c:forEach var="u" items="${allUsers}">
                                                <c:if test="${u.userId == cmt.createdBy}">${fn:substring(u.firstName,0,1)}</c:if>
                                            </c:forEach>
                                        </div>
                                        <div class="bg-light rounded p-2 flex-grow-1">
                                            <div class="d-flex justify-content-between mb-1">
                                                <strong class="small">
                                                    <c:forEach var="u" items="${allUsers}">
                                                        <c:if test="${u.userId == cmt.createdBy}">${u.firstName} ${u.lastName}</c:if>
                                                    </c:forEach>
                                                </strong>
                                                <small class="text-muted">
                                                    ${fn:substring(cmt.createdAt, 8, 10)}/${fn:substring(cmt.createdAt, 5, 7)}/${fn:substring(cmt.createdAt, 0, 4)}
                                                    ${fn:substring(cmt.createdAt, 11, 16)}
                                                </small>
                                            </div>
                                            <p class="mb-0 small">${cmt.content}</p>
                                        </div>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:otherwise>
                    </c:choose>

                    <!-- Comment form -->
                    <c:if test="${task.statusName != 'CANCELLED'}">
                        <form method="post" action="${pageContext.request.contextPath}/sale/task/comment">
                            <input type="hidden" name="taskId" value="${task.taskId}">
                            <div class="input-group">
                                <input type="text" class="form-control form-control-sm"
                                       name="content" placeholder="Thêm bình luận..." required maxlength="500">
                                <button type="submit" class="btn btn-sm btn-primary">
                                    <i class="bi bi-send"></i>
                                </button>
                            </div>
                        </form>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Sidebar -->
        <div class="col-lg-4">
            <!-- Assigned Members -->
            <div class="card mb-3">
                <div class="card-header bg-white">
                    <c:choose>
                        <c:when test="${isGroupTask}">
                            <h6 class="mb-0">
                                <i class="bi bi-people me-2"></i>Nhóm thực hiện
                                <span class="badge bg-primary ms-1">${fn:length(groupMembers)} người</span>
                            </h6>
                        </c:when>
                        <c:otherwise>
                            <h6 class="mb-0"><i class="bi bi-person me-2"></i>Người thực hiện</h6>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${isGroupTask}">
                            <c:forEach var="member" items="${groupMembers}" varStatus="ms">
                                <div class="d-flex align-items-center justify-content-between ${!ms.last ? 'mb-3 pb-3 border-bottom' : ''}">
                                    <div class="d-flex align-items-center">
                                        <div class="bg-primary rounded-circle d-flex align-items-center justify-content-center text-white me-2"
                                             style="width:36px;height:36px;font-size:0.8rem;font-weight:600;">
                                            ${fn:substring(member.firstName, 0, 1)}${fn:substring(member.lastName, 0, 1)}
                                        </div>
                                        <div>
                                            <div class="fw-medium small">${member.firstName} ${member.lastName}</div>
                                            <small class="text-muted">${member.email}</small>
                                        </div>
                                    </div>
                                    <c:forEach var="ta" items="${assigneeList}">
                                        <c:if test="${ta.userId == member.userId}">
                                            <c:choose>
                                                <c:when test="${ta.taskStatus == 2}"><span class="badge bg-success">Hoàn thành</span></c:when>
                                                <c:when test="${ta.taskStatus == 1}"><span class="badge bg-info">Đang làm</span></c:when>
                                                <c:when test="${ta.taskStatus == 3}"><span class="badge bg-dark">Đã hủy</span></c:when>
                                                <c:otherwise><span class="badge bg-secondary">Chờ xử lý</span></c:otherwise>
                                            </c:choose>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="text-muted small">Bạn là người thực hiện công việc này</div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Creator -->
            <div class="card mb-3">
                <div class="card-header bg-white">
                    <h6 class="mb-0"><i class="bi bi-person-plus me-2"></i>Người tạo</h6>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${creator != null}">
                            <div class="d-flex align-items-center">
                                <div class="bg-secondary rounded-circle d-flex align-items-center justify-content-center text-white me-3"
                                     style="width:40px;height:40px;font-size:0.875rem;font-weight:600;">
                                    ${fn:substring(creator.firstName, 0, 1)}${fn:substring(creator.lastName, 0, 1)}
                                </div>
                                <div>
                                    <h6 class="mb-0">${creator.firstName} ${creator.lastName}</h6>
                                    <small class="text-muted">${creator.email}</small>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted mb-0">Không xác định</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Note -->
            <c:if test="${task.statusName != 'COMPLETED' && task.statusName != 'CANCELLED'}">
                <div class="card bg-light border-0">
                    <div class="card-body">
                        <h6 class="mb-2"><i class="bi bi-info-circle me-2"></i>Ghi chú</h6>
                        <ul class="list-unstyled small mb-0">
                            <li class="mb-1">
                                <i class="bi bi-check2 text-success me-1"></i>
                                Bạn có thể cập nhật trạng thái và bình luận
                            </li>
                            <li class="mb-1">
                                <i class="bi bi-check2 text-success me-1"></i>
                                Không thể thay đổi tiêu đề, hạn chót, ưu tiên
                            </li>
                            <li>
                                <i class="bi bi-check2 text-success me-1"></i>
                                Liên hệ quản lý để thay đổi thông tin khác
                            </li>
                        </ul>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</div>

<%-- ═══════════════ Lead Detail Modals (multiple) ═══════════════ --%>
<c:forEach var="ld" items="${relatedLeads}">
    <div class="modal fade" id="leadModal-${ld.leadId}" tabindex="-1" aria-labelledby="leadModalLabel-${ld.leadId}" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header bg-primary bg-opacity-10">
                    <h5 class="modal-title" id="leadModalLabel-${ld.leadId}">
                        <i class="bi bi-person-lines-fill text-primary me-2"></i>Chi tiết Lead
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Mã Lead</label>
                            <div class="fw-semibold">${fn:escapeXml(ld.leadCode)}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Họ tên</label>
                            <div class="fw-semibold">${fn:escapeXml(ld.fullName)}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Email</label>
                            <div>${not empty ld.email ? fn:escapeXml(ld.email) : '<span class="text-muted fst-italic">Chưa có</span>'}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Số điện thoại</label>
                            <div>${not empty ld.phone ? fn:escapeXml(ld.phone) : '<span class="text-muted fst-italic">Chưa có</span>'}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Chức danh</label>
                            <div>${not empty ld.jobTitle ? fn:escapeXml(ld.jobTitle) : '<span class="text-muted fst-italic">Chưa có</span>'}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Công ty</label>
                            <div>${not empty ld.companyName ? fn:escapeXml(ld.companyName) : '<span class="text-muted fst-italic">Chưa có</span>'}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Sở thích / Quan tâm</label>
                            <div>${not empty ld.interests ? fn:escapeXml(ld.interests) : '<span class="text-muted fst-italic">Chưa có</span>'}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Trạng thái</label>
                            <div>
                                <c:choose>
                                    <c:when test="${ld.status == 'New'}"><span class="badge bg-secondary">${ld.status}</span></c:when>
                                    <c:when test="${ld.status == 'Assigned'}"><span class="badge bg-primary">${ld.status}</span></c:when>
                                    <c:when test="${ld.status == 'Working'}"><span class="badge bg-info">${ld.status}</span></c:when>
                                    <c:when test="${ld.status == 'Converted'}"><span class="badge bg-success">${ld.status}</span></c:when>
                                    <c:otherwise><span class="badge bg-secondary">${ld.status}</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Đánh giá (Rating)</label>
                            <div>${not empty ld.rating ? ld.rating : '<span class="text-muted fst-italic">Chưa có</span>'}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Điểm Lead</label>
                            <div>${ld.leadScore != null ? ld.leadScore : '<span class="text-muted fst-italic">Chưa có</span>'}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Chuyển đổi</label>
                            <div>
                                <c:choose>
                                    <c:when test="${ld.isConverted}"><span class="badge bg-success">Đã chuyển đổi</span></c:when>
                                    <c:otherwise><span class="badge bg-warning text-dark">Chưa chuyển đổi</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <c:if test="${ld.isConverted && ld.convertedAt != null}">
                            <div class="col-md-6">
                                <label class="form-label text-muted small mb-0">Ngày chuyển đổi</label>
                                <div>${fn:substring(ld.convertedAt, 8, 10)}/${fn:substring(ld.convertedAt, 5, 7)}/${fn:substring(ld.convertedAt, 0, 4)}</div>
                            </div>
                        </c:if>
                        <div class="col-12">
                            <label class="form-label text-muted small mb-0">Ghi chú</label>
                            <div class="bg-light rounded p-2">${not empty ld.notes ? fn:escapeXml(ld.notes) : '<span class="text-muted fst-italic">Không có ghi chú</span>'}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Ngày tạo</label>
                            <div class="small text-muted">
                                <c:if test="${ld.createdAt != null}">${fn:substring(ld.createdAt, 8, 10)}/${fn:substring(ld.createdAt, 5, 7)}/${fn:substring(ld.createdAt, 0, 4)} ${fn:substring(ld.createdAt, 11, 16)}</c:if>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Cập nhật lần cuối</label>
                            <div class="small text-muted">
                                <c:if test="${ld.updatedAt != null}">${fn:substring(ld.updatedAt, 8, 10)}/${fn:substring(ld.updatedAt, 5, 7)}/${fn:substring(ld.updatedAt, 0, 4)} ${fn:substring(ld.updatedAt, 11, 16)}</c:if>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>
</c:forEach>

<%-- ═══════════════ Customer Detail Modals (multiple) ═══════════════ --%>
<c:forEach var="cust" items="${relatedCustomers}">
    <div class="modal fade" id="custModal-${cust.customerId}" tabindex="-1" aria-labelledby="custModalLabel-${cust.customerId}" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header bg-success bg-opacity-10">
                    <h5 class="modal-title" id="custModalLabel-${cust.customerId}">
                        <i class="bi bi-people-fill text-success me-2"></i>Chi tiết Khách hàng
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Mã KH</label>
                            <div class="fw-semibold">${fn:escapeXml(cust.customerCode)}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Họ tên</label>
                            <div class="fw-semibold">${fn:escapeXml(cust.fullName)}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Email</label>
                            <div>${not empty cust.email ? fn:escapeXml(cust.email) : '<span class="text-muted fst-italic">Chưa có</span>'}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Số điện thoại</label>
                            <div>${not empty cust.phone ? fn:escapeXml(cust.phone) : '<span class="text-muted fst-italic">Chưa có</span>'}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Ngày sinh</label>
                            <div>
                                <c:choose>
                                    <c:when test="${cust.dateOfBirth != null}">${fn:substring(cust.dateOfBirth, 8, 10)}/${fn:substring(cust.dateOfBirth, 5, 7)}/${fn:substring(cust.dateOfBirth, 0, 4)}</c:when>
                                    <c:otherwise><span class="text-muted fst-italic">Chưa có</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Giới tính</label>
                            <div>
                                <c:choose>
                                    <c:when test="${cust.gender == 'Male'}">Nam</c:when>
                                    <c:when test="${cust.gender == 'Female'}">Nữ</c:when>
                                    <c:when test="${not empty cust.gender}">${cust.gender}</c:when>
                                    <c:otherwise><span class="text-muted fst-italic">Chưa có</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Địa chỉ</label>
                            <div>${not empty cust.address ? fn:escapeXml(cust.address) : '<span class="text-muted fst-italic">Chưa có</span>'}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Thành phố</label>
                            <div>${not empty cust.city ? fn:escapeXml(cust.city) : '<span class="text-muted fst-italic">Chưa có</span>'}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Phân khúc</label>
                            <div>${not empty cust.customerSegment ? cust.customerSegment : '<span class="text-muted fst-italic">Chưa có</span>'}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Trạng thái</label>
                            <div><c:if test="${not empty cust.status}"><span class="badge bg-success">${cust.status}</span></c:if></div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Tổng khóa học</label>
                            <div>${cust.totalCourses != null ? cust.totalCourses : 0}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Tổng chi tiêu</label>
                            <div class="fw-semibold text-success">${cust.totalSpent != null ? cust.totalSpent : 0} VNĐ</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Điểm sức khỏe</label>
                            <div>
                                <c:choose>
                                    <c:when test="${cust.healthScore != null && cust.healthScore >= 80}"><span class="badge bg-success">${cust.healthScore}</span></c:when>
                                    <c:when test="${cust.healthScore != null && cust.healthScore >= 50}"><span class="badge bg-warning text-dark">${cust.healthScore}</span></c:when>
                                    <c:when test="${cust.healthScore != null}"><span class="badge bg-danger">${cust.healthScore}</span></c:when>
                                    <c:otherwise><span class="text-muted fst-italic">N/A</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Điểm hài lòng</label>
                            <div>
                                <c:choose>
                                    <c:when test="${cust.satisfactionScore != null && cust.satisfactionScore >= 80}"><span class="badge bg-success">${cust.satisfactionScore}</span></c:when>
                                    <c:when test="${cust.satisfactionScore != null && cust.satisfactionScore >= 50}"><span class="badge bg-warning text-dark">${cust.satisfactionScore}</span></c:when>
                                    <c:when test="${cust.satisfactionScore != null}"><span class="badge bg-danger">${cust.satisfactionScore}</span></c:when>
                                    <c:otherwise><span class="text-muted fst-italic">N/A</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-12">
                            <label class="form-label text-muted small mb-0">Ghi chú</label>
                            <div class="bg-light rounded p-2">${not empty cust.notes ? fn:escapeXml(cust.notes) : '<span class="text-muted fst-italic">Không có ghi chú</span>'}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Ngày tạo</label>
                            <div class="small text-muted">
                                <c:if test="${cust.createdAt != null}">${fn:substring(cust.createdAt, 8, 10)}/${fn:substring(cust.createdAt, 5, 7)}/${fn:substring(cust.createdAt, 0, 4)} ${fn:substring(cust.createdAt, 11, 16)}</c:if>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Cập nhật lần cuối</label>
                            <div class="small text-muted">
                                <c:if test="${cust.updatedAt != null}">${fn:substring(cust.updatedAt, 8, 10)}/${fn:substring(cust.updatedAt, 5, 7)}/${fn:substring(cust.updatedAt, 0, 4)} ${fn:substring(cust.updatedAt, 11, 16)}</c:if>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>
</c:forEach>

<%-- ═══════════════ Single Lead Fallback Modal ═══════════════ --%>
<c:if test="${empty relatedLeads && not empty relatedLead}">
    <div class="modal fade" id="relatedObjectModal" tabindex="-1" aria-labelledby="relatedObjectModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header bg-primary bg-opacity-10">
                    <h5 class="modal-title" id="relatedObjectModalLabel">
                        <i class="bi bi-person-lines-fill text-primary me-2"></i>Chi tiết Lead
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Mã Lead</label>
                            <div class="fw-semibold">${fn:escapeXml(relatedLead.leadCode)}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Họ tên</label>
                            <div class="fw-semibold">${fn:escapeXml(relatedLead.fullName)}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Email</label>
                            <div>${not empty relatedLead.email ? fn:escapeXml(relatedLead.email) : '<span class="text-muted fst-italic">Chưa có</span>'}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Số điện thoại</label>
                            <div>${not empty relatedLead.phone ? fn:escapeXml(relatedLead.phone) : '<span class="text-muted fst-italic">Chưa có</span>'}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Chức danh</label>
                            <div>${not empty relatedLead.jobTitle ? fn:escapeXml(relatedLead.jobTitle) : '<span class="text-muted fst-italic">Chưa có</span>'}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Công ty</label>
                            <div>${not empty relatedLead.companyName ? fn:escapeXml(relatedLead.companyName) : '<span class="text-muted fst-italic">Chưa có</span>'}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Trạng thái</label>
                            <div>
                                <c:choose>
                                    <c:when test="${relatedLead.status == 'New'}"><span class="badge bg-secondary">${relatedLead.status}</span></c:when>
                                    <c:when test="${relatedLead.status == 'Assigned'}"><span class="badge bg-primary">${relatedLead.status}</span></c:when>
                                    <c:when test="${relatedLead.status == 'Working'}"><span class="badge bg-info">${relatedLead.status}</span></c:when>
                                    <c:when test="${relatedLead.status == 'Converted'}"><span class="badge bg-success">${relatedLead.status}</span></c:when>
                                    <c:otherwise><span class="badge bg-secondary">${relatedLead.status}</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Điểm Lead</label>
                            <div>${relatedLead.leadScore != null ? relatedLead.leadScore : '<span class="text-muted fst-italic">Chưa có</span>'}</div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>
</c:if>

<%-- ═══════════════ Single Customer Fallback Modal ═══════════════ --%>
<c:if test="${empty relatedCustomers && not empty relatedCustomer}">
    <div class="modal fade" id="relatedObjectModal" tabindex="-1" aria-labelledby="relatedObjectModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header bg-success bg-opacity-10">
                    <h5 class="modal-title" id="relatedObjectModalLabel">
                        <i class="bi bi-people-fill text-success me-2"></i>Chi tiết Khách hàng
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Mã KH</label>
                            <div class="fw-semibold">${fn:escapeXml(relatedCustomer.customerCode)}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Họ tên</label>
                            <div class="fw-semibold">${fn:escapeXml(relatedCustomer.fullName)}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Email</label>
                            <div>${not empty relatedCustomer.email ? fn:escapeXml(relatedCustomer.email) : '<span class="text-muted fst-italic">Chưa có</span>'}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Số điện thoại</label>
                            <div>${not empty relatedCustomer.phone ? fn:escapeXml(relatedCustomer.phone) : '<span class="text-muted fst-italic">Chưa có</span>'}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Phân khúc</label>
                            <div>${not empty relatedCustomer.customerSegment ? relatedCustomer.customerSegment : '<span class="text-muted fst-italic">Chưa có</span>'}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Trạng thái</label>
                            <div><c:if test="${not empty relatedCustomer.status}"><span class="badge bg-success">${relatedCustomer.status}</span></c:if></div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>
</c:if>

<script>
document.addEventListener('DOMContentLoaded', function () {
    <c:if test="${task.dueDate != null && task.statusName != 'COMPLETED' && task.statusName != 'CANCELLED'}">
    (function () {
        var dueStr = '${fn:substring(task.dueDate, 0, 10)}';
        var today = new Date();
        today.setHours(0, 0, 0, 0);
        var due = new Date(dueStr);
        if (due < today) {
            var label = document.getElementById('overdueLabel');
            if (label) label.innerHTML = '<span class="badge bg-danger mt-1">Quá hạn</span>';
            var txt = document.getElementById('dueDateText');
            if (txt) txt.classList.add('text-danger', 'fw-bold');
        }
    }());
    </c:if>
});
</script>
