<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <div class="row g-4 mb-4">
            <!-- Stat Cards -->
            <div class="col-md-3">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between mb-3">
                            <div class="p-2 bg-primary-subtle rounded text-primary">
                                <i class="bi bi-people fs-4"></i>
                            </div>
                            <span class="text-success small fw-bold">+12% <i class="bi bi-graph-up"></i></span>
                        </div>
                        <h3 class="fw-bold mb-0">${totalLeads}</h3>
                        <p class="text-muted small mb-0">Tổng số Leads</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between mb-3">
                            <div class="p-2 bg-success-subtle rounded text-success">
                                <i class="bi bi-megaphone fs-4"></i>
                            </div>
                        </div>
                        <h3 class="fw-bold mb-0">${totalActiveCampaigns}</h3>
                        <p class="text-muted small mb-0">Chiến dịch đang chạy</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between mb-3">
                            <div class="p-2 bg-info-subtle rounded text-info">
                                <i class="bi bi-envelope fs-4"></i>
                            </div>
                        </div>
                        <h3 class="fw-bold mb-0">1,240</h3>
                        <p class="text-muted small mb-0">Email đã gửi (Tháng này)</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between mb-3">
                            <div class="p-2 bg-warning-subtle rounded text-warning">
                                <i class="bi bi-cursor fs-4"></i>
                            </div>
                        </div>
                        <h3 class="fw-bold mb-0">45</h3>
                        <p class="text-muted small mb-0">Tỉ lệ Click-through (CTR)</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm mb-4" style="height: 400px;">
                    <div class="card-header bg-white py-3">
                        <h6 class="fw-bold mb-0">Biểu đồ tăng trưởng Lead theo thời gian</h6>
                    </div>
                    <div class="card-body d-flex align-items-center justify-content-center">
                        <div class="text-center text-muted">
                            <i class="bi bi-bar-chart-line fs-1 mb-2"></i>
                            <p>Biểu đồ thống kê sẽ hiển thị tại đây</p>
                        </div>
                    </div>
                </div>

                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                        <h6 class="fw-bold mb-0">Chiến dịch gần đây</h6>
                        <a href="${pageContext.request.contextPath}/marketing/campaign/list"
                            class="btn btn-sm btn-link text-decoration-none">Tất cả</a>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="bg-light small">
                                    <tr>
                                        <th class="ps-4">Tên chiến dịch</th>
                                        <th>Loại</th>
                                        <th>Ngân sách</th>
                                        <th>Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="ps-4 fw-medium">Summer Promo 2024</td>
                                        <td>Email Marketing</td>
                                        <td>50,000,000₫</td>
                                        <td><span class="badge bg-success-subtle text-success">Active</span></td>
                                    </tr>
                                    <tr>
                                        <td class="ps-4 fw-medium">New Product Webinar</td>
                                        <td>Event</td>
                                        <td>20,000,000₫</td>
                                        <td><span class="badge bg-primary-subtle text-primary">Planning</span></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-header bg-white py-3">
                        <h6 class="fw-bold mb-0">Nguồn Lead phổ biến</h6>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <div class="d-flex justify-content-between small mb-1">
                                <span>Facebook Ads</span>
                                <span>45%</span>
                            </div>
                            <div class="progress" style="height: 8px;">
                                <div class="progress-bar bg-primary" style="width: 45%;"></div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="d-flex justify-content-between small mb-1">
                                <span>Google Search</span>
                                <span>30%</span>
                            </div>
                            <div class="progress" style="height: 8px;">
                                <div class="progress-bar bg-success" style="width: 30%;"></div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="d-flex justify-content-between small mb-1">
                                <span>Website Referral</span>
                                <span>15%</span>
                            </div>
                            <div class="progress" style="height: 8px;">
                                <div class="progress-bar bg-info" style="width: 15%;"></div>
                            </div>
                        </div>
                        <div>
                            <div class="d-flex justify-content-between small mb-1">
                                <span>Khác</span>
                                <span>10%</span>
                            </div>
                            <div class="progress" style="height: 8px;">
                                <div class="progress-bar bg-secondary" style="width: 10%;"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card border-0 shadow-sm bg-primary text-white">
                    <div class="card-body">
                        <h6 class="fw-bold mb-3">Mẹo Marketing</h6>
                        <p class="small mb-3">Tối ưu hóa các mẫu Email có tỉ lệ chuyển đổi thấp để tăng hiệu quả chiến
                            dịch của bạn.</p>
                        <button class="btn btn-light btn-sm w-100 fw-bold">Xem hướng dẫn</button>
                    </div>
                </div>
            </div>
        </div>