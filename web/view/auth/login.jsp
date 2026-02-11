<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập CRM</title>
    <style>
        body { font-family: Arial, sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; background-color: #f4f6f9; }
        .login-card { background: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); width: 350px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: bold; color: #555; }
        .form-group input { width: 100%; padding: 10px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px; }
        .btn { width: 100%; padding: 12px; background-color: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; font-weight: bold; }
        .btn:hover { background-color: #0056b3; }
        .error { color: #721c24; background-color: #f8d7da; border-color: #f5c6cb; padding: 10px; border-radius: 4px; margin-bottom: 15px; text-align: center; }
    </style>
</head>
<body>
    <div class="login-card">
        <h2 style="text-align: center; margin-bottom: 20px; color: #333;">CRM Login</h2>
        
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" required placeholder="Nhập email của bạn...">
            </div>
            <div class="form-group">
                <label>Mật khẩu</label>
                <input type="password" name="password" required>
            </div>
            <button type="submit" class="btn">Đăng nhập</button>
        </form>
    </div>
</body>
</html>