<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-1 fw-bold">
            <i class="bi bi-clock-history me-2 text-primary"></i>
            <c:choose>
                <c:when test="${not empty selectedOpp}">Lich su: ${selectedOpp.opportunityName}
                    <small class="text-muted fw-normal ms-1">(${selectedOpp.opportunityCode})</small>
                </c:when>
                <c:otherwise>Lich su thay doi Opportunity</c:otherwise>
            </c:choose>
        </h4>
        <p class="text-muted mb-0 small">
            <c:choose>
                <c:when test="${totalItems > 0}"><i class="bi bi-activity me-1"></i>${totalItems} thay doi duoc ghi nhan</c:when>
                <c:otherwise>Chua co thay doi nao</c:otherwise>
            </c:choose>
        </p>
    </div>
    <div class="d-flex gap-2">
        <c:if test="${not empty filterOppId}">
            <a href="${pageContext.request.contextPath}/sale/opportunity/detail?id=${filterOppId}" class="btn btn-outline-primary btn-sm"><i class="bi bi-eye me-1"></i>Chi tiet</a>
        </c:if>
        <a href="${pageContext.request.contextPath}/sale/opportunity/list" class="btn btn-outline-secondary btn-sm"><i class="bi bi-list me-1"></i>Danh sach</a>
    </div>
</div>

<!-- KPI -->
<c:if test="${totalItems > 0}">
    <div class="row g-3 mb-4">
        <div class="col-6 col-md-3">
            <div class="card border-0 shadow-sm text-center p-3">
                <h3 class="fw-bold text-primary mb-0">${totalItems}</h3>
                <small class="text-muted">Tong thay doi</small>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="card border-0 shadow-sm text-center p-3">
                <h3 class="fw-bold text-purple mb-0" style="color:#7c3aed">${totalStageChanges}</h3>
                <small class="text-muted">Chuyen stage</small>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="card border-0 shadow-sm text-center p-3">
                <h3 class="fw-bold text-info mb-0">${totalStatusChanges}</h3>
                <small class="text-muted">Doi trang thai</small>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="card border-0 shadow-sm text-center p-3">
                <h3 class="fw-bold text-success mb-0">${totalValueChanges}</h3>
                <small class="text-muted">Cap nhat gia tri</small>
            </div>
        </div>
    </div>
</c:if>

<!-- Filter -->
<div class="card border-0 shadow-sm mb-4">
    <div class="card-body py-3">
        <form method="GET" action="${pageContext.request.contextPath}/sale/opportunity/history" class="row g-2 align-items-end">
            <div class="col-md-3">
                <label class="form-label small text-muted mb-1">Opportunity</label>
                <select name="oppId" class="form-select form-select-sm" onchange="this.form.submit()">
                    <option value="">-- Tat ca --</option>
                    <c:forEach var="opp" items="${userOpps}">
                        <option value="${opp.opportunityId}" ${filterOppId == opp.opportunityId ? 'selected' : ''}>${opp.opportunityName}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-3">
                <label class="form-label small text-muted mb-1">Loai thay doi</label>
                <select name="field" class="form-select form-select-sm" onchange="this.form.submit()">
                    <option value="">-- Tat ca --</option>
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
            <div class="col-md-3">
                <label class="form-label small text-muted mb-1">Tim kiem</label>
                <div class="input-group input-group-sm">
                    <input type="text" name="search" class="form-control" placeholder="Tu khoa..." value="${filterSearch}"/>
                    <button type="submit" class="btn btn-outline-primary btn-sm"><i class="bi bi-search"></i></button>
                </div>
            </div>
            <div class="col-md-3">
                <a href="${pageContext.request.contextPath}/sale/opportunity/history" class="btn btn-outline-secondary btn-sm w-100"><i class="bi bi-arrow-counterclockwise me-1"></i>Xoa loc</a>
            </div>
        </form>

        <c:if test="${not empty filterOppId || not empty filterField || not empty filterSearch}">
            <div class="mt-2 d-flex gap-2 flex-wrap">
                <small class="text-muted me-1">Dang loc:</small>
                <c:if test="${not empty filterOppId && not empty selectedOpp}">
                    <span class="badge bg-primary">${selectedOpp.opportunityName}
                        <a href="${pageContext.request.contextPath}/sale/opportunity/history?${not empty filterField ? 'field='.concat(filterField) : ''}${not empty filterSearch ? '&search='.concat(filterSearch) : ''}" class="text-white ms-1">&times;</a>
                    </span>
                </c:if>
                <c:if test="${not empty filterField}">
                    <span class="badge bg-info">
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
                        <a href="${pageContext.request.contextPath}/sale/opportunity/history?${not empty filterOppId ? 'oppId='.concat(filterOppId) : ''}${not empty filterSearch ? '&search='.concat(filterSearch) : ''}" class="text-white ms-1">&times;</a>
                    </span>
                </c:if>
                <c:if test="${not empty filterSearch}">
                    <span class="badge bg-warning text-dark">"${filterSearch}"
                        <a href="${pageContext.request.contextPath}/sale/opportunity/history?${not empty filterOppId ? 'oppId='.concat(filterOppId) : ''}${not empty filterField ? '&field='.concat(filterField) : ''}" class="text-dark ms-1">&times;</a>
                    </span>
                </c:if>
            </div>
        </c:if>
    </div>
</div>

<!-- History Table -->
<c:choose>
    <c:when test="${not empty historyList}">
        <div class="card border-0 shadow-sm">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-3" style="width:170px;">Thoi gian</th>
                            <c:if test="${empty filterOppId}">
                                <th>Opportunity</th>
                            </c:if>
                            <th style="width:120px;">Loai</th>
                            <th>Gia tri cu</th>
                            <th></th>
                            <th>Gia tri moi</th>
                            <th style="width:50px;"></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="h" items="${historyList}">
                            <tr>
                                <!-- Thoi gian -->
                                <td class="ps-3">
                                    <small class="text-muted">
                                        <i class="bi bi-clock me-1"></i>${h.changedAt.toString().substring(0, 16).replace('T', ' ')}
                                    </small>
                                </td>

                                <!-- Opp name -->
                                <c:if test="${empty filterOppId}">
                                    <td>
                                        <a href="${pageContext.request.contextPath}/sale/opportunity/history?oppId=${h.opportunityId}" class="text-decoration-none fw-semibold small">
                                            ${not empty oppNameMap[h.opportunityId] ? oppNameMap[h.opportunityId] : 'Opportunity #'.concat(h.opportunityId)}
                                        </a>
                                    </td>
                                </c:if>

                                <!-- Loai thay doi -->
                                <td>
                                    <c:choose>
                                        <c:when test="${h.fieldName == 'status' && empty h.oldValue && h.newValue == 'Created'}"><span class="badge bg-success"><i class="bi bi-plus-circle me-1"></i>Tao moi</span></c:when>
                                        <c:when test="${h.fieldName == 'stage_id'}"><span class="badge bg-purple" style="background-color:#7c3aed"><i class="bi bi-signpost-split me-1"></i>Stage</span></c:when>
                                        <c:when test="${h.fieldName == 'status'}"><span class="badge bg-primary"><i class="bi bi-flag me-1"></i>Trang thai</span></c:when>
                                        <c:when test="${h.fieldName == 'estimated_value'}"><span class="badge bg-success"><i class="bi bi-currency-dollar me-1"></i>Gia tri</span></c:when>
                                        <c:when test="${h.fieldName == 'probability'}"><span class="badge bg-warning text-dark"><i class="bi bi-percent me-1"></i>Xac suat</span></c:when>
                                        <c:when test="${h.fieldName == 'opportunity_name'}"><span class="badge bg-info"><i class="bi bi-pencil me-1"></i>Ten</span></c:when>
                                        <c:when test="${h.fieldName == 'pipeline_id'}"><span class="badge bg-secondary"><i class="bi bi-diagram-3 me-1"></i>Pipeline</span></c:when>
                                        <c:when test="${h.fieldName == 'expected_close_date'}"><span class="badge bg-dark"><i class="bi bi-calendar-event me-1"></i>Ngay dong</span></c:when>
                                        <c:when test="${h.fieldName == 'notes'}"><span class="badge bg-secondary"><i class="bi bi-journal-text me-1"></i>Ghi chu</span></c:when>
                                        <c:when test="${h.fieldName == 'source_id'}"><span class="badge bg-danger"><i class="bi bi-box-arrow-in-right me-1"></i>Nguon</span></c:when>
                                        <c:when test="${h.fieldName == 'campaign_id'}"><span class="badge bg-warning text-dark"><i class="bi bi-megaphone me-1"></i>Chien dich</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary">${h.fieldName}</span></c:otherwise>
                                    </c:choose>
                                </td>

                                <!-- Old value -->
                                <td>
                                    <c:choose>
                                        <c:when test="${h.fieldName == 'status' && empty h.oldValue && h.newValue == 'Created'}">
                                            <span class="text-muted">-</span>
                                        </c:when>
                                        <c:when test="${h.fieldName == 'stage_id'}">
                                            <c:set var="oldSK" value="${h.oldValue}"/>
                                            <span class="text-danger"><s>${not empty stageIdNameMap[oldSK] ? stageIdNameMap[oldSK] : h.oldValue}</s></span>
                                        </c:when>
                                        <c:when test="${h.fieldName == 'pipeline_id'}">
                                            <c:set var="oldPK" value="${h.oldValue}"/>
                                            <span class="text-danger"><s>${not empty pipelineIdNameMap[oldPK] ? pipelineIdNameMap[oldPK] : h.oldValue}</s></span>
                                        </c:when>
                                        <c:when test="${h.fieldName == 'estimated_value'}">
                                            <span class="text-danger"><s>${not empty h.oldValue ? h.oldValue : '0'} VND</s></span>
                                        </c:when>
                                        <c:when test="${h.fieldName == 'probability'}">
                                            <span class="text-danger"><s>${not empty h.oldValue ? h.oldValue : '0'}%</s></span>
                                        </c:when>
                                        <c:when test="${h.fieldName == 'status'}">
                                            <c:choose>
                                                <c:when test="${h.oldValue == 'Won'}"><span class="badge bg-success">${h.oldValue}</span></c:when>
                                                <c:when test="${h.oldValue == 'Lost'}"><span class="badge bg-danger">${h.oldValue}</span></c:when>
                                                <c:when test="${h.oldValue == 'Open'}"><span class="badge bg-primary">${h.oldValue}</span></c:when>
                                                <c:when test="${h.oldValue == 'InProgress'}"><span class="badge bg-info">${h.oldValue}</span></c:when>
                                                <c:otherwise><span class="text-muted">${not empty h.oldValue ? h.oldValue : '-'}</span></c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <c:choose>
                                                <c:when test="${not empty h.oldValue}"><span class="text-danger"><s>${h.oldValue}</s></span></c:when>
                                                <c:otherwise><span class="text-muted">-</span></c:otherwise>
                                            </c:choose>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <!-- Arrow -->
                                <td class="text-center" style="width:30px;">
                                    <c:if test="${!(h.fieldName == 'status' && empty h.oldValue && h.newValue == 'Created')}">
                                        <i class="bi bi-arrow-right text-muted"></i>
                                    </c:if>
                                </td>

                                <!-- New value -->
                                <td>
                                    <c:choose>
                                        <c:when test="${h.fieldName == 'status' && empty h.oldValue && h.newValue == 'Created'}">
                                            <span class="badge bg-success"><i class="bi bi-star-fill me-1"></i>Tao moi opportunity</span>
                                        </c:when>
                                        <c:when test="${h.fieldName == 'stage_id'}">
                                            <c:set var="newSK" value="${h.newValue}"/>
                                            <strong class="text-success">${not empty stageIdNameMap[newSK] ? stageIdNameMap[newSK] : h.newValue}</strong>
                                        </c:when>
                                        <c:when test="${h.fieldName == 'pipeline_id'}">
                                            <c:set var="newPK" value="${h.newValue}"/>
                                            <strong class="text-success">${not empty pipelineIdNameMap[newPK] ? pipelineIdNameMap[newPK] : h.newValue}</strong>
                                        </c:when>
                                        <c:when test="${h.fieldName == 'estimated_value'}">
                                            <strong class="text-success">${not empty h.newValue ? h.newValue : '0'} VND</strong>
                                        </c:when>
                                        <c:when test="${h.fieldName == 'probability'}">
                                            <strong class="text-success">${not empty h.newValue ? h.newValue : '0'}%</strong>
                                        </c:when>
                                        <c:when test="${h.fieldName == 'status'}">
                                            <c:choose>
                                                <c:when test="${h.newValue == 'Won'}"><span class="badge bg-success">${h.newValue}</span></c:when>
                                                <c:when test="${h.newValue == 'Lost'}"><span class="badge bg-danger">${h.newValue}</span></c:when>
                                                <c:when test="${h.newValue == 'Open'}"><span class="badge bg-primary">${h.newValue}</span></c:when>
                                                <c:when test="${h.newValue == 'InProgress'}"><span class="badge bg-info">${h.newValue}</span></c:when>
                                                <c:otherwise><strong class="text-success">${not empty h.newValue ? h.newValue : '-'}</strong></c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <strong class="text-success">${not empty h.newValue ? h.newValue : '(trong)'}</strong>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <!-- Action -->
                                <td>
                                    <a href="${pageContext.request.contextPath}/sale/opportunity/detail?id=${h.opportunityId}" class="btn btn-outline-secondary btn-sm py-0 px-1" title="Xem"><i class="bi bi-box-arrow-up-right"></i></a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <c:set var="baseUrl" value="${pageContext.request.contextPath}/sale/opportunity/history?"/>
                <c:set var="filterParams" value=""/>
                <c:if test="${not empty filterOppId}"><c:set var="filterParams" value="${filterParams}&oppId=${filterOppId}"/></c:if>
                <c:if test="${not empty filterField}"><c:set var="filterParams" value="${filterParams}&field=${filterField}"/></c:if>
                <c:if test="${not empty filterSearch}"><c:set var="filterParams" value="${filterParams}&search=${filterSearch}"/></c:if>

                <div class="card-footer bg-transparent d-flex justify-content-between align-items-center">
                    <small class="text-muted">
                        Hien thi ${(currentPage - 1) * 20 + 1} - ${currentPage * 20 > totalItems ? totalItems : currentPage * 20} / ${totalItems}
                    </small>
                    <nav>
                        <ul class="pagination pagination-sm mb-0">
                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <li class="page-item"><a class="page-link" href="${baseUrl}page=${currentPage - 1}${filterParams}">&laquo;</a></li>
                                </c:when>
                                <c:otherwise>
                                    <li class="page-item disabled"><span class="page-link">&laquo;</span></li>
                                </c:otherwise>
                            </c:choose>

                            <c:if test="${currentPage > 3}">
                                <li class="page-item"><a class="page-link" href="${baseUrl}page=1${filterParams}">1</a></li>
                                <c:if test="${currentPage > 4}"><li class="page-item disabled"><span class="page-link">...</span></li></c:if>
                            </c:if>

                            <c:forEach begin="${currentPage - 2 > 0 ? currentPage - 2 : 1}" end="${currentPage + 2 < totalPages ? currentPage + 2 : totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="${baseUrl}page=${i}${filterParams}">${i}</a>
                                </li>
                            </c:forEach>

                            <c:if test="${currentPage < totalPages - 2}">
                                <c:if test="${currentPage < totalPages - 3}"><li class="page-item disabled"><span class="page-link">...</span></li></c:if>
                                <li class="page-item"><a class="page-link" href="${baseUrl}page=${totalPages}${filterParams}">${totalPages}</a></li>
                            </c:if>

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
        <div class="card border-0 shadow-sm">
            <div class="card-body text-center py-5">
                <i class="bi bi-clock-history text-muted" style="font-size:3rem;"></i>
                <h5 class="text-muted mt-3 mb-2">Chua co thay doi nao</h5>
                <c:choose>
                    <c:when test="${not empty filterOppId || not empty filterField || not empty filterSearch}">
                        <p class="text-muted small mb-3">Khong tim thay ket qua phu hop.</p>
                        <a href="${pageContext.request.contextPath}/sale/opportunity/history" class="btn btn-outline-primary btn-sm"><i class="bi bi-arrow-counterclockwise me-1"></i>Xoa bo loc</a>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted small mb-0">Khi ban cap nhat opportunity, cac thay doi se duoc ghi nhan tai day.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </c:otherwise>
</c:choose>
