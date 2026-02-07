<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- Sortable.js for Drag & Drop -->
<script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>

<style>
    /* Kanban Styles */
    .kanban-container {
        display: flex;
        gap: 1.25rem;
        overflow-x: auto;
        padding-bottom: 1.5rem;
        min-height: calc(100vh - 280px);
    }

    .kanban-column {
        flex-shrink: 0;
        width: 340px;
        background: white;
        border-radius: 1rem;
        border: 1px solid #e2e8f0;
        display: flex;
        flex-direction: column;
        max-height: calc(100vh - 280px);
    }

    .column-header {
        padding: 1.25rem;
        border-bottom: 1px solid #e2e8f0;
        border-radius: 1rem 1rem 0 0;
    }

    .column-title {
        display: flex;
        align-items: center;
        gap: 0.625rem;
        margin-bottom: 0.75rem;
    }

    .stage-indicator {
        width: 0.875rem;
        height: 0.875rem;
        border-radius: 50%;
        flex-shrink: 0;
    }

    .stage-badge {
        padding: 0.25rem 0.75rem;
        border-radius: 1rem;
        font-size: 0.75rem;
        font-weight: 700;
        color: white;
    }

    .column-stats {
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-size: 0.8125rem;
        color: #64748b;
    }

    .cards-container {
        flex: 1;
        padding: 1rem;
        overflow-y: auto;
        display: flex;
        flex-direction: column;
        gap: 0.875rem;
    }

    /* Opportunity Card */
    .opportunity-card {
        background: white;
        border: 1px solid #e2e8f0;
        border-radius: 0.875rem;
        padding: 1.125rem;
        cursor: move;
        transition: all 0.2s;
    }

    .opportunity-card:hover {
        box-shadow: 0 8px 24px rgba(59, 130, 246, 0.15);
        transform: translateY(-2px);
        border-color: #60a5fa;
    }

    .sortable-ghost {
        opacity: 0.4;
        background: #f1f5f9;
    }

    .sortable-drag {
        opacity: 0.8;
    }

    .card-header {
        display: flex;
        justify-content: space-between;
        align-items: start;
        margin-bottom: 0.875rem;
    }

    .priority-badge {
        padding: 0.25rem 0.625rem;
        border-radius: 0.5rem;
        font-size: 0.6875rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.025em;
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

    .card-actions {
        display: flex;
        gap: 0.25rem;
    }

    .card-action-btn {
        padding: 0.375rem;
        border-radius: 0.375rem;
        transition: background 0.15s;
        cursor: pointer;
    }

    .card-action-btn:hover {
        background: #f1f5f9;
    }

    .card-title {
        font-weight: 700;
        color: #1e293b;
        font-size: 0.9375rem;
        margin-bottom: 0.375rem;
        line-height: 1.4;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }

    .card-subtitle {
        font-size: 0.8125rem;
        color: #64748b;
        margin-bottom: 0.875rem;
    }

    .card-value-section {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 0.875rem;
    }

    .card-value {
        font-size: 1.25rem;
        font-weight: 800;
        color: #1e293b;
    }

    .card-probability {
        display: flex;
        align-items: center;
        gap: 0.375rem;
        font-size: 0.75rem;
        color: #64748b;
        background: #f8fafc;
        padding: 0.25rem 0.625rem;
        border-radius: 0.5rem;
    }

    .card-meta {
        padding-top: 0.875rem;
        border-top: 1px solid #f1f5f9;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .card-owner {
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .owner-avatar {
        width: 1.75rem;
        height: 1.75rem;
        border-radius: 0.5rem;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: 700;
        font-size: 0.6875rem;
    }

    .owner-name {
        font-size: 0.8125rem;
        color: #475569;
        font-weight: 500;
    }

    .card-date {
        display: flex;
        align-items: center;
        gap: 0.375rem;
        font-size: 0.75rem;
        color: #64748b;
    }

    .card-tags {
        margin-top: 0.875rem;
        display: flex;
        flex-wrap: wrap;
        gap: 0.375rem;
    }

    .tag {
        padding: 0.25rem 0.625rem;
        border-radius: 0.5rem;
        font-size: 0.6875rem;
        font-weight: 600;
    }

    /* Add Card Button */
    .add-card-btn {
        margin: 1rem;
        padding: 0.875rem;
        border: 2px dashed #cbd5e1;
        border-radius: 0.75rem;
        color: #64748b;
        font-weight: 600;
        transition: all 0.2s;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
    }

    .add-card-btn:hover {
        border-color: #60a5fa;
        color: #3b82f6;
        background: #f8fafc;
    }

    /* Filter Panel */
    .filter-panel {
        background: white;
        border-radius: 1rem;
        border: 1px solid #e2e8f0;
        padding: 1.5rem;
        margin-bottom: 1.5rem;
    }

    .filter-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        gap: 1rem;
        margin-top: 1.5rem;
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

    /* Header Stats */
    .pipeline-header {
        background: white;
        border-radius: 1rem;
        border: 1px solid #e2e8f0;
        padding: 1.5rem;
        margin-bottom: 1.5rem;
    }

    .header-top {
        display: flex;
        justify-content: space-between;
        align-items: start;
        flex-wrap: wrap;
        gap: 1.5rem;
    }

    .header-title {
        font-size: 1.75rem;
        font-weight: 800;
        color: #1e293b;
        margin-bottom: 0.75rem;
    }

    .header-stats {
        display: flex;
        flex-wrap: wrap;
        gap: 1.5rem;
        font-size: 0.875rem;
    }

    .stat-item {
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .stat-label {
        color: #64748b;
    }

    .stat-value {
        font-weight: 700;
        font-size: 1rem;
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
        display: flex;
        align-items: center;
        gap: 0.5rem;
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

    .btn-primary {
        background: linear-gradient(135deg, #60a5fa, #3b82f6);
        color: white;
        border: none;
        box-shadow: 0 2px 8px rgba(59, 130, 246, 0.25);
    }

    .btn-primary:hover {
        box-shadow: 0 4px 16px rgba(59, 130, 246, 0.35);
        transform: translateY(-1px);
    }

    /* Modal */
    .modal-overlay {
        position: fixed;
        inset: 0;
        background: rgba(0, 0, 0, 0.6);
        backdrop-filter: blur(4px);
        z-index: 50;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 1rem;
    }

    .modal-container {
        background: white;
        border-radius: 1.25rem;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        max-width: 48rem;
        width: 100%;
        max-height: 90vh;
        overflow: hidden;
        display: flex;
        flex-direction: column;
    }

    .modal-header {
        padding: 1.5rem;
        border-bottom: 1px solid #e2e8f0;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .modal-title {
        font-size: 1.375rem;
        font-weight: 800;
        color: #1e293b;
    }

    .modal-close {
        padding: 0.5rem;
        border-radius: 0.5rem;
        transition: background 0.15s;
        cursor: pointer;
    }

    .modal-close:hover {
        background: #f1f5f9;
    }

    .modal-body {
        flex: 1;
        overflow-y: auto;
        padding: 1.5rem;
    }

    .form-section {
        margin-bottom: 2rem;
    }

    .section-title {
        font-size: 1rem;
        font-weight: 700;
        color: #1e293b;
        margin-bottom: 1rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .form-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        gap: 1.25rem;
    }

    .form-field {
        display: flex;
        flex-direction: column;
    }

    .form-label {
        font-size: 0.875rem;
        font-weight: 600;
        color: #475569;
        margin-bottom: 0.5rem;
    }

    .form-input {
        padding: 0.75rem 1rem;
        border: 1px solid #e2e8f0;
        border-radius: 0.625rem;
        font-size: 0.875rem;
        transition: all 0.2s;
    }

    .form-input:focus {
        outline: none;
        border-color: #60a5fa;
        box-shadow: 0 0 0 3px rgba(96, 165, 250, 0.1);
    }

    .form-textarea {
        resize: vertical;
        min-height: 100px;
    }

    .modal-footer {
        padding: 1.25rem 1.5rem;
        border-top: 1px solid #e2e8f0;
        display: flex;
        justify-content: flex-end;
        gap: 0.75rem;
    }
</style>

<!-- Pipeline Header -->
<div class="pipeline-header">
    <div class="header-top">
        <div>
            <h2 class="header-title">Sales Pipeline</h2>
            <div class="header-stats">
                <div class="stat-item">
                    <span class="stat-label">Total Opportunities:</span>
                    <span class="stat-value" style="color: #3b82f6;">156</span>
                </div>
                <span style="color: #e2e8f0;">|</span>
                <div class="stat-item">
                    <span class="stat-label">Pipeline Value:</span>
                    <span class="stat-value" style="color: #10b981;">$2,450,000</span>
                </div>
                <span style="color: #e2e8f0;">|</span>
                <div class="stat-item">
                    <span class="stat-label">Expected Close:</span>
                    <span class="stat-value" style="color: #fb923c;">$1,820,000</span>
                </div>
            </div>
        </div>

        <div class="header-actions">
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

<!-- Filters Panel -->
<div id="filtersPanel" class="filter-panel" style="display: none;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
        <h3 style="font-size: 1.125rem; font-weight: 700; color: #1e293b;">Filter Opportunities</h3>
        <button onclick="toggleFilters()" style="color: #64748b;">
            <svg style="width: 1.25rem; height: 1.25rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
            </svg>
        </button>
    </div>

    <form method="GET" action="${pageContext.request.contextPath}/sales/pipeline">
        <div class="filter-grid">
            <div class="filter-field">
                <label>Search</label>
                <input type="text" name="search" class="filter-input" placeholder="Company or deal name...">
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
                <label>Priority</label>
                <select name="priority" class="filter-input">
                    <option value="">All Priorities</option>
                    <option value="high">High</option>
                    <option value="medium">Medium</option>
                    <option value="low">Low</option>
                </select>
            </div>

            <div class="filter-field">
                <label>Min Value</label>
                <input type="number" name="minValue" class="filter-input" placeholder="$0">
            </div>

            <div class="filter-field">
                <label>Max Value</label>
                <input type="number" name="maxValue" class="filter-input" placeholder="$1,000,000">
            </div>
        </div>

        <div style="display: flex; gap: 0.75rem; margin-top: 1.5rem;">
            <button type="submit" class="btn btn-primary">Apply Filters</button>
            <a href="${pageContext.request.contextPath}/sales/pipeline" class="btn btn-secondary">Clear All</a>
        </div>
    </form>
</div>

<!-- Kanban Board -->
<div class="kanban-container">

    <!-- Stage 1: Prospecting -->
    <div class="kanban-column">
        <div class="column-header" style="background: linear-gradient(135deg, #dbeafe, #bfdbfe);">
            <div class="column-title">
                <span class="stage-indicator" style="background: #3b82f6;"></span>
                <h4 style="font-weight: 700; color: #1e293b; flex: 1;">Prospecting</h4>
                <span class="stage-badge" style="background: #3b82f6;">45</span>
            </div>
            <div class="column-stats">
                <span>Total: <strong style="color: #3b82f6;">$450K</strong></span>
                <span style="color: #94a3b8;">18.4%</span>
            </div>
        </div>

        <div class="cards-container" id="prospecting-column" data-stage="prospecting">

            <!-- Card 1 -->
            <div class="opportunity-card" data-opportunity-id="1">
                <div class="card-header">
                    <span class="priority-badge priority-high">High Priority</span>
                    <div class="card-actions">
                        <div class="card-action-btn" onclick="editOpportunity(1)">
                            <svg style="width: 1rem; height: 1rem; color: #64748b;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                            </svg>
                        </div>
                        <div class="card-action-btn" onclick="openCardMenu(1)">
                            <svg style="width: 1rem; height: 1rem; color: #64748b;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 5v.01M12 12v.01M12 19v.01M12 6a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2z"/>
                            </svg>
                        </div>
                    </div>
                </div>

                <h5 class="card-title">Enterprise ERP Solution - ABC Corp</h5>
                <p class="card-subtitle">Software Implementation</p>

                <div class="card-value-section">
                    <span class="card-value">$85,000</span>
                    <div class="card-probability">
                        <svg style="width: 0.875rem; height: 0.875rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/>
                        </svg>
                        30%
                    </div>
                </div>

                <div class="card-meta">
                    <div class="card-owner">
                        <div class="owner-avatar" style="background: linear-gradient(135deg, #60a5fa, #3b82f6);">
                            JD
                        </div>
                        <span class="owner-name">John Doe</span>
                    </div>
                    <div class="card-date">
                        <svg style="width: 0.875rem; height: 0.875rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                        </svg>
                        Feb 28
                    </div>
                </div>

                <div class="card-tags">
                    <span class="tag" style="background: #f3e8ff; color: #7c3aed;">Enterprise</span>
                    <span class="tag" style="background: #dcfce7; color: #16a34a;">Hot Lead</span>
                </div>
            </div>

            <!-- Card 2 -->
            <div class="opportunity-card" data-opportunity-id="2">
                <div class="card-header">
                    <span class="priority-badge priority-medium">Medium</span>
                    <div class="card-actions">
                        <div class="card-action-btn" onclick="editOpportunity(2)">
                            <svg style="width: 1rem; height: 1rem; color: #64748b;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                            </svg>
                        </div>
                        <div class="card-action-btn" onclick="openCardMenu(2)">
                            <svg style="width: 1rem; height: 1rem; color: #64748b;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 5v.01M12 12v.01M12 19v.01M12 6a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2z"/>
                            </svg>
                        </div>
                    </div>
                </div>

                <h5 class="card-title">Cloud Migration Project - Tech Startup</h5>
                <p class="card-subtitle">Infrastructure Services</p>

                <div class="card-value-section">
                    <span class="card-value">$45,000</span>
                    <div class="card-probability">
                        <svg style="width: 0.875rem; height: 0.875rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/>
                        </svg>
                        25%
                    </div>
                </div>

                <div class="card-meta">
                    <div class="card-owner">
                        <div class="owner-avatar" style="background: linear-gradient(135deg, #a78bfa, #7c3aed);">
                            JS
                        </div>
                        <span class="owner-name">Jane Smith</span>
                    </div>
                    <div class="card-date">
                        <svg style="width: 0.875rem; height: 0.875rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                        </svg>
                        Mar 15
                    </div>
                </div>

                <div class="card-tags">
                    <span class="tag" style="background: #dbeafe; color: #2563eb;">Startup</span>
                    <span class="tag" style="background: #fef3c7; color: #d97706;">New Market</span>
                </div>
            </div>

            <!-- Card 3 -->
            <div class="opportunity-card" data-opportunity-id="3">
                <div class="card-header">
                    <span class="priority-badge priority-low">Low</span>
                    <div class="card-actions">
                        <div class="card-action-btn" onclick="editOpportunity(3)">
                            <svg style="width: 1rem; height: 1rem; color: #64748b;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                            </svg>
                        </div>
                        <div class="card-action-btn" onclick="openCardMenu(3)">
                            <svg style="width: 1rem; height: 1rem; color: #64748b;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 5v.01M12 12v.01M12 19v.01M12 6a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2z"/>
                            </svg>
                        </div>
                    </div>
                </div>

                <h5 class="card-title">Marketing Automation - XYZ Ltd</h5>
                <p class="card-subtitle">SaaS Subscription</p>

                <div class="card-value-section">
                    <span class="card-value">$28,000</span>
                    <div class="card-probability">
                        <svg style="width: 0.875rem; height: 0.875rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/>
                        </svg>
                        20%
                    </div>
                </div>

                <div class="card-meta">
                    <div class="card-owner">
                        <div class="owner-avatar" style="background: linear-gradient(135deg, #fb923c, #f97316);">
                            MJ
                        </div>
                        <span class="owner-name">Mike Johnson</span>
                    </div>
                    <div class="card-date">
                        <svg style="width: 0.875rem; height: 0.875rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                        </svg>
                        Apr 10
                    </div>
                </div>

                <div class="card-tags">
                    <span class="tag" style="background: #ffe4e6; color: #be123c;">SMB</span>
                </div>
            </div>

        </div>

        <button class="add-card-btn" onclick="openCreateModalInStage('prospecting')">
            <svg style="width: 1.125rem; height: 1.125rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
            </svg>
            Add Deal
        </button>
    </div>

    <!-- Stage 2: Qualification -->
    <div class="kanban-column">
        <div class="column-header" style="background: linear-gradient(135deg, #e0e7ff, #c7d2fe);">
            <div class="column-title">
                <span class="stage-indicator" style="background: #6366f1;"></span>
                <h4 style="font-weight: 700; color: #1e293b; flex: 1;">Qualification</h4>
                <span class="stage-badge" style="background: #6366f1;">38</span>
            </div>
            <div class="column-stats">
                <span>Total: <strong style="color: #6366f1;">$580K</strong></span>
                <span style="color: #94a3b8;">23.7%</span>
            </div>
        </div>

        <div class="cards-container" id="qualification-column" data-stage="qualification">
            <!-- Add more cards here -->
        </div>

        <button class="add-card-btn" onclick="openCreateModalInStage('qualification')">
            <svg style="width: 1.125rem; height: 1.125rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
            </svg>
            Add Deal
        </button>
    </div>

    <!-- Stage 3: Proposal -->
    <div class="kanban-column">
        <div class="column-header" style="background: linear-gradient(135deg, #f3e8ff, #e9d5ff);">
            <div class="column-title">
                <span class="stage-indicator" style="background: #a855f7;"></span>
                <h4 style="font-weight: 700; color: #1e293b; flex: 1;">Proposal</h4>
                <span class="stage-badge" style="background: #a855f7;">28</span>
            </div>
            <div class="column-stats">
                <span>Total: <strong style="color: #a855f7;">$620K</strong></span>
                <span style="color: #94a3b8;">25.3%</span>
            </div>
        </div>

        <div class="cards-container" id="proposal-column" data-stage="proposal">
            <!-- Add more cards here -->
        </div>

        <button class="add-card-btn" onclick="openCreateModalInStage('proposal')">
            <svg style="width: 1.125rem; height: 1.125rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
            </svg>
            Add Deal
        </button>
    </div>

    <!-- Stage 4: Negotiation -->
    <div class="kanban-column">
        <div class="column-header" style="background: linear-gradient(135deg, #fed7aa, #fdba74);">
            <div class="column-title">
                <span class="stage-indicator" style="background: #fb923c;"></span>
                <h4 style="font-weight: 700; color: #1e293b; flex: 1;">Negotiation</h4>
                <span class="stage-badge" style="background: #fb923c;">23</span>
            </div>
            <div class="column-stats">
                <span>Total: <strong style="color: #fb923c;">$480K</strong></span>
                <span style="color: #94a3b8;">19.6%</span>
            </div>
        </div>

        <div class="cards-container" id="negotiation-column" data-stage="negotiation">
            <!-- Add more cards here -->
        </div>

        <button class="add-card-btn" onclick="openCreateModalInStage('negotiation')">
            <svg style="width: 1.125rem; height: 1.125rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
            </svg>
            Add Deal
        </button>
    </div>

    <!-- Stage 5: Closing -->
    <div class="kanban-column">
        <div class="column-header" style="background: linear-gradient(135deg, #d1fae5, #a7f3d0);">
            <div class="column-title">
                <span class="stage-indicator" style="background: #10b981;"></span>
                <h4 style="font-weight: 700; color: #1e293b; flex: 1;">Closing</h4>
                <span class="stage-badge" style="background: #10b981;">22</span>
            </div>
            <div class="column-stats">
                <span>Total: <strong style="color: #10b981;">$320K</strong></span>
                <span style="color: #94a3b8;">13.0%</span>
            </div>
        </div>

        <div class="cards-container" id="closing-column" data-stage="closing">
            <!-- Add more cards here -->
        </div>

        <button class="add-card-btn" onclick="openCreateModalInStage('closing')">
            <svg style="width: 1.125rem; height: 1.125rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
            </svg>
            Add Deal
        </button>
    </div>

</div>

<!-- Create/Edit Modal -->
<div id="opportunityModal" class="modal-overlay" style="display: none;">
    <div class="modal-container">
        <div class="modal-header">
            <h3 class="modal-title" id="modalTitle">Create New Opportunity</h3>
            <button class="modal-close" onclick="closeModal()">
                <svg style="width: 1.5rem; height: 1.5rem; color: #64748b;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                </svg>
            </button>
        </div>

        <div class="modal-body">
            <form id="opportunityForm">
                <input type="hidden" id="opportunityId" name="opportunityId">

                <!-- Deal Information -->
                <div class="form-section">
                    <h4 class="section-title">
                        <svg style="width: 1.125rem; height: 1.125rem; color: #3b82f6;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                        </svg>
                        Deal Information
                    </h4>

                    <div class="form-grid">
                        <div class="form-field">
                            <label class="form-label">Deal Name *</label>
                            <input type="text" name="dealName" class="form-input" placeholder="e.g., Enterprise Solution" required>
                        </div>

                        <div class="form-field">
                            <label class="form-label">Company Name *</label>
                            <input type="text" name="companyName" class="form-input" placeholder="e.g., Acme Corp" required>
                        </div>

                        <div class="form-field">
                            <label class="form-label">Deal Value ($) *</label>
                            <input type="number" name="dealValue" class="form-input" placeholder="85000" required>
                        </div>

                        <div class="form-field">
                            <label class="form-label">Expected Close *</label>
                            <input type="date" name="closeDate" class="form-input" required>
                        </div>

                        <div class="form-field">
                            <label class="form-label">Probability (%)</label>
                            <input type="number" name="probability" class="form-input" min="0" max="100" placeholder="30">
                        </div>

                        <div class="form-field">
                            <label class="form-label">Priority *</label>
                            <select name="priority" class="form-input" required>
                                <option value="low">Low Priority</option>
                                <option value="medium" selected>Medium Priority</option>
                                <option value="high">High Priority</option>
                            </select>
                        </div>

                        <div class="form-field">
                            <label class="form-label">Sales Rep *</label>
                            <select name="salesRep" class="form-input" required>
                                <option value="john">John Doe</option>
                                <option value="jane">Jane Smith</option>
                                <option value="mike">Mike Johnson</option>
                            </select>
                        </div>

                        <div class="form-field">
                            <label class="form-label">Stage *</label>
                            <select name="stage" id="stageSelect" class="form-input" required>
                                <option value="prospecting">Prospecting</option>
                                <option value="qualification">Qualification</option>
                                <option value="proposal">Proposal</option>
                                <option value="negotiation">Negotiation</option>
                                <option value="closing">Closing</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-field" style="margin-top: 1.25rem;">
                        <label class="form-label">Description</label>
                        <textarea name="description" class="form-input form-textarea" placeholder="Brief description of the opportunity..."></textarea>
                    </div>
                </div>

                <!-- Contact Information -->
                <div class="form-section">
                    <h4 class="section-title">
                        <svg style="width: 1.125rem; height: 1.125rem; color: #a855f7;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                        </svg>
                        Contact Information
                    </h4>

                    <div class="form-grid">
                        <div class="form-field">
                            <label class="form-label">Contact Name</label>
                            <input type="text" name="contactName" class="form-input" placeholder="e.g., John Smith">
                        </div>

                        <div class="form-field">
                            <label class="form-label">Contact Email</label>
                            <input type="email" name="contactEmail" class="form-input" placeholder="john@example.com">
                        </div>

                        <div class="form-field">
                            <label class="form-label">Contact Phone</label>
                            <input type="tel" name="contactPhone" class="form-input" placeholder="+1 (555) 123-4567">
                        </div>

                        <div class="form-field">
                            <label class="form-label">Contact Role</label>
                            <input type="text" name="contactRole" class="form-input" placeholder="e.g., CTO">
                        </div>
                    </div>
                </div>

                <!-- Tags -->
                <div class="form-section" style="margin-bottom: 0;">
                    <div class="form-field">
                        <label class="form-label">Tags</label>
                        <input type="text" name="tags" class="form-input" placeholder="Enterprise, Hot Lead, etc. (comma-separated)">
                    </div>
                </div>
            </form>
        </div>

        <div class="modal-footer">
            <button onclick="closeModal()" class="btn btn-secondary">Cancel</button>
            <button onclick="saveOpportunity()" class="btn btn-primary">Save Opportunity</button>
        </div>
    </div>
</div>

<script>
// Initialize Sortable
    document.addEventListener('DOMContentLoaded', function () {
        const stages = ['prospecting', 'qualification', 'proposal', 'negotiation', 'closing'];

        stages.forEach(stage => {
            const column = document.getElementById(stage + '-column');
            if (column) {
                new Sortable(column, {
                    group: 'pipeline',
                    animation: 200,
                    ghostClass: 'sortable-ghost',
                    dragClass: 'sortable-drag',
                    easing: 'cubic-bezier(0.4, 0, 0.2, 1)',
                    onEnd: function (evt) {
                        const oppId = evt.item.getAttribute('data-opportunity-id');
                        const newStage = evt.to.getAttribute('data-stage');
                        updateStage(oppId, newStage);
                    }
                });
            }
        });
    });

// Toggle filters
    function toggleFilters() {
        const panel = document.getElementById('filtersPanel');
        const isHidden = panel.style.display === 'none';
        panel.style.display = isHidden ? 'block' : 'none';
    }

// Open modal
    function openCreateModal() {
        document.getElementById('modalTitle').textContent = 'Create New Opportunity';
        document.getElementById('opportunityForm').reset();
        document.getElementById('opportunityId').value = '';
        document.getElementById('opportunityModal').style.display = 'flex';
    }

    function openCreateModalInStage(stage) {
        openCreateModal();
        document.getElementById('stageSelect').value = stage;
    }

    function closeModal() {
        document.getElementById('opportunityModal').style.display = 'none';
    }

// Edit opportunity
    function editOpportunity(id) {
        document.getElementById('modalTitle').textContent = 'Edit Opportunity';
        document.getElementById('opportunityId').value = id;
        document.getElementById('opportunityModal').style.display = 'flex';
        // TODO: Load data via AJAX
    }

// Card menu
    function openCardMenu(id) {
        alert('Options for opportunity ' + id);
        // TODO: Implement context menu
    }

// Update stage
    function updateStage(oppId, newStage) {
        console.log('Moving opportunity', oppId, 'to', newStage);
        // TODO: AJAX call to update
        window.CRM.showNotification('Opportunity moved to ' + newStage, 'success');
    }

// Save opportunity
    function saveOpportunity() {
        const form = document.getElementById('opportunityForm');
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        const formData = new FormData(form);
        console.log('Saving opportunity...', Object.fromEntries(formData));

        // TODO: AJAX call to save
        closeModal();
        window.CRM.showNotification('Opportunity saved successfully', 'success');
    }

// Close modal on escape
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') {
            closeModal();
        }
    });

// Close modal on overlay click
    document.getElementById('opportunityModal').addEventListener('click', function (e) {
        if (e.target === this) {
            closeModal();
        }
    });
</script>
