<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- Sortable.js for Drag & Drop -->
<script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>

<!-- Pipeline Header with Filters -->
<div class="bg-white rounded-xl shadow-sm border border-slate-200 p-6 mb-6">
    <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
        
        <!-- Left: Title & Stats -->
        <div>
            <h3 class="text-2xl font-bold text-slate-800 mb-2">Sales Pipeline</h3>
            <div class="flex items-center gap-4 text-sm">
                <span class="text-slate-600">
                    <span class="font-semibold text-blue-600">156</span> Opportunities
                </span>
                <span class="text-slate-300">|</span>
                <span class="text-slate-600">
                    Total Value: <span class="font-semibold text-green-600">$2,450,000</span>
                </span>
                <span class="text-slate-300">|</span>
                <span class="text-slate-600">
                    Expected Close: <span class="font-semibold text-purple-600">$1,820,000</span>
                </span>
            </div>
        </div>
        
        <!-- Right: Actions -->
        <div class="flex items-center gap-3">
            <button onclick="toggleFilters()" class="px-4 py-2 border border-slate-300 rounded-lg hover:bg-slate-50 transition-colors flex items-center gap-2">
                <svg class="w-5 h-5 text-slate-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.293A1 1 0 013 6.586V4z"/>
                </svg>
                <span class="font-medium text-slate-700">Filters</span>
            </button>
            
            <button onclick="openCreateModal()" class="px-4 py-2 bg-gradient-to-r from-blue-600 to-indigo-600 text-white rounded-lg hover:shadow-lg transition-all flex items-center gap-2">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                </svg>
                <span class="font-medium">New Opportunity</span>
            </button>
        </div>
    </div>
    
    <!-- Filters Panel (Collapsible) -->
    <div id="filtersPanel" class="hidden mt-6 pt-6 border-t border-slate-200">
        <form method="GET" action="${pageContext.request.contextPath}/sales/pipeline" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4">
            
            <!-- Search -->
            <div>
                <label class="block text-sm font-medium text-slate-700 mb-2">Search</label>
                <input type="text" name="search" value="${search}" placeholder="Company or deal name..." 
                       class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>
            
            <!-- Sales Rep -->
            <div>
                <label class="block text-sm font-medium text-slate-700 mb-2">Sales Rep</label>
                <select name="salesRep" class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                    <option value="">All Reps</option>
                    <option value="john" ${salesRep == 'john' ? 'selected' : ''}>John Doe</option>
                    <option value="jane" ${salesRep == 'jane' ? 'selected' : ''}>Jane Smith</option>
                    <option value="mike" ${salesRep == 'mike' ? 'selected' : ''}>Mike Johnson</option>
                </select>
            </div>
            
            <!-- Priority -->
            <div>
                <label class="block text-sm font-medium text-slate-700 mb-2">Priority</label>
                <select name="priority" class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                    <option value="">All Priorities</option>
                    <option value="high" ${priority == 'high' ? 'selected' : ''}>High</option>
                    <option value="medium" ${priority == 'medium' ? 'selected' : ''}>Medium</option>
                    <option value="low" ${priority == 'low' ? 'selected' : ''}>Low</option>
                </select>
            </div>
            
            <!-- Value Range -->
            <div>
                <label class="block text-sm font-medium text-slate-700 mb-2">Min Value</label>
                <input type="number" name="minValue" placeholder="$0" 
                       class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>
            
            <div>
                <label class="block text-sm font-medium text-slate-700 mb-2">Max Value</label>
                <input type="number" name="maxValue" placeholder="$1,000,000" 
                       class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>
            
            <!-- Filter Actions -->
            <div class="md:col-span-2 lg:col-span-5 flex items-center gap-3">
                <button type="submit" class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                    Apply Filters
                </button>
                <a href="${pageContext.request.contextPath}/sales/pipeline" class="px-6 py-2 border border-slate-300 text-slate-700 rounded-lg hover:bg-slate-50 transition-colors">
                    Clear All
                </a>
            </div>
        </form>
    </div>
</div>

<!-- Kanban Board -->
<div class="flex gap-4 overflow-x-auto pb-6" style="min-height: calc(100vh - 400px);">
    
    <!-- Stage 1: Prospecting -->
    <div class="flex-shrink-0 w-80">
        <div class="bg-white rounded-xl shadow-sm border border-slate-200 h-full flex flex-col">
            <!-- Stage Header -->
            <div class="px-4 py-3 border-b border-slate-200 bg-gradient-to-r from-blue-50 to-blue-100">
                <div class="flex items-center justify-between mb-2">
                    <h4 class="font-semibold text-slate-800 flex items-center gap-2">
                        <span class="w-3 h-3 bg-blue-500 rounded-full"></span>
                        Prospecting
                    </h4>
                    <span class="px-2 py-1 bg-blue-600 text-white text-xs font-semibold rounded-full">45</span>
                </div>
                <div class="flex items-center justify-between text-xs text-slate-600">
                    <span>Total: <span class="font-semibold text-blue-600">$450,000</span></span>
                    <span class="text-slate-400">18.4%</span>
                </div>
            </div>
            
            <!-- Cards Container -->
            <div class="flex-1 p-3 space-y-3 overflow-y-auto" id="prospecting-column" data-stage="prospecting">
                
                <!-- Opportunity Card 1 -->
                <div class="opportunity-card bg-white border border-slate-200 rounded-lg p-4 cursor-move hover:shadow-lg transition-shadow" 
                     data-opportunity-id="1">
                    <!-- Priority Badge -->
                    <div class="flex items-start justify-between mb-3">
                        <span class="px-2 py-1 bg-red-100 text-red-700 text-xs font-semibold rounded">High Priority</span>
                        <div class="flex items-center gap-1">
                            <button onclick="editOpportunity(1)" class="p-1 hover:bg-slate-100 rounded">
                                <svg class="w-4 h-4 text-slate-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                </svg>
                            </button>
                            <button onclick="openOptionsMenu(1)" class="p-1 hover:bg-slate-100 rounded">
                                <svg class="w-4 h-4 text-slate-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 5v.01M12 12v.01M12 19v.01M12 6a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2z"/>
                                </svg>
                            </button>
                        </div>
                    </div>
                    
                    <!-- Company & Deal Name -->
                    <h5 class="font-semibold text-slate-800 mb-1 line-clamp-2">Enterprise Solution - Acme Corp</h5>
                    <p class="text-sm text-slate-500 mb-3">Software Implementation</p>
                    
                    <!-- Deal Value -->
                    <div class="flex items-center justify-between mb-3">
                        <span class="text-lg font-bold text-slate-800">$85,000</span>
                        <div class="flex items-center gap-1 text-xs text-slate-500">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
                            </svg>
                            <span>30%</span>
                        </div>
                    </div>
                    
                    <!-- Meta Info -->
                    <div class="pt-3 border-t border-slate-100 flex items-center justify-between">
                        <div class="flex items-center gap-2">
                            <div class="w-6 h-6 bg-blue-500 rounded-full flex items-center justify-center text-white text-xs font-semibold">
                                JD
                            </div>
                            <span class="text-xs text-slate-600">John Doe</span>
                        </div>
                        <div class="flex items-center gap-1 text-xs text-slate-500">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                            </svg>
                            <span>Feb 28</span>
                        </div>
                    </div>
                    
                    <!-- Tags -->
                    <div class="mt-3 flex flex-wrap gap-1">
                        <span class="px-2 py-1 bg-purple-100 text-purple-700 text-xs rounded">Enterprise</span>
                        <span class="px-2 py-1 bg-green-100 text-green-700 text-xs rounded">Hot Lead</span>
                    </div>
                </div>
                
                <!-- Opportunity Card 2 -->
                <div class="opportunity-card bg-white border border-slate-200 rounded-lg p-4 cursor-move hover:shadow-lg transition-shadow" 
                     data-opportunity-id="2">
                    <div class="flex items-start justify-between mb-3">
                        <span class="px-2 py-1 bg-yellow-100 text-yellow-700 text-xs font-semibold rounded">Medium Priority</span>
                        <div class="flex items-center gap-1">
                            <button onclick="editOpportunity(2)" class="p-1 hover:bg-slate-100 rounded">
                                <svg class="w-4 h-4 text-slate-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                </svg>
                            </button>
                            <button onclick="openOptionsMenu(2)" class="p-1 hover:bg-slate-100 rounded">
                                <svg class="w-4 h-4 text-slate-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 5v.01M12 12v.01M12 19v.01M12 6a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2z"/>
                                </svg>
                            </button>
                        </div>
                    </div>
                    
                    <h5 class="font-semibold text-slate-800 mb-1 line-clamp-2">Cloud Migration - Tech Startup</h5>
                    <p class="text-sm text-slate-500 mb-3">Infrastructure Services</p>
                    
                    <div class="flex items-center justify-between mb-3">
                        <span class="text-lg font-bold text-slate-800">$45,000</span>
                        <div class="flex items-center gap-1 text-xs text-slate-500">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
                            </svg>
                            <span>25%</span>
                        </div>
                    </div>
                    
                    <div class="pt-3 border-t border-slate-100 flex items-center justify-between">
                        <div class="flex items-center gap-2">
                            <div class="w-6 h-6 bg-purple-500 rounded-full flex items-center justify-center text-white text-xs font-semibold">
                                JS
                            </div>
                            <span class="text-xs text-slate-600">Jane Smith</span>
                        </div>
                        <div class="flex items-center gap-1 text-xs text-slate-500">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                            </svg>
                            <span>Mar 15</span>
                        </div>
                    </div>
                    
                    <div class="mt-3 flex flex-wrap gap-1">
                        <span class="px-2 py-1 bg-blue-100 text-blue-700 text-xs rounded">Startup</span>
                    </div>
                </div>
                
                <!-- Add more cards as needed -->
                
            </div>
            
            <!-- Add Card Button -->
            <div class="p-3 border-t border-slate-200">
                <button onclick="openCreateModalInStage('prospecting')" class="w-full py-2 border-2 border-dashed border-slate-300 rounded-lg text-slate-600 hover:border-blue-500 hover:text-blue-600 transition-colors flex items-center justify-center gap-2">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                    </svg>
                    <span class="font-medium">Add Deal</span>
                </button>
            </div>
        </div>
    </div>
    
    <!-- Stage 2: Qualification -->
    <div class="flex-shrink-0 w-80">
        <div class="bg-white rounded-xl shadow-sm border border-slate-200 h-full flex flex-col">
            <div class="px-4 py-3 border-b border-slate-200 bg-gradient-to-r from-indigo-50 to-indigo-100">
                <div class="flex items-center justify-between mb-2">
                    <h4 class="font-semibold text-slate-800 flex items-center gap-2">
                        <span class="w-3 h-3 bg-indigo-500 rounded-full"></span>
                        Qualification
                    </h4>
                    <span class="px-2 py-1 bg-indigo-600 text-white text-xs font-semibold rounded-full">38</span>
                </div>
                <div class="flex items-center justify-between text-xs text-slate-600">
                    <span>Total: <span class="font-semibold text-indigo-600">$580,000</span></span>
                    <span class="text-slate-400">23.7%</span>
                </div>
            </div>
            
            <div class="flex-1 p-3 space-y-3 overflow-y-auto" id="qualification-column" data-stage="qualification">
                <!-- Add opportunity cards here -->
            </div>
            
            <div class="p-3 border-t border-slate-200">
                <button onclick="openCreateModalInStage('qualification')" class="w-full py-2 border-2 border-dashed border-slate-300 rounded-lg text-slate-600 hover:border-indigo-500 hover:text-indigo-600 transition-colors flex items-center justify-center gap-2">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                    </svg>
                    <span class="font-medium">Add Deal</span>
                </button>
            </div>
        </div>
    </div>
    
    <!-- Stage 3: Proposal -->
    <div class="flex-shrink-0 w-80">
        <div class="bg-white rounded-xl shadow-sm border border-slate-200 h-full flex flex-col">
            <div class="px-4 py-3 border-b border-slate-200 bg-gradient-to-r from-purple-50 to-purple-100">
                <div class="flex items-center justify-between mb-2">
                    <h4 class="font-semibold text-slate-800 flex items-center gap-2">
                        <span class="w-3 h-3 bg-purple-500 rounded-full"></span>
                        Proposal
                    </h4>
                    <span class="px-2 py-1 bg-purple-600 text-white text-xs font-semibold rounded-full">28</span>
                </div>
                <div class="flex items-center justify-between text-xs text-slate-600">
                    <span>Total: <span class="font-semibold text-purple-600">$620,000</span></span>
                    <span class="text-slate-400">25.3%</span>
                </div>
            </div>
            
            <div class="flex-1 p-3 space-y-3 overflow-y-auto" id="proposal-column" data-stage="proposal">
                <!-- Add opportunity cards here -->
            </div>
            
            <div class="p-3 border-t border-slate-200">
                <button onclick="openCreateModalInStage('proposal')" class="w-full py-2 border-2 border-dashed border-slate-300 rounded-lg text-slate-600 hover:border-purple-500 hover:text-purple-600 transition-colors flex items-center justify-center gap-2">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                    </svg>
                    <span class="font-medium">Add Deal</span>
                </button>
            </div>
        </div>
    </div>
    
    <!-- Stage 4: Negotiation -->
    <div class="flex-shrink-0 w-80">
        <div class="bg-white rounded-xl shadow-sm border border-slate-200 h-full flex flex-col">
            <div class="px-4 py-3 border-b border-slate-200 bg-gradient-to-r from-orange-50 to-orange-100">
                <div class="flex items-center justify-between mb-2">
                    <h4 class="font-semibold text-slate-800 flex items-center gap-2">
                        <span class="w-3 h-3 bg-orange-500 rounded-full"></span>
                        Negotiation
                    </h4>
                    <span class="px-2 py-1 bg-orange-600 text-white text-xs font-semibold rounded-full">23</span>
                </div>
                <div class="flex items-center justify-between text-xs text-slate-600">
                    <span>Total: <span class="font-semibold text-orange-600">$480,000</span></span>
                    <span class="text-slate-400">19.6%</span>
                </div>
            </div>
            
            <div class="flex-1 p-3 space-y-3 overflow-y-auto" id="negotiation-column" data-stage="negotiation">
                <!-- Add opportunity cards here -->
            </div>
            
            <div class="p-3 border-t border-slate-200">
                <button onclick="openCreateModalInStage('negotiation')" class="w-full py-2 border-2 border-dashed border-slate-300 rounded-lg text-slate-600 hover:border-orange-500 hover:text-orange-600 transition-colors flex items-center justify-center gap-2">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                    </svg>
                    <span class="font-medium">Add Deal</span>
                </button>
            </div>
        </div>
    </div>
    
    <!-- Stage 5: Closing -->
    <div class="flex-shrink-0 w-80">
        <div class="bg-white rounded-xl shadow-sm border border-slate-200 h-full flex flex-col">
            <div class="px-4 py-3 border-b border-slate-200 bg-gradient-to-r from-green-50 to-green-100">
                <div class="flex items-center justify-between mb-2">
                    <h4 class="font-semibold text-slate-800 flex items-center gap-2">
                        <span class="w-3 h-3 bg-green-500 rounded-full"></span>
                        Closing
                    </h4>
                    <span class="px-2 py-1 bg-green-600 text-white text-xs font-semibold rounded-full">22</span>
                </div>
                <div class="flex items-center justify-between text-xs text-slate-600">
                    <span>Total: <span class="font-semibold text-green-600">$320,000</span></span>
                    <span class="text-slate-400">13.0%</span>
                </div>
            </div>
            
            <div class="flex-1 p-3 space-y-3 overflow-y-auto" id="closing-column" data-stage="closing">
                <!-- Add opportunity cards here -->
            </div>
            
            <div class="p-3 border-t border-slate-200">
                <button onclick="openCreateModalInStage('closing')" class="w-full py-2 border-2 border-dashed border-slate-300 rounded-lg text-slate-600 hover:border-green-500 hover:text-green-600 transition-colors flex items-center justify-center gap-2">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                    </svg>
                    <span class="font-medium">Add Deal</span>
                </button>
            </div>
        </div>
    </div>
    
</div>

<!-- Create/Edit Opportunity Modal -->
<div id="opportunityModal" class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
    <div class="bg-white rounded-xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
        <!-- Modal Header -->
        <div class="sticky top-0 bg-white px-6 py-4 border-b border-slate-200 flex items-center justify-between">
            <h3 class="text-xl font-bold text-slate-800" id="modalTitle">Create New Opportunity</h3>
            <button onclick="closeOpportunityModal()" class="p-2 hover:bg-slate-100 rounded-lg transition-colors">
                <svg class="w-6 h-6 text-slate-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                </svg>
            </button>
        </div>
        
        <!-- Modal Body -->
        <form id="opportunityForm" class="p-6 space-y-6">
            <input type="hidden" id="opportunityId" name="opportunityId">
            <input type="hidden" id="modalStage" name="stage">
            
            <!-- Deal Information -->
            <div class="space-y-4">
                <h4 class="font-semibold text-slate-700 flex items-center gap-2">
                    <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                    </svg>
                    Deal Information
                </h4>
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-2">Deal Name *</label>
                        <input type="text" id="dealName" name="dealName" required
                               class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                               placeholder="e.g., Enterprise Solution">
                    </div>
                    
                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-2">Company Name *</label>
                        <input type="text" id="companyName" name="companyName" required
                               class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                               placeholder="e.g., Acme Corp">
                    </div>
                    
                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-2">Deal Value ($) *</label>
                        <input type="number" id="dealValue" name="dealValue" required
                               class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                               placeholder="85000">
                    </div>
                    
                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-2">Expected Close Date *</label>
                        <input type="date" id="closeDate" name="closeDate" required
                               class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>
                    
                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-2">Probability (%)</label>
                        <input type="number" id="probability" name="probability" min="0" max="100"
                               class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                               placeholder="30">
                    </div>
                    
                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-2">Priority *</label>
                        <select id="priority" name="priority" required
                                class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                            <option value="low">Low Priority</option>
                            <option value="medium" selected>Medium Priority</option>
                            <option value="high">High Priority</option>
                        </select>
                    </div>
                    
                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-2">Sales Rep *</label>
                        <select id="salesRep" name="salesRep" required
                                class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                            <option value="john">John Doe</option>
                            <option value="jane">Jane Smith</option>
                            <option value="mike">Mike Johnson</option>
                        </select>
                    </div>
                    
                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-2">Stage</label>
                        <select id="stage" name="stage"
                                class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                            <option value="prospecting">Prospecting</option>
                            <option value="qualification">Qualification</option>
                            <option value="proposal">Proposal</option>
                            <option value="negotiation">Negotiation</option>
                            <option value="closing">Closing</option>
                        </select>
                    </div>
                </div>
                
                <div>
                    <label class="block text-sm font-medium text-slate-700 mb-2">Description</label>
                    <textarea id="description" name="description" rows="3"
                              class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                              placeholder="Brief description of the opportunity..."></textarea>
                </div>
            </div>
            
            <!-- Contact Information -->
            <div class="space-y-4">
                <h4 class="font-semibold text-slate-700 flex items-center gap-2">
                    <svg class="w-5 h-5 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                    </svg>
                    Contact Information
                </h4>
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-2">Contact Name</label>
                        <input type="text" id="contactName" name="contactName"
                               class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                               placeholder="e.g., John Smith">
                    </div>
                    
                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-2">Contact Email</label>
                        <input type="email" id="contactEmail" name="contactEmail"
                               class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                               placeholder="john@example.com">
                    </div>
                    
                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-2">Contact Phone</label>
                        <input type="tel" id="contactPhone" name="contactPhone"
                               class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                               placeholder="+1 (555) 123-4567">
                    </div>
                    
                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-2">Contact Role</label>
                        <input type="text" id="contactRole" name="contactRole"
                               class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                               placeholder="e.g., CTO">
                    </div>
                </div>
            </div>
            
            <!-- Tags -->
            <div>
                <label class="block text-sm font-medium text-slate-700 mb-2">Tags</label>
                <input type="text" id="tags" name="tags"
                       class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                       placeholder="Enterprise, Hot Lead, etc. (comma-separated)">
            </div>
            
            <!-- Modal Footer -->
            <div class="flex items-center justify-end gap-3 pt-6 border-t border-slate-200">
                <button type="button" onclick="closeOpportunityModal()"
                        class="px-6 py-2 border border-slate-300 text-slate-700 rounded-lg hover:bg-slate-50 transition-colors">
                    Cancel
                </button>
                <button type="submit"
                        class="px-6 py-2 bg-gradient-to-r from-blue-600 to-indigo-600 text-white rounded-lg hover:shadow-lg transition-all">
                    Save Opportunity
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Opportunity Detail View Modal -->
<div id="detailModal" class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
    <div class="bg-white rounded-xl shadow-2xl max-w-4xl w-full max-h-[90vh] overflow-y-auto">
        <!-- Detail content will be loaded dynamically -->
    </div>
</div>



<script>
    // Initialize Sortable.js for drag & drop
    document.addEventListener('DOMContentLoaded', function() {
        const columns = ['prospecting', 'qualification', 'proposal', 'negotiation', 'closing'];
        
        columns.forEach(columnId => {
            const column = document.getElementById(columnId + '-column');
            if (column) {
                new Sortable(column, {
                    group: 'pipeline',
                    animation: 150,
                    ghostClass: 'sortable-ghost',
                    dragClass: 'sortable-drag',
                    onEnd: function(evt) {
                        const opportunityId = evt.item.getAttribute('data-opportunity-id');
                        const newStage = evt.to.getAttribute('data-stage');
                        
                        // Update stage via AJAX
                        updateOpportunityStage(opportunityId, newStage);
                    }
                });
            }
        });
    });
    
    // Toggle filters panel
    function toggleFilters() {
        const panel = document.getElementById('filtersPanel');
        panel.classList.toggle('hidden');
    }
    
    // Open create modal
    function openCreateModal() {
        document.getElementById('modalTitle').textContent = 'Create New Opportunity';
        document.getElementById('opportunityForm').reset();
        document.getElementById('opportunityId').value = '';
        document.getElementById('opportunityModal').classList.remove('hidden');
    }
    
    // Open create modal with pre-selected stage
    function openCreateModalInStage(stage) {
        openCreateModal();
        document.getElementById('stage').value = stage;
        document.getElementById('modalStage').value = stage;
    }
    
    // Close modal
    function closeOpportunityModal() {
        document.getElementById('opportunityModal').classList.add('hidden');
    }
    
    // Edit opportunity
    function editOpportunity(id) {
        // Fetch opportunity data and populate form
        // For now, just open modal
        document.getElementById('modalTitle').textContent = 'Edit Opportunity';
        document.getElementById('opportunityId').value = id;
        document.getElementById('opportunityModal').classList.remove('hidden');
        
        // TODO: Fetch and populate data via AJAX
    }
    
    // Open options menu
    function openOptionsMenu(id) {
        // Show context menu with options: Edit, Delete, View Details, etc.
        alert('Options menu for opportunity ' + id);
    }
    
    // Update opportunity stage (AJAX)
    function updateOpportunityStage(opportunityId, newStage) {
        fetch('${pageContext.request.contextPath}/sales/pipeline', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=updateStage&opportunityId=' + opportunityId + '&newStage=' + newStage
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                console.log('Stage updated successfully');
                // Show success notification
                showNotification('Opportunity moved to ' + newStage, 'success');
            } else {
                console.error('Failed to update stage');
                showNotification('Failed to update stage', 'error');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showNotification('Error updating stage', 'error');
        });
    }
    
    // Form submission
    document.getElementById('opportunityForm').addEventListener('submit', function(e) {
        e.preventDefault();
        
        const formData = new FormData(this);
        const opportunityId = document.getElementById('opportunityId').value;
        const action = opportunityId ? 'updateOpportunity' : 'createOpportunity';
        
        formData.append('action', action);
        
        fetch('${pageContext.request.contextPath}/sales/pipeline', {
            method: 'POST',
            body: new URLSearchParams(formData)
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                closeOpportunityModal();
                showNotification('Opportunity saved successfully', 'success');
                // Reload page or update UI
                location.reload();
            } else {
                showNotification('Failed to save opportunity', 'error');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showNotification('Error saving opportunity', 'error');
        });
    });
    
    // Show notification
    function showNotification(message, type) {
        // Simple notification - you can enhance this
        alert(message);
    }
</script>