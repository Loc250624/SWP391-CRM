<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <div class="welcome-card shadow-sm border-0 rounded-4 p-5 bg-white text-center">
        <div class="mb-4">
            <div class="d-inline-flex align-items-center justify-content-center bg-indigo bg-opacity-10 text-indigo rounded-circle mb-3"
                style="width: 80px; height: 80px;">
                <i class="bi bi-shield-check fs-1" style="color: #4f46e5;"></i>
            </div>
            <h2 class="fw-bold">Welcome to Admin Dashboard</h2>
            <p class="text-muted">You have successfully logged in as an Administrator.</p>
        </div>

        <div class="row g-4 mt-2 justify-content-center">
            <div class="col-md-5">
                <div class="card h-100 border-0 shadow-sm rounded-4 overflow-hidden stat-card"
                    style="border-left: 5px solid #4f46e5 !important;">
                    <div class="card-body p-4 text-start">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <div>
                                <small class="text-uppercase text-muted fw-bold"
                                    style="font-size: 11px; letter-spacing: 0.5px;">Quick Access</small>
                                <h4 class="mb-0 fw-bold mt-1">Customers</h4>
                            </div>
                            <div class="bg-indigo bg-opacity-10 p-2 rounded text-indigo">
                                <i class="bi bi-people-fill"></i>
                            </div>
                        </div>
                        <p class="text-muted small">Manage all system users and customers from a central place.</p>
                        <a href="${pageContext.request.contextPath}/admin/customer/list"
                            class="btn btn-sm p-0 fw-bold text-indigo text-decoration-none">
                            Go to Customers <i class="bi bi-arrow-right ms-1"></i>
                        </a>
                    </div>
                </div>
            </div>

            <div class="col-md-5">
                <div class="card h-100 border-0 shadow-sm rounded-4 overflow-hidden stat-card"
                    style="border-left: 5px solid #10b981 !important;">
                    <div class="card-body p-4 text-start">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <div>
                                <small class="text-uppercase text-muted fw-bold"
                                    style="font-size: 11px; letter-spacing: 0.5px;">Course Management</small>
                                <h4 class="mb-0 fw-bold mt-1">Categories</h4>
                            </div>
                            <div class="bg-success bg-opacity-10 p-2 rounded text-success">
                                <i class="bi bi-tags-fill"></i>
                            </div>
                        </div>
                        <p class="text-muted small">Update course categories, sections, and training metadata.</p>
                        <a href="${pageContext.request.contextPath}/admin/category/list"
                            class="btn btn-sm p-0 fw-bold text-success text-decoration-none">
                            Go to Categories <i class="bi bi-arrow-right ms-1"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="mt-5">
            <a href="${pageContext.request.contextPath}/admin/customer/list"
                class="btn btn-lg px-4 py-2 rounded-3 text-white" style="background-color: #4f46e5;">
                Manage Operations
            </a>
        </div>
    </div>

    <style>
        .text-indigo {
            color: #4f46e5 !important;
        }

        .bg-indigo {
            background-color: #4f46e5 !important;
        }

        .stat-card {
            transition: transform 0.2s, shadow 0.2s;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1) !important;
        }
    </style>