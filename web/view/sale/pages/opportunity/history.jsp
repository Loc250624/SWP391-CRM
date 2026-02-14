<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
    .history-timeline { position: relative; padding-left: 32px; }
    .history-timeline::before { content: ''; position: absolute; left: 12px; top: 0; bottom: 0; width: 2px; background: #e9ecef; }
    .history-item { position: relative; margin-bottom: 16px; }
    .history-dot { position: absolute; left: -26px; top: 4px; width: 12px; height: 12px; border-radius: 50%; border: 2px solid #fff; }
    .dot-stage { background: #6f42c1; }
    .dot-status { background: #0d6efd; }
    .dot-value { background: #198754; }
    .dot-probability { background: #fd7e14; }
    .dot-name { background: #20c997; }
    .dot-date { background: #6610f2; }
    .dot-notes { background: #6c757d; }
    .dot-other { background: #adb5bd; }
    .history-card { background: #fff; border: 1px solid #e9ecef; border-radius: 8px; padding: 12px 16px; transition: all 0.15s; }
    .history-card:hover { border-color: #dee2e6; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
    .field-badge { font-size: 11px; font-weight: 600; padding: 2px 8px; border-radius: 4px; }
    .change-arrow { color: #6c757d; margin: 0 6px; }
    .old-val { color: #dc3545; text-decoration: line-through; opacity: 0.7; }
    .new-val { color: #198754; font-weight: 600; }
    .filter-count { display: inline-flex; align-items: center; justify-content: center; min-width: 20px; height: 20px; border-radius: 10px; font-size: 11px; font-weight: 700; padding: 0 6px; }
</style>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">
            <c:choose>
                <c:when test="${not empty selectedOpp}">
                    <i class="bi bi-clock-history me-2 text-primary"></i>Lich su: ${selectedOpp.opportunityName}
                    <small class="text-muted fw-normal">(${selectedOpp.opportunityCode})</small>
                </c:when>
                <c:otherwise><i class="bi bi-clock-history me-2 text-primary"></i>Lich su thay doi Opportunity</c:otherwise>
            </c:choose>
        </h4>
        <p class="text-muted mb-0">
            <c:choose>
                <c:when test="${totalItems > 0}">${totalItems} thay doi duoc ghi nhan</c:when>
                <c:otherwise>Chua co thay doi nao duoc ghi nhan</c:otherwise>
            </c:choose>
        </p>
    </div>
    <div class="d-flex gap-2">
        <c:if test="${not empty filterOppId}">
            <a href="${pageContext.request.contextPath}/sale/opportunity/detail?id=${filterOppId}" class="btn btn-outline-primary btn-sm"><i class="bi bi-eye me-1"></i>Chi tiet</a>
        </c:if>
        <a href="${pageContext.request.contextPath}/sale/opportunity/history" class="btn btn-outline-secondary btn-sm"><i class="bi bi-clock-history me-1"></i>Tat ca</a>
        <a href="${pageContext.request.contextPath}/sale/opportunity/list" class="btn btn-outline-secondary btn-sm"><i class="bi bi-list me-1"></i>Danh sach</a>
    </div>
</div>

<!-- Filter Bar -->
<div class="card border-0 shadow-sm mb-4">
    <div class="card-body py-3">
        <form method="GET" action="${pageContext.request.contextPath}/sale/opportunity/history" class="row g-2 align-items-end">

            <!-- Opportunity Filter -->
            <div class="col-md-3">
                <label class="form-label small text-muted mb-1">Opportunity</label>
                <select name="oppId" class="form-select form-select-sm" onchange="this.form.submit()">
                    <option value="">-- Tat ca opportunity --</option>
                    <c:forEach var="opp" items="${userOpps}">
                        <option value="${opp.opportunityId}" ${filterOppId == opp.opportunityId.toString() ? 'selected' : ''}>${opp.opportunityName}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- Field Type Filter -->
            <div class="col-md-3">
                <label class="form-label small text-muted mb-1">Loai thay doi</label>
                <select name="field" class="form-select form-select-sm" onchange="this.form.submit()">
                    <option value="">-- Tat ca loai --</option>
                    <option value="stage_id" ${filterField == 'stage_id' ? 'selected' : ''}>Stage</option>
                    <option value="status" ${filterField == 'status' ? 'selected' : ''}>Trang thai</option>
                    <option value="estimated_value" ${filterField == 'estimated_value' ? 'selected' : ''}>Gia tri</option>
                    <option value="probability" ${filterField == 'probability' ? 'selected' : ''}>Xac suat</option>
                    <option value="opportunity_name" ${filterField == 'opportunity_name' ? 'selected' : ''}>Ten</option>
                    <option value="pipeline_id" ${filterField == 'pipeline_id' ? 'selected' : ''}>Pipeline</option>
                    <option value="expected_close_date" ${filterField == 'expected_close_date' ? 'selected' : ''}>Ngay dong</option>
                    <option value="notes" ${filterField == 'notes' ? 'selected' : ''}>Ghi chu</option>
                </select>
            </div>

            <!-- Search -->
            <div class="col-md-3">
                <label class="form-label small text-muted mb-1">Tim kiem</label>
                <div class="input-group input-group-sm">
                    <input type="text" name="search" class="form-control form-control-sm" placeholder="Nhap tu khoa..." value="${filterSearch}"/>
                    <button type="submit" class="btn btn-outline-primary btn-sm"><i class="bi bi-search"></i></button>
                </div>
            </div>

            <!-- Reset -->
            <div class="col-md-3 d-flex gap-2">
                <a href="${pageContext.request.contextPath}/sale/opportunity/history" class="btn btn-outline-secondary btn-sm w-100"><i class="bi bi-arrow-counterclockwise me-1"></i>Xoa loc</a>
            </div>
        </form>

        <!-- Active filters -->
        <c:if test="${not empty filterOppId || not empty filterField || not empty filterSearch}">
            <div class="mt-2 d-flex gap-2 flex-wrap align-items-center">
                <small class="text-muted">Dang loc:</small>
                <c:if test="${not empty filterOppId && not empty selectedOpp}">
                    <span class="badge bg-primary-subtle text-primary">${selectedOpp.opportunityName} <a href="${pageContext.request.contextPath}/sale/opportunity/history?${not empty filterField ? 'field='.concat(filterField) : ''}${not empty filterSearch ? '&search='.concat(filterSearch) : ''}" class="text-primary text-decoration-none ms-1">&times;</a></span>
                </c:if>
                <c:if test="${not empty filterField}">
                    <span class="badge bg-info-subtle text-info">
                        <c:choose>
                            <c:when test="${filterField == 'stage_id'}">Stage</c:when>
                            <c:when test="${filterField == 'status'}">Trang thai</c:when>
                            <c:when test="${filterField == 'estimated_value'}">Gia tri</c:when>
                            <c:when test="${filterField == 'probability'}">Xac suat</c:when>
                            <c:when test="${filterField == 'opportunity_name'}">Ten</c:when>
                            <c:when test="${filterField == 'pipeline_id'}">Pipeline</c:when>
                            <c:when test="${filterField == 'expected_close_date'}">Ngay dong</c:when>
                            <c:when test="${filterField == 'notes'}">Ghi chu</c:when>
                            <c:otherwise>${filterField}</c:otherwise>
                        </c:choose>
                        <a href="${pageContext.request.contextPath}/sale/opportunity/history?${not empty filterOppId ? 'oppId='.concat(filterOppId) : ''}${not empty filterSearch ? '&search='.concat(filterSearch) : ''}" class="text-info text-decoration-none ms-1">&times;</a>
                    </span>
                </c:if>
                <c:if test="${not empty filterSearch}">
                    <span class="badge bg-warning-subtle text-warning">"${filterSearch}" <a href="${pageContext.request.contextPath}/sale/opportunity/history?${not empty filterOppId ? 'oppId='.concat(filterOppId) : ''}${not empty filterField ? '&field='.concat(filterField) : ''}" class="text-warning text-decoration-none ms-1">&times;</a></span>
                </c:if>
            </div>
        </c:if>
    </div>
</div>

<!-- History Timeline -->
<c:choose>
    <c:when test="${not empty historyList}">
        <div class="card border-0 shadow-sm">
            <div class="card-body">
                <div class="history-timeline">
                    <c:forEach var="h" items="${historyList}">
                        <div class="history-item">
                            <!-- Dot color by field type -->
                            <c:choose>
                                <c:when test="${h.fieldName == 'stage_id'}"><span class="history-dot dot-stage"></span></c:when>
                                <c:when test="${h.fieldName == 'status'}"><span class="history-dot dot-status"></span></c:when>
                                <c:when test="${h.fieldName == 'estimated_value'}"><span class="history-dot dot-value"></span></c:when>
                                <c:when test="${h.fieldName == 'probability'}"><span class="history-dot dot-probability"></span></c:when>
                                <c:when test="${h.fieldName == 'opportunity_name'}"><span class="history-dot dot-name"></span></c:when>
                                <c:when test="${h.fieldName == 'expected_close_date'}"><span class="history-dot dot-date"></span></c:when>
                                <c:when test="${h.fieldName == 'notes'}"><span class="history-dot dot-notes"></span></c:when>
                                <c:otherwise><span class="history-dot dot-other"></span></c:otherwise>
                            </c:choose>

                            <div class="history-card">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div class="flex-grow-1">
                                        <!-- Opportunity name (if viewing all) -->
                                        <c:if test="${empty filterOppId}">
                                            <a href="${pageContext.request.contextPath}/sale/opportunity/history?oppId=${h.opportunityId}" class="text-decoration-none fw-semibold me-2">
                                                ${not empty oppNameMap[h.opportunityId] ? oppNameMap[h.opportunityId] : 'Opportunity #'.concat(h.opportunityId)}
                                            </a>
                                        </c:if>

                                        <!-- Field badge -->
                                        <c:choose>
                                            <c:when test="${h.fieldName == 'stage_id'}"><span class="field-badge" style="background:#f3e8ff;color:#6f42c1;">Stage</span></c:when>
                                            <c:when test="${h.fieldName == 'status'}"><span class="field-badge bg-primary-subtle text-primary">Trang thai</span></c:when>
                                            <c:when test="${h.fieldName == 'estimated_value'}"><span class="field-badge bg-success-subtle text-success">Gia tri</span></c:when>
                                            <c:when test="${h.fieldName == 'probability'}"><span class="field-badge bg-warning-subtle text-warning">Xac suat</span></c:when>
                                            <c:when test="${h.fieldName == 'opportunity_name'}"><span class="field-badge bg-info-subtle text-info">Ten</span></c:when>
                                            <c:when test="${h.fieldName == 'pipeline_id'}"><span class="field-badge bg-secondary-subtle text-secondary">Pipeline</span></c:when>
                                            <c:when test="${h.fieldName == 'expected_close_date'}"><span class="field-badge" style="background:#ede9fe;color:#6610f2;">Ngay dong</span></c:when>
                                            <c:when test="${h.fieldName == 'notes'}"><span class="field-badge bg-secondary-subtle text-secondary">Ghi chu</span></c:when>
                                            <c:when test="${h.fieldName == 'source_id'}"><span class="field-badge bg-secondary-subtle text-secondary">Nguon</span></c:when>
                                            <c:when test="${h.fieldName == 'campaign_id'}"><span class="field-badge bg-secondary-subtle text-secondary">Chien dich</span></c:when>
                                            <c:otherwise><span class="field-badge bg-light text-dark">${h.fieldName}</span></c:otherwise>
                                        </c:choose>

                                        <!-- Change values -->
                                        <div class="mt-2">
                                            <c:choose>
                                                <c:when test="${h.fieldName == 'status' && empty h.oldValue && h.newValue == 'Created'}">
                                                    <span class="new-val"><i class="bi bi-plus-circle me-1"></i>Tao moi opportunity</span>
                                                </c:when>
                                                <c:when test="${h.fieldName == 'stage_id'}">
                                                    <c:set var="oldStageKey" value="${h.oldValue}"/>
                                                    <c:set var="newStageKey" value="${h.newValue}"/>
                                                    <span class="old-val">${not empty stageIdNameMap[oldStageKey] ? stageIdNameMap[oldStageKey] : h.oldValue}</span>
                                                    <i class="bi bi-arrow-right change-arrow"></i>
                                                    <span class="new-val">${not empty stageIdNameMap[newStageKey] ? stageIdNameMap[newStageKey] : h.newValue}</span>
                                                </c:when>
                                                <c:when test="${h.fieldName == 'pipeline_id'}">
                                                    <c:set var="oldPipeKey" value="${h.oldValue}"/>
                                                    <c:set var="newPipeKey" value="${h.newValue}"/>
                                                    <span class="old-val">${not empty pipelineIdNameMap[oldPipeKey] ? pipelineIdNameMap[oldPipeKey] : h.oldValue}</span>
                                                    <i class="bi bi-arrow-right change-arrow"></i>
                                                    <span class="new-val">${not empty pipelineIdNameMap[newPipeKey] ? pipelineIdNameMap[newPipeKey] : h.newValue}</span>
                                                </c:when>
                                                <c:when test="${h.fieldName == 'estimated_value'}">
                                                    <span class="old-val">${not empty h.oldValue ? h.oldValue : '0'}d</span>
                                                    <i class="bi bi-arrow-right change-arrow"></i>
                                                    <span class="new-val">${not empty h.newValue ? h.newValue : '0'}d</span>
                                                </c:when>
                                                <c:when test="${h.fieldName == 'probability'}">
                                                    <span class="old-val">${not empty h.oldValue ? h.oldValue : '0'}%</span>
                                                    <i class="bi bi-arrow-right change-arrow"></i>
                                                    <span class="new-val">${not empty h.newValue ? h.newValue : '0'}%</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:if test="${not empty h.oldValue}">
                                                        <span class="old-val">${h.oldValue}</span>
                                                        <i class="bi bi-arrow-right change-arrow"></i>
                                                    </c:if>
                                                    <span class="new-val">${not empty h.newValue ? h.newValue : '(trong)'}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <!-- Timestamp + action -->
                                    <div class="text-end ms-3" style="min-width: 140px;">
                                        <small class="text-muted d-block">
                                            <c:if test="${not empty h.changedAt}">
                                                ${h.changedAt.toString().substring(0, 16).replace('T', ' ')}
                                            </c:if>
                                        </small>
                                        <a href="${pageContext.request.contextPath}/sale/opportunity/detail?id=${h.opportunityId}" class="btn btn-outline-primary btn-sm mt-1 py-0 px-2" style="font-size:11px;"><i class="bi bi-eye"></i></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <%-- Build base URL with filters preserved --%>
                <c:set var="baseUrl" value="${pageContext.request.contextPath}/sale/opportunity/history?"/>
                <c:set var="filterParams" value=""/>
                <c:if test="${not empty filterOppId}"><c:set var="filterParams" value="${filterParams}&oppId=${filterOppId}"/></c:if>
                <c:if test="${not empty filterField}"><c:set var="filterParams" value="${filterParams}&field=${filterField}"/></c:if>
                <c:if test="${not empty filterSearch}"><c:set var="filterParams" value="${filterParams}&search=${filterSearch}"/></c:if>

                <div class="card-footer bg-transparent d-flex justify-content-between align-items-center">
                    <small class="text-muted">Hien thi ${(currentPage - 1) * 20 + 1} - ${currentPage * 20 > totalItems ? totalItems : currentPage * 20} / ${totalItems} thay doi</small>
                    <nav>
                        <ul class="pagination pagination-sm mb-0">
                            <!-- Previous -->
                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <li class="page-item"><a class="page-link" href="${baseUrl}page=${currentPage - 1}${filterParams}">&laquo;</a></li>
                                </c:when>
                                <c:otherwise>
                                    <li class="page-item disabled"><span class="page-link">&laquo;</span></li>
                                </c:otherwise>
                            </c:choose>

                            <!-- First page -->
                            <c:if test="${currentPage > 3}">
                                <li class="page-item"><a class="page-link" href="${baseUrl}page=1${filterParams}">1</a></li>
                                <c:if test="${currentPage > 4}">
                                    <li class="page-item disabled"><span class="page-link">...</span></li>
                                </c:if>
                            </c:if>

                            <!-- Page numbers -->
                            <c:forEach begin="${currentPage - 2 > 0 ? currentPage - 2 : 1}" end="${currentPage + 2 < totalPages ? currentPage + 2 : totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="${baseUrl}page=${i}${filterParams}">${i}</a>
                                </li>
                            </c:forEach>

                            <!-- Last page -->
                            <c:if test="${currentPage < totalPages - 2}">
                                <c:if test="${currentPage < totalPages - 3}">
                                    <li class="page-item disabled"><span class="page-link">...</span></li>
                                </c:if>
                                <li class="page-item"><a class="page-link" href="${baseUrl}page=${totalPages}${filterParams}">${totalPages}</a></li>
                            </c:if>

                            <!-- Next -->
                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <li class="page-item"><a class="page-link" href="${baseUrl}page=${currentPage + 1}${filterParams}">&raquo;</a></li>
                                </c:when>
                                <c:otherwise>
                                    <li class="page-item disabled"><span class="page-link">&raquo;</span></li>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </nav>
                </div>
            </c:if>
        </div>
    </c:when>
    <c:otherwise>
        <div class="text-center py-5">
            <i class="bi bi-clock-history text-muted" style="font-size: 3rem;"></i>
            <p class="text-muted mt-3">Chua co thay doi nao duoc ghi nhan</p>
            <c:choose>
                <c:when test="${not empty filterOppId || not empty filterField || not empty filterSearch}">
                    <p class="text-muted small">Khong tim thay ket qua phu hop voi bo loc hien tai.</p>
                    <a href="${pageContext.request.contextPath}/sale/opportunity/history" class="btn btn-outline-primary btn-sm"><i class="bi bi-arrow-counterclockwise me-1"></i>Xoa bo loc</a>
                </c:when>
                <c:otherwise>
                    <p class="text-muted small">Khi ban cap nhat opportunity, cac thay doi se duoc luu lai o day.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </c:otherwise>
</c:choose>
