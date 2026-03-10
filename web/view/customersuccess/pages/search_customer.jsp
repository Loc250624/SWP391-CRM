<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="card border-0 shadow-sm rounded-3 p-4 mb-4">
    <h5 class="fw-bold mb-4 text-dark"><i class="bi bi-person-search me-2 text-primary"></i>Tra cứu Khách hàng & Lead</h5>
    <form action="${pageContext.request.contextPath}/support/search" method="GET" class="row g-3">
        <div class="col-md-3">
            <label class="modal-label">Mã KH / Lead</label>
            <input type="text" name="sCode" class="form-control" placeholder="KH0001..." value="${param.sCode}">
        </div>
        <div class="col-md-4">
            <label class="modal-label">Họ và tên</label>
            <input type="text" name="sName" class="form-control" placeholder="Nhập tên..." value="${param.sName}">
        </div>
        <div class="col-md-3">
            <label class="modal-label">Số điện thoại</label>
            <input type="text" name="sPhone" class="form-control" placeholder="09xxxxxxxx" value="${param.sPhone}">
        </div>
        <div class="col-md-2 d-flex align-items-end">
            <button type="submit" class="btn btn-primary w-100 rounded-pill fw-bold">Tra cứu</button>
        </div>
    </form>
</div>

<div class="card border-0 shadow-sm rounded-3 overflow-hidden">
    <table class="table table-hover align-middle mb-0">
        <thead class="bg-light text-muted small text-uppercase">
            <tr>
                <th class="ps-4">Mã định danh</th>
                <th>Họ Tên</th>
                <th>Số điện thoại</th>
                <th>Trạng thái</th>
                <th>Người tạo</th>
                <th class="text-center">Hành động</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${searchResult}" var="item">
                <tr>
                    <td class="ps-4">
                        <span class="badge ${item.relatedType == 'Customer' ? 'bg-primary' : 'bg-info'} mb-1">${item.relatedType}</span><br>
                        <span class="fw-bold text-dark">${item.subject}</span>
                    </td>
                    <td class="fw-bold text-dark">${item.customerName}</td>
                    <td class="fw-medium">${item.customerPhone}</td>
                    <td>
                        <span class="status-badge ${item.status == 'Active' || item.status == 'New' ? 'status-active' : 'status-inactive'}">
                            ${item.status}
                        </span>
                    </td>
                    <td class="text-muted small">${item.performerName}</td>
                    <td class="text-center">
                        <%-- Chỉ giữ lại nút Chuyển tiếp nếu không phải do chính người dùng hiện tại tạo --%>
                        <c:if test="${item.createdBy != sessionScope.user.userId}">
                            <button class="btn btn-sm btn-warning text-white rounded-pill px-3 shadow-sm" 
                                    onclick="forwardTask('${item.relatedId}', '${item.relatedType}')">
                                <i class="bi bi-arrow-right-short me-1"></i> Chuyển tiếp
                            </button>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    <c:if test="${empty searchResult}">
        <div class="text-center py-5 text-muted">Nhập thông tin để tìm kiếm khách hàng.</div>
    </c:if>
</div>