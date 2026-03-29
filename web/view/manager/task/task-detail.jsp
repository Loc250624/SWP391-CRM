<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="container-fluid">
    <!-- Header -->
    <div class="mb-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/manager/task/list">Công việc</a>
                </li>
                <li class="breadcrumb-item active">Chi tiết</li>
            </ol>
        </nav>
        <div class="d-flex justify-content-between align-items-center">
            <h3><i class="bi bi-file-earmark-text me-2"></i>Chi tiết Công việc</h3>
            <div class="d-flex gap-2 flex-wrap">
                <c:if test="${task.statusName != 'COMPLETED' && task.statusName != 'CANCELLED'}">
                    <form method="post"
                          action="${pageContext.request.contextPath}/manager/task/status"
                          class="d-inline"
                          onsubmit="return confirm('Bạn có chắc chắn muốn HỦY công việc này? Hành động này không thể hoàn tác.');">
                        <input type="hidden" name="taskId" value="${task.taskId}">
                        <input type="hidden" name="status" value="CANCELLED">
                        <button type="submit" class="btn btn-danger btn-sm">
                            <i class="bi bi-x-circle me-1"></i>Hủy công việc
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
            </div>
        </div>
    </div>

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

    <div class="row">
        <!-- Main Content -->
        <div class="col-lg-8">
            <div class="card mb-4">
                <div class="card-header bg-white">
                    <h5 class="mb-0">${task.title}</h5>
                    <div class="mt-2">
                        <span class="badge bg-secondary me-2">${task.taskCode}</span>
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
                                <span class="badge bg-danger ms-2">Ưu tiên cao</span>
                            </c:when>
                            <c:when test="${task.priorityName == 'MEDIUM'}">
                                <span class="badge bg-warning text-dark ms-2">Ưu tiên trung bình</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary ms-2">Ưu tiên thấp</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="card-body">
                    <h6 class="fw-bold mb-3">Mô tả</h6>
                    <c:choose>
                        <c:when test="${not empty cleanDescription}">
                            <p class="text-muted">${cleanDescription}</p>
                        </c:when>
                        <c:when test="${empty cleanDescription && not empty task.description && !fn:startsWith(task.description, '[DEPS:')}">
                            <p class="text-muted">${task.description}</p>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted fst-italic">Không có mô tả</p>
                        </c:otherwise>
                    </c:choose>

                    <hr class="my-4">

                    <!-- Timeline Info -->
                    <%-- FIX: Replace fmt:formatDate (only works with java.util.Date) with fn:substring.
                         LocalDateTime.toString() = "YYYY-MM-DDTHH:mm:ss[.nanos]"
                         We extract: day=8-10, month=5-7, year=0-4, time=11-16 --%>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <h6 class="fw-bold mb-2">
                                <i class="bi bi-calendar-event me-2"></i>Hạn chót
                            </h6>
                            <c:choose>
                                <c:when test="${task.dueDate != null}">
                                    <p class="mb-0" id="dueDateText">
                                        ${fn:substring(task.dueDate, 8, 10)}/${fn:substring(task.dueDate, 5, 7)}/${fn:substring(task.dueDate, 0, 4)}
                                        ${fn:substring(task.dueDate, 11, 16)}
                                    </p>
                                    <%-- FIX: Overdue badge rendered by JS below --%>
                                    <span id="overdueLabel"></span>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted mb-0">Không xác định</p>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="col-md-6 mb-3">
                            <h6 class="fw-bold mb-2">
                                <i class="bi bi-bell me-2"></i>Nhắc nhở
                            </h6>
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
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <h6 class="fw-bold mb-2">
                                <i class="bi bi-calendar-plus me-2"></i>Ngày tạo
                            </h6>
                            <c:if test="${task.createdAt != null}">
                                <p class="mb-0">
                                    ${fn:substring(task.createdAt, 8, 10)}/${fn:substring(task.createdAt, 5, 7)}/${fn:substring(task.createdAt, 0, 4)}
                                    ${fn:substring(task.createdAt, 11, 16)}
                                </p>
                            </c:if>
                        </div>

                        <div class="col-md-6 mb-3">
                            <h6 class="fw-bold mb-2">
                                <i class="bi bi-calendar-check me-2"></i>Hoàn thành
                            </h6>
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

            <!-- Related Objects: Compact cards + Modal popup -->
            <c:if test="${not empty relatedLeads || not empty relatedCustomers || relatedObject != null}">
                <div class="card mb-4">
                    <div class="card-header bg-white">
                        <h6 class="mb-0"><i class="bi bi-link-45deg me-2"></i>Đối tượng liên kết</h6>
                    </div>
                    <div class="card-body">
                        <%-- Lead list --%>
                        <c:forEach var="ld" items="${relatedLeads}" varStatus="ls">
                            <div class="d-flex align-items-center justify-content-between ${!ls.last || not empty relatedCustomers ? 'mb-3 pb-3 border-bottom' : ''}">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="avatar-md bg-primary bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center">
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
                                    <div class="avatar-md bg-success bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center">
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
                        <c:if test="${empty relatedLeads && empty relatedCustomers && relatedObject != null}">
                            <div class="d-flex align-items-center justify-content-between">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="avatar-md ${task.relatedType == 'LEAD' || task.relatedType == 'Lead' ? 'bg-primary' : 'bg-success'} bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center">
                                        <i class="bi ${task.relatedType == 'LEAD' || task.relatedType == 'Lead' ? 'bi-person-lines-fill text-primary' : 'bi-people-fill text-success'}"></i>
                                    </div>
                                    <div>
                                        <div class="fw-semibold">${relatedObjectName}</div>
                                        <small class="text-muted">${task.relatedType}</small>
                                    </div>
                                </div>
                                <button type="button" class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#singleObjModal">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:if>

            <!-- Dependencies -->
            <c:if test="${not empty dependencyTasks}">
                <div class="card mb-4">
                    <div class="card-header bg-white">
                        <h6 class="mb-0">
                            <i class="bi bi-lock me-2 ${allDepsCompleted ? 'text-success' : 'text-danger'}"></i>
                            Công việc phụ thuộc
                            <c:if test="${!allDepsCompleted}">
                                <span class="badge bg-danger ms-2">Đang bị chặn</span>
                            </c:if>
                            <c:if test="${allDepsCompleted}">
                                <span class="badge bg-success ms-2">Đã giải phóng</span>
                            </c:if>
                        </h6>
                    </div>
                    <div class="card-body">
                        <c:if test="${!allDepsCompleted}">
                            <div class="alert alert-warning py-2 mb-3">
                                <i class="bi bi-exclamation-triangle me-2"></i>
                                Công việc này bị chặn — cần hoàn thành các công việc phụ thuộc trước khi bắt đầu.
                            </div>
                        </c:if>
                        <ul class="list-unstyled mb-0">
                            <c:forEach var="dep" items="${dependencyTasks}">
                                <li class="d-flex align-items-center mb-2">
                                    <c:choose>
                                        <c:when test="${dep.statusName == 'COMPLETED'}">
                                            <i class="bi bi-check-circle-fill text-success me-2"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="bi bi-x-circle-fill text-danger me-2"></i>
                                        </c:otherwise>
                                    </c:choose>
                                    <a href="${pageContext.request.contextPath}/manager/task/detail?id=${dep.taskId}"
                                       class="text-decoration-none">
                                        <span class="badge bg-secondary me-1">${dep.taskCode}</span>
                                        ${dep.title}
                                    </a>
                                    <c:choose>
                                        <c:when test="${dep.statusName == 'COMPLETED'}">
                                            <span class="badge bg-success ms-2">Hoàn thành</span>
                                        </c:when>
                                        <c:when test="${dep.statusName == 'IN_PROGRESS'}">
                                            <span class="badge bg-info ms-2">Đang làm</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary ms-2">Chờ xử lý</span>
                                        </c:otherwise>
                                    </c:choose>
                                </li>
                            </c:forEach>
                        </ul>
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
                                        <div class="avatar-sm bg-secondary rounded-circle d-flex align-items-center justify-content-center text-white flex-shrink-0" style="width:32px;height:32px;font-size:0.75rem;">
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
                                                <div class="d-flex align-items-center gap-2">
                                                    <small class="text-muted">
                                                        ${fn:substring(cmt.createdAt, 8, 10)}/${fn:substring(cmt.createdAt, 5, 7)}/${fn:substring(cmt.createdAt, 0, 4)}
                                                        ${fn:substring(cmt.createdAt, 11, 16)}
                                                    </small>
                                                    <form method="post" action="${pageContext.request.contextPath}/manager/task/comment"
                                                          class="d-inline" onsubmit="return confirm('Bạn có chắc muốn xóa bình luận này?');">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="commentId" value="${cmt.commentId}">
                                                        <input type="hidden" name="taskId" value="${task.taskId}">
                                                        <button type="submit" class="btn btn-link btn-sm text-danger p-0" title="Xóa bình luận">
                                                            <i class="bi bi-trash"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                            <p class="mb-0 small">${cmt.content}</p>
                                        </div>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:otherwise>
                    </c:choose>
                    <c:if test="${task.statusName != 'CANCELLED'}">
                    <form method="post" action="${pageContext.request.contextPath}/manager/task/comment">
                        <input type="hidden" name="taskId" value="${task.taskId}">
                        <div class="input-group">
                            <input type="text" class="form-control form-control-sm"
                                   name="content" placeholder="Thêm bình luận..." required maxlength="500">
                            <button type="submit" class="btn btn-sm btn-success">
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
            <!-- Assigned User / Group Members -->
            <div class="card mb-4">
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
                            <%-- Group task: show all members with their status --%>
                            <c:forEach var="member" items="${groupMembers}" varStatus="ms">
                                <div class="d-flex align-items-center justify-content-between ${!ms.last ? 'mb-3 pb-3 border-bottom' : ''}">
                                    <div class="d-flex align-items-center">
                                        <div class="avatar-md bg-primary rounded-circle d-flex align-items-center justify-content-center text-white me-2">
                                            ${fn:substring(member.firstName, 0, 1)}${fn:substring(member.lastName, 0, 1)}
                                        </div>
                                        <div>
                                            <div class="fw-medium">${member.firstName} ${member.lastName}</div>
                                            <small class="text-muted">${member.email}</small>
                                        </div>
                                    </div>
                                    <%-- Find member status from groupMemberTasks --%>
                                    <c:forEach var="mt" items="${groupMemberTasks}">
                                        <c:if test="${mt.assignedTo == member.userId}">
                                            <c:choose>
                                                <c:when test="${mt.statusName == 'COMPLETED'}"><span class="badge bg-success">Hoàn thành</span></c:when>
                                                <c:when test="${mt.statusName == 'IN_PROGRESS'}"><span class="badge bg-info">Đang làm</span></c:when>
                                                <c:when test="${mt.statusName == 'CANCELLED'}"><span class="badge bg-dark">Đã hủy</span></c:when>
                                                <c:otherwise><span class="badge bg-secondary">Chờ xử lý</span></c:otherwise>
                                            </c:choose>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:when test="${assignedUser != null}">
                            <div class="d-flex align-items-center">
                                <div class="avatar-lg bg-primary rounded-circle d-flex align-items-center justify-content-center text-white me-3">
                                    <h4 class="mb-0">${fn:substring(assignedUser.firstName, 0, 1)}${fn:substring(assignedUser.lastName, 0, 1)}</h4>
                                </div>
                                <div>
                                    <h6 class="mb-1">${assignedUser.firstName} ${assignedUser.lastName}</h6>
                                    <p class="text-muted small mb-0">${assignedUser.email}</p>
                                    <p class="text-muted small mb-0">${assignedUser.phone}</p>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted mb-0">Chưa gán</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Creator -->
            <div class="card">
                <div class="card-header bg-white">
                    <h6 class="mb-0"><i class="bi bi-person-plus me-2"></i>Người tạo</h6>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${creator != null}">
                            <div class="d-flex align-items-center">
                                <div class="avatar-md bg-secondary rounded-circle d-flex align-items-center justify-content-center text-white me-3">
                                    ${fn:substring(creator.firstName, 0, 1)}${fn:substring(creator.lastName, 0, 1)}
                                </div>
                                <div>
                                    <h6 class="mb-1">${creator.firstName} ${creator.lastName}</h6>
                                    <p class="text-muted small mb-0">${creator.email}</p>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted mb-0">Không xác định</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- ═══════════════ Lead Detail Modals ═══════════════ --%>
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

<%-- ═══════════════ Customer Detail Modals ═══════════════ --%>
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

<%-- ═══════════════ Single Object Fallback Modal ═══════════════ --%>
<c:if test="${empty relatedLeads && empty relatedCustomers && relatedObject != null}">
    <div class="modal fade" id="singleObjModal" tabindex="-1" aria-labelledby="singleObjModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header ${task.relatedType == 'LEAD' || task.relatedType == 'Lead' ? 'bg-primary' : 'bg-success'} bg-opacity-10">
                    <h5 class="modal-title" id="singleObjModalLabel">
                        <i class="bi ${task.relatedType == 'LEAD' || task.relatedType == 'Lead' ? 'bi-person-lines-fill text-primary' : 'bi-people-fill text-success'} me-2"></i>
                        Chi tiết ${task.relatedType == 'LEAD' || task.relatedType == 'Lead' ? 'Lead' : 'Khách hàng'}
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="text-center py-3">
                        <div class="fw-semibold fs-5 mb-2">${fn:escapeXml(relatedObjectName)}</div>
                        <span class="badge ${task.relatedType == 'LEAD' || task.relatedType == 'Lead' ? 'bg-primary' : 'bg-success'} fs-6">${task.relatedType}</span>
                        <p class="text-muted mt-2 mb-0">ID: ${task.relatedId}</p>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>
</c:if>

<style>
    .avatar-lg { width: 60px; height: 60px; flex-shrink: 0; }
    .avatar-md { width: 40px; height: 40px; font-size: 0.875rem; font-weight: 600; flex-shrink: 0; }
</style>

<script>
<%-- FIX: Overdue detection via JavaScript (EL cannot call LocalDateTime.isBefore(now())) --%>
document.addEventListener('DOMContentLoaded', function () {
    <c:if test="${task.dueDate != null && task.statusName != 'COMPLETED' && task.statusName != 'CANCELLED'}">
    (function () {
        var dueStr = '${fn:substring(task.dueDate, 0, 10)}'; // YYYY-MM-DD
        var today = new Date();
        today.setHours(0, 0, 0, 0);
        var due = new Date(dueStr);
        if (due < today) {
            var label = document.getElementById('overdueLabel');
            if (label) {
                label.innerHTML = '<span class="badge bg-danger mt-1">Quá hạn</span>';
            }
            var txt = document.getElementById('dueDateText');
            if (txt) txt.classList.add('text-danger', 'fw-bold');
        }
    }());
    </c:if>
});
</script>
