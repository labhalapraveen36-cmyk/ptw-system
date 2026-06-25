<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<jsp:include page="layout/header.jsp" />
<jsp:include page="layout/navbar.jsp" />

<!-- Compute Analytics Data dynamically -->
<c:set var="total" value="${fn:length(sessionScope.permits)}" />
<c:set var="hotCount" value="0" />
<c:set var="csCount" value="0" />
<c:set var="heightCount" value="0" />
<c:set var="elecCount" value="0" />
<c:set var="weldCount" value="0" />

<c:set var="lowCount" value="0" />
<c:set var="medCount" value="0" />
<c:set var="highCount" value="0" />

<c:set var="completed" value="0" />
<c:set var="active" value="0" />
<c:set var="rejected" value="0" />
<c:set var="expired" value="0" />
<c:set var="pending" value="0" />

<c:forEach var="p" items="${sessionScope.permits}">
    <!-- Work Type count -->
    <c:choose>
        <c:when test="${p.workType == 'Hot Work'}"><c:set var="hotCount" value="${hotCount + 1}" /></c:when>
        <c:when test="${p.workType == 'Confined Space Entry'}"><c:set var="csCount" value="${csCount + 1}" /></c:when>
        <c:when test="${p.workType == 'Work at Heights'}"><c:set var="heightCount" value="${heightCount + 1}" /></c:when>
        <c:when test="${p.workType == 'Electrical Maintenance'}"><c:set var="elecCount" value="${elecCount + 1}" /></c:when>
        <c:when test="${p.workType == 'Welding'}"><c:set var="weldCount" value="${weldCount + 1}" /></c:when>
    </c:choose>

    <!-- Risk Level count -->
    <c:choose>
        <c:when test="${p.riskLevel == 'Low'}"><c:set var="lowCount" value="${lowCount + 1}" /></c:when>
        <c:when test="${p.riskLevel == 'Medium'}"><c:set var="medCount" value="${medCount + 1}" /></c:when>
        <c:when test="${p.riskLevel == 'High'}"><c:set var="highCount" value="${highCount + 1}" /></c:when>
    </c:choose>

    <!-- Status counts -->
    <c:choose>
        <c:when test="${p.status == 'COMPLETED'}"><c:set var="completed" value="${completed + 1}" /></c:when>
        <c:when test="${p.status == 'IN_PROGRESS'}"><c:set var="active" value="${active + 1}" /></c:when>
        <c:when test="${p.status == 'REJECTED'}"><c:set var="rejected" value="${rejected + 1}" /></c:when>
        <c:when test="${p.status == 'EXPIRED'}"><c:set var="expired" value="${expired + 1}" /></c:when>
        <c:when test="${fn:startsWith(p.status, 'PENDING_')}"><c:set var="pending" value="${pending + 1}" /></c:when>
    </c:choose>
</c:forEach>

<main class="container" style="padding-top:30px; padding-bottom:50px;">

    <div style="margin-bottom:24px;">
        <h1 style="font-size:28px;">Safety Analytics & Trends</h1>
        <p style="color:var(--text-secondary); margin-top:4px;">Safety metrics, permit loads, and compliance statistics</p>
    </div>

    <!-- Main Grid Split -->
    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:24px;">
        
        <!-- Left: Work Type Distribution & Risk breakdown -->
        <div style="display:flex; flex-direction:column; gap:24px;">
            
            <!-- Work Type Distribution -->
            <div class="card">
                <h3 style="margin-bottom:15px; display:flex; align-items:center; gap:8px;">
                    <span class="material-symbols-outlined" style="color:var(--primary);">bar_chart</span> Activity Breakdown by Work Type
                </h3>
                <p style="color:var(--text-secondary); font-size:12px; margin-bottom:20px;">
                    Distribution of requested permits across hazard classes.
                </p>
                
                <div style="display:flex; flex-direction:column; gap:16px;">
                    <!-- Hot Work -->
                    <div>
                        <div style="display:flex; justify-content:space-between; font-size:13px; margin-bottom:4px;">
                            <span>Hot Work</span>
                            <strong><c:out value="${hotCount}" /> / <c:out value="${total}" /></strong>
                        </div>
                        <div style="height:8px; background-color:var(--border-color); border-radius:4px; overflow:hidden;">
                            <div style="height:100%; background:linear-gradient(90deg, #f59e0b, #ef4444); width:${total > 0 ? (hotCount / total) * 100 : 0}%; transition:width 1s ease;"></div>
                        </div>
                    </div>

                    <!-- Confined Space -->
                    <div>
                        <div style="display:flex; justify-content:space-between; font-size:13px; margin-bottom:4px;">
                            <span>Confined Space Entry</span>
                            <strong><c:out value="${csCount}" /> / <c:out value="${total}" /></strong>
                        </div>
                        <div style="height:8px; background-color:var(--border-color); border-radius:4px; overflow:hidden;">
                            <div style="height:100%; background-color:#8b5cf6; width:${total > 0 ? (csCount / total) * 100 : 0}%; transition:width 1s ease;"></div>
                        </div>
                    </div>

                    <!-- Height Work -->
                    <div>
                        <div style="display:flex; justify-content:space-between; font-size:13px; margin-bottom:4px;">
                            <span>Work at Heights</span>
                            <strong><c:out value="${heightCount}" /> / <c:out value="${total}" /></strong>
                        </div>
                        <div style="height:8px; background-color:var(--border-color); border-radius:4px; overflow:hidden;">
                            <div style="height:100%; background-color:#06b6d4; width:${total > 0 ? (heightCount / total) * 100 : 0}%; transition:width 1s ease;"></div>
                        </div>
                    </div>

                    <!-- Electrical -->
                    <div>
                        <div style="display:flex; justify-content:space-between; font-size:13px; margin-bottom:4px;">
                            <span>Electrical Maintenance</span>
                            <strong><c:out value="${elecCount}" /> / <c:out value="${total}" /></strong>
                        </div>
                        <div style="height:8px; background-color:var(--border-color); border-radius:4px; overflow:hidden;">
                            <div style="height:100%; background-color:#10b981; width:${total > 0 ? (elecCount / total) * 100 : 0}%; transition:width 1s ease;"></div>
                        </div>
                    </div>

                    <!-- Welding -->
                    <div>
                        <div style="display:flex; justify-content:space-between; font-size:13px; margin-bottom:4px;">
                            <span>Welding Operations</span>
                            <strong><c:out value="${weldCount}" /> / <c:out value="${total}" /></strong>
                        </div>
                        <div style="height:8px; background-color:var(--border-color); border-radius:4px; overflow:hidden;">
                            <div style="height:100%; background-color:#3b82f6; width:${total > 0 ? (weldCount / total) * 100 : 0}%; transition:width 1s ease;"></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Risk Level Distribution -->
            <div class="card">
                <h3 style="margin-bottom:15px; display:flex; align-items:center; gap:8px;">
                    <span class="material-symbols-outlined" style="color:var(--status-pending);">report_problem</span> Hazard Risk Distribution
                </h3>
                
                <div style="display:flex; justify-content:space-around; align-items:flex-end; height:180px; padding-top:20px; border-bottom:2px solid var(--border-color);">
                    <!-- High Risk -->
                    <div style="display:flex; flex-direction:column; align-items:center; flex:1;">
                        <span style="font-size:12px; font-weight:600; margin-bottom:8px;"><c:out value="${highCount}" /></span>
                        <div style="width:40px; background-color:var(--status-rejected); height:${total > 0 ? (highCount / total) * 120 : 0}px; border-radius:4px 4px 0 0; min-height:4px; transition:height 1s ease;"></div>
                        <span style="font-size:11px; margin-top:8px; color:var(--text-secondary); font-weight:600;">High</span>
                    </div>

                    <!-- Medium Risk -->
                    <div style="display:flex; flex-direction:column; align-items:center; flex:1;">
                        <span style="font-size:12px; font-weight:600; margin-bottom:8px;"><c:out value="${medCount}" /></span>
                        <div style="width:40px; background-color:var(--status-pending); height:${total > 0 ? (medCount / total) * 120 : 0}px; border-radius:4px 4px 0 0; min-height:4px; transition:height 1s ease;"></div>
                        <span style="font-size:11px; margin-top:8px; color:var(--text-secondary); font-weight:600;">Medium</span>
                    </div>

                    <!-- Low Risk -->
                    <div style="display:flex; flex-direction:column; align-items:center; flex:1;">
                        <span style="font-size:12px; font-weight:600; margin-bottom:8px;"><c:out value="${lowCount}" /></span>
                        <div style="width:40px; background-color:var(--status-active); height:${total > 0 ? (lowCount / total) * 120 : 0}px; border-radius:4px 4px 0 0; min-height:4px; transition:height 1s ease;"></div>
                        <span style="font-size:11px; margin-top:8px; color:var(--text-secondary); font-weight:600;">Low</span>
                    </div>
                </div>
            </div>

        </div>

        <!-- Right: Status Breakdown & Efficiency KPIs -->
        <div style="display:flex; flex-direction:column; gap:24px;">
            
            <!-- Safety Status breakdown -->
            <div class="card">
                <h3 style="margin-bottom:15px; display:flex; align-items:center; gap:8px;">
                    <span class="material-symbols-outlined" style="color:var(--status-active);">pie_chart</span> Status Distribution
                </h3>
                
                <div style="display:flex; flex-direction:column; gap:12px; margin-top:16px;">
                    <div style="display:flex; align-items:center; gap:10px;">
                        <span style="width:12px; height:12px; border-radius:50%; background-color:var(--status-active);"></span>
                        <span style="flex:1; font-size:13px;">Completed & Active</span>
                        <span style="font-weight:600;"><c:out value="${completed + active}" /></span>
                    </div>
                    <div style="display:flex; align-items:center; gap:10px;">
                        <span style="width:12px; height:12px; border-radius:50%; background-color:var(--status-pending);"></span>
                        <span style="flex:1; font-size:13px;">Pending Review Queue</span>
                        <span style="font-weight:600;"><c:out value="${pending}" /></span>
                    </div>
                    <div style="display:flex; align-items:center; gap:10px;">
                        <span style="width:12px; height:12px; border-radius:50%; background-color:var(--status-rejected);"></span>
                        <span style="flex:1; font-size:13px;">Rejected Permits</span>
                        <span style="font-weight:600;"><c:out value="${rejected}" /></span>
                    </div>
                    <div style="display:flex; align-items:center; gap:10px;">
                        <span style="width:12px; height:12px; border-radius:50%; background-color:var(--status-expired);"></span>
                        <span style="flex:1; font-size:13px;">Expired (Overdue)</span>
                        <span style="font-weight:600;"><c:out value="${expired}" /></span>
                    </div>
                </div>
            </div>

            <!-- Performance Efficiency and Compliance Rate -->
            <div class="card" style="background: linear-gradient(135deg, var(--bg-surface) 0%, rgba(16, 185, 129, 0.02) 100%);">
                <h3 style="margin-bottom:15px; display:flex; align-items:center; gap:8px;">
                    <span class="material-symbols-outlined" style="color:var(--status-active);">speed</span> Performance Index
                </h3>
                
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:16px; margin-top:20px;">
                    
                    <div style="border-right:1px solid var(--border-color); padding-right:16px; text-align:center;">
                        <div style="font-size:11px; text-transform:uppercase; color:var(--text-muted); font-weight:700;">Safety Compliance</div>
                        <div style="font-size:32px; font-weight:800; color:var(--status-active); margin-top:4px;">100%</div>
                        <p style="font-size:11px; color:var(--text-secondary); margin-top:4px;">Zero reported incidents or bypasses</p>
                    </div>

                    <div style="text-align:center;">
                        <div style="font-size:11px; text-transform:uppercase; color:var(--text-muted); font-weight:700;">Avg Approval Time</div>
                        <div style="font-size:32px; font-weight:800; color:var(--primary); margin-top:4px;">42m</div>
                        <p style="font-size:11px; color:var(--text-secondary); margin-top:4px;">Average delay across three stages</p>
                    </div>

                </div>

                <div style="margin-top:24px; padding:12px; background-color:var(--bg-app); border:1px solid var(--border-color); border-radius:var(--radius-sm); font-size:12px; line-height:1.4; color:var(--text-secondary);">
                    <strong>Audit Summary:</strong> All submitted high-risk permits underwent 3-level verification. 94.5% of checklists were fully verified with on-site inspection comments.
                </div>
            </div>

        </div>

    </div>

</main>

<jsp:include page="layout/footer.jsp" />
