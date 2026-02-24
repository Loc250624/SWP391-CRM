<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1"><i class="bi bi-calendar3 me-2"></i>Lịch Công việc</h4>
        <p class="text-muted mb-0">Tháng ${month}/${year}</p>
    </div>
    <a href="${pageContext.request.contextPath}/support/task/list" class="btn btn-outline-primary btn-sm">
        <i class="bi bi-list-task me-1"></i>Xem danh sách
    </a>
</div>

<!-- Month Navigation -->
<div class="card mb-4 shadow-sm">
    <div class="card-body py-3">
        <div class="d-flex justify-content-between align-items-center">
            <a href="${pageContext.request.contextPath}/support/task/calendar?year=${previousYear}&month=${previousMonth}"
               class="btn btn-outline-primary btn-sm">
                <i class="bi bi-chevron-left me-1"></i>Tháng trước
            </a>
            <h6 class="mb-0">Tháng ${month} / ${year}</h6>
            <a href="${pageContext.request.contextPath}/support/task/calendar?year=${nextYear}&month=${nextMonth}"
               class="btn btn-outline-primary btn-sm">
                Tháng sau<i class="bi bi-chevron-right ms-1"></i>
            </a>
        </div>
    </div>
</div>

<!-- Calendar Grid -->
<div class="card shadow-sm">
    <div class="card-body p-0">
        <table class="table table-bordered mb-0" style="table-layout:fixed;">
            <thead class="table-light">
                <tr>
                    <th class="text-center py-2 small">T2</th>
                    <th class="text-center py-2 small">T3</th>
                    <th class="text-center py-2 small">T4</th>
                    <th class="text-center py-2 small">T5</th>
                    <th class="text-center py-2 small">T6</th>
                    <th class="text-center py-2 small">T7</th>
                    <th class="text-center py-2 small">CN</th>
                </tr>
            </thead>
            <tbody>
                <c:set var="dayCounter" value="1" />
                <c:forEach var="week" begin="0" end="5">
                    <tr>
                        <c:forEach var="dow" begin="1" end="7">
                            <td style="height:90px; vertical-align:top; padding:3px;">
                                <c:choose>
                                    <c:when test="${week == 0 && dow < firstDayOfWeek}">
                                        <!-- Empty -->
                                    </c:when>
                                    <c:when test="${dayCounter <= daysInMonth}">
                                        <c:if test="${week == 0 && dow >= firstDayOfWeek || week > 0}">
                                            <div class="p-1">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <span class="fw-bold small">${dayCounter}</span>
                                                    <c:if test="${not empty tasksByDate[dayCounter]}">
                                                        <span class="badge bg-primary rounded-pill" style="font-size:9px;">${tasksByDate[dayCounter].size()}</span>
                                                    </c:if>
                                                </div>
                                                <c:if test="${not empty tasksByDate[dayCounter]}">
                                                    <c:forEach var="task" items="${tasksByDate[dayCounter]}" varStatus="st">
                                                        <c:if test="${st.index < 2}">
                                                            <a href="${pageContext.request.contextPath}/support/task/detail?id=${task.taskId}"
                                                               class="d-block text-decoration-none mt-1" title="${task.title}">
                                                                <div class="rounded px-1 text-truncate
                                                                    ${task.priority == 'HIGH' ? 'bg-danger bg-opacity-15 border border-danger' :
                                                                      task.priority == 'MEDIUM' ? 'bg-warning bg-opacity-15 border border-warning' :
                                                                      'bg-secondary bg-opacity-15 border border-secondary'}"
                                                                     style="font-size:10px; max-width:100%;">
                                                                    <span class="text-dark">${task.title}</span>
                                                                </div>
                                                            </a>
                                                        </c:if>
                                                    </c:forEach>
                                                    <c:if test="${tasksByDate[dayCounter].size() > 2}">
                                                        <small class="text-muted" style="font-size:9px;">+${tasksByDate[dayCounter].size() - 2}</small>
                                                    </c:if>
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
<div class="mt-3 d-flex gap-3 align-items-center flex-wrap">
    <small class="text-muted">Chú thích:</small>
    <div class="d-flex align-items-center gap-1">
        <div style="width:12px;height:12px;background:rgba(220,53,69,0.15);border:1px solid #dc3545;border-radius:2px;"></div>
        <small>Cao</small>
    </div>
    <div class="d-flex align-items-center gap-1">
        <div style="width:12px;height:12px;background:rgba(255,193,7,0.15);border:1px solid #ffc107;border-radius:2px;"></div>
        <small>Trung bình</small>
    </div>
    <div class="d-flex align-items-center gap-1">
        <div style="width:12px;height:12px;background:rgba(108,117,125,0.15);border:1px solid #6c757d;border-radius:2px;"></div>
        <small>Thấp</small>
    </div>
</div>
