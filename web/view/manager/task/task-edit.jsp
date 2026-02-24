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
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}">Chi tiết</a>
                </li>
                <li class="breadcrumb-item active">Chỉnh sửa</li>
            </ol>
        </nav>
        <h3><i class="bi bi-pencil-square me-2"></i>Chỉnh sửa Công việc</h3>
    </div>

    <!-- Error Messages -->
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle me-2"></i>${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="errorMessage" scope="session" />
    </c:if>

    <!-- Form -->
    <div class="row">
        <div class="col-lg-8">
            <div class="card">
                <div class="card-header bg-white">
                    <h5 class="mb-0">Thông tin công việc</h5>
                    <small class="text-muted">Mã: ${task.taskCode}</small>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/manager/task/form" method="post">
                        <input type="hidden" name="formAction" value="edit">
                        <input type="hidden" name="taskId" value="${task.taskId}">

                        <!-- Title -->
                        <div class="mb-3">
                            <label for="title" class="form-label">
                                Tiêu đề <span class="text-danger">*</span>
                            </label>
                            <input type="text" class="form-control" id="title" name="title"
                                   value="${task.title}" required maxlength="255"
                                   placeholder="Nhập tiêu đề công việc">
                        </div>

                        <!-- Description -->
                        <div class="mb-3">
                            <label for="description" class="form-label">Mô tả</label>
                            <textarea class="form-control" id="description" name="description" rows="5"
                                      placeholder="Nhập mô tả chi tiết công việc">${task.description}</textarea>
                        </div>

                        <!-- Assigned To & Due Date -->
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="assignedTo" class="form-label">
                                    Giao cho <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="assignedTo" name="assignedTo" required>
                                    <option value="">-- Chọn nhân viên --</option>
                                    <c:forEach var="user" items="${allUsers}">
                                        <option value="${user.userId}"
                                            ${task.assignedTo == user.userId ? 'selected' : ''}>
                                            ${user.firstName} ${user.lastName} (${user.email})
                                        </option>
                                    </c:forEach>
                                </select>
                                <small class="text-muted">Người thực hiện công việc này</small>
                            </div>

                            <div class="col-md-6 mb-3">
                                <label for="dueDate" class="form-label">
                                    Hạn chót <span class="text-danger">*</span>
                                </label>
                                <%-- FIX: LocalDateTime.toString() gives "YYYY-MM-DDTHH:mm:ss"
                                     fn:substring(0,10) extracts "YYYY-MM-DD" for the date input. --%>
                                <input type="date" class="form-control" id="dueDate" name="dueDate"
                                       value="${fn:substring(task.dueDate, 0, 10)}" required>
                                <small class="text-muted">Ngày phải hoàn thành</small>
                            </div>
                        </div>

                        <!-- Priority & Status -->
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="priority" class="form-label">
                                    Mức độ ưu tiên <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="priority" name="priority" required>
                                    <c:forEach var="p" items="${priorityValues}">
                                        <option value="${p.name()}"
                                            ${task.priority == p.name() ? 'selected' : ''}>
                                            ${p.vietnamese}
                                        </option>
                                    </c:forEach>
                                </select>
                                <small class="text-muted">Mức độ quan trọng</small>
                            </div>

                            <div class="col-md-6 mb-3">
                                <label for="status" class="form-label">
                                    Trạng thái <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="status" name="status" required>
                                    <c:forEach var="s" items="${taskStatusValues}">
                                        <option value="${s.name()}"
                                            ${task.status == s.name() ? 'selected' : ''}>
                                            ${s.vietnamese}
                                        </option>
                                    </c:forEach>
                                </select>
                                <small class="text-muted">Tình trạng hiện tại</small>
                            </div>
                        </div>

                        <!-- Related Object -->
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="relatedType" class="form-label">Liên kết với</label>
                                <select class="form-select" id="relatedType" name="relatedType">
                                    <option value="">-- Không liên kết --</option>
                                    <option value="Lead"        ${task.relatedType == 'Lead'        ? 'selected' : ''}>Khách hàng tiềm năng</option>
                                    <option value="Customer"    ${task.relatedType == 'Customer'    ? 'selected' : ''}>Khách hàng</option>
                                    <option value="Opportunity" ${task.relatedType == 'Opportunity' ? 'selected' : ''}>Cơ hội</option>
                                </select>
                                <small class="text-muted">Liên kết với đối tượng khác</small>
                            </div>

                            <div class="col-md-6 mb-3">
                                <label for="relatedId" class="form-label">Đối tượng</label>
                                <select class="form-select" id="relatedId" name="relatedId">
                                    <option value="">-- Chọn đối tượng --</option>
                                </select>
                                <small class="text-muted">Chọn đối tượng cụ thể</small>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex gap-2 mt-4 pt-3 border-top">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check-circle me-2"></i>Lưu thay đổi
                            </button>
                            <a href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}"
                               class="btn btn-secondary">
                                <i class="bi bi-x-circle me-2"></i>Hủy
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Sidebar -->
        <div class="col-lg-4">
            <!-- Current Status Info -->
            <div class="card mb-3">
                <div class="card-header bg-white">
                    <h6 class="mb-0"><i class="bi bi-info-circle me-2"></i>Thông tin hiện tại</h6>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <small class="text-muted d-block">Trạng thái hiện tại</small>
                        <c:choose>
                            <c:when test="${task.status == 'COMPLETED'}">
                                <span class="badge bg-success">Hoàn thành</span>
                            </c:when>
                            <c:when test="${task.status == 'IN_PROGRESS'}">
                                <span class="badge bg-info">Đang thực hiện</span>
                            </c:when>
                            <c:when test="${task.status == 'CANCELLED'}">
                                <span class="badge bg-dark">Đã hủy</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary">Chờ xử lý</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <%-- FIX: Replace fmt:formatDate (requires java.util.Date) with fn:substring.
                         LocalDateTime.toString() = "YYYY-MM-DDTHH:mm:ss" --%>
                    <div class="mb-3">
                        <small class="text-muted d-block">Ngày tạo</small>
                        <strong>
                            <c:if test="${task.createdAt != null}">
                                ${fn:substring(task.createdAt, 8, 10)}/${fn:substring(task.createdAt, 5, 7)}/${fn:substring(task.createdAt, 0, 4)}
                                ${fn:substring(task.createdAt, 11, 16)}
                            </c:if>
                        </strong>
                    </div>

                    <div class="mb-3">
                        <small class="text-muted d-block">Cập nhật lần cuối</small>
                        <strong>
                            <c:if test="${task.updatedAt != null}">
                                ${fn:substring(task.updatedAt, 8, 10)}/${fn:substring(task.updatedAt, 5, 7)}/${fn:substring(task.updatedAt, 0, 4)}
                                ${fn:substring(task.updatedAt, 11, 16)}
                            </c:if>
                        </strong>
                    </div>

                    <c:if test="${task.completedAt != null}">
                        <div class="mb-0">
                            <small class="text-muted d-block">Hoàn thành lúc</small>
                            <strong class="text-success">
                                ${fn:substring(task.completedAt, 8, 10)}/${fn:substring(task.completedAt, 5, 7)}/${fn:substring(task.completedAt, 0, 4)}
                                ${fn:substring(task.completedAt, 11, 16)}
                            </strong>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Help Card -->
            <div class="card bg-light">
                <div class="card-body">
                    <h6 class="card-title"><i class="bi bi-lightbulb me-2"></i>Gợi ý</h6>
                    <ul class="list-unstyled small mb-0">
                        <li class="mb-2"><i class="bi bi-check2 text-success me-2"></i>Cập nhật trạng thái khi có tiến triển</li>
                        <li class="mb-2"><i class="bi bi-check2 text-success me-2"></i>Thay đổi ưu tiên nếu tình huống thay đổi</li>
                        <li class="mb-2"><i class="bi bi-check2 text-success me-2"></i>Gán lại người thực hiện nếu cần</li>
                        <li class="mb-2"><i class="bi bi-check2 text-success me-2"></i>Gia hạn deadline hợp lý nếu cần</li>
                        <li class="mb-0"><i class="bi bi-check2 text-success me-2"></i>Mọi thay đổi được ghi lại tự động</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function () {
    var relatedTypeSelect = document.getElementById('relatedType');
    var relatedIdSelect   = document.getElementById('relatedId');

    var relatedData = {
        'Lead': [
            <c:forEach var="lead" items="${leads}" varStatus="st">
                {id: ${lead.leadId}, name: '${fn:replace(fn:replace(lead.fullName, "'", "\\'"), "\"", "&quot;")} (${lead.leadCode})'}${!st.last ? ',' : ''}
            </c:forEach>
        ],
        'Customer': [
            <c:forEach var="customer" items="${customers}" varStatus="st">
                {id: ${customer.customerId}, name: '${fn:replace(fn:replace(customer.fullName, "'", "\\'"), "\"", "&quot;")} (${customer.customerCode})'}${!st.last ? ',' : ''}
            </c:forEach>
        ],
        'Opportunity': [
            <c:forEach var="opp" items="${opportunities}" varStatus="st">
                {id: ${opp.opportunityId}, name: '${fn:replace(fn:replace(opp.opportunityName, "'", "\\'"), "\"", "&quot;")} (${opp.opportunityCode})'}${!st.last ? ',' : ''}
            </c:forEach>
        ]
    };

    var currentRelatedId = ${task.relatedId != null ? task.relatedId : 'null'};

    function updateRelatedOptions() {
        var selectedType = relatedTypeSelect.value;
        relatedIdSelect.innerHTML = '<option value="">-- Chọn đối tượng --</option>';
        if (selectedType && relatedData[selectedType]) {
            relatedData[selectedType].forEach(function (item) {
                var option = document.createElement('option');
                option.value = item.id;
                option.textContent = item.name;
                if (currentRelatedId && item.id === currentRelatedId) {
                    option.selected = true;
                }
                relatedIdSelect.appendChild(option);
            });
        }
    }

    relatedTypeSelect.addEventListener('change', updateRelatedOptions);

    // Restore related selection on page load
    if (relatedTypeSelect.value) {
        updateRelatedOptions();
    }
});
</script>
