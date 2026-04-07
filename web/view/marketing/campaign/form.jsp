<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h4 class="mb-0 fw-bold">${campaign != null ? 'Chỉnh sửa Chiến dịch' : 'Tạo Chiến dịch mới'}</h4>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a
                                href="${pageContext.request.contextPath}/marketing/dashboard">Marketing</a></li>
                        <li class="breadcrumb-item"><a
                                href="${pageContext.request.contextPath}/marketing/campaign/list">Campaigns</a></li>
                        <li class="breadcrumb-item active" aria-current="page">${campaign != null ? 'Edit' : 'New'}</li>
                    </ol>
                </nav>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-10">
                <form action="${pageContext.request.contextPath}/marketing/campaign/form" method="POST">
                    <input type="hidden" name="campaignId" value="${campaign.campaignId}">

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger mb-4 shadow-sm border-0">${error}</div>
                    </c:if>

                    <div class="card border-0 shadow-sm mb-4">
                        <div class="card-header bg-white py-3">
                            <h6 class="fw-bold mb-0">Thông tin cơ bản</h6>
                        </div>
                        <div class="card-body">
                            <div class="row g-3 mb-3">
                                <div class="col-md-4">
                                    <label class="form-label small fw-bold">Mã chiến dịch <span
                                            class="text-danger">*</span></label>
                                    <input type="text" name="campaignCode" class="form-control"
                                        value="${campaign.campaignCode}" placeholder="VD: CAM-2024-SUMMER" required>
                                </div>
                                <div class="col-md-8">
                                    <label class="form-label small fw-bold">Tên chiến dịch <span
                                            class="text-danger">*</span></label>
                                    <input type="text" name="campaignName" class="form-control"
                                        value="${campaign.campaignName}" required>
                                </div>
                            </div>
                            <div class="row g-3 mb-3">
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold">Loại chiến dịch</label>
                                    <select name="campaignType" class="form-select">
                                        <option value="Email" ${campaign.campaignType=='Email' ? 'selected' : '' }>Email
                                            Marketing</option>
                                        <option value="Social Media" ${campaign.campaignType=='Social Media'
                                            ? 'selected' : '' }>Social Media</option>
                                        <option value="Webinar" ${campaign.campaignType=='Webinar' ? 'selected' : '' }>
                                            Webinar / Event</option>
                                        <option value="Referral" ${campaign.campaignType=='Referral' ? 'selected' : ''
                                            }>Referral</option>
                                        <option value="Banner Ads" ${campaign.campaignType=='Banner Ads' ? 'selected'
                                            : '' }>Banner Ads</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold">Trạng thái</label>
                                    <select name="status" class="form-select">
                                        <option value="Planning" ${campaign.status=='Planning' ? 'selected' : '' }>Lập
                                            kế hoạch (Planning)</option>
                                        <option value="Active" ${campaign.status=='Active' ? 'selected' : '' }>Đang chạy
                                            (Active)</option>
                                        <option value="Completed" ${campaign.status=='Completed' ? 'selected' : '' }>Đã
                                            hoàn thành</option>
                                        <option value="On Hold" ${campaign.status=='On Hold' ? 'selected' : '' }>Tạm
                                            dừng</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row g-4">
                        <div class="col-md-6">
                            <div class="card border-0 shadow-sm h-100">
                                <div class="card-header bg-white py-3">
                                    <h6 class="fw-bold mb-0">Thời gian & Ngân sách</h6>
                                </div>
                                <div class="card-body">
                                    <div class="row g-3 mb-3">
                                        <div class="col-6">
                                            <label class="form-label small fw-bold">Ngày bắt đầu</label>
                                            <input type="date" name="startDate" class="form-control"
                                                value="${campaign.startDate}">
                                        </div>
                                        <div class="col-6">
                                            <label class="form-label small fw-bold">Ngày kết thúc</label>
                                            <input type="date" name="endDate" class="form-control"
                                                value="${campaign.endDate}">
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label small fw-bold">Ngân sách dự kiến (VND)</label>
                                        <div class="input-group">
                                            <input type="number" name="budget" class="form-control"
                                                value="${campaign.budget}">
                                            <span class="input-group-text">₫</span>
                                        </div>
                                    </div>
                                    <div class="mb-0">
                                        <label class="form-label small fw-bold">Mục tiêu số Lead</label>
                                        <input type="number" name="targetLeads" class="form-control"
                                            value="${campaign.targetLeads}">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card border-0 shadow-sm h-100">
                                <div class="card-header bg-white py-3">
                                    <h6 class="fw-bold mb-0">Mô tả dự án</h6>
                                </div>
                                <div class="card-body">
                                    <label class="form-label small fw-bold">Nội dung chi tiết</label>
                                    <textarea name="description" class="form-control"
                                        rows="8">${campaign.description}</textarea>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="mt-4 d-flex justify-content-end gap-2">
                        <a href="${pageContext.request.contextPath}/marketing/campaign/list"
                            class="btn btn-light px-4 py-2">Hủy bỏ</a>
                        <button type="submit" class="btn btn-primary px-4 py-2 fw-bold">Lưu chiến dịch</button>
                    </div>
                </form>
            </div>
        </div>