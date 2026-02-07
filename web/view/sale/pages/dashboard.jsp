<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!-- KPI Cards -->
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-6">
    
    <!-- Total Revenue -->
    <div class="bg-gradient-to-br from-blue-500 to-blue-600 rounded-xl p-6 text-white shadow-lg hover:shadow-xl transition-shadow">
        <div class="flex items-center justify-between mb-4">
            <div class="p-3 bg-white/20 rounded-lg backdrop-blur-sm">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
            </div>
            <span class="px-2 py-1 bg-white/20 rounded-full text-xs font-semibold backdrop-blur-sm">+12.5%</span>
        </div>
        <h3 class="text-sm font-medium opacity-90">Total Revenue</h3>
        <p class="text-3xl font-bold mt-2">$1,245,890</p>
        <p class="text-xs opacity-75 mt-2">vs last month: $1,108,500</p>
    </div>
    
    <!-- Total Opportunities -->
    <div class="bg-gradient-to-br from-indigo-500 to-indigo-600 rounded-xl p-6 text-white shadow-lg hover:shadow-xl transition-shadow">
        <div class="flex items-center justify-between mb-4">
            <div class="p-3 bg-white/20 rounded-lg backdrop-blur-sm">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
            </div>
            <span class="px-2 py-1 bg-white/20 rounded-full text-xs font-semibold backdrop-blur-sm">+8.2%</span>
        </div>
        <h3 class="text-sm font-medium opacity-90">Active Opportunities</h3>
        <p class="text-3xl font-bold mt-2">156</p>
        <p class="text-xs opacity-75 mt-2">Total value: $2,450,000</p>
    </div>
    
    <!-- Win Rate -->
    <div class="bg-gradient-to-br from-green-500 to-green-600 rounded-xl p-6 text-white shadow-lg hover:shadow-xl transition-shadow">
        <div class="flex items-center justify-between mb-4">
            <div class="p-3 bg-white/20 rounded-lg backdrop-blur-sm">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/>
                </svg>
            </div>
            <span class="px-2 py-1 bg-white/20 rounded-full text-xs font-semibold backdrop-blur-sm">+3.1%</span>
        </div>
        <h3 class="text-sm font-medium opacity-90">Win Rate</h3>
        <p class="text-3xl font-bold mt-2">42.5%</p>
        <p class="text-xs opacity-75 mt-2">34 won / 80 total deals</p>
    </div>
    
    <!-- Avg Deal Size -->
    <div class="bg-gradient-to-br from-purple-500 to-purple-600 rounded-xl p-6 text-white shadow-lg hover:shadow-xl transition-shadow">
        <div class="flex items-center justify-between mb-4">
            <div class="p-3 bg-white/20 rounded-lg backdrop-blur-sm">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
                </svg>
            </div>
            <span class="px-2 py-1 bg-white/20 rounded-full text-xs font-semibold backdrop-blur-sm">+5.8%</span>
        </div>
        <h3 class="text-sm font-medium opacity-90">Avg Deal Size</h3>
        <p class="text-3xl font-bold mt-2">$36,643</p>
        <p class="text-xs opacity-75 mt-2">vs last month: $34,650</p>
    </div>
    
</div>

<!-- Charts Row -->
<div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
    
    
    <!-- Pipeline by Stage -->
    <div class="bg-white rounded-xl p-6 shadow-sm border border-slate-200">
        <div class="flex items-center justify-between mb-6">
            <h3 class="text-lg font-semibold text-slate-800">Pipeline by Stage</h3>
            <span class="text-sm text-slate-500">Total: $2,450,000</span>
        </div>
        <canvas id="pipelineChart" height="250"></canvas>
    </div>
       
 <!-- Revenue Trend Chart -->
    <div class="bg-white rounded-xl p-6 shadow-sm border border-slate-200">
        <div class="flex items-center justify-between mb-6">
            <h3 class="text-lg font-semibold text-slate-800">Revenue Trend</h3>
            <div class="flex gap-2">
                <button class="px-3 py-1 text-xs font-medium bg-blue-100 text-blue-700 rounded-lg">Monthly</button>
                <button class="px-3 py-1 text-xs font-medium text-slate-600 hover:bg-slate-100 rounded-lg">Quarterly</button>
            </div>
        </div>
        <canvas id="revenueChart" height="250"></canvas>
    </div>
</div>

<!-- Pipeline Stages Overview -->
<div class="bg-white rounded-xl p-6 shadow-sm border border-slate-200 mb-6">
    <h3 class="text-lg font-semibold text-slate-800 mb-6">Sales Pipeline Overview</h3>
    
    <div class="grid grid-cols-1 md:grid-cols-5 gap-4">
        
        <!-- Prospecting -->
        <div class="border-l-4 border-blue-500 pl-4">
            <div class="flex items-center justify-between mb-2">
                <h4 class="text-sm font-semibold text-slate-700">Prospecting</h4>
                <span class="text-xs text-slate-500">45 deals</span>
            </div>
            <p class="text-2xl font-bold text-blue-600">$450,000</p>
            <div class="mt-3 h-2 bg-slate-100 rounded-full overflow-hidden">
                <div class="h-full bg-blue-500 rounded-full" style="width: 18.4%"></div>
            </div>
        </div>
        
        <!-- Qualification -->
        <div class="border-l-4 border-indigo-500 pl-4">
            <div class="flex items-center justify-between mb-2">
                <h4 class="text-sm font-semibold text-slate-700">Qualification</h4>
                <span class="text-xs text-slate-500">38 deals</span>
            </div>
            <p class="text-2xl font-bold text-indigo-600">$580,000</p>
            <div class="mt-3 h-2 bg-slate-100 rounded-full overflow-hidden">
                <div class="h-full bg-indigo-500 rounded-full" style="width: 23.7%"></div>
            </div>
        </div>
        
        <!-- Proposal -->
        <div class="border-l-4 border-purple-500 pl-4">
            <div class="flex items-center justify-between mb-2">
                <h4 class="text-sm font-semibold text-slate-700">Proposal</h4>
                <span class="text-xs text-slate-500">28 deals</span>
            </div>
            <p class="text-2xl font-bold text-purple-600">$620,000</p>
            <div class="mt-3 h-2 bg-slate-100 rounded-full overflow-hidden">
                <div class="h-full bg-purple-500 rounded-full" style="width: 25.3%"></div>
            </div>
        </div>
        
        <!-- Negotiation -->
        <div class="border-l-4 border-orange-500 pl-4">
            <div class="flex items-center justify-between mb-2">
                <h4 class="text-sm font-semibold text-slate-700">Negotiation</h4>
                <span class="text-xs text-slate-500">23 deals</span>
            </div>
            <p class="text-2xl font-bold text-orange-600">$480,000</p>
            <div class="mt-3 h-2 bg-slate-100 rounded-full overflow-hidden">
                <div class="h-full bg-orange-500 rounded-full" style="width: 19.6%"></div>
            </div>
        </div>
        
        <!-- Closing -->
        <div class="border-l-4 border-green-500 pl-4">
            <div class="flex items-center justify-between mb-2">
                <h4 class="text-sm font-semibold text-slate-700">Closing</h4>
                <span class="text-xs text-slate-500">22 deals</span>
            </div>
            <p class="text-2xl font-bold text-green-600">$320,000</p>
            <div class="mt-3 h-2 bg-slate-100 rounded-full overflow-hidden">
                <div class="h-full bg-green-500 rounded-full" style="width: 13%"></div>
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
            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
            datasets: [{
                label: 'Revenue',
                data: [8500, 9200, 9800, 1050, 1120, 1180, 115000, 1200, 11800, 1220, 11900, 1290],
                borderColor: 'rgb(59, 130, 246)',
                backgroundColor: 'rgba(59, 130, 246, 0.1)',
                tension: 0.4,
                fill: true
            }]
        },
    });

    // Pipeline Chart
    const pipelineCtx = document.getElementById('pipelineChart').getContext('2d');
    new Chart(pipelineCtx, {
        type: 'doughnut',
        data: {
            labels: ['Prospecting', 'Qualification', 'Proposal', 'Negotiation', 'Closing'],
            datasets: [{
                data: [450000, 580000, 620000, 480000, 320000],
                backgroundColor: [
                    'rgb(59, 130, 246)',
                    'rgb(99, 102, 241)',
                    'rgb(168, 85, 247)',
                    'rgb(249, 115, 22)',
                    'rgb(34, 197, 94)'
                ]
            }]
        }
    });
</script>