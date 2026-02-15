<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${pageTitle} | CRM Support</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { background-color: #f3f4f6; }
        .main-wrapper { margin-left: 250px; padding-top: 64px; min-height: 100vh; }
        .content-body { padding: 30px; }
    </style>
</head>
<body>
    <jsp:include page="layout/sidebar.jsp" />

    <jsp:include page="layout/header.jsp" />

    <main class="main-wrapper">
        <div class="content-body">
            <jsp:include page="${contentPage}" />
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>