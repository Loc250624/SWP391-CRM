<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h4 class="mb-0 fw-bold">Chiến dịch Marketing</h4>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item"><a
                                    href="${pageContext.request.contextPath}/marketing/dashboard">Marketing</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Campaigns</li>
                        </ol>
                    </nav>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/marketing/campaign/form" class="btn btn-primary">
                        <i class="bi bi-plus-circle me-2"></i>Tạo chiến dịch mới
                    </a>
                </div>
            </div>

            <c:if test="${param.msg == 'success'}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                    <i class="bi bi-check-circle me-2"></i>Lưu chiến dịch thành công!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.msg == 'deleted'}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                    <i class="bi bi-check-circle me-2"></i>Đã xóa chiến dịch thành công.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-white py-3">
                    <form action="${pageContext.request.contextPath}/marketing/campaign/list" method="GET"
                        class="row g-3">
                        <div class="col-md-6">
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0">
                                    <i class="bi bi-search text-muted"></i>
                                </span>
                                <input type="text" name="search" class="form-control bg-light border-start-0"
                                    placeholder="Tìm kiếm tên chiến dịch..." value="${search}">
                            </div>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-primary w-100">Tìm kiếm</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="row g-4 mb-4">
                <c:choose>
                    <c:when test="${not empty campaigns}">
                        <c:forEach var="campaign" items="${campaigns}">
                            <div class="col-md-6 col-lg-4">
                                <div class="card h-100 border-0 shadow-sm transition-hover">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-start mb-3">
                                            <span
                                                class="badge ${campaign.status == 'Active' ? 'bg-success' : campaign.status == 'Planning' ? 'bg-primary' : campaign.status == 'Completed' ? 'bg-secondary' : 'bg-warning'} px-2 py-1">
                                                ${campaign.status}
                                            </span>
                                            <div class="dropdown">
                                                <button class="btn btn-light btn-sm" type="button"
                                                    data-bs-toggle="dropdown">
                                                    <i class="bi bi-three-dots"></i>
                                                </button>
                                                <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0">
                                                    <li><a class="dropdown-item py-2"
                                                            href="${pageContext.request.contextPath}/marketing/campaign/form?id=${campaign.campaignId}"><i
                                                                class="bi bi-pencil me-2"></i>Chỉnh sửa</a></li>
                                                    <li><a class="dropdown-item py-2" href="#"><i
                                                                class="bi bi-bar-chart me-2"></i>Báo cáo</a></li>
                                                    <li>
                                                        <hr class="dropdown-divider">
                                                    </li>
                                                    <li><a class="dropdown-item py-2 text-danger"
                                                            href="javascript:CRM.confirm('Bạn có chắc chắn muốn xóa chiến dịch này?', () => { window.location.href='${pageContext.request.contextPath}/marketing/campaign/delete?id=${campaign.campaignId}' })"><i
                                                                class="bi bi-trash me-2"></i>Xóa</a></li>
                                                </ul>
                                            </div>
                                        </div>
                                        <h5 class="fw-bold mb-1">${campaign.campaignName}</h5>
                                        <p class="text-muted small mb-4">${campaign.campaignCode} •
                                            ${campaign.campaignType}</p>

                                        <div class="row g-2 mb-4">
                                            <div class="col-6">
                                                <div class="text-muted small">Ngân sách</div>
                                                <div class="fw-bold">
                                                    <fmt:formatNumber value="${campaign.budget}" type="currency"
                                                        currencySymbol="₫" />
                                                </div>
                                            </div>
                                            <div class="col-6">
                                                <div class="text-muted small">Thực tế</div>
                                                <div class="fw-bold">
                                                    <fmt:formatNumber value="${campaign.actualCost}" type="currency"
                                                        currencySymbol="₫" />
                                                </div>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <div class="d-flex justify-content-between small text-muted mb-1">
                                                <span>Tiến độ ngân sách</span>
                                                <span>
                                                    <c:out
                                                        value="${(campaign.budget != null && campaign.budget > 0) ? (campaign.actualCost / campaign.budget * 100).intValue() : 0}" />
                                                    %
                                                </span>
                                            </div>
                                            <div class="progress" style="height: 6px;">
                                                <div class="progress-bar bg-primary" role="progressbar"
                                                    style="width: <c:out value=" ${(campaign.budget !=null &&
                                                    campaign.budget> 0) ? (campaign.actualCost / campaign.budget *
                                                    100).intValue() : 0}"/>%;"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-footer bg-white border-top py-3">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div class="text-muted small">
                                                <i class="bi bi-calendar3 me-1"></i>
                                                ${campaign.startDate} - ${campaign.endDate}
                                            </div>
                                            <a href="${pageContext.request.contextPath}/marketing/campaign/form?id=${campaign.campaignId}"
                                                class="btn btn-link btn-sm p-0 text-decoration-none fw-semibold">
                                                Quản lý <i class="bi bi-chevron-right small"></i>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="col-12">
                            <div class="card border-0 shadow-sm p-5 text-center">
                                <div class="text-muted mb-3"><i class="bi bi-megaphone" style="font-size: 3rem;"></i>
                                </div>
                                <h5>Chưa có chiến dịch nào được tạo</h5>
                                <p class="text-muted">Bắt đầu thu hút Lead bằng cách tạo chiến dịch marketing đầu tiên
                                    của bạn.</p>
                                <div>
                                    <a href="${pageContext.request.contextPath}/marketing/campaign/form"
                                        class="btn btn-primary px-4">Tạo ngay</a>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <nav class="d-flex justify-content-center">
                    <ul class="pagination pagination-sm">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${currentPage - 1}&search=${search}">Trình trước</a>
                        </li>
                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="?page=${i}&search=${search}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${currentPage + 1}&search=${search}">Trình sau</a>
                        </li>
                    </ul>
                </nav>
            </c:if>

            <style>
                .transition-hover {
                    transition: transform 0.2s, box-shadow 0.2s;
                }

                .transition-hover:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1) !important;
                }
            </style>