<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .modal-label { font-weight: 600; color: #64748b; font-size: 13px; margin-bottom: 2px; text-transform: uppercase; }
    .form-input-custom { border: none; border-bottom: 2px solid #e2e8f0; border-radius: 0; padding: 8px 0; background: transparent; transition: all 0.3s; }
    .form-input-custom:focus { box-shadow: none; border-bottom-color: #3b82f6; outline: none; }
    .badge-pending { background-color: #fff9db; color: #f08c00; border: 1px solid #ffe066; }
    /* CSS cho Select2 */
    .select2-container--bootstrap-5 .select2-selection { border: 1px solid #dee2e6; border-radius: 0.375rem; padding: 0.375rem 0.75rem; }
    .select2-container--bootstrap-5 .select2-selection--multiple .select2-selection__choice { background-color: #e0f2fe; color: #1e40af; border: 1px solid #bae6fd; font-size: 13px; margin-top: 4px;}
</style>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" />

<div class="card border-0 shadow-sm rounded-3 overflow-hidden">
    <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
        <h5 class="fw-bold m-0 text-dark"><i class="bi bi-hourglass-split me-2 text-warning"></i>${pageTitle}</h5>
        <span class="badge badge-pending rounded-pill px-3">Đang chờ giải quyết</span>
    </div>
    
    <div class="table-responsive" id="realtimeTable">
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
                    <tr id="row-${a.activityId}" class="position-relative ${!a.isRead && pageTitle == 'Phiếu hỗ trợ được phân công' ? 'bg-warning bg-opacity-10' : ''}">
                        <td class="ps-4">
                            <c:if test="${!a.isRead && pageTitle == 'Phiếu hỗ trợ được phân công'}">
                                <span id="dot-${a.activityId}" class="position-absolute top-0 start-0 translate-middle p-2 bg-danger border border-light rounded-circle" style="margin-top: 25px; margin-left: 15px;" title="Phiếu mới">
                                    <span class="visually-hidden">New alerts</span>
                                </span>
                            </c:if>
                            <div class="fw-bold text-dark">${a.customerName}</div>
                            <div class="small text-muted">${a.customerPhone}</div>
                        </td>
                        <td>
                            <div class="fw-medium text-dark">${a.subject}</div>
                            <div class="small text-muted text-truncate" style="max-width: 250px;">${a.description}</div>
                        </td>
                        <td>
                            <span class="badge bg-light text-dark border fw-normal"><i class="bi bi-clock me-1"></i>${a.createdAt}</span>
                        </td>
                        <td class="text-center">
                            <%-- ĐÃ TRUYỀN THÊM RELATED_ID VÀ RELATED_TYPE ĐỂ LẤY KHÓA HỌC --%>
                            <button class="btn btn-sm btn-primary rounded-pill px-3 shadow-sm" 
                                    onclick="markAsRead('${a.activityId}'); openFinishModal('${a.activityId}', '${a.subject}', '${a.description}', '${a.relatedId}', '${a.relatedType}')">
                                <i class="bi bi-pencil-square me-1"></i> Xử lý & Hoàn thành
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty pendingList}">
                    <tr>
                        <td colspan="4" class="text-center py-5 text-muted">
                            <i class="bi bi-inbox fs-1 d-block mb-2"></i> Hiện tại không có báo cáo nào trong hàng chờ.
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
                <form id="finishForm">
                    <input type="hidden" name="id" id="act_Id">
                    
                    <div class="mb-4">
                        <label class="modal-label text-primary"><i class="bi bi-cart-plus me-1"></i>Đăng ký khóa học (Upsale)</label>
                        <p class="text-muted mb-2" style="font-size: 11px;">* Bỏ trống nếu chỉ hoàn thành báo cáo chăm sóc bình thường.</p>
                        <select class="form-select" name="courseIds" id="courseSelect" multiple="multiple" style="width: 100%;"></select>
                    </div>

                    <div class="mb-4">
                        <label class="modal-label">Tiêu đề báo cáo</label>
                        <input type="text" name="subject" id="act_Subject" class="form-control form-input-custom fw-bold text-primary fs-5" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="modal-label">Nội dung giải quyết cuối cùng</label>
                        <textarea name="description" id="act_Desc" class="form-control border-1 rounded-3 p-3 shadow-none" rows="5"></textarea>
                    </div>
                </form>
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
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

<script>
let myFinishModal;
$(document).ready(function() {
    myFinishModal = new bootstrap.Modal(document.getElementById('finishModal'));
    
    // Khởi tạo Select2
    $('#courseSelect').select2({
        theme: 'bootstrap-5',
        placeholder: "🔍 Tìm và chọn khóa học khách muốn mua...",
        allowClear: true,
        dropdownParent: $('#finishModal') 
    });
});

function markAsRead(activityId) {
    $('#dot-' + activityId).fadeOut('fast');
    $('#row-' + activityId).removeClass('bg-warning bg-opacity-10');
    $.post('${pageContext.request.contextPath}/support/api/notifications', { action: 'markRead', id: activityId }, function(res) {
        if(res.trim() === 'success') {
            if(typeof checkNewNotifications === 'function') checkNewNotifications();
        }
    });
}

function openFinishModal(id, subject, desc, relatedId, relatedType) {
    document.getElementById('act_Id').value = id;
    document.getElementById('act_Subject').value = subject;
    document.getElementById('act_Desc').value = desc;
    
    // Reset và tải lại danh sách khóa học chưa mua
    $('#courseSelect').empty().trigger("change");
    $.ajax({
        url: '${pageContext.request.contextPath}/support/available-courses', 
        type: 'GET',
        data: { id: relatedId, type: relatedType },
        dataType: 'json',
        success: function(courses) {
            if(courses && courses.length > 0) {
                courses.forEach(function(course) {
                    let priceFormatted = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(course.price);
                    let optionText = course.courseName + ' (' + priceFormatted + ')';
                    $('#courseSelect').append(new Option(optionText, course.courseId, false, false));
                });
                $('#courseSelect').trigger('change');
            }
        }
    });

    myFinishModal.show();
}

function confirmFinish() {
    const subject = document.getElementById('act_Subject').value;
    if(!subject.trim()) { alert("Vui lòng không để trống tiêu đề báo cáo!"); return; }

    const btn = document.getElementById('btnConfirmFinish');
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span> Đang lưu...';

    // Đóng gói toàn bộ form (Bao gồm cả mảng courseIds) gửi lên Server
    const formData = $('#finishForm').serialize();

    $.post('${pageContext.request.contextPath}/support/queue/complete', formData, function(res) {
        if(res.trim() === "success") {
            let courseCount = $('#courseSelect').val().length;
            let msg = (courseCount > 0) ? "Cập nhật thành công! Khách hàng đã được đăng ký " + courseCount + " khóa học." : "Báo cáo đã chuyển vào lịch sử hoạt động.";
            alert(msg);
            location.reload(); 
        } else {
            alert("Lỗi: Không thể lưu dữ liệu.");
            btn.disabled = false;
            btn.innerHTML = '<i class="bi bi-send-check me-1"></i> Lưu & Chuyển vào lịch sử';
        }
    }).fail(function() {
        alert("Lỗi kết nối máy chủ!");
        btn.disabled = false;
        btn.innerHTML = '<i class="bi bi-send-check me-1"></i> Lưu & Chuyển vào lịch sử';
    });
}

<c:if test="${pageTitle == 'Phiếu hỗ trợ được phân công'}">
    setInterval(function() {
        $('#realtimeTable').load(window.location.href + ' #realtimeTable > *');
    }, 2000); 
</c:if>
</script>