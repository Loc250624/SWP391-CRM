<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Khong tim thay trang</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body { background: #f0f2f5; display: flex; align-items: center; justify-content: center; min-height: 100vh; margin: 0; }
        .error-card { text-align: center; max-width: 460px; padding: 48px 32px; }
        .error-icon { font-size: 5rem; color: #6c757d; margin-bottom: 16px; }
        .error-code { font-size: 4rem; font-weight: 800; color: #343a40; line-height: 1; }
        .error-title { font-size: 1.25rem; font-weight: 600; color: #495057; margin: 12px 0 8px; }
        .error-desc { color: #6c757d; font-size: .9rem; margin-bottom: 24px; }
    </style>
</head>
<body>
    <div class="error-card">
        <div class="error-icon"><i class="bi bi-file-earmark-x-fill"></i></div>
        <div class="error-code">404</div>
        <div class="error-title">Khong tim thay trang</div>
        <div class="error-desc">Trang ban yeu cau khong ton tai hoac da bi di chuyen. Vui long kiem tra lai duong dan.</div>
        <div class="d-flex justify-content-center gap-2">
            <a href="javascript:history.back()" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left me-1"></i>Quay lai</a>
            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-sm"><i class="bi bi-house me-1"></i>Trang chu</a>
        </div>
    </div>
</body>
</html>
