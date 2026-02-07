<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* Stats Cards */
    .stat-card {
        background: white;
        border-radius: 1rem;
        padding: 1.75rem;
        border: 1px solid #e2e8f0;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        position: relative;
        overflow: hidden;
    }

    .stat-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 3px;
        background: linear-gradient(90deg, #60a5fa, #3b82f6);
        opacity: 0;
        transition: opacity 0.3s;
    }

    .stat-card:hover {
        box-shadow: 0 10px 30px rgba(59, 130, 246, 0.15);
        transform: translateY(-4px);
        border-color: #60a5fa;
    }

    .stat-card:hover::before {
        opacity: 1;
    }

    .stat-icon-wrapper {
        width: 3.5rem;
        height: 3.5rem;
        border-radius: 1rem;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 1rem;
        position: relative;
    }

    .stat-icon-wrapper::after {
        content: '';
        position: absolute;
        width: 100%;
        height: 100%;
        border-radius: 1rem;
        opacity: 0.2;
        filter: blur(12px);
    }

    .stat-value {
        font-size: 2.25rem;
        font-weight: 800;
        color: #1e293b;
        margin-bottom: 0.5rem;
        letter-spacing: -0.02em;
    }

    .stat-label {
        font-size: 0.875rem;
        color: #64748b;
        font-weight: 500;
        margin-bottom: 0.75rem;
    }

    .stat-change {
        display: inline-flex;
        align-items: center;
        gap: 0.375rem;
        font-size: 0.8125rem;
        font-weight: 600;
        padding: 0.375rem 0.75rem;
        border-radius: 0.5rem;
    }

    .stat-change.positive {
        background: linear-gradient(135deg, #dcfce7, #bbf7d0);
        color: #16a34a;
    }

    .stat-change.negative {
        background: linear-gradient(135deg, #fee2e2, #fecaca);
        color: #dc2626;
    }

    /* Chart Card */
    .chart-card {
        background: white;
        border-radius: 1rem;
        padding: 1.75rem;
        border: 1px solid #e2e8f0;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
    }

    .chart-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 1.5rem;
    }

    .chart-title {
        font-size: 1.125rem;
        font-weight: 700;
        color: #1e293b;
    }

    .chart-subtitle {
        font-size: 0.875rem;
        color: #64748b;
        margin-top: 0.25rem;
    }

    /* Pipeline Stage */
    .pipeline-stage {
        padding: 1.25rem;
        background: #f8fafc;
        border-radius: 0.75rem;
        border-left: 4px solid transparent;
        transition: all 0.2s;
        cursor: pointer;
    }

    .pipeline-stage:hover {
        background: white;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        transform: translateX(4px);
    }

    .pipeline-stage.prospecting {
        border-left-color: #94a3b8;
    }

    .pipeline-stage.qualified {
        border-left-color: #22d3ee;
    }

    .pipeline-stage.proposal {
        border-left-color: #fbbf24;
    }

    .pipeline-stage.negotiation {
        border-left-color: #60a5fa;
    }

    .pipeline-stage.closed {
        border-left-color: #10b981;
    }

    .stage-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 0.75rem;
    }

    .stage-name {
        font-weight: 600;
        color: #1e293b;
        font-size: 0.9375rem;
    }

    .stage-count {
        font-size: 0.75rem;
        font-weight: 600;
        padding: 0.25rem 0.625rem;
        border-radius: 0.5rem;
        background: #e2e8f0;
        color: #475569;
    }

    .stage-value {
        font-size: 1.25rem;
        font-weight: 700;
        color: #1e293b;
        margin-bottom: 0.25rem;
    }

    .stage-conversion {
        font-size: 0.75rem;
        color: #64748b;
    }

    /* Activity Item */
    .activity-item {
        padding: 1rem;
        border-radius: 0.75rem;
        background: white;
        border: 1px solid #e2e8f0;
        transition: all 0.2s;
        cursor: pointer;
    }

    .activity-item:hover {
        border-color: #60a5fa;
        box-shadow: 0 4px 12px rgba(59, 130, 246, 0.1);
        transform: translateX(4px);
    }

    .activity-header {
        display: flex;
        justify-content: space-between;
        align-items: start;
        margin-bottom: 0.75rem;
    }

    .activity-title {
        font-weight: 600;
        color: #1e293b;
        font-size: 0.9375rem;
        margin-bottom: 0.25rem;
    }

    .activity-company {
        font-size: 0.8125rem;
        color: #64748b;
    }

    .activity-badge {
        padding: 0.25rem 0.75rem;
        border-radius: 1rem;
        font-size: 0.75rem;
        font-weight: 600;
        white-space: nowrap;
    }

    .activity-footer {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 0.75rem;
        padding-top: 0.75rem;
        border-top: 1px solid #f1f5f9;
    }

    .activity-value {
        font-size: 1rem;
        font-weight: 700;
    }

    .activity-time {
        font-size: 0.75rem;
        color: #94a3b8;
        display: flex;
        align-items: center;
        gap: 0.25rem;
    }

    /* Quick Action Button */
    .quick-action {
        width: 100%;
        padding: 1rem;
        border-radius: 0.75rem;
        border: none;
        font-weight: 600;
        font-size: 0.9375rem;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 0.625rem;
        transition: all 0.2s;
        position: relative;
        overflow: hidden;
    }

    .quick-action.primary {
        background: linear-gradient(135deg, #60a5fa, #3b82f6);
        color: white;
        box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
    }

    .quick-action.primary:hover {
        box-shadow: 0 8px 20px rgba(59, 130, 246, 0.4);
        transform: translateY(-2px);
    }

    .quick-action.secondary {
        background: white;
        color: #3b82f6;
        border: 2px solid #3b82f6;
    }

    .quick-action.secondary:hover {
        background: #3b82f6;
        color: white;
        transform: translateY(-2px);
    }

    .quick-action.tertiary {
        background: #f8fafc;
        color: #475569;
        border: 1px solid #e2e8f0;
    }

    .quick-action.tertiary:hover {
        background: white;
        border-color: #cbd5e1;
        transform: translateY(-2px);
    }

    /* Task Item */
    .task-item {
        display: flex;
        align-items: start;
        gap: 0.75rem;
        padding: 0.875rem;
        border-radius: 0.5rem;
        transition: background 0.2s;
    }

    .task-item:hover {
        background: #f8fafc;
    }

    .task-checkbox {
        width: 1.25rem;
        height: 1.25rem;
        border: 2px solid #cbd5e1;
        border-radius: 0.375rem;
        cursor: pointer;
        flex-shrink: 0;
        margin-top: 0.125rem;
    }

    .task-content {
        flex: 1;
    }

    .task-title {
        font-size: 0.875rem;
        font-weight: 500;
        color: #1e293b;
        margin-bottom: 0.25rem;
    }

    .task-meta {
        font-size: 0.75rem;
        color: #64748b;
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }

    .task-priority {
        display: inline-flex;
        align-items: center;
        gap: 0.25rem;
        padding: 0.125rem 0.5rem;
        border-radius: 0.375rem;
        font-size: 0.6875rem;
        font-weight: 600;
    }

    .task-priority.high {
        background: #fee2e2;
        color: #dc2626;
    }

    .task-priority.medium {
        background: #fef3c7;
        color: #f59e0b;
    }

    /* Section Header */
    .section-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 1.5rem;
    }

    .section-title {
        font-size: 1.5rem;
        font-weight: 700;
        color: #1e293b;
    }

    .section-subtitle {
        font-size: 0.9375rem;
        color: #64748b;
        margin-top: 0.25rem;
    }

    .view-all-link {
        color: #3b82f6;
        font-size: 0.875rem;
        font-weight: 600;
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 0.375rem;
        transition: gap 0.2s;
    }

    .view-all-link:hover {
        gap: 0.625rem;
    }

    /* Performer Card */
    .performer-card {
        padding: 1rem;
        background: #f8fafc;
        border-radius: 0.75rem;
        border: 1px solid #e2e8f0;
    }

    .performer-header {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        margin-bottom: 0.75rem;
    }

    .performer-avatar {
        width: 2.5rem;
        height: 2.5rem;
        border-radius: 0.625rem;
        background: linear-gradient(135deg, #60a5fa, #3b82f6);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: 700;
        font-size: 0.875rem;
    }

    .performer-info {
        flex: 1;
    }

    .performer-name {
        font-weight: 600;
        color: #1e293b;
        font-size: 0.9375rem;
    }

    .performer-role {
        font-size: 0.75rem;
        color: #64748b;
    }

    .performer-stats {
        display: flex;
        gap: 1rem;
    }

    .performer-stat {
        flex: 1;
    }

    .performer-stat-value {
        font-size: 1.125rem;
        font-weight: 700;
        color: #1e293b;
    }

    .performer-stat-label {
        font-size: 0.6875rem;
        color: #64748b;
        text-transform: uppercase;
        letter-spacing: 0.05em;
    }
</style>

<div>
    <!-- Page Header -->
    <div class="section-header">
        <div>
            <h1 class="section-title">Sales Dashboard</h1>
        </div>
        <div style="display: flex; gap: 0.75rem;">
            <select style="padding: 0.625rem 1rem; border: 1px solid #e2e8f0; border-radius: 0.5rem; font-size: 0.875rem; color: #475569; cursor: pointer;">
                <option>Tháng này</option>
                <option>Tháng trước</option>
                <option>Quý này</option>
                <option>Năm nay</option>
            </select>
            <button style="padding: 0.625rem 1.25rem; background: white; border: 1px solid #e2e8f0; border-radius: 0.5rem; color: #475569; font-weight: 500; cursor: pointer; display: flex; align-items: center; gap: 0.5rem;">
                <svg style="width: 1rem; height: 1rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"/>
                </svg>
                Xuất báo cáo
            </button>
        </div>
    </div>

    <!-- Key Metrics -->
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 1.5rem; margin-bottom: 2rem;">

        <!-- Total Pipeline Value -->
        <div class="stat-card">
            <div class="stat-icon-wrapper" style="background: linear-gradient(135deg, #dbeafe, #bfdbfe);">
                <svg style="width: 1.75rem; height: 1.75rem; color: #3b82f6;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
            </div>
            <div class="stat-value">18.7B</div>
            <div class="stat-label">Tổng giá trị Pipeline</div>
            <div class="stat-change positive">
                <svg style="width: 0.875rem; height: 0.875rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 10l7-7m0 0l7 7m-7-7v18"/>
                </svg>
                +15.3% vs tháng trước
            </div>
        </div>

        <!-- Active Opportunities -->
        <div class="stat-card">
            <div class="stat-icon-wrapper" style="background: linear-gradient(135deg, #fef3c7, #fde68a);">
                <svg style="width: 1.75rem; height: 1.75rem; color: #f59e0b;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
                </svg>
            </div>
            <div class="stat-value">64</div>
            <div class="stat-label">Opportunity đang mở</div>
            <div class="stat-change positive">
                <svg style="width: 0.875rem; height: 0.875rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 10l7-7m0 0l7 7m-7-7v18"/>
                </svg>
                +12 mới tuần này
            </div>
        </div>

        <!-- Win Rate -->
        <div class="stat-card">
            <div class="stat-icon-wrapper" style="background: linear-gradient(135deg, #d1fae5, #a7f3d0);">
                <svg style="width: 1.75rem; height: 1.75rem; color: #10b981;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
            </div>
            <div class="stat-value">72%</div>
            <div class="stat-label">Tỷ lệ Win Rate</div>
            <div class="stat-change positive">
                <svg style="width: 0.875rem; height: 0.875rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 10l7-7m0 0l7 7m-7-7v18"/>
                </svg>
                +7% cải thiện
            </div>
        </div>

        <!-- Average Deal Size -->
        <div class="stat-card">
            <div class="stat-icon-wrapper" style="background: linear-gradient(135deg, #fed7aa, #fdba74);">
                <svg style="width: 1.75rem; height: 1.75rem; color: #fb923c;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/>
                </svg>
            </div>
            <div class="stat-value">292M</div>
            <div class="stat-label">Giá trị TB / Deal</div>
            <div class="stat-change negative">
                <svg style="width: 0.875rem; height: 0.875rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M19 14l-7 7m0 0l-7-7m7 7V3"/>
                </svg>
                -4.2% vs mục tiêu
            </div>
        </div>

    </div>

    <!-- Main Content Grid -->
    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-bottom: 1.5rem;">

        <!-- Revenue Trend Chart -->
        <div class="chart-card">
            <div class="chart-header">
                <div>
                    <h3 class="chart-title">Xu hướng Doanh thu</h3>
                    <p class="chart-subtitle">6 tháng gần nhất</p>
                </div>
                <div style="display: flex; gap: 1rem; font-size: 0.75rem;">
                    <div style="display: flex; align-items: center; gap: 0.375rem;">
                        <div style="width: 0.75rem; height: 0.75rem; border-radius: 50%; background: #3b82f6;"></div>
                        <span style="color: #64748b;">Thực tế</span>
                    </div>
                    <div style="display: flex; align-items: center; gap: 0.375rem;">
                        <div style="width: 0.75rem; height: 0.75rem; border-radius: 50%; background: #fb923c;"></div>
                        <span style="color: #64748b;">Mục tiêu</span>
                    </div>
                </div>
            </div>
            <canvas id="revenueChart" height="280"></canvas>
        </div>

        <!-- Win/Loss Ratio -->
        <div class="chart-card">
            <div class="chart-header">
                <div>
                    <h3 class="chart-title">Tỷ lệ Thành công / Thất bại</h3>
                    <p class="chart-subtitle">Quý này</p>
                </div>
            </div>
            <div style="display: flex; align-items: center; justify-content: space-around;">
                <div style="text-align: center;">
                    <canvas id="winLossChart" width="200" height="200"></canvas>
                </div>
                <div style="display: flex; flex-direction: column; gap: 1rem;">
                    <div>
                        <div style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.5rem;">
                            <div style="width: 1rem; height: 1rem; border-radius: 0.25rem; background: #10b981;"></div>
                            <span style="font-weight: 600; color: #1e293b;">Won</span>
                        </div>
                        <div style="font-size: 1.5rem; font-weight: 700; color: #10b981; margin-bottom: 0.25rem;">28 deals</div>
                        <div style="font-size: 0.875rem; color: #64748b;">8.4B VNĐ</div>
                    </div>
                    <div>
                        <div style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.5rem;">
                            <div style="width: 1rem; height: 1rem; border-radius: 0.25rem; background: #ef4444;"></div>
                            <span style="font-weight: 600; color: #1e293b;">Lost</span>
                        </div>
                        <div style="font-size: 1.5rem; font-weight: 700; color: #ef4444; margin-bottom: 0.25rem;">11 deals</div>
                        <div style="font-size: 0.875rem; color: #64748b;">2.8B VNĐ</div>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- Pipeline Funnel & Quick Actions -->
    <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 1.5rem; margin-bottom: 1.5rem;">

        <!-- Pipeline Funnel -->
        <div class="chart-card">
            <div class="chart-header">
                <div>
                    <h3 class="chart-title">Pipeline Funnel</h3>
                    <p class="chart-subtitle">Phân bố theo giai đoạn</p>
                </div>
                <a href="#" class="view-all-link">
                    Xem Kanban
                    <svg style="width: 0.875rem; height: 0.875rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                    </svg>
                </a>
            </div>
            <div style="display: flex; flex-direction: column; gap: 1rem;">

                <div class="pipeline-stage prospecting">
                    <div class="stage-header">
                        <span class="stage-name">🔍 Prospecting</span>
                        <span class="stage-count">18 deals</span>
                    </div>
                    <div class="stage-value">3.2B VNĐ</div>
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <span class="stage-conversion">Conversion: 45%</span>
                        <div style="width: 60%; height: 6px; background: #e2e8f0; border-radius: 3px; overflow: hidden;">
                            <div style="width: 45%; height: 100%; background: #94a3b8; border-radius: 3px;"></div>
                        </div>
                    </div>
                </div>

                <div class="pipeline-stage qualified">
                    <div class="stage-header">
                        <span class="stage-name">✅ Qualified</span>
                        <span class="stage-count">15 deals</span>
                    </div>
                    <div class="stage-value">4.8B VNĐ</div>
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <span class="stage-conversion">Conversion: 65%</span>
                        <div style="width: 60%; height: 6px; background: #e2e8f0; border-radius: 3px; overflow: hidden;">
                            <div style="width: 65%; height: 100%; background: #22d3ee; border-radius: 3px;"></div>
                        </div>
                    </div>
                </div>

                <div class="pipeline-stage proposal">
                    <div class="stage-header">
                        <span class="stage-name">📄 Proposal</span>
                        <span class="stage-count">12 deals</span>
                    </div>
                    <div class="stage-value">3.9B VNĐ</div>
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <span class="stage-conversion">Conversion: 75%</span>
                        <div style="width: 60%; height: 6px; background: #e2e8f0; border-radius: 3px; overflow: hidden;">
                            <div style="width: 75%; height: 100%; background: #fbbf24; border-radius: 3px;"></div>
                        </div>
                    </div>
                </div>

                <div class="pipeline-stage negotiation">
                    <div class="stage-header">
                        <span class="stage-name">🤝 Negotiation</span>
                        <span class="stage-count">10 deals</span>
                    </div>
                    <div class="stage-value">4.2B VNĐ</div>
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <span class="stage-conversion">Conversion: 85%</span>
                        <div style="width: 60%; height: 6px; background: #e2e8f0; border-radius: 3px; overflow: hidden;">
                            <div style="width: 85%; height: 100%; background: #60a5fa; border-radius: 3px;"></div>
                        </div>
                    </div>
                </div>

                <div class="pipeline-stage closed">
                    <div class="stage-header">
                        <span class="stage-name">🎉 Closed Won</span>
                        <span class="stage-count">9 deals</span>
                    </div>
                    <div class="stage-value">2.6B VNĐ</div>
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <span class="stage-conversion">Tháng này</span>
                        <span style="font-size: 0.75rem; font-weight: 600; color: #10b981;">+18% vs tháng trước</span>
                    </div>
                </div>

            </div>
        </div>

        <!-- Quick Actions & Upcoming -->
        <div style="display: flex; flex-direction: column; gap: 1.5rem;">

            <!-- Quick Actions -->
            <div class="chart-card">
                <h3 class="chart-title" style="margin-bottom: 1rem;">Thao tác nhanh</h3>
                <div style="display: flex; flex-direction: column; gap: 0.75rem;">
                    <button class="quick-action primary">
                        <svg style="width: 1.125rem; height: 1.125rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                        </svg>
                        Tạo Opportunity
                    </button>

                    <button class="quick-action secondary">
                        <svg style="width: 1.125rem; height: 1.125rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                        </svg>
                        Tạo báo giá
                    </button>

                    <button class="quick-action tertiary">
                        <svg style="width: 1.125rem; height: 1.125rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                        </svg>
                        Đặt lịch hẹn
                    </button>
                </div>

                <hr style="margin: 1rem 0; border: none; border-top: 1px solid #e2e8f0;">

                <div style="display: flex; flex-direction: column; gap: 0.625rem;">
                    <a href="#" class="view-all-link" style="font-size: 0.8125rem;">
                        <svg style="width: 0.875rem; height: 0.875rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
                        </svg>
                        Pipeline Kanban
                    </a>
                    <a href="#" class="view-all-link" style="font-size: 0.8125rem;">
                        <svg style="width: 0.875rem; height: 0.875rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/>
                        </svg>
                        Sales Forecast
                    </a>
                    <a href="#" class="view-all-link" style="font-size: 0.8125rem;">
                        <svg style="width: 0.875rem; height: 0.875rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
                        </svg>
                        Danh sách Opportunity
                    </a>
                </div>
            </div>

            <!-- Upcoming Tasks -->
            <div class="chart-card">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                    <h3 class="chart-title">Công việc sắp tới</h3>
                    <span style="font-size: 0.75rem; color: #64748b; font-weight: 600;">Hôm nay</span>
                </div>
                <div style="display: flex; flex-direction: column; gap: 0.5rem;">

                    <div class="task-item">
                        <div class="task-checkbox"></div>
                        <div class="task-content">
                            <div class="task-title">Gọi follow-up ABC Corp</div>
                            <div class="task-meta">
                                <span>10:00 AM</span>
                                <span class="task-priority high">HIGH</span>
                            </div>
                        </div>
                    </div>

                    <div class="task-item">
                        <div class="task-checkbox"></div>
                        <div class="task-content">
                            <div class="task-title">Gửi proposal XYZ Ltd</div>
                            <div class="task-meta">
                                <span>2:30 PM</span>
                                <span class="task-priority high">HIGH</span>
                            </div>
                        </div>
                    </div>

                    <div class="task-item">
                        <div class="task-checkbox"></div>
                        <div class="task-content">
                            <div class="task-title">Meeting với DEF Group</div>
                            <div class="task-meta">
                                <span>4:00 PM</span>
                                <span class="task-priority medium">MEDIUM</span>
                            </div>
                        </div>
                    </div>

                </div>
                <a href="#" class="view-all-link" style="margin-top: 0.75rem; font-size: 0.8125rem;">
                    Xem tất cả
                    <svg style="width: 0.875rem; height: 0.875rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                    </svg>
                </a>
            </div>

        </div>

    </div>

    <!-- Recent Activities & Top Performers -->
    <div style="display: grid; grid-template-columns: 1.5fr 1fr; gap: 1.5rem;">

        <!-- Recent Opportunities -->
        <div class="chart-card">
            <div class="chart-header">
                <div>
                    <h3 class="chart-title">Opportunity gần đây</h3>
                    <p class="chart-subtitle">Cập nhật trong 24h</p>
                </div>
                <a href="#" class="view-all-link">
                    Xem tất cả
                    <svg style="width: 0.875rem; height: 0.875rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                    </svg>
                </a>
            </div>

            <div style="display: flex; flex-direction: column; gap: 1rem;">

                <div class="activity-item">
                    <div class="activity-header">
                        <div>
                            <div class="activity-title">Hợp đồng ERP - ABC Corporation</div>
                            <div class="activity-company">ABC Corporation • Enterprise</div>
                        </div>
                        <span class="activity-badge" style="background: linear-gradient(135deg, #60a5fa, #3b82f6); color: white;">
                            Negotiation
                        </span>
                    </div>
                    <div style="font-size: 0.8125rem; color: #475569; margin-bottom: 0.5rem;">
                        Đang đàm phán điều khoản thanh toán và thời hạn triển khai
                    </div>
                    <div class="activity-footer">
                        <span class="activity-value" style="color: #3b82f6;">1.45B VNĐ</span>
                        <span class="activity-time">
                            <svg style="width: 0.875rem; height: 0.875rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                            </svg>
                            2 giờ trước
                        </span>
                    </div>
                </div>

                <div class="activity-item">
                    <div class="activity-header">
                        <div>
                            <div class="activity-title">Dự án CRM Cloud - XYZ Limited</div>
                            <div class="activity-company">XYZ Limited • Mid-Market</div>
                        </div>
                        <span class="activity-badge" style="background: linear-gradient(135deg, #fbbf24, #f59e0b); color: white;">
                            Proposal
                        </span>
                    </div>
                    <div style="font-size: 0.8125rem; color: #475569; margin-bottom: 0.5rem;">
                        Đã gửi proposal chi tiết, chờ phản hồi từ Board
                    </div>
                    <div class="activity-footer">
                        <span class="activity-value" style="color: #f59e0b;">925M VNĐ</span>
                        <span class="activity-time">
                            <svg style="width: 0.875rem; height: 0.875rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                            </svg>
                            5 giờ trước
                        </span>
                    </div>
                </div>

                <div class="activity-item">
                    <div class="activity-header">
                        <div>
                            <div class="activity-title">Hệ thống HRM - DEF Group</div>
                            <div class="activity-company">DEF Group • Enterprise</div>
                        </div>
                        <span class="activity-badge" style="background: linear-gradient(135deg, #34d399, #10b981); color: white;">
                            Qualified
                        </span>
                    </div>
                    <div style="font-size: 0.8125rem; color: #475569; margin-bottom: 0.5rem;">
                        Hoàn thành demo sản phẩm, khách hàng rất hài lòng
                    </div>
                    <div class="activity-footer">
                        <span class="activity-value" style="color: #10b981;">2.8B VNĐ</span>
                        <span class="activity-time">
                            <svg style="width: 0.875rem; height: 0.875rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                            </svg>
                            Hôm qua
                        </span>
                    </div>
                </div>

                <div class="activity-item">
                    <div class="activity-header">
                        <div>
                            <div class="activity-title">Platform Integration - GHI Tech</div>
                            <div class="activity-company">GHI Technology • SMB</div>
                        </div>
                        <span class="activity-badge" style="background: linear-gradient(135deg, #22d3ee, #06b6d4); color: white;">
                            Qualified
                        </span>
                    </div>
                    <div style="font-size: 0.8125rem; color: #475569; margin-bottom: 0.5rem;">
                        Đã xác nhận budget và timeline, chuẩn bị proposal
                    </div>
                    <div class="activity-footer">
                        <span class="activity-value" style="color: #06b6d4;">480M VNĐ</span>
                        <span class="activity-time">
                            <svg style="width: 0.875rem; height: 0.875rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                            </svg>
                            2 ngày trước
                        </span>
                    </div>
                </div>

            </div>
        </div>

        <!-- Top Performers -->
        <div class="chart-card">
            <div class="chart-header">
                <div>
                    <h3 class="chart-title">Top Performers</h3>
                    <p class="chart-subtitle">Tháng này</p>
                </div>
            </div>

            <div style="display: flex; flex-direction: column; gap: 1rem;">

                <div class="performer-card" style="border-left: 3px solid #fbbf24;">
                    <div class="performer-header">
                        <div class="performer-avatar" style="background: linear-gradient(135deg, #fbbf24, #f59e0b);">
                            NT
                        </div>
                        <div class="performer-info">
                            <div class="performer-name">Nguyễn Thanh</div>
                            <div class="performer-role">Senior Sales</div>
                        </div>
                        <div style="font-size: 1.5rem;">🏆</div>
                    </div>
                    <div class="performer-stats">
                        <div class="performer-stat">
                            <div class="performer-stat-value">12</div>
                            <div class="performer-stat-label">Deals</div>
                        </div>
                        <div class="performer-stat">
                            <div class="performer-stat-value">3.2B</div>
                            <div class="performer-stat-label">Revenue</div>
                        </div>
                        <div class="performer-stat">
                            <div class="performer-stat-value">85%</div>
                            <div class="performer-stat-label">Win Rate</div>
                        </div>
                    </div>
                </div>

                <div class="performer-card" style="border-left: 3px solid #cbd5e1;">
                    <div class="performer-header">
                        <div class="performer-avatar" style="background: linear-gradient(135deg, #94a3b8, #64748b);">
                            LM
                        </div>
                        <div class="performer-info">
                            <div class="performer-name">Lê Mai</div>
                            <div class="performer-role">Sales Executive</div>
                        </div>
                        <div style="font-size: 1.5rem;">🥈</div>
                    </div>
                    <div class="performer-stats">
                        <div class="performer-stat">
                            <div class="performer-stat-value">10</div>
                            <div class="performer-stat-label">Deals</div>
                        </div>
                        <div class="performer-stat">
                            <div class="performer-stat-value">2.8B</div>
                            <div class="performer-stat-label">Revenue</div>
                        </div>
                        <div class="performer-stat">
                            <div class="performer-stat-value">78%</div>
                            <div class="performer-stat-label">Win Rate</div>
                        </div>
                    </div>
                </div>

                <div class="performer-card" style="border-left: 3px solid #fb923c;">
                    <div class="performer-header">
                        <div class="performer-avatar" style="background: linear-gradient(135deg, #fb923c, #f97316);">
                            PH
                        </div>
                        <div class="performer-info">
                            <div class="performer-name">Phạm Huy</div>
                            <div class="performer-role">Sales Manager</div>
                        </div>
                        <div style="font-size: 1.5rem;">🥉</div>
                    </div>
                    <div class="performer-stats">
                        <div class="performer-stat">
                            <div class="performer-stat-value">9</div>
                            <div class="performer-stat-label">Deals</div>
                        </div>
                        <div class="performer-stat">
                            <div class="performer-stat-value">2.4B</div>
                            <div class="performer-stat-label">Revenue</div>
                        </div>
                        <div class="performer-stat">
                            <div class="performer-stat-value">72%</div>
                            <div class="performer-stat-label">Win Rate</div>
                        </div>
                    </div>
                </div>

            </div>
        </div>

    </div>

</div>

<!-- Chart.js Scripts -->
<script>
// Revenue Trend Chart
    const revenueCtx = document.getElementById('revenueChart').getContext('2d');
    new Chart(revenueCtx, {
        type: 'line',
        data: {
            labels: ['Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12', 'Tháng 1', 'Tháng 2'],
            datasets: [
                {
                    label: 'Doanh thu thực tế',
                    data: [2200, 2800, 3100, 2900, 3400, 3800],
                    borderColor: '#3b82f6',
                    backgroundColor: 'rgba(59, 130, 246, 0.1)',
                    tension: 0.4,
                    fill: true,
                    borderWidth: 3,
                    pointRadius: 5,
                    pointHoverRadius: 7,
                    pointBackgroundColor: '#3b82f6',
                    pointBorderColor: '#fff',
                    pointBorderWidth: 2
                },
                {
                    label: 'Mục tiêu',
                    data: [2500, 2700, 2900, 3100, 3300, 3500],
                    borderColor: '#fb923c',
                    backgroundColor: 'rgba(251, 146, 60, 0.1)',
                    tension: 0.4,
                    fill: true,
                    borderWidth: 3,
                    borderDash: [5, 5],
                    pointRadius: 5,
                    pointHoverRadius: 7,
                    pointBackgroundColor: '#fb923c',
                    pointBorderColor: '#fff',
                    pointBorderWidth: 2
                }
            ]
        }

    });

// Win/Loss Chart
    const winLossCtx = document.getElementById('winLossChart').getContext('2d');
    new Chart(winLossCtx, {
        type: 'doughnut',
        data: {
            labels: ['Won', 'Lost'],
            datasets: [{
                    data: [28, 11],
                    backgroundColor: [
                        '#10b981',
                        '#ef4444'
                    ],
                    borderWidth: 0,
                    hoverOffset: 10
                }]
        }

    });
</script>
