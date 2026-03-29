<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

                <div class="category-view-container">

                    <!-- ── Breadcrumb / Back Link ── -->
                    <div class="mb-4">
                        <a href="${pageContext.request.contextPath}/admin/category/list"
                            class="text-decoration-none text-muted small fw-medium d-inline-flex align-items-center gap-1">
                            <i class="bi bi-arrow-left"></i> Quay lại danh sách
                        </a>
                    </div>

                    <!-- ── Category Header Card ── -->
                    <div class="card border-0 shadow-lg rounded-4 overflow-hidden mb-4">
                        <div class="card-header border-0 p-4 py-5 text-white"
                            style="background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);">
                            <div class="d-flex align-items-center gap-4">
                                <div class="bg-white bg-opacity-20 p-3 rounded-4 d-flex align-items-center justify-content-center"
                                    style="width: 64px; height: 64px;">
                                    <i class="bi bi-tags fs-2"></i>
                                </div>
                                <div class="flex-grow-1">
                                    <div class="d-flex align-items-center gap-2 mb-1">
                                        <span
                                            class="badge bg-white bg-opacity-25 px-3 py-1 font-monospace">${fn:escapeXml(category.categoryCode)}</span>
                                    </div>
                                    <h3 class="fw-bold mb-1">${fn:escapeXml(category.categoryName)}</h3>
                                    <c:if test="${not empty category.description}">
                                        <p class="mb-0 opacity-75 small">${fn:escapeXml(category.description)}</p>
                                    </c:if>
                                </div>
                                <div class="text-end">
                                    <div class="display-4 fw-bold">${fn:length(courses)}</div>
                                    <small class="opacity-75">Khóa học</small>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- ── Courses Section ── -->
                    <div class="d-flex align-items-center justify-content-between mb-3">
                        <h5 class="fw-bold mb-0">
                            <i class="bi bi-book text-primary me-2"></i>Danh sách Khóa học
                        </h5>
                        <span class="badge bg-primary-subtle text-primary border border-primary px-3 py-2 rounded-pill">
                            Tổng cộng: ${fn:length(courses)} khóa học
                        </span>
                    </div>

                    <c:choose>
                        <c:when test="${empty courses}">
                            <!-- Empty State -->
                            <div class="card border-0 shadow-sm rounded-4">
                                <div class="card-body text-center py-5">
                                    <div class="mb-3">
                                        <i class="bi bi-journal-x text-muted" style="font-size: 3rem;"></i>
                                    </div>
                                    <h5 class="text-muted fw-bold">Chưa có khóa học nào</h5>
                                    <p class="text-muted small mb-0">Danh mục này hiện tại chưa có khóa học nào được
                                        gán.</p>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Course Cards Grid -->
                            <div class="row g-4">
                                <c:forEach items="${courses}" var="course" varStatus="idx">
                                    <div class="col-md-6 col-lg-4">
                                        <div class="card border-0 shadow-sm rounded-4 h-100 course-card">
                                            <!-- Thumbnail -->
                                            <div class="position-relative">
                                                <c:choose>
                                                    <c:when test="${not empty course.thumbnailUrl}">
                                                        <img src="${fn:escapeXml(course.thumbnailUrl)}"
                                                            class="card-img-top rounded-top-4"
                                                            style="height: 180px; object-fit: cover;"
                                                            alt="${fn:escapeXml(course.courseName)}">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="rounded-top-4 d-flex align-items-center justify-content-center"
                                                            style="height: 180px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                                                            <i class="bi bi-mortarboard text-white"
                                                                style="font-size: 3rem; opacity: 0.6;"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                                <!-- Status Badge -->
                                                <span
                                                    class="position-absolute top-0 end-0 m-2 badge rounded-pill px-3 py-2 
                                                    ${course.status == 'Active' ? 'bg-success' : course.status == 'Draft' ? 'bg-warning text-dark' : 'bg-secondary'}">
                                                    ${fn:escapeXml(course.status)}
                                                </span>
                                                <!-- Level Badge -->
                                                <c:if test="${not empty course.level}">
                                                    <span
                                                        class="position-absolute top-0 start-0 m-2 badge rounded-pill bg-dark bg-opacity-75 px-3 py-2">
                                                        ${fn:escapeXml(course.level)}
                                                    </span>
                                                </c:if>
                                            </div>

                                            <div class="card-body p-4">
                                                <!-- Course Code -->
                                                <div class="mb-2">
                                                    <span
                                                        class="badge bg-light text-dark border font-monospace small">${fn:escapeXml(course.courseCode)}</span>
                                                </div>

                                                <!-- Course Name -->
                                                <h6 class="fw-bold mb-2 text-truncate-2"
                                                    title="${fn:escapeXml(course.courseName)}">
                                                    ${fn:escapeXml(course.courseName)}
                                                </h6>

                                                <!-- Short Description -->
                                                <c:if test="${not empty course.shortDescription}">
                                                    <p class="text-muted small mb-3 text-truncate-3">
                                                        ${fn:escapeXml(course.shortDescription)}</p>
                                                </c:if>

                                                <!-- Meta Info -->
                                                <div class="d-flex flex-wrap gap-3 text-muted small mb-3">
                                                    <c:if test="${not empty course.durationHours}">
                                                        <span class="d-flex align-items-center gap-1">
                                                            <i class="bi bi-clock"></i> ${course.durationHours}h
                                                        </span>
                                                    </c:if>
                                                    <c:if test="${not empty course.totalLessons}">
                                                        <span class="d-flex align-items-center gap-1">
                                                            <i class="bi bi-play-circle"></i> ${course.totalLessons}
                                                            bài
                                                        </span>
                                                    </c:if>
                                                    <c:if test="${not empty course.totalEnrolled}">
                                                        <span class="d-flex align-items-center gap-1">
                                                            <i class="bi bi-people"></i> ${course.totalEnrolled} HV
                                                        </span>
                                                    </c:if>
                                                </div>

                                                <!-- Instructor -->
                                                <c:if test="${not empty course.instructorName}">
                                                    <div
                                                        class="d-flex align-items-center gap-2 mb-3 p-2 bg-light rounded-3">
                                                        <div class="bg-primary bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center"
                                                            style="width: 28px; height: 28px;">
                                                            <i class="bi bi-person-fill text-primary small"></i>
                                                        </div>
                                                        <small
                                                            class="fw-medium text-dark">${fn:escapeXml(course.instructorName)}</small>
                                                    </div>
                                                </c:if>

                                                <!-- Rating -->
                                                <c:if test="${not empty course.ratingAvg}">
                                                    <div class="d-flex align-items-center gap-1 mb-3">
                                                        <i class="bi bi-star-fill text-warning small"></i>
                                                        <span class="fw-bold small">
                                                            <fmt:formatNumber value="${course.ratingAvg}" maxFractionDigits="1" />
                                                        </span>
                                                        <c:if test="${not empty course.ratingCount}">
                                                            <span class="text-muted small">(${course.ratingCount}
                                                                đánh giá)</span>
                                                        </c:if>
                                                    </div>
                                                </c:if>
                                            </div>

                                            <!-- Price Footer -->
                                            <div class="card-footer bg-transparent border-top p-4 pt-0">
                                                <div class="d-flex align-items-center justify-content-between">
                                                    <div>
                                                        <c:choose>
                                                            <c:when test="${not empty course.price}">
                                                                <span class="fw-bold text-primary fs-6">
                                                                    <fmt:formatNumber value="${course.price}"
                                                                        type="number" groupingUsed="true" />đ
                                                                </span>
                                                                <c:if
                                                                    test="${not empty course.originalPrice && course.originalPrice > course.price}">
                                                                    <br>
                                                                    <small class="text-muted text-decoration-line-through">
                                                                        <fmt:formatNumber
                                                                            value="${course.originalPrice}" type="number"
                                                                            groupingUsed="true" />đ
                                                                    </small>
                                                                </c:if>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="fw-bold text-success">Miễn phí</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <c:if test="${not empty course.discountPercentage && course.discountPercentage > 0}">
                                                        <span
                                                            class="badge bg-danger-subtle text-danger border border-danger rounded-pill px-2">
                                                            -${course.discountPercentage}%
                                                        </span>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <style>
                    .course-card {
                        transition: transform 0.2s ease, box-shadow 0.2s ease;
                    }

                    .course-card:hover {
                        transform: translateY(-4px);
                        box-shadow: 0 12px 40px rgba(0, 0, 0, 0.12) !important;
                    }

                    .text-truncate-2 {
                        display: -webkit-box;
                        -webkit-line-clamp: 2;
                        -webkit-box-orient: vertical;
                        overflow: hidden;
                    }

                    .text-truncate-3 {
                        display: -webkit-box;
                        -webkit-line-clamp: 3;
                        -webkit-box-orient: vertical;
                        overflow: hidden;
                    }

                    .rounded-top-4 {
                        border-top-left-radius: var(--bs-border-radius-xl) !important;
                        border-top-right-radius: var(--bs-border-radius-xl) !important;
                    }
                </style>
