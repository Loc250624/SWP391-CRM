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

    .card-code {
        font-size: 0.75rem;
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
        color: #10b981;
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
        font-size: 0.75rem;
        color: #64748b;
    }

    .empty-column {
        text-align: center;
        padding: 2rem 1rem;
        color: #94a3b8;
        font-size: 0.875rem;
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
        background: white;
    }

    .add-card-btn:hover {
        border-color: #60a5fa;
        color: #3b82f6;
        background: #f8fafc;
    }

    /* Pipeline Selector */
    .pipeline-selector {
        background: white;
        border-radius: 1rem;
        border: 1px solid #e2e8f0;
        padding: 1.25rem;
        margin-bottom: 1.5rem;
    }

    .pipeline-selector label {
        display: block;
        font-size: 0.875rem;
        font-weight: 600;
        color: #475569;
        margin-bottom: 0.5rem;
    }

    .pipeline-selector select {
        width: 100%;
        max-width: 400px;
        padding: 0.625rem 0.875rem;
        border: 1px solid #e2e8f0;
        border-radius: 0.5rem;
        font-size: 0.875rem;
        transition: all 0.2s;
    }

    .pipeline-selector select:focus {
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
        text-decoration: none;
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

    /* Alert Messages */
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

    .alert-info {
        background: linear-gradient(135deg, #dbeafe, #bfdbfe);
        color: #1e40af;
    }

    .alert-warning {
        background: linear-gradient(135deg, #fef3c7, #fde68a);
        color: #d97706;
    }
</style>

<!-- Pipeline Header -->
<div class="pipeline-header">
    <div class="header-top">
        <div>
            <h2 class="header-title">Pipeline Kanban View</h2>
            <div class="header-stats">
                <div class="stat-item">
                    <span class="stat-label">Total Opportunities:</span>
                    <span class="stat-value" style="color: #3b82f6;">${totalOpportunities}</span>
                </div>
                <span style="color: #e2e8f0;">|</span>
                <div class="stat-item">
                    <span class="stat-label">Pipeline Value:</span>
                    <span class="stat-value" style="color: #10b981;">
                        <fmt:formatNumber value="${totalPipelineValue}" type="currency" currencySymbol="$" maxFractionDigits="0"/>
                    </span>
                </div>
                <span style="color: #e2e8f0;">|</span>
                <div class="stat-item">
                    <span class="stat-label">Stages:</span>
                    <span class="stat-value" style="color: #a855f7;">${stages.size()}</span>
                </div>
            </div>
        </div>

        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/sale/opportunity/list" class="btn btn-secondary">
                <svg style="width: 1.125rem; height: 1.125rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 10h16M4 14h16M4 18h16"/>
                </svg>
                List View
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

<!-- Pipeline Selector -->
<div class="pipeline-selector">
    <label>Select Pipeline</label>
    <form method="GET" action="${pageContext.request.contextPath}/sale/opportunity/kanban">
        <select name="pipeline" onchange="this.form.submit()">
            <c:forEach var="pipeline" items="${allPipelines}">
                <option value="${pipeline.pipelineId}"
                        <c:if test="${selectedPipeline.pipelineId == pipeline.pipelineId}">selected</c:if>>
                    ${pipeline.pipelineName}
                </option>
            </c:forEach>
        </select>
    </form>
</div>

<!-- Kanban Board -->
<c:choose>
    <c:when test="${empty selectedPipeline}">
        <div class="alert alert-warning">
            <svg style="width: 1.25rem; height: 1.25rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
            </svg>
            <span>No pipeline found. Please create a pipeline first.</span>
        </div>
    </c:when>
    <c:when test="${empty stages}">
        <div class="alert alert-info">
            <svg style="width: 1.25rem; height: 1.25rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
            </svg>
            <span>No stages defined for this pipeline. Please add stages first.</span>
        </div>
    </c:when>
    <c:otherwise>
        <div class="kanban-container">
            <c:forEach var="stage" items="${stages}" varStatus="status">
                <div class="kanban-column">
                    <!-- Column Header -->
                    <div class="column-header" style="background: ${not empty stage.colorCode ? stage.colorCode : (status.index % 5 == 0 ? 'linear-gradient(135deg, #dbeafe, #bfdbfe)' : status.index % 5 == 1 ? 'linear-gradient(135deg, #e0e7ff, #c7d2fe)' : status.index % 5 == 2 ? 'linear-gradient(135deg, #f3e8ff, #e9d5ff)' : status.index % 5 == 3 ? 'linear-gradient(135deg, #fed7aa, #fdba74)' : 'linear-gradient(135deg, #d1fae5, #a7f3d0)')};">
                        <div class="column-title">
                            <span class="stage-indicator" style="background: ${not empty stage.colorCode ? stage.colorCode : (status.index % 5 == 0 ? '#3b82f6' : status.index % 5 == 1 ? '#6366f1' : status.index % 5 == 2 ? '#a855f7' : status.index % 5 == 3 ? '#fb923c' : '#10b981')};"></span>
                            <h4 style="font-weight: 700; color: #1e293b; flex: 1;">${stage.stageName}</h4>
                            <span class="stage-badge" style="background: ${not empty stage.colorCode ? stage.colorCode : (status.index % 5 == 0 ? '#3b82f6' : status.index % 5 == 1 ? '#6366f1' : status.index % 5 == 2 ? '#a855f7' : status.index % 5 == 3 ? '#fb923c' : '#10b981')};">
                                ${opportunitiesByStage[stage.stageId].size()}
                            </span>
                        </div>
                        <div class="column-stats">
                            <span>Total: <strong style="color: ${not empty stage.colorCode ? stage.colorCode : (status.index % 5 == 0 ? '#3b82f6' : status.index % 5 == 1 ? '#6366f1' : status.index % 5 == 2 ? '#a855f7' : status.index % 5 == 3 ? '#fb923c' : '#10b981')};">
                                <fmt:formatNumber value="${valueByStage[stage.stageId]}" type="currency" currencySymbol="$" maxFractionDigits="0"/>
                            </strong></span>
                        </div>
                    </div>

                    <!-- Cards Container -->
                    <div class="cards-container" id="stage-${stage.stageId}-column" data-stage-id="${stage.stageId}">
                        <c:choose>
                            <c:when test="${empty opportunitiesByStage[stage.stageId]}">
                                <div class="empty-column">
                                    <svg style="width: 2rem; height: 2rem; margin: 0 auto 0.5rem; display: block;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"/>
                                    </svg>
                                    No opportunities
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="opp" items="${opportunitiesByStage[stage.stageId]}">
                                    <div class="opportunity-card" data-opportunity-id="${opp.opportunityId}">
                                        <h5 class="card-title">${opp.opportunityName}</h5>
                                        <div class="card-code">${opp.opportunityCode}</div>

                                        <div class="card-value-section">
                                            <span class="card-value">
                                                <fmt:formatNumber value="${opp.estimatedValue}" type="currency" currencySymbol="$" maxFractionDigits="0"/>
                                            </span>
                                            <div class="card-probability">
                                                <svg style="width: 0.875rem; height: 0.875rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/>
                                                </svg>
                                                ${opp.probability}%
                                            </div>
                                        </div>

                                        <div class="card-meta">
                                            <span>
                                                <c:if test="${not empty opp.expectedCloseDate}">
                                                    <svg style="width: 0.875rem; height: 0.875rem; display: inline;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                                                    </svg>
                                                    ${opp.expectedCloseDate}
                                                </c:if>
                                                <c:if test="${empty opp.expectedCloseDate}">
                                                    No close date
                                                </c:if>
                                            </span>
                                            <span style="font-weight: 600; color: ${opp.status == 'Open' ? '#3b82f6' : opp.status == 'Won' ? '#10b981' : '#ef4444'};">${opp.status}</span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Add Card Button -->
                    <a href="${pageContext.request.contextPath}/sale/opportunity/form?pipelineId=${selectedPipeline.pipelineId}&stageId=${stage.stageId}" class="add-card-btn">
                        <svg style="width: 1.125rem; height: 1.125rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                        </svg>
                        Add Deal
                    </a>
                </div>
            </c:forEach>
        </div>
    </c:otherwise>
</c:choose>

<script>
// Initialize Sortable with dynamic stages
document.addEventListener('DOMContentLoaded', function () {
    <c:if test="${not empty stages}">
        // Initialize Sortable for each stage column
        <c:forEach var="stage" items="${stages}">
            const column_${stage.stageId} = document.getElementById('stage-${stage.stageId}-column');
            if (column_${stage.stageId}) {
                new Sortable(column_${stage.stageId}, {
                    group: 'pipeline',
                    animation: 200,
                    ghostClass: 'sortable-ghost',
                    dragClass: 'sortable-drag',
                    easing: 'cubic-bezier(0.4, 0, 0.2, 1)',
                    onEnd: function (evt) {
                        const oppId = evt.item.getAttribute('data-opportunity-id');
                        const newStageId = evt.to.getAttribute('data-stage-id');
                        updateStage(oppId, newStageId);
                    }
                });
            }
        </c:forEach>
    </c:if>
});

// Update stage via AJAX
function updateStage(oppId, newStageId) {
    console.log('Moving opportunity', oppId, 'to stage', newStageId);

    // Make AJAX call to update opportunity stage
    fetch('${pageContext.request.contextPath}/sale/opportunity/updateStage', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'opportunityId=' + oppId + '&stageId=' + newStageId
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            console.log('Stage updated successfully');
            // Optionally show a success notification
            if (window.CRM && window.CRM.showNotification) {
                window.CRM.showNotification('Opportunity moved successfully', 'success');
            }
        } else {
            console.error('Failed to update stage:', data.message);
            // Reload page to revert the drag
            location.reload();
        }
    })
    .catch(error => {
        console.error('Error updating stage:', error);
        // Reload page to revert the drag
        location.reload();
    });
}

// Click on card to edit
document.querySelectorAll('.opportunity-card').forEach(card => {
    card.addEventListener('click', function(e) {
        // Only navigate if not dragging
        if (!e.target.closest('.sortable-ghost') && !e.target.closest('.sortable-drag')) {
            const oppId = this.getAttribute('data-opportunity-id');
            window.location.href = '${pageContext.request.contextPath}/sale/opportunity/form?id=' + oppId;
        }
    });
});
</script>
