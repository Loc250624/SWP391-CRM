<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h4 class="mb-0 fw-bold">${lead != null ? 'Chỉnh sửa Lead' : 'Tạo Lead mới'}</h4>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a
                                href="${pageContext.request.contextPath}/marketing/dashboard">Marketing</a></li>
                        <li class="breadcrumb-item"><a
                                href="${pageContext.request.contextPath}/marketing/lead/list">Leads</a></li>
                        <li class="breadcrumb-item active" aria-current="page">${lead != null ? 'Edit' : 'New'}</li>
                    </ol>
                </nav>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-10">
                <form action="${pageContext.request.contextPath}/marketing/lead/form" method="POST">
                    <input type="hidden" name="leadId" value="${lead.leadId}">

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger mb-4 shadow-sm border-0">${error}</div>
                    </c:if>

                    <div class="row g-4">
                        <!-- Left Column -->
                        <div class="col-md-7">
                            <div class="card border-0 shadow-sm mb-4">
                                <div class="card-header bg-white py-3">
                                    <h6 class="fw-bold mb-0">Thông tin cá nhân</h6>
                                </div>
                                <div class="card-body">
                                    <div class="mb-3">
                                        <label class="form-label small fw-bold">Họ và tên <span
                                                class="text-danger">*</span></label>
                                        <input type="text" name="fullName" class="form-control" value="${lead.fullName}"
                                            required>
                                    </div>
                                    <div class="row g-3 mb-3">
                                        <div class="col-md-6">
                                            <label class="form-label small fw-bold">Email</label>
                                            <input type="email" name="email" class="form-control" value="${lead.email}">
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label small fw-bold">Số điện thoại <span
                                                    class="text-danger">*</span></label>
                                            <input type="text" name="phone" class="form-control" value="${lead.phone}"
                                                required>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="card border-0 shadow-sm">
                                <div class="card-header bg-white py-3">
                                    <h6 class="fw-bold mb-0">Thông tin bổ sung</h6>
                                </div>
                                <div class="card-body">
                                    <div class="row g-3 mb-3">
                                        <div class="col-md-6">
                                            <label class="form-label small fw-bold">Tên công ty</label>
                                            <input type="text" name="companyName" class="form-control"
                                                value="${lead.companyName}">
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label small fw-bold">Chức danh</label>
                                            <input type="text" name="jobTitle" class="form-control"
                                                value="${lead.jobTitle}">
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label small fw-bold">Sở thích / Quan tâm</label>
                                        <input type="text" name="interests" class="form-control"
                                            value="${lead.interests}" placeholder="Ví dụ: Khóa học Marketing, AI...">
                                    </div>
                                    <div class="mb-0">
                                        <label class="form-label small fw-bold">Ghi chú</label>
                                        <textarea name="notes" class="form-control" rows="4">${lead.notes}</textarea>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Right Column -->
                        <div class="col-md-5">
                            <div class="card border-0 shadow-sm mb-4">
                                <div class="card-header bg-white py-3">
                                    <h6 class="fw-bold mb-0">Trạng thái & Nguồn</h6>
                                </div>
                                <div class="card-body">
                                    <div class="mb-3">
                                        <label class="form-label small fw-bold">Trạng thái</label>
                                        <select name="status" class="form-select">
                                            <option value="New" ${lead.status=='New' ? 'selected' : '' }>Mới (New)</option>
                                            <option value="Contacted" ${lead.status=='Contacted' ? 'selected' : '' }>Đã liên hệ (Contacted)</option>
                                            <option value="Qualified" ${lead.status=='Qualified' ? 'selected' : '' }>Đủ điều kiện (Qualified)</option>
                                            <option value="Unqualified" ${lead.status=='Unqualified' ? 'selected' : '' }>Không đủ điều kiện (Unqualified)</option>
                                            <option value="Converted" ${lead.status=='Converted' ? 'selected' : '' }>Đã chuyển đổi (Converted)</option>
                                        </select>
                                    </div>
                                    <div class="row g-3 mb-3">
                                        <div class="col-md-6">
                                            <label class="form-label small fw-bold">Đánh giá (Rating)</label>
                                            <select name="rating" class="form-select">
                                                <option value="">-- Chọn --</option>
                                                <option value="Hot" ${lead.rating=='Hot' ? 'selected' : '' }>Hot 🔥</option>
                                                <option value="Warm" ${lead.rating=='Warm' ? 'selected' : '' }>Warm ⚡</option>
                                                <option value="Cold" ${lead.rating=='Cold' ? 'selected' : '' }>Cold ❄️</option>
                                            </select>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label small fw-bold">Điểm số (Score)</label>
                                            <input type="number" name="leadScore" class="form-control" value="${lead.leadScore != null ? lead.leadScore : 0}">
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label small fw-bold">Nguồn Lead</label>
                                        <select name="sourceId" class="form-select">
                                            <option value="">-- Chọn nguồn --</option>
                                            <c:forEach var="source" items="${sources}">
                                                <option value="${source.sourceId}" ${lead.sourceId==source.sourceId
                                                    ? 'selected' : '' }>${source.sourceName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="mb-0">
                                        <label class="form-label small fw-bold">Gắn với chiến dịch</label>
                                        <select name="campaignId" class="form-select">
                                            <option value="">-- Không có --</option>
                                            <c:forEach var="camp" items="${campaigns}">
                                                <option value="${camp.campaignId}" ${lead.campaignId==camp.campaignId
                                                    ? 'selected' : '' }>${camp.campaignName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="card border-0 shadow-sm bg-light">
                                <div class="card-body">
                                    <p class="small text-muted mb-4"><i class="bi bi-info-circle me-1"></i> Việc điền
                                        đầy đủ thông tin giúp đội ngũ Sale dễ dàng tiếp cận và quản lý khách hàng tiềm
                                        năng hơn.</p>
                                    <div class="d-grid gap-2">
                                        <button type="submit" class="btn btn-primary py-2 fw-bold">
                                            ${lead != null ? 'Cập nhật Lead' : 'Lưu Lead mới'}
                                        </button>
                                        <a href="${pageContext.request.contextPath}/marketing/lead/list"
                                            class="btn btn-light py-2">Hủy bỏ</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>