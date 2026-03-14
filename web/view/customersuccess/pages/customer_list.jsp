<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Giữ nguyên phần Style của bạn --%>
<style>
    .status-badge { padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
    .status-active { background-color: #d1fae5; color: #065f46; }
    .status-inactive { background-color: #f1f5f9; color: #475569; }
    .modal-label { font-weight: 600; color: #64748b; font-size: 13px; margin-bottom: 2px; text-transform: uppercase; }
    .modal-value { color: #1e293b; font-weight: 500; margin-bottom: 15px; border-bottom: 1px solid #f1f5f9; padding-bottom: 5px; }
    .form-input-custom { border: none; border-bottom: 2px solid #e2e8f0; border-radius: 0; padding: 8px 0; background: transparent; transition: all 0.3s; }
    .form-input-custom:focus { box-shadow: none; border-bottom-color: #3b82f6; outline: none; }
    .table-hover tbody tr:hover { background-color: #f8fafc; cursor: pointer; }
</style>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h5 class="fw-bold text-dark m-0"><i class="bi bi-people-fill me-2 text-primary"></i>Danh sách khách hàng</h5>
    <div class="input-group" style="max-width: 350px;">
        <span class="input-group-text bg-white border-end-0"><i class="bi bi-search text-muted"></i></span>
        <input type="text" class="form-control border-start-0 shadow-none" id="searchPhone" placeholder="Tìm theo số điện thoại hoặc tên..." onkeyup="filterTable()">
    </div>
</div>

<div id="liveAlertPlaceholder"></div>

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
                                <button type="button" class="btn btn-sm btn-outline-success d-flex align-items-center gap-1" 
                                        onclick="openReportModal('${c.customerId}', '${c.customerCode}', '${c.fullName}', 'Customer')">
                                    <i class="bi bi-plus-circle"></i> <span>Tạo phiếu</span>
                                </button>
                                <a href="${pageContext.request.contextPath}/support/activities?id=${c.customerId}&type=Customer" 
                                   class="btn btn-sm btn-outline-info d-flex align-items-center gap-1">
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

<%-- Detail Modal giữ nguyên --%>
<div class="modal fade" id="detailModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 15px;">
            <div class="modal-header border-bottom-0 pt-4 px-4">
                <h5 class="modal-title fw-bold text-dark"><i class="bi bi-person-badge me-2 text-primary"></i>Thông tin chi tiết</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <div class="row bg-light rounded-3 p-3 mb-3 mx-1">
                    <div class="col-md-4"><div class="modal-label">Mã khách hàng</div><div class="modal-value" id="mCode"></div></div>
                    <div class="col-md-8"><div class="modal-label">Họ và tên</div><div class="modal-value fw-bold text-primary" id="mName"></div></div>
                </div>
                <div class="row px-1">
                    <div class="col-md-6"><div class="modal-label">Email</div><div class="modal-value" id="mEmail"></div></div>
                    <div class="col-md-6"><div class="modal-label">Số điện thoại</div><div class="modal-value" id="mPhone"></div></div>
                    <div class="col-md-4"><div class="modal-label">Giới tính</div><div class="modal-value" id="mGender"></div></div>
                    <div class="col-md-4"><div class="modal-label">Phân khúc</div><div class="modal-value" id="mSegment"></div></div>
                    <div class="col-md-4"><div class="modal-label">Trạng thái</div><div class="modal-value" id="mStatus"></div></div>
                    <div class="col-md-4"><div class="modal-label">Tổng chi tiêu</div><div class="modal-value text-success fw-bold" id="mSpent"></div></div>
                    <div class="col-12 mt-2"><div class="modal-label">Ghi chú</div><div class="modal-value text-muted italic" id="mNotes" style="border: none;"></div></div>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- Report Modal: Đã thêm hidden input 'type' để đồng bộ --%>
<div class="modal fade" id="reportModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 15px;">
            <div class="modal-header border-bottom-0 pt-4 px-4">
                <h5 class="modal-title fw-bold text-dark"><i class="bi bi-file-earmark-plus me-2 text-success"></i>Tạo báo cáo hỗ trợ</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <div class="row rounded-3 p-3 mb-4 mx-1" style="background-color: #f0f7ff !important; border: 1px solid #e0efff;">
                    <div class="col-md-4"><div class="modal-label">Mã định danh</div><div class="modal-value mb-0" id="rpt_Code"></div></div>
                    <div class="col-md-8"><div class="modal-label">Họ và tên</div><div class="modal-value fw-bold text-primary mb-0" id="rpt_Name"></div></div>
                </div>

                <form id="reportForm">
                    <input type="hidden" name="id" id="rpt_Id">
                    <input type="hidden" name="type" id="rpt_Type">
                    <input type="hidden" name="status" id="rpt_Status" value="Completed">

                    <div class="row px-1">
                        <div class="col-12 mb-4">
                            <label class="modal-label">Tiêu đề báo cáo</label>
                            <input type="text" name="subject" class="form-control form-input-custom" placeholder="Nhập tiêu đề phiếu..." required>
                        </div>
                        <div class="col-12 mb-3">
                            <label class="modal-label">Nội dung chi tiết</label>
                            <textarea name="description" class="form-control border-1 rounded-3 p-3 shadow-none" rows="5" placeholder="Ghi chú nội dung hỗ trợ khách hàng tại đây..."></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-0 pb-4 pr-4">
                <button type="button" class="btn btn-light px-4 rounded-pill border" data-bs-dismiss="modal">Hủy bỏ</button>
                <button type="button" class="btn btn-warning px-4 rounded-pill shadow-sm text-dark fw-bold" onclick="addToQueue()">
                    <i class="bi bi-clock-history me-1"></i> Thêm vào hàng chờ
                </button>
                <button type="button" class="btn btn-success px-5 rounded-pill shadow-sm" onclick="submitReport()">
                    <i class="bi bi-check-lg me-1"></i> Lưu báo cáo
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
        document.getElementById("mSegment").innerText = segment;
        document.getElementById("mSpent").innerText = "$" + spent;
        document.getElementById("mStatus").innerText = status;
        document.getElementById("mNotes").innerText = notes || "Không có ghi chú";
        new bootstrap.Modal(document.getElementById('detailModal')).show();
    }

    // --- ĐÃ ĐỒNG BỘ THAM SỐ TYPE ---
    function openReportModal(id, code, name, type) {
        document.getElementById("rpt_Id").value = id;
        document.getElementById("rpt_Type").value = type; // Gán 'Customer'
        document.getElementById("rpt_Code").innerText = code;
        document.getElementById("rpt_Name").innerText = name;
        document.getElementById("reportForm").reset(); 
        new bootstrap.Modal(document.getElementById('reportModal')).show();
    }

    function submitReport() {
        const subject = $("input[name='subject']").val();
        if(!subject) { alert("Vui lòng nhập tiêu đề!"); return; }
        document.getElementById("rpt_Status").value = "Completed"; 
        executeSubmit();
    }

    function addToQueue() {
        const subject = $("input[name='subject']").val();
        if(!subject) { alert("Vui lòng nhập tiêu đề!"); return; }
        document.getElementById("rpt_Status").value = "Pending"; 
        executeSubmit();
    }

    function executeSubmit() {
        const formData = $('#reportForm').serialize();
        const status = document.getElementById("rpt_Status").value;
        const subject = $("input[name='subject']").val();

        // Gửi tới ActivityController đã được đồng bộ
        $.post('${pageContext.request.contextPath}/support/activities', formData, function (response) {
            if (response.trim() === "success") {
                const modalElement = document.getElementById('reportModal');
                bootstrap.Modal.getInstance(modalElement).hide();

                let alertTitle = (status === "Pending") ? "Đã vào hàng chờ!" : "Thành công!";
                let alertColor = (status === "Pending") ? "#ffc107" : "#198754";
                let icon = (status === "Pending") ? "bi-clock-history" : "bi-check-circle-fill";
                let alertMsg = (status === "Pending") 
                    ? "Báo cáo \"" + subject + "\" đã chuyển vào hàng chờ." 
                    : "Báo cáo \"" + subject + "\" đã được lưu vào lịch sử.";

                const alertHtml = 
                    '<div class="alert alert-dismissible fade show shadow-sm border-0 mb-4" role="alert" ' +
                    'style="border-left: 5px solid ' + alertColor + ' !important; background-color: white;">' +
                    '<i class="bi ' + icon + ' me-2" style="color: ' + alertColor + '"></i>' +
                    '<strong style="color: ' + alertColor + '">' + alertTitle + '</strong> ' + alertMsg +
                    '<button type="button" class="btn-close" data-bs-alert="alert"></button>' +
                    '</div>';
                
                $('#liveAlertPlaceholder').html(alertHtml);
                window.scrollTo({top: 0, behavior: 'smooth'});
            } else {
                alert("Lỗi: " + response);
            }
        }).fail(function () {
            alert("Không thể kết nối với máy chủ.");
        });
    }
</script>