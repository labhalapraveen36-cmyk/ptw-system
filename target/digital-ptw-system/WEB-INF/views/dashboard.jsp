<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<jsp:include page="layout/header.jsp" />
<jsp:include page="layout/navbar.jsp" />

<!-- Compute dashboard statistics dynamically from session permits -->
<c:set var="activeCount" value="0" />
<c:set var="pendingCount" value="0" />
<c:set var="rejectedCount" value="0" />
<c:set var="completedCount" value="0" />

<c:set var="bfActive" value="0" /><c:set var="bfHigh" value="0" />
<c:set var="coActive" value="0" /><c:set var="coHigh" value="0" />
<c:set var="opActive" value="0" /><c:set var="opHigh" value="0" />
<c:set var="rmActive" value="0" /><c:set var="rmHigh" value="0" />
<c:set var="ppActive" value="0" /><c:set var="ppHigh" value="0" />
<c:set var="spActive" value="0" /><c:set var="spHigh" value="0" />

<c:set var="riskLow" value="0" />
<c:set var="riskMedium" value="0" />
<c:set var="riskHigh" value="0" />

<c:forEach var="p" items="${sessionScope.permits}">
    <c:choose>
        <c:when test="${p.status == 'IN_PROGRESS'}">
            <c:set var="activeCount" value="${activeCount + 1}" />
        </c:when>
        <c:when test="${fn:startsWith(p.status, 'PENDING_')}">
            <c:set var="pendingCount" value="${pendingCount + 1}" />
        </c:when>
        <c:when test="${p.status == 'REJECTED'}">
            <c:set var="rejectedCount" value="${rejectedCount + 1}" />
        </c:when>
        <c:when test="${p.status == 'COMPLETED'}">
            <c:set var="completedCount" value="${completedCount + 1}" />
        </c:when>
    </c:choose>

    <!-- Count active tasks by location for the Interactive Plant Map -->
    <c:if test="${p.status == 'IN_PROGRESS' || p.status == 'APPROVED'}">
        <c:choose>
            <c:when test="${p.location == 'Blast Furnace 1'}">
                <c:set var="bfActive" value="${bfActive + 1}" />
                <c:if test="${p.riskLevel == 'High'}"><c:set var="bfHigh" value="${bfHigh + 1}" /></c:if>
            </c:when>
            <c:when test="${p.location == 'Coke Oven 2'}">
                <c:set var="coActive" value="${coActive + 1}" />
                <c:if test="${p.riskLevel == 'High'}"><c:set var="coHigh" value="${coHigh + 1}" /></c:if>
            </c:when>
            <c:when test="${p.location == 'Oxygen Plant'}">
                <c:set var="opActive" value="${opActive + 1}" />
                <c:if test="${p.riskLevel == 'High'}"><c:set var="opHigh" value="${opHigh + 1}" /></c:if>
            </c:when>
            <c:when test="${p.location == 'Rolling Mill'}">
                <c:set var="rmActive" value="${rmActive + 1}" />
                <c:if test="${p.riskLevel == 'High'}"><c:set var="rmHigh" value="${rmHigh + 1}" /></c:if>
            </c:when>
            <c:when test="${p.location == 'Power Plant'}">
                <c:set var="ppActive" value="${ppActive + 1}" />
                <c:if test="${p.riskLevel == 'High'}"><c:set var="ppHigh" value="${ppHigh + 1}" /></c:if>
            </c:when>
            <c:when test="${p.location == 'Sinter Plant'}">
                <c:set var="spActive" value="${spActive + 1}" />
                <c:if test="${p.riskLevel == 'High'}"><c:set var="spHigh" value="${spHigh + 1}" /></c:if>
            </c:when>
        </c:choose>
        
        <!-- Count active tasks by Risk Level -->
        <c:choose>
            <c:when test="${p.riskLevel == 'Low'}"><c:set var="riskLow" value="${riskLow + 1}" /></c:when>
            <c:when test="${p.riskLevel == 'Medium'}"><c:set var="riskMedium" value="${riskMedium + 1}" /></c:when>
            <c:when test="${p.riskLevel == 'High'}"><c:set var="riskHigh" value="${riskHigh + 1}" /></c:when>
        </c:choose>
    </c:if>
</c:forEach>

<main class="container" style="padding-top: 30px; padding-bottom: 50px;">
    
    <!-- Welcoming Header and Quick Actions -->
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:24px;">
        <div>
            <h1 style="font-size:28px; font-weight:800; letter-spacing:-0.5px;">Operations Control Dashboard</h1>
            <p style="color:var(--text-secondary); margin-top:4px;">Safety status overview for steel plant operations</p>
        </div>
        <div>
            <c:if test="${sessionScope.currentUserRole == 'Worker'}">
                <a href="${pageContext.request.contextPath}/dashboard?view=create" class="btn btn-primary">
                    <span class="material-symbols-outlined">add_task</span> Request Work Permit
                </a>
            </c:if>
            <c:if test="${sessionScope.currentUserRole != 'Worker' && sessionScope.currentUserRole != 'Admin'}">
                <a href="${pageContext.request.contextPath}/dashboard?view=approvals" class="btn btn-primary" style="background-color:var(--status-pending); color:#000;">
                    <span class="material-symbols-outlined">approval_delegation</span> Review Inbox (${pendingCount})
                </a>
            </c:if>
        </div>
    </div>

    <!-- Metrics Cards Grid -->
    <div class="dashboard-grid">
        <div class="card metric-card active-permits">
            <div class="card-title-bar">
                <span class="card-title">Active Work</span>
                <span class="material-symbols-outlined" style="color:var(--status-active);">engineering</span>
            </div>
            <div class="metric-value"><c:out value="${activeCount}" /></div>
            <div class="metric-sub">Permits actively running onsite</div>
        </div>
        <div class="card metric-card pending-permits">
            <div class="card-title-bar">
                <span class="card-title">Pending Approvals</span>
                <span class="material-symbols-outlined" style="color:var(--status-pending);">hourglass_empty</span>
            </div>
            <div class="metric-value"><c:out value="${pendingCount}" /></div>
            <div class="metric-sub">Permits in approval queue</div>
        </div>
        <div class="card metric-card rejected-permits">
            <div class="card-title-bar">
                <span class="card-title">Rejected Work</span>
                <span class="material-symbols-outlined" style="color:var(--status-rejected);">cancel</span>
            </div>
            <div class="metric-value"><c:out value="${rejectedCount}" /></div>
            <div class="metric-sub">Work permits denied safety clearance</div>
        </div>
        <div class="card metric-card completed-permits">
            <div class="card-title-bar">
                <span class="card-title">Completed (24h)</span>
                <span class="material-symbols-outlined" style="color:var(--status-completed);">task_alt</span>
            </div>
            <div class="metric-value"><c:out value="${completedCount}" /></div>
            <div class="metric-sub">Successfully closed operations</div>
        </div>
    </div>

    <!-- Main Content Split (Map / Charts / Tables) -->
    <div class="dashboard-main-area">
        
        <!-- Left Side: Interactive Map & Recent Permits -->
        <div style="display:flex; flex-direction:column; gap:24px;">
            
            <!-- Steel Plant Layout Hot-spot map -->
            <div class="card">
                <div class="card-title-bar">
                    <h3><span class="material-symbols-outlined" style="color:var(--primary); font-size:24px;">map</span> Plant Hazard Location Map</h3>
                    <span style="font-size:12px; color:var(--text-muted); font-weight:600; text-transform:uppercase;">Live status</span>
                </div>
                <p style="color:var(--text-secondary); font-size:13px; margin-bottom:15px;">
                    Visual status of active/approved permits in plant zones. Click any area to view registered permits.
                </p>
                
                <div class="plant-layout-grid">
                    <div class="plant-cell ${bfActive > 0 ? 'active-work' : ''} ${bfHigh > 0 ? 'has-high-risk' : ''}" 
                         onclick="window.location.href='${pageContext.request.contextPath}/dashboard?view=permits&location=Blast+Furnace+1'">
                        <span class="plant-active-indicator"></span>
                        <div class="plant-name">Blast Furnace 1</div>
                        <div class="plant-metric">
                            <span>Active Permits:</span>
                            <strong><c:out value="${bfActive}" /></strong>
                        </div>
                    </div>
                    <div class="plant-cell ${coActive > 0 ? 'active-work' : ''} ${coHigh > 0 ? 'has-high-risk' : ''}"
                         onclick="window.location.href='${pageContext.request.contextPath}/dashboard?view=permits&location=Coke+Oven+2'">
                        <span class="plant-active-indicator"></span>
                        <div class="plant-name">Coke Oven 2</div>
                        <div class="plant-metric">
                            <span>Active Permits:</span>
                            <strong><c:out value="${coActive}" /></strong>
                        </div>
                    </div>
                    <div class="plant-cell ${opActive > 0 ? 'active-work' : ''} ${opHigh > 0 ? 'has-high-risk' : ''}"
                         onclick="window.location.href='${pageContext.request.contextPath}/dashboard?view=permits&location=Oxygen+Plant'">
                        <span class="plant-active-indicator"></span>
                        <div class="plant-name">Oxygen Plant</div>
                        <div class="plant-metric">
                            <span>Active Permits:</span>
                            <strong><c:out value="${opActive}" /></strong>
                        </div>
                    </div>
                    <div class="plant-cell ${rmActive > 0 ? 'active-work' : ''} ${rmHigh > 0 ? 'has-high-risk' : ''}"
                         onclick="window.location.href='${pageContext.request.contextPath}/dashboard?view=permits&location=Rolling+Mill'">
                        <span class="plant-active-indicator"></span>
                        <div class="plant-name">Rolling Mill</div>
                        <div class="plant-metric">
                            <span>Active Permits:</span>
                            <strong><c:out value="${rmActive}" /></strong>
                        </div>
                    </div>
                    <div class="plant-cell ${ppActive > 0 ? 'active-work' : ''} ${ppHigh > 0 ? 'has-high-risk' : ''}"
                         onclick="window.location.href='${pageContext.request.contextPath}/dashboard?view=permits&location=Power+Plant'">
                        <span class="plant-active-indicator"></span>
                        <div class="plant-name">Power Plant</div>
                        <div class="plant-metric">
                            <span>Active Permits:</span>
                            <strong><c:out value="${ppActive}" /></strong>
                        </div>
                    </div>
                    <div class="plant-cell ${spActive > 0 ? 'active-work' : ''} ${spHigh > 0 ? 'has-high-risk' : ''}"
                         onclick="window.location.href='${pageContext.request.contextPath}/dashboard?view=permits&location=Sinter+Plant'">
                        <span class="plant-active-indicator"></span>
                        <div class="plant-name">Sinter Plant</div>
                        <div class="plant-metric">
                            <span>Active Permits:</span>
                            <strong><c:out value="${spActive}" /></strong>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent permits list -->
            <div class="card">
                <div class="card-title-bar">
                    <h3><span class="material-symbols-outlined" style="color:var(--primary); font-size:24px;">list_alt</span> Recent Permit Actions</h3>
                    <a href="${pageContext.request.contextPath}/dashboard?view=permits" style="font-size:12px; font-weight:600;">View All</a>
                </div>
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Permit ID</th>
                                <th>Type of Work</th>
                                <th>Location</th>
                                <th>Applicant</th>
                                <th>Risk</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="count" value="0" />
                            <c:forEach var="p" items="${sessionScope.permits}">
                                <c:if test="${count < 5}">
                                    <c:set var="count" value="${count + 1}" />
                                    <tr>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/dashboard?view=details&id=${p.id}" style="font-family:monospace; font-weight:600;">
                                                <c:out value="${p.id}" />
                                            </a>
                                        </td>
                                        <td><c:out value="${p.workType}" /></td>
                                        <td><c:out value="${p.location}" /></td>
                                        <td><c:out value="${p.applicant}" /></td>
                                        <td><span class="badge badge-risk-${fn:toLowerCase(p.riskLevel)}"><c:out value="${p.riskLevel}" /></span></td>
                                        <td><span class="badge badge-${fn:toLowerCase(p.status)}"><c:out value="${fn:replace(p.status, '_', ' ')}" /></span></td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                            <c:if test="${count == 0}">
                                <tr>
                                    <td colspan="6" style="text-align:center; padding:30px; color:var(--text-muted);">No records found.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>

        <!-- Right Side: Risk Matrices and Guidelines -->
        <div style="display:flex; flex-direction:column; gap:24px;">
            
            <!-- Risk Level Metric Box -->
            <div class="card">
                <h3><span class="material-symbols-outlined" style="color:var(--status-pending); font-size:24px;">warning</span> Active Risk Matrix</h3>
                <p style="color:var(--text-secondary); font-size:12px; margin-top:4px;">
                    Count of active/approved permits mapped by their risk classification.
                </p>
                
                <div class="risk-matrix">
                    <!-- Row 1: High -->
                    <div class="matrix-label-y">Severity (H)</div>
                    <div class="matrix-cell matrix-med">
                        <c:out value="${riskLow}" />
                        <span class="matrix-desc">Low Prob</span>
                    </div>
                    <div class="matrix-cell matrix-high">
                        <c:out value="${riskMedium}" />
                        <span class="matrix-desc">Med Prob</span>
                    </div>
                    <div class="matrix-cell matrix-high" style="background-color:#b91c1c;">
                        <c:out value="${riskHigh}" />
                        <span class="matrix-desc">High Prob</span>
                    </div>

                    <!-- Row 2: Medium -->
                    <div class="matrix-label-y">Severity (M)</div>
                    <div class="matrix-cell matrix-low">0<span class="matrix-desc"></span></div>
                    <div class="matrix-cell matrix-med">0<span class="matrix-desc"></span></div>
                    <div class="matrix-cell matrix-high">0<span class="matrix-desc"></span></div>

                    <!-- Row 3: Low -->
                    <div class="matrix-label-y">Severity (L)</div>
                    <div class="matrix-cell matrix-low">0<span class="matrix-desc"></span></div>
                    <div class="matrix-cell matrix-low">0<span class="matrix-desc"></span></div>
                    <div class="matrix-cell matrix-med">0<span class="matrix-desc"></span></div>

                    <!-- Empty corner and X label -->
                    <div></div>
                    <div class="matrix-label-x">Low Prob</div>
                    <div class="matrix-label-x">Med Prob</div>
                    <div class="matrix-label-x">High Prob</div>
                </div>
                
                <div style="margin-top:16px; font-size:11px; color:var(--text-secondary); display:flex; flex-direction:column; gap:6px; border-top:var(--border-width) solid var(--border-color); padding-top:12px;">
                    <div style="display:flex; align-items:center; gap:8px;">
                        <span style="width:10px; height:10px; border-radius:50%; background-color:#b91c1c;"></span>
                        <span>High Risk Work: Requires Supervisor, Safety, AND Manager sign-off.</span>
                    </div>
                    <div style="display:flex; align-items:center; gap:8px;">
                        <span style="width:10px; height:10px; border-radius:50%; background-color:var(--status-pending);"></span>
                        <span>Medium/Low Risk: Requires Supervisor and Safety verification.</span>
                    </div>
                </div>
            </div>

            <!-- Steel Plant Safety Rules Widget -->
            <div class="card" style="background: linear-gradient(180deg, var(--bg-surface) 0%, rgba(56, 189, 248, 0.03) 100%);">
                <h3><span class="material-symbols-outlined" style="color:var(--primary); font-size:24px;">verified_user</span> Safety Regulations</h3>
                <ul style="padding-left:20px; font-size:13px; color:var(--text-secondary); display:flex; flex-direction:column; gap:10px; margin-top:12px;">
                    <li><b>Atmosphere Testing:</b> Gas Sniff test required before any hot work or confined entry.</li>
                    <li><b>LOTO isolation:</b> Electrical breakers must be locked out, tagged, and verified zero energy.</li>
                    <li><b>Fall Protection:</b> Double harness anchoring mandatory for works > 1.8 meters.</li>
                    <li><b>Emergency Alerts:</b> Evacuate immediately if safety horn sounds or gas detector alarm triggers.</li>
                </ul>
            </div>

        </div>

    </div>

</main>

<jsp:include page="layout/footer.jsp" />
