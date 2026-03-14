<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* CSS hỗ trợ giao diện */
    .status-badge { padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
    .status-active { background-color: #d1fae5; color: #065f46; }
    .status-inactive { background-color: #f1f5f9; color: #475569; }
    .modal-label { font-weight: 600; color: #64748b; font-size: 13px; margin-bottom: 2px; text-transform: uppercase; }
</style>

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

<div id="liveAlertPlaceholder"></div>

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
                            <button type="button" class="btn btn-sm btn-warning rounded-pill px-3 fw-bold text-dark" 
                                    onclick="openForwardModal('${item.relatedId}', '${item.relatedType}', '${item.subject}', '${item.customerName}', '${item.createdBy}', '${item.performerName}')">
                                <i class="bi bi-arrow-right-short"></i> Chuyển tiếp
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

<div class="modal fade" id="forwardModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 15px;">
            <div class="modal-header border-bottom-0 pt-4 px-4">
                <h5 class="modal-title fw-bold text-dark"><i class="bi bi-send-fill me-2 text-warning"></i>Chuyển tiếp hỗ trợ</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4 pt-2">
                <div class="row bg-light rounded-3 p-3 mb-4 mx-1 border">
                    <div class="col-12 mb-2">
                        <div class="modal-label" style="font-size: 11px; color: #64748b; font-weight: bold;">KHÁCH HÀNG / LEAD</div>
                        <div class="fw-bold text-primary" id="fwd_CustomerName"></div>
                    </div>
                    <div class="col-12">
                        <div class="modal-label" style="font-size: 11px; color: #64748b; font-weight: bold;">CHUYỂN ĐẾN (NGƯỜI TẠO)</div>
                        <div class="fw-bold text-dark" id="fwd_AssigneeName"></div>
                    </div>
                </div>

                <form id="forwardForm">
                    <input type="hidden" name="id" id="fwd_Id">
                    <input type="hidden" name="type" id="fwd_Type">
                    <input type="hidden" name="assignTo" id="fwd_AssignTo">
                    <input type="hidden" name="status" value="Pending"> 
                    <input type="hidden" name="description" value="Phiếu yêu cầu hỗ trợ được chuyển tiếp từ bộ phận Tra cứu.">

                    <div class="px-1">
                        <label class="modal-label mb-2" style="font-size: 12px; font-weight: bold; color: #64748b;">TIÊU ĐỀ BÁO CÁO</label>
                        <input type="text" name="subject" id="fwd_Subject" class="form-control border-1 rounded-3 p-2 shadow-none" placeholder="Nhập vấn đề cần hỗ trợ..." required>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-0 pb-4 pr-4">
                <button type="button" class="btn btn-light px-4 rounded-pill border" data-bs-dismiss="modal">Hủy bỏ</button>
                <button type="button" class="btn btn-success px-5 rounded-pill shadow-sm fw-bold" onclick="submitForward()">
                    <i class="bi bi-send me-1"></i> Chuyển
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    function openForwardModal(id, type, code, name, assignToId, assigneeName) {
        document.getElementById("fwd_Id").value = id;
        document.getElementById("fwd_Type").value = type;
        document.getElementById("fwd_AssignTo").value = assignToId;
        document.getElementById("fwd_CustomerName").innerText = code + " - " + name;
        document.getElementById("fwd_AssigneeName").innerText = assigneeName || "Không xác định";
        document.getElementById("fwd_Subject").value = ""; 
        new bootstrap.Modal(document.getElementById('forwardModal')).show();
    }

    function submitForward() {
        const subject = document.getElementById("fwd_Subject").value;
        if(!subject) { alert("Vui lòng nhập tiêu đề báo cáo!"); return; }

        const formData = $('#forwardForm').serialize();
        $.post('${pageContext.request.contextPath}/support/activities', formData, function(response) {
            if (response.trim() === "success") {
                // Đóng Modal
                const modalElement = document.getElementById('forwardModal');
                bootstrap.Modal.getInstance(modalElement).hide();

                // Hiện thông báo Toast/Alert
                const alertHtml = 
                    '<div class="alert alert-dismissible fade show shadow-sm border-0 mb-4" role="alert" ' +
                    'style="border-left: 5px solid #198754 !important; background-color: white;">' +
                    '<i class="bi bi-check-circle-fill me-2" style="color: #198754"></i>' +
                    '<strong style="color: #198754">Thành công!</strong> Đã chuyển phiếu hỗ trợ thành công cho nhân viên phụ trách.' +
                    '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>' +
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