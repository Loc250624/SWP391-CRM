<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Báo cáo công việc</title>
    <jsp:include page="../../layout/head.jsp"/>
</head>
<body>
<div class="d-flex">
    <jsp:include page="../../layout/sidebar_module4.jsp"/>
    <div class="container-fluid">
        <jsp:include page="../../layout/header.jsp"/>
        <div class="content">
            <h3>Báo cáo hoàn thành công việc</h3>

            <div class="mb-3">
                <a class="btn btn-outline-primary ${viewType == 'personal' ? 'active' : ''}" href="${pageContext.request.contextPath}/sale/task/report?view=personal">Công việc của tôi</a>
                <a class="btn btn-outline-primary ${viewType == 'team' ? 'active' : ''}" href="${pageContext.request.contextPath}/sale/task/report?view=team">Công việc của nhóm</a>
            </div>

            <div class="row mb-3">
                <div class="col-md-4">
                    <div class="alert alert-info">Tổng công việc: ${total}</div>
                </div>
                <div class="col-md-4">
                    <div class="alert alert-success">Đã hoàn thành: ${completed}</div>
                </div>
                <div class="col-md-4">
                    <div class="alert alert-warning">Tỷ lệ hoàn thành: <c:out value="${completionRate}"/>%</div>
                </div>
            </div>

            <h5>Thống kê theo trạng thái</h5>
            <table class="table table-bordered">
                <thead>
                <tr>
                    <th>Trạng thái</th>
                    <th>Số lượng</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="entry" items="${summary}">
                    <tr>
                        <td>${entry.key.vietnamese}</td>
                        <td>${entry.value}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <h5>Danh sách công việc</h5>
            <table class="table table-striped">
                <thead>
                <tr>
                    <th>Tiêu đề</th>
                    <th>Ngày hết hạn</th>
                    <th>Ưu tiên</th>
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
