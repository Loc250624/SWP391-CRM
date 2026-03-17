<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    .status-badge { padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
    .status-active { background-color: #d1fae5; color: #065f46; }
    .status-inactive { background-color: #f1f5f9; color: #475569; }
    .modal-label { font-weight: 600; color: #64748b; font-size: 13px; margin-bottom: 2px; text-transform: uppercase; }
    .modal-value { color: #1e293b; font-weight: 500; margin-bottom: 15px; border-bottom: 1px solid #f1f5f9; padding-bottom: 5px; }
    .form-input-custom { border: none; border-bottom: 2px solid #e2e8f0; border-radius: 0; padding: 8px 0; background: transparent; transition: all 0.3s; }
    .form-input-custom:focus { box-shadow: none; border-bottom-color: #3b82f6; outline: none; }
    .table-hover tbody tr:hover { background-color: #f8fafc; cursor: pointer; }
    
    /* CSS cho Select2 */
    .select2-container--bootstrap-5 .select2-selection { border: 1px solid #dee2e6; border-radius: 0.375rem; padding: 0.375rem 0.75rem; }
    .select2-container--bootstrap-5 .select2-selection--multiple .select2-selection__choice { background-color: #e0f2fe; color: #1e40af; border: 1px solid #bae6fd; font-size: 13px; margin-top: 4px;}
</style>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" />

<div class="d-flex justify-content-between align-items-center mb-4">
    <h5 class="fw-bold text-dark m-0"><i class="bi bi-people-fill me-2 text-primary"></i>Danh sách khách hàng</h5>
    <div class="d-flex gap-2">
        <button id="btnExpiringFilter" class="btn btn-outline-warning fw-bold shadow-sm text-nowrap" onclick="toggleExpiringFilter()">
            <i class="bi bi-hourglass-bottom me-1"></i> Sắp hết hạn
        </button>
        <div class="input-group" style="max-width: 350px;">
            <span class="input-group-text bg-white border-end-0"><i class="bi bi-search text-muted"></i></span>
            <input type="text" class="form-control border-start-0 shadow-none" id="searchPhone" placeholder="Tìm theo số điện thoại hoặc tên..." onkeyup="applyFilters()">
        </div>
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
                    <th class="border-0">Khóa học</th>
                    <th class="text-center border-0" id="thDetail">Chi tiết</th>
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
                            <span class="status-badge ${c.status == 'Active' || c.status == 'active' ? 'status-active' : 'status-inactive'}">
                                ${c.status}
                            </span>
                        </td>
                        
                        <td style="min-width: 280px; vertical-align: top;" class="py-3">
                            <div class="course-column-wrapper">
                                <c:choose>
                                    <c:when test="${c.status eq 'Active' || c.status eq 'active'}">
                                        <c:choose>
                                            <c:when test="${not empty c.purchasedCourses}">
                                                ${c.purchasedCourses}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted fst-italic small">Chưa đăng ký</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted opacity-50 pe-4">-</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </td>

                        <td class="text-center detail-btn-cell">
                            <button class="btn btn-sm btn-light border shadow-sm" 
                                    onclick="showDetail('${c.customerCode}', '${c.fullName}', '${c.email}', '${c.phone}', '${c.gender}', '${c.address}', '${c.city}', '${c.customerSegment}', '${c.totalSpent}', '${c.status}', '${c.notes}')">
                                <i class="bi bi-eye-fill text-primary"></i>
                            </button>
                        </td>
                        
                        <td class="text-center action-cell" style="vertical-align: middle;">
                            <div class="btn-group normal-actions">
                                <button type="button" class="btn btn-sm btn-outline-success d-flex align-items-center gap-1" 
                                        onclick="openReportModal('${c.customerId}', '${c.customerCode}', '${c.fullName}', 'Customer')">
                                    <i class="bi bi-plus-circle"></i> <span>Tạo phiếu</span>
                                </button>
                                <a href="${pageContext.request.contextPath}/support/activities?id=${c.customerId}&type=Customer" 
                                   class="btn btn-sm btn-outline-info d-flex align-items-center gap-1">
                                    <i class="bi bi-clock-history"></i> <span>Lịch sử</span>
                                </a>
                            </div>
                            
                            <div class="expiring-actions" style="display: none;">
                                <button type="button" class="btn btn-sm btn-warning text-dark fw-bold shadow-sm rounded-pill px-4" 
                                        onclick="openReportModal('${c.customerId}', '${c.customerCode}', '${c.fullName}', 'Customer')">
                                    <i class="bi bi-headset me-1"></i> Hỗ trợ
                                </button>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<%-- ĐÃ KHÔI PHỤC LẠI DETAIL MODAL --%>
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

<%-- Report Modal --%>
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
                            <label class="modal-label text-primary"><i class="bi bi-cart-plus me-1"></i>Đăng ký khóa học (Upsale)</label>
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
    let showOnlyExpiring = false;

    $(document).ready(function() {
        $('#courseSelect').select2({
            theme: 'bootstrap-5',
            placeholder: "🔍 Tìm và chọn khóa học khách muốn mua...",
            allowClear: true,
            dropdownParent: $('#reportModal') 
        });
    });

    function toggleExpiringFilter() {
        showOnlyExpiring = !showOnlyExpiring;
        let btn = document.getElementById('btnExpiringFilter');
        
        if (showOnlyExpiring) {
            btn.classList.remove('btn-outline-warning');
            btn.classList.add('btn-warning');
        } else {
            btn.classList.remove('btn-warning');
            btn.classList.add('btn-outline-warning');
        }
        applyFilters();
    }

    function applyFilters() {
        let input = document.getElementById("searchPhone").value.toLowerCase();
        let rows = document.querySelectorAll("#customerTable tbody tr");
        
        let now = new Date().getTime();
        let threeDaysInMs = 3 * 24 * 60 * 60 * 1000; 
        
        // ẨN/HIỆN TIÊU ĐỀ CỘT CHI TIẾT
        let thDetail = document.getElementById("thDetail");

        if (showOnlyExpiring) {
            if(thDetail) thDetail.style.display = 'none'; // Ẩn chữ Chi tiết
        } else {
            if(thDetail) thDetail.style.display = ''; // Hiện lại
        }

        rows.forEach(row => {
            let phone = row.querySelector(".phone-cell").textContent.toLowerCase();
            let name = row.querySelector(".fw-bold").textContent.toLowerCase();
            let matchText = phone.includes(input) || name.includes(input);

            let matchExpiring = true; 
            if (showOnlyExpiring) {
                matchExpiring = false; 
                let timers = row.querySelectorAll('.timer');
                timers.forEach(timer => {
                    let endTimeStr = timer.getAttribute('data-endtime');
                    if (endTimeStr) {
                        let endTime = new Date(endTimeStr.replace(' ', 'T')).getTime();
                        let distance = endTime - now;
                        if (distance > 0 && distance <= threeDaysInMs) {
                            matchExpiring = true;
                        }
                    }
                });
            }

            if (matchText && matchExpiring) {
                row.style.display = "";
                if (showOnlyExpiring) {
                    row.querySelector('.normal-actions').style.display = 'none';
                    row.querySelector('.expiring-actions').style.display = 'block';
                    row.querySelector('.detail-btn-cell').style.display = 'none'; // Ẩn nút con mắt
                } else {
                    row.querySelector('.normal-actions').style.display = 'flex';
                    row.querySelector('.expiring-actions').style.display = 'none';
                    row.querySelector('.detail-btn-cell').style.display = ''; // Hiện lại nút con mắt
                }
            } else {
                row.style.display = "none";
            }
        });
    }

    // ĐÃ KHÔI PHỤC LẠI HÀM XEM CHI TIẾT
    function showDetail(code, name, email, phone, gender, addr, city, segment, spent, status, notes) {
        document.getElementById("mCode").innerText = code;
        document.getElementById("mName").innerText = name;
        document.getElementById("mEmail").innerText = email;
        document.getElementById("mPhone").innerText = phone;
        document.getElementById("mGender").innerText = gender;
        document.getElementById("mSegment").innerText = segment;
        
        let formattedSpent = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(spent);
        document.getElementById("mSpent").innerText = formattedSpent;
        document.getElementById("mStatus").innerText = status;
        document.getElementById("mNotes").innerText = notes && notes !== 'null' ? notes : "Không có ghi chú";
        
        new bootstrap.Modal(document.getElementById('detailModal')).show();
    }

    function openReportModal(id, code, name, type) {
        document.getElementById("rpt_Id").value = id;
        document.getElementById("rpt_Type").value = type;
        document.getElementById("rpt_Code").innerText = code;
        document.getElementById("rpt_Name").innerText = name;
        document.getElementById("reportForm").reset();
        
        $('#courseSelect').empty().trigger("change");

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
                        $('#courseSelect').append(new Option(optionText, course.courseId, false, false));
                    });
                    $('#courseSelect').trigger('change');
                }
            },
            error: function(xhr, status, error) {
                alert("⚠️ Hệ thống không tải được khóa học!\nMã trạng thái: " + xhr.status + "\nLỗi: " + error);
                console.log("Chi tiết lỗi:", xhr.responseText);
            }
        });

        new bootstrap.Modal(document.getElementById('reportModal')).show();
    }

    function submitReport() {
        const subject = $("input[name='subject']").val();
        if (!subject) { alert("Vui lòng nhập tiêu đề!"); return; }
        document.getElementById("rpt_Status").value = "Completed";
        executeSubmit();
    }

    function addToQueue() {
        const subject = $("input[name='subject']").val();
        if (!subject) { alert("Vui lòng nhập tiêu đề!"); return; }
        
        let courseCount = $('#courseSelect').val().length;
        if (courseCount > 0) {
            alert("⚠️ LỖI LOGIC: Khách đã chốt khóa học thì bạn phải bấm [Lưu báo cáo] để hoàn tất.\n\nNút [Thêm vào hàng chờ] chỉ dành cho khách chưa mua và cần gọi lại sau!");
            return; 
        }

        document.getElementById("rpt_Status").value = "Pending";
        executeSubmit();
    }

    function executeSubmit() {
        const formData = $('#reportForm').serialize(); 
        const status = document.getElementById("rpt_Status").value;
        const subject = $("input[name='subject']").val();

        $.post('${pageContext.request.contextPath}/support/activities', formData, function (response) {
            if (response.trim() === "success") {
                const modalElement = document.getElementById('reportModal');
                bootstrap.Modal.getInstance(modalElement).hide();

                let alertTitle = (status === "Pending") ? "Đã vào hàng chờ!" : "Thành công!";
                let alertColor = (status === "Pending") ? "#ffc107" : "#198754";
                let icon = (status === "Pending") ? "bi-clock-history" : "bi-check-circle-fill";
                
                let courseCount = $('#courseSelect').val().length;
                let upsaleMsg = (courseCount > 0) ? " và đăng ký " + courseCount + " khóa học mới" : "";
                
                let alertMsg = (status === "Pending")
                        ? "Báo cáo \"" + subject + "\" đã chuyển vào hàng chờ."
                        : "Báo cáo \"" + subject + "\"" + upsaleMsg + " đã được lưu vào lịch sử.";

                const alertHtml =
                        '<div class="alert alert-dismissible fade show shadow-sm border-0 mb-4" role="alert" ' +
                        'style="border-left: 5px solid ' + alertColor + ' !important; background-color: white;">' +
                        '<i class="bi ' + icon + ' me-2" style="color: ' + alertColor + '"></i>' +
                        '<strong style="color: ' + alertColor + '">' + alertTitle + '</strong> ' + alertMsg +
                        '<button type="button" class="btn-close" data-bs-alert="alert"></button>' +
                        '</div>';

                $('#liveAlertPlaceholder').html(alertHtml);
                window.scrollTo({top: 0, behavior: 'smooth'});
                
                setTimeout(function(){ location.reload(); }, 2000);
            } else {
                alert("Lỗi: " + response);
            }
        }).fail(function () {
            alert("Không thể kết nối với máy chủ.");
        });
    }

    function startCourseTimers() {
        const timers = document.querySelectorAll('.timer');
        timers.forEach(function (el) {
            let endTimeStr = el.getAttribute('data-endtime');
            if (!endTimeStr) return;

            let endTime = new Date(endTimeStr.replace(' ', 'T')).getTime();
            let interval = setInterval(function () {
                let now = new Date().getTime();
                let distance = endTime - now;

                if (distance <= 0) {
                    clearInterval(interval);
                    el.className = "badge bg-danger text-white ms-1 shadow-sm";
                    el.innerHTML = '<i class="bi bi-exclamation-triangle-fill"></i> Đã hết hạn';
                    return;
                }

                let days = Math.floor(distance / (1000 * 60 * 60 * 24));
                let hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                let minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                let seconds = Math.floor((distance % (1000 * 60)) / 1000);

                if (days > 0) {
                    el.innerHTML = '<i class="bi bi-clock-history"></i> Còn ' + days + ' ngày ' + hours + ' giờ';
                } else {
                    el.className = "badge bg-danger text-white ms-1 shadow-sm";
                    el.innerHTML = '<i class="bi bi-alarm-fill"></i> ' + hours + 'g ' + minutes + 'p ' + seconds + 's';
                }
            }, 1000);
        });
    }

    document.addEventListener("DOMContentLoaded", function () {
        startCourseTimers();
    });
</script>