<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">${not empty activity ? 'Chinh sua Hoat dong' : 'Ghi nhan Hoat dong'}</h4>
        <p class="text-muted mb-0">Ghi nhan cuoc goi, email, cuoc hop hoac ghi chu</p>
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
                <div class="card-header bg-transparent border-0"><h6 class="mb-0 fw-semibold"><i class="bi bi-activity me-2"></i>Thong tin hoat dong</h6></div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Loai hoat dong <span class="text-danger">*</span></label>
                            <select class="form-select" name="activityType" required id="activityTypeSelect">
                                <option value="" disabled ${empty activity ? 'selected' : ''}>Chon loai...</option>
                                <option value="Call" ${activity.activityType == 'Call' ? 'selected' : ''}>Cuoc goi</option>
                                <option value="Email" ${activity.activityType == 'Email' ? 'selected' : ''}>Email</option>
                                <option value="Meeting" ${activity.activityType == 'Meeting' ? 'selected' : ''}>Cuoc hop</option>
                                <option value="Note" ${activity.activityType == 'Note' ? 'selected' : ''}>Ghi chu</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Doi tuong</label>
                            <select class="form-select" name="relatedType" id="relatedTypeSelect">
                                <option value="" ${empty activity.relatedType ? 'selected' : ''}>Khong</option>
                                <option value="Opportunity" ${activity.relatedType == 'Opportunity' ? 'selected' : ''}>Opportunity</option>
                                <option value="Lead" ${activity.relatedType == 'Lead' ? 'selected' : ''}>Lead</option>
                                <option value="Customer" ${activity.relatedType == 'Customer' ? 'selected' : ''}>Customer</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Chon</label>
                            <select class="form-select" name="relatedId" id="relatedIdSelect">
                                <option value="">-- Chon --</option>
                            </select>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label">Tieu de <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="subject" placeholder="VD: Goi tu van khoa hoc..." value="${activity.subject}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Ngay gio <span class="text-danger">*</span></label>
                            <input type="datetime-local" class="form-control" name="activityDate"
                                   value="${not empty activity.activityDate ? activity.activityDate.toString().substring(0, 16) : ''}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Thoi luong (phut)</label>
                            <input type="number" class="form-control" name="durationMinutes" placeholder="30" value="${activity.durationMinutes}">
                        </div>
                        <div class="col-md-6" id="callDirectionGroup" style="display:none;">
                            <label class="form-label">Huong cuoc goi</label>
                            <select class="form-select" name="callDirection">
                                <option value="">-- Chon --</option>
                                <option value="Outbound" ${activity.callDirection == 'Outbound' ? 'selected' : ''}>Goi di (Outbound)</option>
                                <option value="Inbound" ${activity.callDirection == 'Inbound' ? 'selected' : ''}>Goi den (Inbound)</option>
                            </select>
                        </div>
                        <div class="col-md-6" id="callResultGroup" style="display:none;">
                            <label class="form-label">Ket qua</label>
                            <select class="form-select" name="callResult">
                                <option value="" ${empty activity.callResult ? 'selected' : ''}>Chon ket qua...</option>
                                <option value="Success" ${activity.callResult == 'Success' ? 'selected' : ''}>Thanh cong</option>
                                <option value="NoAnswer" ${activity.callResult == 'NoAnswer' ? 'selected' : ''}>Khong tra loi</option>
                                <option value="Busy" ${activity.callResult == 'Busy' ? 'selected' : ''}>Ban</option>
                                <option value="Callback" ${activity.callResult == 'Callback' ? 'selected' : ''}>Hen lai</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Mo ta chi tiet</label>
                            <textarea class="form-control" name="description" rows="4" placeholder="Noi dung chi tiet cuoc goi / email / cuoc hop...">${activity.description}</textarea>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="card border-0 shadow-sm"><div class="card-body">
                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-primary"><i class="bi bi-save me-1"></i>Luu hoat dong</button>
                    <a href="${pageContext.request.contextPath}/sale/activity/list" class="btn btn-outline-secondary">Huy</a>
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
            relIdSelect.innerHTML = '<option value="">-- Chon --</option>';
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
