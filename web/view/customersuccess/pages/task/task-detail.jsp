<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!-- Breadcrumb -->
<nav aria-label="breadcrumb" class="mb-3">
    <ol class="breadcrumb">
        <li class="breadcrumb-item">
            <a href="${pageContext.request.contextPath}/support/task/list">Công việc của tôi</a>
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

<!-- Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <h4 class="mb-0"><i class="bi bi-file-earmark-text me-2"></i>Chi tiết Công việc</h4>
    <div class="d-flex gap-2">
        <c:if test="${task.statusName != 'COMPLETED' && task.statusName != 'CANCELLED'}">
            <a href="${pageContext.request.contextPath}/support/task/status?id=${task.taskId}"
               class="btn btn-success btn-sm">
                <i class="bi bi-check2-circle me-1"></i>Đánh dấu Hoàn thành
            </a>
        </c:if>
        <a href="${pageContext.request.contextPath}/support/task/list"
           class="btn btn-outline-secondary btn-sm">
            <i class="bi bi-arrow-left me-1"></i>Quay lại
        </a>
    </div>
</div>

<div class="row">
    <!-- Main Content -->
    <div class="col-lg-8">
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-white">
                <h5 class="mb-1">${task.title}</h5>
                <div>
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
                            <span class="badge bg-danger ms-1">Cao</span>
                        </c:when>
                        <c:when test="${task.priorityName == 'MEDIUM'}">
                            <span class="badge bg-warning text-dark ms-1">Trung bình</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-secondary ms-1">Thấp</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="card-body">
                <h6 class="fw-bold mb-2">Mô tả</h6>
                <c:choose>
                    <c:when test="${not empty task.description}">
                        <p class="text-muted">${task.description}</p>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted fst-italic small">Không có mô tả</p>
                    </c:otherwise>
                </c:choose>

                <hr>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <small class="text-muted d-block">Hạn chót</small>
                        <c:choose>
                            <c:when test="${task.dueDate != null}">
                                <strong>${fn:substring(task.dueDate, 8, 10)}/${fn:substring(task.dueDate, 5, 7)}/${fn:substring(task.dueDate, 0, 4)}</strong>
                            </c:when>
                            <c:otherwise><span class="text-muted small">Không xác định</span></c:otherwise>
                        </c:choose>
                    </div>
                    <div class="col-md-6 mb-3">
                        <small class="text-muted d-block">Nhắc nhở</small>
                        <c:choose>
                            <c:when test="${task.reminderAt != null}">
                                <strong>${fn:substring(task.reminderAt, 8, 10)}/${fn:substring(task.reminderAt, 5, 7)}/${fn:substring(task.reminderAt, 0, 4)}</strong>
                            </c:when>
                            <c:otherwise><span class="text-muted small">Không có</span></c:otherwise>
                        </c:choose>
                    </div>
                    <div class="col-md-6 mb-3">
                        <small class="text-muted d-block">Ngày tạo</small>
                        <c:if test="${task.createdAt != null}">
                            <strong>${fn:substring(task.createdAt, 8, 10)}/${fn:substring(task.createdAt, 5, 7)}/${fn:substring(task.createdAt, 0, 4)}</strong>
                        </c:if>
                    </div>
                    <c:if test="${task.completedAt != null}">
                        <div class="col-md-6 mb-3">
                            <small class="text-muted d-block">Hoàn thành lúc</small>
                            <strong class="text-success">${fn:substring(task.completedAt, 8, 10)}/${fn:substring(task.completedAt, 5, 7)}/${fn:substring(task.completedAt, 0, 4)}</strong>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Related Object -->
        <c:if test="${not empty relatedObjectName}">
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-white">
                    <h6 class="mb-0"><i class="bi bi-link-45deg me-2"></i>Đối tượng liên kết</h6>
                </div>
                <div class="card-body">
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
                </div>
            </div>
        </c:if>

        <!-- Comments -->
        <div class="card shadow-sm mb-4">
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
                                    <div class="rounded-circle bg-secondary d-flex align-items-center justify-content-center text-white flex-shrink-0" style="width:32px;height:32px;font-size:0.75rem;">
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
                <c:if test="${task.statusName != 'CANCELLED'}">
                <form method="post" action="${pageContext.request.contextPath}/support/task/comment">
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
        <div class="card shadow-sm mb-3">
            <div class="card-header bg-white">
                <h6 class="mb-0"><i class="bi bi-person-plus me-2"></i>Người tạo</h6>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${creator != null}">
                        <div class="d-flex align-items-center">
                            <div class="rounded-circle bg-secondary d-flex align-items-center justify-content-center text-white me-3"
                                 style="width:40px;height:40px;font-size:0.875rem;">
                                ${fn:substring(creator.firstName, 0, 1)}${fn:substring(creator.lastName, 0, 1)}
                            </div>
                            <div>
                                <div class="fw-medium">${creator.firstName} ${creator.lastName}</div>
                                <small class="text-muted">${creator.email}</small>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted small mb-0">Không xác định</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <c:if test="${task.statusName != 'COMPLETED' && task.statusName != 'CANCELLED'}">
            <div class="card bg-light border-0">
                <div class="card-body">
                    <h6 class="mb-2"><i class="bi bi-info-circle me-1"></i>Quyền của bạn</h6>
                    <ul class="list-unstyled small mb-0">
                        <li class="mb-1"><i class="bi bi-check2 text-success me-1"></i>Xem chi tiết công việc</li>
                        <li class="mb-1"><i class="bi bi-check2 text-success me-1"></i>Cập nhật trạng thái</li>
                        <li class="mb-1"><i class="bi bi-check2 text-success me-1"></i>Bình luận</li>
                        <li class="mb-1"><i class="bi bi-x text-danger me-1"></i>Không thể chỉnh sửa thông tin khác</li>
                    </ul>
                </div>
            </div>
        </c:if>
    </div>
</div>

<%-- ═══════════════ Lead Detail Modal ═══════════════ --%>
<c:if test="${not empty relatedLead}">
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
                            <label class="form-label text-muted small mb-0">Sở thích / Quan tâm</label>
                            <div>${not empty relatedLead.interests ? fn:escapeXml(relatedLead.interests) : '<span class="text-muted fst-italic">Chưa có</span>'}</div>
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
                            <label class="form-label text-muted small mb-0">Đánh giá (Rating)</label>
                            <div>${not empty relatedLead.rating ? relatedLead.rating : '<span class="text-muted fst-italic">Chưa có</span>'}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Điểm Lead</label>
                            <div>${relatedLead.leadScore != null ? relatedLead.leadScore : '<span class="text-muted fst-italic">Chưa có</span>'}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Chuyển đổi</label>
                            <div>
                                <c:choose>
                                    <c:when test="${relatedLead.isConverted}"><span class="badge bg-success">Đã chuyển đổi</span></c:when>
                                    <c:otherwise><span class="badge bg-warning text-dark">Chưa chuyển đổi</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <c:if test="${relatedLead.isConverted && relatedLead.convertedAt != null}">
                            <div class="col-md-6">
                                <label class="form-label text-muted small mb-0">Ngày chuyển đổi</label>
                                <div>${fn:substring(relatedLead.convertedAt, 8, 10)}/${fn:substring(relatedLead.convertedAt, 5, 7)}/${fn:substring(relatedLead.convertedAt, 0, 4)}</div>
                            </div>
                        </c:if>
                        <div class="col-12">
                            <label class="form-label text-muted small mb-0">Ghi chú</label>
                            <div class="bg-light rounded p-2">${not empty relatedLead.notes ? fn:escapeXml(relatedLead.notes) : '<span class="text-muted fst-italic">Không có ghi chú</span>'}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Ngày tạo</label>
                            <div class="small text-muted">
                                <c:if test="${relatedLead.createdAt != null}">${fn:substring(relatedLead.createdAt, 8, 10)}/${fn:substring(relatedLead.createdAt, 5, 7)}/${fn:substring(relatedLead.createdAt, 0, 4)} ${fn:substring(relatedLead.createdAt, 11, 16)}</c:if>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Cập nhật lần cuối</label>
                            <div class="small text-muted">
                                <c:if test="${relatedLead.updatedAt != null}">${fn:substring(relatedLead.updatedAt, 8, 10)}/${fn:substring(relatedLead.updatedAt, 5, 7)}/${fn:substring(relatedLead.updatedAt, 0, 4)} ${fn:substring(relatedLead.updatedAt, 11, 16)}</c:if>
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
</c:if>

<%-- ═══════════════ Customer Detail Modal ═══════════════ --%>
<c:if test="${not empty relatedCustomer}">
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
                            <label class="form-label text-muted small mb-0">Ngày sinh</label>
                            <div>
                                <c:choose>
                                    <c:when test="${relatedCustomer.dateOfBirth != null}">${fn:substring(relatedCustomer.dateOfBirth, 8, 10)}/${fn:substring(relatedCustomer.dateOfBirth, 5, 7)}/${fn:substring(relatedCustomer.dateOfBirth, 0, 4)}</c:when>
                                    <c:otherwise><span class="text-muted fst-italic">Chưa có</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Giới tính</label>
                            <div>
                                <c:choose>
                                    <c:when test="${relatedCustomer.gender == 'Male'}">Nam</c:when>
                                    <c:when test="${relatedCustomer.gender == 'Female'}">Nữ</c:when>
                                    <c:when test="${not empty relatedCustomer.gender}">${relatedCustomer.gender}</c:when>
                                    <c:otherwise><span class="text-muted fst-italic">Chưa có</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Địa chỉ</label>
                            <div>${not empty relatedCustomer.address ? fn:escapeXml(relatedCustomer.address) : '<span class="text-muted fst-italic">Chưa có</span>'}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Thành phố</label>
                            <div>${not empty relatedCustomer.city ? fn:escapeXml(relatedCustomer.city) : '<span class="text-muted fst-italic">Chưa có</span>'}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Phân khúc</label>
                            <div>${not empty relatedCustomer.customerSegment ? relatedCustomer.customerSegment : '<span class="text-muted fst-italic">Chưa có</span>'}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Trạng thái</label>
                            <div><c:if test="${not empty relatedCustomer.status}"><span class="badge bg-success">${relatedCustomer.status}</span></c:if></div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Tổng khóa học</label>
                            <div>${relatedCustomer.totalCourses != null ? relatedCustomer.totalCourses : 0}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Tổng chi tiêu</label>
                            <div class="fw-semibold text-success">${relatedCustomer.totalSpent != null ? relatedCustomer.totalSpent : 0} VNĐ</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Điểm sức khỏe</label>
                            <div>
                                <c:choose>
                                    <c:when test="${relatedCustomer.healthScore != null && relatedCustomer.healthScore >= 80}"><span class="badge bg-success">${relatedCustomer.healthScore}</span></c:when>
                                    <c:when test="${relatedCustomer.healthScore != null && relatedCustomer.healthScore >= 50}"><span class="badge bg-warning text-dark">${relatedCustomer.healthScore}</span></c:when>
                                    <c:when test="${relatedCustomer.healthScore != null}"><span class="badge bg-danger">${relatedCustomer.healthScore}</span></c:when>
                                    <c:otherwise><span class="text-muted fst-italic">N/A</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Điểm hài lòng</label>
                            <div>
                                <c:choose>
                                    <c:when test="${relatedCustomer.satisfactionScore != null && relatedCustomer.satisfactionScore >= 80}"><span class="badge bg-success">${relatedCustomer.satisfactionScore}</span></c:when>
                                    <c:when test="${relatedCustomer.satisfactionScore != null && relatedCustomer.satisfactionScore >= 50}"><span class="badge bg-warning text-dark">${relatedCustomer.satisfactionScore}</span></c:when>
                                    <c:when test="${relatedCustomer.satisfactionScore != null}"><span class="badge bg-danger">${relatedCustomer.satisfactionScore}</span></c:when>
                                    <c:otherwise><span class="text-muted fst-italic">N/A</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-12">
                            <label class="form-label text-muted small mb-0">Ghi chú</label>
                            <div class="bg-light rounded p-2">${not empty relatedCustomer.notes ? fn:escapeXml(relatedCustomer.notes) : '<span class="text-muted fst-italic">Không có ghi chú</span>'}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Ngày tạo</label>
                            <div class="small text-muted">
                                <c:if test="${relatedCustomer.createdAt != null}">${fn:substring(relatedCustomer.createdAt, 8, 10)}/${fn:substring(relatedCustomer.createdAt, 5, 7)}/${fn:substring(relatedCustomer.createdAt, 0, 4)} ${fn:substring(relatedCustomer.createdAt, 11, 16)}</c:if>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small mb-0">Cập nhật lần cuối</label>
                            <div class="small text-muted">
                                <c:if test="${relatedCustomer.updatedAt != null}">${fn:substring(relatedCustomer.updatedAt, 8, 10)}/${fn:substring(relatedCustomer.updatedAt, 5, 7)}/${fn:substring(relatedCustomer.updatedAt, 0, 4)} ${fn:substring(relatedCustomer.updatedAt, 11, 16)}</c:if>
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
</c:if>
