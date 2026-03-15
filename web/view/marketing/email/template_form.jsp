<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h4 class="mb-0 fw-bold">${template != null ? 'Chỉnh sửa mẫu Email' : 'Tạo mẫu Email mới'}</h4>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a
                                href="${pageContext.request.contextPath}/marketing/dashboard">Marketing</a></li>
                        <li class="breadcrumb-item"><a
                                href="${pageContext.request.contextPath}/marketing/email/template/list">Email
                                Templates</a></li>
                        <li class="breadcrumb-item active" aria-current="page">${template != null ? 'Edit' : 'New'}</li>
                    </ol>
                </nav>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-8">
                <form action="${pageContext.request.contextPath}/marketing/email/template/form" method="POST">
                    <input type="hidden" name="templateId" value="${template.templateId}">

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger mb-4 shadow-sm border-0 border-start border-danger border-4">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                        </div>
                    </c:if>

                    <div class="card border-0 shadow-sm mb-4">
                        <div class="card-header bg-white py-3">
                            <h6 class="fw-bold mb-0">Thông tin cơ bản</h6>
                        </div>
                        <div class="card-body">
                            <div class="row g-3 mb-3">
                                <div class="col-md-4">
                                    <label class="form-label small fw-bold">Mã mẫu <span
                                            class="text-danger">*</span></label>
                                    <input type="text" name="templateCode" class="form-control"
                                        value="${template.templateCode}" placeholder="VD: WELCOME_EMAIL" required>
                                </div>
                                <div class="col-md-8">
                                    <label class="form-label small fw-bold">Tên mẫu <span
                                            class="text-danger">*</span></label>
                                    <input type="text" name="templateName" class="form-control"
                                        value="${template.templateName}" required>
                                </div>
                            </div>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold">Danh mục</label>
                                    <select name="category" class="form-select">
                                        <option value="Marketing" ${template.category=='Marketing' ? 'selected' : '' }>
                                            Marketing</option>
                                        <option value="Service" ${template.category=='Service' ? 'selected' : '' }>Dịch
                                            vụ khách hàng</option>
                                        <option value="System" ${template.category=='System' ? 'selected' : '' }>Thông
                                            báo hệ thống</option>
                                        <option value="Other" ${template.category=='Other' ? 'selected' : '' }>Khác
                                        </option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold">Mô tả ngắn</label>
                                    <input type="text" name="description" class="form-control"
                                        value="${template.description}">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card border-0 shadow-sm mb-4">
                        <div class="card-header bg-white py-3">
                            <h6 class="fw-bold mb-0">Nội dung Email</h6>
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Tiêu đề Email <span
                                        class="text-danger">*</span></label>
                                <input type="text" name="subject" class="form-control" value="${template.subject}"
                                    placeholder="VD: Chào mừng {{full_name}} đến với chúng tôi" required>
                            </div>

                            <ul class="nav nav-tabs mb-3" id="emailTabs" role="tablist">
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link active small fw-bold" id="html-tab" data-bs-toggle="tab"
                                        data-bs-target="#html-content" type="button" role="tab">Giao diện HTML</button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link small fw-bold" id="text-tab" data-bs-toggle="tab"
                                        data-bs-target="#text-content" type="button" role="tab">Văn bản thuần
                                        túy</button>
                                </li>
                            </ul>

                            <div class="tab-content" id="emailTabsContent">
                                <div class="tab-pane fade show active" id="html-content" role="tabpanel">
                                    <label class="form-label small text-muted">Mẹo: Sử dụng HTML để tạo email chuyên
                                        nghiệp với hình ảnh và định dạng.</label>
                                    <textarea name="bodyHtml" class="form-control font-monospace" rows="12"
                                        placeholder="<html><body>...</body></html>">${template.bodyHtml}</textarea>
                                </div>
                                <div class="tab-pane fade" id="text-content" role="tabpanel">
                                    <label class="form-label small text-muted">Văn bản này sẽ được gửi khi người nhận
                                        không thể xem được HTML.</label>
                                    <textarea name="bodyText" class="form-control"
                                        rows="12">${template.bodyText}</textarea>
                                </div>
                            </div>
                        </div>
                        <div class="card-footer bg-light py-3 border-0">
                            <div class="d-flex gap-4">
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" name="isActive" id="isActive"
                                        ${template==null || template.isActive ? 'checked' : '' }>
                                    <label class="form-check-label small fw-bold" for="isActive">Đang hoạt động</label>
                                </div>
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" name="isDefault" id="isDefault"
                                        ${template.isDefault ? 'checked' : '' }>
                                    <label class="form-check-label small fw-bold" for="isDefault">Mẫu mặc định</label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end gap-2 mb-5">
                        <a href="${pageContext.request.contextPath}/marketing/email/template/list"
                            class="btn btn-light px-4 py-2">Hủy bỏ</a>
                        <button type="submit" class="btn btn-primary px-4 py-2 fw-bold">Lưu mẫu Email</button>
                    </div>
                </form>
            </div>

            <div class="col-lg-4">
                <div class="card border-0 shadow-sm sticky-top" style="top: 1rem;">
                    <div class="card-header bg-white py-3">
                        <h6 class="fw-bold mb-0"><i class="bi bi-info-circle me-2 text-primary"></i>Hướng dẫn Sử dụng
                        </h6>
                    </div>
                    <div class="card-body">
                        <p class="small text-muted mb-4">Bạn có thể sử dụng các "Biến thay thế" để tự động điền thông
                            tin khách hàng vào nội dung email.</p>

                        <div class="table-responsive">
                            <table class="table table-sm table-hover" style="font-size: 13px;">
                                <thead class="table-light">
                                    <tr>
                                        <th>Biến bản ghi</th>
                                        <th>Ý nghĩa</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td><code>{{full_name}}</code></td>
                                        <td>Họ và tên</td>
                                    </tr>
                                    <tr>
                                        <td><code>{{email}}</code></td>
                                        <td>Địa chỉ Email</td>
                                    </tr>
                                    <tr>
                                        <td><code>{{phone}}</code></td>
                                        <td>Số điện thoại</td>
                                    </tr>
                                    <tr>
                                        <td><code>{{company}}</code></td>
                                        <td>Tên công ty</td>
                                    </tr>
                                    <tr>
                                        <td><code>{{campaign}}</code></td>
                                        <td>Tên chiến dịch</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="alert alert-warning small border-0 shadow-sm mt-3 mb-0">
                            <i class="bi bi-lightbulb-fill me-2"></i>
                            Luôn kiểm tra kỹ nội dung và định dạng HTML trước khi gửi để tránh bị đánh dấu là Spam.
                        </div>
                    </div>
                </div>
            </div>
        </div>