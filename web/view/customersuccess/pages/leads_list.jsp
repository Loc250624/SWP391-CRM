<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h5 class="fw-bold text-dark m-0"><i class="bi bi-person-plus-fill me-2 text-primary"></i>Danh sách Leads</h5>
    
    <div class="d-flex gap-3 align-items-center">
        <a href="${pageContext.request.contextPath}/support/leads/add" class="btn btn-primary rounded-pill px-3 shadow-sm">
            <i class="bi bi-plus-lg"></i> Thêm Lead
        </a>
        <div class="input-group" style="min-width: 300px;">
            <span class="input-group-text bg-white border-end-0"><i class="bi bi-telephone text-muted"></i></span>
            <input type="text" class="form-control border-start-0 shadow-none" id="searchPhone" 
                   placeholder="Lọc theo số điện thoại..." onkeyup="filterByPhone()">
        </div>
    </div>
</div>

<div class="card border-0 shadow-sm rounded-3 overflow-hidden">
    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0" id="leadsTable">
            <thead class="bg-light">
                <tr>
                    <th class="ps-4">Mã Lead</th>
                    <th>Họ Tên & Email</th>
                    <th>Số điện thoại</th>
                    <th>Trạng thái</th>
                    <th class="text-center">Chi tiết</th>
                    <th class="text-center">Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${leadList}" var="l">
                    <tr>
                        <td class="ps-4 text-primary fw-bold">${l.leadCode}</td>
                        <td>
                            <div class="fw-bold text-dark">${l.fullName}</div>
                            <div class="small text-muted">${l.email}</div>
                        </td>
                        <td class="phone-cell">${l.phone}</td>
                        <td><span class="badge bg-info-subtle text-info rounded-pill px-3">${l.status}</span></td>
                        <td class="text-center">
                            <a href="${pageContext.request.contextPath}/support/leads/detail?id=${l.leadId}" 
                               class="btn btn-sm btn-light border shadow-sm">
                                <i class="bi bi-eye-fill text-primary"></i>
                            </a>
                        </td>
                        <td class="text-center">
                            <div class="btn-group">
                                <button class="btn btn-sm btn-outline-success"><i class="bi bi-plus-circle"></i> Tạo phiếu</button>
                                <a href="${pageContext.request.contextPath}/support/activities?leadId=${l.leadId}" class="btn btn-sm btn-outline-info">
                                    <i class="bi bi-clock-history"></i> Lịch sử
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<script>
function filterByPhone() {
    let input = document.getElementById("searchPhone").value.toLowerCase();
    let rows = document.querySelectorAll("#leadsTable tbody tr");
    rows.forEach(row => {
        let phone = row.querySelector(".phone-cell").textContent.toLowerCase();
        row.style.display = phone.includes(input) ? "" : "none";
    });
}
</script>