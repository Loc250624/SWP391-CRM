<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">${not empty activity ? 'Chỉnh sửa hoạt động' : 'Ghi nhận hoạt động'}</h4>
        <p class="text-muted mb-0">Ghi nhận cuộc gọi, email, cuộc họp hoặc ghi chú</p>
    </div>
</div>

<c:if test="${not empty error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        ${error}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<form method="POST" action="${pageContext.request.contextPath}/sale/activity/form">
    <c:if test="${not empty activity}">
        <input type="hidden" name="activityId" value="${activity.activityId}">
    </c:if>
    <div class="row g-4">
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold"><i class="bi bi-activity me-2"></i>Thông tin hoạt động</h6></div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Loại hoạt động <span class="text-danger">*</span></label>
                            <select class="form-select" name="activityType" required id="activityTypeSelect">
                                <option value="" disabled ${empty activity ? 'selected' : ''}>Chọn loại...</option>
                                <option value="Call" ${activity.activityType == 'Call' ? 'selected' : ''}>Cuộc gọi</option>
                                <option value="Email" ${activity.activityType == 'Email' ? 'selected' : ''}>Email</option>
                                <option value="Meeting" ${activity.activityType == 'Meeting' ? 'selected' : ''}>Cuộc họp</option>
                                <option value="Note" ${activity.activityType == 'Note' ? 'selected' : ''}>Ghi chú</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Trạng thái</label>
                            <select class="form-select" name="status">
                                <option value="Completed" ${activity.status == 'Completed' || empty activity.status ? 'selected' : ''}>Hoàn thành</option>
                                <option value="Pending" ${activity.status == 'Pending' ? 'selected' : ''}>Đang chờ</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Đối tượng</label>
                            <select class="form-select" name="relatedType" id="relatedTypeSelect">
                                <option value="" ${empty activity.relatedType ? 'selected' : ''}>Không</option>
                                <option value="Opportunity" ${activity.relatedType == 'Opportunity' ? 'selected' : ''}>Opportunity</option>
                                <option value="Lead" ${activity.relatedType == 'Lead' ? 'selected' : ''}>Lead</option>
                                <option value="Customer" ${activity.relatedType == 'Customer' ? 'selected' : ''}>Customer</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Chọn</label>
                            <select class="form-select" name="relatedId" id="relatedIdSelect">
                                <option value="">-- Chọn --</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Tiêu đề <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="subject" placeholder="VD: Gọi tư vấn khóa học..." value="${activity.subject}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Ngày giờ <span class="text-danger">*</span></label>
                            <input type="datetime-local" class="form-control" name="activityDate"
                                   value="${not empty activity.activityDate ? activity.activityDate.toString().substring(0, 16) : ''}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Thời lượng (phút)</label>
                            <input type="number" class="form-control" name="durationMinutes" placeholder="30" value="${activity.durationMinutes}">
                        </div>
                        <div class="col-md-6" id="callDirectionGroup" style="display:none;">
                            <label class="form-label">Hướng cuộc gọi</label>
                            <select class="form-select" name="callDirection">
                                <option value="">-- Chọn --</option>
                                <option value="Outbound" ${activity.callDirection == 'Outbound' ? 'selected' : ''}>Gọi đi (Outbound)</option>
                                <option value="Inbound" ${activity.callDirection == 'Inbound' ? 'selected' : ''}>Gọi đến (Inbound)</option>
                            </select>
                        </div>
                        <div class="col-md-6" id="callResultGroup" style="display:none;">
                            <label class="form-label">Kết quả</label>
                            <select class="form-select" name="callResult">
                                <option value="" ${empty activity.callResult ? 'selected' : ''}>Chọn kết quả...</option>
                                <option value="Success" ${activity.callResult == 'Success' ? 'selected' : ''}>Thành công</option>
                                <option value="NoAnswer" ${activity.callResult == 'NoAnswer' ? 'selected' : ''}>Không trả lời</option>
                                <option value="Busy" ${activity.callResult == 'Busy' ? 'selected' : ''}>Bận</option>
                                <option value="Callback" ${activity.callResult == 'Callback' ? 'selected' : ''}>Hẹn lại</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Mô tả chi tiết</label>
                            <textarea class="form-control" name="description" rows="4" placeholder="Nội dung chi tiết cuộc gọi / email / cuộc họp...">${activity.description}</textarea>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="card border-0 shadow-sm"><div class="card-body">
                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-primary"><i class="bi bi-save me-1"></i>Lưu hoạt động</button>
                    <a href="${pageContext.request.contextPath}/sale/activity/list" class="btn btn-outline-secondary">Hủy</a>
                </div>
            </div></div>
        </div>
    </div>
</form>

<!-- Data for related entity dropdowns -->
<script>
    var oppData = [
        <c:forEach var="opp" items="${opportunities}" varStatus="s">
        {id: ${opp.opportunityId}, name: '${opp.opportunityCode} - ${opp.opportunityName}'}${!s.last ? ',' : ''}
        </c:forEach>
    ];
    var leadData = [
        <c:forEach var="ld" items="${leads}" varStatus="s">
        {id: ${ld.leadId}, name: '${ld.fullName}'}${!s.last ? ',' : ''}
        </c:forEach>
    ];
    var custData = [
        <c:forEach var="ct" items="${customers}" varStatus="s">
        {id: ${ct.customerId}, name: '${ct.fullName}'}${!s.last ? ',' : ''}
        </c:forEach>
    ];

    var editRelatedType = '${activity.relatedType}';
    var editRelatedId = '${activity.relatedId}';

    document.addEventListener('DOMContentLoaded', function() {
        var typeSelect = document.getElementById('activityTypeSelect');
        var relTypeSelect = document.getElementById('relatedTypeSelect');
        var relIdSelect = document.getElementById('relatedIdSelect');
        var callDirGroup = document.getElementById('callDirectionGroup');
        var callResGroup = document.getElementById('callResultGroup');

        function toggleCallFields() {
            var isCall = typeSelect.value === 'Call';
            callDirGroup.style.display = isCall ? '' : 'none';
            callResGroup.style.display = isCall ? '' : 'none';
        }
        typeSelect.addEventListener('change', toggleCallFields);
        toggleCallFields();

        function populateRelated() {
            var type = relTypeSelect.value;
            var data = type === 'Opportunity' ? oppData : type === 'Lead' ? leadData : type === 'Customer' ? custData : [];
            relIdSelect.innerHTML = '<option value="">-- Chọn --</option>';
            data.forEach(function(item) {
                var opt = document.createElement('option');
                opt.value = item.id;
                opt.textContent = item.name;
                if (editRelatedId && item.id == editRelatedId && type === editRelatedType) opt.selected = true;
                relIdSelect.appendChild(opt);
            });
        }
        relTypeSelect.addEventListener('change', populateRelated);
        if (editRelatedType) populateRelated();
    });
</script>
