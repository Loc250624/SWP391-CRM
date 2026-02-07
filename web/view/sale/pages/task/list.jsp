<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách Công việc</title>
    <jsp:include page="../../layout/head.jsp"/> <%-- Corrected Path --%>
</head>
<body>
<div class="d-flex">
    <jsp:include page="../../layout/sidebar.jsp"/> <%-- Corrected Path --%>
    <div class="container-fluid">
        <jsp:include page="../../layout/header.jsp"/> <%-- Corrected Path --%>
        <div class="content">
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger" role="alert">
                    ${sessionScope.errorMessage}
                </div>
                <c:remove var="errorMessage" scope="session" />
            </c:if>

            <div class="d-flex justify-content-between align-items-center mb-3">
                <h3>Danh sách Công việc</h3>
                <a href="${pageContext.request.contextPath}/sale/task/form?action=create" class="btn btn-primary">Thêm mới công việc</a>
            </div>

            <ul class="nav nav-tabs mb-3">
                <li class="nav-item">
                    <a class="nav-link ${viewType == 'personal' ? 'active' : ''}" href="${pageContext.request.contextPath}/sale/task/list?view=personal">Công việc của tôi</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${viewType == 'team' ? 'active' : ''}" href="${pageContext.request.contextPath}/sale/task/list?view=team">Công việc của nhóm</a>
                </li>
            </ul>

            <table class="table table-striped">
                <thead>
                <tr>
                    <th>Tiêu đề</th>
                    <th>Người được giao</th>
                    <th>Ngày hết hạn</th>
                    <th>Mức độ ưu tiên</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="task" items="${taskList}">
                    <tr>
                        <td><a href="${pageContext.request.contextPath}/sale/task/detail?id=${task.taskId}">${task.title}</a></td>
                        <td>
                            <c:forEach var="user" items="${userList}">
                                <c:if test="${user.userId == task.assigneeId}">${user.fullName}</c:if>
                            </c:forEach>
                        </td>
                        <td>${task.dueDate}</td>
                        <td>${task.priority.vietnamese}</td>
                        <td>${task.status.vietnamese}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/sale/task/form?action=edit&id=${task.taskId}" class="btn btn-sm btn-outline-primary">Sửa</a>
                            <a href="${pageContext.request.contextPath}/sale/task/delete?id=${task.taskId}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa công việc này không?');">Xóa</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
<jsp:include page="../../layout/script.jsp"/> <%-- Corrected Path --%>
</body>
</html>