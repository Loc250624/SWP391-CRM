<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="java.time.LocalDate" %>

<%-- 1. Logic tính toán số lượt hỗ trợ trong hôm nay --%>
<c:set var="today" value="<%= LocalDate.now() %>" />
<c:set var="todayCount" value="0" />
<c:forEach items="${activities}" var="countLog">
    <c:if test="${countLog.createdAt.toLocalDate() == today}">
        <c:set var="todayCount" value="${todayCount + 1}" />
    </c:if>
</c:forEach>

<style>
    /* Thẻ thống kê năng suất */
    .summary-card {
        background: linear-gradient(135deg, #0ea5e9 0%, #2563eb 100%);
        color: white;
        border-radius: 16px;
        padding: 24px;
        margin-bottom: 24px;
        display: flex;
        align-items: center;
        justify-content: space-between;
    }
    
    /* Header nhóm theo ngày */
    .day-group-header {
        background: #f1f5f9;
        border-left: 5px solid #3b82f6;
        padding: 12px 20px;
        margin: 25px 0 15px 0;
        font-weight: 700;
        color: #334155;
        border-radius: 4px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    /* Hiệu ứng trục thời gian (Timeline) */
    .timeline-item {
        position: relative;
        padding-left: 35px;
        margin-bottom: 20px;
    }
    .timeline-item::before {
        content: "";
        position: absolute;
        left: 12px;
        top: 0;
        bottom: -20px;
        width: 2px;
        background: #cbd5e1;
    }
    .timeline-item:last-child::before { display: none; }
    .timeline-dot {
        position: absolute;
        left: 5px;
        top: 5px;
        width: 16px;
        height: 16px;
        background: #3b82f6;
        border: 3px solid #fff;
        border-radius: 50%;
        box-shadow: 0 0 0 2px #3b82f6;
        z-index: 2;
    }
</style>

<div class="container-fluid px-4">
    <div class="summary-card shadow-sm mt-3" style="background: linear-gradient(135deg, #6366f1 0%, #4338ca 100%);">
        <div>
            <h6 class="text-white-50 mb-1 text-uppercase small fw-bold">Năng suất Tháng ${month}/${year}</h6>
            <h3 class="mb-0 fw-bold">${activities.size()} lượt hỗ trợ thành công</h3>
        </div>
        <div class="bg-white bg-opacity-20 p-3 rounded-circle">
            <i class="bi bi-calendar-check-fill fs-1"></i>
        </div>
    </div>

    <h5 class="fw-bold text-dark mb-3">
        <i class="bi bi-journal-bookmark me-2 text-primary"></i>Nhật ký hỗ trợ Tháng ${month}
    </h5>

    <div class="card border-0 shadow-sm p-4" style="border-radius: 16px;">
        <c:choose>
            <c:when test="${not empty activities}">
                <c:set var="lastDate" value="" />
                <c:forEach items="${activities}" var="log">
                    <c:set var="currentDate" value="${log.createdAt.toLocalDate()}" />
                    
                    <c:if test="${currentDate != lastDate}">
                        <div class="day-group-header shadow-sm">
                            <span><i class="bi bi-calendar3 me-2"></i>Ngày: ${currentDate}</span>
                        </div>
                        <c:set var="lastDate" value="${currentDate}" />
                    </c:if>

                    <div class="timeline-item">
                        <div class="timeline-dot"></div>
                        <div class="p-3 bg-white border rounded-3 shadow-sm mb-3">
                            <small class="text-muted fw-bold">${log.createdAt.toLocalTime()}</small>
                            <p class="mb-0 mt-1">
                                Bạn đã thực hiện hỗ trợ khách hàng 
                                <strong class="text-primary">${log.customerName}</strong> 
                                (SĐT: <span class="fw-bold text-dark">${log.customerPhone}</span>).
                            </p>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5">
                    <i class="bi bi-calendar-x display-4 text-light"></i>
                    <p class="text-muted mt-3">Bạn chưa có hoạt động hỗ trợ nào trong tháng ${month}.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>