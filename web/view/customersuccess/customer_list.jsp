<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    .status-badge { padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
    .status-active { background-color: #d1fae5; color: #065f46; }
    .status-inactive { background-color: #f1f5f9; color: #475569; }
    .modal-label { font-weight: 600; color: #64748b; font-size: 13px; margin-bottom: 2px; }
    .modal-value { color: #1e293b; font-weight: 500; margin-bottom: 15px; border-bottom: 1px solid #f1f5f9; padding-bottom: 5px; }
    .table-hover tbody tr:hover { background-color: #f8fafc; cursor: pointer; }
</style>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h5 class="fw-bold text-dark m-0"><i class="bi bi-people-fill me-2"></i>Danh sách khách hàng</h5>
    <div class="input-group" style="max-width: 350px;">
        <span class="input-group-text bg-white border-end-0"><i class="bi bi-search text-muted"></i></span>
        <input type="text" class="form-control border-start-0" id="searchPhone" placeholder="Tìm theo số điện thoại hoặc tên..." onkeyup="filterTable()">
    </div>
</div>

<div class="card border-0 shadow-sm rounded-3 overflow-hidden">
    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0" id="customerTable">
            <thead class="bg-light">
                <tr>
                    <th class="ps-4 border-0">Mã KH</th>
                    <th class="border-0">Họ Tên & Email</th>
                    <th class="border-0">Số điện thoại</th>
                    <th class="border-0">Trạng thái</th>
                    <th class="text-center border-0">Chi tiết</th>
                    <th class="text-center border-0">Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${customerList}" var="c">
                    <tr>
                        <td class="ps-4 text-primary fw-bold">${c.customerCode}</td>
                        <td>
                            <div class="fw-bold text-dark">${c.fullName}</div>
                            <div class="small text-muted">${c.email}</div>
                        </td>
                        <td class="phone-cell">${c.phone}</td>
                        <td>
                            <span class="status-badge ${c.status == 'Active' ? 'status-active' : 'status-inactive'}">
                                ${c.status}
                            </span>
                        </td>
                        <td class="text-center">
                            <button class="btn btn-sm btn-light border shadow-sm" 
                                    onclick="showDetail('${c.customerCode}', '${c.fullName}', '${c.email}', '${c.phone}', 
                                    '${c.gender}', '${c.address}', '${c.city}', '${c.customerSegment}', 
                                    '${c.totalSpent}', '${c.status}', '${c.notes}')">
                                <i class="bi bi-eye-fill text-primary"></i>
                            </button>
                        </td>
                        <td class="text-center">
                            <div class="btn-group">
                                <a href="${pageContext.request.contextPath}/support/create-ticket?id=${c.customerId}" 
                                   class="btn btn-sm btn-outline-success d-flex align-items-center gap-1" title="Tạo phiếu">
                                    <i class="bi bi-plus-circle"></i> <span>Tạo phiếu</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/support/history?id=${c.customerId}" 
                                   class="btn btn-sm btn-outline-info d-flex align-items-center gap-1" title="Lịch sử">
                                    <i class="bi bi-clock-history"></i> <span>Lịch sử</span>
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<div class="modal fade" id="detailModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 15px;">
            <div class="modal-header border-bottom-0 pt-4 px-4">
                <h5 class="modal-title fw-bold text-dark" id="modalTitle">
                    <i class="bi bi-person-badge me-2 text-primary"></i>Thông tin chi tiết
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <div class="row bg-light rounded-3 p-3 mb-3 mx-1">
                    <div class="col-md-4">
                        <div class="modal-label">Mã khách hàng</div>
                        <div class="modal-value" id="mCode"></div>
                    </div>
                    <div class="col-md-8">
                        <div class="modal-label">Họ và tên</div>
                        <div class="modal-value fw-bold text-primary" id="mName"></div>
                    </div>
                </div>
                <div class="row px-1">
                    <div class="col-md-6"><div class="modal-label">Email</div><div class="modal-value" id="mEmail"></div></div>
                    <div class="col-md-6"><div class="modal-label">Số điện thoại</div><div class="modal-value" id="mPhone"></div></div>
                    <div class="col-md-4"><div class="modal-label">Giới tính</div><div class="modal-value" id="mGender"></div></div>
                    <div class="col-md-4"><div class="modal-label">Phân khúc</div><div class="modal-value" id="mSegment"></div></div>
                    <div class="col-md-4"><div class="modal-label">Trạng thái</div><div class="modal-value" id="mStatus"></div></div>
                    <div class="col-md-8"><div class="modal-label">Địa chỉ</div><div class="modal-value" id="mAddress"></div></div>
                    <div class="col-md-4"><div class="modal-label">Thành phố</div><div class="modal-value" id="mCity"></div></div>
                    <div class="col-md-4"><div class="modal-label">Tổng chi tiêu</div><div class="modal-value text-success fw-bold" id="mSpent"></div></div>
                    <div class="col-12 mt-2"><div class="modal-label">Ghi chú</div><div class="modal-value text-muted italic" id="mNotes" style="border: none;"></div></div>
                </div>
            </div>
            <div class="modal-footer border-0 pb-4">
                <button type="button" class="btn btn-secondary px-4 rounded-pill" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<script>
    function filterTable() {
        let input = document.getElementById("searchPhone").value.toLowerCase();
        let rows = document.querySelectorAll("#customerTable tbody tr");
        rows.forEach(row => {
            let phone = row.querySelector(".phone-cell").textContent.toLowerCase();
            let name = row.querySelector(".fw-bold").textContent.toLowerCase();
            row.style.display = (phone.includes(input) || name.includes(input)) ? "" : "none";
        });
    }

    function showDetail(code, name, email, phone, gender, addr, city, segment, spent, status, notes) {
        document.getElementById("mCode").innerText = code;
        document.getElementById("mName").innerText = name;
        document.getElementById("mEmail").innerText = email;
        document.getElementById("mPhone").innerText = phone;
        document.getElementById("mGender").innerText = gender;
        document.getElementById("mAddress").innerText = addr;
        document.getElementById("mCity").innerText = city;
        document.getElementById("mSegment").innerText = segment;
        document.getElementById("mSpent").innerText = "$" + spent;
        document.getElementById("mStatus").innerText = status;
        document.getElementById("mNotes").innerText = notes || "Không có ghi chú";
        
        var myModal = new bootstrap.Modal(document.getElementById('detailModal'));
        myModal.show();
    }
</script>