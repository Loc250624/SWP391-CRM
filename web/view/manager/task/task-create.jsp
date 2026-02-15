<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="container-fluid">
    <!-- Header -->
    <div class="mb-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/manager/task/list">Công việc</a></li>
                <li class="breadcrumb-item active">${formAction == 'edit' ? 'Chỉnh sửa' : 'Tạo mới'}</li>
            </ol>
        </nav>
        <h3><i class="bi bi-file-earmark-text me-2"></i>${formAction == 'edit' ? 'Chỉnh sửa Công việc' : 'Tạo Công việc mới'}</h3>
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
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/manager/task/form" method="post">
                        <input type="hidden" name="formAction" value="${formAction}">
                        <c:if test="${formAction == 'edit'}">
                            <input type="hidden" name="taskId" value="${task.taskId}">
                        </c:if>

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
                            <textarea class="form-control" id="description" name="description" rows="4"
                                      placeholder="Nhập mô tả chi tiết công việc">${task.description}</textarea>
                        </div>

                        <!-- Assigned To -->
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="assignedTo" class="form-label">
                                    Giao cho <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="assignedTo" name="assignedTo" required>
                                    <option value="">-- Chọn nhân viên --</option>
                                    <c:forEach var="user" items="${allUsers}">
                                        <option value="${user.userId}" ${task.assignedTo == user.userId ? 'selected' : ''}>
                                            ${user.firstName} ${user.lastName} (${user.email})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Due Date -->
                            <div class="col-md-6 mb-3">
                                <label for="dueDate" class="form-label">
                                    Hạn chót <span class="text-danger">*</span>
                                </label>
                                <input type="date" class="form-control" id="dueDate" name="dueDate"
                                       value="<fmt:formatDate value='${task.dueDate}' pattern='yyyy-MM-dd' />" required>
                            </div>
                        </div>

                        <!-- Priority and Status -->
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="priority" class="form-label">
                                    Mức độ ưu tiên <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="priority" name="priority" required>
                                    <c:forEach var="p" items="${priorityValues}">
                                        <option value="${p.name()}" ${task.priority == p.name() ? 'selected' : ''}>
                                            ${p.vietnamese}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-6 mb-3">
                                <label for="status" class="form-label">
                                    Trạng thái <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="status" name="status" required>
                                    <c:forEach var="s" items="${taskStatusValues}">
                                        <option value="${s.name()}" ${task.status == s.name() ? 'selected' : ''}>
                                            ${s.vietnamese}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <!-- Related Object -->
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="relatedType" class="form-label">Liên kết với</label>
                                <select class="form-select" id="relatedType" name="relatedType">
                                    <option value="">-- Không liên kết --</option>
                                    <option value="Lead" ${task.relatedType == 'Lead' ? 'selected' : ''}>Khách hàng tiềm năng</option>
                                    <option value="Customer" ${task.relatedType == 'Customer' ? 'selected' : ''}>Khách hàng</option>
                                    <option value="Opportunity" ${task.relatedType == 'Opportunity' ? 'selected' : ''}>Cơ hội</option>
                                </select>
                            </div>

                            <div class="col-md-6 mb-3">
                                <label for="relatedId" class="form-label">Đối tượng</label>
                                <select class="form-select" id="relatedId" name="relatedId">
                                    <option value="">-- Chọn đối tượng --</option>
                                    <!-- Options will be populated by JavaScript -->
                                </select>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex gap-2 mt-4">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check-circle me-2"></i>
                                ${formAction == 'edit' ? 'Cập nhật' : 'Tạo công việc'}
                            </button>
                            <a href="${pageContext.request.contextPath}/manager/task/list" class="btn btn-secondary">
                                <i class="bi bi-x-circle me-2"></i>Hủy
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Help Card -->
        <div class="col-lg-4">
            <div class="card bg-light">
                <div class="card-body">
                    <h5 class="card-title"><i class="bi bi-info-circle me-2"></i>Hướng dẫn</h5>
                    <ul class="list-unstyled small">
                        <li class="mb-2">
                            <i class="bi bi-check2 text-success me-2"></i>
                            Điền đầy đủ thông tin bắt buộc (*)
                        </li>
                        <li class="mb-2">
                            <i class="bi bi-check2 text-success me-2"></i>
                            Chọn người thực hiện phù hợp với công việc
                        </li>
                        <li class="mb-2">
                            <i class="bi bi-check2 text-success me-2"></i>
                            Đặt hạn chót hợp lý để hoàn thành
                        </li>
                        <li class="mb-2">
                            <i class="bi bi-check2 text-success me-2"></i>
                            Liên kết với Lead/Customer/Opportunity nếu cần
                        </li>
                        <li class="mb-2">
                            <i class="bi bi-check2 text-success me-2"></i>
                            Hệ thống tự động gửi nhắc nhở trước 24 giờ
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const relatedTypeSelect = document.getElementById('relatedType');
    const relatedIdSelect = document.getElementById('relatedId');

    const relatedData = {
        'Lead': ${leads != null ? '[' : '[]'}
            <c:forEach var="lead" items="${leads}" varStatus="status">
                {id: ${lead.leadId}, name: '${lead.fullName} (${lead.leadCode})'}${!status.last ? ',' : ''}
            </c:forEach>
        ${leads != null ? ']' : ''},
        'Customer': ${customers != null ? '[' : '[]'}
            <c:forEach var="customer" items="${customers}" varStatus="status">
                {id: ${customer.customerId}, name: '${customer.fullName} (${customer.customerCode})'}${!status.last ? ',' : ''}
            </c:forEach>
        ${customers != null ? ']' : ''},
        'Opportunity': ${opportunities != null ? '[' : '[]'}
            <c:forEach var="opp" items="${opportunities}" varStatus="status">
                {id: ${opp.opportunityId}, name: '${opp.opportunityName} (${opp.opportunityCode})'}${!status.last ? ',' : ''}
            </c:forEach>
        ${opportunities != null ? ']' : ''}
    };

    const currentRelatedId = ${task.relatedId != null ? task.relatedId : 'null'};

    function updateRelatedOptions() {
        const selectedType = relatedTypeSelect.value;
        relatedIdSelect.innerHTML = '<option value="">-- Chọn đối tượng --</option>';

        if (selectedType && relatedData[selectedType]) {
            relatedData[selectedType].forEach(item => {
                const option = document.createElement('option');
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

    // Initialize on page load
    if (relatedTypeSelect.value) {
        updateRelatedOptions();
    }

    // Set min date for due date to today
    const dueDateInput = document.getElementById('dueDate');
    const today = new Date().toISOString().split('T')[0];
    dueDateInput.setAttribute('min', today);
});
</script>
