<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ page contentType="text/html;charset=UTF-8" %>
        <div class="container-fluid p-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h4 class="fw-bold mb-0">Phân quyền (Roles & Permissions)</h4>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mt-2 mb-0">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard"
                                    class="text-decoration-none">Dashboard</a></li>
                            <li class="breadcrumb-item active">Ma trận Phân quyền</li>
                        </ol>
                    </nav>
                </div>
                <div>
                    <span class="badge bg-warning text-dark py-2 px-3 border border-warning shadow-sm">
                        <i class="bi bi-info-circle me-1"></i> Hệ thống đang chạy phân quyền tĩnh (Hardcoded)
                    </span>
                </div>
            </div>

            <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
                <div class="card-header bg-white border-bottom py-3">
                    <h6 class="mb-0 fw-bold"><i class="bi bi-grid-3x3-gap me-2"></i>Ma trận quyền hạn truy cập</h6>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-bordered align-middle mb-0">
                            <thead class="bg-light text-center">
                                <tr>
                                    <th rowspan="2" class="align-middle bg-light" style="min-width: 250px;">Chức năng /
                                        Nghiệp vụ</th>
                                    <th colspan="6" class="bg-indigo text-white py-2">Vai trò (Role)</th>
                                </tr>
                                <tr>
                                    <th class="py-2" style="width: 12%;">Admin</th>
                                    <th class="py-2" style="width: 12%;">Manager</th>
                                    <th class="py-2" style="width: 12%;">Marketing</th>
                                    <th class="py-2" style="width: 12%;">Support</th>
                                    <th class="py-2" style="width: 12%;">Sale</th>
                                </tr>
                            </thead>
                            <tbody class="text-center">
                                <!-- User Management -->
                                <tr class="table-light">
                                    <td class="text-start fw-bold ps-3" colspan="7">QUẢN LÝ TÀI KHOẢN (USER)</td>
                                </tr>
                                <tr>
                                    <td class="text-start ps-4">Xem danh sách User</td>
                                    <td><i class="bi bi-check-circle-fill text-success fs-5"></i></td>
                                    <td><i class="bi bi-check-circle-fill text-success fs-5"></i></td>
                                    <td><i class="bi bi-dash text-muted"></i></td>
                                    <td><i class="bi bi-dash text-muted"></i></td>
                                    <td><i class="bi bi-dash text-muted"></i></td>
                                    <td><i class="bi bi-dash text-muted"></i></td>
                                </tr>
                                <tr>
                                    <td class="text-start ps-4">Tạo User mới / Chỉnh sửa</td>
                                    <td><i class="bi bi-check-circle-fill text-success fs-5"></i></td>
                                    <td><i class="bi bi-dash text-muted"></i></td>
                                    <td><i class="bi bi-dash text-muted"></i></td>
                                    <td><i class="bi bi-dash text-muted"></i></td>
                                    <td><i class="bi bi-dash text-muted"></i></td>
                                    <td><i class="bi bi-dash text-muted"></i></td>
                                </tr>
                                <tr>
                                    <td class="text-start ps-4">Xóa / Vô hiệu hóa User</td>
                                    <td><i class="bi bi-check-circle-fill text-success fs-5"></i></td>
                                    <td><i class="bi bi-dash text-muted"></i></td>
                                    <td><i class="bi bi-dash text-muted"></i></td>
                                    <td><i class="bi bi-dash text-muted"></i></td>
                                    <td><i class="bi bi-dash text-muted"></i></td>
                                    <td><i class="bi bi-dash text-muted"></i></td>
                                </tr>

                                <!-- Role Management -->
                                <tr class="table-light">
                                    <td class="text-start fw-bold ps-3" colspan="7">PHÂN QUYỀN (ROLES)</td>
                                </tr>
                                <tr>
                                    <td class="text-start ps-4">Xem cấu hình Role</td>
                                    <td><i class="bi bi-check-circle-fill text-success fs-5"></i></td>
                                    <td><i class="bi bi-dash text-muted"></i></td>
                                    <td><i class="bi bi-dash text-muted"></i></td>
                                    <td><i class="bi bi-dash text-muted"></i></td>
                                    <td><i class="bi bi-dash text-muted"></i></td>
                                    <td><i class="bi bi-dash text-muted"></i></td>
                                </tr>
                                <tr>
                                    <td class="text-start ps-4">Gán Role cho User</td>
                                    <td><i class="bi bi-check-circle-fill text-success fs-5"></i></td>
                                    <td><i class="bi bi-dash text-muted"></i></td>
                                    <td><i class="bi bi-dash text-muted"></i></td>
                                    <td><i class="bi bi-dash text-muted"></i></td>
                                    <td><i class="bi bi-dash text-muted"></i></td>
                                    <td><i class="bi bi-dash text-muted"></i></td>
                                </tr>

                                <!-- Customer Management -->
                                <tr class="table-light">
                                    <td class="text-start fw-bold ps-3" colspan="7">QUẢN LÝ KHÁCH HÀNG</td>
                                </tr>
                                <tr>
                                    <td class="text-start ps-4">Xem danh sách Khách hàng</td>
                                    <td><i class="bi bi-check-circle-fill text-success fs-5"></i></td>
                                    <td><i class="bi bi-check-circle-fill text-success fs-5"></i></td>
                                    <td><i class="bi bi-check-circle-fill text-success fs-5"></i></td>
                                    <td><i class="bi bi-check-circle-fill text-success fs-5"></i></td>
                                    <td><i class="bi bi-dash text-muted"></i></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="card-footer bg-light p-3">
                    <small class="text-muted italic">
                        * Lưu ý: Theo yêu cầu hệ thống, cấu hình phân quyền hiện tại được quản lý trực tiếp trong mã
                        nguồn (Hardcoded) để đảm bảo tính toàn vẹn và không thay đổi cấu trúc Database.
                    </small>
                </div>
            </div>
        </div>

        <style>
            .bg-indigo {
                background-color: #4f46e5 !important;
            }
        </style>