<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Import Customers – Admin</title>
            <style>
                @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');

                body {
                    margin: 0;
                    background-color: #f8f9fa;
                    color: #1f2937;
                    -webkit-font-smoothing: antialiased;
                }

                .page {
                    padding: 30px;
                    font-family: 'Inter', sans-serif;
                    max-width: 600px;
                    margin: 0 auto;
                }

                h2 {
                    font-size: 26px;
                    font-weight: 700;
                    color: #111827;
                    margin-top: 0;
                    margin-bottom: 24px;
                }

                .card {
                    background: #ffffff;
                    border: 1px solid #e5e7eb;
                    border-radius: 8px;
                    padding: 32px;
                    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
                }

                .upload-area {
                    border: 2px dashed #d1d5db;
                    border-radius: 4px;
                    padding: 40px 20px;
                    text-align: center;
                    margin-bottom: 24px;
                    background-color: #f9fafb;
                    transition: all 0.2s;
                }

                .upload-area:hover {
                    border-color: #9ca3af;
                    background-color: #f3f4f6;
                }

                input[type="file"] {
                    display: block;
                    margin: 0 auto 16px auto;
                    width: 100%;
                    max-width: 300px;
                    color: #4b5563;
                }

                .btn {
                    padding: 10px 16px;
                    border-radius: 4px;
                    border: 1px solid #d1d5db;
                    background: #ffffff;
                    font-weight: 500;
                    font-size: 14px;
                    cursor: pointer;
                    text-decoration: none;
                    color: #374151;
                    transition: all 0.2s;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
                }

                .btn:hover {
                    background: #f9fafb;
                    border-color: #c1c7d0;
                    color: #111827;
                }

                .btn-primary {
                    background: #0d6efd;
                    color: #ffffff;
                    border-color: #0d6efd;
                    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
                }

                .btn-primary:hover {
                    background: #0b5ed7;
                    border-color: #0a58ca;
                    color: #ffffff;
                    box-shadow: 0 4px 6px -1px rgba(13, 110, 253, 0.3);
                }

                .actions {
                    display: flex;
                    gap: 12px;
                    margin-top: 24px;
                    border-top: 1px solid #e5e7eb;
                    padding-top: 24px;
                }

                .success {
                    background: #ecfdf5;
                    border: 1px solid #a7f3d0;
                    color: #065f46;
                    padding: 12px 16px;
                    border-radius: 4px;
                    font-size: 14px;
                    margin-bottom: 24px;
                    font-weight: 500;
                }

                .error {
                    background: #fef2f2;
                    border: 1px solid #fecaca;
                    color: #b91c1c;
                    padding: 12px 16px;
                    border-radius: 4px;
                    font-size: 14px;
                    margin-bottom: 24px;
                }

                .error-item {
                    margin-bottom: 4px;
                }

                .error-item:last-child {
                    margin-bottom: 0;
                }

                .info-text {
                    color: #6b7280;
                    font-size: 13px;
                    margin-top: 8px;
                    text-align: center;
                }
            </style>
        </head>

        <body>
            <div class="page">
                <h2>Import Customers (CSV) <small style="font-size:14px;font-weight:400;color:#6b7280;">[Admin]</small>
                </h2>

                <div class="card">
                    <c:if test="${imported > 0}">
                        <div class="success">
                            Successfully imported ${imported} customers.
                        </div>
                    </c:if>

                    <c:if test="${not empty errors}">
                        <div class="error">
                            <c:forEach items="${errors}" var="e">
                                <div class="error-item">&bull; ${e}</div>
                            </c:forEach>
                        </div>
                    </c:if>

                    <form method="post" enctype="multipart/form-data"
                        action="${pageContext.request.contextPath}/admin/customer/import">
                        <div class="upload-area">
                            <input type="file" name="file" accept=".csv" required />
                            <div class="info-text">Please upload a valid CSV file containing customer data.</div>
                            <div class="info-text" style="margin-top: 4px; font-size: 12px;">Format:
                                full_name,email,phone,status,customer_segment,city</div>
                        </div>

                        <div class="actions">
                            <button class="btn btn-primary" type="submit">Upload CSV File</button>
                            <a class="btn" href="${pageContext.request.contextPath}/admin/customer/list">Back to
                                List</a>
                        </div>
                    </form>
                </div>
            </div>
        </body>

        </html>