<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
    /* Form Container */
    .form-container {
        background: white;
        border-radius: 1rem;
        border: 1px solid #e2e8f0;
        padding: 2rem;
        max-width: 900px;
        margin: 0 auto;
    }

    .form-header {
        margin-bottom: 2rem;
        padding-bottom: 1.5rem;
        border-bottom: 2px solid #e2e8f0;
    }

    .form-title {
        font-size: 1.75rem;
        font-weight: 800;
        color: #1e293b;
        margin-bottom: 0.5rem;
    }

    .form-subtitle {
        color: #64748b;
        font-size: 0.875rem;
    }

    /* Form Sections */
    .form-section {
        margin-bottom: 2rem;
    }

    .section-title {
        font-size: 1.125rem;
        font-weight: 700;
        color: #1e293b;
        margin-bottom: 1.25rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .section-icon {
        width: 1.25rem;
        height: 1.25rem;
        color: #3b82f6;
    }

    /* Form Grid */
    .form-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 1.25rem;
    }

    .form-grid-full {
        grid-column: 1 / -1;
    }

    /* Form Fields */
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

    .form-label.required::after {
        content: " *";
        color: #ef4444;
    }

    .form-input,
    .form-select,
    .form-textarea {
        padding: 0.75rem 1rem;
        border: 1px solid #e2e8f0;
        border-radius: 0.625rem;
        font-size: 0.875rem;
        transition: all 0.2s;
        background: white;
    }

    .form-input:focus,
    .form-select:focus,
    .form-textarea:focus {
        outline: none;
        border-color: #60a5fa;
        box-shadow: 0 0 0 3px rgba(96, 165, 250, 0.1);
    }

    .form-textarea {
        resize: vertical;
        min-height: 120px;
        font-family: inherit;
    }

    .form-help {
        font-size: 0.75rem;
        color: #64748b;
        margin-top: 0.375rem;
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

    /* Info Message */
    .info-message {
        background: linear-gradient(135deg, #dbeafe, #bfdbfe);
        color: #1e40af;
        padding: 1rem 1.25rem;
        border-radius: 0.75rem;
        margin-bottom: 1.5rem;
        display: flex;
        align-items: center;
        gap: 0.75rem;
        font-weight: 600;
        font-size: 0.875rem;
    }

    /* Form Actions */
    .form-actions {
        display: flex;
        gap: 0.75rem;
        justify-content: flex-end;
        padding-top: 1.5rem;
        border-top: 1px solid #e2e8f0;
        margin-top: 2rem;
    }

    .btn {
        padding: 0.75rem 1.5rem;
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

    /* Responsive */
    @media (max-width: 640px) {
        .form-container {
            padding: 1.5rem;
        }

        .form-grid {
            grid-template-columns: 1fr;
        }

        .form-actions {
            flex-direction: column-reverse;
        }

        .btn {
            width: 100%;
            justify-content: center;
        }
    }
</style>

<div class="form-container">
    <!-- Form Header -->
    <div class="form-header">
        <h2 class="form-title">
            <c:choose>
                <c:when test="${mode == 'edit'}">Edit Opportunity</c:when>
                <c:otherwise>Create New Opportunity</c:otherwise>
            </c:choose>
        </h2>
        <p class="form-subtitle">
            <c:choose>
                <c:when test="${mode == 'edit'}">Update opportunity information</c:when>
                <c:otherwise>Fill in the details to create a new opportunity</c:otherwise>
            </c:choose>
        </p>
    </div>

    <!-- Convert from Lead Info -->
    <c:if test="${convertFromLead == true && not empty lead}">
        <div class="info-message">
            <svg class="error-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
            </svg>
            <span>Converting lead: ${lead.fullName} (${lead.leadCode})</span>
        </div>
    </c:if>

    <!-- Error Message -->
    <c:if test="${not empty error}">
        <div class="error-message">
            <svg class="error-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
            </svg>
            <span>${error}</span>
        </div>
    </c:if>

    <!-- Form -->
    <form method="POST" action="${pageContext.request.contextPath}/sale/opportunity/form" id="opportunityForm">
        <!-- Hidden Field for Edit Mode -->
        <c:if test="${mode == 'edit'}">
            <input type="hidden" name="opportunityId" value="${opportunity.opportunityId}">
        </c:if>

        <!-- Hidden Field for Lead ID (when converting) -->
        <c:if test="${not empty opportunity.leadId}">
            <input type="hidden" name="leadId" value="${opportunity.leadId}">
        </c:if>

        <!-- Basic Information Section -->
        <div class="form-section">
            <h3 class="section-title">
                <svg class="section-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                </svg>
                Basic Information
            </h3>

            <div class="form-grid">
                <!-- Opportunity Name -->
                <div class="form-field form-grid-full">
                    <label class="form-label required" for="opportunityName">Opportunity Name</label>
                    <input type="text"
                           id="opportunityName"
                           name="opportunityName"
                           class="form-input"
                           placeholder="e.g., Enterprise CRM Implementation"
                           value="${opportunity.opportunityName}"
                           required>
                </div>

                <!-- Pipeline -->
                <div class="form-field">
                    <label class="form-label required" for="pipelineId">Pipeline</label>
                    <select id="pipelineId" name="pipelineId" class="form-select" required onchange="loadStages(this.value)">
                        <option value="">-- Select Pipeline --</option>
                        <c:forEach var="pipeline" items="${pipelines}">
                            <option value="${pipeline.pipelineId}"
                                    <c:if test="${opportunity.pipelineId == pipeline.pipelineId}">selected</c:if>>
                                ${pipeline.pipelineName}
                            </option>
                        </c:forEach>
                    </select>
                    <span class="form-help">Select the sales pipeline</span>
                </div>

                <!-- Stage -->
                <div class="form-field">
                    <label class="form-label" for="stageId">Stage</label>
                    <select id="stageId" name="stageId" class="form-select">
                        <option value="">-- Auto (First Stage) --</option>
                        <c:forEach var="stage" items="${stages}">
                            <option value="${stage.stageId}"
                                    <c:if test="${opportunity.stageId == stage.stageId}">selected</c:if>>
                                ${stage.stageName}
                            </option>
                        </c:forEach>
                    </select>
                    <span class="form-help">Leave empty to use first stage</span>
                </div>

                <!-- Estimated Value -->
                <div class="form-field">
                    <label class="form-label" for="estimatedValue">Estimated Value ($)</label>
                    <input type="number"
                           id="estimatedValue"
                           name="estimatedValue"
                           class="form-input"
                           placeholder="50000"
                           step="0.01"
                           value="${opportunity.estimatedValue}">
                </div>

                <!-- Probability -->
                <div class="form-field">
                    <label class="form-label" for="probability">Win Probability (%)</label>
                    <input type="number"
                           id="probability"
                           name="probability"
                           class="form-input"
                           placeholder="50"
                           min="0"
                           max="100"
                           value="${opportunity.probability}">
                    <span class="form-help">0-100%</span>
                </div>

                <!-- Expected Close Date -->
                <div class="form-field">
                    <label class="form-label" for="expectedCloseDate">Expected Close Date</label>
                    <input type="date"
                           id="expectedCloseDate"
                           name="expectedCloseDate"
                           class="form-input"
                           value="${opportunity.expectedCloseDate}">
                </div>

                <!-- Status -->
                <div class="form-field">
                    <label class="form-label" for="status">Status</label>
                    <select id="status" name="status" class="form-select">
                        <option value="Open" <c:if test="${opportunity.status == 'Open' || empty opportunity.status}">selected</c:if>>Open</option>
                        <option value="Won" <c:if test="${opportunity.status == 'Won'}">selected</c:if>>Won</option>
                        <option value="Lost" <c:if test="${opportunity.status == 'Lost'}">selected</c:if>>Lost</option>
                    </select>
                </div>
            </div>
        </div>

        <!-- Additional Information Section -->
        <div class="form-section">
            <h3 class="section-title">
                <svg class="section-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                Additional Information
            </h3>

            <div class="form-grid">
                <!-- Source -->
                <div class="form-field">
                    <label class="form-label" for="sourceId">Lead Source</label>
                    <select id="sourceId" name="sourceId" class="form-select">
                        <option value="">-- Select Source --</option>
                        <c:forEach var="source" items="${sources}">
                            <option value="${source.sourceId}"
                                    <c:if test="${opportunity.sourceId == source.sourceId}">selected</c:if>>
                                ${source.sourceName}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Campaign -->
                <div class="form-field">
                    <label class="form-label" for="campaignId">Campaign</label>
                    <select id="campaignId" name="campaignId" class="form-select">
                        <option value="">-- Select Campaign --</option>
                        <c:forEach var="campaign" items="${campaigns}">
                            <option value="${campaign.campaignId}"
                                    <c:if test="${opportunity.campaignId == campaign.campaignId}">selected</c:if>>
                                ${campaign.campaignName}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Notes -->
                <div class="form-field form-grid-full">
                    <label class="form-label" for="notes">Notes</label>
                    <textarea id="notes"
                              name="notes"
                              class="form-textarea"
                              placeholder="Add any additional notes about this opportunity...">${opportunity.notes}</textarea>
                </div>
            </div>
        </div>

        <!-- Form Actions -->
        <div class="form-actions">
            <a href="${pageContext.request.contextPath}/sale/opportunity/list" class="btn btn-secondary">
                <svg class="btn-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                </svg>
                Cancel
            </a>

            <button type="submit" class="btn btn-primary">
                <svg class="btn-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                </svg>
                <c:choose>
                    <c:when test="${mode == 'edit'}">Update Opportunity</c:when>
                    <c:otherwise>Create Opportunity</c:otherwise>
                </c:choose>
            </button>
        </div>
    </form>
</div>

<script>
    // Form validation
    document.getElementById('opportunityForm').addEventListener('submit', function (e) {
        const opportunityName = document.getElementById('opportunityName').value.trim();
        const pipelineId = document.getElementById('pipelineId').value;

        if (!opportunityName) {
            e.preventDefault();
            alert('Opportunity name is required!');
            document.getElementById('opportunityName').focus();
            return false;
        }

        if (!pipelineId) {
            e.preventDefault();
            alert('Please select a pipeline!');
            document.getElementById('pipelineId').focus();
            return false;
        }

        return true;
    });

    // Show loading state on submit
    document.getElementById('opportunityForm').addEventListener('submit', function () {
        const submitBtn = this.querySelector('button[type="submit"]');
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<span>Saving...</span>';
    });

    // Load stages when pipeline changes (for future AJAX implementation)
    function loadStages(pipelineId) {
        // TODO: Implement AJAX to load stages dynamically
        console.log('Loading stages for pipeline:', pipelineId);
    }
</script>
