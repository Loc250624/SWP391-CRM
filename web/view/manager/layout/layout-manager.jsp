<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${pageTitle != null ? pageTitle : 'Manager Tasks'} - CRM Pro</title>

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

        <!-- Manager Sidebar -->
        <jsp:include page="/view/manager/layout/sidebar-manager.jsp"/>

        <!-- Manager Header -->
        <jsp:include page="/view/manager/layout/header-manager.jsp"/>

        <!-- Main Content Wrapper -->
        <main style="margin-left: 260px; margin-top: 64px; min-height: calc(100vh - 64px);">
            <div class="p-4">
                <c:choose>
                    <c:when test="${not empty CONTENT_PAGE}">
                        <jsp:include page="${CONTENT_PAGE}" />
                    </c:when>
                    <c:otherwise>
                        <div class="card shadow-sm">
                            <div class="card-body text-center py-5">
                                <i class="bi bi-file-earmark-text text-muted" style="font-size: 4rem;"></i>
                                <h5 class="text-muted mt-3">No Content Page Specified</h5>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>

        <!-- Toast Container -->
        <div class="toast-container position-fixed bottom-0 end-0 p-3" id="toastContainer"></div>

        <!-- Bootstrap JS Bundle -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Global CRM Utilities -->
        <script>
            window.CRM = {
                contextPath: '${pageContext.request.contextPath}',

                showToast: function(message, type) {
                    type = type || 'success';
                    var toastContainer = document.getElementById('toastContainer');
                    var toastId = 'toast-' + Date.now();
                    var iconMap = {
                        success: 'bi-check-circle-fill text-success',
                        error:   'bi-x-circle-fill text-danger',
                        warning: 'bi-exclamation-triangle-fill text-warning',
                        info:    'bi-info-circle-fill text-info'
                    };
                    var icon = iconMap[type] || iconMap.info;
                    var html = '<div id="' + toastId + '" class="toast align-items-center border-0" role="alert">'
                        + '<div class="d-flex"><div class="toast-body d-flex align-items-center gap-2">'
                        + '<i class="bi ' + icon + '"></i><span>' + message + '</span>'
                        + '</div><button type="button" class="btn-close me-2 m-auto" data-bs-dismiss="toast"></button>'
                        + '</div></div>';
                    toastContainer.insertAdjacentHTML('beforeend', html);
                    var el = document.getElementById(toastId);
                    new bootstrap.Toast(el, {delay: 3000}).show();
                    el.addEventListener('hidden.bs.toast', function() { el.remove(); });
                },

                confirm: function(message, callback) {
                    if (confirm(message)) callback();
                },

                formatCurrency: function(amount) {
                    return new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(amount);
                },

                initTooltips: function() {
                    document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(function(el) {
                        new bootstrap.Tooltip(el);
                    });
                }
            };

            document.addEventListener('DOMContentLoaded', function() { CRM.initTooltips(); });
        </script>

        <c:if test="${not empty customJS}">
            <script>${customJS}</script>
        </c:if>

        <c:if test="${not empty pageScript}">
            <script>${pageScript}</script>
        </c:if>

    </body>
</html>
