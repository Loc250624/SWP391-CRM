<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* Style bổ sung cho Modal giống mẫu bạn mong muốn */
    .modal-label {
        font-weight: 600;
        color: #64748b;
        font-size: 13px;
        margin-bottom: 2px;
        text-transform: uppercase;
    }
    .form-input-custom {
        border: none;
        border-bottom: 2px solid #e2e8f0;
        border-radius: 0;
        padding: 8px 0;
        background: transparent;
        transition: all 0.3s;
    }
    .form-input-custom:focus {
        box-shadow: none;
        border-bottom-color: #3b82f6;
        outline: none;
    }
    .badge-pending {
        background-color: #fff9db;
        color: #f08c00;
        border: 1px solid #ffe066;
    }
</style>

<div class="card border-0 shadow-sm rounded-3 overflow-hidden">
    <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
        <h5 class="fw-bold m-0 text-dark">
            <i class="bi bi-hourglass-split me-2 text-warning"></i>Hàng chờ xử lý
        </h5>
        <span class="badge badge-pending rounded-pill px-3">
            Đang chờ giải quyết
        </span>
    </div>
    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0">
            <thead class="bg-light text-muted small text-uppercase">
                <tr>
                    <th class="ps-4">Khách hàng</th>
                    <th>Vấn đề / Tiêu đề</th>
                    <th>Thời gian tạo</th>
                    <th class="text-center">Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${pendingList}" var="a">
                    <tr>
                        <td class="ps-4">
                            <div class="fw-bold text-dark">${a.customerName}</div>
                            <div class="small text-muted">${a.customerPhone}</div>
                        </td>
                        <td>
                            <div class="fw-medium text-dark">${a.subject}</div>
                            <div class="small text-muted text-truncate" style="max-width: 250px;">${a.description}</div>
                        </td>
                        <td>
                            <span class="badge bg-light text-dark border fw-normal">
                                <i class="bi bi-clock me-1"></i>${a.createdAt}
                            </span>
                        </td>
                        <td class="text-center">
                            <button class="btn btn-sm btn-primary rounded-pill px-3 shadow-sm" 
                                    onclick="openFinishModal('${a.activityId}', '${a.subject}', '${a.description}')">
                                <i class="bi bi-pencil-square me-1"></i> Xử lý & Hoàn thành
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty pendingList}">
                    <tr>
                        <td colspan="4" class="text-center py-5 text-muted">
                            <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                            Hiện tại không có báo cáo nào trong hàng chờ.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<div class="modal fade" id="finishModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 15px;">
            <div class="modal-header border-0 pt-4 px-4">
                <h5 class="fw-bold"><i class="bi bi-check2-circle me-2 text-success"></i>Hoàn thiện báo cáo hỗ trợ</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <input type="hidden" id="act_Id">
                
                <div class="mb-4">
                    <label class="modal-label">Tiêu đề báo cáo (Có thể sửa)</label>
                    <input type="text" id="act_Subject" class="form-control form-input-custom fw-bold text-primary fs-5" 
                           placeholder="Nhập tiêu đề phiếu...">
                </div>
                
                <div class="mb-3">
                    <label class="modal-label">Nội dung giải quyết cuối cùng</label>
                    <textarea id="act_Desc" class="form-control border-1 rounded-3 p-3 shadow-none" 
                              rows="6" placeholder="Cập nhật nội dung xử lý cuối cùng tại đây..."></textarea>
                </div>
            </div>
            <div class="modal-footer border-0 pb-4">
                <button type="button" class="btn btn-light px-4 rounded-pill border" data-bs-dismiss="modal">Đóng</button>
                <button type="button" class="btn btn-success px-5 rounded-pill shadow-sm fw-bold" id="btnConfirmFinish" onclick="confirmFinish()">
                    <i class="bi bi-send-check me-1"></i> Lưu & Chuyển vào lịch sử
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
// Khởi tạo Modal bằng Bootstrap 5
let myFinishModal;
document.addEventListener('DOMContentLoaded', function() {
    myFinishModal = new bootstrap.Modal(document.getElementById('finishModal'));
});

function openFinishModal(id, subject, desc) {
    document.getElementById('act_Id').value = id;
    document.getElementById('act_Subject').value = subject;
    document.getElementById('act_Desc').value = desc;
    myFinishModal.show();
}

function confirmFinish() {
    // Vô hiệu hóa nút để tránh double click
    const btn = document.getElementById('btnConfirmFinish');
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span> Đang lưu...';

    const id = document.getElementById('act_Id').value;
    const subject = document.getElementById('act_Subject').value;
    const desc = document.getElementById('act_Desc').value;
    
    if(!subject.trim()) {
        alert("Vui lòng không để trống tiêu đề báo cáo!");
        btn.disabled = false;
        btn.innerHTML = '<i class="bi bi-send-check me-1"></i> Lưu';
        return;
    }

    // Gửi AJAX POST
    $.ajax({
        url: '${pageContext.request.contextPath}/support/queue/complete',
        type: 'POST',
        data: {
            id: id, 
            subject: subject, 
            description: desc
        },
        success: function(res) {
            if(res.trim() === "success") {
                alert("Chúc mừng! Báo cáo đã được cập nhật và chuyển vào lịch sử hoạt động.");
                location.reload(); 
            } else {
                alert("Lỗi: " + res);
                btn.disabled = false;
                btn.innerHTML = '<i class="bi bi-send-check me-1"></i> Lưu';
            }
        },
        error: function() {
            alert("Lỗi kết nối máy chủ!");
            btn.disabled = false;
            btn.innerHTML = '<i class="bi bi-send-check me-1"></i> Lưu';
        }
    });
}
</script>