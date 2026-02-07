<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Nhắc việc theo deadline</title>
    <jsp:include page="../../layout/head.jsp"/>
</head>
<body>
<div class="d-flex">
    <jsp:include page="../../layout/sidebar_module4.jsp"/>
    <div class="container-fluid">
        <jsp:include page="../../layout/header.jsp"/>
        <div class="content">
            <h3>Nhắc việc theo deadline</h3>

            <div class="d-flex justify-content-between align-items-center mb-3">
                <div>
                    <a class="btn btn-outline-primary ${viewType == 'personal' ? 'active' : ''}" href="${pageContext.request.contextPath}/sale/task/reminder?view=personal&days=${days}">Công việc của tôi</a>
                    <a class="btn btn-outline-primary ${viewType == 'team' ? 'active' : ''}" href="${pageContext.request.contextPath}/sale/task/reminder?view=team&days=${days}">Công việc của nhóm</a>
                </div>
                <form class="d-flex" method="get" action="${pageContext.request.contextPath}/sale/task/reminder">
                    <input type="hidden" name="view" value="${viewType}">
                    <input type="number" min="1" class="form-control me-2" name="days" value="${days}" style="width: 120px;">
                    <button type="submit" class="btn btn-primary">Lọc ngày</button>
                </form>
            </div>

            <p>Khoảng thời gian: ${fromDate} đến ${toDate}</p>

            <table class="table table-striped">
                <thead>
                <tr>
                    <th>Tiêu đề</th>
                    <th>Ngày hết hạn</th>
                    <th>Mức độ ưu tiên</th>
                    <th>Trạng thái</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="task" items="${taskList}">
                    <tr>
                        <td><a href="${pageContext.request.contextPath}/sale/task/detail?id=${task.taskId}">${task.title}</a></td>
                        <td>${task.dueDate}</td>
                        <td>${task.priority.vietnamese}</td>
                        <td>${task.status.vietnamese}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
<jsp:include page="../../layout/script.jsp"/>
</body>
</html>
