<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>

<style>
    /* ===== Jira-inspired Kanban ===== */
    .kb-toolbar {
        background: #fff;
        border-radius: 8px;
        padding: 10px 16px;
        margin-bottom: 16px;
        box-shadow: 0 1px 3px rgba(0,0,0,.06);
    }
    .kb-stats {
        display: flex;
        gap: 20px;
    }
    .kb-stat {
        text-align: center;
    }
    .kb-stat-val {
        font-size: 1.25rem;
        font-weight: 700;
        line-height: 1.2;
    }
    .kb-stat-label {
        font-size: .7rem;
        color: #6b778c;
        text-transform: uppercase;
        letter-spacing: .3px;
    }

    /* Board */
    .kb-board {
        display: flex;
        gap: 8px;
        overflow-x: auto;
        padding-bottom: 8px;
        align-items: flex-start;
    }
    .kb-board::-webkit-scrollbar {
        height: 6px;
    }
    .kb-board::-webkit-scrollbar-thumb {
        background: #c1c7d0;
        border-radius: 3px;
    }

    /* Columns - flex equally, shrink when needed */
    .kb-col {
        background: #f4f5f7;
        border-radius: 6px;
        display: flex;
        flex-direction: column;
        min-width: 0;
        flex: 1 1 0;
        max-height: calc(100vh - 280px);
    }
    .kb-col-head {
        padding: 10px 10px 8px;
        flex-shrink: 0;
    }
    .kb-col-title {
        font-size: .75rem;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: .4px;
        color: #5e6c84;
        display: flex;
        align-items: center;
        gap: 6px;
    }
    .kb-col-count {
        background: #dfe1e6;
        color: #44546f;
        border-radius: 10px;
        font-size: .65rem;
        font-weight: 700;
        padding: 1px 7px;
        min-width: 20px;
        text-align: center;
    }
    .kb-col-value {
        font-size: .68rem;
        color: #8993a4;
        margin-top: 2px;
    }
    .kb-col-dot {
        width: 8px;
        height: 8px;
        border-radius: 50%;
        flex-shrink: 0;
    }

    /* Cards area - scrollable */
    .kb-cards {
        padding: 0 6px 6px;
        flex: 1;
        overflow-y: auto;
        min-height: 60px;
    }
    .kb-cards::-webkit-scrollbar {
        width: 4px;
    }
    .kb-cards::-webkit-scrollbar-thumb {
        background: #c1c7d0;
        border-radius: 2px;
    }

    /* Card */
    .kb-card {
        background: #fff;
        border-radius: 4px;
        padding: 8px 10px;
        margin-bottom: 6px;
        box-shadow: 0 1px 1px rgba(9,30,66,.13), 0 0 1px rgba(9,30,66,.2);
        cursor: grab;
        transition: background .12s, box-shadow .12s;
        position: relative;
    }
    .kb-card:hover {
        background: #ebecf0;
        box-shadow: 0 2px 4px rgba(9,30,66,.18), 0 0 1px rgba(9,30,66,.2);
    }
    .kb-card.sortable-ghost {
        opacity: .35;
        background: #deebff;
    }
    .kb-card.sortable-chosen {
        box-shadow: 0 8px 16px rgba(9,30,66,.25);
        transform: rotate(2deg);
    }

    .kb-card-title {
        font-size: .8rem;
        font-weight: 500;
        color: #172b4d;
        line-height: 1.3;
        margin-bottom: 4px;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }
    .kb-card-title a {
        color: inherit;
        text-decoration: none;
    }
    .kb-card-title a:hover {
        color: #0052cc;
    }
    .kb-card-code {
        font-size: .65rem;
        color: #8993a4;
    }
    .kb-card-value {
        font-size: .75rem;
        font-weight: 600;
        color: #36b37e;
    }
    .kb-card-footer {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-top: 6px;
    }
    .kb-card-meta {
        display: flex;
        align-items: center;
        gap: 8px;
    }
    .kb-card-prob {
        font-size: .65rem;
        color: #8993a4;
    }
    .kb-card-date {
        font-size: .65rem;
        color: #8993a4;
        display: flex;
        align-items: center;
        gap: 2px;
    }
    .kb-card-avatar {
        width: 22px;
        height: 22px;
        border-radius: 50%;
        background: #dfe1e6;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: .6rem;
        font-weight: 700;
        color: #44546f;
    }

    /* Priority dot on card */
    .kb-prob-dot {
        width: 6px;
        height: 6px;
        border-radius: 50%;
        display: inline-block;
    }
    .kb-prob-high {
        background: #36b37e;
    }
    .kb-prob-med {
        background: #ffab00;
    }
    .kb-prob-low {
        background: #ff5630;
    }

    /* Empty column */
    .kb-empty {
        text-align: center;
        padding: 20px 10px;
        color: #b3bac5;
        font-size: .75rem;
    }

    /* Add deal button */
    .kb-add-btn {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 4px;
        width: 100%;
        padding: 6px;
        margin-top: 2px;
        border: 1px dashed #c1c7d0;
        border-radius: 4px;
        background: transparent;
        color: #6b778c;
        font-size: .72rem;
        cursor: pointer;
        transition: all .15s;
        text-decoration: none;
    }
    .kb-add-btn:hover {
        background: #fff;
        border-color: #0052cc;
        color: #0052cc;
    }

    /* Modal detail styles */
    .opp-modal-header {
        border-bottom: 3px solid #0052cc;
    }
    .opp-detail-label {
        font-size: .75rem;
        color: #6b778c;
        text-transform: uppercase;
        letter-spacing: .3px;
        margin-bottom: 2px;
    }
    .opp-detail-value {
        font-size: .9rem;
        font-weight: 500;
        color: #172b4d;
    }
    .opp-stage-progress {
        display: flex;
        gap: 3px;
        align-items: center;
    }
    .opp-stage-step {
        flex: 1;
        height: 6px;
        border-radius: 3px;
        background: #dfe1e6;
    }
    .opp-stage-step.active {
        background: #0052cc;
    }
    .opp-stage-step.passed {
        background: #36b37e;
    }
    .opp-kpi-box {
        text-align: center;
        padding: 12px 8px;
        background: #f4f5f7;
        border-radius: 8px;
    }
    .opp-kpi-box .value {
        font-size: 1.1rem;
        font-weight: 700;
    }
    .opp-kpi-box .label {
        font-size: .7rem;
        color: #6b778c;
    }

    /* Locked card (Won/Lost) */
    .kb-card.kb-locked {
        opacity: .7;
        cursor: default !important;
        border-left: 3px solid #6c757d;
    }
    .kb-card.kb-locked .kb-card-title { color: #6c757d; }
    .kb-locked-badge {
        font-size: .6rem;
        font-weight: 700;
        padding: 1px 6px;
        border-radius: 3px;
    }
</style>

<!-- Compact Header -->
<div class="kb-toolbar d-flex justify-content-between align-items-center flex-wrap gap-2">
    <div class="d-flex align-items-center gap-3">
        <div>
            <h5 class="mb-0 fw-bold" style="font-size: 1.1rem;">
                <i class="bi bi-kanban me-1 text-primary"></i>
                <c:choose>
                    <c:when test="${not empty selectedPipeline}">${selectedPipeline.pipelineName}</c:when>
                    <c:otherwise>Pipeline</c:otherwise>
                </c:choose>
            </h5>
        </div>
        <form method="GET" action="${pageContext.request.contextPath}/sale/opportunity/kanban">
            <select name="pipeline" class="form-select form-select-sm" onchange="this.form.submit()" style="width: 170px; font-size: .8rem;">
                <c:forEach var="p" items="${allPipelines}">
                    <option value="${p.pipelineId}" ${selectedPipeline != null && selectedPipeline.pipelineId == p.pipelineId ? 'selected' : ''}>${p.pipelineName}</option>
                </c:forEach>
            </select>
        </form>
    </div>

    <div class="d-flex align-items-center gap-3">
        <!-- Inline Stats -->
        <div class="kb-stats d-none d-md-flex">
            <div class="kb-stat">
                <div class="kb-stat-val text-primary">${totalOpportunities}</div>
                <div class="kb-stat-label">Deals</div>
            </div>
            <div class="kb-stat">
                <div class="kb-stat-val text-success"><fmt:formatNumber value="${totalPipelineValue}" type="number" groupingUsed="true" maxFractionDigits="0"/></div>
                <div class="kb-stat-label">Pipeline (VND)</div>
            </div>
            <div class="kb-stat">
                <div class="kb-stat-val text-warning">${winRate}%</div>
                <div class="kb-stat-label">Win rate</div>
            </div>
        </div>

        <div class="vr d-none d-md-block"></div>

        <div class="d-flex gap-1">
            <a href="${pageContext.request.contextPath}/sale/opportunity/list" class="btn btn-outline-secondary btn-sm" style="font-size:.75rem;"><i class="bi bi-list-ul"></i></a>
            <a href="${pageContext.request.contextPath}/sale/opportunity/form" class="btn btn-primary btn-sm" style="font-size:.75rem;"><i class="bi bi-plus-lg me-1"></i>Tao deal</a>
        </div>
    </div>
</div>

<!-- Kanban Board -->
<c:choose>
    <c:when test="${not empty stages}">
        <div class="kb-board">
            <c:forEach var="stage" items="${stages}">
                <c:set var="stageColor" value="${not empty stage.colorCode ? stage.colorCode : '#6b778c'}" />
                <c:set var="stageOpps" value="${opportunitiesByStage[stage.stageId]}" />
                <c:set var="stageCount" value="${not empty stageOpps ? stageOpps.size() : 0}" />

                <div class="kb-col">
                    <div class="kb-col-head">
                        <div class="kb-col-title">
                            <span class="kb-col-dot" style="background: ${stageColor};"></span>
                            ${stage.stageName}
                            <span class="kb-col-count">${stageCount}</span>
                        </div>
                        <div class="kb-col-value">
                            <c:choose>
                                <c:when test="${not empty valueByStage[stage.stageId] and valueByStage[stage.stageId] > 0}">
                                    <fmt:formatNumber value="${valueByStage[stage.stageId]}" type="number" groupingUsed="true" maxFractionDigits="0"/>d
                                </c:when>
                                <c:otherwise>0d</c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="kb-col-actions" style="padding: 0 6px 4px;">
                        <a href="${pageContext.request.contextPath}/sale/opportunity/form?pipeline=${selectedPipeline.pipelineId}&stage=${stage.stageId}" class="kb-add-btn">
                            <i class="bi bi-plus"></i>Tao deal
                        </a>
                    </div>

                    <div class="kb-cards" id="stage-${stage.stageId}" data-stage-id="${stage.stageId}" data-stage-type="${stage.stageType}">
                        <c:choose>
                            <c:when test="${not empty stageOpps}">
                                <c:forEach var="opp" items="${stageOpps}">
                                    <div class="kb-card${opp.status == 'Won' || opp.status == 'Lost' ? ' kb-locked' : ''}" data-opp-id="${opp.opportunityId}"
                                         data-name="${opp.opportunityName}"
                                         data-code="${opp.opportunityCode}"
                                         data-value="${opp.estimatedValue}"
                                         data-prob="${opp.probability}"
                                         data-status="${opp.status}"
                                         data-stage="${stage.stageName}"
                                         data-stage-color="${stageColor}"
                                         data-stage-order="${stage.stageOrder}"
                                         data-close-date="${opp.expectedCloseDate}"
                                         data-actual-close="${opp.actualCloseDate}"
                                         data-notes="${opp.notes}"
                                         data-reason="${opp.wonLostReason}"
                                         data-created="${opp.createdAt}"
                                         data-updated="${opp.updatedAt}"
                                         onclick="showOppDetail(this)" style="cursor:pointer;">
                                        <div class="kb-card-title">
                                            ${opp.opportunityName}
                                            <c:if test="${opp.status == 'Won'}"><span class="kb-locked-badge bg-success text-white ms-1">Won</span></c:if>
                                            <c:if test="${opp.status == 'Lost'}"><span class="kb-locked-badge bg-danger text-white ms-1">Lost</span></c:if>
                                        </div>
                                        <div class="d-flex justify-content-between align-items-center">
                                            <span class="kb-card-code">${opp.opportunityCode}</span>
                                            <c:if test="${not empty opp.estimatedValue and opp.estimatedValue > 0}">
                                                <span class="kb-card-value"><fmt:formatNumber value="${opp.estimatedValue}" type="number" groupingUsed="true" maxFractionDigits="0"/>d</span>
                                            </c:if>
                                        </div>
                                        <div class="kb-card-footer">
                                            <div class="kb-card-meta">
                                                <span class="kb-card-prob">
                                                    <span class="kb-prob-dot <c:choose><c:when test='${opp.probability >= 70}'>kb-prob-high</c:when><c:when test='${opp.probability >= 40}'>kb-prob-med</c:when><c:otherwise>kb-prob-low</c:otherwise></c:choose>"></span>
                                                    ${opp.probability}%
                                                </span>
                                                <c:if test="${not empty opp.expectedCloseDate}">
                                                    <span class="kb-card-date"><i class="bi bi-calendar3"></i>${opp.expectedCloseDate.toString().substring(5)}</span>
                                                    </c:if>
                                            </div>
                                            <div class="kb-card-avatar" title="Owner">${opp.opportunityName.substring(0,1)}</div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="kb-empty"><i class="bi bi-inbox"></i><br>Trong</div>
                                </c:otherwise>
                            </c:choose>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:when>
    <c:otherwise>
        <div class="text-center py-5">
            <i class="bi bi-kanban text-muted" style="font-size: 3rem;"></i>
            <p class="text-muted mt-3 mb-1">Chua co pipeline hoac stage nao</p>
            <small class="text-muted">Vui long cau hinh pipeline va stages trong he thong</small>
        </div>
    </c:otherwise>
</c:choose>

<!-- Opportunity Detail Modal -->
<div class="modal fade" id="oppDetailModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <div class="modal-header opp-modal-header py-2">
                <div>
                    <h6 class="modal-title fw-bold mb-0" id="mdl-name"></h6>
                    <small class="text-muted" id="mdl-code"></small>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <!-- Stage & Status -->
                <div class="d-flex align-items-center gap-2 mb-3">
                    <span class="badge" id="mdl-status-badge"></span>
                    <span class="text-muted small"><i class="bi bi-arrow-right me-1"></i>Stage: <strong id="mdl-stage"></strong></span>
                </div>

                <!-- KPI Row -->
                <div class="row g-2 mb-3">
                    <div class="col-4">
                        <div class="opp-kpi-box">
                            <div class="value text-success" id="mdl-value">0</div>
                            <div class="label">Gia tri (VND)</div>
                        </div>
                    </div>
                    <div class="col-4">
                        <div class="opp-kpi-box">
                            <div class="value text-primary" id="mdl-prob">0%</div>
                            <div class="label">Xac suat</div>
                        </div>
                    </div>
                    <div class="col-4">
                        <div class="opp-kpi-box">
                            <div class="value text-warning" id="mdl-forecast">0</div>
                            <div class="label">Du bao</div>
                        </div>
                    </div>
                </div>

                <!-- Probability Bar -->
                <div class="mb-3">
                    <div class="d-flex justify-content-between mb-1">
                        <small class="text-muted fw-semibold">Tien do xac suat</small>
                        <small class="fw-bold" id="mdl-prob-text"></small>
                    </div>
                    <div class="progress" style="height: 8px;">
                        <div class="progress-bar" id="mdl-prob-bar" style="width:0%;"></div>
                    </div>
                </div>

                <!-- Detail Info -->
                <div class="row g-3">
                    <div class="col-md-6">
                        <div class="opp-detail-label">Ngay dong du kien</div>
                        <div class="opp-detail-value" id="mdl-close-date">-</div>
                    </div>
                    <div class="col-md-6">
                        <div class="opp-detail-label">Ngay dong thuc te</div>
                        <div class="opp-detail-value" id="mdl-actual-close">-</div>
                    </div>
                    <div class="col-md-6">
                        <div class="opp-detail-label">Ngay tao</div>
                        <div class="opp-detail-value" id="mdl-created">-</div>
                    </div>
                    <div class="col-md-6">
                        <div class="opp-detail-label">Cap nhat</div>
                        <div class="opp-detail-value" id="mdl-updated">-</div>
                    </div>
                    <div id="mdl-reason-wrap" class="col-12" style="display:none;">
                        <div class="opp-detail-label">Ly do Won/Lost</div>
                        <div class="opp-detail-value" id="mdl-reason"></div>
                    </div>
                    <div id="mdl-notes-wrap" class="col-12" style="display:none;">
                        <div class="opp-detail-label">Ghi chu</div>
                        <div class="opp-detail-value p-2 bg-light rounded" id="mdl-notes" style="white-space:pre-wrap; font-size:.85rem;"></div>
                    </div>
                </div>
            </div>
            <div class="modal-footer py-2">
                <a id="mdl-link-detail" href="#" class="btn btn-outline-primary btn-sm"><i class="bi bi-eye me-1"></i>Xem chi tiet</a>
                <a id="mdl-link-edit" href="#" class="btn btn-outline-secondary btn-sm"><i class="bi bi-pencil me-1"></i>Chinh sua</a>
                <button type="button" class="btn btn-light btn-sm" data-bs-dismiss="modal">Dong</button>
            </div>
        </div>
    </div>
</div>

<!-- Won/Lost Confirmation Modal -->
<div class="modal fade" id="confirmCloseModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <div class="modal-header py-2" id="confirmCloseHeader">
                <h6 class="modal-title fw-bold" id="confirmCloseTitle"></h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p class="mb-3" id="confirmCloseMsg"></p>
                <div class="mb-3">
                    <label class="form-label small fw-semibold">Ly do (khong bat buoc)</label>
                    <textarea class="form-control form-control-sm" id="confirmCloseReason" rows="3" placeholder="Nhap ly do..."></textarea>
                </div>
                <div class="alert alert-warning small py-2 mb-0">
                    <i class="bi bi-exclamation-triangle me-1"></i>Sau khi xac nhan, trang thai se <strong>khong the thay doi</strong> lai duoc.
                </div>
            </div>
            <div class="modal-footer py-2">
                <button type="button" class="btn btn-light btn-sm" id="confirmCloseCancel" data-bs-dismiss="modal">Huy</button>
                <button type="button" class="btn btn-sm" id="confirmCloseBtn">Xac nhan</button>
            </div>
        </div>
    </div>
</div>

<script>
    // Pending close action (for won/lost confirmation)
    var pendingClose = null;

    document.querySelectorAll('.kb-cards').forEach(function (el) {
        new Sortable(el, {
            group: 'kanban',
            animation: 150,
            easing: 'cubic-bezier(0.22, 1, 0.36, 1)',
            ghostClass: 'sortable-ghost',
            chosenClass: 'sortable-chosen',
            dragClass: 'sortable-drag',
            delayOnTouchOnly: true,
            delay: 80,
            filter: '.kb-locked',
            onMove: function (evt) {
                // Prevent dragging locked (Won/Lost) cards
                if (evt.dragged.classList.contains('kb-locked')) return false;
            },
            onEnd: function (evt) {
                var card = evt.item;
                var oppId = card.getAttribute('data-opp-id');
                var oppName = card.getAttribute('data-name');
                var newStageId = evt.to.getAttribute('data-stage-id');
                var oldStageId = evt.from.getAttribute('data-stage-id');
                var targetStageType = evt.to.getAttribute('data-stage-type');

                if (newStageId === oldStageId)
                    return;

                // If target is won/lost, show confirmation
                if (targetStageType === 'won' || targetStageType === 'lost') {
                    pendingClose = {
                        card: card,
                        oppId: oppId,
                        newStageId: newStageId,
                        oldStageId: oldStageId,
                        fromEl: evt.from,
                        toEl: evt.to,
                        stageType: targetStageType
                    };

                    var isWon = targetStageType === 'won';
                    var header = document.getElementById('confirmCloseHeader');
                    header.style.borderBottom = '3px solid ' + (isWon ? '#27ae60' : '#c0392b');
                    document.getElementById('confirmCloseTitle').textContent = isWon ? 'Xac nhan Thanh cong' : 'Xac nhan That bai';
                    document.getElementById('confirmCloseMsg').innerHTML = (isWon
                            ? 'Ban co chac muon danh dau <strong>' + oppName + '</strong> la <span class="text-success fw-bold">Thanh cong (Won)</span>?'
                            : 'Ban co chac muon danh dau <strong>' + oppName + '</strong> la <span class="text-danger fw-bold">That bai (Lost)</span>?');
                    document.getElementById('confirmCloseReason').value = '';
                    var btn = document.getElementById('confirmCloseBtn');
                    btn.className = 'btn btn-sm ' + (isWon ? 'btn-success' : 'btn-danger');
                    btn.textContent = isWon ? 'Xac nhan Won' : 'Xac nhan Lost';

                    getConfirmModal().show();
                    return;
                }

                // Normal stage move
                performStageUpdate(oppId, newStageId, oldStageId, evt.from, evt.to, null);
            }
        });
    });

    function performStageUpdate(oppId, newStageId, oldStageId, fromEl, toEl, reason) {
        // Update counts visually
        updateColumnCount(fromEl);
        updateColumnCount(toEl);

        // Remove empty message if target had one
        var emptyMsg = toEl.querySelector('.kb-empty');
        if (emptyMsg) emptyMsg.remove();

        // Show empty message if source is now empty
        if (fromEl.querySelectorAll('.kb-card').length === 0) {
            fromEl.innerHTML = '<div class="kb-empty"><i class="bi bi-inbox"></i><br>Trong</div>';
        }

        var body = 'opportunityId=' + oppId + '&stageId=' + newStageId;
        if (reason) body += '&reason=' + encodeURIComponent(reason);

        fetch('${pageContext.request.contextPath}/sale/opportunity/stage', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: body
        })
                .then(function (r) { return r.json(); })
                .then(function (data) {
                    if (!data.success) {
                        alert('Loi: ' + data.message);
                        location.reload();
                    } else if (data.newStatus === 'Won' || data.newStatus === 'Lost') {
                        if (data.leadConverted) {
                            alert('Lead da duoc tu dong chuyen doi thanh Customer!');
                        }
                        location.reload();
                    }
                })
                .catch(function () {
                    alert('Loi ket noi');
                    location.reload();
                });
    }

    function updateColumnCount(container) {
        var col = container.closest('.kb-col');
        var count = container.querySelectorAll('.kb-card').length;
        var badge = col.querySelector('.kb-col-count');
        if (badge)
            badge.textContent = count;
    }

    // --- Won/Lost Confirmation Modal ---
    var confirmModal = null;
    function getConfirmModal() {
        if (!confirmModal) {
            confirmModal = new bootstrap.Modal(document.getElementById('confirmCloseModal'));
        }
        return confirmModal;
    }

    // Confirm button handler
    document.getElementById('confirmCloseBtn').addEventListener('click', function () {
        if (!pendingClose) return;
        var reason = document.getElementById('confirmCloseReason').value;
        performStageUpdate(
                pendingClose.oppId,
                pendingClose.newStageId,
                pendingClose.oldStageId,
                pendingClose.fromEl,
                pendingClose.toEl,
                reason
                );
        getConfirmModal().hide();
        pendingClose = null;
    });

    // Cancel: revert the card back
    document.getElementById('confirmCloseModal').addEventListener('hidden.bs.modal', function () {
        if (pendingClose) {
            // Move card back to original column
            pendingClose.fromEl.appendChild(pendingClose.card);
            updateColumnCount(pendingClose.fromEl);
            updateColumnCount(pendingClose.toEl);
            // Check empty
            if (pendingClose.toEl.querySelectorAll('.kb-card').length === 0) {
                pendingClose.toEl.innerHTML = '<div class="kb-empty"><i class="bi bi-inbox"></i><br>Trong</div>';
            }
            var emptyFrom = pendingClose.fromEl.querySelector('.kb-empty');
            if (emptyFrom) emptyFrom.remove();
            pendingClose = null;
        }
    });

    // --- Opportunity Detail Modal ---
    var oppModal = null;
    var isDragging = false;

    function getOppModal() {
        if (!oppModal) {
            oppModal = new bootstrap.Modal(document.getElementById('oppDetailModal'));
        }
        return oppModal;
    }

    // Prevent modal from opening during drag
    document.querySelectorAll('.kb-card').forEach(function (card) {
        card.addEventListener('mousedown', function () {
            isDragging = false;
        });
        card.addEventListener('mousemove', function () {
            isDragging = true;
        });
    });

    function showOppDetail(card) {
        if (isDragging)
            return;

        var oppId = card.getAttribute('data-opp-id');
        var name = card.getAttribute('data-name') || '';
        var code = card.getAttribute('data-code') || '';
        var value = parseFloat(card.getAttribute('data-value')) || 0;
        var prob = parseInt(card.getAttribute('data-prob')) || 0;
        var status = card.getAttribute('data-status') || 'Open';
        var stage = card.getAttribute('data-stage') || '';
        var closeDate = card.getAttribute('data-close-date') || '';
        var actualClose = card.getAttribute('data-actual-close') || '';
        var notes = card.getAttribute('data-notes') || '';
        var reason = card.getAttribute('data-reason') || '';
        var created = card.getAttribute('data-created') || '';
        var updated = card.getAttribute('data-updated') || '';

        // Set modal content
        document.getElementById('mdl-name').textContent = name;
        document.getElementById('mdl-code').textContent = code;
        document.getElementById('mdl-stage').textContent = stage;

        // Status badge
        var statusBadge = document.getElementById('mdl-status-badge');
        var statusMap = {
            'Open': ['bg-info-subtle text-info', 'Open'],
            'InProgress': ['bg-primary-subtle text-primary', 'In Progress'],
            'Won': ['bg-success', 'Won'],
            'Lost': ['bg-danger', 'Lost'],
            'OnHold': ['bg-warning-subtle text-warning', 'On Hold'],
            'Cancelled': ['bg-secondary', 'Cancelled']
        };
        var sc = statusMap[status] || ['bg-secondary', status];
        statusBadge.className = 'badge ' + sc[0];
        statusBadge.textContent = sc[1];

        // KPI
        document.getElementById('mdl-value').textContent = formatNumber(value) + 'd';
        document.getElementById('mdl-prob').textContent = prob + '%';
        var forecast = Math.round(value * prob / 100);
        document.getElementById('mdl-forecast').textContent = formatNumber(forecast) + 'd';

        // Probability bar
        document.getElementById('mdl-prob-text').textContent = prob + '%';
        var bar = document.getElementById('mdl-prob-bar');
        bar.style.width = prob + '%';
        bar.className = 'progress-bar ' + (prob >= 70 ? 'bg-success' : prob >= 40 ? 'bg-warning' : 'bg-danger');

        // Dates
        document.getElementById('mdl-close-date').textContent = (closeDate && closeDate !== 'null') ? closeDate : '-';
        document.getElementById('mdl-actual-close').textContent = (actualClose && actualClose !== 'null') ? actualClose : '-';
        document.getElementById('mdl-created').textContent = formatDateTime(created);
        document.getElementById('mdl-updated').textContent = formatDateTime(updated);

        // Reason
        var reasonWrap = document.getElementById('mdl-reason-wrap');
        if (reason && reason !== 'null') {
            reasonWrap.style.display = '';
            document.getElementById('mdl-reason').textContent = reason;
        } else {
            reasonWrap.style.display = 'none';
        }

        // Notes
        var notesWrap = document.getElementById('mdl-notes-wrap');
        if (notes && notes !== 'null') {
            notesWrap.style.display = '';
            document.getElementById('mdl-notes').textContent = notes;
        } else {
            notesWrap.style.display = 'none';
        }

        // Links
        var ctx = '${pageContext.request.contextPath}';
        document.getElementById('mdl-link-detail').href = ctx + '/sale/opportunity/detail?id=' + oppId;
        document.getElementById('mdl-link-edit').href = ctx + '/sale/opportunity/form?id=' + oppId;

        getOppModal().show();
    }

    function formatNumber(num) {
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    }

    function formatDateTime(dt) {
        if (!dt || dt === 'null')
            return '-';
        var s = dt.toString();
        if (s.length >= 16)
            return s.substring(0, 16).replace('T', ' ');
        return s;
    }
</script>
