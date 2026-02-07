<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đặt deadline</title>
    <jsp:include page="../../layout/head.jsp"/>
</head>
<body>
<div class="d-flex">
    <jsp:include page="../../layout/sidebar_module4.jsp"/>
    <div class="container-fluid">
        <jsp:include page="../../layout/header.jsp"/>
        <div class="content">
            <h3>Đặt deadline công việc</h3>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger" role="alert">
                    ${errorMessage}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/sale/task/deadline" method="post">
                <input type="hidden" name="taskId" value="${task.taskId}">

                <div class="mb-3">
                    <label class="form-label">Tiêu đề</label>
                    <input type="text" class="form-control" value="${task.title}" readonly>
                </div>

                <div class="mb-3">
                    <label for="dueDate" class="form-label">Ngày hết hạn</label>
                    <input type="date" class="form-control" id="dueDate" name="dueDate" value="${task.dueDate}" required>
                </div>

                <button type="submit" class="btn btn-primary">Cập nhật</button>
                <a href="${pageContext.request.contextPath}/sale/task/detail?id=${task.taskId}" class="btn btn-secondary">Quay lại</a>
            </form>
        </div>
    </div>
</div>
<jsp:include page="../../layout/script.jsp"/>
</body>
</html>
