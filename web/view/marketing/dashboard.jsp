<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Marketing Dashboard</title>
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap');

            body {
                font-family: 'Inter', sans-serif;
                background-color: #f3f4f6;
                margin: 0;
                display: flex;
                align-items: center;
                justify-content: center;
                height: 100vh;
            }

            .container {
                background: white;
                padding: 40px;
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
                text-align: center;
                max-width: 500px;
            }

            h1 {
                color: #111827;
                margin-bottom: 10px;
            }

            p {
                color: #6b7280;
                line-height: 1.5;
            }

            .badge {
                display: inline-block;
                background: #dcfce7;
                color: #15803d;
                padding: 6px 12px;
                border-radius: 9999px;
                font-size: 14px;
                font-weight: 600;
                margin-bottom: 20px;
            }

            .btn {
                margin-top: 25px;
                display: inline-block;
                background: #2563eb;
                color: white;
                padding: 12px 24px;
                text-decoration: none;
                border-radius: 6px;
                font-weight: 500;
                transition: background 0.2s;
            }

            .btn:hover {
                background: #1d4ed8;
            }
        </style>
    </head>

    <body>
        <div class="container">
            <span class="badge">Success</span>
            <h1>Marketing Dashboard</h1>
            <p>Chào mừng bạn đến với khu vực quản lý Marketing. Servlet hiện đã hoạt động và đang kết nối tới trang này.
            </p>
            <a href="${pageContext.request.contextPath}/admin/customer/list" class="btn">Quay lại Admin Customer</a>
        </div>
    </body>

    </html>