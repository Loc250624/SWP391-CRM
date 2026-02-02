<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lead Detail</title>
</head>
<body>
    <h2>Lead Detail</h2>

    <p><b>ID:</b> ${lead.id}</p>
    <p><b>Full name:</b> ${lead.fullName}</p>
    <p><b>Email:</b> ${lead.email}</p>
    <p><b>Phone:</b> ${lead.phone}</p>
    <p><b>Total score:</b> ${lead.totalScore}</p>
    <p><b>Status:</b> ${lead.leadStatusName}</p>

    <a href="${pageContext.request.contextPath}/leads">Back to list</a>
</body>
</html>
