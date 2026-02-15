<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="container-fluid">
    <!-- Header -->
    <div class="mb-4">
        <h3 class="mb-1"><i class="bi bi-bell me-2"></i>Nhắc nhở Công việc</h3>
        <p class="text-muted mb-0">Xem các công việc cần chú ý và sắp đến hạn</p>
    </div>

    <!-- Summary Cards -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card border-danger">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="text-muted mb-1 small">Quá hạn</p>
                            <h3 class="mb-0 text-danger">${overdueTasks.size()}</h3>
                        </div>
                        <div class="bg-danger bg-opacity-10 p-3 rounded">
                            <i class="bi bi-exclamation-triangle text-danger fs-3"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-warning">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="text-muted mb-1 small">Hôm nay</p>
                            <h3 class="mb-0 text-warning">${todayTasks.size()}</h3>
                        </div>
                        <div class="bg-warning bg-opacity-10 p-3 rounded">
                            <i class="bi bi-calendar-check text-warning fs-3"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-info">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="text-muted mb-1 small">Tuần này</p>
                            <h3 class="mb-0 text-info">${thisWeekTasks.size()}</h3>
                        </div>
                        <div class="bg-info bg-opacity-10 p-3 rounded">
                            <i class="bi bi-calendar-week text-info fs-3"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-primary">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="text-muted mb-1 small">Ưu tiên cao</p>
                            <h3 class="mb-0 text-primary">${highPriorityPending}</h3>
                        </div>
                        <div class="bg-primary bg-opacity-10 p-3 rounded">
                            <i class="bi bi-flag-fill text-primary fs-3"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Overdue Tasks -->
    <c:if test="${not empty overdueTasks}">
        <div class="card mb-4 border-danger">
            <div class="card-header bg-danger text-white">
                <h5 class="mb-0">
                    <i class="bi bi-exclamation-triangle me-2"></i>
                    Công việc quá hạn (${overdueTasks.size()})
                </h5>
            </div>
            <div class="card-body p-0">
                <div class="list-group list-group-flush">
                    <c:forEach var="task" items="${overdueTasks}">
                        <div class="list-group-item list-group-item-action">
                            <div class="d-flex w-100 justify-content-between align-items-start">
                                <div class="flex-grow-1">
                                    <h6 class="mb-1">
                                        <a href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}"
                                           class="text-decoration-none text-dark">
                                            ${task.title}
                                        </a>
                                    </h6>
                                    <p class="mb-1 small text-muted">${task.description}</p>
                                    <div class="d-flex gap-2 align-items-center">
                                        <c:forEach var="user" items="${allUsers}">
                                            <c:if test="${user.userId == task.assignedTo}">
                                                <small class="text-muted">
                                                    <i class="bi bi-person me-1"></i>${user.firstName} ${user.lastName}
                                                </small>
                                            </c:if>
                                        </c:forEach>
                                        <span class="badge bg-danger">Quá hạn</span>
                                        <c:choose>
                                            <c:when test="${task.priority == 'HIGH'}">
                                                <span class="badge bg-danger">Cao</span>
                                            </c:when>
                                            <c:when test="${task.priority == 'MEDIUM'}">
                                                <span class="badge bg-warning">Trung bình</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">Thấp</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="text-end ms-3">
                                    <small class="text-danger d-block">
                                        <i class="bi bi-calendar-x me-1"></i>
                                        <fmt:formatDate value="${task.dueDate}" pattern="dd/MM/yyyy" />
                                    </small>
                                    <small class="text-muted">
                                        <c:set var="daysOverdue" value="${now().toEpochDay() - task.dueDate.toLocalDate().toEpochDay()}" />
                                        Quá ${daysOverdue} ngày
                                    </small>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </c:if>

    <!-- Today's Tasks -->
    <c:if test="${not empty todayTasks}">
        <div class="card mb-4 border-warning">
            <div class="card-header bg-warning bg-opacity-10">
                <h5 class="mb-0">
                    <i class="bi bi-calendar-check me-2"></i>
                    Công việc hôm nay (${todayTasks.size()})
                </h5>
            </div>
            <div class="card-body p-0">
                <div class="list-group list-group-flush">
                    <c:forEach var="task" items="${todayTasks}">
                        <div class="list-group-item list-group-item-action">
                            <div class="d-flex w-100 justify-content-between align-items-start">
                                <div class="flex-grow-1">
                                    <h6 class="mb-1">
                                        <a href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}"
                                           class="text-decoration-none text-dark">
                                            ${task.title}
                                        </a>
                                    </h6>
                                    <p class="mb-1 small text-muted">${task.description}</p>
                                    <div class="d-flex gap-2 align-items-center">
                                        <c:forEach var="user" items="${allUsers}">
                                            <c:if test="${user.userId == task.assignedTo}">
                                                <small class="text-muted">
                                                    <i class="bi bi-person me-1"></i>${user.firstName} ${user.lastName}
                                                </small>
                                            </c:if>
                                        </c:forEach>
                                        <c:choose>
                                            <c:when test="${task.status == 'COMPLETED'}">
                                                <span class="badge bg-success">Hoàn thành</span>
                                            </c:when>
                                            <c:when test="${task.status == 'IN_PROGRESS'}">
                                                <span class="badge bg-info">Đang làm</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">Chờ xử lý</span>
                                            </c:otherwise>
                                        </c:choose>
                                        <c:choose>
                                            <c:when test="${task.priority == 'HIGH'}">
                                                <span class="badge bg-danger">Cao</span>
                                            </c:when>
                                            <c:when test="${task.priority == 'MEDIUM'}">
                                                <span class="badge bg-warning">Trung bình</span>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="text-end ms-3">
                                    <small class="text-warning">
                                        <i class="bi bi-alarm me-1"></i>Hôm nay
                                    </small>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </c:if>

    <!-- This Week Tasks -->
    <c:if test="${not empty thisWeekTasks}">
        <div class="card mb-4 border-info">
            <div class="card-header bg-info bg-opacity-10">
                <h5 class="mb-0">
                    <i class="bi bi-calendar-week me-2"></i>
                    Công việc tuần này (${thisWeekTasks.size()})
                </h5>
            </div>
            <div class="card-body p-0">
                <div class="list-group list-group-flush">
                    <c:forEach var="task" items="${thisWeekTasks}">
                        <div class="list-group-item list-group-item-action">
                            <div class="d-flex w-100 justify-content-between align-items-start">
                                <div class="flex-grow-1">
                                    <h6 class="mb-1">
                                        <a href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}"
                                           class="text-decoration-none text-dark">
                                            ${task.title}
                                        </a>
                                    </h6>
                                    <div class="d-flex gap-2 align-items-center">
                                        <c:forEach var="user" items="${allUsers}">
                                            <c:if test="${user.userId == task.assignedTo}">
                                                <small class="text-muted">
                                                    <i class="bi bi-person me-1"></i>${user.firstName} ${user.lastName}
                                                </small>
                                            </c:if>
                                        </c:forEach>
                                        <c:choose>
                                            <c:when test="${task.status == 'COMPLETED'}">
                                                <span class="badge bg-success">Hoàn thành</span>
                                            </c:when>
                                            <c:when test="${task.status == 'IN_PROGRESS'}">
                                                <span class="badge bg-info">Đang làm</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">Chờ xử lý</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="text-end ms-3">
                                    <small class="text-info d-block">
                                        <i class="bi bi-calendar me-1"></i>
                                        <fmt:formatDate value="${task.dueDate}" pattern="dd/MM/yyyy" />
                                    </small>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </c:if>

    <!-- No Reminders -->
    <c:if test="${empty overdueTasks && empty todayTasks && empty thisWeekTasks}">
        <div class="card">
            <div class="card-body text-center py-5">
                <i class="bi bi-check-circle text-success" style="font-size: 4rem;"></i>
                <h4 class="mt-3">Tuyệt vời!</h4>
                <p class="text-muted mb-0">Không có công việc nào cần nhắc nhở</p>
            </div>
        </div>
    </c:if>
</div>
