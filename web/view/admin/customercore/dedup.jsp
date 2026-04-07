<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Duplicate Customers – Admin</title>
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
                    max-width: 1000px;
                    margin: 0 auto;
                }

                h2 {
                    font-size: 26px;
                    font-weight: 700;
                    color: #111827;
                    margin-top: 0;
                    margin-bottom: 24px;
                }

                h3 {
                    font-size: 18px;
                    font-weight: 600;
                    color: #374151;
                    margin-top: 32px;
                    margin-bottom: 16px;
                    border-bottom: 2px solid #e5e7eb;
                    padding-bottom: 8px;
                }

                .table-container {
                    background: #ffffff;
                    border-radius: 8px;
                    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
                    border: 1px solid #e5e7eb;
                    overflow: hidden;
                    margin-bottom: 24px;
                }

                table {
                    width: 100%;
                    border-collapse: collapse;
                    text-align: left;
                }

                th,
                td {
                    padding: 14px 20px;
                    font-size: 14px;
                    border-bottom: 1px solid #f3f4f6;
                }

                th {
                    background: #f9fafb;
                    font-weight: 600;
                    color: #4b5563;
                    text-transform: uppercase;
                    font-size: 12px;
                    letter-spacing: 0.05em;
                }

                tbody tr {
                    transition: background-color 0.2s;
                }

                tbody tr:hover {
                    background-color: #f8fafc;
                }

                tbody tr:last-child td {
                    border-bottom: none;
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

                .id-col {
                    font-weight: 600;
                    color: #6b7280;
                    width: 60px;
                }

                .empty-state {
                    padding: 32px;
                    text-align: center;
                    color: #6b7280;
                    font-style: italic;
                }
            </style>
        </head>

        <body>
            <div class="page">
                <h2>Duplicate Customers <small style="font-size:14px;font-weight:400;color:#6b7280;">[Admin]</small>
                </h2>

                <h3>Duplicate Email Address</h3>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th class="id-col">ID</th>
                                <th>Name</th>
                                <th>Email</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty dupEmail}">
                                <tr>
                                    <td colspan="3" class="empty-state">No customers found with duplicate email
                                        addresses.</td>
                                </tr>
                            </c:if>
                            <c:forEach items="${dupEmail}" var="c">
                                <tr>
                                    <td class="id-col">#${c.customerId}</td>
                                    <td>${c.fullName}</td>
                                    <td>${c.email}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <h3>Duplicate Phone Number</h3>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th class="id-col">ID</th>
                                <th>Name</th>
                                <th>Phone Number</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty dupPhone}">
                                <tr>
                                    <td colspan="3" class="empty-state">No customers found with duplicate phone numbers.
                                    </td>
                                </tr>
                            </c:if>
                            <c:forEach items="${dupPhone}" var="c">
                                <tr>
                                    <td class="id-col">#${c.customerId}</td>
                                    <td>${c.fullName}</td>
                                    <td>${c.phone}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div style="margin-top: 32px;">
                    <a class="btn" href="${pageContext.request.contextPath}/admin/customer/list">Back to List</a>
                </div>
            </div>
        </body>

        </html>