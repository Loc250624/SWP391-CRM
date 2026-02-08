<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Customer - CRM</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f3f4f6; }
        .sidebar { height: 100vh; width: 250px; position: fixed; top: 0; left: 0; background-color: #1e293b; color: white; padding-top: 20px; z-index: 1000; }
        .sidebar-brand { text-align: center; font-size: 24px; font-weight: bold; color: #38bdf8; margin-bottom: 30px; }
        .sidebar a { padding: 15px 25px; text-decoration: none; color: #cbd5e1; display: block; transition: 0.3s; }
        .sidebar a:hover, .sidebar a.active { background-color: #334155; color: white; border-left: 4px solid #38bdf8; }
        .main-content { margin-left: 250px; padding: 30px; }
        .header-profile { display: flex; justify-content: space-between; align-items: center; background: white; padding: 15px 25px; border-radius: 10px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); margin-bottom: 30px; }
        .status-badge { padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .status-active { background-color: #d1fae5; color: #065f46; }
        .status-inactive { background-color: #f1f5f9; color: #475569; }
        .modal-label { font-weight: 600; color: #64748b; font-size: 13px; margin-bottom: 2px; }
        .modal-value { color: #1e293b; font-weight: 500; margin-bottom: 15px; border-bottom: 1px solid #f1f5f9; padding-bottom: 5px; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-brand"><i class="fa-solid fa-cloud"></i> CRM System</div>
        <a href="${pageContext.request.contextPath}/support/dashboard"><i class="fa-solid fa-chart-line"></i> Tổng quan</a>
        <a href="${pageContext.request.contextPath}/support/customers" class="active"><i class="fa-solid fa-users"></i> Quản lý Customer</a>
        <a href="#"><i class="fa-solid fa-gear"></i> Cài đặt</a>
        <a href="${pageContext.request.contextPath}/login" style="margin-top: 50px; color: #f87171;"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a>
    </div>

    <div class="main-content">
        <div class="header-profile">
            <h4 class="m-0 fw-bold">Quản lý Customer</h4>
            <div class="d-flex align-items-center">
                <div class="me-3 text-end">
                    <div class="fw-bold">${sessionScope.account.fullName}</div>
                    <div class="small text-muted">${sessionScope.account.roleCode}</div>
                </div>
                <img src="https://ui-avatars.com/api/?name=${sessionScope.account.fullName}&background=0D8ABC&color=fff" class="rounded-circle" width="45">
            </div>
        </div>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h5 class="fw-semibold text-secondary m-0">Danh sách khách hàng</h5>
            <div class="input-group" style="max-width: 300px;">
                <span class="input-group-text bg-white border-end-0"><i class="fa-solid fa-magnifying-glass text-muted"></i></span>
                <input type="text" class="form-control border-start-0" id="searchPhone" placeholder="Tìm theo số điện thoại..." onkeyup="filterTable()">
            </div>
        </div>

        <div class="card border-0 shadow-sm rounded-3">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0" id="customerTable">
                    <thead class="bg-light">
                        <tr>
                            <th class="ps-4">Mã KH</th>
                            <th>Họ Tên & Email</th>
                            <th>Số điện thoại</th>
                            <th>Trạng thái</th>
                            <th class="text-center">Chi tiết</th>
                            <th class="text-center">Hỗ trợ</th> </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${customerList}" var="c">
                            <tr>
                                <td class="ps-4 text-primary fw-bold">${c.customerCode}</td>
                                <td>
                                    <div class="fw-bold">${c.fullName}</div>
                                    <div class="small text-muted">${c.email}</div>
                                </td>
                                <td class="phone-cell">${c.phone}</td>
                                <td>
                                    <span class="status-badge ${c.status == 'Active' ? 'status-active' : 'status-inactive'}">
                                        ${c.status}
                                    </span>
                                </td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-light border" 
                                            onclick="showDetail('${c.customerCode}', '${c.fullName}', '${c.email}', '${c.phone}', 
                                            '${c.gender}', '${c.address}', '${c.city}', '${c.customerSegment}', 
                                            '${c.totalSpent}', '${c.status}', '${c.notes}')">
                                        <i class="fa-solid fa-eye text-primary"></i>
                                    </button>
                                </td>
                                <td class="text-center">
                                    <div class="btn-group">
                                        <a href="${pageContext.request.contextPath}/support/create-ticket?id=${c.customerId}" 
                                           class="btn btn-sm btn-outline-success me-1" title="Tạo phiếu">
                                            <i class="fa-solid fa-plus-circle"></i> Tạo phiếu
                                        </a>
                                        <a href="${pageContext.request.contextPath}/support/history?id=${c.customerId}" 
                                           class="btn btn-sm btn-outline-info" title="Lịch sử">
                                            <i class="fa-solid fa-clock-rotate-left"></i> Lịch sử
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="detailModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-light">
                    <h5 class="modal-title fw-bold" id="modalTitle">Thông tin chi tiết khách hàng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row">
                        <div class="col-md-4"><div class="modal-label">Mã khách hàng</div><div class="modal-value" id="mCode"></div></div>
                        <div class="col-md-8"><div class="modal-label">Họ và tên</div><div class="modal-value" id="mName"></div></div>
                        <div class="col-md-6"><div class="modal-label">Email</div><div class="modal-value" id="mEmail"></div></div>
                        <div class="col-md-6"><div class="modal-label">Số điện thoại</div><div class="modal-value" id="mPhone"></div></div>
                        <div class="col-md-4"><div class="modal-label">Giới tính</div><div class="modal-value" id="mGender"></div></div>
                        <div class="col-md-4"><div class="modal-label">Phân khúc</div><div class="modal-value" id="mSegment"></div></div>
                        <div class="col-md-4"><div class="modal-label">Trạng thái</div><div class="modal-value" id="mStatus"></div></div>
                        <div class="col-md-8"><div class="modal-label">Địa chỉ</div><div class="modal-value" id="mAddress"></div></div>
                        <div class="col-md-4"><div class="modal-label">Thành phố</div><div class="modal-value" id="mCity"></div></div>
                        <div class="col-md-4"><div class="modal-label">Tổng chi tiêu</div><div class="modal-value text-success fw-bold" id="mSpent"></div></div>
                        <div class="col-12"><div class="modal-label">Ghi chú</div><div class="modal-value" id="mNotes" style="border: none;"></div></div>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function filterTable() {
            let input = document.getElementById("searchPhone").value.toLowerCase();
            let rows = document.querySelectorAll("#customerTable tbody tr");
            rows.forEach(row => {
                let phone = row.querySelector(".phone-cell").textContent.toLowerCase();
                row.style.display = phone.includes(input) ? "" : "none";
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
</body>
</html>