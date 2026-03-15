<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* Style cho Modal giống Customer */
    .modal-label { font-weight: 600; color: #64748b; font-size: 13px; margin-bottom: 2px; text-transform: uppercase; }
    .modal-value { color: #1e293b; font-weight: 500; margin-bottom: 15px; border-bottom: 1px solid #f1f5f9; padding-bottom: 5px; }
    .form-input-custom { border: none; border-bottom: 2px solid #e2e8f0; border-radius: 0; padding: 8px 0; background: transparent; transition: all 0.3s; }
    .form-input-custom:focus { box-shadow: none; border-bottom-color: #3b82f6; outline: none; }
    .table-hover tbody tr:hover { background-color: #f8fafc; cursor: pointer; }

    /* CSS cho Select2 (Làm đẹp ô chọn khóa học) */
    .select2-container--bootstrap-5 .select2-selection { border: 1px solid #dee2e6; border-radius: 0.375rem; padding: 0.375rem 0.75rem; }
    .select2-container--bootstrap-5 .select2-selection--multiple .select2-selection__choice { background-color: #e0f2fe; color: #1e40af; border: 1px solid #bae6fd; font-size: 13px; margin-top: 4px;}
</style>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" />

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

<div id="liveAlertPlaceholder"></div>

<div class="card border-0 shadow-sm rounded-3 overflow-hidden">
    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0" id="leadsTable">
            <thead class="bg-light">
                <tr>
                    <th class="ps-4 border-0">Mã Lead</th>
                    <th class="border-0">Họ Tên & Email</th>
                    <th class="border-0">Số điện thoại</th>
                    <th class="border-0">Trạng thái</th>
                    <th class="text-center border-0">Chi tiết</th>
                    <th class="text-center border-0">Hành động</th>
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
                                <button type="button" class="btn btn-sm btn-outline-success d-flex align-items-center gap-1" 
                                        onclick="openReportModal('${l.leadId}', '${l.leadCode}', '${l.fullName}', 'Lead')">
                                    <i class="bi bi-plus-circle"></i> <span>Tạo phiếu</span>
                                </button>
                                <a href="${pageContext.request.contextPath}/support/activities?id=${l.leadId}&type=Lead" 
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
                        <div class="col-12 mb-4 p-3 bg-light rounded-3 border">
                            <label class="modal-label text-primary"><i class="bi bi-cart-plus me-1"></i>Đăng ký khóa học (Chuyển đổi thành Khách hàng)</label>
                            <p class="text-muted mb-2" style="font-size: 11px;">* Bỏ trống nếu chỉ tạo báo cáo chăm sóc bình thường.</p>
                            <select class="form-select" name="courseIds" id="courseSelect" multiple="multiple" style="width: 100%;">
                                </select>
                        </div>

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
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

<script>
    // --- KHỞI TẠO SELECT2 ---
    $(document).ready(function() {
        $('#courseSelect').select2({
            theme: 'bootstrap-5',
            placeholder: "🔍 Tìm và chọn khóa học khách muốn mua...",
            allowClear: true,
            dropdownParent: $('#reportModal') // Rất quan trọng để hiển thị đúng trong Bootstrap Modal
        });
    });

    // --- TÌM KIẾM ---
    function filterByPhone() {
        let input = document.getElementById("searchPhone").value.toLowerCase();
        let rows = document.querySelectorAll("#leadsTable tbody tr");
        rows.forEach(row => {
            let phone = row.querySelector(".phone-cell").textContent.toLowerCase();
            row.style.display = phone.includes(input) ? "" : "none";
        });
    }

    // --- MỞ MODAL & GỌI AJAX LẤY KHÓA HỌC ---
    function openReportModal(id, code, name, type) {
        document.getElementById("rpt_Id").value = id;
        document.getElementById("rpt_Type").value = type; // Nhận 'Lead'
        document.getElementById("rpt_Code").innerText = code;
        document.getElementById("rpt_Name").innerText = name;
        document.getElementById("reportForm").reset(); 
        
        // Làm trống Select2 mỗi lần mở Modal
        $('#courseSelect').empty().trigger("change");

        // Gọi AJAX lấy danh sách khóa học (Dùng chung API với Customer)
        $.ajax({
            url: '${pageContext.request.contextPath}/support/available-courses', 
            type: 'GET',
            data: { id: id, type: type },
            dataType: 'json',
            success: function(courses) {
                if(courses && courses.length > 0) {
                    courses.forEach(function(course) {
                        let priceFormatted = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(course.price);
                        let optionText = course.courseName + ' (' + priceFormatted + ')';
                        let newOption = new Option(optionText, course.courseId, false, false);
                        $('#courseSelect').append(newOption);
                    });
                    $('#courseSelect').trigger('change');
                }
            },
            error: function() {
                console.log("Đã có lỗi xảy ra khi tải danh sách khóa học!");
            }
        });

        new bootstrap.Modal(document.getElementById('reportModal')).show();
    }

    // --- XỬ LÝ NÚT BẤM LƯU ---
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

    // --- XỬ LÝ LƯU (AJAX SUBMIT) & ALERT ---
    function executeSubmit() {
        const formData = $('#reportForm').serialize(); // Bao gồm luôn mảng 'courseIds' nếu có chọn
        const status = document.getElementById("rpt_Status").value;
        const subject = $("input[name='subject']").val();

        $.post('${pageContext.request.contextPath}/support/activities', formData, function (response) {
            if (response.trim() === "success") {
                const modalElement = document.getElementById('reportModal');
                bootstrap.Modal.getInstance(modalElement).hide();

                let alertTitle = (status === "Pending") ? "Đã vào hàng chờ!" : "Thành công!";
                let alertColor = (status === "Pending") ? "#ffc107" : "#198754";
                let icon = (status === "Pending") ? "bi-clock-history" : "bi-check-circle-fill";
                
                // Hiển thị thông báo cực VIP nếu chốt sale thành công
                let courseCount = $('#courseSelect').val().length;
                let upsaleMsg = (courseCount > 0) ? "<br><b>🎉 Chốt Sale thành công!</b> Khách hàng đã được đăng ký " + courseCount + " khóa và tự động chuyển sang Danh sách Khách hàng." : "";

                let alertMsg = (status === "Pending") 
                    ? "Báo cáo \"" + subject + "\" đã chuyển vào hàng chờ." 
                    : "Báo cáo \"" + subject + "\" đã được lưu." + upsaleMsg;

                const alertHtml = 
                    '<div class="alert alert-dismissible fade show shadow-sm border-0 mb-4" role="alert" ' +
                    'style="border-left: 5px solid ' + alertColor + ' !important; background-color: white;">' +
                    '<i class="bi ' + icon + ' me-2" style="color: ' + alertColor + '"></i>' +
                    '<strong style="color: ' + alertColor + '">' + alertTitle + '</strong> ' + alertMsg +
                    '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>' +
                    '</div>';
                
                $('#liveAlertPlaceholder').html(alertHtml);
                window.scrollTo({top: 0, behavior: 'smooth'});
                
                // Tự động load lại trang sau 2.5s để cập nhật biến mất Lead nếu đã chuyển đổi
                setTimeout(function(){ location.reload(); }, 2500);
            } else {
                alert("Lỗi: " + response);
            }
        }).fail(function () {
            alert("Không thể kết nối với máy chủ.");
        });
    }
</script>