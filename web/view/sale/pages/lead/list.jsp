<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
    /* Statistics Cards */
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
        gap: 1.25rem;
        margin-bottom: 2rem;
    }

    .stat-card {
        background: white;
        border-radius: 1rem;
        border: 1px solid #e2e8f0;
        padding: 1.5rem;
        transition: all 0.2s;
    }

    .stat-card:hover {
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        transform: translateY(-2px);
    }

    .stat-header {
        display: flex;
        justify-content: space-between;
        align-items: start;
        margin-bottom: 1rem;
    }

    .stat-icon {
        width: 3rem;
        height: 3rem;
        border-radius: 0.75rem;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .stat-icon svg {
        width: 1.5rem;
        height: 1.5rem;
    }

    .stat-label {
        font-size: 0.875rem;
        color: #64748b;
        font-weight: 600;
    }

    .stat-value {
        font-size: 2rem;
        font-weight: 800;
        color: #1e293b;
        line-height: 1;
        margin-bottom: 0.5rem;
    }

    /* List Container */
    .list-container {
        background: white;
        border-radius: 1rem;
        border: 1px solid #e2e8f0;
        overflow: hidden;
    }

    .list-header {
        padding: 1.5rem;
        border-bottom: 1px solid #e2e8f0;
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 1rem;
    }

    .list-title {
        font-size: 1.375rem;
        font-weight: 800;
        color: #1e293b;
    }

    .list-actions {
        display: flex;
        gap: 0.75rem;
    }

    /* Buttons */
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

    .btn-icon {
        width: 1.125rem;
        height: 1.125rem;
    }

    /* Table */
    .leads-table {
        width: 100%;
        border-collapse: collapse;
    }

    .leads-table thead {
        background: #f8fafc;
    }

    .leads-table th {
        padding: 1rem 1.5rem;
        text-align: left;
        font-size: 0.75rem;
        font-weight: 700;
        color: #64748b;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        border-bottom: 1px solid #e2e8f0;
    }

    .leads-table td {
        padding: 1.25rem 1.5rem;
        border-bottom: 1px solid #f1f5f9;
        font-size: 0.875rem;
    }

    .leads-table tbody tr {
        transition: background 0.15s;
    }

    .leads-table tbody tr:hover {
        background: #f8fafc;
    }

    /* Badges */
    .badge {
        display: inline-flex;
        align-items: center;
        padding: 0.375rem 0.75rem;
        border-radius: 0.5rem;
        font-size: 0.75rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.025em;
    }

    .badge-new {
        background: linear-gradient(135deg, #dbeafe, #bfdbfe);
        color: #1e40af;
    }

    .badge-contacted {
        background: linear-gradient(135deg, #e0e7ff, #c7d2fe);
        color: #4338ca;
    }

    .badge-qualified {
        background: linear-gradient(135deg, #d1fae5, #a7f3d0);
        color: #047857;
    }

    .badge-converted {
        background: linear-gradient(135deg, #dcfce7, #bbf7d0);
        color: #15803d;
    }

    .badge-hot {
        background: linear-gradient(135deg, #fee2e2, #fecaca);
        color: #dc2626;
    }

    .badge-warm {
        background: linear-gradient(135deg, #fef3c7, #fde68a);
        color: #d97706;
    }

    .badge-cold {
        background: linear-gradient(135deg, #e0e7ff, #c7d2fe);
        color: #4f46e5;
    }

    .badge-default {
        background: #f1f5f9;
        color: #64748b;
    }

    /* Action Buttons */
    .action-buttons {
        display: flex;
        gap: 0.5rem;
    }

    .action-btn {
        padding: 0.5rem;
        border-radius: 0.5rem;
        border: 1px solid #e2e8f0;
        background: white;
        color: #64748b;
        cursor: pointer;
        transition: all 0.15s;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        text-decoration: none;
    }

    .action-btn:hover {
        background: #f8fafc;
        border-color: #cbd5e1;
        color: #475569;
    }

    .action-btn svg {
        width: 1rem;
        height: 1rem;
    }

    .action-btn-danger:hover {
        background: #fee2e2;
        border-color: #fecaca;
        color: #dc2626;
    }

    /* Empty State */
    .empty-state {
        padding: 4rem 2rem;
        text-align: center;
        color: #64748b;
    }

    .empty-icon {
        width: 5rem;
        height: 5rem;
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
        margin-bottom: 1.5rem;
    }

    /* Success Message */
    .success-message {
        background: linear-gradient(135deg, #d1fae5, #a7f3d0);
        color: #047857;
        padding: 1rem 1.25rem;
        border-radius: 0.75rem;
        margin-bottom: 1.5rem;
        display: flex;
        align-items: center;
        gap: 0.75rem;
        font-weight: 600;
        font-size: 0.875rem;
    }

    .success-icon {
        width: 1.25rem;
        height: 1.25rem;
        flex-shrink: 0;
    }

    /* Error Message */
    .error-message {
        background: linear-gradient(135deg, #fee2e2, #fecaca);
        color: #dc2626;
        padding: 1rem 1.25rem;
        border-radius: 0.75rem;
        margin-bottom: 1.5rem;
        display: flex;
        align-items: center;
        gap: 0.75rem;
        font-weight: 600;
        font-size: 0.875rem;
    }

    .error-icon {
        width: 1.25rem;
        height: 1.25rem;
        flex-shrink: 0;
    }
</style>

<!-- Success Message -->
<c:if test="${not empty successMessage}">
    <div class="success-message">
        <svg class="success-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
        </svg>
        <span>${successMessage}</span>
    </div>
</c:if>

<!-- Error Message -->
<c:if test="${param.error == 'no_permission'}">
    <div class="error-message">
        <svg class="error-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
        </svg>
        <span>You don't have permission to access this lead!</span>
    </div>
</c:if>
<c:if test="${param.error == 'delete_failed'}">
    <div class="error-message">
        <svg class="error-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
        </svg>
        <span>Failed to delete lead. Please try again.</span>
    </div>
</c:if>

<!-- Statistics Cards -->
<div class="stats-grid">
    <div class="stat-card">
        <div class="stat-header">
            <div>
                <div class="stat-label">Total Leads</div>
                <div class="stat-value">${totalLeads}</div>
            </div>
            <div class="stat-icon" style="background: linear-gradient(135deg, #dbeafe, #bfdbfe);">
                <svg style="color: #3b82f6;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                </svg>
            </div>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-header">
            <div>
                <div class="stat-label">New Leads</div>
                <div class="stat-value" style="color: #3b82f6;">${newLeads}</div>
            </div>
            <div class="stat-icon" style="background: linear-gradient(135deg, #e0e7ff, #c7d2fe);">
                <svg style="color: #6366f1;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M12 4v16m8-8H4"/>
                </svg>
            </div>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-header">
            <div>
                <div class="stat-label">Hot Leads</div>
                <div class="stat-value" style="color: #dc2626;">${hotLeads}</div>
            </div>
            <div class="stat-icon" style="background: linear-gradient(135deg, #fee2e2, #fecaca);">
                <svg style="color: #dc2626;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M17.657 18.657A8 8 0 016.343 7.343S7 9 9 10c0-2 .5-5 2.986-7C14 5 16.09 5.777 17.656 7.343A7.975 7.975 0 0120 13a7.975 7.975 0 01-2.343 5.657z"/>
                </svg>
            </div>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-header">
            <div>
                <div class="stat-label">Converted</div>
                <div class="stat-value" style="color: #16a34a;">${convertedLeads}</div>
            </div>
            <div class="stat-icon" style="background: linear-gradient(135deg, #d1fae5, #a7f3d0);">
                <svg style="color: #16a34a;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
            </div>
        </div>
    </div>
</div>

<!-- Leads List -->
<div class="list-container">
    <div class="list-header">
        <h2 class="list-title">All Leads</h2>
        <div class="list-actions">
            <a href="${pageContext.request.contextPath}/sale/lead/form" class="btn btn-primary">
                <svg class="btn-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                </svg>
                New Lead
            </a>
        </div>
    </div>

    <c:choose>
        <c:when test="${empty leadList}">
            <!-- Empty State -->
            <div class="empty-state">
                <svg class="empty-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                </svg>
                <div class="empty-title">No leads yet</div>
                <p class="empty-text">Get started by creating your first lead</p>
                <a href="${pageContext.request.contextPath}/sale/lead/form" class="btn btn-primary">
                    <svg class="btn-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                    </svg>
                    Create First Lead
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <!-- Leads Table -->
            <table class="leads-table">
                <thead>
                    <tr>
                        <th>Lead Code</th>
                        <th>Full Name</th>
                        <th>Email</th>
                        <th>Company</th>
                        <th>Status</th>
                        <th>Rating</th>
                        <th>Created</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="lead" items="${leadList}">
                        <tr>
                            <td><strong>${lead.leadCode}</strong></td>
                            <td>
                                <div style="font-weight: 600; color: #1e293b;">${lead.fullName}</div>
                                <c:if test="${not empty lead.jobTitle}">
                                    <div style="font-size: 0.75rem; color: #64748b;">${lead.jobTitle}</div>
                                </c:if>
                            </td>
                            <td style="color: #64748b;">${not empty lead.email ? lead.email : '-'}</td>
                            <td>${not empty lead.companyName ? lead.companyName : '-'}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${lead.status == 'New'}">
                                        <span class="badge badge-new">${lead.status}</span>
                                    </c:when>
                                    <c:when test="${lead.status == 'Contacted'}">
                                        <span class="badge badge-contacted">${lead.status}</span>
                                    </c:when>
                                    <c:when test="${lead.status == 'Qualified'}">
                                        <span class="badge badge-qualified">${lead.status}</span>
                                    </c:when>
                                    <c:when test="${lead.status == 'Converted'}">
                                        <span class="badge badge-converted">${lead.status}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-default">${lead.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${lead.rating == 'Hot'}">
                                        <span class="badge badge-hot">${lead.rating}</span>
                                    </c:when>
                                    <c:when test="${lead.rating == 'Warm'}">
                                        <span class="badge badge-warm">${lead.rating}</span>
                                    </c:when>
                                    <c:when test="${lead.rating == 'Cold'}">
                                        <span class="badge badge-cold">${lead.rating}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #94a3b8;">-</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="color: #64748b; font-size: 0.8125rem;">
                                <c:choose>
                                    <c:when test="${not empty lead.createdAt}">
                                        ${lead.createdAt.toString().substring(0, 10)}
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="action-buttons">
                                    <button onclick="viewLeadDetail(${lead.leadId})"
                                            class="action-btn"
                                            title="View Details">
                                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                  d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                  d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                                        </svg>
                                    </button>
                                    <a href="${pageContext.request.contextPath}/sale/lead/form?id=${lead.leadId}"
                                       class="action-btn"
                                       title="Edit">
                                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                  d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                        </svg>
                                    </a>
                                    <button onclick="deleteLead(${lead.leadId}, '${lead.fullName}')"
                                            class="action-btn action-btn-danger"
                                            title="Delete">
                                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                  d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                        </svg>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>

<!-- Lead Detail Modal -->
<div id="leadDetailModal" class="modal-overlay" style="display: none;">
    <div class="modal-container" style="max-width: 56rem;">
        <div class="modal-header">
            <h3 class="modal-title">Lead Details</h3>
            <button class="modal-close" onclick="closeLeadDetailModal()">
                <svg style="width: 1.5rem; height: 1.5rem; color: #64748b;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                </svg>
            </button>
        </div>

        <div class="modal-body" id="leadDetailContent" style="max-height: 70vh; overflow-y: auto;">
            <!-- Loading state -->
            <div id="leadDetailLoading" style="text-align: center; padding: 3rem; color: #64748b;">
                <svg style="width: 3rem; height: 3rem; margin: 0 auto 1rem; animation: spin 1s linear infinite; color: #3b82f6;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
                </svg>
                <p>Loading...</p>
            </div>

            <!-- Content will be loaded here -->
            <div id="leadDetailData" style="display: none;"></div>
        </div>

        <div class="modal-footer">
            <button onclick="closeLeadDetailModal()" class="btn btn-secondary">Close</button>
            <button onclick="editCurrentLead()" class="btn btn-primary" id="editLeadBtn">
                <svg class="btn-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                </svg>
                Edit Lead
            </button>
        </div>
    </div>
</div>

<style>
    @keyframes spin {
        from { transform: rotate(0deg); }
        to { transform: rotate(360deg); }
    }

    .modal-overlay {
        position: fixed;
        inset: 0;
        background: rgba(0, 0, 0, 0.6);
        backdrop-filter: blur(4px);
        z-index: 1000;
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
        border: none;
        background: transparent;
    }

    .modal-close:hover {
        background: #f1f5f9;
    }

    .modal-body {
        flex: 1;
        overflow-y: auto;
        padding: 1.5rem;
    }

    .modal-footer {
        padding: 1.25rem 1.5rem;
        border-top: 1px solid #e2e8f0;
        display: flex;
        justify-content: flex-end;
        gap: 0.75rem;
    }

    .detail-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 1.5rem;
    }

    .detail-field {
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
    }

    .detail-label {
        font-size: 0.75rem;
        font-weight: 600;
        color: #64748b;
        text-transform: uppercase;
        letter-spacing: 0.05em;
    }

    .detail-value {
        font-size: 0.9375rem;
        color: #1e293b;
        font-weight: 500;
    }

    .detail-section {
        margin-bottom: 2rem;
    }

    .section-title {
        font-size: 1rem;
        font-weight: 700;
        color: #1e293b;
        margin-bottom: 1rem;
        padding-bottom: 0.75rem;
        border-bottom: 2px solid #e2e8f0;
    }
</style>

<script>
    let currentLeadId = null;

    function viewLeadDetail(leadId) {
        currentLeadId = leadId;
        const modal = document.getElementById('leadDetailModal');
        const loading = document.getElementById('leadDetailLoading');
        const content = document.getElementById('leadDetailData');

        // Show modal and loading
        modal.style.display = 'flex';
        loading.style.display = 'block';
        content.style.display = 'none';

        // Fetch lead details
        fetch('${pageContext.request.contextPath}/sale/lead/detail?id=' + leadId + '&format=json')
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to load lead details');
                }
                return response.json();
            })
            .then(data => {
                displayLeadDetails(data);
                loading.style.display = 'none';
                content.style.display = 'block';
            })
            .catch(error => {
                loading.innerHTML = '<p style="color: #dc2626;">Error loading lead details: ' + error.message + '</p>';
            });
    }

    function displayLeadDetails(data) {
        const lead = data.lead;
        const content = document.getElementById('leadDetailData');

        let html = '';

        // Basic Information
        html += '<div class="detail-section">';
        html += '<h4 class="section-title">Basic Information</h4>';
        html += '<div class="detail-grid">';
        html += '<div class="detail-field"><span class="detail-label">Lead Code</span><span class="detail-value">' + (lead.leadCode || '-') + '</span></div>';
        html += '<div class="detail-field"><span class="detail-label">Full Name</span><span class="detail-value">' + (lead.fullName || '-') + '</span></div>';
        html += '<div class="detail-field"><span class="detail-label">Email</span><span class="detail-value">' + (lead.email || '-') + '</span></div>';
        html += '<div class="detail-field"><span class="detail-label">Phone</span><span class="detail-value">' + (lead.phone || '-') + '</span></div>';
        html += '<div class="detail-field"><span class="detail-label">Company</span><span class="detail-value">' + (lead.companyName || '-') + '</span></div>';
        html += '<div class="detail-field"><span class="detail-label">Job Title</span><span class="detail-value">' + (lead.jobTitle || '-') + '</span></div>';
        html += '</div>';
        html += '</div>';

        // Status & Source
        html += '<div class="detail-section">';
        html += '<h4 class="section-title">Status & Source</h4>';
        html += '<div class="detail-grid">';
        html += '<div class="detail-field"><span class="detail-label">Status</span><span class="detail-value">' + (lead.status || '-') + '</span></div>';
        html += '<div class="detail-field"><span class="detail-label">Rating</span><span class="detail-value">' + (lead.rating || '-') + '</span></div>';
        html += '<div class="detail-field"><span class="detail-label">Lead Score</span><span class="detail-value">' + (lead.leadScore || 0) + '</span></div>';
        html += '<div class="detail-field"><span class="detail-label">Source</span><span class="detail-value">' + (data.sourceName || '-') + '</span></div>';
        html += '<div class="detail-field"><span class="detail-label">Campaign</span><span class="detail-value">' + (data.campaignName || '-') + '</span></div>';
        html += '<div class="detail-field"><span class="detail-label">Converted</span><span class="detail-value">' + (lead.isConverted ? 'Yes' : 'No') + '</span></div>';
        html += '</div>';
        html += '</div>';

        // Additional Info
        if (lead.interests || lead.notes) {
            html += '<div class="detail-section">';
            html += '<h4 class="section-title">Additional Information</h4>';
            if (lead.interests) {
                html += '<div class="detail-field" style="margin-bottom: 1rem;"><span class="detail-label">Interests</span><span class="detail-value">' + lead.interests + '</span></div>';
            }
            if (lead.notes) {
                html += '<div class="detail-field"><span class="detail-label">Notes</span><span class="detail-value" style="white-space: pre-wrap;">' + lead.notes + '</span></div>';
            }
            html += '</div>';
        }

        // Timestamps
        html += '<div class="detail-section">';
        html += '<h4 class="section-title">Timeline</h4>';
        html += '<div class="detail-grid">';
        html += '<div class="detail-field"><span class="detail-label">Created At</span><span class="detail-value">' + (lead.createdAt ? lead.createdAt.substring(0, 19).replace('T', ' ') : '-') + '</span></div>';
        html += '<div class="detail-field"><span class="detail-label">Updated At</span><span class="detail-value">' + (lead.updatedAt ? lead.updatedAt.substring(0, 19).replace('T', ' ') : '-') + '</span></div>';
        html += '</div>';
        html += '</div>';

        content.innerHTML = html;
    }

    function closeLeadDetailModal() {
        document.getElementById('leadDetailModal').style.display = 'none';
        currentLeadId = null;
    }

    function editCurrentLead() {
        if (currentLeadId) {
            window.location.href = '${pageContext.request.contextPath}/sale/lead/form?id=' + currentLeadId;
        }
    }

    // Close modal on escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeLeadDetailModal();
        }
    });

    // Close modal on overlay click
    document.getElementById('leadDetailModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeLeadDetailModal();
        }
    });

    function deleteLead(leadId, leadName) {
        if (confirm('Are you sure you want to delete lead "' + leadName + '"? This action cannot be undone.')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/sale/lead/list';

            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'delete';

            const idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'leadId';
            idInput.value = leadId;

            form.appendChild(actionInput);
            form.appendChild(idInput);
            document.body.appendChild(form);
            form.submit();
        }
    }
</script>
