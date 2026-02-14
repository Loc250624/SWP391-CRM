<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${pageTitle != null ? pageTitle : 'Sales Pipeline'} - CRM Pro</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

        <!-- Custom Page CSS -->
        <c:if test="${not empty customCSS}">
            <style>${customCSS}</style>
        </c:if>
    </head>
    <body class="bg-light">

        <!-- Sidebar -->
        <jsp:include page="sidebar.jsp"/>

        <!-- Header -->
        <jsp:include page="header.jsp"/>

        <!-- Main Content Wrapper -->
        <main style="margin-left: 260px; margin-top: 64px; min-height: calc(100vh - 64px);">
            <!-- Page Content -->
            <div class="p-4">
                <c:choose>
                    <c:when test="${not empty CONTENT_PAGE}">
                        <jsp:include page="${CONTENT_PAGE}" />
                    </c:when>
                    <c:otherwise>
                        <!-- Default Empty State -->
                        <div class="card shadow-sm">
                            <div class="card-body text-center py-5">
                                <div class="mb-3">
                                    <i class="bi bi-file-earmark-text text-muted" style="font-size: 4rem;"></i>
                                </div>
                                <h5 class="text-muted">No Content Page Specified</h5>
                                <p class="text-muted small mb-0">Please set CONTENT_PAGE variable</p>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </main>

        <!-- Toast Container for Notifications -->
        <div class="toast-container position-fixed bottom-0 end-0 p-3" id="toastContainer"></div>

        <!-- Bootstrap JS Bundle -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Global CRM Utilities -->
        <script>
            // CRM Global Object
            window.CRM = {
                // Context Path
                contextPath: '${pageContext.request.contextPath}',

                // Show Toast Notification
                showToast: function (message, type = 'success') {
                    const toastContainer = document.getElementById('toastContainer');
                    const toastId = 'toast-' + Date.now();

                    const iconMap = {
                        success: 'bi-check-circle-fill text-success',
                        error: 'bi-x-circle-fill text-danger',
                        warning: 'bi-exclamation-triangle-fill text-warning',
                        info: 'bi-info-circle-fill text-info'
                    };

                    const toastHTML = `
                        <div id="${toastId}" class="toast align-items-center border-0" role="alert">
                            <div class="d-flex">
                                <div class="toast-body d-flex align-items-center gap-2">
                                    <i class="bi ${iconMap[type] || iconMap.info}"></i>
                                    <span>${message}</span>
                                </div>
                                <button type="button" class="btn-close me-2 m-auto" data-bs-dismiss="toast"></button>
                            </div>
                        </div>
                    `;

                    toastContainer.insertAdjacentHTML('beforeend', toastHTML);
                    const toastElement = document.getElementById(toastId);
                    const toast = new bootstrap.Toast(toastElement, {delay: 4000});
                    toast.show();

                    toastElement.addEventListener('hidden.bs.toast', () => toastElement.remove());
                },

                // Confirm Dialog
                confirm: function (message, callback) {
                    if (confirm(message)) {
                        callback();
                    }
                },

                // Format Currency (VND)
                formatCurrency: function (amount) {
                    return new Intl.NumberFormat('vi-VN', {
                        style: 'currency',
                        currency: 'VND'
                    }).format(amount);
                },

                // Format Number
                formatNumber: function (number) {
                    return new Intl.NumberFormat('vi-VN').format(number);
                },

                // Format Date
                formatDate: function (date, format = 'short') {
                    const options = format === 'long'
                            ? {weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'}
                    : {year: 'numeric', month: '2-digit', day: '2-digit'};
                    return new Intl.DateTimeFormat('vi-VN', options).format(new Date(date));
                },

                // Format DateTime
                formatDateTime: function (date) {
                    return new Intl.DateTimeFormat('vi-VN', {
                        year: 'numeric',
                        month: '2-digit',
                        day: '2-digit',
                        hour: '2-digit',
                        minute: '2-digit'
                    }).format(new Date(date));
                },

                // AJAX Helper
                ajax: function (url, options = {}) {
                    const defaultOptions = {
                        method: 'GET',
                        headers: {
                            'Content-Type': 'application/json',
                            'X-Requested-With': 'XMLHttpRequest'
                        }
                    };

                    return fetch(this.contextPath + url, {...defaultOptions, ...options})
                            .then(response => {
                                if (!response.ok)
                                    throw new Error('Network response was not ok');
                                return response.json();
                            });
                },

                // Initialize Tooltips
                initTooltips: function () {
                    const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
                    tooltipTriggerList.forEach(el => new bootstrap.Tooltip(el));
                },

                // Initialize Popovers
                initPopovers: function () {
                    const popoverTriggerList = document.querySelectorAll('[data-bs-toggle="popover"]');
                    popoverTriggerList.forEach(el => new bootstrap.Popover(el));
                }
            };

            // Auto-init on DOM ready
            document.addEventListener('DOMContentLoaded', function () {
                CRM.initTooltips();
                CRM.initPopovers();
            });
        </script>

        <!-- Additional Custom JS -->
        <c:if test="${not empty customJS}">
            <script>${customJS}</script>
        </c:if>

        <!-- Page Specific JS -->
        <c:if test="${not empty pageScript}">
            <script>${pageScript}</script>
        </c:if>

    </body>
</html>
