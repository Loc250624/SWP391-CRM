<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <jsp:include page="../../layout/head.jsp"/>
</head>
<body>
<div class="d-flex">
    <jsp:include page="../../layout/sidebar.jsp"/>
    <div class="container-fluid">
        <jsp:include page="../../layout/header.jsp"/>
        <div class="content">
            <h3>${pageTitle}</h3>
            
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger" role="alert">
                    ${errorMessage}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/sale/task/form" method="post">
                <input type="hidden" name="formAction" value="${formAction}">
                <c:if test="${formAction == 'edit'}">
                    <input type="hidden" name="taskId" value="${task.taskId}">
                </c:if>

                <div class="mb-3">
                    <label for="title" class="form-label">Tiêu đề</label>
                    <input type="text" class="form-control" id="title" name="title" value="${task.title}" required>
                </div>

                <div class="mb-3">
                    <label for="description" class="form-label">Mô tả</label>
                    <textarea class="form-control" id="description" name="description" rows="3">${task.description}</textarea>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="assigneeId" class="form-label">Người được giao</label>
                        <select class="form-select" id="assigneeId" name="assigneeId" required>
                            <c:forEach var="user" items="${userList}">
                                <option value="${user.userId}" ${task.assigneeId == user.userId ? 'selected' : ''}>${user.fullName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="dueDate" class="form-label">Ngày hết hạn</label>
                        <input type="date" class="form-control" id="dueDate" name="dueDate" value="${task.dueDate}" required>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="priority" class="form-label">Mức độ ưu tiên</label>
                        <select class="form-select" id="priority" name="priority" required>
                            <c:forEach var="p" items="${priorityValues}">
                                <option value="${p}" ${task.priority == p ? 'selected' : ''}>${p.vietnamese}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="status" class="form-label">Trạng thái</label>
                        <select class="form-select" id="status" name="status" required>
                            <c:forEach var="s" items="${taskStatusValues}">
                                <option value="${s}" ${task.status == s ? 'selected' : ''}>${s.vietnamese}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="relatedToEntityType" class="form-label">Liên kết với</label>
                        <select class="form-select" id="relatedToEntityType" name="relatedToEntityType">
                            <option value="">Không có</option>
                            <option value="LEAD" ${task.relatedToEntityType == 'LEAD' ? 'selected' : ''}>Khách hàng tiềm năng</option>
                            <option value="CUSTOMER" ${task.relatedToEntityType == 'CUSTOMER' ? 'selected' : ''}>Khách hàng</option>
                            <option value="OPPORTUNITY" ${task.relatedToEntityType == 'OPPORTUNITY' ? 'selected' : ''}>Cơ hội</option>
                        </select>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="relatedToEntityId" class="form-label">Đối tượng liên kết</label>
                        <select class="form-select" id="relatedToEntityId" name="relatedToEntityId">
                            <!-- Options will be populated by JavaScript -->
                        </select>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary">Lưu công việc</button>
                <a href="${pageContext.request.contextPath}/sale/task/list" class="btn btn-secondary">Hủy</a>
            </form>
        </div>
    </div>
</div>
<jsp:include page="../../layout/script.jsp"/>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const entityTypeSelect = document.getElementById('relatedToEntityType');
        const entityIdSelect = document.getElementById('relatedToEntityId');
        
        const leads = [
            <c:forEach var="lead" items="${leads}" varStatus="loop">
                {id: ${lead.leadId}, name: "${lead.name}"}${!loop.last ? ',' : ''}
            </c:forEach>
        ];
        const customers = [
            <c:forEach var="customer" items="${customers}" varStatus="loop">
                {id: ${customer.customerId}, name: "${customer.name}"}${!loop.last ? ',' : ''}
            </c:forEach>
        ];
        const opportunities = [
            <c:forEach var="opp" items="${opportunities}" varStatus="loop">
                {id: ${opp.opportunityId}, name: "${opp.opportunityName}"}${!loop.last ? ',' : ''}
            </c:forEach>
        ];

        function populateEntityIdSelect(type) {
            entityIdSelect.innerHTML = '<option value="">Chọn một đối tượng</option>';
            let data = [];
            if (type === 'LEAD') data = leads;
            if (type === 'CUSTOMER') data = customers;
            if (type === 'OPPORTUNITY') data = opportunities;
            
            data.forEach(item => {
                const option = document.createElement('option');
                option.value = item.id;
                option.textContent = item.name;
                if (item.id === ${task.relatedToEntityId != 0 ? task.relatedToEntityId : -1}) {
                    option.selected = true;
                }
                entityIdSelect.appendChild(option);
            });
        }

        entityTypeSelect.addEventListener('change', function() {
            populateEntityIdSelect(this.value);
        });

        // Initial population on page load for edit forms
        if (entityTypeSelect.value) {
            populateEntityIdSelect(entityTypeSelect.value);
        }
    });
</script>
</body>
</html>