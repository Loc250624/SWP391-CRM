<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
    /* List View Styles */
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

    .filters-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        gap: 1rem;
        margin-top: 1rem;
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

    th.sortable {
        cursor: pointer;
        user-select: none;
    }

    th.sortable:hover {
        color: #3b82f6;
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

    .company-cell {
        font-weight: 600;
        color: #1e293b;
    }

    .deal-name {
        font-weight: 600;
        color: #1e293b;
        margin-bottom: 0.25rem;
    }

    .deal-category {
        font-size: 0.75rem;
        color: #64748b;
    }

    .value-cell {
        font-weight: 700;
        color: #1e293b;
        font-size: 0.9375rem;
    }

    /* Stage Badge */
    .stage-badge {
        display: inline-flex;
        align-items: center;
        gap: 0.375rem;
        padding: 0.375rem 0.75rem;
        border-radius: 0.5rem;
        font-size: 0.75rem;
        font-weight: 700;
        white-space: nowrap;
    }

    .stage-prospecting {
        background: linear-gradient(135deg, #dbeafe, #bfdbfe);
        color: #1e40af;
    }

    .stage-qualification {
        background: linear-gradient(135deg, #e0e7ff, #c7d2fe);
        color: #4338ca;
    }

    .stage-proposal {
        background: linear-gradient(135deg, #f3e8ff, #e9d5ff);
        color: #7c3aed;
    }

    .stage-negotiation {
        background: linear-gradient(135deg, #fed7aa, #fdba74);
        color: #c2410c;
    }

    .stage-closing {
        background: linear-gradient(135deg, #d1fae5, #a7f3d0);
        color: #15803d;
    }

    /* Priority Badge */
    .priority-badge {
        display: inline-block;
        padding: 0.25rem 0.625rem;
        border-radius: 0.375rem;
        font-size: 0.6875rem;
        font-weight: 700;
        text-transform: uppercase;
    }

    .priority-high {
        background: linear-gradient(135deg, #fee2e2, #fecaca);
        color: #dc2626;
    }

    .priority-medium {
        background: linear-gradient(135deg, #fef3c7, #fde68a);
        color: #d97706;
    }

    .priority-low {
        background: linear-gradient(135deg, #e0e7ff, #c7d2fe);
        color: #4f46e5;
    }

    /* Owner */
    .owner-cell {
        display: flex;
        align-items: center;
        gap: 0.625rem;
    }

    .owner-avatar {
        width: 2rem;
        height: 2rem;
        border-radius: 0.5rem;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: 700;
        font-size: 0.75rem;
        flex-shrink: 0;
    }

    .owner-name {
        font-weight: 500;
        color: #475569;
    }

    /* Date */
    .date-cell {
        display: flex;
        align-items: center;
        gap: 0.375rem;
        color: #64748b;
        font-size: 0.8125rem;
    }

    /* Actions */
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

    /* Pagination */
    .pagination-container {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 1.25rem 1.5rem;
        border-top: 1px solid #e2e8f0;
    }

    .pagination-info {
        font-size: 0.875rem;
        color: #64748b;
    }

    .pagination-controls {
        display: flex;
        gap: 0.5rem;
    }

    .page-btn {
        padding: 0.5rem 0.875rem;
        border: 1px solid #e2e8f0;
        background: white;
        border-radius: 0.5rem;
        font-size: 0.875rem;
        font-weight: 500;
        color: #475569;
        cursor: pointer;
        transition: all 0.15s;
    }

    .page-btn:hover:not(:disabled) {
        background: #f8fafc;
        border-color: #cbd5e1;
    }

    .page-btn.active {
        background: linear-gradient(135deg, #60a5fa, #3b82f6);
        color: white;
        border-color: #3b82f6;
    }

    .page-btn:disabled {
        opacity: 0.5;
        cursor: not-allowed;
    }

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

    /* Bulk Actions */
    .bulk-actions {
        background: white;
        border: 1px solid #e2e8f0;
        border-radius: 0.75rem;
        padding: 1rem 1.25rem;
        margin-bottom: 1rem;
        display: none;
        align-items: center;
        gap: 1rem;
    }

    .bulk-actions.active {
        display: flex;
    }

    .selected-count {
        font-size: 0.875rem;
        font-weight: 600;
        color: #475569;
    }

    .bulk-btn {
        padding: 0.5rem 1rem;
        border-radius: 0.5rem;
        font-size: 0.8125rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.15s;
    }

    /* Checkbox */
    .checkbox {
        width: 1.125rem;
        height: 1.125rem;
        cursor: pointer;
        accent-color: #3b82f6;
    }
</style>

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
            <button onclick="exportData()" class="btn btn-secondary">
                <svg style="width: 1.125rem; height: 1.125rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"/>
                </svg>
                Export
            </button>

            <button onclick="toggleFilters()" class="btn btn-secondary">
                <svg style="width: 1.125rem; height: 1.125rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.293A1 1 0 013 6.586V4z"/>
                </svg>
                Filters
            </button>

            <button onclick="openCreateModal()" class="btn btn-primary">
                <svg style="width: 1.125rem; height: 1.125rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                </svg>
                New Opportunity
            </button>
        </div>
    </div>
</div>

<!-- Stats Cards -->
<div class="stats-grid">
    <div class="stat-card">
        <div class="stat-label">Total Opportunities</div>
        <div class="stat-value" style="color: #3b82f6;">156</div>
    </div>
    <div class="stat-card">
        <div class="stat-label">Pipeline Value</div>
        <div class="stat-value" style="color: #10b981;">$2.45M</div>
    </div>
    <div class="stat-card">
        <div class="stat-label">Expected Close</div>
        <div class="stat-value" style="color: #fb923c;">$1.82M</div>
    </div>
    <div class="stat-card">
        <div class="stat-label">Avg Win Rate</div>
        <div class="stat-value" style="color: #a855f7;">68%</div>
    </div>
</div>

<!-- Filters -->
<div id="filtersContainer" class="filters-container" style="display: none;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
        <h3 style="font-size: 1.125rem; font-weight: 700; color: #1e293b;">Filter Opportunities</h3>
        <button onclick="toggleFilters()" style="color: #64748b; background: none; border: none; cursor: pointer;">
            <svg style="width: 1.25rem; height: 1.25rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
            </svg>
        </button>
    </div>

    <form method="GET" action="${pageContext.request.contextPath}/sale/opportunity/list">
        <div class="filters-grid">
            <div class="filter-field">
                <label>Search</label>
                <input type="text" name="search" class="filter-input" placeholder="Deal or company name...">
            </div>

            <div class="filter-field">
                <label>Stage</label>
                <select name="stage" class="filter-input">
                    <option value="">All Stages</option>
                    <option value="prospecting">Prospecting</option>
                    <option value="qualification">Qualification</option>
                    <option value="proposal">Proposal</option>
                    <option value="negotiation">Negotiation</option>
                    <option value="closing">Closing</option>
                </select>
            </div>

            <div class="filter-field">
                <label>Priority</label>
                <select name="priority" class="filter-input">
                    <option value="">All Priorities</option>
                    <option value="high">High</option>
                    <option value="medium">Medium</option>
                    <option value="low">Low</option>
                </select>
            </div>

            <div class="filter-field">
                <label>Sales Rep</label>
                <select name="salesRep" class="filter-input">
                    <option value="">All Reps</option>
                    <option value="john">John Doe</option>
                    <option value="jane">Jane Smith</option>
                    <option value="mike">Mike Johnson</option>
                </select>
            </div>

            <div class="filter-field">
                <label>Min Value ($)</label>
                <input type="number" name="minValue" class="filter-input" placeholder="0">
            </div>

            <div class="filter-field">
                <label>Max Value ($)</label>
                <input type="number" name="maxValue" class="filter-input" placeholder="1000000">
            </div>
        </div>

        <div style="display: flex; gap: 0.75rem; margin-top: 1.5rem;">
            <button type="submit" class="btn btn-primary">Apply Filters</button>
            <a href="${pageContext.request.contextPath}/sale/opportunity/list" class="btn btn-secondary" style="text-decoration: none;">Clear All</a>
        </div>
    </form>
</div>

<!-- Bulk Actions Bar -->
<div id="bulkActions" class="bulk-actions">
    <input type="checkbox" id="selectAll" class="checkbox" onchange="toggleSelectAll(this)">
    <span class="selected-count"><span id="selectedCount">0</span> selected</span>

    <div style="flex: 1;"></div>

    <button onclick="bulkChangeStage()" class="bulk-btn" style="background: #dbeafe; color: #1e40af; border: none;">
        Change Stage
    </button>
    <button onclick="bulkAssign()" class="bulk-btn" style="background: #e0e7ff; color: #4338ca; border: none;">
        Assign To
    </button>
    <button onclick="bulkDelete()" class="bulk-btn" style="background: #fee2e2; color: #dc2626; border: none;">
        Delete
    </button>
</div>

<!-- Table -->
<div class="table-container">
    <div class="table-wrapper">
        <table>
            <thead>
                <tr>
                    <th style="width: 40px;">
                        <input type="checkbox" class="checkbox" onchange="toggleSelectAll(this)">
                    </th>
                    <th class="sortable" onclick="sortTable('deal')">
                        Deal Name
                        <svg style="width: 0.875rem; height: 0.875rem; display: inline-block; margin-left: 0.25rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16V4m0 0L3 8m4-4l4 4m6 0v12m0 0l4-4m-4 4l-4-4"/>
                        </svg>
                    </th>
                    <th class="sortable" onclick="sortTable('company')">Company</th>
                    <th class="sortable" onclick="sortTable('value')">Value</th>
                    <th>Stage</th>
                    <th>Priority</th>
                    <th>Owner</th>
                    <th class="sortable" onclick="sortTable('date')">Close Date</th>
                    <th style="width: 120px;">Actions</th>
                </tr>
            </thead>
            <tbody>

                <!-- Row 1 -->
                <tr>
                    <td>
                        <input type="checkbox" class="checkbox row-checkbox" onchange="updateBulkActions()">
                    </td>
                    <td>
                        <div class="deal-name">Enterprise ERP Solution</div>
                        <div class="deal-category">Software Implementation</div>
                    </td>
                    <td class="company-cell">ABC Corporation</td>
                    <td class="value-cell">$85,000</td>
                    <td>
                        <span class="stage-badge stage-prospecting">
                            <span style="width: 0.5rem; height: 0.5rem; background: #3b82f6; border-radius: 50%; display: inline-block;"></span>
                            Prospecting
                        </span>
                    </td>
                    <td>
                        <span class="priority-badge priority-high">High</span>
                    </td>
                    <td>
                        <div class="owner-cell">
                            <div class="owner-avatar" style="background: linear-gradient(135deg, #60a5fa, #3b82f6);">
                                JD
                            </div>
                            <span class="owner-name">John Doe</span>
                        </div>
                    </td>
                    <td>
                        <div class="date-cell">
                            <svg style="width: 0.875rem; height: 0.875rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                            </svg>
                            Feb 28, 2026
                        </div>
                    </td>
                    <td>
                        <div class="actions-cell">
                            <button class="action-btn" onclick="viewOpportunity(1)" title="View">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                                </svg>
                            </button>
                            <button class="action-btn" onclick="editOpportunity(1)" title="Edit">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                </svg>
                            </button>
                            <button class="action-btn" onclick="deleteOpportunity(1)" title="Delete">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                </svg>
                            </button>
                        </div>
                    </td>
                </tr>

                <!-- Row 2 -->
                <tr>
                    <td>
                        <input type="checkbox" class="checkbox row-checkbox" onchange="updateBulkActions()">
                    </td>
                    <td>
                        <div class="deal-name">Cloud Migration Project</div>
                        <div class="deal-category">Infrastructure Services</div>
                    </td>
                    <td class="company-cell">Tech Startup Inc</td>
                    <td class="value-cell">$45,000</td>
                    <td>
                        <span class="stage-badge stage-qualification">
                            <span style="width: 0.5rem; height: 0.5rem; background: #6366f1; border-radius: 50%; display: inline-block;"></span>
                            Qualification
                        </span>
                    </td>
                    <td>
                        <span class="priority-badge priority-medium">Medium</span>
                    </td>
                    <td>
                        <div class="owner-cell">
                            <div class="owner-avatar" style="background: linear-gradient(135deg, #a78bfa, #7c3aed);">
                                JS
                            </div>
                            <span class="owner-name">Jane Smith</span>
                        </div>
                    </td>
                    <td>
                        <div class="date-cell">
                            <svg style="width: 0.875rem; height: 0.875rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                            </svg>
                            Mar 15, 2026
                        </div>
                    </td>
                    <td>
                        <div class="actions-cell">
                            <button class="action-btn" onclick="viewOpportunity(2)" title="View">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                                </svg>
                            </button>
                            <button class="action-btn" onclick="editOpportunity(2)" title="Edit">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                </svg>
                            </button>
                            <button class="action-btn" onclick="deleteOpportunity(2)" title="Delete">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                </svg>
                            </button>
                        </div>
                    </td>
                </tr>

                <!-- Row 3 -->
                <tr>
                    <td>
                        <input type="checkbox" class="checkbox row-checkbox" onchange="updateBulkActions()">
                    </td>
                    <td>
                        <div class="deal-name">Marketing Automation Suite</div>
                        <div class="deal-category">SaaS Subscription</div>
                    </td>
                    <td class="company-cell">XYZ Limited</td>
                    <td class="value-cell">$28,000</td>
                    <td>
                        <span class="stage-badge stage-proposal">
                            <span style="width: 0.5rem; height: 0.5rem; background: #a855f7; border-radius: 50%; display: inline-block;"></span>
                            Proposal
                        </span>
                    </td>
                    <td>
                        <span class="priority-badge priority-low">Low</span>
                    </td>
                    <td>
                        <div class="owner-cell">
                            <div class="owner-avatar" style="background: linear-gradient(135deg, #fb923c, #f97316);">
                                MJ
                            </div>
                            <span class="owner-name">Mike Johnson</span>
                        </div>
                    </td>
                    <td>
                        <div class="date-cell">
                            <svg style="width: 0.875rem; height: 0.875rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                            </svg>
                            Apr 10, 2026
                        </div>
                    </td>
                    <td>
                        <div class="actions-cell">
                            <button class="action-btn" onclick="viewOpportunity(3)" title="View">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                                </svg>
                            </button>
                            <button class="action-btn" onclick="editOpportunity(3)" title="Edit">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                </svg>
                            </button>
                            <button class="action-btn" onclick="deleteOpportunity(3)" title="Delete">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                </svg>
                            </button>
                        </div>
                    </td>
                </tr>

                <!-- Row 4 -->
                <tr>
                    <td>
                        <input type="checkbox" class="checkbox row-checkbox" onchange="updateBulkActions()">
                    </td>
                    <td>
                        <div class="deal-name">CRM Integration Package</div>
                        <div class="deal-category">Consulting Services</div>
                    </td>
                    <td class="company-cell">Global Enterprises</td>
                    <td class="value-cell">$120,000</td>
                    <td>
                        <span class="stage-badge stage-negotiation">
                            <span style="width: 0.5rem; height: 0.5rem; background: #fb923c; border-radius: 50%; display: inline-block;"></span>
                            Negotiation
                        </span>
                    </td>
                    <td>
                        <span class="priority-badge priority-high">High</span>
                    </td>
                    <td>
                        <div class="owner-cell">
                            <div class="owner-avatar" style="background: linear-gradient(135deg, #60a5fa, #3b82f6);">
                                JD
                            </div>
                            <span class="owner-name">John Doe</span>
                        </div>
                    </td>
                    <td>
                        <div class="date-cell">
                            <svg style="width: 0.875rem; height: 0.875rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                            </svg>
                            Feb 20, 2026
                        </div>
                    </td>
                    <td>
                        <div class="actions-cell">
                            <button class="action-btn" onclick="viewOpportunity(4)" title="View">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                                </svg>
                            </button>
                            <button class="action-btn" onclick="editOpportunity(4)" title="Edit">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                </svg>
                            </button>
                            <button class="action-btn" onclick="deleteOpportunity(4)" title="Delete">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                </svg>
                            </button>
                        </div>
                    </td>
                </tr>

                <!-- Row 5 -->
                <tr>
                    <td>
                        <input type="checkbox" class="checkbox row-checkbox" onchange="updateBulkActions()">
                    </td>
                    <td>
                        <div class="deal-name">Mobile App Development</div>
                        <div class="deal-category">Software Development</div>
                    </td>
                    <td class="company-cell">Innovate Labs</td>
                    <td class="value-cell">$95,000</td>
                    <td>
                        <span class="stage-badge stage-closing">
                            <span style="width: 0.5rem; height: 0.5rem; background: #10b981; border-radius: 50%; display: inline-block;"></span>
                            Closing
                        </span>
                    </td>
                    <td>
                        <span class="priority-badge priority-high">High</span>
                    </td>
                    <td>
                        <div class="owner-cell">
                            <div class="owner-avatar" style="background: linear-gradient(135deg, #a78bfa, #7c3aed);">
                                JS
                            </div>
                            <span class="owner-name">Jane Smith</span>
                        </div>
                    </td>
                    <td>
                        <div class="date-cell">
                            <svg style="width: 0.875rem; height: 0.875rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                            </svg>
                            Feb 25, 2026
                        </div>
                    </td>
                    <td>
                        <div class="actions-cell">
                            <button class="action-btn" onclick="viewOpportunity(5)" title="View">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                                </svg>
                            </button>
                            <button class="action-btn" onclick="editOpportunity(5)" title="Edit">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                </svg>
                            </button>
                            <button class="action-btn" onclick="deleteOpportunity(5)" title="Delete">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                </svg>
                            </button>
                        </div>
                    </td>
                </tr>

            </tbody>
        </table>
    </div>

    <!-- Pagination -->
    <div class="pagination-container">
        <div class="pagination-info">
            Showing <strong>1-5</strong> of <strong>156</strong> opportunities
        </div>

        <div class="pagination-controls">
            <button class="page-btn" disabled>
                <svg style="width: 1rem; height: 1rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>
                </svg>
            </button>
            <button class="page-btn active">1</button>
            <button class="page-btn">2</button>
            <button class="page-btn">3</button>
            <button class="page-btn">...</button>
            <button class="page-btn">31</button>
            <button class="page-btn">
                <svg style="width: 1rem; height: 1rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                </svg>
            </button>
        </div>
    </div>
</div>

<script>
// Toggle filters
    function toggleFilters() {
        const container = document.getElementById('filtersContainer');
        container.style.display = container.style.display === 'none' ? 'block' : 'none';
    }

// Sort table
    function sortTable(column) {
        console.log('Sorting by:', column);
        // TODO: Implement sorting
    }

// Bulk actions
    function toggleSelectAll(checkbox) {
        const rowCheckboxes = document.querySelectorAll('.row-checkbox');
        rowCheckboxes.forEach(cb => cb.checked = checkbox.checked);
        updateBulkActions();
    }

    function updateBulkActions() {
        const checked = document.querySelectorAll('.row-checkbox:checked').length;
        const bulkBar = document.getElementById('bulkActions');
        const countSpan = document.getElementById('selectedCount');

        if (checked > 0) {
            bulkBar.classList.add('active');
            countSpan.textContent = checked;
        } else {
            bulkBar.classList.remove('active');
        }
    }

    function bulkChangeStage() {
        const selected = Array.from(document.querySelectorAll('.row-checkbox:checked')).length;
        if (selected === 0)
            return;
        alert(`Change stage for ${selected} opportunities`);
        // TODO: Implement bulk stage change
    }

    function bulkAssign() {
        const selected = Array.from(document.querySelectorAll('.row-checkbox:checked')).length;
        if (selected === 0)
            return;
        alert(`Assign ${selected} opportunities to...`);
        // TODO: Implement bulk assign
    }

    function bulkDelete() {
        const selected = Array.from(document.querySelectorAll('.row-checkbox:checked')).length;
        if (selected === 0)
            return;
        if (confirm(`Delete ${selected} opportunities? This action cannot be undone.`)) {
            alert('Deleting...');
            // TODO: Implement bulk delete
        }
    }

// Row actions
    function viewOpportunity(id) {
        window.location.href = '${pageContext.request.contextPath}/sale/opportunity/view/' + id;
    }

    function editOpportunity(id) {
        window.location.href = '${pageContext.request.contextPath}/sale/opportunity/edit/' + id;
    }

    function deleteOpportunity(id) {
        if (confirm('Delete this opportunity? This action cannot be undone.')) {
            console.log('Deleting opportunity:', id);
            // TODO: AJAX delete
            window.CRM.showNotification('Opportunity deleted', 'success');
        }
    }

    function openCreateModal() {
        window.location.href = '${pageContext.request.contextPath}/sale/opportunity/create';
    }

    function exportData() {
        console.log('Exporting data...');
        // TODO: Implement export
        window.CRM.showNotification('Export started', 'success');
    }
</script>