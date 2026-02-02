<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lead Pipeline</title>
    <style>
        body { font-family: Arial, sans-serif; background:#0b1220; color:#e5e7eb; margin:0; }
        .layout { display:flex; min-height:100vh; }
        .sidebar { width:220px; background:#0f172a; padding:18px; border-right:1px solid rgba(255,255,255,0.08); }
        .brand { font-weight:800; font-size:18px; margin-bottom:18px; }
        .nav a { display:block; padding:10px 12px; border-radius:10px; color:#cbd5e1; text-decoration:none; margin-bottom:6px; }
        .nav a.active, .nav a:hover { background:rgba(37,99,235,0.15); color:#fff; }

        .content { flex:1; padding:22px; }
        .topbar { display:flex; gap:12px; align-items:center; justify-content:space-between; margin-bottom:16px; }
        .title { font-size:22px; font-weight:800; }
        .search { flex:1; max-width:520px; display:flex; gap:8px; align-items:center; background:rgba(255,255,255,0.06); border:1px solid rgba(255,255,255,0.12); border-radius:14px; padding:8px 12px; }
        .search input { width:100%; border:none; outline:none; background:transparent; color:#e5e7eb; }
        .btn { background:#2563eb; color:white; border:none; border-radius:12px; padding:10px 12px; font-weight:700; cursor:pointer; }
        .btn:hover { background:#1d4ed8; }

        .card { background:rgba(255,255,255,0.04); border:1px solid rgba(255,255,255,0.08); border-radius:16px; padding:16px; }
        .tabs { display:flex; gap:10px; margin-bottom:14px; flex-wrap:wrap; }
        .tab { padding:8px 12px; border-radius:999px; border:1px solid rgba(255,255,255,0.12); color:#cbd5e1; text-decoration:none; }
        .tab.active { background:#2563eb; border-color:#2563eb; color:white; }

        table { width:100%; border-collapse:collapse; overflow:hidden; border-radius:14px; }
        th, td { padding:12px; border-bottom:1px solid rgba(255,255,255,0.08); }
        th { text-align:left; font-size:12px; letter-spacing:0.07em; text-transform:uppercase; color:#94a3b8; background:rgba(255,255,255,0.03); }
        tr:hover td { background:rgba(255,255,255,0.03); }

        .pill { display:inline-block; padding:4px 10px; border-radius:999px; font-size:12px; font-weight:800; }
        .pill-new { background:#1e293b; color:#93c5fd; }
        .pill-contacted { background:#3b2f0b; color:#facc15; }
        .pill-qualified { background:#0f3d2e; color:#34d399; }
        .pill-other { background:#111827; color:#e5e7eb; }

        select { border-radius:10px; border:1px solid rgba(255,255,255,0.15); background:rgba(255,255,255,0.06); color:#e5e7eb; padding:6px 8px; }
        .action-form { display:flex; gap:8px; align-items:center; }
        a.link { color:#93c5fd; text-decoration:none; font-weight:700; }
        a.link:hover { text-decoration:underline; }
        .muted { color:#94a3b8; font-size:12px; }
    </style>
</head>

<body>
<div class="layout">
    <!-- Sidebar (mockup style) -->
    <div class="sidebar">
        <div class="brand">CRM Sales</div>
        <div class="nav">
            <a href="#" class="active">Leads</a>
            <a href="#">Opportunities</a>
            <a href="#">Quotations</a>
            <a href="#">Contracts</a>
        </div>
    </div>

    <!-- Main content -->
    <div class="content">
        <div class="topbar">
            <div>
                <div class="title">Lead Pipeline</div>
                <div class="muted">Search and manage your sales leads</div>
            </div>

            <!-- Search -->
            <form class="search" method="get" action="${pageContext.request.contextPath}/leads">
                <input name="q" value="${q}" placeholder="Search leads by name, email, phone..." />
                <c:if test="${not empty param.statusId}">
                    <input type="hidden" name="statusId" value="${param.statusId}" />
                </c:if>
                <button class="btn" type="submit">Search</button>
            </form>

            <button class="btn" type="button">+ Add New Lead</button>
        </div>

        <div class="card">
            <!-- Tabs -->
            <div class="tabs">
                <a class="tab <c:if test='${empty param.statusId}'>active</c:if>'"
                   href="${pageContext.request.contextPath}/leads">All</a>

                <a class="tab <c:if test='${param.statusId == "1"}'>active</c:if>'"
                   href="${pageContext.request.contextPath}/leads?statusId=1">New</a>

                <a class="tab <c:if test='${param.statusId == "2"}'>active</c:if>'"
                   href="${pageContext.request.contextPath}/leads?statusId=2">Contacted</a>

                <a class="tab <c:if test='${param.statusId == "3"}'>active</c:if>'"
                   href="${pageContext.request.contextPath}/leads?statusId=3">Qualified</a>
            </div>

            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Lead Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Total Score</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>

                <tbody>
                <c:if test="${empty leads}">
                    <tr><td colspan="7">No leads found.</td></tr>
                </c:if>

                <c:forEach items="${leads}" var="l">
                    <tr>
                        <td>${l.id}</td>
                        <td>
                            <a class="link" href="${pageContext.request.contextPath}/lead-detail?id=${l.id}">
                                ${l.fullName}
                            </a>
                        </td>
                        <td>${l.email}</td>
                        <td>${l.phone}</td>
                        <td>${l.totalScore}</td>

                        <td>
                            <c:set var="st" value="${l.leadStatusName}" />
                            <span class="pill
                                <c:choose>
                                  <c:when test="${st == 'New Lead' || st == 'New'}">pill-new</c:when>
                                  <c:when test="${st == 'Contacted'}">pill-contacted</c:when>
                                  <c:when test="${st == 'Qualified'}">pill-qualified</c:when>
                                  <c:otherwise>pill-other</c:otherwise>
                                </c:choose>
                            ">
                                ${l.leadStatusName}
                            </span>
                        </td>

                        <td>
                            <form class="action-form" method="post" action="${pageContext.request.contextPath}/update-lead-status">
                                <input type="hidden" name="leadId" value="${l.id}" />
                                <select name="statusId">
                                    <c:forEach items="${leadStatuses}" var="s">
                                        <option value="${s.id}" <c:if test="${s.id == l.leadStatusId}">selected</c:if>>
                                            ${s.name}
                                        </option>
                                    </c:forEach>
                                </select>
                                <button class="btn" type="submit">Update</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>

                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
