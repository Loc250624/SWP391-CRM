<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
    /* Stats Cards */
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1rem;
        margin-bottom: 1.5rem;
    }

    .stat-card {
        background: white;
        border-radius: 0.875rem;
        border: 1px solid #e2e8f0;
        padding: 1.25rem;
        transition: all 0.2s;
    }

    .stat-card:hover {
        box-shadow: 0 4px 12px rgba(59, 130, 246, 0.1);
        transform: translateY(-2px);
    }

    .stat-label {
        font-size: 0.8125rem;
        color: #64748b;
        font-weight: 500;
        margin-bottom: 0.5rem;
    }

    .stat-value {
        font-size: 1.5rem;
        font-weight: 800;
        color: #1e293b;
    }

    /* List Header */
    .list-header {
        background: white;
        border-radius: 1rem;
        border: 1px solid #e2e8f0;
        padding: 1.5rem;
        margin-bottom: 1.5rem;
    }

    .header-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 1rem;
    }

    .page-title {
        font-size: 1.75rem;
        font-weight: 800;
        color: #1e293b;
    }

    .header-actions {
        display: flex;
        gap: 0.75rem;
    }

    .btn {
        padding: 0.625rem 1.25rem;
        border-radius: 0.625rem;
        font-weight: 600;
        font-size: 0.875rem;
        transition: all 0.2s;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        border: none;
        text-decoration: none;
    }

    .btn-primary {
        background: linear-gradient(135deg, #60a5fa, #3b82f6);
        color: white;
        box-shadow: 0 2px 8px rgba(59, 130, 246, 0.25);
    }

    .btn-primary:hover {
        box-shadow: 0 4px 16px rgba(59, 130, 246, 0.35);
        transform: translateY(-1px);
    }

    .btn-secondary {
        background: white;
        border: 1px solid #e2e8f0;
        color: #475569;
    }

    .btn-secondary:hover {
        background: #f8fafc;
        border-color: #cbd5e1;
    }

    /* Filters */
    .filters-container {
        background: white;
        border-radius: 1rem;
        border: 1px solid #e2e8f0;
        padding: 1.5rem;
        margin-bottom: 1.5rem;
    }

    .filter-field {
        margin-bottom: 1rem;
    }

    .filter-field label {
        display: block;
        font-size: 0.875rem;
        font-weight: 600;
        color: #475569;
        margin-bottom: 0.5rem;
    }

    .filter-input {
        width: 100%;
        padding: 0.625rem 0.875rem;
        border: 1px solid #e2e8f0;
        border-radius: 0.5rem;
        font-size: 0.875rem;
        transition: all 0.2s;
    }

    .filter-input:focus {
        outline: none;
        border-color: #60a5fa;
        box-shadow: 0 0 0 3px rgba(96, 165, 250, 0.1);
    }

    /* Table */
    .table-container {
        background: white;
        border-radius: 1rem;
        border: 1px solid #e2e8f0;
        overflow: hidden;
    }

    .table-wrapper {
        overflow-x: auto;
    }

    table {
        width: 100%;
        border-collapse: collapse;
    }

    thead {
        background: linear-gradient(135deg, #f8fafc, #f1f5f9);
        border-bottom: 2px solid #e2e8f0;
    }

    th {
        padding: 1rem 1.25rem;
        text-align: left;
        font-size: 0.8125rem;
        font-weight: 700;
        color: #475569;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        white-space: nowrap;
    }

    tbody tr {
        border-bottom: 1px solid #f1f5f9;
        transition: background 0.15s;
    }

    tbody tr:hover {
        background: #f8fafc;
    }

    td {
        padding: 1rem 1.25rem;
        font-size: 0.875rem;
        color: #1e293b;
    }

    .opp-name {
        font-weight: 600;
        color: #1e293b;
        margin-bottom: 0.25rem;
    }

    .opp-code {
        font-size: 0.75rem;
        color: #64748b;
    }

    .value-cell {
        font-weight: 700;
        color: #10b981;
        font-size: 0.9375rem;
    }

    .status-badge {
        display: inline-flex;
        align-items: center;
        gap: 0.375rem;
        padding: 0.375rem 0.75rem;
        border-radius: 0.5rem;
        font-size: 0.75rem;
        font-weight: 700;
        white-space: nowrap;
    }

    .status-open {
        background: linear-gradient(135deg, #dbeafe, #bfdbfe);
        color: #1e40af;
    }

    .status-won {
        background: linear-gradient(135deg, #d1fae5, #a7f3d0);
        color: #15803d;
    }

    .status-lost {
        background: linear-gradient(135deg, #fee2e2, #fecaca);
        color: #dc2626;
    }

    .actions-cell {
        display: flex;
        gap: 0.375rem;
    }

    .action-btn {
        padding: 0.5rem;
        border-radius: 0.5rem;
        transition: background 0.15s;
        cursor: pointer;
        border: none;
        background: transparent;
    }

    .action-btn:hover {
        background: #f1f5f9;
    }

    .action-btn svg {
        width: 1rem;
        height: 1rem;
        color: #64748b;
    }

    .action-btn:hover svg {
        color: #3b82f6;
    }

    /* Empty State */
    .empty-state {
        text-align: center;
        padding: 4rem 2rem;
    }

    .empty-icon {
        width: 4rem;
        height: 4rem;
        margin: 0 auto 1.5rem;
        color: #cbd5e1;
    }

    .empty-title {
        font-size: 1.25rem;
        font-weight: 700;
        color: #475569;
        margin-bottom: 0.5rem;
    }

    .empty-text {
        font-size: 0.875rem;
        color: #64748b;
        margin-bottom: 1.5rem;
    }

    /* Success/Error Messages */
    .alert {
        padding: 1rem 1.25rem;
        border-radius: 0.75rem;
        margin-bottom: 1.5rem;
        display: flex;
        align-items: center;
        gap: 0.75rem;
        font-weight: 600;
        font-size: 0.875rem;
    }

    .alert-success {
        background: linear-gradient(135deg, #d1fae5, #a7f3d0);
        color: #15803d;
    }

    .alert-error {
        background: linear-gradient(135deg, #fee2e2, #fecaca);
        color: #dc2626;
    }
</style>

<!-- Success/Error Messages -->
<c:if test="${param.success == 'created'}">
    <div class="alert alert-success">
        <svg style="width: 1.25rem; height: 1.25rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
        </svg>
        <span>Opportunity created successfully!</span>
    </div>
</c:if>

<c:if test="${param.success == 'updated'}">
    <div class="alert alert-success">
        <svg style="width: 1.25rem; height: 1.25rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
        </svg>
        <span>Opportunity updated successfully!</span>
    </div>
</c:if>

<c:if test="${param.error == 'no_permission'}">
    <div class="alert alert-error">
        <svg style="width: 1.25rem; height: 1.25rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
        </svg>
        <span>You don't have permission to access that opportunity.</span>
    </div>
</c:if>

<!-- Page Header -->
<div class="list-header">
    <div class="header-row">
        <div>
            <h1 class="page-title">Opportunity List</h1>
            <p style="font-size: 0.875rem; color: #64748b; margin-top: 0.5rem;">
                Manage all sales opportunities in one place
            </p>
        </div>

        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/sale/opportunity/kanban" class="btn btn-secondary">
                <svg style="width: 1.125rem; height: 1.125rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17V7m0 10a2 2 0 01-2 2H5a2 2 0 01-2-2V7a2 2 0 012-2h2a2 2 0 012 2m0 10a2 2 0 002 2h2a2 2 0 002-2M9 7a2 2 0 012-2h2a2 2 0 012 2m0 10V7m0 10a2 2 0 002 2h2a2 2 0 002-2V7a2 2 0 00-2-2h-2a2 2 0 00-2 2"/>
                </svg>
                Kanban View
            </a>

            <a href="${pageContext.request.contextPath}/sale/opportunity/form" class="btn btn-primary">
                <svg style="width: 1.125rem; height: 1.125rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                </svg>
                New Opportunity
            </a>
        </div>
    </div>
</div>

<!-- Stats Cards -->
<div class="stats-grid">
    <div class="stat-card">
        <div class="stat-label">Total Opportunities</div>
        <div class="stat-value" style="color: #3b82f6;">${totalOpportunities}</div>
    </div>
    <div class="stat-card">
        <div class="stat-label">Total Value</div>
        <div class="stat-value" style="color: #10b981;">
            <fmt:formatNumber value="${totalValue}" type="currency" currencySymbol="$" maxFractionDigits="0"/>
        </div>
    </div>
    <div class="stat-card">
        <div class="stat-label">Open</div>
        <div class="stat-value" style="color: #3b82f6;">${openCount}</div>
    </div>
    <div class="stat-card">
        <div class="stat-label">Won</div>
        <div class="stat-value" style="color: #10b981;">${wonCount}</div>
    </div>
    <div class="stat-card">
        <div class="stat-label">Lost</div>
        <div class="stat-value" style="color: #ef4444;">${lostCount}</div>
    </div>
</div>

<!-- Filters -->
<c:if test="${not empty pipelines}">
    <div class="filters-container">
        <h3 style="font-size: 1.125rem; font-weight: 700; color: #1e293b; margin-bottom: 1rem;">Filter by Pipeline</h3>
        <form method="GET" action="${pageContext.request.contextPath}/sale/opportunity/list">
            <div class="filter-field">
                <label>Select Pipeline</label>
                <select name="pipeline" class="filter-input" onchange="this.form.submit()">
                    <option value="">All Pipelines</option>
                    <c:forEach var="pipeline" items="${pipelines}">
                        <option value="${pipeline.pipelineId}"
                                <c:if test="${selectedPipelineId == pipeline.pipelineId}">selected</c:if>>
                            ${pipeline.pipelineName}
                        </option>
                    </c:forEach>
                </select>
            </div>
        </form>
    </div>
</c:if>

<!-- Table -->
<div class="table-container">
    <c:choose>
        <c:when test="${empty opportunities}">
            <div class="empty-state">
                <svg class="empty-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
                </svg>
                <div class="empty-title">No opportunities found</div>
                <div class="empty-text">Start by creating your first opportunity</div>
                <a href="${pageContext.request.contextPath}/sale/opportunity/form" class="btn btn-primary">
                    <svg style="width: 1.125rem; height: 1.125rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                    </svg>
                    Create Opportunity
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>Code</th>
                            <th>Opportunity Name</th>
                            <th>Pipeline</th>
                            <th>Stage</th>
                            <th>Value</th>
                            <th>Probability</th>
                            <th>Status</th>
                            <th>Close Date</th>
                            <th style="width: 120px;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="opp" items="${opportunities}">
                            <tr>
                                <td>
                                    <div class="opp-code">${opp.opportunityCode}</div>
                                </td>
                                <td>
                                    <div class="opp-name">${opp.opportunityName}</div>
                                </td>
                                <td>
                                    <c:forEach var="pipeline" items="${pipelines}">
                                        <c:if test="${pipeline.pipelineId == opp.pipelineId}">
                                            ${pipeline.pipelineName}
                                        </c:if>
                                    </c:forEach>
                                </td>
                                <td>
                                    Stage ID: ${opp.stageId}
                                </td>
                                <td class="value-cell">
                                    <fmt:formatNumber value="${opp.estimatedValue}" type="currency" currencySymbol="$" maxFractionDigits="0"/>
                                </td>
                                <td>
                                    ${opp.probability}%
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${opp.status == 'Open'}">
                                            <span class="status-badge status-open">
                                                <span style="width: 0.5rem; height: 0.5rem; background: #3b82f6; border-radius: 50%; display: inline-block;"></span>
                                                Open
                                            </span>
                                        </c:when>
                                        <c:when test="${opp.status == 'Won'}">
                                            <span class="status-badge status-won">
                                                <span style="width: 0.5rem; height: 0.5rem; background: #10b981; border-radius: 50%; display: inline-block;"></span>
                                                Won
                                            </span>
                                        </c:when>
                                        <c:when test="${opp.status == 'Lost'}">
                                            <span class="status-badge status-lost">
                                                <span style="width: 0.5rem; height: 0.5rem; background: #ef4444; border-radius: 50%; display: inline-block;"></span>
                                                Lost
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-open">${opp.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${not empty opp.expectedCloseDate}">
                                        ${opp.expectedCloseDate}
                                    </c:if>
                                    <c:if test="${empty opp.expectedCloseDate}">
                                        -
                                    </c:if>
                                </td>
                                <td>
                                    <div class="actions-cell">
                                        <a href="${pageContext.request.contextPath}/sale/opportunity/form?id=${opp.opportunityId}" class="action-btn" title="Edit">
                                            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                            </svg>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Pagination Info -->
            <div style="padding: 1.25rem 1.5rem; border-top: 1px solid #e2e8f0;">
                <div style="font-size: 0.875rem; color: #64748b;">
                    Showing <strong>${opportunities.size()}</strong> opportunities
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>
