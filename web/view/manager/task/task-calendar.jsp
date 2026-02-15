<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="container-fluid">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="mb-1"><i class="bi bi-calendar3 me-2"></i>Lịch Công việc</h3>
            <p class="text-muted mb-0">Xem công việc theo lịch tháng</p>
        </div>
        <a href="${pageContext.request.contextPath}/manager/task/form?action=create" class="btn btn-primary">
            <i class="bi bi-plus-circle me-2"></i>Tạo Công việc
        </a>
    </div>

    <!-- Navigation Tabs -->
    <ul class="nav nav-tabs mb-4">
        <li class="nav-item">
            <a class="nav-link ${viewType == 'personal' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/manager/task/calendar?view=personal&year=${year}&month=${month}">
                <i class="bi bi-person me-2"></i>Lịch của tôi
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${viewType == 'team' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/manager/task/calendar?view=team&year=${year}&month=${month}">
                <i class="bi bi-people me-2"></i>Lịch nhóm
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/manager/task/list">
                <i class="bi bi-list-task me-2"></i>Danh sách
            </a>
        </li>
    </ul>

    <!-- Calendar Navigation -->
    <div class="card mb-4">
        <div class="card-body">
            <div class="d-flex justify-content-between align-items-center">
                <a href="${pageContext.request.contextPath}/manager/task/calendar?view=${viewType}&year=${previousYear}&month=${previousMonth}"
                   class="btn btn-outline-primary">
                    <i class="bi bi-chevron-left me-2"></i>Tháng trước
                </a>
                <h4 class="mb-0">Tháng ${month}/${year}</h4>
                <a href="${pageContext.request.contextPath}/manager/task/calendar?view=${viewType}&year=${nextYear}&month=${nextMonth}"
                   class="btn btn-outline-primary">
                    Tháng sau<i class="bi bi-chevron-right ms-2"></i>
                </a>
            </div>
        </div>
    </div>

    <!-- Calendar Grid -->
    <div class="card">
        <div class="card-body p-0">
            <table class="table table-bordered mb-0 calendar-table">
                <thead class="table-light">
                    <tr>
                        <th class="text-center">Thứ Hai</th>
                        <th class="text-center">Thứ Ba</th>
                        <th class="text-center">Thứ Tư</th>
                        <th class="text-center">Thứ Năm</th>
                        <th class="text-center">Thứ Sáu</th>
                        <th class="text-center">Thứ Bảy</th>
                        <th class="text-center">Chủ Nhật</th>
                    </tr>
                </thead>
                <tbody>
                    <c:set var="dayCounter" value="1" />
                    <c:set var="currentDayOfWeek" value="1" />

                    <c:forEach var="week" begin="0" end="5">
                        <tr>
                            <c:forEach var="dow" begin="1" end="7">
                                <td class="calendar-cell align-top" style="height: 120px;">
                                    <c:choose>
                                        <c:when test="${week == 0 && dow < firstDayOfWeek}">
                                            <!-- Empty cells before month starts -->
                                        </c:when>
                                        <c:when test="${dayCounter <= daysInMonth}">
                                            <c:if test="${week == 0 && dow >= firstDayOfWeek || week > 0}">
                                                <div class="p-2">
                                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                                        <span class="fw-bold">${dayCounter}</span>
                                                        <c:if test="${not empty tasksByDate[dayCounter]}">
                                                            <span class="badge bg-primary rounded-pill">${tasksByDate[dayCounter].size()}</span>
                                                        </c:if>
                                                    </div>

                                                    <!-- Tasks for this day -->
                                                    <c:if test="${not empty tasksByDate[dayCounter]}">
                                                        <div class="task-list-mini">
                                                            <c:forEach var="task" items="${tasksByDate[dayCounter]}" varStatus="status">
                                                                <c:if test="${status.index < 3}">
                                                                    <a href="${pageContext.request.contextPath}/manager/task/detail?id=${task.taskId}"
                                                                       class="d-block text-decoration-none mb-1">
                                                                        <div class="task-item-mini p-1 rounded
                                                                            ${task.priority == 'HIGH' ? 'bg-danger' : task.priority == 'MEDIUM' ? 'bg-warning' : 'bg-secondary'}
                                                                            bg-opacity-10 border border-${task.priority == 'HIGH' ? 'danger' : task.priority == 'MEDIUM' ? 'warning' : 'secondary'}">
                                                                            <small class="text-dark d-block text-truncate" style="max-width: 100%;">
                                                                                ${task.title}
                                                                            </small>
                                                                        </div>
                                                                    </a>
                                                                </c:if>
                                                            </c:forEach>
                                                            <c:if test="${tasksByDate[dayCounter].size() > 3}">
                                                                <small class="text-muted">+${tasksByDate[dayCounter].size() - 3} khác...</small>
                                                            </c:if>
                                                        </div>
                                                    </c:if>
                                                </div>
                                                <c:set var="dayCounter" value="${dayCounter + 1}" />
                                            </c:if>
                                        </c:when>
                                    </c:choose>
                                </td>
                            </c:forEach>
                        </tr>
                        <c:if test="${dayCounter > daysInMonth}">
                            <c:set var="breakLoop" value="true" />
                        </c:if>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Legend -->
    <div class="card mt-4">
        <div class="card-body">
            <h6 class="mb-3">Chú thích</h6>
            <div class="d-flex gap-4 flex-wrap">
                <div class="d-flex align-items-center">
                    <div class="me-2" style="width: 20px; height: 20px; background-color: rgba(220, 53, 69, 0.1); border: 1px solid #dc3545; border-radius: 4px;"></div>
                    <span>Ưu tiên cao</span>
                </div>
                <div class="d-flex align-items-center">
                    <div class="me-2" style="width: 20px; height: 20px; background-color: rgba(255, 193, 7, 0.1); border: 1px solid #ffc107; border-radius: 4px;"></div>
                    <span>Ưu tiên trung bình</span>
                </div>
                <div class="d-flex align-items-center">
                    <div class="me-2" style="width: 20px; height: 20px; background-color: rgba(108, 117, 125, 0.1); border: 1px solid #6c757d; border-radius: 4px;"></div>
                    <span>Ưu tiên thấp</span>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .calendar-table {
        border-collapse: separate;
        border-spacing: 0;
    }

    .calendar-table th {
        background-color: #f8f9fa;
        font-weight: 600;
        padding: 12px;
        border: 1px solid #dee2e6;
    }

    .calendar-cell {
        border: 1px solid #dee2e6;
        vertical-align: top;
        position: relative;
    }

    .task-list-mini {
        max-height: 80px;
        overflow-y: auto;
    }

    .task-item-mini {
        transition: all 0.2s;
    }

    .task-item-mini:hover {
        transform: translateX(2px);
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    .calendar-table tbody tr:hover {
        background-color: rgba(0, 0, 0, 0.02);
    }
</style>
