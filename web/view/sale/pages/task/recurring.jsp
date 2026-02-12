<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tạo công việc định kỳ</title>
    <jsp:include page="../../layout/head.jsp"/>
</head>
<body>
<div class="d-flex">
    <jsp:include page="../../layout/sidebar_module4.jsp"/>
    <div class="container-fluid">
        <jsp:include page="../../layout/header.jsp"/>
        <div class="content">
            <h3>Tạo công việc định kỳ</h3>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger" role="alert">
                    ${errorMessage}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/sale/task/recurring" method="post">
                <div class="mb-3">
                    <label class="form-label">Tiêu đề</label>
                    <input type="text" class="form-control" name="title" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Mô tả</label>
                    <textarea class="form-control" name="description" rows="3"></textarea>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Người được giao</label>
                        <select class="form-select" name="assigneeId" required>
                            <c:forEach var="user" items="${userList}">
                                <option value="${user.userId}">${user.fullName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Ngày bắt đầu</label>
                        <input type="date" class="form-control" name="startDate" required>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Chu kỳ</label>
                        <select class="form-select" name="intervalType" required>
                            <option value="DAILY">Hàng ngày</option>
                            <option value="WEEKLY">Hàng tuần</option>
                            <option value="MONTHLY">Hàng tháng</option>
                        </select>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Bước lặp</label>
                        <input type="number" min="1" class="form-control" name="intervalValue" value="1" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Số lần lặp</label>
                        <input type="number" min="1" class="form-control" name="repeatCount" value="3" required>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Mức độ ưu tiên</label>
                        <select class="form-select" name="priority" required>
                            <c:forEach var="p" items="${priorityValues}">
                                <option value="${p}">${p.vietnamese}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Trạng thái</label>
                        <select class="form-select" name="status" required>
                            <c:forEach var="s" items="${taskStatusValues}">
                                <option value="${s}">${s.vietnamese}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Liên kết với</label>
                        <select class="form-select" id="relatedToEntityType" name="relatedToEntityType">
                            <option value="">Không có</option>
                            <option value="LEAD">Khách hàng tiềm năng</option>
                            <option value="CUSTOMER">Khách hàng</option>
                            <option value="OPPORTUNITY">Cơ hội</option>
                        </select>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Đối tượng liên kết</label>
                        <select class="form-select" id="relatedToEntityId" name="relatedToEntityId">
                            <option value="">Chọn một đối tượng</option>
                        </select>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary">Tạo công việc định kỳ</button>
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
                entityIdSelect.appendChild(option);
            });
        }

        entityTypeSelect.addEventListener('change', function() {
            populateEntityIdSelect(this.value);
        });
    });
</script>
</body>
</html>
