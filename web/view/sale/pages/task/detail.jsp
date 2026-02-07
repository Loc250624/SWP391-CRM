<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết Công việc</title>
    <jsp:include page="../../layout/head.jsp"/>
</head>
<body>
<div class="d-flex">
    <jsp:include page="../../layout/sidebar.jsp"/>
    <div class="container-fluid">
        <jsp:include page="../../layout/header.jsp"/>
        <div class="content">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h3>Chi tiết Công việc: ${task.title}</h3>
                <div>
                    <a href="${pageContext.request.contextPath}/sale/task/form?action=edit&id=${task.taskId}" class="btn btn-primary">Chỉnh sửa</a>
                    <a href="${pageContext.request.contextPath}/sale/task/list" class="btn btn-secondary">Quay lại danh sách</a>
                </div>
            </div>

            <div class="card">
                <div class="card-body">
                    <p><strong>Mô tả:</strong> ${task.description}</p>
                    <p><strong>Người được giao:</strong> ${assignee.fullName}</p>
                    <p><strong>Ngày hếtạn:</strong> ${task.dueDate}</p>
                    <p><strong>Mức độ ưu tiên:</strong> ${task.priority.vietnamese}</p>
                    <p><strong>Trạng thái:</strong> ${task.status.vietnamese}</p>
                    <p><strong>Người tạo:</strong> ${createdBy.fullName}</p>
                    <p><strong>Ngày tạo:</strong> ${task.createdAt}</p>
                    <c:if test="${not empty task.relatedToEntityType}">
                        <p><strong>Liên kết với:</strong> 
                            <a href="${relatedEntityUrl}">${relatedEntityName}</a> 
                            (${task.relatedToEntityType.toLowerCase()})
                        </p>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>
<jsp:include page="../../layout/script.jsp"/>
</body>
</html>